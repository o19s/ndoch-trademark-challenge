#!/opt/local/bin/ruby

require 'rubygems'
require 'neography'
require './neo4j_helper'
require 'csv'

# There are 93112 entries in extracted_tr_statements.csv.  Be prepared to wait a long while.

if $0 == __FILE__


  @h = Helper.new
  @h.setup
  @neo = @h.neo
  counter = 0
  CSV.foreach("extracted_tr_statements.csv") do |row|
    word1 = row[0]
    word2 = row[1]
    mark_id = row[2]
    begin
      #puts "#{word1}, #{word2}"
      print "#{counter} " if (counter % 100 == 0)

      @h.save_pair(word1,word2, mark_id)
    rescue 
      
    end  
    counter = counter + 1
  end
end






