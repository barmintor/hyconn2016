# hyconn2016

A project to migrate an exhibition in Fedora 3 to Fedora 4
## Checkpoint Branches
### [Simple Migration](/hyconn2016/tree/migrate-simple)
includes output of CurationConcerns work generator:
  rails generate curation_concerns:work Work
overrides target model selection to swap FileSet in for GenericFile
adds basic File containment for Fedora 3 datastreams
### [Simple Migration with Hooks](/hyconn2016/tree/migrate-hooks)
### [Migration with RDF Metadata](/hyconn2016/tree/migrate-metadata)
### [Migration with Multiple Related Files](/hyconn2016/tree/migrate-ocr)
### [Migration with Member Objects](/hyconn2016/tree/migrate-members)
### [Migration with Ordered Member Objects](/hyconn2016/tree/migrate-structure)
### [Migration with Generated Derivatives](/hyconn2016/tree/migrate-derivatives)
