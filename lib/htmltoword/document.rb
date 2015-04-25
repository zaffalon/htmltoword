module Htmltoword
  class Document
    class << self
      include HtmltowordHelper

      def create(content, file_name, template_name = nil, extras = false)
        file_name += extension unless file_name =~ /\.docx$/
        template_name += extension if template_name && !(template_name =~ /\.docx$/)
        word_file = new(template_file(template_name), file_name)
        word_file.replace_file(content, Document.doc_xml_file, extras)
        word_file.save
      end

      def create_with_content(template, file_name, content, set=nil, extras = false)
        template += extension unless template =~ /\.docx$/
        word_file = new(template_file(template), file_name)
        content = replace_values(content, set) if set
        word_file.replace_file(content, Document.doc_xml_file, extras)
        word_file.save
      end

      def extension
        '.docx'
      end

      def doc_xml_file
        'word/document.xml'
      end

      def xslt_template(extras = false)
        File.join(Htmltoword.config.default_xslt_path, (extras ? 'htmltoword.xslt' : 'base.xslt'))
      end
    end

    def initialize(template_path, file_name)
      @file_name = file_name
      @replaceable_files = {}
      @template_path = template_path
    end

    def file_name
      @file_name
    end

    #
    # It creates missing folders if needed, creates a new zip/word file on the
    # specified location, copies all the files from the template word document
    # and replace the content of the ones to be replaced.
    # It will create a tempfile and return it. The rails app using the gem
    # should decide what to do with it.
    #
    #
    def save
      Tempfile.open([file_name, Document.extension], type: 'application/zip') do |output_file|
        Zip::File.open(@template_path) do |template_zip|
          Zip::OutputStream.open(output_file.path) do |out|
            template_zip.each do |entry|
              out.put_next_entry entry.name
              if @replaceable_files[entry.name]
                out.write(@replaceable_files[entry.name])
              else
                out.write(template_zip.read(entry.name))
              end
            end
          end
        end
        output_file
      end
    end

    def replace_file(html, file_name = Document.doc_xml_file, extras = false)
      html = html.presence || '<body></body>'
      source = Nokogiri::HTML(html.gsub(/>\s+</, '><'))
      template = Document.xslt_template(extras)
      xslt = Nokogiri::XSLT(File.open(template))
      source = xslt.transform(source) #unless (source / '/html').blank?
      @replaceable_files[file_name] = source.to_s
    end
  end
end
