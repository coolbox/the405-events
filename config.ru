require 'rubygems'
require 'bundler'
require 'bundler/setup'
Bundler.require(:default)
require 'haml'
require 'sass/plugin/rack'
require './app.rb'

# use scss for stylesheets
Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack

# use coffeescript for javascript
use Rack::Coffee, root: 'public', urls: '/javascripts'

run Giftlist::App