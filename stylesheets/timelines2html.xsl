<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
        xmlns:t='https://github.com/lindenb/timelines/'
        version='1.0'
        >

<xsl:output method="text" />

<xsl:template match="/">
<xsl:apply-templates select="*"/>

</xsl:template>

<xsl:template match="t:timelines">
  <xsl:apply-templates select="t:timeline"/>
  <xsl:document href="timelines/index.html" method="html">
  <html lang="en">
  <head>
    <title>Available timelines</title>
  </head>
  <body>
    <h1>Available timelines</h1>
 	<dl>
  	<xsl:for-each select="t:timeline">
  	<dt><a><xsl:attribute name="href"><xsl:value-of select="concat(@id,'/index.html')"/></xsl:attribute><xsl:apply-templates select="." mode="label"/></a></dt>
  	<dd><xsl:apply-templates select="." mode="description"/></dd>
  	</xsl:for-each>
  	</dl>
  </body>
  </html>
  </xsl:document>
</xsl:template>

<xsl:template match="t:timeline">
<xsl:message>Processing <xsl:value-of select="count(@id)"/></xsl:message>
<xsl:variable name="htmllout" select="concat('timelines/',@id,'/index.html')"/>
<xsl:document href="{$htmllout}" method="html">
<html lang="en">
  <head>
    <title><xsl:apply-templates select="." mode="label"/></title>
    <meta charset="utf-8"/>
    <meta name="description">
    <xsl:attribute name="content"><xsl:apply-templates select="." mode="description"/></xsl:attribute>
    </meta>
    <meta name="apple-mobile-web-app-capable" content="yes"/>
    <meta name="apple-touch-fullscreen" content="yes"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0"/>

    <style>
      html, body {
       height:100%;
       padding: 0px;
       margin: 0px;
      }
    </style>
  </head>
  <body>
      <!-- BEGIN Timeline Embed -->
      <div id="timeline-embed"></div>
      <script type="text/javascript">
        var timeline_config = {
         width: "100%",
         height: "100%",
         source: '<xsl:value-of select="@id"/>.json'
        }
      </script>
      <script type="text/javascript" src="../../TimelineJS/build/js/storyjs-embed.js"></script>
      <!-- END Timeline Embed-->
  </body>
</html>
</xsl:document>

<xsl:variable name="jsonout" select="concat('timelines/',@id,'/',@id,'.json')"/>
<xsl:document href="{$jsonout}" method="text">
{
"timeline":
   {
   "headline":"<xsl:apply-templates select="." mode="label.json"/>",
   "type":"default",
   "text":"<xsl:apply-templates select="." mode="description.json"/>",
   "date":[<xsl:for-each select="t:event">
   	<xsl:if test="position() &gt; 1">,</xsl:if>
   	<xsl:apply-templates select="."/>
   	</xsl:for-each>]
   }
}
</xsl:document>
</xsl:template>


<xsl:template match="t:event">{"headline":"<xsl:apply-templates select="." mode="label.json"/>","text":"<xsl:apply-templates select="." mode="description"/><xsl:apply-templates select="t:url"/>","startDate":"<xsl:value-of select="@date"/>"}
</xsl:template>

<xsl:template match="t:url">
<xsl:text> [&lt;a href=\"</xsl:text>
<xsl:value-of select="."/>
<xsl:text>\"&gt;</xsl:text>
<xsl:value-of select="."/>
<xsl:text>&lt;/a&gt;]</xsl:text>
</xsl:template>



<xsl:template match="*" mode="id">
	<xsl:choose>
		<xsl:when test="@id"><xsl:apply-templates select="@id"/></xsl:when>
		<xsl:otherwise><xsl:apply-templates select="generate-id(.)"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template match="*" mode="label">
	<xsl:choose>
		<xsl:when test="t:label"><xsl:apply-templates select="t:label"/></xsl:when>
		<xsl:when test="@label"><xsl:apply-templates select="@label"/></xsl:when>
		<xsl:otherwise><xsl:apply-templates select="." mode="id"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="*" mode="label.json">
	<xsl:choose>
		<xsl:when test="t:label"><xsl:apply-templates select="t:label" mode="json"/></xsl:when>
		<xsl:when test="@label"><xsl:apply-templates select="@label"  mode="json"/></xsl:when>
		<xsl:otherwise><xsl:apply-templates select="." mode="id" /></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="*" mode="description">
	<xsl:choose>
		<xsl:when test="t:description"><xsl:apply-templates select="t:description"/></xsl:when>
		<xsl:when test="@description"><xsl:apply-templates select="@description"/></xsl:when>
		<xsl:otherwise><xsl:apply-templates select="." mode="label"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="*" mode="description.json">
	<xsl:choose>
		<xsl:when test="t:description"><xsl:apply-templates select="t:description" mode="json"/></xsl:when>
		<xsl:when test="@description"><xsl:apply-templates select="@description" mode="json"/></xsl:when>
		<xsl:otherwise><xsl:apply-templates select="." mode="label.json"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="*" mode="json">
<xsl:text>&lt;</xsl:text>
<xsl:value-of select="name(.)"/>
<xsl:for-each select="@*">
	<xsl:text> </xsl:text>
	<xsl:value-of select="name(.)"/>
	<xsl:text>=\"</xsl:text>
	<xsl:apply-templates select="." mode="json"/>
	<xsl:text>\"</xsl:text>
</xsl:for-each>

<xsl:choose>
	<xsl:when test="count(node())&gt;0">
		<xsl:text>&gt;</xsl:text>
		<xsl:apply-templates mode="json"/>
		<xsl:text>&lt;/</xsl:text>
		<xsl:value-of select="name(.)"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:when>
	<xsl:otherwise>
		<xsl:text>/&gt;</xsl:text>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="text()" mode="json">
<xsl:value-of select="."/>
</xsl:template>


<xsl:template match="t:a|t:b|t:i">
<xsl:variable name="name" select="name(.)"/>
<xsl:element name="{$name}">
<xsl:for-each select="@*">
	<xsl:variable name="name2" select="name(.)"/>
	<xsl:attribute name="{$name2}">
		<xsl:value-of select="."/>
	</xsl:attribute>
</xsl:for-each>
<xsl:apply-templates/>
</xsl:element>
</xsl:template>

</xsl:stylesheet>
