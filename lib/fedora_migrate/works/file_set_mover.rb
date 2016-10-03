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
        end
      end
    end
  end
end