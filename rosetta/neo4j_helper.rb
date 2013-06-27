class Helper

	attr_accessor :neo

	def find_word(word)
		word = word.upcase
		nodes = @neo.get_node_index("node_auto_index", "word", word)
		if nodes.nil? or nodes.empty?
			node = @neo.create_node("word" => word)
			#@neo.add_node_to_index("words", "word", word, node)
		else
			node_hash = nodes.first
			node_url = node_hash["self"]
			node = @neo.get_node(node_url)			
		end
		return node
	end


	def find_mark(mark_id)
		mark_id = mark_id.upcase
		nodes = @neo.get_node_index("node_auto_index", "mark_id", mark_id)
	
		if nodes.nil? or nodes.empty?
			node = @neo.create_node("mark_id" => mark_id)
			#@neo.add_node_to_index("words", "word", word, node)
		else
			node_hash = nodes.first
			node_url = node_hash["self"]
			node = @neo.get_node(node_url)			
		end
		return node
	end

	def find_relationship(node, node2)
		word1 = node["data"]["word"].upcase
		word2 = node2["data"]["word"].upcase
		
		rels = @neo.execute_query('start n1=node:node_auto_index(word={word1}), n2=node:node_auto_index(word={word2}) match n1-[r]-(n2) return r;', {:word1 => word1, :word2 => word2})
		
		if rels["data"].empty?
			rel = neo.create_relationship("translation", node, node2, {:count => 1})   
		else
			rel_url = rels['data'].first.first["self"]
			rel = neo.get_relationship(rel_url) 
		end

		return rel
	end

	def find_relationship_mark(node, mark)
		word1 = node["data"]["word"].upcase
		mark_id = mark["data"]["mark_id"].upcase
		
		rels = @neo.execute_query('start n1=node:node_auto_index(word={word1}), n2=node:node_auto_index(mark_id={mark_id}) match n1-[r]-(n2) return r;', {:word1 => word1, :mark_id => mark_id})

		if rels["data"].empty?
			rel = neo.create_relationship("contains", node, mark)   
		else
			rel_url = rels['data'].first.first["self"]
			rel = neo.get_relationship(rel_url) 
		end

		return rel
	end	

	def increment_rel(rel)
		count = rel["data"]["count"]
		
		if count.nil?
			count = 0
		end
		@neo.set_relationship_properties(rel, {"count" => count + 1})
	end

	def setup
		Neography.configure do |config|
		  config.protocol       = "http://"
		  config.server         = "ec2-50-19-204-17.compute-1.amazonaws.com"
		  config.port           = 7474
		  config.directory      = ""  # prefix this path with '/' 
		  config.cypher_path    = "/cypher"
		  config.gremlin_path   = "/ext/GremlinPlugin/graphdb/execute_script"
		  config.log_file       = "neography.log"
		  config.log_enabled    = true
		  config.max_threads    = 20
		  config.authentication = nil  # 'basic' or 'digest'
		  config.username       = nil
		  config.password       = nil
		  config.parser         = MultiJsonParser
		end

		@neo = Neography::Rest.new


	end

	def save_pair(word1, word2, mark_id)
	  node = find_word(word1)
	  node2 = find_word(word2)

	  mark = find_mark(mark_id)

	  rel = find_relationship(node, node2)
	  increment_rel(rel)

	  rel = find_relationship_mark(node, mark)
	  rel = find_relationship_mark(node2, mark)

	end



end
