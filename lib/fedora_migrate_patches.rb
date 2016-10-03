# monkey patches for FedoraMigrate to work with CurationConcerns and Hydra 10
require "fedora-migrate"
module FedoraMigrate
  # monkeypatch FedoraMigrate::RelsExtDatastreamMover to use RDF 2 supported statement loading methods
  class RelsExtDatastreamMover
    def migrate
      migrate_statements
      save
      update_index
      super
    end
    private
    def graph
      @graph ||= RDF::Graph.new do |graph|
        RDF::Reader.for(:rdfxml).new(StringIO.new(source.datastreams[RELS_EXT_DATASTREAM].content)) do |reader|
          reader.each_statement {|statement| graph << statement }
        end
      end
    end
  end
  autoload :Tasks, 'fedora_migrate/tasks'
end
