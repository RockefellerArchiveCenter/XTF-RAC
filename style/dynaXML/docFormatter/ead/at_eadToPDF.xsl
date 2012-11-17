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
        * REVISED          November 14, 2011 WS                            *
        * ADAPTED          September 26, 2011 WS                          *
        *                  Adapted for Rockefeller Archive Center         *  
        *                                                                 *
        * ABOUT:           This file has been created for use with        *
        *                  the Archivists' Toolkit  July 30 2008.         *
        *                  this file calls lookupLists.xsl, which         *
        *                  should be located in the same folder.          *
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
    <xsl:template name="print">
        <pipe:pipeFOP xmlns:pipe="java:/org.cdlib.xtf.saxonExt.Pipe"
            fileName="test.pdf"> 
            <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format"
                font-family="verdana, arial, sans-serif" font-size="11pt">
                <fo:layout-master-set>
                    <!-- Page master for Cover Page -->
                    <fo:simple-page-master master-name="cover-page" page-width="8.5in"
                        page-height="11in" margin-top="0.2in" margin-bottom="0.5in" margin-left="0.5in"
                        margin-right="0.5in">
                        <fo:region-body margin="0.5in" margin-bottom="1in"/>
                        <fo:region-before extent="0.2in"/>
                        <fo:region-after extent="2in"/>
                    </fo:simple-page-master>
                    <!-- 8/11/11 WS: Page master for Overview for Rockefeller Archives -->
                    <fo:simple-page-master master-name="overview" page-width="8.5in" page-height="11in"
                        margin-top="0.25in" margin-bottom="0.5in" margin-left="0.5in"
                        margin-right="0.5in">
                        <fo:region-body margin="0.5in" margin-bottom="1in"/>
                        <fo:region-before extent=".75in"/>
                        <fo:region-after extent=".75in"/>
                    </fo:simple-page-master>
                    <!-- Page master for Table of Contents -->
                    <fo:simple-page-master master-name="toc" page-width="8.5in" page-height="11in"
                        margin-top="0.25in" margin-bottom="0.5in" margin-left="0.5in"
                        margin-right="0.5in">
                        <fo:region-body margin="0.5in" margin-bottom="1in"/>
                        <fo:region-before extent="0.75in"/>
                        <fo:region-after extent="0.2in"/>
                    </fo:simple-page-master>
                    <!-- Page master for Contents -->
                    <fo:simple-page-master master-name="contents" page-width="8.5in" page-height="11in"
                        margin-top="0.25in" margin-bottom="0.5in" margin-left="0.5in"
                        margin-right="0.5in">
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
                            <!--<xsl:apply-templates select="ead:eadheader"/>-->
                            TEST COVER PAGE
                        </fo:block>
                    </fo:flow>
                </fo:page-sequence>
                <!-- 8/11/11 WS: Added overview page for Rockefeller Archives -->
                <fo:page-sequence master-reference="overview">
                    <fo:static-content flow-name="xsl-region-before">
                        <fo:block color="gray" text-align="center" margin-top=".25in">
<!--                            <xsl:value-of select="$pageHeader"/>-->
                        </fo:block>
                    </fo:static-content>
                    <!-- 8/14/11 WS for RA: changed footer-->
                    <fo:static-content flow-name="xsl-region-after">
                        <fo:block border-top-style="solid" border-top-color="#7E1416"
                            border-top-width=".04in" padding-top=".025in" margin-bottom="0in"
                            padding-after="0in" padding-bottom="0">
                            <fo:block color="gray" padding-top="0in" margin-top="-0.015in"
                                border-top-style="solid" border-top-color="#7E1416"
                                border-top-width=".015in">
                                <fo:table space-before="0.07in" table-layout="fixed" width="100%"
                                    font-size="8pt" margin-top=".05in" padding-top="0in">
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
                        TEST OVERVIEW
                        <!--                        <xsl:apply-templates select="ead:archdesc/ead:did" mode="print"/>-->
                    </fo:flow>
                </fo:page-sequence>
                <fo:page-sequence master-reference="toc">
                    <fo:static-content flow-name="xsl-region-before">
                        <fo:block color="gray" text-align="center" margin-top=".25in">
<!--                            <xsl:value-of select="$pageHeader"/>-->
                        </fo:block>
                    </fo:static-content>
                    <!-- 8/14/11 WS for RA: changed footer-->
                    <fo:static-content flow-name="xsl-region-after">
                        <fo:block border-top-style="solid" border-top-color="#7E1416"
                            border-top-width=".04in" padding-top=".025in" margin-bottom="0in"
                            padding-after="0in" padding-bottom="0">
                            <fo:block color="gray" padding-top="0in" margin-top="-0.015in"
                                border-top-style="solid" border-top-color="#7E1416"
                                border-top-width=".015in">
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
                        TEST TOC
                        <!--                        <xsl:call-template name="printToc"/>-->
                    </fo:flow>
                </fo:page-sequence>
                <fo:page-sequence master-reference="contents">
                    <fo:static-content flow-name="xsl-region-before" margin-top=".25in">
                        <fo:block color="gray" text-align="center">
<!--                            <xsl:value-of select="$pageHeader"/>-->
                        </fo:block>
                    </fo:static-content>
                    <!-- 8/14/11 WS for RA: changed footer-->
                    <!-- NOTE: get parent -->
                    <fo:static-content flow-name="xsl-region-after">
                        <fo:block border-top-style="solid" border-top-color="#7E1416"
                            border-top-width=".04in" padding-top=".025in" margin-bottom="0in"
                            padding-after="0in" padding-bottom="0">
                            <fo:block color="gray" padding-top="0in" margin-top="-0.015in"
                                border-top-style="solid" border-top-color="#7E1416"
                                border-top-width=".015in">
                                <fo:table space-before="0.07in" table-layout="fixed" width="100%"
                                    font-size="8pt" margin-top=".05in" padding-top="0in">
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
                        TEST CONTENT
                        <!--                        <xsl:apply-templates select="ead:archdesc" mode="print"/>-->
                    </fo:flow>
                </fo:page-sequence>
            </fo:root>
        </pipe:pipeFOP>
    </xsl:template>
    <xsl:template match="ead:ead" mode="print">
        <!--The following two variables headerString and pageHeader establish the title of the finding aid and substring long titles for dsiplay in the header -->
        <xsl:variable name="headerString">
            <xsl:choose>
                <xsl:when test="ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper">
                    <xsl:choose>
                        <xsl:when
                            test="starts-with(ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper,ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper/ead:num)">
                            <xsl:apply-templates
                                select="/ead:ead/ead:archdesc/ead:did/ead:unittitle" mode="header"/>
                        </xsl:when>
                        <xsl:when
                            test="ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper/@type = 'filing'">
                            <xsl:choose>
                                <xsl:when
                                    test="count(ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper) &gt; 1">
                                    <xsl:apply-templates
                                        select="ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper[not(@type='filing')]"
                                    />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates
                                        select="/ead:ead/ead:archdesc/ead:did/ead:unittitle"
                                        mode="header"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates
                                select="ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:did/ead:unittitle"
                        mode="header"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="pageHeader">
            <xsl:value-of select="substring($headerString,1,100)"/>
            <xsl:if test="string-length(normalize-space($headerString)) &gt; 100">...</xsl:if>
        </xsl:variable>
        <!--fo:root establishes the page types and layouts contained in the PDF, the finding aid consists of 4 distinct 
            page types, the cover page, the table of contents, contents and the container list. To alter basic page apperence 
            such as margins fonts alter the following page-masters.-->
        
    </xsl:template>
</xsl:stylesheet>
