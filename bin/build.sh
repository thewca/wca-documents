#!/bin/bash

# Find all Markdown files and build PDFs out of them.
find documents -name '*.md' | while read file; do
  pdf_name="${file%.md}.pdf"
  pandoc "$file" | wkhtmltopdf --quiet --encoding 'utf-8' - "$pdf_name"
  rm "$file"
done
