module Emcee
  module Processors
    module Includes
      # Match a stylesheet link tag.
      #
      #   <link rel="stylesheet" href="assets/example.css">
      #
      STYLESHEET_PATTERN = /^ *<link .*rel=["']stylesheet["'].*>$/

      # Scan the body for external stylesheet references. If any are found,
      # inline the files in place of the references and return the new body.
      def process_stylesheets(body, directory)
        to_inline = []

        body.scan(STYLESHEET_PATTERN) do |stylesheet_tag|
          if path = stylesheet_tag[HREF_PATH_PATTERN, :path]
            absolute_path = File.absolute_path(path, directory)
            stylesheet_contents = read_file(absolute_path)
            to_inline << [stylesheet_tag, "<style>" + stylesheet_contents + "</style>"]
          end
        end

        to_inline.reduce(body) do |output, (tag, contents)|
          output.gsub(tag, contents)
        end
      end
    end
  end
end