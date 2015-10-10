#!/usr/bin/env ruby

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'
agent.robots = false

base_url = "http://modules.ussquash.com/ssm/pages/leagues/League_Information.asp?action=league&a=3&leagueid=1263"

results = CSV.open("csv/teams.csv","w")

begin
  page = agent.get(base_url)
rescue
  print "  -> error, retrying\n"
  retry
end

path='//*[@id="corebody"]/table[2]/tr'

page.parser.xpath(path).each_with_index do |tr,i|
  row = []
  tr.xpath("td").each_with_index do |td,j|
    case j
    when 0,1
      a = td.xpath("a").first
      text = a.text.strip
      href = a.attribute("href").text.strip
      id = href.split("=")[1].to_i
      url = URI.join(base_url, href).to_s
      row += [text, url, id]
    else
      row += [td.text.strip]
    end
  end
  results << row
end

results.close
