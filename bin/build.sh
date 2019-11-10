#!/bin/bash

wca_url="https://worldcubeassociation.org/"

# Find formal and legal Markdown files and build PDFs out of them.
find 'documents' -name '*.md' | while read file; do
  echo "Processing $file, vanilla style"

  pdf_name="${file%.md}.pdf"

  sed -r "s#wca\{([^}]*)\}#$wca_url\1#g" "$file" | # Replace wca{...} with absolute WCA URL.
  pandoc | # Markdown -> HTML
  wkhtmltopdf --encoding 'utf-8' --user-style-sheet 'assets/style.css' -T 15mm -B 15mm -R 15mm -L 15mm --quiet - "$pdf_name" # HTML -> PDF
done

compile_date=$(date '+%Y-%m-%d')

# Find educational Markdown files and build PDFs out of them.
find 'edudoc' -name '*.md' | while read file; do
  echo "Processing $file, edudoc style"

  pdf_name="${file%.md}.pdf"
  header_html="${file%.md}-header.html"

  file_headline=$(head -n 1 "$file")
  document_title=$(echo "$file_headline" | sed -E "s/#+\s*//")

  sed -E "s#DOCUMENT_TITLE#$document_title#g" "assets/edudoc-header.html" |
  sed -E "s#DATE#$compile_date#g" > "$header_html"
  
  pandoc -s --from markdown --to html5 --metadata pagetitle="$document_title" "$file" | # Markdown -> HTML
  wkhtmltopdf --encoding 'utf-8' --user-style-sheet 'assets/edudoc-style.css' -T 15mm -B 15mm -R 15mm -L 15mm --header-html "$header_html" --footer-center "[page]" --quiet - "$pdf_name" # HTML -> PDF
done

# Remove potentially cached PDFs from last build run
rm -rf build
# Create build dir so that the following cp operations maintain folder structure
mkdir build
# Copy generated content into build folder
cp -r documents build/
cp -r edudoc build/
# Remove source files from target build
find build/ -type f -not -name "*.pdf" -delete
# Remove target PDF from source folder
find documents/ -name "*.pdf" -delete
find edudoc/ -name "*.pdf" -delete
find edudoc/ -name "*.html" -delete
