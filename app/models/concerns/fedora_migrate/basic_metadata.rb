module FedoraMigrate::BasicMetadata
  extend ActiveSupport::Concern
  included do
		self.property :format, predicate: ::RDF::Vocab::DC.format do |index|
      index.as :stored_searchable, :facetable
    end
  end
end