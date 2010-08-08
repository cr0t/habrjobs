require 'rubygems'
require 'sinatra'
require 'mongo'
require 'active_support'

DEFAULT_LIMIT = 40

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

get '/robots.txt' do
  "User-agent: *\nAllow: /"
end

# XML feed
get '/feed.xml' do
	@jobs = jobs_collection.find().sort(:job_id, -1).to_a[0...15]
	builder :feed
end

# MAIN PAGE
get '/' do
	@jobs = jobs_collection.find().sort(:job_id, -1).limit(DEFAULT_LIMIT).to_a
	erb :job_list
end

# LIMIT FOR THE NUMBER OF JOBS
get '/:limit' do
  lim = params[:limit].to_i
  @jobs = jobs_collection.find().sort(:job_id, -1).limit(lim).to_a
	erb :job_list
end

# SORTED BY SALARY (MONEY_NUM)
get '/salary/topfirst' do
  @jobs = jobs_collection.find().sort(:money_num, -1).to_a
	erb :job_list
end

# SEARCH ACTION
post '/search' do
  phrase = params[:word]
  @jobs = jobs_collection.find(:title => /.*#{phrase}.*/i).sort(:job_id, -1).to_a
#  params[:word].inspect
	erb :job_list
end

=begin
Общий случай для сортировки
get '/:sort/:direction' do
	@jobs = jobs_collection.find().sort(params[:sort], params[:direction]).to_a
	erb :job_list
end
=end
