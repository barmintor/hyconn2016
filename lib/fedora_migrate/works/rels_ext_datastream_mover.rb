module FedoraMigrate
  module Works
    class RelsExtDatastreamMover < FedoraMigrate::RelsExtDatastreamMover
      def missing_object?(statement)
        return !ActiveFedora::Base.exists?(id_component(statement.object))
      end
      # All the graph statements except hasModel, hasMember and those with missing objects
      def statements
        graph.statements.reject do |stmt|
          reject = (stmt.predicate == ActiveFedora::RDF::Fcrepo::Model.hasModel)
          reject ||= (stmt.predicate == Hydra::PCDM::Vocab::PCDMTerms.hasMember)
          reject ||= missing_object?(stmt)
        end
      end
    end
  end
end