<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                xmlns:str="http://exslt.org/strings"
                xmlns:func="http://exslt.org/functions"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="1.0">

  <xsl:template match="span[contains(concat(' ', @class, ' '), ' h ')]">
    <xsl:comment>
      This template adds MS Word highlighting ability.
    </xsl:comment>
    <xsl:variable name="color" select="func:highlight-color(./@data-style)" />
    <xsl:choose>
      <xsl:when test="preceding-sibling::h1 or preceding-sibling::h2 or preceding-sibling::h3 or preceding-sibling::h4 or preceding-sibling::h5 or preceding-sibling::h6 or preceding-sibling::table or preceding-sibling::p or preceding-sibling::ol or preceding-sibling::ul or preceding-sibling::div or following-sibling::h1 or following-sibling::h2 or following-sibling::h3 or following-sibling::h4 or following-sibling::h5 or following-sibling::h6 or following-sibling::table or following-sibling::p or following-sibling::ol or following-sibling::ul or following-sibling::div">
        <w:p>
          <xsl:call-template name="highlight-note">
            <xsl:with-param name="color" select="$color" />
          </xsl:call-template>
        </w:p>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="highlight-note">
          <xsl:with-param name="color" select="$color" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="highlight-note">
    <xsl:param name="color" />
    <xsl:choose>
      <xsl:when test="./span[contains(concat(' ', @class, ' '), ' ms-comment ')]">
        <xsl:variable name="comment-id" select="count(preceding::span[contains(concat(' ', @class, ' '), ' ms-comment ')]) + 1"/>
        <xsl:variable name="comment-text" select="./span[contains(concat(' ', @class, ' '), ' ms-comment ')]"/>
        <xsl:variable name="highlight-text" select="concat(substring-before(., $comment-text), ' ', substring-after(., $comment-text))"/>
        <w:commentRangeStart w:id="{$comment-id}" />
        <w:r>
          <w:rPr>
            <w:highlight w:val="{$color}"/>
          </w:rPr>
          <w:t xml:space="preserve"><xsl:value-of select="normalize-space($highlight-text)"/></w:t>
        </w:r>
        <w:commentRangeEnd w:id="{$comment-id}" />
        <w:r>
          <w:rPr>
            <w:rStyle w:val="CommentReference"/>
            <w:highlight w:val="{$color}"/>
          </w:rPr>
          <w:commentReference w:id="{$comment-id}" />
        </w:r>
      </xsl:when>
      <xsl:otherwise>
        <w:r>
          <w:rPr>
            <w:highlight w:val="{$color}"/>
          </w:rPr>
          <w:t xml:space="preserve"><xsl:value-of select="."/></w:t>
        </w:r>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <func:function name="func:highlight-color">
    <xsl:param name="html-color"/>
    <func:result>
      <xsl:choose>
        <xsl:when test="$html-color='pink'">magenta</xsl:when>
        <xsl:when test="$html-color='blue'">cyan</xsl:when>
        <xsl:when test="$html-color='orange'">darkYellow</xsl:when>
        <xsl:otherwise><xsl:value-of select="$html-color"/></xsl:otherwise>
      </xsl:choose>
    </func:result>
  </func:function>
</xsl:stylesheet>
