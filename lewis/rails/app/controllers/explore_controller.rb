require 'uri'
class ExploreController < ApplicationController

	def index
		@query = params[:query]
		@clusters = get_clusters(@query)

		if @clusters
			@clusters.each do |cluster|
				begin
					mark_names = get_marks_for_ids(cluster["docs"])
					cluster["mark_names"] = mark_names
				rescue
				end
			end
		end

	end


	def flare
		@query = params[:query]
		clusters = get_clusters(@query)

		flare_hash = {:name => "flare"}

		myclusters = []
		#
		clusters.each do |cluster|
			puts cluster
			myclusters << {:name => cluster["labels"].first.to_s, :size => cluster["docs"].size}
		end

		flare_hash[:children] = myclusters

		render :json => flare_hash

	end


	def get_marks_for_ids(ids)
		query = "id:("

		ids.each {|id| query = query + id + " "}
		
		query = query + ")"
		query = URI::encode(query)
		response = HTTParty.get("http://rosetta.bloom.sh:8983/solr/trademarks/select?q=#{query}&fl=MarkIdentification,id&q.op=OR&&wt=json")

			
		result = JSON.parse(response.body)['response']['docs']
			
	end

	def get_clusters(query)
		

		unless query.blank?
			query = query.upcase
			rows = 1000
			response = HTTParty.get("http://rosetta.bloom.sh:8983/solr/clustering?echoParams=ALL&carrot.snippet=code_text&qf=code_text&q=code_text:#{URI::encode(query)}&clustering.collection=true&rows=#{rows}&carrot.title=code_text&fl=code_text,id&wt=json")

			
			clusters = JSON.parse(response.body)['clusters']
			return clusters
			#puts response.code
			#puts response.message
			#puts response.headers.inspect

			#response.each do |item|
			#  puts item
			#end
		end

	end
end
