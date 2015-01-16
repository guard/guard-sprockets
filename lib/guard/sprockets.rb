require 'guard/compat/plugin'

require 'sprockets'
require 'execjs'

module Guard
  class Sprockets < Plugin

    attr_reader :asset_paths, :destination, :root_file, :sprockets

    def initialize(options = {})
      super

      @options     = options
      @asset_paths = Array(@options[:asset_paths] || 'app/assets/javascripts')
      @destination = @options[:destination] || 'public/javascripts'
      @root_file   = Array(@options[:root_file])
      @keep_paths  = @options[:keep_paths] || false

      @sprockets = ::Sprockets::Environment.new
      @asset_paths.each { |p| @sprockets.append_path(p) }
      @root_file.each { |f| @sprockets.append_path(Pathname.new(f).dirname) }

      if js_minify_option = @options[:js_minify] || @options[:minify]
        UI.warning 'DEPRECATION WARNING: The :minify option has been renamed to :js_minify. Please modify your Guardfile to use the :js_minify option instead.' if @options[:minify]
        begin
          require 'uglifier'
          @sprockets.js_compressor = ::Uglifier.new(js_minify_option.is_a?(Hash) ? js_minify_option : {})
          Compat::UI.info 'Sprockets will compress JavaScript output.'
        rescue LoadError => ex
          Compat::UI.error "js_minify: Uglifier cannot be loaded. No JavaScript compression will be used.\nPlease include 'uglifier' in your Gemfile."
          Compat::UI.debug ex.message
        end
      end

      if @options.delete(:css_minify)
        begin
          require 'yui/compressor'
          @sprockets.css_compressor = YUI::CssCompressor.new
          Compat::UI.info 'Sprockets will compress CSS output.'
        rescue LoadError => ex
          Compat::UI.error "minify: yui-compressor cannot be loaded. No CSS compression will be used.\nPlease include 'yui-compressor' in your Gemfile."
          Compat::UI.debug ex.message
        end
      end

    end

    def start
       Compat::UI.info 'Guard::Sprockets is ready and waiting for some file changes...'
       Compat::UI.debug "Guard::Sprockets.asset_paths = #{@asset_paths.inspect}" unless @asset_paths.empty?
       Compat::UI.debug "Guard::Sprockets.destination = #{@destination.inspect}"

       run_all
    end

    def run_all
      run_on_changes([])
    end

    def run_on_changes(paths)
      paths = @root_file unless @root_file.empty?

      success = true
      paths.each do |file|
        success &= sprocketize(file)
      end
      success
    end

    private

    def sprocketize(path)
      path = Pathname.new(path)

      output_filename = if @keep_paths
        # retain the relative directories of assets to the asset directory
        parent_paths = @asset_paths.find_all { |p| path.to_s.start_with?(p) }.collect { |p| Pathname.new(p) }
        relative_paths = parent_paths.collect { |p| path.relative_path_from(p) }
        relative_path = relative_paths.min_by { |p| p.to_s.size }

        without_preprocessor_extension(relative_path.to_s)
      else
        without_preprocessor_extension(path.basename.to_s)
      end

      output_path = Pathname.new(File.join(@destination, output_filename))

      Compat::UI.info "Sprockets will compile #{output_filename}"

      FileUtils.mkdir_p(output_path.parent) unless output_path.parent.exist?
      output_path.open('w') do |f|
        f.write @sprockets[output_filename]
      end

      Compat::UI.info "Sprockets compiled #{output_filename}"
      Compat::UI.notify "Sprockets compiled #{output_filename}"
    rescue ExecJS::ProgramError => ex
      Compat::UI.error "Sprockets failed compiling #{output_filename}"
      Compat::UI.error ex.message
      Compat::UI.notify "Sprockets failed compiling #{output_filename}!", priority: 2, image: :failed

      false
    end

    def without_preprocessor_extension(filename)
      filename.gsub(/^(.*\.(?:js|css))\.[^.]+(\.erb)?$/, '\1')
    end
  end
end
