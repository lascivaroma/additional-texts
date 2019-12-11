<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0">
    <xsl:output omit-xml-declaration="yes" indent="true"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="div">
        <div type="edition" xml:lang="lat" n="urn:cts:latinLit:stoa0159.stoa004.thayer-lat1">
            <xsl:apply-templates select="//p[contains(@class, 'justify') and not(.//a[@class='note'])]" />
        </div>
    </xsl:template>
    
    <xsl:template name="br">
        <lb />
    </xsl:template>
    
    <xsl:template match="p[not(.//a[@class='note'])]">
        <div type="textpart" subtype="chapter">
            <xsl:attribute name="n" select="translate(.//a[@class='chapter']/text(), ' ', '')"/>
            <p>
                <xsl:apply-templates />
            </p>
        </div>
    </xsl:template>
    
    <xsl:template match="span[contains(@class, 'pagenum')]">
        <xsl:element name="pb">
            <xsl:attribute name="n" select="translate(./text(), 'p ', '')"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="span[@class='small']">
        <num><xsl:apply-templates/></num>
    </xsl:template>
    
    <xsl:template match="span[@class='emend']">
        <corr><xsl:apply-templates/></corr>
    </xsl:template>
    
    <xsl:template match="span[@class='smallcaps']">
        <head><xsl:apply-templates /></head>
    </xsl:template>
    
    <xsl:template match="a[@class='sec']">
        <xsl:element name="milestone">
            <xsl:attribute name="unit">section</xsl:attribute>
            <xsl:attribute name="n"><xsl:value-of select="@name" /></xsl:attribute> 
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="p[.//a[contains(@class, 'note')]]" >
        <xsl:message>Note reached !</xsl:message>
        <note xml:lang="eng"><xsl:apply-templates/></note>
    </xsl:template>
    
    <xsl:template match="span[@class='Latin']">
        <foreign xml:lang="lat"><xsl:apply-templates/></foreign>
    </xsl:template>
    
    <xsl:template match="a[contains(@class, 'ref')]">
        <xsl:variable name="note_id" select="translate(tokenize(./@href, '#')[2], ' ', '')"/>
        <xsl:message select="'Note ID: ' || $note_id || count(//p[./a[@id=$note_id]])"></xsl:message>
        <xsl:apply-templates select="//p[.//a[@id=$note_id]]" />
    </xsl:template>
    
    <xsl:template match="a[@class='chapter']" />
    <xsl:template match="a[@class='note']" />
    
</xsl:stylesheet>
