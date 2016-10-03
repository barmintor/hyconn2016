# hyconn2016

A project to migrate an exhibition in Fedora 3 to Fedora 4
## Checkpoint Branches
### [Simple Migration](../../tree/migrate-simple)
includes output of CurationConcerns work generator: `rails generate curation_concerns:work Work`

overrides target model selection to swap FileSet in for GenericFile

adds basic File containment for Fedora 3 datastreams

### [Simple Migration with Hooks](../../tree/migrate-hooks)
### [Migration with RDF Metadata](../../tree/migrate-metadata)
### [Migration with Multiple Related Files](../../tree/migrate-ocr-fileset)
### [Migration with Member Objects](../../tree/migrate-members)
### [Migration with Ordered Member Objects](../../tree/migrate-structure)
### [Migration with Generated Derivatives](../../tree/migrate-derivatives)
