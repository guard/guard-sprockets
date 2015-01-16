require 'guard/compat/test/helper'

require 'guard/sprockets'

RSpec.describe Guard::Sprockets do
  before do
    allow(Guard::Compat::UI).to receive(:info)
    allow(Guard::Compat::UI).to receive(:error)
    allow(Guard::Compat::UI).to receive(:notify)
  end

  describe '.initialize' do
    describe 'options' do
      describe 'asset_paths' do
        it { expect(described_class.new.asset_paths).to eq ['app/assets/javascripts'] }
        it { expect(described_class.new(asset_paths: 'foo/bar').asset_paths).to eq ['foo/bar'] }
        it { expect(described_class.new(asset_paths: ['foo/bar']).asset_paths).to eq ['foo/bar'] }
      end

      describe 'destination' do
        it { expect(described_class.new.destination).to eq 'public/javascripts' }
        it { expect(described_class.new(destination: 'foo/bar').destination).to eq 'foo/bar' }
      end

      describe 'js_minify' do
        it { expect(described_class.new.sprockets.js_compressor).to be_nil }
        it { expect(described_class.new(js_minify: false).sprockets.js_compressor).to be_nil }
        it { expect(described_class.new(js_minify: true).sprockets.js_compressor).not_to be_nil }
        it { expect(described_class.new(js_minify: { mangle: false }).sprockets.js_compressor).not_to be_nil }
      end

      describe 'css_minify' do
        it { expect(described_class.new.sprockets.css_compressor).to be_nil }
        it { expect(described_class.new(css_minify: false).sprockets.css_compressor).to be_nil }
        it { expect(described_class.new(css_minify: true).sprockets.css_compressor).not_to be_nil }
      end

      describe 'root_file' do
        it { expect(described_class.new.root_file).to eq [] }
        it { expect(described_class.new(root_file: 'foo/bar').root_file).to eq ['foo/bar'] }
        it { expect(described_class.new(root_file: %w(a b c)).root_file).to eq %w(a b c) }
      end
    end
  end

  describe 'without_preprocessor_extension' do
    it { expect(subject.send(:without_preprocessor_extension, 'foo.js.coffee')).to eq 'foo.js' }
  end

  describe 'with ERB' do
    it { expect(subject.send(:without_preprocessor_extension, 'foo.js.coffee.erb')).to eq 'foo.js' }
  end

  describe 'run_on_change' do
    before do
      expect(subject.sprockets).to receive(:[]).and_raise ExecJS::ProgramError
    end
    after { FileUtils.rm_r('public') }

    it { expect(subject.run_on_changes(['foo'])).to be(false) }
  end

end
