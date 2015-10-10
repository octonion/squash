#!/usr/bin/env ruby

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'
agent.robots = false

outcome_path = '//*[@id="corebody"]/table[2]/tr[2]/td'
game_path = '//*[@id="corebody"]/table[4]/td'

matches = CSV.open("csv/matches.csv", "r")
match_outcomes = CSV.open("csv/match_outcomes.csv", "w")
match_games = CSV.open("csv/match_games.csv", "w")

matches.each do |match|

  team_name = match[0]
  team_id = match[1]
  opponent_name = match[6]
  opponent_id = match[8]

  match_url = match[4]
  match_id = match[5]

  if (match_url == nil)
    next
  end

  if (team_id>opponent_id)
    next
  end

  begin
    page = agent.get(match_url)
  rescue
    print "  -> error, retrying\n"
    retry
  end

  outcome = [match_id]
  page.parser.xpath(outcome_path).each_with_index do |td,i|
    case i
    when 1,3
      a = td.xpath("a").first
      text = a.text.strip rescue nil
      href = a.attribute("href").text.strip rescue nil
      id = href.split("=")[1].to_i rescue nil
      url = URI.join(match_url, href).to_s rescue nil
      outcome += [text, url, id]
    else
      outcome += [td.text.strip]
    end
  end
  match_outcomes << outcome

#  match_id = outcome[0].to_i
#  team_id = outcome[4]
#  opponent_id = outcome[8]

  found = 0
  i = 0
  row = []
  page.parser.xpath(game_path).each do |td|

    n = i/8
    j = i%8

    i += 1

    if (j==0)
      row = [match_id, team_id, team_name, opponent_id, opponent_name]
    end

    case j
    when 1,3
      if not(td.attribute("bgcolor")==nil)
        won = true
      else
        won = false
      end
      a = td.xpath("a").first
      text = a.text.strip rescue nil
      href = a.attribute("href").text.strip rescue nil
      id = href.split("=")[1].to_i rescue nil
      url = URI.join(match_url, href).to_s rescue nil
      row += [won, text, url, id]
#      when 4
#        text = td.text.strip rescue nil
#        if (text=='-')
#          row += [nil, nil, nil, nil]
#        else
#          outcome = text.split(" ")[0].strip
#          score = text.split(" ")[1].strip
#          scores = score.split("-")
#          team_score = scores[0].to_i
#          opponent_score = scores[1].to_i
#          row += [outcome, score, team_score, opponent_score]
#        end
    else
      row += [td.text.strip]
    end

    if (j==7)
      match_games << row
      found += 1
    end
    
  end
  match_outcomes.flush
  match_games.flush
  print "found #{found}\n"

end

match_outcomes.close
match_games.close
