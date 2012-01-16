<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:xtf="http://cdlib.org/xtf"
    xmlns:session="java:org.cdlib.xtf.xslt.Session"
    xmlns:pipe="java:/org.cdlib.xtf.saxonExt.Pipe"
    xmlns:FileUtils="java:org.cdlib.xtf.xslt.FileUtils"
    xmlns:erep="http://escholarship.org/erep"
    xmlns:ns2="http://www.w3.org/1999/xlink"
    xmlns:ead="urn:isbn:1-931666-22-9"
    xmlns:cal="xalan://java.util.GregorianCalendar"
    extension-element-prefixes="session pipe"> 
    
    <!--
        *******************************************************************
        *                                                                 *
        * VERSION:          1.01                                          *
        *                                                                 *
        * AUTHOR:           Winona Salesky                                *
        *                   wsalesky@gmail.com                            *
        *                                                                 *
        * REVISED          December 7, 2011 WS                            *
        * ADAPTED          September 26, 2011 WS                          *
        *                  Adapted for Rockefeller Archive Center         *  
        *                                                                 *
        * ABOUT:           This file is a modified version of the         *
        *                  Archivists Toolkit at_eadToPDF stylesheet      *
        *                  Created for use within xtf for a "print view"  *
        *                                                                 *
        *******************************************************************
    -->
    <xsl:output method="xml" encoding="utf-8" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:include href="lookupListsPDF.xsl"/>
