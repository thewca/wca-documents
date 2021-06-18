#!/bin/bash

set -x

wca_url="https://worldcubeassociation.org/"

# Find formal and legal Markdown files and build PDFs out of them.
find 'documents' -name '*.md' | while read file; do
  echo "Processing $file, vanilla style"

  html_name="${file%.md}.html"
  pdf_name="${file%.md}.pdf"
  stylesheet="../../../assets/style.css"
  
  file_headline=$(head -n 1 "$file")
  document_title=$(echo "$file_headline" | sed -E "s/#+\s*//")

  # deliberately NOT using the pipe | operator here because wkhtml tries to resolve image links
  # based on the location of its input file. If piping is used, wkhtml assumes /tmp as location
  # and links like "./dummy-image.png" become "/tmp/dummy-image.png" instead of "edudoc/$project/dummy-image.png"
  sed -r "s#wca\{([^}]*)\}#$wca_url\1#g" "$file" | # Replace wca{...} with absolute WCA URL.
  pandoc -s --from markdown --to html5 --css="$stylesheet"  --metadata pagetitle="$document_title" "$file" -o "$html_name" # Markdown -> HTML
  wkhtmltopdf --encoding 'utf-8' -T 15mm -B 15mm -R 15mm -L 15mm --quiet "$html_name" "$pdf_name" # HTML -> PDF
done

compile_date=$(date '+%Y-%m-%d')

# Find educational Markdown files and build PDFs out of them.
find 'edudoc' -name '*.md' | while read file; do
  echo "Processing $file, edudoc style"

  pdf_name="${file%.md}.pdf"
  html_name="${file%.md}.html"
  header_html="${file%.md}-header.html"
  edudoc_stylesheet="../../assets/edudoc-style.css"
  
  file_headline=$(head -n 1 "$file")
  document_title=$(echo "$file_headline" | sed -E "s/#+\s*//")

  sed -E "s#DOCUMENT_TITLE#$document_title#g" "assets/edudoc-header.html" |
  sed -E "s#DATE#$compile_date#g" > "$header_html"

  #pandoc -s --from markdown --to html5 --metadata pagetitle="$document_title" "$file" -o "$html_name"  # Markdown -> HTML
  #wkhtmltopdf --encoding 'utf-8' --user-style-sheet 'assets/edudoc-style.css' -T 15mm -B 15mm -R 15mm -L 15mm --header-html "$header_html" --footer-center "[page]" --quiet "$html_name" "$pdf_name" # HTML -> PDF
  pandoc -s --from markdown --to html5 --css="$edudoc_stylesheet" --metadata pagetitle="$document_title" "$file" -o "$html_name"  # Markdown -> HTML
  wkhtmltopdf --encoding 'utf-8' -T 15mm -B 15mm -R 15mm -L 15mm --header-html "$header_html" --footer-center "[page]" --quiet "$html_name" "$pdf_name" # HTML -> PDF
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
# Remove target PDF and HTML from source folder
find documents/ -name "*.pdf" -delete
find edudoc/ -name "*.pdf" -delete
find documents/ -name "*.html" -delete
find edudoc/ -name "*.html" -delete
