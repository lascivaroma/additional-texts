<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="3.0">    
    <xsl:template match="table">
        <div type="textpart" subtype="book">
            <xsl:apply-templates select="//tr/td[1]" />
        </div>
    </xsl:template>
    <xsl:template match="td">
        <div subtype="chapter" type="textpart">
            <p>
                <xsl:apply-templates/>
            </p>
        </div>
    </xsl:template>
    <xsl:template match="span">
        <xsl:apply-templates />
    </xsl:template>
    <xsl:template match="span[ contains(@style, 'font-size: 10.0pt;')]">
        <quote>
            <xsl:apply-templates/>
        </quote>
    </xsl:template>
</xsl:stylesheet>