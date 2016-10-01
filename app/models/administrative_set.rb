# stub class for admin sets
class AdministrativeSet < ActiveFedora::Container
  include ::CurationConcerns::AdminSetBehavior
  include FedoraMigrate::LegacyMetadata
end