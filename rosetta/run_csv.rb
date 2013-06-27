#!/opt/local/bin/ruby

require 'rubygems'
require 'neography'
require './helper'
require 'csv'

# these are the default values:


puts "hi"

# This code will only execute if this file is the file
# being run from the command line.
if $0 == __FILE__



  @h = Helper.new
  @h.setup
  @neo = @h.neo

  CSV.foreach("out.csv") do |row|
    word1 = row[0]
    word2 = row[1]
    mark_id = row[2]
    begin
      puts "#{word1}, #{word2}"
      @h.save_pair(word1,word2, mark_id)
    rescue 
      
    end  
  

  end

end






