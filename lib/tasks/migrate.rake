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
    if target.has_attribute? :title
      target.title ||= []
      target.title << source.label if target.title.empty?
    end
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
  end

  # Called from FedoraMigrate::DatastreamMover
  def before_datastream_migration
    # additional actions as needed
  end

  # Called from FedoraMigrate::DatastreamMover
  def after_datastream_migration
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
    subreports << FedoraMigrate::Tasks.migrate_work(pid, reload: true)
  end
  assets[:works].each do |pid|
    subreports << FedoraMigrate::Tasks.migrate_work(pid, reload: true)
  end
  assets[:collections].each do |pid|
    subreports << FedoraMigrate::Tasks.migrate_collection(pid, reload: true)
  end
  subreports.compact!
  report = FedoraMigrate::MigrationReport.new
  subreports.each {|subreport| report.results.merge! subreport.results }
  report.report_failures STDOUT
end
