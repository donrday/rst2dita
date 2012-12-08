<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>


<!--
  <xsl:include href="docutils-struct.xsl"/>
  <xsl:include href="docutils-blocks.xsl"/>
  <xsl:include href="docutils-param.xsl"/>
  <xsl:include href="docutils-inlines.xsl"/>
  <xsl:include href="docutils-lists.xsl"/>
  <xsl:include href="docutils-common.xsl"/>
  <xsl:include href="docutils-images.xsl"/>
-->

<xsl:output method="xml" indent="yes" />

<xsl:template match="*">
   <xsl:variable name="class" select="generate-id(@class)"/>
   <xsl:variable name="space" select="generate-id(@xml:space)"/>
   <xsl:copy>
      <xsl:copy-of select="@*[(generate-id(.)!=$class) and (generate-id(.)!=$space)]" />
      <xsl:apply-templates />
   </xsl:copy>
</xsl:template>

<xsl:template match="comment()|processing-instruction()">
   <xsl:copy />
</xsl:template>

<xsl:template match="/">
		<xsl:apply-templates select="document" mode="map"/>
</xsl:template>

<xsl:template match="document" mode="map">
<xsl:text>
</xsl:text>
	<map>
		<xsl:attribute name="title"><xsl:value-of select="child::title"/></xsl:attribute>
		<xsl:apply-templates mode="map"/>
	</map>
</xsl:template>

<xsl:template match="document/title|section/title|topic/title" mode="map">
</xsl:template>

<xsl:template match="paragraph|literal_block|comment" mode="map">
</xsl:template>

<xsl:template match="section|topic" mode="map">
	<topicref>
		<xsl:attribute name="navtitle"><xsl:value-of select="child::title"/></xsl:attribute>
		<xsl:attribute name="type"><xsl:value-of select="name()"/></xsl:attribute>
		<xsl:apply-templates select="topic|section" mode="map"/>
	</topicref>
</xsl:template>

</xsl:stylesheet>
