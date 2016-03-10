require 'spec_helper'

describe "XSLT to include images" do
  it "generates correct style from html" do
    html = <<-EOL
  <!DOCTYPE html>
  <html>
  <head></head>
  <body>
    <p><img src="http://placehold.it/250x100" id="img" style="width: 250px; height: 100px"></p>
    <p><img src="http://placehold.it/250x100" id="img" style="height:100px width:250px; margin-left:10px"></p>
    <p><img src="http://placehold.it/150x100" id="img" data-width="150" style="width:250px; height:100px"></p>
    <p><img src="http://placehold.it/250x150" id="img" data-height="150" style="width:250px; height:100px"></p>
    <p><img src="http://placehold.it/150x150" id="img" data-width="150" data-height="150" style="width:250px; height:100px"></p>
    <p><img src="http://placehold.it/150x150" id="img" data-width="150" data-height="150""></p>
    </body>
  </html>
    EOL

    expected_wordml = <<-EOL
    <w:p>
      <w:pict>
        <v:shape type="#_x0000_t75" id="img" style="width:250;height:100">
          <v:imagedata r:id="rIdImg1"/>
        </v:shape>
      </w:pict>
    </w:p>
    <w:p>
      <w:pict>
        <v:shape type="#_x0000_t75" id="img" style="width:250;height:100">
          <v:imagedata r:id="rIdImg2"/>
        </v:shape>
      </w:pict>
    </w:p>
    <w:p>
      <w:pict>
        <v:shape type="#_x0000_t75" id="img" style="width:150;height:100">
          <v:imagedata r:id="rIdImg3"/>
        </v:shape>
      </w:pict>
    </w:p>
    <w:p>
      <w:pict>
        <v:shape type="#_x0000_t75" id="img" style="width:250;height:150">
          <v:imagedata r:id="rIdImg4"/>
        </v:shape>
      </w:pict>
    </w:p>
    <w:p>
      <w:pict>
        <v:shape type="#_x0000_t75" id="img" style="width:150;height:150">
          <v:imagedata r:id="rIdImg5"/>
        </v:shape>
      </w:pict>
    </w:p>
    <w:p>
      <w:pict>
        <v:shape type="#_x0000_t75" id="img" style="width:150;height:150">
          <v:imagedata r:id="rIdImg6"/>
        </v:shape>
      </w:pict>
    </w:p>
    EOL


    compare_resulting_wordml_with_expected(html, expected_wordml.strip)
  end

  it "transforms simple img tags" do
    html = <<-EOL
  <!DOCTYPE html>
  <html>
  <head></head>
  <body>
    <p><img src="http://placehold.it/350x150" id="img" data-width="350" data-height="150"></p>
  </body>
  </html>
    EOL

    expected_wordml = <<-EOL
    <w:p>
      <w:pict>
        <v:shape type="#_x0000_t75" id="img" style="width:350;height:150">
          <v:imagedata r:id="rIdImg1"/>
        </v:shape>
      </w:pict>
    </w:p>
    EOL


    compare_resulting_wordml_with_expected(html, expected_wordml.strip)
  end

  it "generates correct relations even when links present" do
    html = <<-EOL
  <!DOCTYPE html>
  <html>
  <head></head>
  <body>
    <p><a href="http://somelink.com">Link text.</a></p>
    <p><img src="http://placehold.it/350x150" id="img" data-width="350" data-height="150"></p>
    <p><a href="http://someotherlink2.com">Other link text 2.</a></p>
    <p><img src="http://placehold.it/400x250" id="img2" data-width="400" data-height="250"></p>
  </body>
  </html>
    EOL
    expected_relations_xml = <<-EOL
  <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
    <Relationship Id="rId3" Type="http://schemas.microsoft.com/office/2007/relationships/stylesWithEffects" Target="stylesWithEffects.xml"/>
    <Relationship Id="rId4" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/settings" Target="settings.xml"/>
    <Relationship Id="rId5" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/webSettings" Target="webSettings.xml"/>
    <Relationship Id="rId6" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/fontTable" Target="fontTable.xml"/>
    <Relationship Id="rId7" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme" Target="theme/theme1.xml"/>
    <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/numbering" Target="numbering.xml"/>
    <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
    <Relationship Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink" Target="http://somelink.com" TargetMode="External" Id="rIdHref1"/>
    <Relationship Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/image" Target="http://placehold.it/350x150" TargetMode="External" Id="rIdImg1"/>
    <Relationship Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink" Target="http://someotherlink2.com" TargetMode="External" Id="rIdHref2"/>
    <Relationship Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/image" Target="http://placehold.it/400x250" TargetMode="External" Id="rIdImg2"/>

  </Relationships>
    EOL
    compare_relations_xml(html, expected_relations_xml)

  end
end