# WCA Documents ![Build Status](https://github.com/thewca/wca-documents/actions/workflows/deploy.yml/badge.svg)

Official Documents of the World Cube Association.

## Process

Whenever changes are made, GitHub builds PDF files out of each Markdown document, pushes the generated files to the [build](https://github.com/thewca/wca-documents/tree/build) branch and deploys them to the website. Documents in `documents` then become available at `worldcubeassociation.org/documents/[path to doc]`, and documents in `edudoc` become available at `worldcubeassociation.org/edudoc/[path to doc]`.

Example: `documents/policies/external/Competition Requirements.md` gets converted to PDF and becomes available at `https://www.worldcubeassociation.org/documents/policies/external/Competition Requirements.pdf`.

The `static` folder contains PDF files that don't need to be rendered; these simply get copied into `build/documents` and become available at the same URL as the files in `documents`.

## Scripts

| Script | Description |
| ------ | ----------- |
| `bin/install_dependencies.sh` | Installs dependencies necessary to generate PDFs. Run this once. |
| `bin/build.sh` | Builds PDF files into `build` directory. Use this to test the rendering of your docs. |
| `bin/deploy.sh` | WCA deployment script used by GitHub. You don't need to use this. |

## Detailed Explanation

The build script (`bin/build.sh`) works in the following steps:

1. Convert all Markdown files in `documents` to HTML, while applying the styling in `assets/style.css` to them. The stylesheet is temporarily copied into each subfolder to be used by the HTML files. HTML files are created and put next to each corresponding Markdown file.
2. Convert all temporary HTML files in `documents` to PDF.
3. Convert all Markdown files in `edudoc` to HTML in the same way as described in step 1, except with the use of the `assets/edudoc-style.css` stylesheet instead.
4. Convert all temporary HTML files in `edudoc` to PDF, while also applying the `assets/edudoc-header.html` header to them.
5. Remove old `build` folder if it exists and create a new one.
6. Copy `documents` and `edudoc` into `build`, and copy the contents of `static` into `build/documents`.
7. Delete all non-PDF files and all empty folders in `build`.
8. Delete all temporary HTML, PDF and CSS files in `documents` and `edudoc`.
