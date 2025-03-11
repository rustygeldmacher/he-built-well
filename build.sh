#!/bin/bash

# Usage: ./build.sh [epub|pdf|html|all]

BOOK_TITLE="He Built Well"
OUTPUT_DIR="output"
TEMP_DIR="tmp"
COMBINED_ADOC="${TEMP_DIR}/combined.adoc"
CSS_FILE="style.css"

# Create directories if they don't exist
mkdir -p "$OUTPUT_DIR"
mkdir -p "$TEMP_DIR"

# Function to combine all asciidoc files
combine_files() {
    echo "Combining AsciiDoc files..."

    # Start with metadata
    cat attributes.adoc > "$COMBINED_ADOC"
    echo "" >> "$COMBINED_ADOC"

    # Add frontmatter content
    for file in front-matter/*.adoc; do
        if [ -f "$file" ]; then
            echo "Including $file"
            cat "$file" >> "$COMBINED_ADOC"
            echo "" >> "$COMBINED_ADOC"
        fi
    done

    # Add chapters (in numerical order)
    for file in chapters/[0-9]*.adoc; do
        if [ -f "$file" ]; then
            echo "Including $file"
            cat "$file" >> "$COMBINED_ADOC"
            echo "" >> "$COMBINED_ADOC"
        fi
    done

    # Add backmatter content
    for file in back-matter/*.adoc; do
        if [ -f "$file" ]; then
            echo "Including $file"
            cat "$file" >> "$COMBINED_ADOC"
            echo "" >> "$COMBINED_ADOC"
        fi
    done

    echo "All files combined into $COMBINED_ADOC"
}

# Function to build EPUB
build_epub() {
    local outfile="${OUTPUT_DIR}/${BOOK_TITLE}.epub"

    echo "Building EPUB..."

    bundle exec asciidoctor-epub3 \
      --out-file "${outfile}" \
      ${COMBINED_ADOC}

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
      ${COMBINED_ADOC}

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
      ${COMBINED_ADOC}

    echo "HTML created at ${outfile}"
}

# Main execution
case "$1" in
    "epub")
        combine_files
        build_epub
        ;;
    "pdf")
        combine_files
        build_pdf
        ;;
    "html")
        combine_files
        build_html
        ;;
    "all")
        combine_files
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
