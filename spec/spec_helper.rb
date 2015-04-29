require 'rubygems'
require 'bundler/setup'
require 'htmltoword'

def compare_resulting_wordml_with_expected(html, resulting_wordml, extras: false)
  source = Nokogiri::HTML(html.gsub(/>\s+</, "><"))
  xslt = Nokogiri::XSLT(File.open(Htmltoword::Document.xslt_template(extras)))
  result = xslt.transform(source)
  result.xpath('//comment()').remove
  result = remove_declaration(result.to_s)
  expect(remove_whitespace(result.to_s)).to eq(remove_whitespace(resulting_wordml))
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
