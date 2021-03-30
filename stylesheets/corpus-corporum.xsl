<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="1.0">
    <xsl:template match="node()">
        <xsl:choose>
            <xsl:when test="local-name()">
                <xsl:element name="{local-name()}" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:apply-templates select="node()|@*|comment()"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="node()|@*|comment()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template> 
    
    <xsl:template match="@*|comment()">
        <xsl:copy/>
    </xsl:template>
        
    <xsl:template match="TEI.2">
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates />
        </TEI>
    </xsl:template>
    <xsl:template match="publicationStmt">
        <xsl:element name="titleStmt" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates select="/TEI.2/teiHeader/fileDesc/sourceDesc/bibl/title" />
            <xsl:apply-templates select="/TEI.2/teiHeader/fileDesc/sourceDesc/bibl/author" />
        </xsl:element>
        
        <publicationStmt xmlns="http://www.tei-c.org/ns/1.0">
            <p xmlns="http://www.tei-c.org/ns/1.0">This document has been adapted from the Corpus Corporum project for Capitains formating.</p>
        </publicationStmt>
    </xsl:template>
    <xsl:template match="seriesStmt|notesStmt"></xsl:template>
    <xsl:template match="imprint">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="projectDesc|normalization">
        <xsl:element name="{local-name()}" namespace="http://www.tei-c.org/ns/1.0">
            
            <p xmlns="http://www.tei-c.org/ns/1.0"><xsl:apply-templates /></p>
        </xsl:element>
    </xsl:template>
    <xsl:template match="projectDesc/i">
        <title xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates />
        </title>
    </xsl:template>
    <xsl:template match="language[./text()='latin']">
        <language xmlns="http://www.tei-c.org/ns/1.0" ident="latin">latin</language>
    </xsl:template>
    <xsl:template match="text">
        <text xmlns="http://www.tei-c.org/ns/1.0">
            <body xmlns="http://www.tei-c.org/ns/1.0">
                <div xmlns="http://www.tei-c.org/ns/1.0" type="edition" n="" xml:lang="lat">
                    <xsl:apply-templates />
                </div>
            </body>
        </text>
    </xsl:template>
    <xsl:template match="i">
        <hi xmlns="http://www.tei-c.org/ns/1.0" rend="italics"><xsl:apply-templates/></hi>
    </xsl:template>
    <xsl:template match="b|B">
        <hi xmlns="http://www.tei-c.org/ns/1.0" rend="bold"><xsl:apply-templates/></hi>
    </xsl:template>
    
    <xsl:template match="editorialDecl">
        <editorialDecl xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates />
        </editorialDecl>
        <refsDecl xmlns="http://www.tei-c.org/ns/1.0" n="CTS">
            <cRefPattern n="section" matchPattern="(\w+).(\w+)"
                replacementPattern="#xpath(/tei:TEI/tei:text/tei:body/tei:div/tei:div[@n='$1']/tei:div[@n='$2'])">
                <p>This pointer pattern extracts chapter</p>
            </cRefPattern>
            <cRefPattern n="book" matchPattern="(\w+)"
                replacementPattern="#xpath(/tei:TEI/tei:text/tei:body/tei:div/tei:div[@n='$1'])">
                <p>This pointer pattern extracts books</p>
            </cRefPattern>
        </refsDecl>
    </xsl:template>
    
    <!-- Might be specific to a file -->
    <xsl:template match="div3/head"/>
    <xsl:template match="p//div3">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="div3">
        <div xmlns="http://www.tei-c.org/ns/1.0" type="textpart" subtype="section">
            <xsl:attribute name="n" ><xsl:value-of select="translate(./head/text(), '.', '')"/></xsl:attribute>
            <xsl:choose>
                <xsl:when test="./p">
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise>
                    <p xmlns="http://www.tei-c.org/ns/1.0"><xsl:apply-templates/></p>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    <xsl:template match="div1">
        <div xmlns="http://www.tei-c.org/ns/1.0" type="textpart" subtype="book">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="div1/p">
        <div xmlns="http://www.tei-c.org/ns/1.0" type="textpart" subtype="section">
            <xsl:attribute name="n">1</xsl:attribute>
            <p xmlns="http://www.tei-c.org/ns/1.0"><xsl:apply-templates/></p>
        </div>
    </xsl:template>
</xsl:stylesheet>