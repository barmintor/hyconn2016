# Generated via
#  `rails generate curation_concerns:work Work`
# contained Files added from Fedora 3 content-bearing datastreams
class Work < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::CurationConcerns::BasicMetadata
  include FedoraMigrate::LegacyMetadata
  include FedoraMigrate::BasicMetadata
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }
  has_subresource "transcript", class_name: "FileSet", autocreate: false
end
