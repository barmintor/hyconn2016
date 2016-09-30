# Generated via
#  `rails generate curation_concerns:work Work`
# contained Files added from Fedora 3 content-bearing datastreams
class Work < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::CurationConcerns::BasicMetadata
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }
  has_subresource "descMetadata", class_name: "ActiveFedora::File"
  has_subresource "ocr", class_name: "ActiveFedora::File"
end