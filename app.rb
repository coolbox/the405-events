require 'rubygems'
require 'sinatra'
require 'haml'
require 'mongo'
require 'uri'
require 'mongoid'
require 'json'

module Giglist
  class Gig
    include Mongoid::Document
 
    field :title, type: String
    field :date_time, type: Date
    field :price, type: String
    field :venue, type: String
    field :url, type: String

    attr_accessible :title,
                    :date_time,
                    :price,
                    :venue,
                    :url
  end

  class App < Sinatra::Application
    configure do
      enable :sessions, :logging, :dump_errors

      # set :root, File.dirname(__FILE__)
      # logger = Logger.new($stdout)
  
      Mongoid.load!("config/mongoid.yml")
    end

    helpers do
      # Basic auth
      def protected!
        return if authorized?
        headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
        halt 401, "Not authorized\n"
      end

      def authorized?
        @auth ||=  Rack::Auth::Basic::Request.new(request.env)
        @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['pete', 'roome']
      end
      # End of basic auth
    end

    get '/' do
      @gigs = Gig.order_by(:date_time.desc)
      haml :index
    end

    get '/admin' do
      protected!
      @gigs = Gig.all
      haml :admin
    end

    get '/edit/:id' do |id|
      @gig = Gig.find(id)
      haml :edit
    end

    put '/update/:id' do
      @gig = Gig.find(params[:id])
      if @gig.update_attributes(params[:gig])
        redirect '/admin'
      else
        "Error saving doc"
      end
    end

    post '/gig' do
      @gig = Gig.new(params[:gig])
      
      if @gig.save
        redirect '/admin'
      else
        "Error saving doc"
      end
    end

    delete '/gig/:id' do
      @gig = Gig.find(params[:id])
      @gig.delete
      redirect '/admin'   
    end
  end
end