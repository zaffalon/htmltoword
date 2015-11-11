require 'rubygems'
require 'bundler/setup'
require 'htmltoword'

def compare_transformed_files(test_file_name, extras: false)
  source = File.read(html_fixture_path(test_file_name))
  expected_content = File.read(wordml_fixture_path(test_file_name))
  compare_resulting_wordml_with_expected(source, expected_content, extras: extras)
end

def compare_resulting_wordml_with_expected(html, resulting_wordml, extras: false)
  source = Nokogiri::HTML(html.gsub(/>\s+</, "><"))
  cleaned_source = Nokogiri::XSLT(File.open(File.join(Htmltoword.config.default_xslt_path, 'inline_elements.xslt'))).transform(source)
  xslt = Nokogiri::XSLT(File.open(Htmltoword::Document.xslt_template(extras)))
  result = xslt.transform(cleaned_source)
  result.xpath('//comment()').remove
  result = remove_declaration(result.to_s)
  expect(remove_whitespace(result.to_s)).to eq(remove_whitespace(resulting_wordml))
end

def compare_numbering_xml(html, expected_xml)
  source = Nokogiri::HTML(html.gsub(/>\s+</, "><"))
  xslt = Nokogiri::XSLT(File.open(Htmltoword::Document.numbering_xslt))
  result = xslt.transform(source)
  result.xpath('//comment()').remove
  result = remove_declaration(result.to_s)
  expect(remove_whitespace(result.to_s)).to eq(remove_whitespace(expected_xml))
end

def compare_relations_xml(html, expected_xml)
  source = Nokogiri::HTML(html.gsub(/>\s+</, "><"))
  xslt = Nokogiri::XSLT(File.open(Htmltoword::Document.relations_xslt))
  result = xslt.transform(source)
  result.xpath('//comment()').remove
  result = remove_declaration(result.to_s)
  expect(remove_whitespace(result.to_s)).to eq(remove_whitespace(expected_xml))
end

private

def html_fixture_path(file_name)
  File.join(File.dirname(__FILE__), 'fixtures', 'html', "#{file_name}.html")
end

def wordml_fixture_path(file_name)
  File.join(File.dirname(__FILE__), 'fixtures', 'wordml', "#{file_name}.xml")
end

def compare_content_of_body?(wordml)
  wordml !~ /<?xml version/
end

def remove_whitespace(wordml)
  wordml.gsub(/\s+/, " ").sub(/\A\s+/, '').gsub(/\s+\z/,'')
end

def remove_declaration(wordml)
  wordml.sub(/<\?xml (.*?)>/, '').gsub(/\s*xmlns:(\w+)="(.*?)\s*"/,'')
end
