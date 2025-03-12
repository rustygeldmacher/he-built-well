#!/bin/bash

# Usage: ./build.sh [epub|pdf|html|all]

BOOK_TITLE="He Built Well"
OUTPUT_DIR="output"
TEMP_DIR="tmp"
ROOT_ADOC="book/index.adoc"
CSS_FILE="style.css"

# Create directories if they don't exist
mkdir -p "$OUTPUT_DIR"
mkdir -p "$TEMP_DIR"

# Function to build EPUB
build_epub() {
    local outfile="${OUTPUT_DIR}/${BOOK_TITLE}.epub"

    echo "Building EPUB..."

    bundle exec asciidoctor-epub3 \
      --out-file "${outfile}" \
      ${ROOT_ADOC}

    echo "EPUB created at ${OUTPUT_DIR}/${BOOK_TITLE}.epub"
}

# Function to build PDF
build_pdf() {
    local outfile="${OUTPUT_DIR}/${BOOK_TITLE}.pdf"

    echo "Building PDF..."

    mkdir -p ${TEMP_DIR}/images
    cp images/* ${TEMP_DIR}/images

    bundle exec asciidoctor \
      --require asciidoctor-pdf \
      --backend pdf \
      --out-file "${outfile}" \
      ${ROOT_ADOC}

    echo "PDF created at ${outfile}"
}

# Function to build HTML
build_html() {
    local outfile="${OUTPUT_DIR}/${BOOK_TITLE}.html"

    echo "Building HTML..."

    mkdir -p ${OUTPUT_DIR}/images
    cp images/* ${OUTPUT_DIR}/images

    bundle exec asciidoctor \
      --backend html5 \
      --out-file "${outfile}" \
      --attribute toc=left \
      ${ROOT_ADOC}

    echo "HTML created at ${outfile}"
}

# Main execution
case "$1" in
    "epub")
        build_epub
        ;;
    "pdf")
        build_pdf
        ;;
    "html")
        build_html
        ;;
    "all")
        build_epub
        build_pdf
        build_html
        ;;
    *)
        echo "Usage: $0 [epub|pdf|html|all]"
        echo "  epub: Build EPUB file only"
        echo "  pdf:  Build PDF file only"
        echo "  html: Build HTML file only"
        echo "  all:  Build all formats"
        exit 1
        ;;
esac

echo "Build process complete!"
exit 0
