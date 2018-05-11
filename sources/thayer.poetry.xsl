<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:functx="http://www.functx.com"
    >
    <xsl:output method="xml" indent="yes" encoding="UTF-8" exclude-result-prefixes="#all"/>
    <xsl:param name="uri" select="'http://penelope.uchicago.edu/Thayer/L/Roman/Texts/Grattius/Cynegeticon*.html'" />
    <xsl:function name="functx:escape-for-regex">
        <xsl:param name="arg"/>
        <xsl:sequence select="
            replace($arg,
            '(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')
            "/>
        
    </xsl:function>
    <xsl:template match="*:html">
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title xml:lang="lat">Elegiarum Liber</title>
                        <author xml:lang="fre">Maximien</author>
                        <author xml:lang="eng">Maximianus</author>
                    </titleStmt>
                    <publicationStmt>
                        <p>Publication Information</p>
                    </publicationStmt>
                    <sourceDesc>
                        <bibl>
                            <editor>Richard Webster</editor>
                            <title>The Elegies of Maximianus</title>
                            <publisher>Princeton Press</publisher>
                            <date>1900</date>
                            <ref target="https://archive.org/details/elegiesmaximian00websgoog"/>
                        </bibl>
                        <bibl>
                            <pubPlace>Lacus Curtius</pubPlace>
                            <xsl:element name="ref"><xsl:attribute name="target" select="$uri" /></xsl:element>
                            <editor>Bill Thayer</editor>
                        </bibl>
                    </sourceDesc>
                </fileDesc>
                <encodingDesc>
                    <refsDecl n="CTS">
                        <cRefPattern n="line" matchPattern="(\d+).(\d+)"
                            replacementPattern="#xpath(/tei:TEI/tei:text/tei:body/tei:div/tei:div[@n='$1']//tei:l[@n='$2'])">
                            <p>This pattern extracts lines in poems</p>
                        </cRefPattern>
                    </refsDecl>
                </encodingDesc>
                <revisionDesc>
                    <change who="Thibault Clérice" when="2018-05-10">Original transformation into Capitains
                        Epidoc</change>
                </revisionDesc>
            </teiHeader>
            <text>
                <body>
                    <div type="edition" n="urn:cts:latinLit:stoa0196.stoa001.latinlibrary-lat1" xml:lang="lat">
                        <xsl:apply-templates />
                    </div>
                </body>
            </text>
        </TEI>
    </xsl:template>
    <xsl:template match="*:p[starts-with(@class, 'verse') or matches(@class, 'line')]">
        <l>
            <xsl:attribute name="n" select="./*:a[matches(@name, '^\d+$')]/@name" />
            <xsl:apply-templates />
        </l>
    </xsl:template>
    
    <xsl:template match="*:a[contains(@href, '#note')]">
        <xsl:variable name="id" select="replace(./@href, functx:escape-for-regex(concat($uri, '#')), '')"/>
        <note>
            <xsl:attribute name="xml:id" select="$id"/>
            <xsl:call-template name="note">
                <xsl:with-param name="node" select="//*:p[./*:a[@id=$id]]" />
            </xsl:call-template>
        </note>
    </xsl:template>
    <xsl:template match="*:p[starts-with(@class, 'verse') or matches(@class, 'line')]/text()">
        <xsl:copy />
    </xsl:template>
    <xsl:template match="*:span[@class='pagenum']">
        <xsl:element name="pb">
            <xsl:attribute name="n" select="replace(./text(),'\s+','')"  />
        </xsl:element>
    </xsl:template>
    <xsl:template match="*:span[@class='emend']">
        <corr><xsl:value-of select="text()"/></corr>
    </xsl:template>
    <xsl:template match="*:span[@class='Latin']/text()">
        <xsl:copy/>
    </xsl:template>
    <xsl:template match="*:span[@class='Latin']">
        <foreign xml:lang="lat">
            <xsl:apply-templates />
        </foreign>
    </xsl:template>
    <xsl:template match="*:span[@class='manuscript']">
        <abbr type="manuscript"><xsl:value-of select="text()"/></abbr>
    </xsl:template>
    <xsl:template match="*:i">
        <emph><xsl:value-of select="./text()"/></emph>
    </xsl:template>
    <xsl:template name="note">
        <xsl:param name="node" />
        <xsl:apply-templates select="$node/child::*" />
    </xsl:template>
    <xsl:template match="*:p[./*:a[starts-with(./@id, 'note')]]/text()">
        <xsl:copy />
    </xsl:template>
    <!-- Ignore some content -->
    <xsl:template match="*:p[./*:a[starts-with(./@id, 'note')]]" />
    <xsl:template match="text()"/>
</xsl:stylesheet>