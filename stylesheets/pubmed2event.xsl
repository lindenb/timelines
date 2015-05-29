<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
        xmlns:t='https://github.com/lindenb/timelines/'
        version='1.0'
        >

<xsl:output method="xml" indent="yes"/>

<xsl:template match="/">
<t:events>
<xsl:apply-templates select="PubmedArticleSet" />
</t:events>
</xsl:template>


<xsl:template match="PubmedArticleSet">
<xsl:apply-templates select="PubmedArticle" />
</xsl:template>

<xsl:template match="PubmedArticle">
<t:event>
<xsl:attribute name="id">pmid<xsl:value-of select="MedlineCitation/PMID/text()"/></xsl:attribute>
<xsl:apply-templates select="MedlineCitation/Article" />
</t:event>
</xsl:template>

<xsl:template match="Article">
<xsl:apply-templates select="Abstract" />
<xsl:apply-templates select="ArticleTitle" />
<xsl:apply-templates select="Journal/JournalIssue/PubDate" />
</xsl:template>

<xsl:template match="ArticleTitle">
<t:label>
<xsl:value-of select="text()"/>
</t:label>
</xsl:template>

<xsl:template match="Abstract">
<t:description>
<xsl:for-each select="AbstractText">
<xsl:value-of select="text()"/>
</xsl:for-each>
</t:description>
</xsl:template>

<xsl:template match="PubDate">
<t:date>
	<xsl:apply-templates select="Year|Month|Day" />
</t:date>
</xsl:template>

<xsl:template match="Year">
<t:year>
	<xsl:value-of select="text()"/>
</t:year>
</xsl:template>

<xsl:template match="Month">
<t:month>
	<xsl:choose>
		<xsl:when test=".='May'">5</xsl:when>
		<xsl:otherwise><xsl:value-of select="text()"/></xsl:otherwise>
	</xsl:choose>
</t:month>
</xsl:template>

<xsl:template match="Day">
<t:day>
	<xsl:value-of select="text()"/>
</t:day>
</xsl:template>

</xsl:stylesheet>
