module FedoraMigrate
  module Works
    class FileSetMover < FedoraMigrate::ObjectMover
      def migrate_content_datastreams
        super
        if target.is_a?(FileSet) && (ds = source.datastreams['content'])
          ofile = target.files.build(type: ::RDF::URI('http://pcdm.org/use#OriginalFile'))
          mover = FedoraMigrate::DatastreamMover.new(ds, ofile, options)
          report.content_datastreams << ContentDatastreamReport.new(ds.dsid, mover.migrate)
          save
          filename = CurationConcerns::WorkingDirectory.find_or_retrieve(ofile.id, target.id, nil)
          Hydra::Works::CharacterizationService.run(target.original_file, filename)
          target.create_derivatives(filename)
        end
      end
    end
  end
end