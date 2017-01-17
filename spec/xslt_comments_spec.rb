require 'spec_helper'

describe "XSLT to extract and insert notes as comments" do

  it "extracts and insert notes as comments" do
    html = <<-EOL
  <!DOCTYPE html>
  <html>
  <head></head>
  <body>
    <p>Paragraph
      <span class="h orange" id="h-589694" data-style="orange">
        <div class="marginalia-note-inline ms-comment" data-timestamp="2017-01-17T11:46:00Z" data-author-name="John Doe" data-author-initials="JD">
          my comment
        </div>
        one
      </span>
    ends here.
    </p>
  </body>
  </html>
    EOL
    expected_wordml = <<-EOL
  <w:p>
    <w:r>
      <w:t xml:space="preserve">Paragraph</w:t>
    </w:r>
    <w:commentRangeStart w:id="0" />
    <w:r>
      <w:t xml:space="preserve">
        one
      </w:t>
    </w:r>
    <w:commentRangeEnd w:id="0" />
    <w:r>
      <w:rPr>
        <w:rStyle w:val="CommentReference"/>
      </w:rPr>
      <w:commentReference w:id="0" />
    </w:r>
    <w:r>
      <w:t xml:space="preserve">
      ends here.
      </w:t>
    </w:r>
  </w:p>
    EOL
    expected_comments_xml = <<-EOL
    <w:comments xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape" mc:Ignorable="w14 w15 wp14">
      <w:comment w:id="0" w:author="John Doe" w:date="2017-01-17T11:46:00Z" w:initials="JD">
      <w:p>
        <w:pPr>
          <w:pStyle w:val="CommentText"/>
        </w:pPr>
        <w:r>
          <w:rPr>
            <w:rStyle w:val="CommentReference"/>
          </w:rPr>
          <w:annotationRef/>
        </w:r>
        <w:r>
          <w:t>my comment</w:t>
        </w:r>
      </w:p>
      </w:comment>
    </w:comments>

    EOL
    # source = Nokogiri::HTML(html.gsub(/>\s+</, '><'))
    # result = Htmltoword::Document.new(template_file(nil)).transform_doc_xml(source, false)
    # result.gsub!(/\s*<!--(.*?)-->\s*/m, '')
    # result = remove_declaration(result)
    # binding.pry
    compare_resulting_wordml_with_expected(html, expected_wordml.strip)
    compare_comments_xml(html, expected_comments_xml)
  end
end
