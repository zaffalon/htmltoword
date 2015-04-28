<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
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

  <!-- support function to return substring-before or everything -->
  <func:function name="func:substring-before-if-contains">
    <xsl:param name="arg"/>
    <xsl:param name="delim"/>
    <func:result>
      <xsl:choose>
        <xsl:when test="contains($arg, $delim)">
          <xsl:value-of select="substring-before($arg, $delim)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$arg"/>
        </xsl:otherwise>
      </xsl:choose>
    </func:result>
  </func:function>

  <!-- Full width tables per default -->
  <xsl:template match="table">
    <w:tbl>
      <w:tblPr>
        <w:tblStyle w:val="TableGrid"/>
        <w:tblW w:w="5000" w:type="pct"/>
        <xsl:call-template name="tableborders"/>
        <w:tblLook w:val="0600" w:firstRow="0" w:lastRow="0" w:firstColumn="0" w:lastColumn="0" w:noHBand="1" w:noVBand="1"/>
      </w:tblPr>
      <xsl:apply-templates />
    </w:tbl>
  </xsl:template>

  <!-- Advanced cell transformation -->
  <xsl:template match="td|th">
    <w:tc>
      <xsl:choose>
        <xsl:when test="contains(@class, 'ms-border-')">
          <w:tcPr>
            <w:tcBorders>
              <xsl:for-each select="str:tokenize(@class, ' ')">
                <xsl:if test="contains(., 'ms-border-')">
                  <xsl:variable name="border" select="substring-after(., 'ms-border-')"/>
                  <xsl:variable name="border-location" select="substring-before($border, '-')" />
                  <xsl:variable name="border-value" select="substring-after($border, '-')" />
                  <xsl:element name="w:{$border-location}">
                    <xsl:attribute name="w:val"><xsl:value-of select="$border-value" /></xsl:attribute>
                    <xsl:attribute name="w:sz">6</xsl:attribute>
                    <xsl:attribute name="w:space">0</xsl:attribute>
                    <xsl:attribute name="w:color">000000</xsl:attribute>
                  </xsl:element>
                </xsl:if>
              </xsl:for-each>
            </w:tcBorders>
          </w:tcPr>
        </xsl:when>
      </xsl:choose>
      <xsl:call-template name="block">
        <xsl:with-param name="current" select="." />
        <xsl:with-param name="class" select="@class" />
        <xsl:with-param name="style" select="@style" />
      </xsl:call-template>
    </w:tc>
  </xsl:template>

  <!-- use block quotes for spacing (can be nested) -->
  <xsl:template match="blockquote">
    <w:p>
      <w:pPr>
        <w:spacing w:afterLines="200" />
      </w:pPr>
    </w:p>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="ol/li">
    <w:p>
      <w:pPr>
        <w:pStyle w:val="ListParagraph"/>
        <w:numPr>
          <w:ilvl w:val="0"/>
          <w:numId w:val="1"/>
        </w:numPr>
      </w:pPr>
      <w:r>
        <w:t xml:space="preserve"><xsl:value-of select="."/></w:t>
      </w:r>
    </w:p>
  </xsl:template>

  <xsl:template match="ul/li">
    <w:p>
      <w:pPr>
        <w:pStyle w:val="ListParagraph"/>
        <w:numPr>
          <w:ilvl w:val="0"/>
          <w:numId w:val="10"/>
        </w:numPr>
      </w:pPr>
      <w:r>
        <w:t xml:space="preserve"><xsl:value-of select="."/></w:t>
      </w:r>
    </w:p>
  </xsl:template>

  <xsl:template match="ol">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="ul">
    <xsl:apply-templates />
  </xsl:template>

</xsl:stylesheet>
