# hyconn2016

A project to migrate an exhibition in Fedora 3 to Fedora 4
## Checkpoint Branches
### [Simple Migration](../../tree/migrate-simple)
includes output of CurationConcerns work generator: `rails generate curation_concerns:work Work`

overrides target model selection to swap FileSet in for GenericFile

adds basic File containment for Fedora 3 datastreams

### [Simple Migration with Hooks](../../tree/migrate-hooks)
`rails generate rspec:install`

add `require 'capybara'` to rails_helper.rb

write a legacy metadata property mixin, include it in models and test assignment
### [Migration with RDF Metadata](../../tree/migrate-metadata)
Replace descMetadata subresource with convert option to FedoraMigrate

[Review CurationConcerns::RequiredMetadata](https://github.com/projecthydra/curation_concerns/blob/master/app/models/concerns/curation_concerns/required_metadata.rb) for required attributes

Inline context URI references in source n-triples

Move default title assignment to subsequent hooks

[Review CurationConcerns::BasicMetadata](https://github.com/projecthydra/curation_concerns/blob/master/app/models/concerns/curation_concerns/basic_metadata.rb) for predicate differences

modify predicates in after hook based on [RDF::Graph](https://github.com/ruby-rdf/rdf/blob/develop/lib/rdf/model/graph.rb) queries and substitutions

write and include `FedoraMigrate::BasicMetadata` mixin for models with additional RDF properties

make migrated objects publicly readable

### [Migration with Multiple Related Files](../../tree/migrate-ocr-fileset)

[Review Hydra::Works::ContainedFiles](https://github.com/projecthydra/hydra-works/blob/master/lib/hydra/works/models/concerns/file_set/contained_files.rb)

Add a service file typed membership to FileSet

### [Migration with Member Objects](../../tree/migrate-members)
### [Migration with Ordered Member Objects](../../tree/migrate-structure)
### [Migration with Generated Derivatives](../../tree/migrate-derivatives)
