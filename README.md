# v1 Ontology for Islandora

## Description

This repository holds a RDFS representation of the relsext, and relsint ontologies used Islandora 7.x-1.x.

HTML representations of the ontologies can be viewed here:

* http://islandora.ca/ontology/relsext#
* http://islandora.ca/ontology/relsint#

To generate HTML versions of the ontologies:

```sh
$ mvn xml:transform
```

## Contributing

Should there be discrepancy between the ontology as published and the codebase, please create a JIRA ticket as outlined in the [CONTRIBUTING.md](https://github.com/Islandora-Labs/islandora_ontology/blob/master/CONTRIBUTING.md#report-a-bug).

In addition, during each release cycle, an audit of the ontology is done to identify discrepancies between the existing code base, and published ontology.

## Maintainer(s)

* Chris Stanton](https://github.com/ChrisStanton)

## License

Apache 2.0
