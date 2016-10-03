module FedoraMigrate
  module Works
    autoload :FileSetMover, 'fedora_migrate/works/file_set_mover'
    autoload :MembersMover, 'fedora_migrate/works/members_mover'
    autoload :RelsExtDatastreamMover, 'fedora_migrate/works/rels_ext_datastream_mover'
  end
end