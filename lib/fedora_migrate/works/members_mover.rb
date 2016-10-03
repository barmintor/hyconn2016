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
      def migrate_statements
        statements.each do |statement|
          target.members << migrate_object(statement.object)
        end
        target.save # so that we don't have an Etag mismatch on update_index
      end
    end
  end
end
