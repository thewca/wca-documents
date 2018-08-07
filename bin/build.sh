#!/bin/bash

wca_url="https://worldcubeassociation.org/"

# Find all Markdown files and build PDFs out of them.
find documents -name '*.md' | while read file; do
  pdf_name="${file%.md}.pdf"

  sed -r "s#wca\{([^}]*)\}#$wca_url\1#g" "$file" | # Replace wca{...} with absolute WCA URL.
  pandoc | # Markdown -> HTML
  wkhtmltopdf --quiet --encoding 'utf-8' - "$pdf_name" # HTML -> PDF
  rm "$file"
done
