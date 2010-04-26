require 'rubygems'
require 'sinatra'
require 'mongo'
require 'active_support'

class Integer
  def odd
      self & 1 != 0
   end
  def even
      self & 1 == 0
  end
end

db = Mongo::Connection.new.db('habr')
jobs_collection = db['habr_jobs']

get '/' do
	@jobs = jobs_collection.find().sort(:job_id, -1).to_a
	erb :index
end

get '/:sort/:direction' do
	@jobs = jobs_collection.find().sort(params[:sort], params[:direction]).to_a
	erb :index
end

get '/feed.xml' do
	@jobs = jobs_collection.find().sort(:job_id, -1).to_a
	builder :feed
end
