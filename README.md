# WCA Documents [![Build Status](https://travis-ci.org/thewca/wca-documents.svg?branch=master)](https://travis-ci.org/thewca/wca-documents)

Official Documents of the World Cube Association.

## Process

Whenever changes are made Travis builds PDF out of each Markdown document, pushes the generated files to the [build](https://github.com/thewca/wca-documents/tree/build) branch
and deploys them to [the website](https://www.worldcubeassociation.org/documents).

## Scripts

| Script | Description |
| ------ | ----------- |
| `bin/install_dependencies.sh` | Installs dependencies necessary to generate PDFs. |
| `bin/build.sh` | Builds PDF files into `build` directory. |
| `bin/deploy.sh` | WCA deployment script used by Travis. |
