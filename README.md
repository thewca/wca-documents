# WCA Documents ![Build Status](https://github.com/thewca/wca-documents/actions/workflows/deploy.yml/badge.svg)

Official Documents of the World Cube Association.

## Process

Whenever changes are made, GitHub builds PDF files out of each Markdown document, pushes the generated files to the [build branch](https://github.com/thewca/wca-documents/tree/build) and deploys them to the website. Documents in `documents` then become available at `worldcubeassociation.org/documents/[path to doc].pdf`, and documents in `edudoc` become available at `worldcubeassociation.org/edudoc/[path to doc].pdf`. Pre-rendered PDFs are simply copied into `build` during the build process.

Example: `documents/policies/external/Competition Requirements.md` gets converted to PDF and becomes available at `https://documents.worldcubeassociation.org/documents/policies/external/Competition Requirements.pdf`.

## Scripts

Run these scripts from the root directory of the repository:

| Script | Description |
| ------ | ----------- |
| `bin/install_dependencies.sh` | Installs dependencies necessary to generate PDFs*. Run this once. |
| `bin/build.sh` | Builds PDF files into the `build` directory. `documents` or `edudoc` can be passed as the first argument to only build documents from the specified directory. |
| `bin/docker_build.sh` | Builds PDF files using Docker. Use the `--rebuild` flag if you need to rebuild the image. The same directory argument as in `build.sh` is also supported. |
| `bin/deploy.sh` | WCA deployment script used by GitHub. You don't need to use this. |

\* This only supports Debian-based distributions. If you are not using a Debian-based distribution, install these dependencies manually: [pandoc](https://www.pandoc.org), [weasyprint](https://doc.courtbouillon.org/weasyprint/stable), Liberation Sans font, a font with full Unicode support (e.g. Google Noto).

## Writing and translating documents

[This document](https://github.com/thewca/wca-documents/blob/master/documents-guide.md) explains everything necessary to create a new document or translate an Educational Resources document.

## Detailed Explanation

The build script (`bin/build.sh`) works in the following steps:

1. Remove old `build` folder if it exists and create a new one.
2. Copy the `documents` folder into `build` (all changes are applied inside of the `build` folder).
3. Replace all occurences of `wca{[url]}` and `wcadoc{[url]}` with the actual URL to the website (used as a shortcut).
4. Replace all occurences of `{logo}` with the actual absolute path to the WCA logo in `assets/WCAlogo_notext.svg` (used as a shortcut).
5. Convert all Markdown files to HTML, while applying the styling in `assets/style.css`. HTML files are created and put next to each corresponding Markdown file.
6. Convert all temporary HTML files in `documents` to PDF. PDF files are created and put next to each corresponding Markdown file.
7. Repeat steps 2-5 for the `edudoc` folder, except with the use of the stylesheet in `assets/edudoc-style.css`.
8. For each edudoc create a custom header using `assets/edudoc-header.html`, where **DOCUMENT_TITLE** is replaced with the actual title, **WCA_LOGO_PATH** is replaced with the absolute path to the logo and **DATE** is replaced with the current date at the time of the build.
9. Repeat step 6 for the `edudoc` files, except also apply the custom header and a footer that shows the document page.
10. Delete all non-PDF files and all empty folders in `build`.
