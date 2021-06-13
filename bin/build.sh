#!/bin/bash

# Makes it so that all commands are displayed as they get executed
set -x

# WCA url and absolute path to WCA logo file
wca_url="https://worldcubeassociation.org/"
logo=$(realpath "./assets/WCAlogo_notext.svg")
# Absolute paths to the stylesheets and the edudoc header
stylesheet=$(realpath "./assets/style.css")
edudoc_stylesheet=$(realpath "./assets/edudoc-style.css")
edudoc_header=$(realpath "./assets/edudoc-header.html")
# Current date
compile_date=$(date '+%Y-%m-%d')

<<<<<<< HEAD
# Function for converting Markdown files from a given folder into PDF files using the given stylesheet
# The first argument ($1) is the folder and the second argument is the stylesheet ($2)
convert_to_pdf() {
  cp -r "$1/" build/
=======
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
  
  #ORIGINAL
  #pandoc -o "$html_name" # Markdown -> HTML
  #wkhtmltopdf --encoding 'utf-8' --user-style-sheet 'assets/style.css' -T 15mm -B 15mm -R 15mm -L 15mm --quiet "$html_name" "$pdf_name" # HTML -> PDF
done
>>>>>>> Potential fix for styling of all documents (WIP)

  # Find formal and legal Markdown files and build PDFs out of them.
  find "build/$1" -name '*.md' | while read file; do
    echo "Processing $file using the ${1} stylesheet"

    pdf_name="${file%.md}.pdf"
    html_name="${file%.md}.html"
    
    file_headline=$(head -n 1 "$file")
    document_title=$(echo "$file_headline" | sed -E "s/#+\s*//")

<<<<<<< HEAD
    # Replace wca{...} with absolute WCA URLs (the correct URLs only get inserted in production)
    sed -Ei "s#wca\{([^}]*)\}#$wca_url\1#g" "$file"
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
=======
  pdf_name="${file%.md}.pdf"
  html_name="${file%.md}.html"
  header_html="${file%.md}-header.html"
  edudoc_stylesheet="../../assets/edudoc-style.css"
  
  file_headline=$(head -n 1 "$file")
  document_title=$(echo "$file_headline" | sed -E "s/#+\s*//")
>>>>>>> Potential fix for styling of all documents (WIP)

    # HTML -> PDF
    if [ $1 = "documents" ]; then
      wkhtmltopdf --encoding 'utf-8' -T 15mm -B 15mm -R 15mm -L 15mm --quiet "$html_name" "$pdf_name"
    elif [ $1 = "edudoc" ]; then
      wkhtmltopdf --encoding 'utf-8' -T 15mm -B 15mm -R 15mm -L 15mm --header-html "$header_html" --footer-center "[page]" --quiet "$html_name" "$pdf_name"
    fi

<<<<<<< HEAD
    # Deliberately NOT using the pipe | operator between pandoc and wkhtml because wkhtml tries to resolve image links
    # based on the location of its input file. If piping is used, wkhtml assumes /tmp as location,
    # and links like "./dummy-image.png" become "/tmp/dummy-image.png" instead of "edudoc/$project/dummy-image.png"
  done
}
=======
  #pandoc -s --from markdown --to html5 --metadata pagetitle="$document_title" "$file" -o "$html_name"  # Markdown -> HTML
  #wkhtmltopdf --encoding 'utf-8' --user-style-sheet 'assets/edudoc-style.css' -T 15mm -B 15mm -R 15mm -L 15mm --header-html "$header_html" --footer-center "[page]" --quiet "$html_name" "$pdf_name" # HTML -> PDF
  pandoc -s --from markdown --to html5 --css="$edudoc_stylesheet" --metadata pagetitle="$document_title" "$file" -o "$html_name"  # Markdown -> HTML
  wkhtmltopdf --encoding 'utf-8' -T 15mm -B 15mm -R 15mm -L 15mm --header-html "$header_html" --footer-center "[page]" --quiet "$html_name" "$pdf_name" # HTML -> PDF
done
>>>>>>> Potential fix for styling of all documents (WIP)

# Remove potentially cached PDFs from the last build run and make an empty build folder
rm -rf build
mkdir build

convert_to_pdf documents "$stylesheet"
convert_to_pdf edudoc "$edudoc_stylesheet"

# Remove all non-PDF files and empty folders from build
find build/ -type f -not -name "*.pdf" -delete
find build/ -type d -empty -delete
<<<<<<< HEAD
=======
# Remove target PDF and HTML from source folder
find documents/ -name "*.pdf" -delete
find edudoc/ -name "*.pdf" -delete
find documents/ -name "*.html" -delete
find edudoc/ -name "*.html" -delete
>>>>>>> Potential fix for styling of all documents (WIP)
