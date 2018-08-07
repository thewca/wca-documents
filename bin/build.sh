#!/bin/bash

wca_url="https://worldcubeassociation.org/"

# Find all Markdown files and build PDFs out of them.
find 'documents' -name '*.md' | while read file; do
  pdf_name="${file%.md}.pdf"

  sed -r "s#wca\{([^}]*)\}#$wca_url\1#g" "$file" | # Replace wca{...} with absolute WCA URL.
  pandoc | # Markdown -> HTML
  wkhtmltopdf --encoding 'utf-8' --user-style-sheet 'assets/style.css' --quiet - "$pdf_name" # HTML -> PDF
done

# Move pdf files to build directory
rm -rf build
cp -r documents build
find build -name '*.md' -exec rm {} +
find documents -name '*.pdf' -exec rm {} +
