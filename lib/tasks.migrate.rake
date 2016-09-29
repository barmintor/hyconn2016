module FedoraMigrate::Hooks

  # @source is a Rubydora object
  # @target is a Hydra 9 modeled object

  # Called from FedoraMigrate::ObjectMover
  def before_object_migration
    # additional actions as needed
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
    subreports << Fedora::Migrate::Tasks.migrate_file_set(pid, true)
  end
  assets[:admin_sets].each do |pid|
    subreports << Fedora::Migrate::Tasks.migrate_administrative_set(pid, true)
  end
  assets[:pages].each do |pid|
    subreports << Fedora::Migrate::Tasks.migrate_work(pid, true)
  end
  assets[:works].each do |pid|
    subreports << Fedora::Migrate::Tasks.migrate_work(pid, true)
  end
  assets[:collections].each do |pid|
    subreports << Fedora::Migrate::Tasks.migrate_collection(pid, true)
  end
  subreports.compact!
  report = FedoraMigrate::MigrationReport.new
  subreports.each {|subreport| report.results.merge! subreport.results }
  report.report_failures STDOUT
end
