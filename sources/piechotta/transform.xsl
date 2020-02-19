<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:strip-space elements="*"/>
    <xsl:output indent="yes" ></xsl:output>
    <xsl:template match="/">
        <text>
            <body>
                <div2 type="edition" n="urn:cts:latinLit:dlt000006.001.csl-lat1" xml:lang="lat">
                <xsl:apply-templates select="//div[./milestone]" />
                </div2>
            </body>
        </text>
    </xsl:template>
    <xsl:template match="font">
        <xsl:apply-templates />
    </xsl:template>
    <xsl:template match="a[starts-with(./@href, '#n')]">
        <xsl:variable name="n" select="substring(@href, 2)"/>
        <xsl:message select="//a[@name=$n]"></xsl:message>
        <note resp="#piechotta">
            <xsl:apply-templates select="//a[@name=$n]"/>
        </note>
    </xsl:template>
    <xsl:template match="sup[ancestor::a]" />
    <xsl:template match="div[./milestone]">
        <div type="textpart" subtype="entry">
            <xsl:attribute name="n" select="./milestone/@n"/>
            <xsl:apply-templates />
        </div>
    </xsl:template>
    <xsl:template match="milestone">
        <head><xsl:apply-templates/></head>
    </xsl:template>
    <xsl:template match="pb">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="gap">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="supplied">
        <supplied reason="lost">
            <xsl:apply-templates />
        </supplied>
    </xsl:template>
    <xsl:template match="font[@color='#0000FF']">
        <corr resp="#helmreich"><xsl:apply-templates/></corr>
    </xsl:template>
    <xsl:template match="font[@color='#009900']">
        <corr resp="#bricout"><xsl:apply-templates/></corr>
    </xsl:template>
</xsl:stylesheet>