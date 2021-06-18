#!/bin/bash

set -x

wca_url="https://worldcubeassociation.org/"
stylesheet=$(realpath "./assets/style.css")

# Find formal and legal Markdown files and build PDFs out of them.
find 'documents' -name '*.md' | while read file; do
  echo "Processing $file, vanilla style"

  html_name="${file%.md}.html"
  pdf_name="${file%.md}.pdf"
  
  file_headline=$(head -n 1 "$file")
  document_title=$(echo "$file_headline" | sed -E "s/#+\s*//")
  
  # Copy stylesheet to be used by the temporary HTML files
  cp "$stylesheet" "$(realpath $(dirname "$file"))"

  # deliberately NOT using the pipe | operator here because wkhtml tries to resolve image links
  # based on the location of its input file. If piping is used, wkhtml assumes /tmp as location
  # and links like "./dummy-image.png" become "/tmp/dummy-image.png" instead of "edudoc/$project/dummy-image.png"
  sed -r "s#wca\{([^}]*)\}#$wca_url\1#g" "$file" | # Replace wca{...} with absolute WCA URL
  
  # Markdown -> HTML
  pandoc -s --from markdown --to html5 --css="./style.css"  --metadata pagetitle="$document_title" "$file" -o "$html_name"
  # HTML -> PDF
  wkhtmltopdf --encoding 'utf-8' -T 15mm -B 15mm -R 15mm -L 15mm --quiet "$html_name" "$pdf_name"
done

compile_date=$(date '+%Y-%m-%d')
stylesheet=$(realpath "./assets/edudoc-style.css")

# Find educational Markdown files and build PDFs out of them.
find 'edudoc' -name '*.md' | while read file; do
  echo "Processing $file, edudoc style"

  pdf_name="${file%.md}.pdf"
  html_name="${file%.md}.html"
  header_html="${file%.md}-header.html"
  
  file_headline=$(head -n 1 "$file")
  document_title=$(echo "$file_headline" | sed -E "s/#+\s*//")
  
  # Copy stylesheet to be used by the temporary HTML files
  cp "$stylesheet" "$(realpath $(dirname "$file"))"

  sed -E "s#DOCUMENT_TITLE#$document_title#g" "assets/edudoc-header.html" |
  sed -E "s#DATE#$compile_date#g" > "$header_html"
  
  # Markdown -> HTML
  pandoc -s --from markdown --to html5 --css="$stylesheet" --metadata pagetitle="$document_title" "$file" -o "$html_name"
  # HTML -> PDF
  wkhtmltopdf --encoding 'utf-8' -T 15mm -B 15mm -R 15mm -L 15mm --header-html "$header_html" --footer-center "[page]" --quiet "$html_name" "$pdf_name"
done

# Remove potentially cached PDFs from last build run
rm -rf build
# Create build dir so that the following cp operations maintain folder structure
mkdir build
# Copy generated content into build folder
cp -r documents build/
cp -r edudoc build/
# Remove source files from target build and trim empty directories
find build/ -type f -not -name "*.pdf" -delete
find build/ -type d -empty -delete
# Remove target PDF, HTML and CSS from source folder
find documents/ -name "*.pdf" -delete
find edudoc/ -name "*.pdf" -delete
find documents/ -name "*.html" -delete
find edudoc/ -name "*.html" -delete
find documents/ -name "*.css" -delete
find edudoc/ -name "*.css" -delete
