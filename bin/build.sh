#!/bin/bash

# Makes it so that all commands are displayed as they get executed
set -x

wca_url="https://worldcubeassociation.org/"
stylesheet=$(realpath "./assets/style.css")

# Remove potentially cached PDFs from the last build run and make an empty build folder
rm -rf build
mkdir build
# Copy source folders into build
cp -r documents/ build/
cp -r edudoc/ build/
# Copy WCA logo into build/assets temporarily
mkdir build/assets
cp assets/WCAlogo_notext.svg build/assets/

# Find formal and legal Markdown files and build PDFs out of them.
find 'build/documents' -name '*.md' | while read file; do
  echo "Processing $file, vanilla style"

  pdf_name="${file%.md}.pdf"
  html_name="${file%.md}.html"
  
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
find 'build/edudoc' -name '*.md' | while read file; do
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

# Remove all non-PDF files and empty folders from build
find build/ -type f -not -name "*.pdf" -delete
find build/ -type d -empty -delete
