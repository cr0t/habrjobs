require 'rubygems'
require 'mongo'
require 'open-uri'
require 'hpricot'
require 'htmlentities'

db = Mongo::Connection.new.db('habr')
jobs_collection = db['habr_jobs']

(1..3).each do | pagenum |
  doc = Hpricot(open('http://habrahabr.ru/job/page' + pagenum.to_s))
  
  jobTable = doc.search('#job-items')
  jobs = jobTable.search('tr')
  
  jobs.each do | job |
    url = job.at('a')[:href] rescue nil
    id = url.match(/\d{1,}/)[0] rescue nil
    date = job.search('.date-th').inner_text.strip
    title = job.search('.title-td').inner_text.strip
    money = job.search('.money-td').inner_text.strip
    money_num = job.search('.money-td').inner_text.strip.match(/\d{1,} \d{1,}/)[0].gsub(/\s/, '').to_i rescue nil
    region = job.search('.region-td').inner_text.strip.gsub(/[\t\r\n]/, ' ')
    
    #check if we already have this vacancy in our database
    already_have = jobs_collection.find('job_id' => id).count()
    
    if date != '' && already_have === 0 then
      jobs_collection.insert({
        'job_id' => id,
        'date' => date,
        'title' => title,
        'money' => money,
        'money_num' => money_num,
        'region' => region,
        'url' => url,
      })
     # print '+ '
    else
     # print '0 '
    end
  end
end

#just little end of out little script - new line
#puts 

#data = jobs_collection.find('job_id' => '1748').count()
#puts data
