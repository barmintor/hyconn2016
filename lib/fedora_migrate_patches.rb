# monkey patches for FedoraMigrate to work with CurationConcerns and Hydra 10
require "fedora-migrate"
module FedoraMigrate
  # monketpatch FedoraMigrate::ObjectMover to call hooks around migrate_content_datastreams
  class ObjectMover
    private
    def migrate_datastreams
      before_content_datastreams
      migrate_content_datastreams
      after_content_datastreams
      migrate_permissions
      migrate_dates
    end
  end
  class RDFDatastreamMover
    private
    def updated_datastream_content
      _content = correct_encoding(datastream_content)
      _content.gsub!(/<.+#{source.pid}>/, "<#{target.uri}>")
      _content.gsub!(/<>/, "<#{target.uri}>")
      _content
    end
  end
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
  # monkeypatch FedoraMigrate::TargetConstructor to swap FileSet for GenericFile
  class TargetConstructor
    private
    def target
      @target ||= begin 
        _target = nil
        candidates.each do |model|
          _target ||= FedoraMigrate::Mover.id_component(model).eql?("GenericFile") ? FileSet : nil
        end
        _target
      end
      @target ||= determine_target
    end
  end
  autoload :Tasks, 'fedora_migrate/tasks'
end
