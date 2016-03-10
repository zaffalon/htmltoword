<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
                xmlns:o="urn:schemas-microsoft-com:office:office"
                xmlns:v="urn:schemas-microsoft-com:vml"
                xmlns:WX="http://schemas.microsoft.com/office/word/2003/auxHint"
                xmlns:aml="http://schemas.microsoft.com/aml/2001/core"
                xmlns:w10="urn:schemas-microsoft-com:office:word"
                xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:ext="http://www.xmllab.net/wordml2html/ext"
                xmlns:java="http://xml.apache.org/xalan/java"
                xmlns:str="http://exslt.org/strings"
                xmlns:func="http://exslt.org/functions"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="1.0"
                exclude-result-prefixes="java msxsl ext w o v WX aml w10"
                extension-element-prefixes="func">
  <xsl:template match="img" name="image">
    <xsl:comment>
      A style specifiying the width and height is required to render an image correctly in word.
      Styles can be provided either via data attributes:
      img src="pathtosomeimage" data-width="200" data-height="250"

      or via the html style attribute
      img src="pathtosomeimage" style="width:150px;height:200px"

      If both a style and data attributes are provided then data attributes take president. e.g:
      e.g.
      img src="pathtosomeimage" data-width="200" style="width:150px;height:200px"
      becomes: width:200;height:200

      Note: All sizes must be in pixles
    </xsl:comment>
    <xsl:variable name="width">
      <xsl:choose>
        <xsl:when test="string-length(@data-width) > 0">
          <xsl:value-of select="@data-width" />
        </xsl:when>
        <xsl:when test="contains(@style, 'width:')">
          <xsl:value-of select="translate(substring-before(str:tokenize(substring-after(@style, 'width:'), ';')[1],'px'),'&#x20;&#x9;&#xD;&#xA;','')" />
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="height">
      <xsl:choose>
        <xsl:when test="string-length(@data-height) > 0">
          <xsl:value-of select="@data-height" />
        </xsl:when>
        <xsl:when test="contains(@style, 'height:')">
          <xsl:value-of select="translate(substring-before(str:tokenize(substring-after(@style, 'height:'), ';')[1],'px'),'&#x20;&#x9;&#xD;&#xA;','')"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <w:pict>
      <v:shape type="#_x0000_t75">
        <xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute>
        <xsl:attribute name="style">width:<xsl:value-of select="$width"/>;height:<xsl:value-of select="$height"/></xsl:attribute>
        <v:imagedata>
          <xsl:attribute name="r:id">rIdImg<xsl:value-of select="count(preceding::img)+1" /></xsl:attribute>
        </v:imagedata>
      </v:shape>
    </w:pict>
  </xsl:template>
</xsl:stylesheet>