# Guard::Sprockets

[![Gem Version](https://img.shields.io/gem/v/guard-sprockets.svg?style=flat)](https://rubygems.org/gems/guard-sprockets) [![Build Status](https://travis-ci.org/guard/guard-sprockets.png?branch=master)](https://travis-ci.org/guard/guard-sprockets) [![Dependency Status](https://gemnasium.com/guard/guard-sprockets.png)](https://gemnasium.com/guard/guard-sprockets) [![Code Climate](https://codeclimate.com/github/guard/guard-sprockets.png)](https://codeclimate.com/github/guard/guard-sprockets) [![Test Coverage](https://codeclimate.com/github/guard/guard-sprockets/badges/coverage.svg)](https://codeclimate.com/github/guard/guard-sprockets)

Sprockets guard automatically packages your JavaScript files together when your source files are saved.

* Compatible with Sprockets 2.x (for Sprockets 1.x compatibility, please use Guard::Sprockets 0.1.4 or the `sprockets_1` branch).
* Tested against Ruby 2.0, 2.1, 2.2, Rubinius & JRuby (1.9 mode only).

## Install

Please be sure to have [Guard](https://github.com/guard/guard) installed before continue.

Install the gem:

```bash
$ gem install guard-sprockets
```

Add it to your Gemfile (inside the `:tools` group for instance):

```ruby
group :development do
  gem 'guard-sprockets'
end
```

Add guard definition to your Guardfile by running this command:

```bash
$ guard init sprockets
```

## Usage

Please read [Guard usage doc](https://github.com/guard/guard#readme)

## Guardfile

Guard::Sprockets can be adapted to all kind of projects.

### Typical Rails 3 app (default generated Guardfile)

```ruby
guard :sprockets, destination: 'public/javascripts', asset_paths: ['/app/assets/javascripts'] do
  watch 'app/assets/javascripts/application.js'
end
```

Please read [Guard doc](https://github.com/guard/guard#readme) for more information about the Guardfile DSL.

## Options

```ruby
destination: 'public/js'          # change the destination folder in which the compiled assets are saved, default: 'public/javascripts'
asset_paths: 'app/js'             # add a directory (or on array of directories) to Sprockets' environment's load path, default: ['app/assets/javascripts']
asset_paths: ['app/js', 'lib/js'] # asset_paths can be a String or an Array
js_minify: true                   # minify the JavaScript files content using Uglifier. You can pass true, false, or an Uglifier options hash. default: false
                                  # be sure to add: "gem 'uglifier'" in your Gemfile
css_minify: true                  # minify the CSS files content using YUI Compressor, default: false
                                  # be sure to add: "gem 'yui-compressor'" in your Gemfile
keep_paths: true                  # retain the directory structure of an asset's path relative to the asset_path, default: false
                                  # this prevents assets with the same basename, but placed different folders, from overwriting each other in the destination folder
                                  # e.x. with this option set to true: app/js/vendor/rails/turbolinks.js.coffee -> public/js/vendor/rails/turbolinks.js
                                  # and with this option set to false: app/js/vendor/rails/turbolinks.js.coffee -> public/js/turbolinks.js
root_file: 'app/js/app.js'        # if set, only this file will be compiled, default: nil
root_file: ['one.js', 'two.js']   # root_file can be a String or an Array
```

## Development

* Documentation hosted at [RubyDoc](http://rubydoc.info/gems/guard-sprockets/frames).
* Source hosted at [GitHub](https://github.com/guard/guard-sprockets).

Pull requests are very welcome! Please try to follow these simple rules if applicable:

* Please create a topic branch for every separate change you make.
* Make sure your patches are well tested. All specs must pass on [Travis CI](https://travis-ci.org/guard/guard-sprockets).
* Update the [Yard](http://yardoc.org/) documentation.
* Update the [README](https://github.com/guard/guard-sprockets/blob/master/README.md).
* Please **do not change** the version number.

For questions please join us in our [Google group](http://groups.google.com/group/guard-dev) or on
`#guard` (irc.freenode.net).

## Author

[Aaron Cruz](https://github.com/pferdefleisch) ([@mraaroncruz](http://twitter.com/mraaroncruz), [aaroncruz.com](http://aaroncruz.com))

## Maintainer

[Rémy Coutable](https://github.com/rymai)

## Contributors

[https://github.com/guard/guard-sprockets/graphs/contributors](https://github.com/guard/guard-sprockets/graphs/contributors)
