module FedoraMigrate::Hooks

  # @source is a Rubydora object
  # @target is a modern Hydra/ActiveFedora modeled object

  # Called from FedoraMigrate::ObjectMover
  def before_object_migration
    # additional actions as needed
    # make sure migrated objects will validate
    if target.is_a? Hydra::WithDepositor
      depositor = source.ownerId.blank? ? "fedoraAdmin" : source.ownerId
      target.apply_depositor_metadata(depositor)
    end

    # migrate legacy properties
    if source.state
      case source.state
      when 'D'
        target.legacy_state = ActiveFedora::RDF::Fcrepo::Model.Deleted
      when 'I'
        target.legacy_state = ActiveFedora::RDF::Fcrepo::Model.Inactive
      else
        target.legacy_state = ActiveFedora::RDF::Fcrepo::Model.Active
      end
    end
    target.legacy_pid = source.pid
    target.read_groups = ['public']
  end

  # Called from FedoraMigrate::ObjectMover
  def after_object_migration
    # additional actions as needed
  end

  # Called from FedoraMigrate::RDFDatastreamMover
  def before_rdf_datastream_migration
    # additional actions as needed
  end

  # Called from FedoraMigrate::RDFDatastreamMover
  def after_rdf_datastream_migration
    # additional actions as needed
    resource = target.resource
    subject = resource.rdf_subject
    resource.query(subject: subject, predicate: RDF::Vocab::DC.creator) do |statement|
      mod = statement.clone
      mod.predicate = ::RDF::Vocab::DC11.creator
      resource.delete_statement statement
      resource.insert_statement mod
    end
    resource.query(subject: subject, predicate: RDF::Vocab::DC.publisher) do |statement|
      mod = statement.clone
      mod.predicate = ::RDF::Vocab::DC11.publisher
      resource.delete_statement statement
      resource.insert_statement mod
    end
  end

  # Called from FedoraMigrate::DatastreamMover
  def before_datastream_migration
    # additional actions as needed
  end

  # Called from FedoraMigrate::DatastreamMover
  def after_datastream_migration
    # additional actions as needed
  end

  # Called from patched ObjectMover
  def before_content_datastreams
    # additional actions as needed
    # make sure migrated objects will validate
    if target.has_attribute? :title
      target.title ||= []
      target.title << source.label if target.title.empty?
    end
  end

  def after_content_datastreams
    # additional actions as needed
  end
end

require 'fedora_migrate_patches'

desc "Delete all the content in Fedora 4"
task clean: :environment do
  ActiveFedora::Cleaner.clean!
end
desc "Run my migrations"
task migrate: :environment do
  ## We're not going to use the namespace filtered repository migration for this workshop
  # report = FedoraMigrate.migrate_repository(namespace: "usna",options:{})
  asset_map = YAML.load(open("#{Rails.root}/config/fixtures.yml"))
  assets = asset_map[:'1667751']
  subreports = []
  assets[:generic_files].each do |pid|
    subreports << FedoraMigrate::Tasks.migrate_file_set(pid, reload: true)
  end
  assets[:admin_sets].each do |pid|
    subreports << FedoraMigrate::Tasks.migrate_administrative_set(pid, reload: true)
  end
  assets[:pages].each do |pid|
    subreports << FedoraMigrate::Tasks.migrate_work(pid, reload: true, convert: 'descMetadata')
  end
  assets[:works].each do |pid|
    subreports << FedoraMigrate::Tasks.migrate_work(pid, reload: true, convert: 'descMetadata')
  end
  assets[:collections].each do |pid|
    subreports << FedoraMigrate::Tasks.migrate_collection(pid, reload: true, convert: 'descMetadata')
  end
  subreports.compact!
  report = FedoraMigrate::MigrationReport.new
  subreports.each {|subreport| report.results.merge! subreport.results }
  report.report_failures STDOUT
end
