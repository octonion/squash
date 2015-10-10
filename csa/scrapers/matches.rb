#!/usr/bin/env ruby

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'
agent.robots = false

header_path = '//*[@id="corebody"]/table[3]/thead/tr/th'
schedule_path = '//*[@id="corebody"]/table[3]/tr'

teams = CSV.open("csv/teams.csv","r")
matches = CSV.open("csv/matches.csv","w")

teams.each do |team|

  team_name = team[0]
  team_url = team[1]
  team_id = team[2]

  print "#{team_name} - "

  begin
    page = agent.get(team_url)
  rescue
    print "  -> error, retrying\n"
    retry
  end

  header = []
  page.parser.xpath(header_path).each do |th|
    header += [th.text.strip]
  end

  if (header[2]=="Time")
    offset = 1
  else
    offset = 0
  end

  found = 0
  page.parser.xpath(schedule_path).each_with_index do |tr,i|
    row = [team_name, team_id]
    tr.xpath("td").each_with_index do |td,j|

      if (offset==1) and (j==2)
        next
      end
      
      case j
      when 1,2+offset
        a = td.xpath("a").first
        text = a.text.strip rescue nil
        href = a.attribute("href").text.strip rescue nil
        id = href.split("=")[1].to_i rescue nil
        url = URI.join(team_url, href).to_s rescue nil
        row += [text, url, id]
      when 4+offset
        text = td.text.strip rescue nil
        if (text=='-')
          row += [nil, nil, nil, nil]
        else
          outcome = text.split(" ")[0].strip
          score = text.split(" ")[1].strip
          scores = score.split("-")
          team_score = scores[0].to_i
          opponent_score = scores[1].to_i
          row += [outcome, score, team_score, opponent_score]
        end
      else
        row += [td.text.strip]
      end
    end

    if (row.size > 3)
      matches << row
    end
    found += 1
  end

  matches.flush
  print "found #{found}\n"

end

matches.close
