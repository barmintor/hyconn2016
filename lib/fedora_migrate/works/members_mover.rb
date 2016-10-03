module FedoraMigrate
  module Works
    class MembersMover < FedoraMigrate::Works::RelsExtDatastreamMover
      # All the graph statements indicating membership of existing objects
      def statements
        graph.statements.reject do |s|
          (s.predicate != Hydra::PCDM::Vocab::PCDMTerms.hasMember) || missing_object?(s)
        end
      end
      def migrate_object(fc3_uri)
        ActiveFedora::Base.find(id_component(fc3_uri))
      end
      def structured_members
        structMetadata = source.datastreams['structMetadata']
        return [] if structMetadata.nil? || structMetadata.new?
        ns = {mets: "http://www.loc.gov/METS/"}
        structMetadata = Nokogiri::XML(structMetadata.content)
        members = {}
        structMetadata.xpath("/mets:structMap/mets:div", ns).each do |node|
          members[node["ORDER"]] = node["CONTENTIDS"]
        end
        sorted_keys = members.keys.sort {|a,b| a.to_i <=> b.to_i}
        sorted_keys.map { |key| members[key] }
      end
      def migrate_statements
        unordered_members = statements.collect { |statement| statement.object.to_s }
        ordered_members = structured_members & unordered_members
        unordered_members = unordered_members - structured_members
        ordered_members.each do |member|
          next unless ActiveFedora::Base.exists?(id_component(member))
          target.ordered_members << migrate_object(member)
        end
        unordered_members.each do |member|
          target.members << migrate_object(member)
        end
        target.save # so that we don't have an Etag mismatch on update_index
      end
    end
  end
end
