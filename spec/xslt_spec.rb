require 'spec_helper'

describe "XSLT" do

  it "transforms an empty html doc into an empty docx doc" do
    html = '<html><head></head><body></body></html>'
    compare_resulting_wordml_with_expected(html, " ")
  end

  it "transforms a div into a docx block element." do
    html = '<html><head></head><body><div>Hello</div></body></html>'
    compare_resulting_wordml_with_expected(html, "<w:p> <w:r> <w:t xml:space=\"preserve\">Hello</w:t> </w:r> </w:p>")
  end

  context "transform a span" do

    it "into a docx block element if child of body." do
      html = '<html><head></head><body><span>Hello</span></body></html>'
      compare_resulting_wordml_with_expected(html, "<w:p> <w:r> <w:t xml:space=\"preserve\">Hello</w:t> </w:r> </w:p>")
    end

    it "into a docx inline element if not child of body." do
      html = '<html><head></head><body><div><span>Hello</span></div></body></html>'
      compare_resulting_wordml_with_expected(html, "<w:p> <w:r> <w:t xml:space=\"preserve\">Hello</w:t> </w:r> </w:p>")
    end

  end

  it "transforms a p into a docx block element." do
    html = '<html><head></head><body><p>Hello</p></body></html>'
    compare_resulting_wordml_with_expected(html, "<w:p> <w:r> <w:t xml:space=\"preserve\">Hello</w:t> </w:r> </w:p>")
  end

  it "Should strip out details tags" do
    html = '<html><head></head><body><div><p>Hello</p><details><summary>Title</summary><p>Second</p><details></div></body></html>'
    compare_resulting_wordml_with_expected(html, "<w:p> <w:r> <w:t xml:space=\"preserve\">Hello</w:t> </w:r> </w:p>")
  end
end
