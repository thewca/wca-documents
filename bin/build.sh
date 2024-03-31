#!/bin/bash

# Makes it so that all commands are displayed as they get executed
set -x

# WCA url and absolute path to WCA logo file
wca_url="https://www.worldcubeassociation.org/"
wca_docs_url="https://documents.worldcubeassociation.org/"
logo=$(realpath "./assets/WCAlogo_notext.svg")
# Absolute paths to the stylesheets and the edudoc header
stylesheet=$(realpath "./assets/style.css")
edudoc_stylesheet=$(realpath "./assets/edudoc-style.css")
edudoc_header=$(realpath "./assets/edudoc-header.html")
# Current date
compile_date=$(date '+%Y-%m-%d')

# Function for converting Markdown files from a given folder into PDF files using the given stylesheet
# The first argument ($1) is the folder and the second argument is the stylesheet ($2)
convert_to_pdf() {
  cp -r "$1/" build/

  # Find formal and legal Markdown files and build PDFs out of them.
  find "build/$1" -name '*.md' | while read file; do
    echo "Processing $file using the ${1} stylesheet"

    pdf_name="${file%.md}.pdf"
    html_name="${file%.md}.html"
    
    file_headline=$(head -n 1 "$file")
    document_title=$(echo "$file_headline" | sed -E "s/#+\s*//")

    # Replace wca{...} and wcadoc{...} with absolute WCA URLs (the correct URLs only get inserted in production)
    sed -Ei "s#wca\{([^}]*)\}#$wca_url\1#g" "$file"
    sed -Ei "s#wcadoc\{([^}]*)\}#$wca_docs_url\1#g" "$file"
    # Replace {logo} with the path to the WCA logo in /assets
    sed -Ei "s#\{logo\}#$logo#g" "$file"

    # This creates the custom header for each edudoc and saves it next to the doc that will use it
    if [ $1 = "edudoc" ]; then
      header_html="${file%.md}-header.html"
    
      # Set the document title, path to the logo and the date
      sed -E "s#DOCUMENT_TITLE#$document_title#g" "$edudoc_header" |
      sed -E "s#WCA_LOGO_PATH#$logo#g" |
      sed -E "s#DATE#$compile_date#g" > "$header_html"
    fi

    # Markdown -> HTML
    pandoc -s --from markdown --to html5 --css=$2 --metadata pagetitle="$document_title" "$file" -o "$html_name"

    # HTML -> PDF
    if [ $1 = "documents" ]; then
      wkhtmltopdf --encoding 'utf-8' -T 15mm -B 15mm -R 15mm -L 15mm --quiet "$html_name" "$pdf_name"
    elif [ $1 = "edudoc" ]; then
      wkhtmltopdf --encoding 'utf-8' -T 15mm -B 15mm -R 15mm -L 15mm --header-html "$header_html" --footer-center "[page]" --quiet "$html_name" "$pdf_name"
    fi

    # Deliberately NOT using the pipe | operator between pandoc and wkhtml because wkhtml tries to resolve image links
    # based on the location of its input file. If piping is used, wkhtml assumes /tmp as location,
    # and links like "./dummy-image.png" become "/tmp/dummy-image.png" instead of "edudoc/$project/dummy-image.png"
  done
}

# Remove potentially cached PDFs from the last build run and make an empty build folder
rm -rf build
mkdir build

convert_to_pdf documents "$stylesheet"
convert_to_pdf edudoc "$edudoc_stylesheet"

# Remove all non-PDF files and empty folders from build
find build/ -type f -not -name "*.pdf" -delete
find build/ -type d -empty -delete
