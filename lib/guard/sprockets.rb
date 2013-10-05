require 'guard'
require 'guard/plugin'

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

      if @options.delete(:minify)
        begin
          require 'uglifier'
          @sprockets.js_compressor = ::Uglifier.new
          UI.info 'Sprockets will compress output.'
        rescue LoadError => ex
          UI.error "minify: Uglifier cannot be loaded. No compression will be used.\nPlease include 'uglifier' in your Gemfile."
          UI.debug ex.message
        end
      end
    end

    def start
       UI.info 'Guard::Sprockets is ready and waiting for some file changes...'
       UI.debug "Guard::Sprockets.asset_paths = #{@asset_paths.inspect}" unless @asset_paths.empty?
       UI.debug "Guard::Sprockets.destination = #{@destination.inspect}"

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

      UI.info "Sprockets will compile #{output_filename}"

      FileUtils.mkdir_p(output_path.parent) unless output_path.parent.exist?
      output_path.open('w') do |f|
        f.write @sprockets[output_filename]
      end

      UI.info "Sprockets compiled #{output_filename}"
      Notifier.notify "Sprockets compiled #{output_filename}"
    rescue ExecJS::ProgramError => ex
      UI.error "Sprockets failed compiling #{output_filename}"
      UI.error ex.message
      Notifier.notify "Sprockets failed compiling #{output_filename}!", priority: 2, image: :failed

      false
    end

    def without_preprocessor_extension(filename)
      filename.gsub(/^(.*\.(?:js|css))\.[^.]+(\.erb)?$/, '\1')
    end
  end
end
