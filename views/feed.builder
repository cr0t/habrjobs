xml.instruct!
xml.rss "version" => "2.0", "xmlns:atom" => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.title "HabrJobs"
    xml.link "http://habrjobs.summercode.ru/"
    xml.pubDate CGI::rfc1123_date Time.parse(@jobs.first["date"]) if @jobs.any?
    xml.description "Habrahabr.ru Jobs Feed"
    @jobs.each do |item|
      xml.item do
        xml.tag!('title', item['title'] + ' ' + item['money_num'].to_s + ' (' + item['money'] + ')')
        xml.tag!('link', item['url'])
        xml.tag!('description', item['region'])
      end
    end
  end
end
