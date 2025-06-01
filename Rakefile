BOOK_TITLE = "HeBuiltWell"
OUTPUT_DIR = "output"
ROOT_ADOC = "book/index.adoc"
CSS_FILE = "style.css"

directory OUTPUT_DIR

desc "Build EPUB version of the book"
task :epub => [OUTPUT_DIR] do
  outfile = "#{OUTPUT_DIR}/#{BOOK_TITLE}.epub"
  puts "Building EPUB..."

  sh "bundle exec asciidoctor-epub3 --out-file \"#{outfile}\" #{ROOT_ADOC}"

  puts "EPUB created at #{outfile}"
end

desc "Build PDF version of the book"
task :pdf => [OUTPUT_DIR] do
  outfile = "#{OUTPUT_DIR}/#{BOOK_TITLE}.pdf"
  puts "Building PDF..."

  sh "bundle exec asciidoctor --require asciidoctor-pdf --backend pdf --out-file \"#{outfile}\" #{ROOT_ADOC} --trace"

  puts "PDF created at #{outfile}"
end

desc "Build HTML version of the book"
task :html => [OUTPUT_DIR] do
  outfile = "#{OUTPUT_DIR}/#{BOOK_TITLE}.html"
  puts "Building HTML..."

  # Process custom CSS
  mkdir_p "tmp"
  mkdir_p "#{OUTPUT_DIR}/css"
  asciidoctor_path = `bundle show asciidoctor`.strip
  cp_r "#{asciidoctor_path}/data/stylesheets/asciidoctor-default.css", "tmp/"
  `cat tmp/asciidoctor-default.css book/css/custom.css > output/css/styles.css`

  mkdir_p "#{OUTPUT_DIR}/images"
  cp_r Dir.glob("book/images/*"), "#{OUTPUT_DIR}/images"

  sh "bundle exec asciidoctor --backend html5 --out-file \"#{outfile}\" --attribute toc=left #{ROOT_ADOC}"

  puts "HTML created at #{outfile}"
end

desc "Build all formats (EPUB, PDF, HTML)"
task :all => [:epub, :pdf, :html] do
  puts "All formats built successfully!"
end

desc "Display usage information"
task :default do
  puts "Available tasks:"
  puts "  rake epub  # Build EPUB file only"
  puts "  rake pdf   # Build PDF file only"
  puts "  rake html  # Build HTML file only"
  puts "  rake all   # Build all formats"
end

desc "Clean output directory"
task :clean do
  rm_rf OUTPUT_DIR
  puts "Cleaned output directory"
end