<!--    <xsl:include href="reports/Resources/eadToPdf/lookupListsPDF.xsl"/>-->
    <!-- 9/19/11 WS for RA: Caculates current date -->   
    <xsl:variable name="tmp" select="cal:new()"/>
    <xsl:variable name="year" select="cal:get($tmp, 1)"/>
    <xsl:variable name="filename" select="substring-before(/ead:ead/ead:eadheader/ead:eadid,'.xml')"/>
    <xsl:template name="print">
        <xsl:variable name="headerString">
            <xsl:choose>
                <xsl:when test="/ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper">
                    <xsl:choose>
                        <xsl:when test="starts-with(/ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper,/ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper/ead:num)">
                            <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:did/ead:unittitle" mode="header"/>
                        </xsl:when>
                        <xsl:when test="/ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper/@type = 'filing'">
                            <xsl:choose>
                                <xsl:when test="count(/ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper) &gt; 1">
                                    <xsl:apply-templates select="ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper[not(@type='filing')]" mode="print"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:did/ead:unittitle" mode="printheader"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="/ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper" mode="print"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:did/ead:unittitle" mode="printheader"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="pageHeader">
            <xsl:value-of select="substring($headerString,1,100)"/>
            <xsl:if test="string-length(normalize-space($headerString)) &gt; 100">...</xsl:if>
        </xsl:variable>
        <pipe:pipeFOP xmlns:pipe="java:/org.cdlib.xtf.saxonExt.Pipe" fileName="{$filename}.pdf"> 
            <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="verdana, arial, sans-serif" font-size="11pt">
                <fo:layout-master-set>
                    <!-- Page master for Cover Page -->
                    <fo:simple-page-master master-name="cover-page" page-width="8.5in" page-height="11in" margin-top="0.2in" margin-bottom="0.5in" margin-left="0.5in" margin-right="0.5in">
                        <fo:region-body margin="0.5in" margin-bottom="1in"/>
                        <fo:region-before extent="0.2in"/>
                        <fo:region-after extent="2in"/>
                    </fo:simple-page-master>
                    <!-- 8/11/11 WS: Page master for Overview for Rockefeller Archives -->
                    <fo:simple-page-master master-name="overview" page-width="8.5in" page-height="11in" margin-top="0.25in" margin-bottom="0.5in" margin-left="0.5in" margin-right="0.5in">
                        <fo:region-body margin="0.5in" margin-bottom="1in"/>
                        <fo:region-before extent=".75in"/>
                        <fo:region-after extent=".75in"/>
                    </fo:simple-page-master>
                    <!-- Page master for Table of Contents -->
                    <fo:simple-page-master master-name="toc" page-width="8.5in" page-height="11in" margin-top="0.25in" margin-bottom="0.5in" margin-left="0.5in" margin-right="0.5in">
                        <fo:region-body margin="0.5in" margin-bottom="1in"/>
                        <fo:region-before extent="0.75in"/>
                        <fo:region-after extent="0.2in"/>
                    </fo:simple-page-master>
                    <!-- Page master for Contents -->
                    <fo:simple-page-master master-name="contents" page-width="8.5in" page-height="11in" margin-top="0.25in" margin-bottom="0.5in" margin-left="0.5in" margin-right="0.5in">
                        <fo:region-body margin="0.5in" margin-bottom="1in"/>
                        <fo:region-before extent="0.75in"/>
                        <fo:region-after extent="0.2in"/>
                    </fo:simple-page-master>
                </fo:layout-master-set>
                <!-- The fo:page-sequence establishes headers, footers and the body of the page.-->
                <fo:page-sequence master-reference="cover-page">
                    <fo:static-content flow-name="xsl-region-after">
                        <fo:block text-align="center">
                            <xsl:apply-templates select="/ead:ead/ead:eadheader/ead:filedesc/ead:publicationstmt" mode="print"/>
                        </fo:block>
                    </fo:static-content>
                    <fo:flow flow-name="xsl-region-body">
                        <fo:block>
                            <xsl:apply-templates select="/ead:ead/ead:eadheader" mode="print"/>
                        </fo:block>
                    </fo:flow>
                </fo:page-sequence>
                <!-- 8/11/11 WS: Added overview page for Rockefeller Archives -->
                <fo:page-sequence master-reference="overview">
                    <fo:static-content flow-name="xsl-region-before">
                        <fo:block color="gray" text-align="center" margin-top=".25in">
                            <xsl:value-of select="$pageHeader"/>
                        </fo:block>
                    </fo:static-content>
                    <!-- 8/14/11 WS for RA: changed footer-->
                    <fo:static-content flow-name="xsl-region-after">
                        <fo:block border-top-style="solid" border-top-color="#7E1416" border-top-width=".04in" padding-top=".025in" margin-bottom="0in" padding-after="0in" padding-bottom="0">
                            <fo:block color="gray" padding-top="0in" margin-top="-0.015in" border-top-style="solid" border-top-color="#7E1416" border-top-width=".015in">
                                <fo:table space-before="0.07in" table-layout="fixed" width="100%" font-size="8pt" margin-top=".05in" padding-top="0in">
                                    <fo:table-column column-width="2in"/>
                                    <fo:table-column column-width="5in"/>
                                    <fo:table-body>
                                        <fo:table-row>
                                            <fo:table-cell>
                                                <fo:block text-align="left" margin-left=".025in">
                                                    <xsl:text> Overview</xsl:text>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell>
                                                <fo:block text-align="right" margin-right="-.475in">
                                                    <xsl:text> Page </xsl:text>
                                                    <fo:page-number/>
                                                </fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                    </fo:table-body>
                                </fo:table>
                            </fo:block>
                        </fo:block>
                    </fo:static-content>
                    <fo:flow flow-name="xsl-region-body">
                        <xsl:apply-templates select="ead:archdesc/ead:did" mode="print"/>
                    </fo:flow>
                </fo:page-sequence>
                <fo:page-sequence master-reference="toc">
                    <fo:static-content flow-name="xsl-region-before">
                        <fo:block color="gray" text-align="center" margin-top=".25in">
                            <xsl:value-of select="$pageHeader"/>
                        </fo:block>
                    </fo:static-content>
                    <fo:static-content flow-name="xsl-region-after">
                        <fo:block border-top-style="solid" border-top-color="#7E1416" border-top-width=".04in" padding-top=".025in" margin-bottom="0in" padding-after="0in" padding-bottom="0">
                            <fo:block color="gray" padding-top="0in" margin-top="-0.015in" border-top-style="solid" border-top-color="#7E1416" border-top-width=".015in">
                                <fo:table space-before="0.07in" table-layout="fixed" width="100%"
                                    font-size="8pt" margin-top=".05in" padding-top="0in">
                                    <fo:table-column column-width="2in"/>
                                    <fo:table-column column-width="5in"/>
                                    <fo:table-body>
                                        <fo:table-row>
                                            <fo:table-cell>
                                                <fo:block text-align="left" margin-left=".025in">
                                                    <xsl:text> Table of Contents</xsl:text>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell>
                                                <fo:block text-align="right" margin-right="-.475in">
                                                    <xsl:text> Page </xsl:text>
                                                    <fo:page-number/>
                                                </fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                    </fo:table-body>
                                </fo:table>
                            </fo:block>
                        </fo:block>
                    </fo:static-content>
                    <fo:flow flow-name="xsl-region-body">
                        <xsl:call-template name="printToc"/>
                    </fo:flow>
                </fo:page-sequence>
                <fo:page-sequence master-reference="contents">
                    <fo:static-content flow-name="xsl-region-before" margin-top=".25in">
                        <fo:block color="gray" text-align="center">
                            <xsl:value-of select="$pageHeader"/>
                        </fo:block>
                    </fo:static-content>
                    <fo:static-content flow-name="xsl-region-after">
                        <fo:block border-top-style="solid" border-top-color="#7E1416" border-top-width=".04in" padding-top=".025in" margin-bottom="0in" padding-after="0in" padding-bottom="0">
                            <fo:block color="gray" padding-top="0in" margin-top="-0.015in" border-top-style="solid" border-top-color="#7E1416" border-top-width=".015in">
                                <fo:table space-before="0.07in" table-layout="fixed" width="100%" font-size="8pt" margin-top=".05in" padding-top="0in">
                                    <fo:table-column column-width="5in"/>
                                    <fo:table-column column-width="2in"/>
                                    <fo:table-body>
                                        <fo:table-row>
                                            <fo:table-cell>
                                                <fo:block text-align="left" margin-left=".025in">
                                                    <fo:retrieve-marker retrieve-class-name="title"/>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell>
                                                <fo:block text-align="right" margin-right="-.475in">
                                                    <xsl:text> Page </xsl:text>
                                                    <fo:page-number/>
                                                </fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                    </fo:table-body>
                                </fo:table>
                            </fo:block>
                        </fo:block>
                    </fo:static-content>
                    <fo:flow flow-name="xsl-region-body">
                        <xsl:apply-templates select="ead:archdesc" mode="print"/>
                    </fo:flow>
                </fo:page-sequence>
            </fo:root>
        </pipe:pipeFOP>
    </xsl:template>
    <!-- EAD Header, this information populates the cover page -->
    <xsl:template match="ead:eadheader" mode="print">
        <fo:block text-align="center" padding-top=".5in" line-height="24pt" border-bottom="3pt solid #F4EFEF" space-after="18pt" padding-bottom="12pt">
            <fo:block font-size="20pt" wrap-option="wrap">
                <xsl:choose>
                    <xsl:when test="ead:filedesc/ead:titlestmt/ead:titleproper">
                        <xsl:choose>
                            <xsl:when test="starts-with(ead:filedesc/ead:titlestmt/ead:titleproper,ead:filedesc/ead:titlestmt/ead:titleproper/ead:num)">
                                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:did/ead:unittitle" mode="printheader"/>
                            </xsl:when>
                            <xsl:when test="ead:filedesc/ead:titlestmt/ead:titleproper/@type = 'filing'">
                                <xsl:choose>
                                    <xsl:when test="count(ead:filedesc/ead:titlestmt/ead:titleproper) &gt; 1">
                                        <xsl:apply-templates select="ead:filedesc/ead:titlestmt/ead:titleproper[not(@type='filing')]" mode="print"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:did/ead:unittitle" mode="printheader"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="ead:filedesc/ead:titlestmt/ead:titleproper" mode="print"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:did/ead:unittitle" mode="printheader"/>
                    </xsl:otherwise>
                </xsl:choose>
            </fo:block>
            <fo:block font-size="16pt">
                <xsl:apply-templates select="ead:filedesc/ead:titlestmt/ead:subtitle" mode="print"/>
            </fo:block>
        </fo:block>
        <fo:block margin="1in" font-size="14pt" space-before="18pt" color="#666" text-align="center" font-weight="normal" line-height="24pt">
            <fo:block>
                <!-- 10/30/11 WS for RA: Replaced default AT language in author field with "Collection Guide prepared by"-->
                <xsl:if test="ead:filedesc/ead:titlestmt/ead:author">
                    <xsl:value-of select="concat('Collection Guide prepared ',substring-after(ead:filedesc/ead:titlestmt/ead:author,'prepared'))"/>                    
                </xsl:if>
            </fo:block>
            <!-- 8/10/11 WS: Changed publication date from profiledec to publicationstmt/date -->
            <!--<xsl:apply-templates select="ead:profiledesc"/>-->
            <xsl:apply-templates select="ead:filedesc/ead:publicationstmt/ead:date" mode="print"/>    
            <xsl:apply-templates select="ead:revisiondesc" mode="print"/>    
            
            <!-- 8/10/11 WS: Added Rockefeller Logo -->
            <fo:block space-before="75pt">
                <fo:external-graphic src="http://www.rockarch.org/images/RAC-logo.png" content-height="100%" content-width="100%"/>
                <fo:block font-size="11pt"> &#169; Rockefeller Archive Center,
                    <xsl:choose>
                        <xsl:when test="ead:filedesc/ead:publicationstmt/ead:date">
                            <xsl:value-of select="ead:filedesc/ead:publicationstmt/ead:date"/>        
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$year"/>
                        </xsl:otherwise>
                    </xsl:choose> 
                </fo:block>
            </fo:block>
        </fo:block>
    </xsl:template>
    <xsl:template match="ead:filedesc/ead:titlestmt/ead:titleproper/ead:num" mode="print">
        <!-- 8/15/11 WS: Added parenthesizes for RA -->
        <fo:block> &#160;(<xsl:apply-templates/>) </fo:block>
    </xsl:template>
    <xsl:template match="ead:revisiondesc" mode="print">
        <fo:block line-height="12pt">
            <xsl:if test="ead:change/ead:date">Last revised: &#160;<xsl:value-of select="ead:change/ead:date"/></xsl:if>
        </fo:block>
    </xsl:template>
    <xsl:template match="ead:publicationstmt" mode="print">
        <fo:block font-size="14pt">
            <xsl:apply-templates select="ead:publisher"/>
        </fo:block>
        <xsl:apply-templates select="ead:address"/>
    </xsl:template>
    <xsl:template match="ead:address" mode="print">
        <fo:block>
            <xsl:apply-templates mode="print"/>
        </fo:block>
    </xsl:template>
    <!-- 8/10/11 WS: Added test to link email addresses -->
    <xsl:template match="ead:addressline" mode="print">
        <xsl:choose>
            <xsl:when test="position()=1">
                <fo:block>
                    <xsl:apply-templates mode="print"/>
                </fo:block>
            </xsl:when>
            <xsl:when test="contains(.,'@')">
                <fo:block>
                    <fo:basic-link external-destination="url('mailto:{.}')" color="blue" text-decoration="underline">
                        <xsl:value-of select="."/>
                    </fo:basic-link>
                </fo:block>
            </xsl:when>
            <xsl:otherwise>
                <fo:block>
                    <xsl:apply-templates mode="print"/>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="ead:profiledesc/ead:creation/ead:date" mode="print">
        <xsl:variable name="month">
            <xsl:choose>
                <xsl:when test="substring(.,6,2) = '01'">January</xsl:when>
                <xsl:when test="substring(.,6,2) = '02'">February</xsl:when>
                <xsl:when test="substring(.,6,2) = '03'">March</xsl:when>
                <xsl:when test="substring(.,6,2) = '04'">April</xsl:when>
                <xsl:when test="substring(.,6,2) = '05'">May</xsl:when>
                <xsl:when test="substring(.,6,2) = '06'">June</xsl:when>
                <xsl:when test="substring(.,6,2) = '07'">July</xsl:when>
                <xsl:when test="substring(.,6,2) = '08'">August</xsl:when>
                <xsl:when test="substring(.,6,2) = '09'">September</xsl:when>
                <xsl:when test="substring(.,6,2) = '10'">October</xsl:when>
                <xsl:when test="substring(.,6,2) = '11'">November</xsl:when>
                <xsl:when test="substring(.,6,2) = '12'">December</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <fo:block line-height="18pt" font-size="12pt">
            <xsl:value-of select="concat($month,' ',substring(.,9,2),', ',substring(.,1,4))"/>
        </fo:block>
    </xsl:template>
    <xsl:template match="ead:profiledesc/ead:langusage" mode="print"/>
    <!-- Special template for header display -->
    <xsl:template match="/ead:ead/ead:archdesc/ead:did/ead:unittitle" mode="printheader">
        <xsl:apply-templates mode="printheader"/>
    </xsl:template>
    <xsl:template match="/ead:ead/ead:archdesc/ead:did/ead:unittitle/child::*" mode="printheader">
            &#160;<xsl:apply-templates select="." mode="header"/>
    </xsl:template>
    <xsl:template match="ead:num" mode="printheader"> (<xsl:value-of select="."/>) </xsl:template>
    <!-- A named template generating the Table of Contents, order of items is pre-determined, to change the order, rearrange the xsl:if or xsl:for-each statements.  -->
    <!-- 8/21/11 WS for RA: uses predefined headings, not headings output in the xml-->
    <xsl:template name="printToc">
        <fo:block font-size="14pt" space-before="24pt" padding-bottom="-2pt" space-after="18pt" color="black" padding-after="1pt" padding-before="24pt" border-bottom="1pt solid #000">Table of Contents </fo:block>
        <fo:block line-height="16pt">
            <xsl:if test="/ead:ead/ead:archdesc/ead:did">
                <fo:block text-align-last="justify">
                    <fo:basic-link internal-destination="{generate-id(/ead:ead/ead:archdesc/ead:did)}">Overview</fo:basic-link>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <fo:leader leader-pattern="dots"/>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <fo:page-number-citation ref-id="{generate-id(/ead:ead/ead:archdesc/ead:did)}"/>
                </fo:block>
            </xsl:if>
            <xsl:for-each select="/ead:ead/ead:archdesc/ead:scopecontent">
                <fo:block text-align-last="justify">
                    <fo:basic-link>
                        <xsl:call-template name="printtocLinks"/>Collection Description</fo:basic-link>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <fo:leader leader-pattern="dots"/>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <xsl:call-template name="tocPage"/>
                </fo:block>
            </xsl:for-each>
            <!-- 8/16/11 WS for RA: Added Access and Use Location note-->
            <xsl:if test="/ead:ead/ead:archdesc/ead:relatedmaterial or /ead:ead/ead:archdesc/ead:separatedmaterial
                or /ead:ead/ead:archdesc/ead:accessrestrict or /ead:ead/ead:archdesc/ead:userestrict
                or /ead:ead/ead:archdesc/ead:phystech or /ead:ead/ead:archdesc/ead:prefercite
                or /ead:ead/ead:archdesc/ead:otherfindaid /ead:ead/ead:archdesc/ead:originalsloc /ead:ead/ead:archdesc/ead:altformavail">
                <fo:block text-align-last="justify">
                    <fo:basic-link internal-destination="relMat">Access and Use</fo:basic-link>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <fo:leader leader-pattern="dots"/>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <fo:page-number-citation ref-id="relMat"/>
                </fo:block>
            </xsl:if>
            <xsl:for-each select="/ead:ead/ead:archdesc/ead:arrangement">
                <fo:block text-align-last="justify">
                    <fo:basic-link>
                        <xsl:call-template name="printtocLinks"/>Arrangement</fo:basic-link>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <fo:leader leader-pattern="dots"/>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <xsl:call-template name="tocPage"/>
                </fo:block>
            </xsl:for-each>
            <xsl:for-each select="/ead:ead/ead:archdesc/ead:bioghist">
                <fo:block text-align-last="justify">
                    <fo:basic-link>
                        <xsl:call-template name="printtocLinks"/>Biographical/Historical Note</fo:basic-link>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <fo:leader leader-pattern="dots"/>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <xsl:call-template name="tocPage"/>
                </fo:block>
            </xsl:for-each>
            <xsl:for-each select="/ead:ead/ead:archdesc/ead:controlaccess">
                <fo:block text-align-last="justify">
                    <fo:basic-link>
                        <xsl:call-template name="printtocLinks"/>Controlled Access Headings</fo:basic-link>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <fo:leader leader-pattern="dots"/>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <xsl:call-template name="tocPage"/>
                </fo:block>
            </xsl:for-each>
            <!-- Administrative Information  -->
            <xsl:if
                test="/ead:ead/ead:archdesc/ead:userestrict or
                /ead:ead/ead:archdesc/ead:custodhist or
                /ead:ead/ead:archdesc/ead:accruals or
                /ead:ead/ead:archdesc/ead:altformavail or
                /ead:ead/ead:archdesc/ead:acqinfo or
                /ead:ead/ead:archdesc/ead:processinfo or
                /ead:ead/ead:archdesc/ead:appraisal">
                <fo:block text-align-last="justify">
                    <fo:basic-link internal-destination="adminInfo">Administrative Information</fo:basic-link>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <fo:leader leader-pattern="dots"/>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <fo:page-number-citation ref-id="adminInfo"/>
                </fo:block>
            </xsl:if>
            
            <xsl:if test="/ead:ead/ead:archdesc/ead:did/ead:physdesc[@label = 'General Physical Description note']">
                <fo:block text-align-last="justify">
                    <fo:basic-link internal-destination="physdesc">Physical Description of Material</fo:basic-link>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <fo:leader leader-pattern="dots"/>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <fo:page-number-citation ref-id="physdesc"/>
                </fo:block> 
            </xsl:if>
            <xsl:for-each select="/ead:ead/ead:archdesc/ead:dsc">
                <xsl:if test="child::*">
                    <fo:block text-align-last="justify">
                        <fo:basic-link>
                            <xsl:call-template name="printtocLinks"/>Inventory</fo:basic-link>
                        <xsl:text>&#160;&#160;</xsl:text>
                        <fo:leader leader-pattern="dots"/>
                        <xsl:text>&#160;&#160;</xsl:text>
                        <xsl:call-template name="tocPage"/>
                    </fo:block>
                </xsl:if>

                <!--Creates a submenu for collections, record groups and series and fonds-->
                <xsl:for-each select="child::*[@level = 'collection']  | child::*[@level = 'recordgrp']  | child::*[@level = 'series'] | child::*[@level = 'fonds']">
                    <fo:block text-align-last="justify" margin-left="18pt">
                        <fo:basic-link>
                            <xsl:call-template name="printtocLinks"/>
                            <!-- 8/21/11 WS for RA: Added series headings -->
                            <xsl:if test="child::*/ead:unitid">
                                <xsl:choose>
                                    <xsl:when test="@level='series'">Series <xsl:value-of select="child::*/ead:unitid"/>: </xsl:when>
                                    <xsl:when test="@level='subseries'">Subseries <xsl:value-of select="child::*/ead:unitid"/>: </xsl:when>
                                    <xsl:when test="@level='collection'">Collection <xsl:value-of select="child::*/ead:unitid"/>: </xsl:when>
                                    <xsl:when test="@level='subcollection'">Subcollection <xsl:value-of select="child::*/ead:unitid"/>: </xsl:when>
                                    <xsl:when test="@level='fonds'">Fonds <xsl:value-of select="child::*/ead:unitid"/>: </xsl:when>
                                    <xsl:when test="@level='subfonds'">Subfonds <xsl:value-of select="child::*/ead:unitid"/>: </xsl:when>
                                    <xsl:when test="@level='recordgrp'">Record Group <xsl:value-of select="child::*/ead:unitid"/>: </xsl:when>
                                    <xsl:when test="@level='subgrp'">Subgroup <xsl:value-of select="child::*/ead:unitid"/>: </xsl:when>
                                    <xsl:otherwise><xsl:value-of select="child::*/ead:unitid"/>: </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                            <xsl:apply-templates select="child::*/ead:unittitle"/>
                        </fo:basic-link>
                        <xsl:text>&#160;&#160;</xsl:text>
                        <fo:leader leader-pattern="dots"/>
                        <xsl:text>&#160;&#160;</xsl:text>
                        <xsl:call-template name="tocPage"/>
                    </fo:block>
                </xsl:for-each>
            </xsl:for-each>
        </fo:block>
    </xsl:template>

    <!-- Template generates the page numbers for the table of contents -->
    <xsl:template name="tocPage">
        <fo:page-number-citation>
            <xsl:attribute name="ref-id">
                <xsl:choose>
                    <xsl:when test="self::*/@id">
                        <xsl:value-of select="@id"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="generate-id(.)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </fo:page-number-citation>
    </xsl:template>

    <!--Orders the how ead elements appear in the PDF, order matches Table of Contents.  -->
    <xsl:template match="ead:archdesc" mode="print">
        <!-- Summary Information, summary information includes citation -->
        <xsl:if test="/ead:ead/ead:archdesc/ead:scopecontent">
            <fo:block>
                <fo:marker marker-class-name="title">Collection Description</fo:marker>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:scopecontent" mode="print"/>
            </fo:block>
        </xsl:if>
        <xsl:if test="/ead:ead/ead:archdesc/ead:relatedmaterial or /ead:ead/ead:archdesc/ead:separatedmaterial
            or /ead:ead/ead:archdesc/ead:accessrestrict or /ead:ead/ead:archdesc/ead:userestrict
            or /ead:ead/ead:archdesc/ead:phystech or /ead:ead/ead:archdesc/ead:prefercite
            or /ead:ead/ead:archdesc/ead:otherfindaid">
            <fo:block>
                <fo:marker marker-class-name="title">Access and Use</fo:marker>
                <fo:block font-size="14pt" space-before="18pt" padding-bottom="-2pt" space-after="18pt" color="black" padding-after="1pt" padding-before="24pt" border-bottom="1pt solid #000" id="relMat">Access and Use</fo:block>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:did/ead:physloc" mode="print"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:accessrestrict" mode="print"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:userestrict" mode="print"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:phystech" mode="print"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:prefercite" mode="print"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:otherfindaid" mode="print"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:relatedmaterial" mode="print"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:altformavail" mode="print"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:originalsloc" mode="print"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:bibliography" mode="print"/>
            </fo:block>
        </xsl:if>
        <xsl:if test="/ead:ead/ead:archdesc/ead:arrangement">
            <fo:block>
                <fo:marker marker-class-name="title">Arrangement</fo:marker>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:arrangement" mode="print"/>
            </fo:block>
        </xsl:if>        
        <xsl:if test="/ead:ead/ead:archdesc/ead:bioghist">
            <fo:block>
                <fo:marker marker-class-name="title">Biographical/Historical Note</fo:marker>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:bioghist" mode="print"/>
            </fo:block>
        </xsl:if>
        <xsl:if test="/ead:ead/ead:archdesc/ead:controlaccess">
            <fo:block>
                <fo:marker marker-class-name="title">Controlled Access Headings</fo:marker>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:controlaccess" mode="print"/>
            </fo:block>
        </xsl:if>
        <!-- Administrative Information  -->
        <xsl:if test="/ead:ead/ead:archdesc/ead:custodhist or
            /ead:ead/ead:archdesc/ead:accruals or
            /ead:ead/ead:archdesc/ead:altformavail or
            /ead:ead/ead:archdesc/ead:acqinfo or
            /ead:ead/ead:archdesc/ead:processinfo or
            /ead:ead/ead:archdesc/ead:appraisal or /ead:ead/ead:eadheader/ead:filedesc/ead:publicationstmt | /ead:ead/ead:eadheader/ead:revisiondesc">
            <fo:block>
                <fo:marker marker-class-name="title">Administrative Information</fo:marker>
                <fo:block font-size="14pt" space-before="18pt" padding-bottom="-2pt" space-after="18pt" color="black" padding-after="1pt" padding-before="24pt"
                    border-bottom="1pt solid #000" id="adminInfo"> Administrative Information </fo:block>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:acqinfo" mode="print"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:fileplan" mode="print"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:custodhist" mode="print"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:accruals" mode="print"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:processinfo" mode="print"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:appraisal" mode="print"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:separatedmaterial" mode="print"/>
            </fo:block>
        </xsl:if>
        <xsl:if test="/ead:ead/ead:archdesc/ead:did/ead:physdesc[@label = 'General Physical Description note']">
            <fo:block>
                <fo:marker marker-class-name="title">Physical Description of Material</fo:marker>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:did/ead:physdesc[@label = 'General Physical Description note']" mode="print"/>
           </fo:block>     
        </xsl:if>
        <!-- <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:index"/>-->
        
        <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:dsc" mode="print"/>    
    </xsl:template>
    
    <!-- Summary Information, generated from ead:archdesc/ead:did -->
    <xsl:template match="ead:archdesc/ead:did" mode="print">
        <fo:block break-after="page">
            <fo:block font-size="14pt" space-before="18pt" padding-bottom="-2pt" space-after="18pt" color="black" padding-before="24pt" border-bottom="1pt solid #000" id="{generate-id(.)}">
                <xsl:choose>
                    <xsl:when test="ead:head">
                        <xsl:value-of select="ead:head"/>
                    </xsl:when>
                    <xsl:otherwise>Overview</xsl:otherwise>
                </xsl:choose>
            </fo:block>
            <fo:table space-before="0.1in" table-layout="fixed" width="100%">
                <fo:table-column column-width="2in"/>
                <fo:table-column column-width="5in"/>
                <fo:table-body>
                    <!-- Determines the order in wich elements from the archdesc did appear,  to change the order of appearance for the children of did
                         by changing the order of the following statements.-->
                    <xsl:apply-templates select="ead:repository" mode="printOverview"/>
                    <xsl:apply-templates select="ead:origination[starts-with(child::*/@role,'Author')]" mode="printOverview"/>
                    <xsl:apply-templates select="ead:unittitle" mode="printOverview"/>
                    <!-- 8/14/11 WS: Reformated dates to be called all in one row -->
                    <xsl:call-template name="printarchdescUnitdate"/>
                    <xsl:apply-templates select="ead:physdesc[ead:extent]" mode="printOverview"/>
                    <xsl:apply-templates select="ead:physloc" mode="printOverview"/>
                    <xsl:apply-templates select="ead:langmaterial" mode="printOverview"/>
                    <xsl:apply-templates select="ead:materialspec" mode="printOverview"/>
                    <xsl:apply-templates select="ead:container" mode="printOverview"/>
                    <xsl:apply-templates select="ead:abstract" mode="printOverview"/>
                    <xsl:apply-templates select="ead:note" mode="printOverview"/>
                </fo:table-body>
            </fo:table>
            <!--8/14/11 WS for RA: removed prefered citation  -->
            <!--<xsl:apply-templates select="../ead:prefercite"/>-->
            <!--8/14/11 WS for RA: Added test to check for restrictions  -->
            <xsl:if test="../ead:accessrestrict">
                <fo:block color="#990000" font-size="10pt" text-align="center" space-before="24pt">
                    *Restrictions Apply. Please see the Access and Use section for more details.*
                </fo:block>
            </xsl:if>
        </fo:block>
    </xsl:template>

    <!-- Template calls and formats the children of archdesc/did -->
    <xsl:template  match="ead:archdesc/ead:did/ead:repository | ead:archdesc/ead:did/ead:unittitle | ead:archdesc/ead:did/ead:unitid | ead:archdesc/ead:did/ead:origination[starts-with(child::*/@role,'Author')] 
        | ead:archdesc/ead:did/ead:unitdate | ead:archdesc/ead:did/ead:physdesc | ead:archdesc/ead:did/ead:physloc 
        | ead:archdesc/ead:did/ead:abstract | ead:archdesc/ead:did/ead:langmaterial | ead:archdesc/ead:did/ead:container" mode="printOverview">
        <fo:table-row>
            <fo:table-cell padding-bottom="2pt">
                <fo:block font-weight="bold" color="#111">
                    <xsl:choose>
                        <xsl:when test="self::ead:repository">Repository:</xsl:when>
                        <xsl:when test="self::ead:unittitle">Title:</xsl:when>
                        <xsl:when test="self::ead:unitid">Resource ID:</xsl:when>
                        <xsl:when test="self::ead:unitdate">Date<xsl:if test="@type">
                            [<xsl:value-of select="@type"/>]</xsl:if>:</xsl:when>
                        <xsl:when test="self::ead:origination">Creator:                                
                        </xsl:when>                       
                        <xsl:when test="self::ead:physdesc[ead:extent]">Extent:</xsl:when>
                        <xsl:when test="self::ead:abstract">Abstract:</xsl:when>
                        <xsl:when test="self::ead:physloc">Location:</xsl:when>
                        <xsl:when test="self::ead:langmaterial">Language:</xsl:when>
                        <xsl:when test="self::ead:materialspec">Material Specific Details:</xsl:when>
                        <xsl:when test="self::ead:container">Container:</xsl:when>
                        <xsl:when test="self::ead:note">General Note:</xsl:when>
                    </xsl:choose>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell padding-bottom="2pt">
                <fo:block>
                    <!-- 9/17/11 WS for RA: Added choose statement to suppress creators not listed as 'authors' -->
                    <xsl:choose>
                        <xsl:when test="self::ead:origination">
                            <xsl:choose>
                                <xsl:when test="not(starts-with(child::*/@role,'Author'))"/>
                                <xsl:otherwise><xsl:apply-templates mode="print"/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <!-- 10/30/11 WS for RA: addeds comma if there is a second extent in a single physdesc element -->
                        <xsl:when test="self::ead:physdesc[ead:extent]">
                            <xsl:value-of select="ead:extent[1]"/>
                            <xsl:if test="ead:extent[position() &gt; 1]">, <xsl:value-of select="ead:extent[position() &gt; 1]"/> </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates mode="print"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
        <xsl:if test="self::ead:repository">
            <fo:table-row>
                <fo:table-cell padding-bottom="2pt">
                    <fo:block font-weight="bold" color="#111"> Resource ID: </fo:block>
                </fo:table-cell>
                <fo:table-cell padding-bottom="2pt">
                    <fo:block>
                        <xsl:value-of select="../ead:unitid"/>
                    </fo:block>
                </fo:table-cell>
            </fo:table-row>
        </xsl:if>
    </xsl:template>
    <!-- 8/14/11 WS for RA: Added named template to handle date display in overview -->
    <xsl:template name="printarchdescUnitdate">
        <fo:table-row>
            <fo:table-cell padding-bottom="2pt">
                <fo:block font-weight="bold" color="#111"> Date(s) </fo:block>
            </fo:table-cell>
            <fo:table-cell padding-bottom="2pt">
                <fo:block>
                    <xsl:value-of select="ead:unitdate[@type='inclusive']"/>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>

    <!-- Template calls and formats all other children of archdesc many of 
        these elements are repeatable within the ead:dsc section as well.-->
    <xsl:template match="ead:odd | ead:arrangement  | ead:bioghist 
        | ead:accessrestrict | ead:userestrict  | ead:custodhist | ead:altformavail | ead:originalsloc 
        | ead:fileplan | ead:acqinfo | ead:otherfindaid | ead:phystech | ead:processinfo | ead:relatedmaterial
        | ead:scopecontent  | ead:separatedmaterial | ead:appraisal | ead:materialspec" mode="print">
        <xsl:choose>
            <xsl:when test="parent::ead:archdesc">
                <xsl:choose>
                    <xsl:when test="self::ead:odd">
                        <fo:block font-size="14pt" space-before="18pt" padding-bottom="-2pt" space-after="18pt" color="black" padding-after="1pt" padding-before="24pt" border-bottom="1pt solid #000">
                            <xsl:call-template name="printAnchor"/>General Note</fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:arrangement">
                        <fo:block font-size="14pt" space-before="18pt" padding-bottom="-2pt" space-after="18pt" color="black" padding-after="1pt" padding-before="24pt" border-bottom="1pt solid #000">
                            <xsl:call-template name="printAnchor"/>Arrangement</fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:bioghist">
                        <fo:block font-size="14pt" space-before="18pt" padding-bottom="-2pt" space-after="18pt" color="black" padding-after="1pt" padding-before="24pt" border-bottom="1pt solid #000">
                            <xsl:call-template name="printAnchor"/>Biographical/Historical Note</fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:accessrestrict">
                        <xsl:choose>
                            <xsl:when test="ead:legalstatus"/>
                            <xsl:otherwise>
                                <fo:block space-before="18pt" font-weight="bold" color="#111">
                                    <xsl:call-template name="printAnchor"/>Access Restrictions</fo:block>
                            </xsl:otherwise>
                        </xsl:choose>                        
                    </xsl:when>
                    <xsl:when test="self::ead:userestrict">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="printAnchor"/>Use Restrictions</fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:custodhist">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="printAnchor"/>Custodial History</fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:altformavail">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="printAnchor"/>Location of Copies</fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:originalsloc">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="printAnchor"/>Location of Originals</fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:fileplan">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="printAnchor"/>File Plan</fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:acqinfo">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="printAnchor"/>Acquisition Information</fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:otherfindaid">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="printAnchor"/>Other Finding Aids</fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:phystech">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="printAnchor"/>Physical Characteristics and Technical Requirements </fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:processinfo">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="printAnchor"/>Processing Information</fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:relatedmaterial">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="printAnchor"/>Related Archival Materials</fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:separatedmaterial">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="printAnchor"/>Separated Materials</fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:appraisal">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="printAnchor"/>Appraisal</fo:block>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <fo:block font-weight="bold" color="#111">
                    <xsl:choose>
                        <xsl:when test="self::ead:odd">General Note</xsl:when>
                        <xsl:when test="self::ead:arrangement">Arrangement</xsl:when>
                        <xsl:when test="self::ead:bioghist">Biographical/Historical Note</xsl:when>
                        <xsl:when test="self::ead:accessrestrict">
                            <xsl:choose>
                                <xsl:when test="ead:legalstatus"/>
                                <xsl:otherwise>
                                    Access Restrictions                                    
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="self::ead:userestrict">Use Restrictions</xsl:when>
                        <xsl:when test="self::ead:custodhist">Custodial History</xsl:when>
                        <xsl:when test="self::ead:altformavail">Location of Copies</xsl:when>
                        <xsl:when test="self::ead:originalsloc">Location of Originals</xsl:when>
                        <xsl:when test="self::ead:fileplan">File Plan</xsl:when>
                        <xsl:when test="self::ead:acqinfo">Acquisition Information</xsl:when>
                        <xsl:when test="self::ead:otherfindaid">Other Finding Aids</xsl:when>
                        <xsl:when test="self::ead:phystech">Physical Characteristics and Technical Requirements</xsl:when>
                        <xsl:when test="self::ead:processinfo">Processing Information</xsl:when>
                        <xsl:when test="self::ead:relatedmaterial">Related Archival Materials</xsl:when>
                        <xsl:when test="self::ead:separatedmaterial">Separated Materials</xsl:when>
                        <xsl:when test="self::ead:appraisal">Appraisal</xsl:when>
                        <xsl:when test="self::ead:materialspec">Material Specific Details</xsl:when>
                    </xsl:choose>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="self::ead:bioghist">
                <fo:block space-after="12pt">
                    <xsl:apply-templates select="ead:p" mode="print"/>
                    <xsl:apply-templates select="child::*[name() != 'head' and name() != 'p']" mode="print"/>
                </fo:block>
            </xsl:when>
            <xsl:when test="self::ead:materialspec">
                <fo:block space-after="12pt">
                    <xsl:apply-templates mode="print"/>
                </fo:block>
            </xsl:when>
            <xsl:otherwise>
                <fo:block space-after="12pt">
                    <xsl:apply-templates select="child::*[name() != 'head']" mode="print"/>
                </fo:block>                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- 11/2/11 WS for RA: templates added for special handeling of physdesc notes and language -->
    <xsl:template match="ead:physdesc" mode="print">
        <xsl:choose>
            <xsl:when test="@label = 'General Physical Description note'">
                <xsl:choose>
                    <xsl:when test="parent::*/parent::ead:archdesc">
                        <fo:block space-after="12pt">
                            <fo:block font-size="14pt" space-before="18pt" padding-bottom="-2pt"
                                space-after="18pt" color="black" padding-after="1pt" padding-before="24pt"
                                border-bottom="1pt solid #000" id="physdesc">Physical Description of Material </fo:block>
                            <xsl:apply-templates mode="print"/>    
                        </fo:block>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:block space-after="12pt">
                            <fo:block font-weight="bold">Physical Description of Material </fo:block>
                            <xsl:apply-templates mode="print"/>
                        </fo:block>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="@label='Physical Facet note'">
                <xsl:apply-templates mode="print"/>
            </xsl:when>
            <xsl:when test="ead:dimensions">
                <fo:block space-after="12pt">
                    <fo:block font-weight="bold">Dimensions</fo:block>
                    <xsl:apply-templates select="*[not(ead:head)]" mode="print"/>
                </fo:block>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="print"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="ead:langmaterial">
        <fo:block space-after="12pt">
            <fo:block font-weight="bold">Language</fo:block>
            <xsl:apply-templates mode="print"/>
        </fo:block>
    </xsl:template>
    
    <!-- 10/30/11 WS for RA: added choose statment to print accruals and bibliography at collection level only-->
    <xsl:template match="ead:accruals | ead:bibliography" mode="print">
        <xsl:choose>
            <xsl:when test="parent::ead:archdesc">
                <xsl:choose>
                    <xsl:when test="self::ead:bibliography">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="printAnchor"/>Bibliography </fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:accruals">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="printAnchor"/>Accruals</fo:block>
                    </xsl:when>
                </xsl:choose>
                <fo:block space-after="12pt">
                    <xsl:apply-templates select="child::*[name() != 'head']" mode="print"/>
                </fo:block>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
   
    <!-- 10/30/11 WS for RA: Template to format scope and conents notes -->
    <xsl:template match="ead:scopecontent" mode="print">
        <xsl:choose>
            <xsl:when test="parent::ead:archdesc">        
                <fo:block font-size="14pt" space-before="18pt" padding-bottom="-2pt" space-after="18pt" color="black" padding-after="1pt" padding-before="24pt" border-bottom="1pt solid #000">
                    <xsl:call-template name="printAnchor"/>Collection Description 
                </fo:block>
            </xsl:when>
            <xsl:when test="parent::*[@level = 'recordgrp']"><fo:block font-weight="bold">Record Group Description</fo:block></xsl:when>
            <xsl:when test="parent::*[@level = 'subgrp']"><fo:block font-weight="bold">Subgroup Description</fo:block></xsl:when>
            <xsl:when test="parent::*[@level = 'collection']"><fo:block font-weight="bold">Collection Description</fo:block></xsl:when>
            <xsl:when test="parent::*[@level = 'fonds']"><fo:block font-weight="bold">Fonds Description</fo:block></xsl:when>
            <xsl:when test="parent::*[@level = 'subfonds']"><fo:block font-weight="bold">Sub-Fonds Description</fo:block></xsl:when>
            <xsl:when test="parent::*[@level = 'series']"><fo:block font-weight="bold">Series Description</fo:block></xsl:when>
            <xsl:when test="parent::*[@level = 'subseries']"><fo:block font-weight="bold">Subseries Description</fo:block></xsl:when>
            <xsl:when test="parent::*[@level = 'item']"><fo:block font-weight="bold">Item Description</fo:block></xsl:when>
            <xsl:when test="parent::*[@level = 'file']"><fo:block font-weight="bold">File Description</fo:block></xsl:when>
            <xsl:otherwise>
                <fo:block space-before="2pt" font-weight="bold" color="#111">Description</fo:block>
            </xsl:otherwise>
        </xsl:choose>
        <fo:block space-after="12pt">
            <xsl:apply-templates select="child::*[name() != 'head']" mode="print"/>
        </fo:block>
    </xsl:template>
    
    <!-- Templates for publication information  -->
    <xsl:template match="/ead:ead/ead:eadheader/ead:filedesc/ead:publicationstmt" mode="printadmin">
        <fo:block space-before="18pt" space-after="8pt" font-weight="bold" color="#111"> Publication Information</fo:block>
        <fo:block>
            <xsl:apply-templates select="ead:publisher" mode="print"/>
            <xsl:if test="ead:date">&#160;<xsl:apply-templates select="ead:date" mode="print"/></xsl:if>
        </fo:block>
    </xsl:template>
    
    <!-- Templates for revision description  -->
    <xsl:template match="/ead:ead/ead:eadheader/ead:revisiondesc" mode="printadmin">
        <fo:block space-before="18pt" space-after="8pt" font-weight="bold" color="#111">Revision Description</fo:block>
        <fo:block>
            <xsl:if test="ead:change/ead:item">
                <xsl:apply-templates select="ead:change/ead:item" mode="print"/>
            </xsl:if>
            <xsl:if test="ead:change/ead:date">&#160;<xsl:apply-templates select="ead:change/ead:date" mode="print"/></xsl:if>
        </fo:block>
    </xsl:template>
    
    <!-- 10/30/11 WS for RA: added template for ead:ead/ead:arcdesc/ead:did/ead:physloc -->
    <xsl:template match="/ead:ead/ead:archdesc/ead:did/ead:physloc" mode="print">
        <fo:block>                  
            <fo:block font-weight="bold" color="#111">Location</fo:block>                      
            <xsl:apply-templates mode="print"/>
        </fo:block>
    </xsl:template>  
    
    <!-- Formats prefered citiation -->
    <xsl:template match="ead:prefercite" mode="print">
        <!-- 10/30/11 WS for RA: added choose statment to print prefercite at collection level only-->
        <xsl:choose>
            <xsl:when test="parent::ead:archdesc">
                <fo:block>                  
                    <fo:block font-weight="bold" color="#111">Preferred Citation</fo:block>                      
                    <xsl:apply-templates select="child::*[not(name()='head')]" mode="print"/>
                </fo:block>                
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
        
    <!-- 9/12/11 WS for RA: added special template for preferred citation example paragraph -->
    <xsl:template match="ead:prefercite/ead:p[starts-with(.,'Example:')]" mode="print">
            <fo:block margin-left="24pt">
                <fo:block font-weight="bold">Example</fo:block>
                <fo:block><xsl:value-of select="substring-after(.,'Example: ')"/></fo:block>
            </fo:block>
    </xsl:template>
    <!-- Formats controlled access terms -->
   
    <!-- 8/16/11 WS for RA: Changed grouping for RA specified display -->
    <xsl:template match="ead:controlaccess" mode="print"> 
        <xsl:choose>
            <xsl:when test="parent::ead:archdesc">
                <fo:block font-size="14pt" space-before="18pt" padding-bottom="-2pt" space-after="8pt" color="black" padding-after="1pt" padding-before="24pt"
                    border-bottom="1pt solid #000" id="{generate-id(.)}">Controlled Access Headings</fo:block>
            </xsl:when>
            <xsl:otherwise>
                <fo:block space-before="18pt" space-after="4pt" font-weight="bold" color="#111">Controlled Access Headings</fo:block>
            </xsl:otherwise>
        </xsl:choose>
        <!-- 8/17/11 WS for RA: Changed grouping for controlaccess -->
        <xsl:if test="ead:corpname or ead:famname or ead:famname or ead:persname">
            <fo:block space-before="8pt" font-variant="small-caps" font-weight="bold" color="#111"
                padding-after="8pt" padding-before="8pt"> Name(s) </fo:block>
            <fo:list-block margin-bottom="8pt" margin-left="8pt">                        
                <xsl:for-each select="ead:corpname | ead:famname | ead:persname  | /ead:ead/ead:archdesc/ead:did/ead:origination/ead:corpname | /ead:ead/ead:archdesc/ead:did/ead:origination/ead:famname | /ead:ead/ead:archdesc/ead:did/ead:origination/ead:persname">
                    <fo:list-item>
                        <fo:list-item-label end-indent="24pt">
                            <fo:block> </fo:block>
                        </fo:list-item-label>
                        <fo:list-item-body start-indent="24pt">
                            <fo:block>
                                <xsl:apply-templates mode="print"/>
                            </fo:block>
                        </fo:list-item-body>
                    </fo:list-item>
                </xsl:for-each>
           </fo:list-block>
        </xsl:if> 
        <xsl:if test="ead:genreform">
            <fo:block space-before="8pt" font-variant="small-caps" font-weight="bold" color="#111"
                padding-after="8pt" padding-before="8pt"> Genre/Form</fo:block>
            <fo:list-block margin-bottom="8pt" margin-left="8pt">
                <xsl:for-each select="ead:genreform">
                    <fo:list-item>
                        <fo:list-item-label end-indent="24pt">
                            <fo:block> </fo:block>
                        </fo:list-item-label>
                        <fo:list-item-body start-indent="24pt">
                            <fo:block>
                                <xsl:apply-templates mode="print"/>
                            </fo:block>
                        </fo:list-item-body>
                    </fo:list-item>
                </xsl:for-each>
            </fo:list-block>
        </xsl:if>
        <xsl:if test="ead:subject or ead:function or ead:occupation or ead:geogname or ead:title or ead:name">
            <fo:block space-before="8pt" font-variant="small-caps" font-weight="bold" color="#111"
                padding-after="8pt" padding-before="8pt"> Subject(s)</fo:block>
            <fo:list-block margin-bottom="8pt" margin-left="8pt">
                <xsl:for-each select="ead:subject | ead:function | ead:occupation | ead:geogname | ead:title | ead:name">
                    <fo:list-item>
                        <fo:list-item-label end-indent="24pt">
                            <fo:block> </fo:block>
                        </fo:list-item-label>
                        <fo:list-item-body start-indent="24pt">
                            <fo:block>
                                <xsl:apply-templates mode="print"/>
                            </fo:block>
                        </fo:list-item-body>
                    </fo:list-item>
                </xsl:for-each>
            </fo:list-block>
        </xsl:if>
    </xsl:template>

    <!-- 11/1/11 WS for RA: Added special template for inventory list -->
    <xsl:template match="ead:controlaccess[ancestor::ead:dsc]" mode="print">       
        <fo:block space-before="12pt" space-after="4pt" font-weight="bold" color="#111">Controlled Access Headings</fo:block>
        <fo:block margin-left="8pt">
        <xsl:if test="ead:corpname or ead:famname or ead:famname or ead:persname">
            <fo:block space-before="8pt" font-variant="small-caps" font-weight="bold"  color="#111">Name(s) </fo:block>
            <fo:list-block margin-bottom="8pt">
                <xsl:for-each select="ead:corpname | ead:famname | ead:persname | 
                    ../ead:did/ead:origination/ead:corpname | ../ead:did/ead:origination/ead:famname | ../ead:did/ead:origination/ead:persname">
                    <fo:list-item>
                        <fo:list-item-label>
                            <fo:block> </fo:block>
                        </fo:list-item-label>
                        <fo:list-item-body>
                            <fo:block>
                               <xsl:apply-templates mode="print"/>
                            </fo:block>
                        </fo:list-item-body>
                    </fo:list-item>
                </xsl:for-each>
            </fo:list-block>
        </xsl:if>
        <xsl:if test="ead:genreform">
            <fo:block space-before="8pt" font-variant="small-caps" 
                font-weight="bold"  color="#111">Genre/Form</fo:block>
            <fo:list-block margin-bottom="8pt">
                <xsl:for-each select="ead:genreform">
                    <fo:list-item>
                        <fo:list-item-label>
                            <fo:block> </fo:block>
                        </fo:list-item-label>
                        <fo:list-item-body>
                            <fo:block>
                                <xsl:apply-templates mode="print"/>
                            </fo:block>
                        </fo:list-item-body>
                    </fo:list-item>
                </xsl:for-each>
            </fo:list-block>
        </xsl:if>
        <xsl:if test="ead:subject or ead:function or ead:occupation or ead:geogname or ead:title or ead:name">
            <fo:block space-before="8pt" font-variant="small-caps" 
                font-weight="bold"  color="#111"> Subject(s)</fo:block>
            <fo:list-block margin-bottom="8pt">
                <xsl:for-each
                    select="ead:subject | ead:function | ead:occupation | ead:geogname | ead:title | ead:name">
                    <fo:list-item>
                        <fo:list-item-label>
                            <fo:block> </fo:block>
                        </fo:list-item-label>
                        <fo:list-item-body>
                            <fo:block>
                                <xsl:apply-templates mode="print"/>
                            </fo:block>
                        </fo:list-item-body>
                    </fo:list-item>
                </xsl:for-each>
            </fo:list-block>
        </xsl:if>
        </fo:block>
    </xsl:template>
    
    <!-- Formats index and child elements, groups indexentry elements by type (i.e. corpname, subject...)-->
    <!-- 10/30/11 WS for RA: removed ead:index -->
    <xsl:template match="ead:index" mode="print"/>    
    <xsl:template match="ead:indexentry" mode="print">
        <fo:block font-weight="bold">
            <xsl:apply-templates select="child::*[1]" mode="print"/>
        </fo:block>
        <fo:block margin-left="18pt">
            <xsl:apply-templates select="child::*[2]" mode="print"/>
        </fo:block>
    </xsl:template>
    <xsl:template match="ead:ptrgrp">
        <xsl:apply-templates mode="print"/>
    </xsl:template>

    <!-- Digital Archival Object -->
    <xsl:template match="ead:dao" mode="print">
        <xsl:choose>
            <xsl:when test="child::*">
                <xsl:apply-templates mode="print"/>
                <fo:basic-link external-destination="url('{@ns2:href}')" text-decoration="underline" color="blue"> [<xsl:value-of select="@ns2:href"/>]</fo:basic-link>
            </xsl:when>
            <xsl:otherwise>
                <fo:basic-link external-destination="url('{@ns2:href}')" text-decoration="underline" color="blue">
                    <xsl:value-of select="@ns2:href"/>
                </fo:basic-link>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Linking elements, ptr and ref. -->
    <xsl:template match="ead:ptr" mode="print">
        <xsl:choose>
            <xsl:when test="@target">
                <fo:basic-link internal-destination="{@target}" text-decoration="underline" color="blue">
                    <xsl:value-of select="@target"/>
                </fo:basic-link>
                <xsl:if test="following-sibling::ead:ptr">, </xsl:if>
            </xsl:when>
            <xsl:when test="@ns2:href">
                <fo:basic-link internal-destination="{@ns2:href}" text-decoration="underline" color="blue">
                    <xsl:value-of select="@target"/>
                </fo:basic-link>
                <xsl:if test="following-sibling::ead:ptr">, </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="print"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="ead:ref" mode="print">
        <xsl:choose>
            <xsl:when test="@target">
                <fo:basic-link internal-destination="{@target}" text-decoration="underline" color="blue">
                    <xsl:value-of select="@target"/>
                </fo:basic-link>
                <xsl:if test="following-sibling::ead:ref">, </xsl:if>
            </xsl:when>
            <xsl:when test="@ns2:href">
                <fo:basic-link internal-destination="{@ns2:href}" text-decoration="underline" color="blue">
                    <xsl:value-of select="@target"/>
                </fo:basic-link>
                <xsl:if test="following-sibling::ead:ref">, </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- 8/16/11 WS for AR: added extref template -->
    <xsl:template match="ead:extref" mode="print">
        <xsl:choose>
            <xsl:when test="@target">
                <fo:basic-link external-destination="{@target}" text-decoration="underline" color="blue">
                    <xsl:value-of select="@target"/>
                </fo:basic-link>
                <xsl:if test="following-sibling::ead:extref">, </xsl:if>
            </xsl:when>
            <xsl:when test="@ns2:href">
                <fo:basic-link external-destination="{@ns2:href}" text-decoration="underline" color="blue">
                    <xsl:value-of select="."/>
                </fo:basic-link>
                <xsl:if test="following-sibling::ead:extref">, </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="print"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--Creates a hidden anchor tag that allows navigation within the finding aid. 
        In this stylesheet only children of the archdesc and c0* itmes call this template. 
        It can be applied anywhere in the stylesheet as the id attribute is universal. -->
    <xsl:template match="@id" mode="print">
        <xsl:attribute name="id">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="printAnchor">
        <xsl:choose>
            <xsl:when test="@id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="id">
                    <xsl:value-of select="generate-id(.)"/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="printtocLinks">
        <xsl:attribute name="internal-destination">
            <xsl:choose>
                <xsl:when test="self::*/@id">
                    <xsl:value-of select="@id"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="generate-id(.)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>

    <!-- 9/19/11 WS added for RA -->
    <xsl:template match="ead:legalstatus" mode="print">
        <fo:block space-after="12pt">
            <fo:block font-weight="bold">Access Restrictions / Legal Status</fo:block>
            <fo:block><xsl:apply-templates mode="print"/></fo:block>
        </fo:block>
    </xsl:template>
    <xsl:template match="ead:physfacet" mode="print">
        <fo:block space-after="12pt">
            <fo:block font-weight="bold">Physical Facet Note</fo:block>
            <fo:block><xsl:apply-templates mode="print"/></fo:block>
        </fo:block>
    </xsl:template>
    <!-- Formats headings throughout the finding aid -->
    <xsl:template match="ead:head[parent::*/parent::ead:archdesc]" mode="print">
        <xsl:choose>
            <xsl:when test="parent::ead:accessrestrict or parent::ead:userestrict or
                parent::ead:custodhist or parent::ead:accruals or
                parent::ead:altformavail or parent::ead:acqinfo or 
                parent::ead:processinfo or parent::ead:appraisal or parent::ead:fileplan or
                parent::ead:originalsloc or parent::ead:phystech or parent::eadotherfindaid or
                parent::ead:relatedmaterial or parent::ead:separatedmaterial">
                <fo:block space-before="18pt" space-after="4pt" font-weight="bold" color="#111">
                    <xsl:choose>
                        <xsl:when test="parent::*/@id">
                            <xsl:attribute name="id">
                                <xsl:value-of select="parent::*/@id"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="id">
                                <xsl:value-of select="generate-id(parent::*)"/>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:apply-templates mode="print"/>
                </fo:block>
            </xsl:when>
            <xsl:when test="parent::ead:prefercite">
                <fo:block space-before="4pt" space-after="8pt" font-weight="bold" color="#111">
                    <xsl:choose>
                        <xsl:when test="parent::*/@id">
                            <xsl:attribute name="id">
                                <xsl:value-of select="parent::*/@id"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="id">
                                <xsl:value-of select="generate-id(parent::*)"/>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:apply-templates mode="print"/>
                </fo:block>
            </xsl:when>
            <xsl:otherwise>
                <fo:block font-size="14pt" space-before="18pt" padding-bottom="-2pt"
                    space-after="18pt" color="black" padding-after="1pt" padding-before="24pt"
                    border-bottom="1pt solid #000">
                    <xsl:choose>
                        <xsl:when test="parent::*/@id">
                            <xsl:attribute name="id">
                                <xsl:value-of select="parent::*/@id"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="id">
                                <xsl:value-of select="generate-id(parent::*)"/>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:apply-templates mode="print"/>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- 8/17/11 WS for RA: Added new header formating for display within inventory -->
    <xsl:template match="ead:head[ancestor-or-self::ead:dsc]" mode="print">
        <fo:block space-before="8pt" font-weight="bold" color="#111">
            <xsl:apply-templates mode="print"/>
        </fo:block>
    </xsl:template>
    <xsl:template match="ead:head" mode="print">
        <fo:block space-before="18pt" space-after="8pt" font-weight="bold" color="#111">
            <xsl:apply-templates mode="print"/>
        </fo:block>
    </xsl:template>

    <!--Bibref, choose statement decides if the citation is inline, if there is a parent element
        or if it is its own line, typically when it is a child of the bibliography element.-->
    <xsl:template match="ead:bibref" mode="print">
        <xsl:choose>
            <xsl:when test="parent::ead:p">
                <xsl:choose>
                    <xsl:when test="@ns2:href">
                        <fo:basic-link external-destination="url('{@ns2:href}')">
                            <xsl:apply-templates mode="print"/>
                        </fo:basic-link>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates mode="print"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <fo:block margin-bottom="8pt">
                    <xsl:choose>
                        <xsl:when test="@ns2:href">
                            <fo:basic-link external-destination="url('{@ns2:href}')">
                                <xsl:apply-templates mode="print"/>
                            </fo:basic-link>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates mode="print"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Puts a space between sibling elements -->
    <xsl:template match="child::*" mode="print">
        <xsl:if test="preceding-sibling::*">&#160;</xsl:if>
        <xsl:apply-templates mode="print"/>
    </xsl:template>

    <xsl:template match="ead:p" mode="print">
        <fo:block margin-bottom="8pt">
            <xsl:apply-templates mode="print"/>
        </fo:block>
    </xsl:template>

    <!--Formats a simple table. The width of each column is defined by the colwidth attribute in a colspec element.-->
    <xsl:template match="ead:table" mode="print">
        <xsl:for-each select="tgroup">
            <fo:table table-layout="fixed" width="100%" space-after="24pt" space-before="36pt" font-size="12pt" line-height="18pt" border-top="1pt solid #000" border-bottom="1pt solid #000">
                <xsl:for-each select="ead:colspec">
                    <fo:table-column column-width="{@colwidth}"/>
                </xsl:for-each>
                <fo:table-body>
                    <xsl:for-each select="ead:thead">
                        <xsl:for-each select="ead:row">
                            <fo:table-row>
                                <xsl:for-each select="ead:entry">
                                    <fo:table-cell border="1pt solid #fff" background-color="#000"
                                        padding="8pt">
                                        <fo:block font-size="14pt" font-weight="bold" color="#111">
                                            <xsl:value-of select="."/>
                                        </fo:block>
                                    </fo:table-cell>
                                </xsl:for-each>
                            </fo:table-row>
                        </xsl:for-each>
                    </xsl:for-each>
                    <xsl:for-each select="ead:tbody">
                        <xsl:for-each select="ead:row">
                            <fo:table-row>
                                <xsl:for-each select="ead:entry">
                                    <fo:table-cell padding="8pt">
                                        <fo:block>
                                            <xsl:value-of select="."/>
                                        </fo:block>
                                    </fo:table-cell>
                                </xsl:for-each>
                            </fo:table-row>
                        </xsl:for-each>
                    </xsl:for-each>
                </fo:table-body>
            </fo:table>
        </xsl:for-each>
    </xsl:template>
    <!-- Formats unitdates and dates -->
    <xsl:template match="ead:unitdate" mode="print">
        <xsl:if test="preceding-sibling::*">&#160;</xsl:if>
        <xsl:choose>
            <xsl:when test="@type = 'bulk'"> (<xsl:apply-templates mode="print"/>) </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="print"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="ead:date" mode="print">
        <xsl:apply-templates mode="print"/>
    </xsl:template>
    <!-- Formats unitTitle -->
    <xsl:template match="ead:unittitle" mode="print">
        <xsl:choose>
            <xsl:when test="child::ead:unitdate[@type='bulk']">
                <xsl:apply-templates select="node()[not(self::ead:unitdate[@type='bulk'])]" mode="print"/>
                <xsl:apply-templates select="ead:date[@type='bulk']" mode="print"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="print"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Following five templates output chronlist and children in a table -->
    <xsl:template match="ead:chronlist" mode="print">
        <fo:table table-layout="fixed" width="100%" space-before="14pt" line-height="18pt" border-top="1pt solid #000" border-bottom="1pt solid #000" space-after="24pt">
            <fo:table-body>
                <xsl:apply-templates mode="print"/>
            </fo:table-body>
        </fo:table>
    </xsl:template>
    <xsl:template match="ead:chronlist/ead:listhead" mode="print">
        <fo:table-row>
            <fo:table-cell border="1pt solid #fff" background-color="#000" padding="4pt">
                <fo:block font-weight="bold" color="#fff">
                    <xsl:apply-templates select="ead:head01" mode="print"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell border="1pt solid #fff" background-color="#000" padding="4pt">
                <fo:block font-size="14pt" font-weight="bold" color="#fff">
                    <xsl:apply-templates select="ead:head02" mode="print"/>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>
    <xsl:template match="ead:chronlist/ead:head" mode="print">
        <fo:table-row>
            <fo:table-cell border="1pt solid #fff" background-color="#000" number-columns-spanned="2" padding="4pt">
                <fo:block font-weight="bold" color="#fff">
                    <xsl:apply-templates mode="print"/>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>
    <xsl:template match="ead:chronitem" mode="print">
        <fo:table-row>
            <xsl:attribute name="background-color">
                <xsl:choose>
                    <xsl:when test="(position() mod 2 = 0)">#eee</xsl:when>
                    <xsl:otherwise>#fff</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <fo:table-cell>
                <fo:block margin-left=".15in">
                    <xsl:apply-templates select="ead:date" mode="print"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block>
                    <xsl:apply-templates select="descendant::ead:event" mode="print"/>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>
    <xsl:template match="ead:event" mode="print">
        <xsl:choose>
            <xsl:when test="following-sibling::*">
                <fo:block>
                    <xsl:apply-templates mode="print"/>
                </fo:block>
                <fo:block/>
            </xsl:when>
            <xsl:otherwise>
                <fo:block>
                    <xsl:apply-templates mode="print"/>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <!-- Output for a variety of list types -->
    <xsl:template match="ead:list" mode="print">
        <xsl:if test="ead:head">
            <fo:block space-before="18pt" space-after="4pt" font-weight="bold" color="#111">
                <xsl:value-of select="ead:head"/>
            </fo:block>
        </xsl:if>
        <fo:list-block margin-bottom="8pt" margin-left="8pt">
            <xsl:apply-templates mode="print"/>
        </fo:list-block>
    </xsl:template>
    <xsl:template match="ead:list/ead:head" mode="print"/>
    <xsl:template match="ead:list/ead:item" mode="print">
        <xsl:choose>
            <xsl:when test="parent::*/@type = 'ordered'">
                <xsl:choose>
                    <xsl:when test="parent::*/@numeration = 'arabic'">
                        <fo:list-item>
                            <fo:list-item-label end-indent="24pt">
                                <fo:block>
                                    <xsl:number format="1"/>
                                </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="24pt">
                                <fo:block>
                                    <xsl:apply-templates mode="print"/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:when>
                    <xsl:when test="parent::*/@numeration = 'upperalpha'">
                        <fo:list-item>
                            <fo:list-item-label end-indent="24pt">
                                <fo:block>
                                    <xsl:number format="A"/>
                                </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="24pt">
                                <fo:block>
                                    <xsl:apply-templates mode="print"/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:when>
                    <xsl:when test="parent::*/@numeration = 'loweralpha'">
                        <fo:list-item>
                            <fo:list-item-label end-indent="24pt">
                                <fo:block>
                                    <xsl:number format="a"/>
                                </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="24pt">
                                <fo:block>
                                    <xsl:apply-templates mode="print"/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:when>
                    <xsl:when test="parent::*/@numeration = 'upperroman'">
                        <fo:list-item>
                            <fo:list-item-label end-indent="24pt">
                                <fo:block>
                                    <xsl:number format="I"/>
                                </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="24pt">
                                <fo:block>
                                    <xsl:apply-templates mode="print"/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:when>
                    <xsl:when test="parent::*/@numeration = 'lowerroman'">
                        <fo:list-item>
                            <fo:list-item-label end-indent="24pt">
                                <fo:block>
                                    <xsl:number format="i"/>
                                </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="24pt">
                                <fo:block>
                                    <xsl:apply-templates mode="print"/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:list-item>
                            <fo:list-item-label end-indent="24pt">
                                <fo:block>
                                    <xsl:number format="1"/>
                                </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="24pt">
                                <fo:block>
                                    <xsl:apply-templates mode="print"/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="parent::*/@type='simple'">
                <fo:list-item>
                    <fo:list-item-label end-indent="24pt">
                        <fo:block>&#x2022;</fo:block>
                    </fo:list-item-label>
                    <fo:list-item-body start-indent="24pt">
                        <fo:block>
                            <xsl:apply-templates mode="print"/>
                        </fo:block>
                    </fo:list-item-body>
                </fo:list-item>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="parent::*/@numeration = 'arabic'">
                        <fo:list-item>
                            <fo:list-item-label end-indent="24pt">
                                <fo:block>
                                    <xsl:number format="1"/>
                                </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="24pt">
                                <fo:block>
                                    <xsl:apply-templates mode="print"/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:when>
                    <xsl:when test="parent::*/@numeration = 'upperalpha'">
                        <fo:list-item>
                            <fo:list-item-label end-indent="24pt">
                                <fo:block>
                                    <xsl:number format="A"/>
                                </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="24pt">
                                <fo:block>
                                    <xsl:apply-templates mode="print"/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:when>
                    <xsl:when test="parent::*/@numeration = 'loweralpha'">
                        <fo:list-item>
                            <fo:list-item-label end-indent="24pt">
                                <fo:block>
                                    <xsl:number format="a"/>
                                </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="24pt">
                                <fo:block>
                                    <xsl:apply-templates mode="print"/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:when>
                    <xsl:when test="parent::*/@numeration = 'upperroman'">
                        <fo:list-item>
                            <fo:list-item-label end-indent="24pt">
                                <fo:block>
                                    <xsl:number format="I"/>
                                </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="24pt">
                                <fo:block>
                                    <xsl:apply-templates mode="print"/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:when>
                    <xsl:when test="parent::*/@numeration = 'lowerroman'">
                        <fo:list-item>
                            <fo:list-item-label end-indent="24pt">
                                <fo:block>
                                    <xsl:number format="i"/>
                                </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="24pt">
                                <fo:block>
                                    <xsl:apply-templates mode="print"/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:list-item>
                            <fo:list-item-label end-indent="24pt">
                                <fo:block>&#x2022;</fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="24pt">
                                <fo:block>
                                    <xsl:apply-templates mode="print"/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="ead:defitem" mode="print">
        <fo:list-item>
            <fo:list-item-label>
                <fo:block/>
            </fo:list-item-label>
            <fo:list-item-body>
                <fo:block font-weight="bold">
                    <xsl:apply-templates select="ead:label" mode="print"/>
                </fo:block>
                <fo:block margin-left="18pt">
                    <xsl:apply-templates select="ead:item" mode="print"/>
                </fo:block>
            </fo:list-item-body>
        </fo:list-item>
    </xsl:template>

    <!-- Formats list as tabel if list has listhead element  -->
    <xsl:template match="ead:list[child::ead:listhead]" mode="print">
        <fo:table table-layout="fixed" space-before="24pt" space-after="24pt" line-height="18pt" width="4.5in" margin-left="8pt" border-top="1pt solid #000" border-bottom="1pt solid #000">
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell border="1pt solid #fff" background-color="#000" padding="8pt">
                        <fo:block font-size="14pt" font-weight="bold" color="#fff">
                            <xsl:apply-templates select="ead:listhead/ead:head01" mode="print"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="1pt solid #fff" background-color="#000" padding="8pt">
                        <fo:block font-size="14pt" font-weight="bold" color="#fff">
                            <xsl:apply-templates select="ead:listhead/ead:head02" mode="print"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <xsl:for-each select="ead:defitem">
                    <fo:table-row>
                        <fo:table-cell>
                            <fo:block margin-left="8pt">
                                <xsl:apply-templates select="ead:label" mode="print"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block margin-left="8pt">
                                <xsl:apply-templates select="ead:item" mode="print"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:for-each>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <!-- Formats notestmt and notes -->
    <xsl:template match="ead:notestmt" mode="print">
        <fo:block space-before="18pt" space-after="8pt" font-weight="bold" color="#111" id="{generate-id(.)}">General Note</fo:block>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="ead:note" mode="print">
        <xsl:choose>
            <xsl:when test="parent::ead:notestmt">
                <fo:block>
                    <xsl:apply-templates mode="print"/>
                </fo:block>
            </xsl:when>
            <xsl:when test="parent::ead:notestmt">
                <fo:block space-before="18pt" space-after="8pt" font-weight="bold" color="#111" id="{generate-id(.)}">               
                    Physical Description of Material
                </fo:block>
                <fo:block>
                    <xsl:apply-templates mode="print"/>
                </fo:block>            
            </xsl:when>
            <xsl:otherwise>
                <fo:block space-before="18pt" space-after="8pt" font-weight="bold" color="#111" id="{generate-id(.)}">               
                    General Note
                </fo:block>
                <fo:block>
                    <xsl:apply-templates mode="print"/>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Generic text display elements -->
    <xsl:template match="ead:lb" mode="print">
        <fo:block/>
    </xsl:template>
    <xsl:template match="ead:blockquote" mode="print">
        <fo:block margin="18pt">
            <xsl:apply-templates mode="print"/>
        </fo:block>
    </xsl:template>
    <xsl:template match="ead:emph" mode="print">
        <fo:inline font-style="italic">
            <xsl:apply-templates mode="print"/>
        </fo:inline>
    </xsl:template>

    <!--Render elements -->
    <xsl:template match="*[@render = 'bold'] | *[@altrender = 'bold'] " mode="print">
        <fo:inline font-weight="bold">
            <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>
            <xsl:apply-templates mode="print"/>
        </fo:inline>
    </xsl:template>
    <xsl:template match="*[@render = 'bolddoublequote'] | *[@altrender = 'bolddoublequote']" mode="print">
        <fo:inline font-weight="bold"><xsl:if test="preceding-sibling::*">
            &#160;</xsl:if>"<xsl:apply-templates mode="print"/>"</fo:inline>
    </xsl:template>
    <xsl:template match="*[@render = 'boldsinglequote'] | *[@altrender = 'boldsinglequote']" mode="print">
        <fo:inline font-weight="bold"><xsl:if test="preceding-sibling::*">
            &#160;</xsl:if>'<xsl:apply-templates mode="print"/>'</fo:inline>
    </xsl:template>
    <xsl:template match="*[@render = 'bolditalic'] | *[@altrender = 'bolditalic']" mode="print">
        <fo:inline font-weight="bold" font-style="italic">
            <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>
            <xsl:apply-templates mode="print"/>
        </fo:inline>
    </xsl:template>
    <xsl:template match="*[@render = 'boldsmcaps'] | *[@altrender = 'boldsmcaps']" mode="print">
        <fo:inline font-weight="bold" font-variant="small-caps">
            <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>
            <xsl:apply-templates mode="print"/>
        </fo:inline>
    </xsl:template>
    <xsl:template match="*[@render = 'boldunderline'] | *[@altrender = 'boldunderline']" mode="print">
        <fo:inline font-weight="bold" border-bottom="1pt solid #000">
            <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>
            <xsl:apply-templates mode="print"/>
        </fo:inline>
    </xsl:template>
    <xsl:template match="*[@render = 'doublequote'] | *[@altrender = 'doublequote']" mode="print">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>"<xsl:apply-templates mode="print"/>" </xsl:template>
    <xsl:template match="*[@render = 'italic'] | *[@altrender = 'italic']" mode="print">
        <fo:inline font-style="italic">
            <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>
            <xsl:apply-templates mode="print"/>
        </fo:inline>
    </xsl:template>
    <xsl:template match="*[@render = 'singlequote'] | *[@altrender = 'singlequote']" mode="print">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>'<xsl:apply-templates mode="print"/>' </xsl:template>
    <xsl:template match="*[@render = 'smcaps'] | *[@altrender = 'smcaps']" mode="print">
        <fo:inline font-variant="small-caps">
            <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>
            <xsl:apply-templates mode="print"/>
        </fo:inline>
    </xsl:template>
    <xsl:template match="*[@render = 'sub'] | *[@altrender = 'sub']" mode="print">
        <fo:inline baseline-shift="sub">
            <xsl:apply-templates mode="print"/>
        </fo:inline>
    </xsl:template>
    <xsl:template match="*[@render = 'super'] | *[@altrender = 'super']" mode="print">
        <fo:inline baseline-shift="super">
            <xsl:apply-templates mode="print"/>
        </fo:inline>
    </xsl:template>
    <xsl:template match="*[@render = 'underline'] | *[@altrender = 'underline']" mode="print">
        <fo:inline text-decoration="underline">
            <xsl:apply-templates mode="print"/>
        </fo:inline>
    </xsl:template>

    <!-- *** Begin templates for Container List *** -->
    <xsl:template match="ead:archdesc/ead:dsc" mode="print">
        <fo:block font-size="14pt" space-before="18pt" padding-bottom="-2pt" border-bottom="1pt solid #000" color="black" padding-after="0" padding-before="8pt"
            id="{generate-id(.)}" break-before="page"> Inventory </fo:block>
        <fo:block>
            <xsl:choose>
                <xsl:when test="child::*[@level='series' or @level='subseries' or @level='collection' or @level='subcollection' or  @level='fonds' or @level='subfonds' or  @level='recordgrp' or @level='subgrp']"></xsl:when>
                <xsl:otherwise>
                    <fo:marker marker-class-name="title">
                        Inventory
                    </fo:marker>
                </xsl:otherwise>
            </xsl:choose>
        <fo:table table-layout="fixed" space-after="12pt" width="7.25in">
            <fo:table-column column-number="1" column-width="3.25in"/>
            <fo:table-column column-number="2" column-width="1in"/>
            <fo:table-column column-number="3" column-width="1in"/>
            <fo:table-column column-number="4" column-width="1in"/>
            <fo:table-column column-number="5" column-width="1in"/>
            <fo:table-body>
                <xsl:apply-templates select="*[not(self::ead:head)]" mode="print"/>
            </fo:table-body>
        </fo:table>
        </fo:block>
    </xsl:template>

    <!--This section of the stylesheet creates a div for each c01 or c 
        It then recursively processes each child component of the c01 by 
        calling the printclevel template. -->
    <xsl:template match="ead:c" mode="print">
        <xsl:call-template name="printclevel">
            <xsl:with-param name="level">01</xsl:with-param>
        </xsl:call-template>
        <xsl:for-each select="ead:c">
            <xsl:call-template name="printclevel">
                <xsl:with-param name="level">02</xsl:with-param>
            </xsl:call-template>
            <xsl:for-each select="ead:c">
                <xsl:call-template name="printclevel">
                    <xsl:with-param name="level">03</xsl:with-param>
                </xsl:call-template>
                <xsl:for-each select="ead:c">
                    <xsl:call-template name="printclevel">
                        <xsl:with-param name="level">04</xsl:with-param>
                    </xsl:call-template>
                    <xsl:for-each select="ead:c">
                        <xsl:call-template name="printclevel">
                            <xsl:with-param name="level">05</xsl:with-param>
                        </xsl:call-template>
                        <xsl:for-each select="ead:c">
                            <xsl:call-template name="printclevel">
                                <xsl:with-param name="level">06</xsl:with-param>
                            </xsl:call-template>
                            <xsl:for-each select="ead:c">
                                <xsl:call-template name="printclevel">
                                    <xsl:with-param name="level">07</xsl:with-param>
                                </xsl:call-template>
                                <xsl:for-each select="ead:c">
                                    <xsl:call-template name="printclevel">
                                        <xsl:with-param name="level">08</xsl:with-param>
                                    </xsl:call-template>
                                    <xsl:for-each select="ead:c">
                                        <xsl:call-template name="printclevel">
                                            <xsl:with-param name="level">019</xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:for-each>
                                </xsl:for-each>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="ead:c01">
        <xsl:call-template name="printclevel"/>
        <xsl:for-each select="ead:c02">
            <xsl:call-template name="printclevel"/>
            <xsl:for-each select="ead:c03">
                <xsl:call-template name="printclevel"/>
                <xsl:for-each select="ead:c04">
                    <xsl:call-template name="printclevel"/>
                    <xsl:for-each select="ead:c05">
                        <xsl:call-template name="printclevel"/>
                        <xsl:for-each select="ead:c06">
                            <xsl:call-template name="printclevel"/>
                            <xsl:for-each select="ead:c07">
                                <xsl:call-template name="printclevel"/>
                                <xsl:for-each select="ead:c08">
                                    <xsl:call-template name="printclevel"/>
                                    <xsl:for-each select="ead:c09">
                                        <xsl:call-template name="printclevel"/>
                                        <xsl:for-each select="ead:c10">
                                            <xsl:call-template name="printclevel"/>
                                            <xsl:for-each select="ead:c11">
                                                <xsl:call-template name="printclevel"/>
                                                <xsl:for-each select="ead:c12">
                                                  <xsl:call-template name="printclevel"/>
                                                </xsl:for-each>
                                            </xsl:for-each>
                                        </xsl:for-each>
                                    </xsl:for-each>
                                </xsl:for-each>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    <!--This is a named template that processes all c0* elements  -->
    <xsl:template name="printclevel">
        <!-- 9/8/11 WS for RA: this feature is not used by the RA stylesheets 
            Establishes which level is being processed in order to provided indented displays. 
            Indents handdled by CSS margins-->
        <xsl:param name="level" />
        <xsl:variable name="printclevelMargin">
            <xsl:choose>
                <xsl:when test="$level = 01">0in</xsl:when>
                <xsl:when test="$level = 02">.2in</xsl:when>
                <xsl:when test="$level = 03">.4in</xsl:when>
                <xsl:when test="$level = 04">.6in</xsl:when>
                <xsl:when test="$level = 05">.8in</xsl:when>
                <xsl:when test="$level = 06">1in</xsl:when>
                <xsl:when test="$level = 07">1.2in</xsl:when>
                <xsl:when test="$level = 08">1.4in</xsl:when>
                <xsl:when test="$level = 09">1.6in</xsl:when>
                <xsl:when test="$level = 10">1.8in</xsl:when>
                <xsl:when test="$level = 11">1.9in</xsl:when>
                <xsl:when test="$level = 12">2.0in</xsl:when>
                <xsl:when test="../c">0in</xsl:when>
                <xsl:when test="../c01">.2in</xsl:when>
                <xsl:when test="../c02">.4in</xsl:when>
                <xsl:when test="../c03">.6in</xsl:when>
                <xsl:when test="../c04">.8in</xsl:when>
                <xsl:when test="../c05">1in</xsl:when>
                <xsl:when test="../c06">1.2in</xsl:when>
                <xsl:when test="../c07">1.4in</xsl:when>
                <xsl:when test="../c08">1.6in</xsl:when>
                <xsl:when test="../c08">1.8in</xsl:when>
                <xsl:when test="../c08">1.9in</xsl:when>
                <xsl:when test="../c08">2.0in</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="printclevelFont">
            <xsl:choose>
                <xsl:when test="$level = 01">11pt</xsl:when>
                <xsl:when test="$level = 02">10pt</xsl:when>
                <xsl:when test="$level = 03">9pt</xsl:when>
                <xsl:when test="$level = 04">8pt</xsl:when>
                <xsl:when test="$level = 05">7pt</xsl:when>
                <xsl:when test="$level = 06">6pt</xsl:when>
                <xsl:when test="$level = 07">6pt</xsl:when>
                <xsl:when test="$level = 08">6pt</xsl:when>
                <xsl:when test="$level = 09">6pt</xsl:when>
                <xsl:when test="$level = 10">6pt</xsl:when>
                <xsl:when test="$level = 11">6pt</xsl:when>
                <xsl:when test="$level = 12">6pt</xsl:when>
                <xsl:when test="../c">11pt</xsl:when>
                <xsl:when test="../c01">10pt</xsl:when>
                <xsl:when test="../c02">9pt</xsl:when>
                <xsl:when test="../c03">8pt</xsl:when>
                <xsl:when test="../c04">7pt</xsl:when>
                <xsl:when test="../c05">6pt</xsl:when>
                <xsl:when test="../c06">6pt</xsl:when>
                <xsl:when test="../c07">6pt</xsl:when>
                <xsl:when test="../c08">6pt</xsl:when>
                <xsl:when test="../c08">6pt</xsl:when>
                <xsl:when test="../c08">6pt</xsl:when>
                <xsl:when test="../c08">6pt</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <!-- 9/8/11 WS for RA: this feature is not used by the RA stylesheets
            Establishes a class for even and odd rows in the table for color coding. 
            Colors are Declared in the CSS. -->
        <xsl:variable name="colorClass">
            <xsl:choose>
                <xsl:when test="ancestor-or-self::*[@level='file' or @level='item'  or @level='otherlevel']">
                    <xsl:choose>
                        <xsl:when test="(position() mod 2 = 0)">#fff</xsl:when>
                        <xsl:otherwise>#fff</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <!-- Processes the all child elements of the c or c0* level -->
        <xsl:for-each select=".">
            <xsl:choose>
                <!--Formats Series and Groups  -->
                <xsl:when test="@level='collection' or @level='subcollection' 
                     or @level='series' or @level='subseries' or 
                     @level='fonds' or @level='subfonds' or
                     @level='recordgrp' or @level='subgrp' or (@level='otherlevel' and not(child::did/container))">
                    <fo:table-row font-size="{$printclevelFont}">
                        <!-- 9/8/11 WS for RA: removed background color for series and subseries -->
                        <fo:table-cell number-columns-spanned="5" padding="4pt" margin-left="{$printclevelMargin}">
                                    <fo:block>
                                        <xsl:call-template name="printAnchor"/>
                                        <xsl:apply-templates select="ead:did" mode="printdsc"/>
                                        <xsl:apply-templates select="ead:scopecontent" mode="print"/>
                                        <xsl:for-each select="ead:did/ead:physdesc[ead:extent]">
                                            <fo:block>
                                                <fo:block font-weight="bold">Extent</fo:block>
                                                <fo:block space-after="8pt">
                                                    <xsl:value-of select="ead:extent[1]"/>
                                                    <xsl:if test="ead:extent[position() &gt; 1]">, <xsl:value-of select="ead:extent[position() &gt; 1]"/> </xsl:if>
                                                </fo:block>
                                            </fo:block>
                                        </xsl:for-each>
                                        <xsl:apply-templates select="ead:accruals" mode="print"/>
                                        <xsl:apply-templates select="ead:appraisal" mode="print"/>
                                        <xsl:apply-templates select="ead:arrangement" mode="print"/>
                                        <xsl:apply-templates select="ead:bioghist" mode="print"/>
                                        <xsl:apply-templates select="ead:accessrestrict[not(child::ead:legalstatus)]" mode="print"/>
                                        <xsl:apply-templates select="ead:userestrict" mode="print"/>
                                        <xsl:apply-templates select="ead:custodhist" mode="print"/>
                                        <xsl:apply-templates select="ead:altformavail" mode="print"/>
                                        <xsl:apply-templates select="ead:originalsloc" mode="print"/>
                                        <xsl:apply-templates select="ead:did/ead:physdesc[@label='Dimensions note']" mode="print"/>
                                        <xsl:apply-templates select="ead:fileplan" mode="print"/>
                                        <xsl:apply-templates select="ead:did/ead:physdesc[@label = 'General Physical Description note']" mode="print"/>
                                        <xsl:apply-templates select="ead:odd" mode="print"/>
                                        <xsl:apply-templates select="ead:acqinfo" mode="print"/>
                                        <xsl:apply-templates select="ead:did/ead:langmaterial" mode="print"/>
                                        <xsl:apply-templates select="ead:accessrestrict[child::ead:legalstatus]" mode="print"/>
                                        <xsl:apply-templates select="ead:did/ead:materialspec" mode="print"/>
                                        <xsl:apply-templates select="ead:otherfindaid" mode="print"/>
                                        <xsl:apply-templates select="ead:phystech" mode="print"/>
                                        <xsl:apply-templates select="ead:did/ead:physdesc[@label='Physical Facet note']" mode="print"/>
                                        <xsl:apply-templates select="ead:processinfo" mode="print"/>
                                        <xsl:apply-templates select="ead:relatedmaterial" mode="print"/>
                                        <xsl:apply-templates select="ead:separatedmaterial" mode="print"/>
                                        <xsl:apply-templates select="ead:controlaccess" mode="print"/>
                                    </fo:block>
                                    <xsl:if test="ead:did/ead:container | child::*[name() = 'dao']">
                                        <fo:table table-layout="fixed" space-before="4pt" space-after="4pt" width="6.25in" font-size="11pt" line-height="12pt" margin-left=".25in">
                                            <fo:table-column column-number="1" column-width="3.25in"/>
                                            <fo:table-column column-number="2" column-width="3in"/>
                                            <fo:table-body>
                                                <xsl:if test="ead:did/ead:container | ead:dao">
                                                    <fo:table-row>
                                                        <fo:table-cell number-columns-spanned="2">
                                                            <fo:block font-weight="bold" text-decoration="underline" space-after="4pt"> Instances </fo:block>
                                                        </fo:table-cell>
                                                    </fo:table-row>
                                                </xsl:if>
                                                <xsl:for-each select="ead:did/ead:container[@id]">
                                                    <xsl:variable name="id" select="@id"/>
                                                    <fo:table-row>
                                                        <fo:table-cell>
                                                            <fo:block>
                                                                <xsl:value-of select="@label"/>
                                                            </fo:block>
                                                        </fo:table-cell>
                                                        <fo:table-cell>
                                                            <fo:block>
                                                                <xsl:value-of select="concat(@type,' ',.)"/>
                                                                <xsl:if test="../ead:container[@parent = $id]">
                                                                    <xsl:value-of select="concat(' / ',../ead:container[@parent = $id]/@type,' ',../ead:container[@parent = $id])"/>
                                                                </xsl:if>
                                                            </fo:block>
                                                        </fo:table-cell>
                                                    </fo:table-row>
                                                </xsl:for-each>
                                                <!-- Uncomment for digital object display
                                                <xsl:if test="ead:dao">
                                                    <xsl:for-each select="ead:dao">
                                                        <fo:table-row>
                                                            <fo:table-cell>
                                                                <fo:block>
                                                                    Digital Object
                                                                </fo:block>
                                                            </fo:table-cell>
                                                            <fo:table-cell>
                                                                <fo:block>
                                                                    Digital Object ID: <xsl:value-of select="@ns2:href"/>
                                                                </fo:block>
                                                            </fo:table-cell>
                                                        </fo:table-row>                                                
                                                    </xsl:for-each>
                                                </xsl:if>
                                                -->
                                            </fo:table-body>
                                        </fo:table>
                                    </xsl:if>
                          </fo:table-cell>
                    </fo:table-row>
                </xsl:when>

                <!-- Items/Files-->
                <xsl:when test="@level='file' or @level='item' or (@level='otherlevel'and child::did/container)">
                    <fo:table-row font-size="{$printclevelFont}">
                        <fo:table-cell padding="4pt" number-columns-spanned="5" margin-left="{$printclevelMargin}">
                            <fo:block><xsl:apply-templates select="ead:did" mode="printdsc"/></fo:block>
                            <!-- 9/8/11 WS for RA: Added internal table for instances -->
                            <xsl:if test="ead:did/ead:container | child::*[name() != 'did' and name() != 'c']">
                                <fo:table table-layout="fixed" space-before="4pt" space-after="4pt" width="6.25in" line-height="12pt" margin-left=".05in">
                                    <fo:table-column column-number="1" column-width="3.25in"/>
                                    <fo:table-column column-number="2" column-width="3in"/>
                                    <fo:table-body>
                                        <xsl:if test="ead:did/ead:container | ead:dao">
                                            <fo:table-row>
                                                <fo:table-cell number-columns-spanned="2">
                                                  <fo:block font-weight="bold" text-decoration="underline" space-after="4pt"> Instances </fo:block>
                                                </fo:table-cell>
                                            </fo:table-row>
                                        </xsl:if>
                                        <xsl:for-each select="ead:did/ead:container[@id]">
                                            <xsl:sort select="@label"/>
                                            <xsl:variable name="id" select="@id"/>
                                            <fo:table-row>
                                                <fo:table-cell>
                                                  <fo:block>
                                                  <xsl:value-of select="@label"/>
                                                  </fo:block>
                                                </fo:table-cell>
                                                <fo:table-cell>
                                                  <fo:block>
                                                  <xsl:value-of select="concat(@type,' ',.)"/>
                                                  <xsl:if test="../ead:container[@parent = $id]">
                                                  <xsl:value-of select="concat(' / ',../ead:container[@parent = $id]/@type,' ',../ead:container[@parent = $id])"/>
                                                  </xsl:if>
                                                  </fo:block>
                                                </fo:table-cell>
                                            </fo:table-row>
                                        </xsl:for-each>
                                        <!-- Uncomment for digital object display
                                        <xsl:if test="descendant-or-self::ead:dao">
                                            <xsl:for-each select="descendant-or-self::ead:dao">
                                                <fo:table-row>
                                                    <fo:table-cell>
                                                        <fo:block>
                                                            Digital Object
                                                        </fo:block>
                                                    </fo:table-cell>
                                                    <fo:table-cell>
                                                        <fo:block>
                                                            Digital Object ID: <xsl:value-of select="@ns2:href"/>
                                                        </fo:block>
                                                    </fo:table-cell>
                                                </fo:table-row>                                                
                                            </xsl:for-each>
                                        </xsl:if>
                                        -->
                                        <!-- Adds row for scope and contents notes and dimensions -->
                                        <xsl:if test="child::*[name() != 'did'] | 
                                            child::ead:did/ead:physdesc[@label='Dimensions note'] | 
                                            child::ead:did/ead:physdesc[@label = 'General Physical Description note'] | 
                                            child::ead:did/ead:langmaterial | 
                                            child::ead:did/ead:materialspec |
                                            child::ead:did/ead:physdesc[@label='Physical Facet note']">
                                            <fo:table-row>
                                                <fo:table-cell number-columns-spanned="2">
                                                  <fo:block font-weight="bold" text-decoration="underline" margin-top="12pt">Details </fo:block>
                                                    <xsl:apply-templates select="ead:scopecontent" mode="print"/>
                                                    <xsl:apply-templates select="ead:accruals" mode="print"/>
                                                    <xsl:apply-templates select="ead:appraisal" mode="print"/>
                                                    <xsl:apply-templates select="ead:arrangement" mode="print"/>
                                                    <xsl:apply-templates select="ead:bioghist" mode="print"/>
                                                    <xsl:apply-templates select="ead:accessrestrict[not(child::ead:legalstatus)]" mode="print"/>
                                                    <xsl:apply-templates select="ead:userestrict" mode="print"/>
                                                    <xsl:apply-templates select="ead:custodhist" mode="print"/>
                                                    <xsl:apply-templates select="ead:altformavail" mode="print"/>
                                                    <xsl:apply-templates select="ead:originalsloc" mode="print"/>
                                                    <xsl:apply-templates select="ead:did/ead:physdesc[@label='Dimensions note']" mode="print"/>
                                                    <xsl:apply-templates select="ead:fileplan" mode="print"/>
                                                    <xsl:apply-templates select="ead:did/ead:physdesc[@label = 'General Physical Description note']" mode="print"/>
                                                    <xsl:apply-templates select="ead:odd" mode="print"/>
                                                    <xsl:apply-templates select="ead:acqinfo" mode="print"/>
                                                    <xsl:apply-templates select="ead:did/ead:langmaterial" mode="print"/>
                                                    <xsl:apply-templates select="ead:accessrestrict[child::ead:legalstatus]" mode="print"/>
                                                    <xsl:apply-templates select="ead:did/ead:materialspec" mode="print"/>
                                                    <xsl:apply-templates select="ead:otherfindaid" mode="print"/>
                                                    <xsl:apply-templates select="ead:phystech" mode="print"/>
                                                    <xsl:apply-templates select="ead:did/ead:physdesc[@label='Physical Facet note']" mode="print"/>
                                                    <xsl:apply-templates select="ead:processinfo" mode="print"/>
                                                    <xsl:apply-templates select="ead:relatedmaterial" mode="print"/>
                                                    <xsl:apply-templates select="ead:separatedmaterial" mode="print"/>
                                                    <xsl:apply-templates select="ead:controlaccess" mode="print"/>
                                                </fo:table-cell>
                                            </fo:table-row>
                                        </xsl:if>
                                    </fo:table-body>
                                </fo:table>
                            </xsl:if>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:when>
                <xsl:otherwise>
                    <fo:table-row>
                        <fo:table-cell padding="4pt" margin-left="{$printclevelMargin}">
                            <fo:block padding-before="8pt"><xsl:apply-templates select="ead:did" mode="printdsc"/>
                                <xsl:apply-templates select="ead:scopecontent" mode="print"/>
                                <xsl:apply-templates select="ead:accruals" mode="print"/>
                                <xsl:apply-templates select="ead:appraisal" mode="print"/>
                                <xsl:apply-templates select="ead:arrangement" mode="print"/>
                                <xsl:apply-templates select="ead:bioghist" mode="print"/>
                                <xsl:apply-templates select="ead:accessrestrict[not(child::ead:legalstatus)]" mode="print"/>
                                <xsl:apply-templates select="ead:userestrict" mode="print"/>
                                <xsl:apply-templates select="ead:custodhist" mode="print"/>
                                <xsl:apply-templates select="ead:altformavail" mode="print"/>
                                <xsl:apply-templates select="ead:originalsloc" mode="print"/>
                                <xsl:apply-templates select="ead:did/ead:physdesc[@label='Dimensions note']" mode="print"/>
                                <xsl:apply-templates select="ead:fileplan" mode="print"/>
                                <xsl:apply-templates select="ead:did/ead:physdesc[@label = 'General Physical Description note']" mode="print"/>
                                <xsl:apply-templates select="ead:odd" mode="print"/>
                                <xsl:apply-templates select="ead:acqinfo" mode="print"/>
                                <xsl:apply-templates select="ead:did/ead:langmaterial" mode="print"/>
                                <xsl:apply-templates select="ead:accessrestrict[child::ead:legalstatus]" mode="print"/>
                                <xsl:apply-templates select="ead:did/ead:materialspec" mode="print"/>
                                <xsl:apply-templates select="ead:otherfindaid" mode="print"/>
                                <xsl:apply-templates select="ead:phystech" mode="print"/>
                                <xsl:apply-templates select="ead:did/ead:physdesc[@label='Physical Facet note']" mode="print"/>
                                <xsl:apply-templates select="ead:processinfo" mode="print"/>
                                <xsl:apply-templates select="ead:relatedmaterial" mode="print"/>
                                <xsl:apply-templates select="ead:separatedmaterial" mode="print"/>
                                <xsl:apply-templates select="ead:controlaccess" mode="print"/>                         
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <!-- 8/17/11 WS for RA: added a test to include Series/Subseries and unitid, customized display -->
    <xsl:template match="ead:did" mode="printdsc">
        <xsl:choose>
            <xsl:when  test="../@level='series' or ../@level='subseries'  or ../@level='collection' or ../@level='subcollection' or  ../@level='fonds' or ../@level='subfonds' or  ../@level='recordgrp' or ../@level='subgrp'">
                <fo:block font-size="14pt" margin-top="24pt" space-after="8pt" font-weight="bold" color="#111" id="{generate-id(.)}">
                    <fo:marker marker-class-name="title">
                        <xsl:if test="../@level='subcollection' or ../@level='subgrp' or ../@level='subseries' or ../@level='subfonds'">                                
                            <xsl:if test="ancestor::*[@level='series'] or ancestor::*[1][@level='collection'] or ancestor::*[1][@level='fonds'] or ancestor::*[1][@level='recordgrp']">
                                <xsl:choose>
                                    <xsl:when test="ancestor::*[@level='series']">Series <xsl:value-of select="ancestor::*[@level='series']/ead:did/ead:unitid"/>: 
                                        <xsl:value-of select="ancestor::*[@level='series']/ead:did/ead:unittitle"/>; </xsl:when>
                                    <xsl:when test="ancestor::*[1][@level='collection']">Collection <xsl:value-of select="ancestor::*[@level='collection']/ead:did/ead:unitid"/>: 
                                        <xsl:value-of select="ancestor::*[@level='collection']/ead:did/ead:unittitle"/>; </xsl:when>
                                    <xsl:when test="ancestor::*[1][@level='fonds']">Fonds <xsl:value-of select="ancestor::*[@level='fonds']/ead:did/ead:unitid"/>:
                                        <xsl:value-of select="ancestor::*[@level='fonds']/ead:did/ead:unittitle"/>;                  
                                    </xsl:when>
                                    <xsl:when test="ancestor::*[1][@level='recordgrp']">Record Group <xsl:value-of select="ancestor::*[@level='recordgrp']/ead:did/ead:unitid"/>: 
                                        <xsl:value-of select="ancestor::*[@level='recordgrp']/ead:did/ead:unittitle"/>; </xsl:when>
                                </xsl:choose>
                            </xsl:if> 
                        </xsl:if>
                        <xsl:if test="ead:unitid">
                            <xsl:choose>
                                <xsl:when test="../@level='series'">Series <xsl:value-of select="ead:unitid"/>: </xsl:when>
                                <xsl:when test="../@level='subseries'">Subseries <xsl:value-of select="ead:unitid"/>: </xsl:when>
                                <xsl:when test="../@level='collection'">Collection <xsl:value-of select="ead:unitid"/>: </xsl:when>
                                <xsl:when test="../@level='subcollection'">Subcollection <xsl:value-of select="ead:unitid"/>: </xsl:when>
                                <xsl:when test="../@level='fonds'">Fonds <xsl:value-of select="ead:unitid"/>: </xsl:when>
                                <xsl:when test="../@level='subfonds'">Subfonds <xsl:value-of select="ead:unitid"/>: </xsl:when>
                                <xsl:when test="../@level='recordgrp'">Record Group <xsl:value-of select="ead:unitid"/>: </xsl:when>
                                <xsl:when test="../@level='subgrp'">Subgroup <xsl:value-of select="ead:unitid"/>: </xsl:when>
                                <xsl:otherwise><xsl:value-of select="ead:unitid"/>: </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                        <xsl:value-of select="normalize-space(ead:unittitle)"/>
                    </fo:marker>
                    <xsl:if test="ead:unitid">
                        <xsl:choose>
                            <xsl:when test="../@level='series'">Series <xsl:value-of select="ead:unitid"/>: </xsl:when>
                            <xsl:when test="../@level='subseries'">Subseries <xsl:value-of select="ead:unitid"/>: </xsl:when>
                            <xsl:when test="../@level='subsubseries'">Sub-Subseries <xsl:value-of select="ead:unitid"/>: </xsl:when>
                            <xsl:when test="../@level='collection'">Collection <xsl:value-of select="ead:unitid"/>: </xsl:when>
                            <xsl:when test="../@level='subcollection'">Subcollection <xsl:value-of select="ead:unitid"/>: </xsl:when>
                           <xsl:when test="../@level='fonds'">Fonds <xsl:value-of select="ead:unitid"/>: </xsl:when>
                            <xsl:when test="../@level='subfonds'">Subfonds <xsl:value-of select="ead:unitid"/>: </xsl:when>
                            <xsl:when test="../@level='recordgrp'">Record Group <xsl:value-of select="ead:unitid"/>: </xsl:when>
                            <xsl:when test="../@level='subgrp'">Subgroup <xsl:value-of select="ead:unitid"/>: </xsl:when>
                            <xsl:otherwise><xsl:value-of select="ead:unitid"/>: </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:apply-templates select="ead:unittitle" mode="print"/> 
                    <xsl:if test="ead:unitdate[not(@type)] or ead:unitdate[@type != 'bulk']">, 
                        <xsl:apply-templates select="ead:unitdate[not(@type)] | ead:unitdate[@type != 'bulk']" mode="print"/>
                    </xsl:if>
                </fo:block>
            </xsl:when>
            <!--Otherwise render the text in its normal font.-->
            <xsl:otherwise>
                <fo:block><xsl:call-template name="printcomponent-did-core"/></fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="printcomponent-did-core">
        <!--Inserts unitid and a space if it exists in the markup.-->
        <xsl:if test="ead:unitid"><fo:inline font-style="italic"><xsl:value-of select="normalize-space(ead:unitid)"/></fo:inline>
            <xsl:if test="ead:unittitle | ead:origination">:</xsl:if>
            <xsl:text>&#160;</xsl:text>
        </xsl:if>
        <!--Inserts origination and a space if it exists in the markup.-->
        <!-- 11/2/11 WS for RA: commented out for RA.
        <xsl:if test="ead:origination">
            <xsl:apply-templates select="ead:origination"/>
            <xsl:text>&#160;</xsl:text>
        </xsl:if>-->
        <!--This choose statement selects between cases where unitdate is a child of unittitle and where it is a separate child of did.-->
        <xsl:choose>
            <!--This code processes the elements when unitdate is a child of unittitle.-->
            <xsl:when test="ead:unittitle/ead:unitdate">
                <xsl:apply-templates select="ead:unittitle" mode="print"/>
            </xsl:when>
            <!--This code process the elements when unitdate is not a child of untititle-->
            <xsl:otherwise>
                <xsl:apply-templates select="ead:unittitle" mode="print"/>
                <xsl:if test="ead:unitdate and ead:unittitle and string-length(ead:unittitle) &gt; 1">, </xsl:if>
                <xsl:for-each select="ead:unitdate[not(self::ead:unitdate[@type='bulk'])]">
                    <xsl:apply-templates mode="print"/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="ead:physdesc/ead:extent">
            <xsl:text>&#160;</xsl:text>
            <!-- 9/16/11 WS for RA: added parentheses -->
            (<xsl:for-each select="ead:physdesc">
                <xsl:value-of select="ead:extent[1]"/>
                <xsl:if test="ead:extent[position() &gt; 1]">, <xsl:value-of select="ead:extent[position() &gt; 1]"/> </xsl:if>                
            </xsl:for-each>)
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
