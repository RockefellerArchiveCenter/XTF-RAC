<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xtf="http://cdlib.org/xtf" xmlns:html="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/xhtml"
   xmlns:session="java:org.cdlib.xtf.xslt.Session" extension-element-prefixes="session" exclude-result-prefixes="#all" xpath-default-namespace="urn:isbn:1-931666-22-9">

   <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
   <!-- EAD dynaXML Stylesheet                                                 -->
   <!-- 9/27/11 WS: Edited for Rockefeller Archives Center                     -->

   <!--  Modified by DG for RAC 5/17/12 - 6/11/12
	This files goes in  /var/lib/tomcat6/webapps/xtf/style/dynaXML/docFormatter/ead/
 
	-->

   <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->

   <!--
      Copyright (c) 2008, Regents of the University of California
      All rights reserved.
      
      Redistribution and use in source and binary forms, with or without 
      modification, are permitted provided that the following conditions are 
      met:
      
      - Redistributions of source code must retain the above copyright notice, 
      this list of conditions and the following disclaimer.
      - Redistributions in binary form must reproduce the above copyright 
      notice, this list of conditions and the following disclaimer in the 
      documentation and/or other materials provided with the distribution.
      - Neither the name of the University of California nor the names of its
      contributors may be used to endorse or promote products derived from 
      this software without specific prior written permission.
      
      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
      AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
      IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
      ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
      LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
      CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
      SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
      INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
      CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
      ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
      POSSIBILITY OF SUCH DAMAGE.
   -->

   <!-- 
      NOTE: This is rough adaptation of the EAD Cookbook stylesheets to get them 
      to work with XTF. It should in no way be considered a production interface 
   -->

   <!-- ====================================================================== -->
   <!-- Import Common Templates                                                -->
   <!-- ====================================================================== -->

   <xsl:import href="../common/docFormatterCommon.xsl"/>
   <xsl:include href="../../../myList/myListFormatter.xsl"/>

   <!-- ====================================================================== -->
   <!-- Output Format                                                          -->
   <!-- ====================================================================== -->

   <xsl:output method="xhtml" indent="yes" encoding="UTF-8" media-type="text/html; charset=UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" exclude-result-prefixes="#all" omit-xml-declaration="yes"/>

   <!-- ====================================================================== -->
   <!-- Strip Space                                                            -->
   <!-- ====================================================================== -->

   <xsl:strip-space elements="*"/>

   <!-- ====================================================================== -->
   <!-- Included Stylesheets                                                   -->
   <!-- ====================================================================== -->

   <xsl:include href="parameter.xsl"/>
   <xsl:include href="search.xsl"/>
   <xsl:include href="eadcbs7.xsl"/>

   <!-- ====================================================================== -->
   <!-- Define Keys                                                            -->
   <!-- ====================================================================== -->

   <xsl:key name="chunk-id" match="*[parent::archdesc or matches(local-name(), '^(c|c[0-9][0-9])$')][@id]" use="@id"/>

   <!-- ====================================================================== -->
   <!-- EAD-specific parameters                                                -->
   <!-- ====================================================================== -->

   <!-- If a query was specified but no particular hit rank, jump to the first hit 
        (in document order) -->
   <xsl:param name="hit.num" select="'0'"/>

   <xsl:param name="hit.rank">
      <xsl:choose>
         <xsl:when test="$hit.num != '0'">
            <xsl:value-of select="key('hit-num-dynamic', string($hit.num))/@rank"/>
         </xsl:when>
         <xsl:when test="$query and not($query = '0')">
            <xsl:value-of select="key('hit-num-dynamic', '1')/@rank"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="'0'"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:param>

   <!-- To support direct links from snippets, the following two parameters must check value of $hit.rank -->
   <xsl:param name="chunk.id">
      <xsl:choose>
         <xsl:when test="$hit.rank != '0'">
            <xsl:call-template name="findHitChunk">
               <xsl:with-param name="hitNode" select="key('hit-rank-dynamic', string($hit.rank))"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="'ref0'"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:param>

   <xsl:param name="parentID"/>

   <!-- ====================================================================== -->
   <!-- Root Template                                                          -->
   <!-- ====================================================================== -->

   <xsl:template match="/ead">
      <xsl:choose>
         <!-- robot solution -->
         <!--<xsl:when test="matches($http.user-agent,$robots)">
            <xsl:call-template name="robot"/>
         </xsl:when>-->
         <!-- Creates the body of the finding aid.-->
         <xsl:when test="$doc.view = 'content'">
            <xsl:call-template name="body"/>
         </xsl:when>
         <!-- pdf view -->
         <xsl:when test="$doc.view='print'">
            <xsl:call-template name="print"/>
         </xsl:when>
         <!-- popup for file level descriptions -->
         <!--<xsl:when test="$doc.view='dscDescription'">
            <xsl:call-template name="dscDescription"/>
         </xsl:when>
         <xsl:when test="$doc.view='restrictions'">
            <xsl:call-template name="restrictions"/>
         </xsl:when>-->
         <!--XML view for debugging -->
         <xsl:when test="$doc.view='xml'">
            <xsl:copy-of select="."/>
         </xsl:when>
         <!-- citation -->
         <xsl:when test="$doc.view='citation'">
            <xsl:call-template name="citation"/>
         </xsl:when>
         <!-- Creates the basic frameset.-->
         <xsl:otherwise>
            <xsl:call-template name="contents"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- Main Template                                                      -->
   <!-- ====================================================================== -->

   <xsl:template name="contents">
      <xsl:variable name="bbar.href"><xsl:value-of select="$query.string"/>;doc.view=bbar;brand=<xsl:value-of select="$brand"/><xsl:value-of select="$search"/></xsl:variable>
      <xsl:variable name="toc.href"><xsl:value-of select="$query.string"/>;doc.view=toc;brand=<xsl:value-of select="$brand"/>;chunk.id=<xsl:value-of select="$chunk.id"/>;<xsl:value-of select="$search"
         />#X</xsl:variable>
      <xsl:variable name="content.href"><xsl:value-of select="$query.string"/>;doc.view=content;brand=<xsl:value-of select="$brand"/>;chunk.id=<xsl:value-of select="$chunk.id"/><xsl:value-of
            select="$search"/></xsl:variable>

      <xsl:result-document exclude-result-prefixes="#all">

         <html xml:lang="en" lang="en">
            <head>
               <link rel="alternate" type="application/xml" href="{$xtfURL}data/{$docId}"/>
               <xsl:copy-of select="$brand.links"/>
               <title>
                  <xsl:value-of select="archdesc/did/unittitle"/>
                  <xsl:text> (</xsl:text>
                  <xsl:value-of select="archdesc/did/unitid"/>
                  <xsl:text>)</xsl:text>
               </title>
            </head>
            <body>
               <!-- Schema.org metadata -->
               <div itemscope="" typeof="http:/schema.org/CollectionPage">
                  <xsl:if test="ead/archdesc/abstract">
                     <meta itemprop="http:/schema.org/description">
                        <xsl:attribute name="content">
                           <xsl:value-of select="archdesc/abstract"/>
                        </xsl:attribute>
                     </meta>
                  </xsl:if>
                  <meta itemprop="http:/schema.org/name">
                     <xsl:attribute name="content">
                        <xsl:value-of select="archdesc/did/unittitle"/>
                     </xsl:attribute>
                  </meta>
                  <div itemprop="http:/schema.org/contentLocation" itemscope="" itemtype="http:/schema.org/Place">
                     <meta itemprop="http:/schema.org/name" content="Rockefeller Archive Center"/>
                     <meta itemprop="http:/schema.org/url" content="http://www.rockarch.org"/>
                     <div itemprop="http:/schema.org/address" itemscop="" itemtype="http:/schema.org/PostalAddress">
                        <meta itemprop="streetAddress" content="15 Dayton Avenue"/>
                        <meta itemprop="addressLocality" content="Sleepy Hollow"/>
                        <meta itemprop="addressRegion" content="NY"/>
                        <meta itemprop="postalCode" content="10591"/>
                     </div>
                     <div itemprop="http:/schema.org/geo" itemscope="" itemtype="http:/schema.org/GeoCoordinates">
                        <meta itemprop="http:/schema.org/latitude" content="41.091845"/>
                        <meta itemprop="http:/schema.org/longitude" content="-73.835265"/>
                     </div>
                     <meta itemprop="http:/schema.org/telephone" content="(914) 366-6300"/>
                  </div>
                  <xsl:for-each select="archdesc/did/origination/child::*[starts-with(@role,'Contributor')]">
                     <meta itemprop="http:/schema.org/contributor">
                        <xsl:attribute name="content">
                           <xsl:apply-templates/>
                        </xsl:attribute>
                     </meta>
                  </xsl:for-each>
                  <xsl:for-each select="archdesc/did/origination/child::*[starts-with(@role,'Author')]">
                     <meta itemprop="http:/schema.org/creator">
                        <xsl:attribute name="content">
                           <xsl:apply-templates/>
                        </xsl:attribute>
                     </meta>
                  </xsl:for-each>
                  <div itemprop="http:/schema.org/dateCreated" itemscope="" itemtype="Date">
                     <meta itemprop="date">
                        <xsl:attribute name="content">
                           <xsl:value-of select="archdesc/did/unitdate[@type != 'bulk']"/>
                        </xsl:attribute>
                     </meta>
                  </div>
                  <meta itemprop="http:/schema.org/inLanguage" content="en"/>
                  <div itemprop="http:/schema.org/publisher" itemscope="" itemtype="http:/schema.org/organization">
                     <meta itemprop="http:/schema.org/name" content="Rockefeller Archive Center"/>
                     <meta itemprop="http:/schema.org/url" content="http://www.rockarch.org"/>
                     <div itemprop="http:/schema.org/address" itemscop="" itemtype="http:/schema.org/PostalAddress">
                        <meta itemprop="streetAddress" content="15 Dayton Avenue"/>
                        <meta itemprop="addressLocality" content="Sleepy Hollow"/>
                        <meta itemprop="addressRegion" content="NY"/>
                        <meta itemprop="postalCode" content="10591"/>
                     </div>
                     <meta itemprop="http:/schema.org/telephone" content="(914) 366-6300"/>
                  </div>
               </div>
               <!-- End Schema.org metadata -->

               <xsl:copy-of select="$brand.header"/>
               <div id="header">
                  <a href="/xtf/search">
                     <img src="http://www.rockarch.org/images/RAC-logo.png" width="103" height="140" alt="The Rockefeller Archive Center" border="0"/>
                     <h1>dimes.rockarch.org</h1>
                     <p class="tagline">The Online Collections and Catalog of Rockefeller Archive Center</p>
                  </a>
               </div>
               <xsl:call-template name="myListNav"/>
               <xsl:call-template name="bbar_custom"/>

               <div class="main">
                  <xsl:call-template name="toc"/>
                  <xsl:call-template name="body"/>
               </div>
               <xsl:copy-of select="$brand.feedback"/>
               <xsl:call-template name="myListCopies"/>
               <xsl:call-template name="myListEmail"/>
               <xsl:call-template name="myListPrint"/>
               <xsl:call-template name="myListRequest"/>
               <div class="fixedFooter">
                  <xsl:copy-of select="$brand.footer"/>
               </div>
            </body>
         </html>
      </xsl:result-document>
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- 9/27/11 WS: Internal navbar ammended from docFormatterCommon           -->
   <!-- 7/29/2013 HA: making additional changes                                -->
   <!-- ====================================================================== -->
   <xsl:template name="bbar_custom">
      <div class="bbar_custom">
         <div class="documentTitle ead">
            <h1>
               <xsl:variable name="title">
                  <xsl:apply-templates select="eadheader/filedesc/titlestmt/titleproper"/>
               </xsl:variable>
               <xsl:if test="string-length($title) &gt; 175">
                  <xsl:attribute name="style"> font-size:1.15em; </xsl:attribute>
               </xsl:if>
               <xsl:choose>
                  <xsl:when test="eadheader/filedesc/titlestmt/titleproper[@type='filing']">
                     <xsl:apply-templates select="eadheader/filedesc/titlestmt/titleproper[not(@type='filing')]"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:apply-templates select="eadheader/filedesc/titlestmt/titleproper"/>
                  </xsl:otherwise>
               </xsl:choose>
            </h1>
         </div>
         <xsl:variable name="searchPage">
            <xsl:choose>
               <xsl:when test="$doc.view='dao'">
                  <xsl:value-of select="'Digital Materials'"/>
               </xsl:when>
               <xsl:when test="$doc.view='contents'">
                  <xsl:value-of select="'Contents List'"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="'Collection Description'"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:variable name="identifier" select="/ead/xtf:meta/child::*[1]"/>
         <xsl:variable name="indexId" select="$identifier"/>
         <div class="headerIcons">
            <ul>
               <xsl:if test="$doc.view != 'dao'">
                  <li>
                     <xsl:variable name="pdfID" select="substring-before($docId,'.xml')"/>
                     <a href="{$xtfURL}/media/pdf/{$pdfID}.pdf" onClick="_gaq.push(['_trackEvent', 'finding aid', 'view', 'pdf']);">
                        <img src="/xtf/icons/default/pdf.gif" alt="PDF" title="PDF"/>
                     </a>
                  </li>
               </xsl:if>
            </ul>
         </div>
         <div class="headerSearch">
            <form action="{$xtfURL}{$dynaxmlPath}" method="get" class="bbform">
               <input name="query" type="text"/>
               <input type="hidden" name="docId" value="{$docId}"/>
               <input type="hidden" name="chunk.id" value="contentsLink"/>
               <input type="hidden" name="doc.view" value="contentsSearch"/>
               <input type="submit" value="Search Contents List" onclick="_gaq.push(['_trackEvent', 'finding aid', 'search', '{$searchPage}']);"/>
            </form>
            <div class="searchAll">
               <a href="{$xtfURL}{$crossqueryPath}">Search all collections</a>
            </div>
         </div>
         <xsl:call-template name="tabs"/>
      </div>
   </xsl:template>
   <!-- only display first num tag -->
   <xsl:template match="titleproper/num[1]">
      <br/>
      <xsl:value-of select="."/>
   </xsl:template>
   <xsl:template match="titleproper/num[2]"/>
   <!-- ====================================================================== -->
   <!-- Tabs Templates                                                         -->
   <!-- ====================================================================== -->

   <xsl:template name="tabs">
      <xsl:variable name="content.href"><xsl:value-of select="$query.string"/>;brand=<xsl:value-of select="$brand"/><xsl:value-of select="$search"/></xsl:variable>
      <div class="tabs">
         <div class="tab collectionTab">
            <xsl:choose>
               <xsl:when test="$doc.view = 'collection'">
                  <xsl:attribute name="class">tab collectionTab select</xsl:attribute>
               </xsl:when>
               <xsl:when test="$doc.view = 'contents'"/>
               <xsl:when test="$doc.view = 'dao'"/>
               <xsl:when test="$doc.view = 'contentsSearch'"/>
               <xsl:otherwise>
                  <xsl:attribute name="class">tab select</xsl:attribute>
               </xsl:otherwise>
            </xsl:choose>
            <xsl:call-template name="make-tab-link">
               <xsl:with-param name="name" select="'Collection Description'"/>
               <xsl:with-param name="id" select="'headerlink'"/>
               <xsl:with-param name="doc.view" select="'collection'"/>
               <xsl:with-param name="nodes" select="archdesc/did"/>
            </xsl:call-template>
         </div>
         <div class="tab contentsTab">
            <xsl:if test="$doc.view='contents' or $doc.view='contentsSearch'">
               <xsl:attribute name="class">tab contentsTab select</xsl:attribute>
            </xsl:if>
            <xsl:variable name="idFile">
               <xsl:choose>
                  <xsl:when test="archdesc/dsc/child::*[1][@level = 'file']">
                     <xsl:value-of select="'contentsLink'"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="archdesc/dsc/child::*[1]/@id"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <xsl:variable name="nodesLst">
               <xsl:choose>
                  <xsl:when test="/ead/archdesc/dsc/child::*[1][@level = 'file']">archdesc/dsc/child::*</xsl:when>
                  <xsl:otherwise>archdesc/dsc/child::*[1]</xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <!-- 7/24/12 WS: Added condition to test for finding aids with no contents list and supress this tab -->
            <xsl:choose>
               <xsl:when test="/ead/archdesc/dsc/child::*">
                  <xsl:call-template name="make-tab-link">
                     <xsl:with-param name="name" select="'Contents List'"/>
                     <xsl:with-param name="id" select="'contentsLink'"/>
                     <xsl:with-param name="doc.view" select="'contents'"/>
                     <xsl:with-param name="nodes" select="$nodesLst"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:attribute name="class">clear</xsl:attribute>
               </xsl:otherwise>
            </xsl:choose>
         </div>
         <div class="tab digitalTab">
            <!-- Need to insure only shows up if digital material is available -->
            <xsl:if test="$doc.view='dao'">
               <xsl:attribute name="class">tab digitalTab select</xsl:attribute>
            </xsl:if>
            <xsl:variable name="idFile">
               <xsl:choose>
                  <xsl:when test="archdesc/dsc/child::*[1][@level = 'file' and exists(xtf:meta/*:type = 'dao')]">
                     <xsl:value-of select="'digitalLink'"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="archdesc/dsc/child::*[xtf:meta/*:type = 'dao'][1]/@id"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <xsl:variable name="nodesLst">
               <xsl:choose>
                  <xsl:when test="/ead/archdesc/dsc/child::*[1][@level = 'file' and exists(dao)]">archdesc/dsc/child::*</xsl:when>
                  <xsl:otherwise>archdesc/dsc/child::*[xtf:meta/*:type = 'dao'][1]</xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <xsl:choose>
               <xsl:when test="/ead/xtf:meta/*:type = 'dao'">
                  <xsl:call-template name="make-tab-link">
                     <xsl:with-param name="name" select="'Digital Materials'"/>
                     <xsl:with-param name="id" select="'digitalLink'"/>
                     <xsl:with-param name="doc.view" select="'dao'"/>
                     <xsl:with-param name="nodes" select="$nodesLst"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:attribute name="class">clear</xsl:attribute>
               </xsl:otherwise>
            </xsl:choose>
         </div>
      </div>
   </xsl:template>

   <xsl:template name="make-tab-link">
      <xsl:param name="name"/>
      <xsl:param name="id"/>
      <xsl:param name="doc.view"/>
      <xsl:param name="nodes"/>
      <xsl:param name="indent" select="1"/>
      <xsl:variable name="hit.count">
         <xsl:choose>
            <xsl:when test="$doc.view='collection'">
               <xsl:value-of select="/ead/archdesc/@xtf:hitCount - /ead/archdesc/dsc/@xtf:hitCount"/>
            </xsl:when>
            <xsl:when test="$doc.view='contents'">
               <xsl:value-of select="/ead/archdesc/dsc/@xtf:hitCount"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="'0'"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="tracking-id">
         <xsl:choose>
            <xsl:when test="$id='contentsLink'">
               <xsl:value-of select="'Contents List'"/>
            </xsl:when>
            <xsl:when test="$id='digitalLink'">
               <xsl:value-of select="'Digital Materials'"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="'Collection Description'"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="content.href"><xsl:value-of select="$query.string"/>;chunk.id=<xsl:value-of select="$id"/>;brand=<xsl:value-of select="$brand"/><xsl:value-of select="$search"
            />&amp;doc.view=<xsl:value-of select="$doc.view"/></xsl:variable>
      <a onclick="_gaq.push(['_trackEvent', 'finding aid', 'tab', '{$tracking-id}']);">

         <!-- 5/17/2012 DG: create variables for the new href: documentname2, basicchoice2, xtfURL2, href2. Just use chunk.id and doc name for now-->
         <xsl:variable name="documentname2">
            <xsl:analyze-string select="$query.string" regex="docId=ead/([A-Z0-9^/]+)/([A-Z0-9^/]+).xml" flags="i">

               <xsl:matching-substring>
                  <xsl:value-of select="regex-group(2)"/>
               </xsl:matching-substring>

               <xsl:non-matching-substring>
                  <xsl:text>no_match_docname</xsl:text>
               </xsl:non-matching-substring>
            </xsl:analyze-string>
         </xsl:variable>

         <xsl:variable name="basicchoice2">
            <xsl:choose>
               <xsl:when test="$id='headerlink'">
                  <xsl:text>collection</xsl:text>
               </xsl:when>
               <xsl:when test="$id='contentsLink'">
                  <xsl:text>contents</xsl:text>
               </xsl:when>
               <xsl:when test="$id='digitalLink'">
                  <xsl:text>digital</xsl:text>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:text>nomatch_for_</xsl:text>
                  <xsl:value-of select="$id"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:variable name="xtfURL2">
            <!-- remove xtf/ from end, if there.  -->
            <xsl:analyze-string select="$xtfURL" regex="(.*)xtf/">
               <xsl:matching-substring>
                  <xsl:value-of select="regex-group(1)"/>
               </xsl:matching-substring>
               <xsl:non-matching-substring>
                  <xsl:value-of select="$xtfURL"/>
               </xsl:non-matching-substring>
            </xsl:analyze-string>
         </xsl:variable>

         <xsl:variable name="href2">
            <xsl:value-of select="concat($xtfURL2,$documentname2,'/',$basicchoice2)"/>
         </xsl:variable>
         <!--  end new  DG: created $href2 -->
         <xsl:attribute name="href">
            <xsl:choose>
               <xsl:when test="($query != '0') and ($query != '')">
                  <xsl:value-of select="$xtfURL"/><xsl:value-of select="$dynaxmlPath"/>?<xsl:value-of select="$content.href"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="$href2"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:attribute>
         <xsl:value-of select="$name"/>
      </a>
      <xsl:if test="string-length($hit.count) &gt; 0 and $hit.count != '0'">
         <span class="hit"> (<xsl:value-of select="$hit.count"/>)</span>
      </xsl:if>
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- TOC Templates                                                          -->
   <!-- ====================================================================== -->

   <xsl:template name="toc">
      <xsl:call-template name="translate">
         <xsl:with-param name="resultTree">
            <div id="tocWrapper">
               <div id="toc">
                  <!-- The Table of Contents template performs a series of tests to
                     determine which elements will be included in the table
                     of contents.  Each if statement tests to see if there is
                     a matching element with content in the finding aid.-->
                  <xsl:choose>
                     <xsl:when test="$doc.view='contents' or $doc.view = 'contentsSearch'">
                        <div class="contentsList">
                           <xsl:if
                              test="archdesc/dsc/child::*[@level='series'] | 
                              archdesc/dsc/child::*[@level='recordgrp'] | 
                              archdesc/dsc/child::*[@level='fonds'] | archdesc/dsc/child::*[@level='subgrp'] 
                              | archdesc/dsc/child::*[@level='subseries'] 
                              | archdesc/dsc/child::*[@level='otherlevel' and not(child::did/container)]">
                              <h4>Contents List</h4>
                           </xsl:if>
                           <xsl:if test="archdesc/dsc/child::*">
                              <xsl:apply-templates select="archdesc/dsc/head" mode="tocLink"/>
                              <!-- Displays the unittitle and unitdates for a c01 if it is a series (as
                                 evidenced by the level attribute series)and numbers them
                                 to form a hyperlink to each.   Delete this section if you do not
                                 wish the c01 titles to appear in the table of contents.-->
                              <xsl:apply-templates
                                 select="archdesc/dsc/child::*[@level='series'] | 
                                 archdesc/dsc/child::*[@level='recordgrp'] | 
                                 archdesc/dsc/child::*[@level='fonds'] | archdesc/dsc/child::*[@level='subgrp'] 
                                 | archdesc/dsc/child::*[@level='subseries'] 
                                 | archdesc/dsc/child::*[@level='otherlevel' and not(child::did/container)]"
                                 mode="dscTocSeries"/>
                           </xsl:if>
                        </div>
                     </xsl:when>
                     <xsl:when test="$doc.view='dao'">
                        <div class="contentsList">
                           <h4>Digital Contents List</h4>
                           <xsl:apply-templates
                              select="archdesc/dsc/child::*[@level='series'] [xtf:meta/*:type = 'dao'] | 
                              archdesc/dsc/child::*[@level='recordgrp'][xtf:meta/*:type = 'dao'] | 
                              archdesc/dsc/child::*[@level='fonds'][xtf:meta/*:type = 'dao'] | archdesc/dsc/child::*[@level='subgrp'][xtf:meta/*:type = 'dao'] 
                              | archdesc/dsc/child::*[@level='subseries'][xtf:meta/*:type = 'dao'] 
                              | archdesc/dsc/child::*[@level='otherlevel' and not(child::did/container)][xtf:meta/*:type = 'dao']"
                              mode="dscTocDao"/>
                        </div>
                     </xsl:when>
                     <xsl:otherwise>
                        <div class="contents">
                           <h4>Contents</h4>
                           <xsl:if test="archdesc/did">
                              <div class="tocRow" id="headerlinkMenu">
                                 <xsl:call-template name="make-toc-link">
                                    <xsl:with-param name="name" select="'Overview'"/>
                                    <xsl:with-param name="id" select="'headerlink'"/>
                                    <xsl:with-param name="nodes" select="archdesc/did | archdesc/scopecontent"/>
                                 </xsl:call-template>
                              </div>
                           </xsl:if>
                           <xsl:if test="archdesc/did/head">
                              <div class="tocRow">
                                 <xsl:apply-templates select="archdesc/did/head" mode="tocLink"/>
                              </div>
                           </xsl:if>
                           <xsl:if
                              test="archdesc/accessrestrict or archdesc/userestrict or 
                              archdesc/phystech or archdesc/otherfindaid or  archdesc/relatedmaterial or 
                              archdesc/altformavail or archdesc/originalsloc or archdesc/bibliography">
                              <div class="tocRow" id="restrictlinkMenu">
                                 <xsl:call-template name="make-toc-link">
                                    <xsl:with-param name="name" select="'Access and Use'"/>
                                    <xsl:with-param name="id" select="'restrictlink'"/>
                                    <xsl:with-param name="nodes"
                                       select="archdesc/accessrestrict|
                                    archdesc/userestrict|
                                    archdesc/phystech|
                                    archdesc/otherfindaid|
                                    archdesc/relatedmaterial|
                                    archdesc/altformavail|
                                    archdesc/bibliography"
                                    />
                                 </xsl:call-template>
                              </div>
                           </xsl:if>
                           <xsl:if test="archdesc/arrangement/head">
                              <div class="tocRow" id="arrangementlinkMenu">
                                 <xsl:call-template name="make-toc-link">
                                    <xsl:with-param name="name" select="'Arrangement'"/>
                                    <xsl:with-param name="id" select="'arrangementlink'"/>
                                    <xsl:with-param name="nodes" select="archdesc/arrangement"/>
                                 </xsl:call-template>
                              </div>
                           </xsl:if>
                           <xsl:if test="archdesc/bioghist/head">
                              <div class="tocRow" id="bioghistMenu">
                                 <xsl:call-template name="make-toc-link">
                                    <xsl:with-param name="name" select="'Biographical/Historical Note'"/>
                                    <xsl:with-param name="id" select="'bioghist'"/>
                                    <xsl:with-param name="nodes" select="archdesc/bioghist"/>
                                 </xsl:call-template>
                              </div>
                           </xsl:if>
                           <xsl:if
                              test="archdesc/revisiondesc or archdesc/acqinfo or
                              archdesc/fileplan or archdesc/custodialhist or archdesc/accruals or
                              archdesc/processinfo or archdesc/appraisal or
                              archdesc/separatedmaterial or archdesc/altformavail or archdesc/accruals">
                              <div class="tocRow" id="adminlinkMenu">
                                 <xsl:call-template name="make-toc-link">
                                    <xsl:with-param name="name" select="'Administrative Information'"/>
                                    <xsl:with-param name="id" select="'adminlink'"/>
                                    <xsl:with-param name="nodes"
                                       select="archdesc/revisiondesc|
                                    archdesc/acqinfo|
                                    archdesc/fileplan|
                                    archdesc/custodialhist|
                                    archdesc/accruals|
                                    archdesc/processinfo|
                                    archdesc/appraisal|
                                    archdesc/separatedmaterial|
                                    archdesc/altformavail|
                                    archdesc/accruals"
                                    />
                                 </xsl:call-template>
                              </div>
                           </xsl:if>
                           <xsl:if test="archdesc/did/physdesc[@label = 'General Physical Description note']|archdesc/did/physdesc[not(@altrender)]">
                              <div class="tocRow" id="physdesclinkMenu">
                                 <xsl:call-template name="make-toc-link">
                                    <xsl:with-param name="name" select="'Physical Description'"/>
                                    <xsl:with-param name="id" select="'physdesclink'"/>
                                    <xsl:with-param name="nodes" select="archdesc/did/physdesc[@label = 'General Physical Description note']|archdesc/did/physdesc[not(@altrender)]"/>
                                 </xsl:call-template>
                              </div>
                           </xsl:if>
                        </div>
                        <div class="subjects">
                           <xsl:if test="archdesc/controlaccess/child::*[not(@role='aut')]">
                              <h4>Subjects</h4>
                              <ul class="none">
                                 <xsl:for-each select="archdesc/controlaccess">
                                    <xsl:for-each select="subject | genreform | title | occupation">
                                       <li>
                                          <a onclick="_gaq.push(['_trackEvent', 'search', 'subject', 'finding aid']);" href="{$xtfURL}search?browse-all=yes;f1-subject={.}">
                                             <xsl:value-of select="."/>
                                          </a>
                                       </li>
                                    </xsl:for-each>
                                    <xsl:for-each select="corpname[not(@role='aut')] | famname[not(@role='aut')] | persname[not(@role='aut')]">
                                       <li>
                                          <a onclick="_gaq.push(['_trackEvent', 'search', 'subject', 'finding aid']);" href="{$xtfURL}/search?browse-all=yes;f1-subjectname={.}">
                                             <xsl:value-of select="."/>
                                          </a>
                                       </li>
                                    </xsl:for-each>
                                    <xsl:for-each select="geogname">
                                       <li>
                                          <a onclick="_gaq.push(['_trackEvent', 'search', 'subject', 'finding aid']);" href="{$xtfURL}/search?browse-all=yes;f1-geogname={.}">
                                             <xsl:value-of select="."/>
                                          </a>
                                       </li>
                                    </xsl:for-each>
                                 </xsl:for-each>
                              </ul>
                           </xsl:if>
                        </div>
                        <!--End of the table of contents. -->
                     </xsl:otherwise>
                  </xsl:choose>
               </div>
            </div>
         </xsl:with-param>
      </xsl:call-template>
   </xsl:template>

   <xsl:template match="node()" mode="tocLink">
      <xsl:call-template name="make-toc-link">
         <xsl:with-param name="name" select="string(.)"/>
         <xsl:with-param name="id" select="ancestor-or-self::*[@id][1]/@id"/>
         <xsl:with-param name="nodes" select="parent::*"/>
      </xsl:call-template>
   </xsl:template>
   <xsl:template match="*" mode="dscTocSeries">
      <xsl:variable name="submenuID">
         <xsl:variable name="seriesID" select="@id"/>
         <xsl:value-of select="concat('dsc',$seriesID)"/>
      </xsl:variable>
      <xsl:variable name="submenu">
         <xsl:if test="child::*[@level='subgrp' or @level='subseries' or @level='subfonds' or @level='series' or (@level='otherlevel' and not(child::did/container))]">
            <xsl:value-of select="'true'"/>
         </xsl:if>
      </xsl:variable>
      <div id="{@id}Menu">
         <xsl:attribute name="class">
            <xsl:value-of select="'tocRow '"/>
         </xsl:attribute>

         <xsl:variable name="levelID">
            <xsl:choose>
               <xsl:when test="@level='series'">Series <xsl:value-of select="did/unitid"/>: </xsl:when>
               <xsl:when test="@level='subseries'">Subseries <xsl:value-of select="did/unitid"/>: </xsl:when>
               <xsl:when test="@level='subsubseries'">Sub-Subseries <xsl:value-of select="did/unitid"/>: </xsl:when>
               <xsl:when test="@level='collection'">Collection <xsl:value-of select="did/unitid"/>: </xsl:when>
               <xsl:when test="@level='subcollection'">Subcollection <xsl:value-of select="did/unitid"/>: </xsl:when>
               <xsl:when test="@level='fonds'">Fonds <xsl:value-of select="did/unitid"/>: </xsl:when>
               <xsl:when test="@level='subfonds'">Subfonds <xsl:value-of select="did/unitid"/>: </xsl:when>
               <xsl:when test="@level='recordgrp'">Record Group <xsl:value-of select="did/unitid"/>: </xsl:when>
               <xsl:when test="@level='subgrp'">Subgroup <xsl:value-of select="did/unitid"/>: </xsl:when>
               <xsl:when test="(@level='otherlevel') and (string-length(@otherlevel) &gt; 1 and @otherlevel!='unspecified')">
                  <xsl:value-of select="@otherlevel"/><xsl:value-of select="did/unitid"/>: </xsl:when>
               <xsl:when test="(@level='otherlevel') and (string-length(@otherlevel) &lt; 1)">
                  <xsl:if test="did/unitid">
                     <xsl:value-of select="did/unitid"/>
                     <xsl:text>: </xsl:text>
                  </xsl:if>
               </xsl:when>
               <xsl:when test="@otherlevel='unspecified'">
                  <xsl:if test="did/unitid">
                     <xsl:value-of select="did/unitid"/>
                     <xsl:text>: </xsl:text>
                  </xsl:if>
               </xsl:when>
               <xsl:otherwise><xsl:value-of select="did/unitid"/>: </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:variable name="untititle">
            <xsl:choose>
               <xsl:when test="string-length(did/unittitle) &gt; 1">
                  <xsl:value-of select="did/unittitle"/>
               </xsl:when>
               <xsl:when test="string-length(did/unitdate) &gt; 1">
                  <xsl:value-of select="did/unitdate"/>
               </xsl:when>
               <xsl:otherwise>Unknown</xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:call-template name="make-toc-link">
            <xsl:with-param name="submenuID" select="$submenuID"/>
            <xsl:with-param name="name">
               <xsl:value-of select="concat($levelID,$untititle)"/>
            </xsl:with-param>
            <xsl:with-param name="id" select="@id"/>
            <xsl:with-param name="nodes" select="."/>
            <xsl:with-param name="indent" select="2"/>
            <xsl:with-param name="dao">
               <xsl:if test="xtf:meta/*:type = 'dao'">true</xsl:if>
            </xsl:with-param>
         </xsl:call-template>
      </div>
      <xsl:if test="$submenu = 'true'">
         <div id="{$submenuID}">
            <xsl:if test="$parentID = $submenuID">
               <xsl:attribute name="style">display:block;</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates
               select="child::*[@level='subgrp'] 
                  | child::*[@level='series']
                  | child::*[@level='subseries'] 
                  | child::*[@level='otherlevel' and not(child::did/container)]"
               mode="dscTocSubseries">
               <xsl:with-param name="submenuID" select="$submenuID"/>
            </xsl:apply-templates>
         </div>
      </xsl:if>
   </xsl:template>
   <xsl:template match="*" mode="dscTocSubseries">
      <xsl:param name="submenuID"/>
      <xsl:variable name="levelID">
         <xsl:choose>
            <xsl:when test="@level='series'">Series <xsl:value-of select="did/unitid"/>: </xsl:when>
            <xsl:when test="@level='subseries'">Subseries <xsl:value-of select="did/unitid"/>: </xsl:when>
            <xsl:when test="@level='subsubseries'">Sub-Subseries <xsl:value-of select="did/unitid"/>: </xsl:when>
            <xsl:when test="@level='collection'">Collection <xsl:value-of select="did/unitid"/>: </xsl:when>
            <xsl:when test="@level='subcollection'">Subcollection <xsl:value-of select="did/unitid"/>: </xsl:when>
            <xsl:when test="@level='fonds'">Fonds <xsl:value-of select="did/unitid"/>: </xsl:when>
            <xsl:when test="@level='subfonds'">Subfonds <xsl:value-of select="did/unitid"/>: </xsl:when>
            <xsl:when test="@level='recordgrp'">Record Group <xsl:value-of select="did/unitid"/>: </xsl:when>
            <xsl:when test="@level='subgrp'">Subgroup <xsl:value-of select="did/unitid"/>: </xsl:when>
            <xsl:when test="(@level='otherlevel') and (string-length(@otherlevel) &gt; 1 and @otherlevel!='unspecified')">
               <xsl:value-of select="@otherlevel"/><xsl:value-of select="did/unitid"/>: </xsl:when>
            <xsl:when test="(@level='otherlevel') and (string-length(@otherlevel) &lt; 1)">
               <xsl:if test="did/unitid">
                  <xsl:value-of select="did/unitid"/>
                  <xsl:text>: </xsl:text>
               </xsl:if>
            </xsl:when>
            <xsl:when test="@otherlevel='unspecified'">
               <xsl:if test="did/unitid">
                  <xsl:value-of select="did/unitid"/>
                  <xsl:text>: </xsl:text>
               </xsl:if>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="did/unitid"/>: </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="untititle">
         <xsl:choose>
            <xsl:when test="string-length(did/unittitle) &gt; 1">
               <xsl:value-of select="did/unittitle"/>
            </xsl:when>
            <xsl:when test="string-length(did/unitdate) &gt; 1">
               <xsl:value-of select="did/unitdate"/>
            </xsl:when>
            <xsl:otherwise>Unknown</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <div>
         <xsl:attribute name="class">
            <xsl:value-of select="'tocSubrow '"/>
         </xsl:attribute>
         <xsl:call-template name="make-toc-link">
            <xsl:with-param name="submenuID" select="$submenuID"/>
            <xsl:with-param name="name">
               <xsl:value-of select="concat($levelID,$untititle)"/>
            </xsl:with-param>
            <xsl:with-param name="id" select="@id"/>
            <xsl:with-param name="nodes" select="."/>
            <xsl:with-param name="indent" select="3"/>
            <xsl:with-param name="dao">
               <xsl:if test="xtf:meta/*:type = 'dao'">true</xsl:if>
            </xsl:with-param>
         </xsl:call-template>
      </div>
   </xsl:template>

   <xsl:template match="*" mode="dscTocDao">
      <xsl:variable name="submenuID">
         <xsl:variable name="seriesID" select="@id"/>
         <xsl:value-of select="concat('dsc',$seriesID)"/>
      </xsl:variable>
      <xsl:variable name="submenu">
         <xsl:if test="child::*[@level='subgrp' or @level='subseries' or @level='subfonds' or @level='series' or (@level='otherlevel' and not(child::did/container))]">
            <xsl:value-of select="'true'"/>
         </xsl:if>
      </xsl:variable>
      <div id="{@id}Menu">
         <xsl:attribute name="class">
            <xsl:value-of select="'tocRow '"/>
            <xsl:choose>
               <xsl:when test="$chunk.id = @id">
                  <xsl:attribute name="class">
                     <xsl:value-of select="'active '"/>
                  </xsl:attribute>
               </xsl:when>
            </xsl:choose>
         </xsl:attribute>

         <xsl:variable name="levelID">
            <xsl:choose>
               <xsl:when test="@level='series'">Series <xsl:value-of select="did/unitid"/>: </xsl:when>
               <xsl:when test="@level='subseries'">Subseries <xsl:value-of select="did/unitid"/>: </xsl:when>
               <xsl:when test="@level='subsubseries'">Sub-Subseries <xsl:value-of select="did/unitid"/>: </xsl:when>
               <xsl:when test="@level='collection'">Collection <xsl:value-of select="did/unitid"/>: </xsl:when>
               <xsl:when test="@level='subcollection'">Subcollection <xsl:value-of select="did/unitid"/>: </xsl:when>
               <xsl:when test="@level='fonds'">Fonds <xsl:value-of select="did/unitid"/>: </xsl:when>
               <xsl:when test="@level='subfonds'">Subfonds <xsl:value-of select="did/unitid"/>: </xsl:when>
               <xsl:when test="@level='recordgrp'">Record Group <xsl:value-of select="did/unitid"/>: </xsl:when>
               <xsl:when test="@level='subgrp'">Subgroup <xsl:value-of select="did/unitid"/>: </xsl:when>
               <xsl:when test="(@level='otherlevel') and (string-length(@otherlevel) &gt; 1)"><xsl:value-of select="@otherlevel"/>: </xsl:when>
               <xsl:when test="(@level='otherlevel') and (string-length(@otherlevel) &lt; 1)">
                  <xsl:value-of select="@otherlevel"/>
               </xsl:when>
               <xsl:otherwise><xsl:value-of select="did/unitid"/>: </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:variable name="untititle">
            <xsl:choose>
               <xsl:when test="string-length(did/unittitle) &gt; 1">
                  <xsl:value-of select="did/unittitle"/>
               </xsl:when>
               <xsl:when test="string-length(did/unitdate) &gt; 1">
                  <xsl:value-of select="did/unitdate"/>
               </xsl:when>
               <xsl:otherwise>Unknown</xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:call-template name="make-toc-link">
            <xsl:with-param name="submenuID" select="$submenuID"/>
            <xsl:with-param name="name">
               <xsl:value-of select="concat($levelID,$untititle)"/>
            </xsl:with-param>
            <xsl:with-param name="id" select="@id"/>
            <xsl:with-param name="nodes" select="."/>
            <xsl:with-param name="indent" select="2"/>
            <xsl:with-param name="dao">
               <xsl:if test="xtf:meta/*:type = 'dao'">true</xsl:if>
            </xsl:with-param>
         </xsl:call-template>
      </div>

      <!-- Displays the unittitle and unitdates for each c02 if it is a subseries 
      (as evidenced by the level attribute series) and forms a hyperlink to each.   
      Delete this section if you do not wish the c02 titles to appear in the 
      table of contents. -->
      <xsl:if test="$submenu = 'true'">
         <div id="{$submenuID}">
            <xsl:if test="$parentID = $submenuID">
               <xsl:attribute name="style">display:block;</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="child::*[@level='subgrp'] 
                  | child::*[@level='subseries'] 
                  | child::*[@level='otherlevel' and not(child::did/container)]"
               mode="dscTocDaoSubseries">
               <xsl:with-param name="submenuID" select="$submenuID"/>
            </xsl:apply-templates>
         </div>
      </xsl:if>
   </xsl:template>

   <xsl:template match="*" mode="dscTocDaoSubseries">
      <xsl:param name="submenuID"/>
      <xsl:variable name="levelID">
         <xsl:choose>
            <xsl:when test="@level='series'">Series <xsl:value-of select="did/unitid"/>: </xsl:when>
            <xsl:when test="@level='subseries'">Subseries <xsl:value-of select="did/unitid"/>: </xsl:when>
            <xsl:when test="@level='subsubseries'">Sub-Subseries <xsl:value-of select="did/unitid"/>: </xsl:when>
            <xsl:when test="@level='collection'">Collection <xsl:value-of select="did/unitid"/>: </xsl:when>
            <xsl:when test="@level='subcollection'">Subcollection <xsl:value-of select="did/unitid"/>: </xsl:when>
            <xsl:when test="@level='fonds'">Fonds <xsl:value-of select="did/unitid"/>: </xsl:when>
            <xsl:when test="@level='subfonds'">Subfonds <xsl:value-of select="did/unitid"/>: </xsl:when>
            <xsl:when test="@level='recordgrp'">Record Group <xsl:value-of select="did/unitid"/>: </xsl:when>
            <xsl:when test="@level='subgrp'">Subgroup <xsl:value-of select="did/unitid"/>: </xsl:when>
            <xsl:when test="(@level='otherlevel') and (string-length(@otherlevel) &gt; 1)"><xsl:value-of select="@otherlevel"/>: </xsl:when>
            <xsl:when test="(@level='otherlevel') and (string-length(@otherlevel) &lt; 1)">
               <xsl:value-of select="@otherlevel"/>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="did/unitid"/>: </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="untititle">
         <xsl:choose>
            <xsl:when test="string-length(did/unittitle) &gt; 1">
               <xsl:value-of select="did/unittitle"/>
            </xsl:when>
            <xsl:when test="string-length(did/unitdate) &gt; 1">
               <xsl:value-of select="did/unitdate"/>
            </xsl:when>
            <xsl:otherwise>Unknown</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <div>
         <xsl:attribute name="class">
            <xsl:value-of select="'tocSubrow '"/>
            <xsl:if test="$chunk.id = @id">
               <xsl:value-of select="'active '"/>
            </xsl:if>
         </xsl:attribute>
         <xsl:call-template name="make-toc-link">
            <xsl:with-param name="submenuID" select="$submenuID"/>
            <xsl:with-param name="name">
               <xsl:value-of select="concat($levelID,$untititle)"/>
            </xsl:with-param>
            <xsl:with-param name="id" select="@id"/>
            <xsl:with-param name="nodes" select="."/>
            <xsl:with-param name="indent" select="2"/>
            <xsl:with-param name="dao">
               <xsl:if test="xtf:meta/*:type = 'dao'">true</xsl:if>
            </xsl:with-param>
         </xsl:call-template>
      </div>
   </xsl:template>

   <xsl:template name="make-toc-link">
      <xsl:param name="submenuID"/>
      <xsl:param name="name"/>
      <xsl:param name="id"/>
      <xsl:param name="nodes"/>
      <xsl:param name="indent" select="1"/>
      <xsl:param name="dao"/>
      <xsl:variable name="hit.count" select="sum($nodes/@xtf:hitCount)"/>
      <!-- 5/17/2012 DG:  a new variable for the new href.       -->
      <xsl:variable name="documentname2">
         <xsl:analyze-string select="$query.string" regex="(.*)ead/([A-Z0-9^/]+)/([A-Z0-9^/]+).xml" flags="i">

            <xsl:matching-substring>
               <xsl:value-of select="regex-group(2)"/>
            </xsl:matching-substring>

            <xsl:non-matching-substring>
               <xsl:text>no_match_docname</xsl:text>
            </xsl:non-matching-substring>
         </xsl:analyze-string>
      </xsl:variable>
      <xsl:variable name="basicchoice2">
         <xsl:choose>
            <xsl:when test="$id='headerlink'">
               <xsl:text>overview</xsl:text>
            </xsl:when>
            <xsl:when test="$id='restrictlink'">
               <xsl:text>access</xsl:text>
            </xsl:when>
            <xsl:when test="$id='arrangementlink'">
               <xsl:text>arrangement</xsl:text>
            </xsl:when>
            <xsl:when test="$id='bioghist'">
               <xsl:text>biohist</xsl:text>
            </xsl:when>
            <xsl:when test="$id='adminlink'">
               <xsl:text>admin</xsl:text>
            </xsl:when>
            <xsl:when test="$id='physdesclink'">
               <xsl:text>physdesc</xsl:text>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>nomatch_for_id</xsl:text>
            </xsl:otherwise>
         </xsl:choose>

      </xsl:variable>
      <xsl:variable name="xtfURL2">
         <!-- remove xtf/ from end, if there.  -->
         <xsl:analyze-string select="$xtfURL" regex="(.*)xtf/">
            <xsl:matching-substring>
               <xsl:value-of select="regex-group(1)"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
               <xsl:value-of select="$xtfURL"/>
            </xsl:non-matching-substring>
         </xsl:analyze-string>
      </xsl:variable>
      <xsl:variable name="href2">
         <xsl:value-of select="concat($xtfURL2,$documentname2,'/',$basicchoice2)"/>
      </xsl:variable>
      <!--  end new  DG: created $href2 -->
      <xsl:variable name="content.href">
         <xsl:value-of select="$query.string"/>;chunk.id=<xsl:value-of select="$id"/>;brand=<xsl:value-of select="$brand"/>
         <xsl:value-of select="$search"/>&amp;doc.view=<xsl:value-of select="$doc.view"/></xsl:variable>
      <xsl:choose>
         <xsl:when
            test="$doc.view='collection' or $chunk.id='headerlink' or $chunk.id='restrictlink' or $chunk.id='arrangementlink' or $chunk.id='bioghist' or $chunk.id='adminlink' or $chunk.id='physdesclink'">
            <xsl:variable name="tracking-id">
               <xsl:choose>
                  <xsl:when test="$id = 'restrictlink'">
                     <xsl:value-of select="'Access and Use'"/>
                  </xsl:when>
                  <xsl:when test="$id = 'bioghist'">
                     <xsl:value-of select="'Biographical/Historial Note'"/>
                  </xsl:when>
                  <xsl:when test="$id = 'arrangementlink'">
                     <xsl:value-of select="'Arrangement'"/>
                  </xsl:when>
                  <xsl:when test="$id = 'adminlink'">
                     <xsl:value-of select="'Administrative Information'"/>
                  </xsl:when>
                  <xsl:when test="$id = 'headerlink'">
                     <xsl:value-of select="'Overview'"/>
                  </xsl:when>
                  <xsl:when test="$id = 'physdesclink'">
                     <xsl:value-of select="'Physical Description'"/>
                  </xsl:when>
               </xsl:choose>
            </xsl:variable>
            <a onclick="_gaq.push(['_trackEvent', 'finding aid', 'table of contents', '{$tracking-id}']);">
               <!-- if basicchoice2 = "nomatch_for_id" then use the original -->
               <xsl:attribute name="href">
                  <xsl:choose>
                     <xsl:when test="($query != '0') and ($query != '')">
                        <xsl:value-of select="$xtfURL"/><xsl:value-of select="$dynaxmlPath"/>?<xsl:value-of select="$content.href"/>
                     </xsl:when>
                     <xsl:when test="$basicchoice2='nomatch_for_id'">
                        <xsl:value-of select="$xtfURL"/><xsl:value-of select="$dynaxmlPath"/>?<xsl:value-of select="$content.href"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <!-- 5/17/12 DG for RAC: rewrite -->
                        <xsl:value-of select="$href2"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
               <div class="tocItem">
                  <xsl:choose>
                     <xsl:when test="$indent = 2">
                        <xsl:attribute name="class">inventory</xsl:attribute>
                     </xsl:when>
                     <xsl:when test="$indent = 3">
                        <xsl:attribute name="class">inventory2</xsl:attribute>
                     </xsl:when>
                     <xsl:otherwise/>
                  </xsl:choose>
                  <xsl:value-of select="$name"/>
                  <div class="hit-count">
                     <xsl:if test="$hit.count"> (<xsl:value-of select="$hit.count"/>) </xsl:if>
                  </div>
               </div>
            </a>
         </xsl:when>
         <xsl:otherwise>
            <a onclick="_gaq.push(['_trackEvent', 'finding aid', 'table of contents', 'level {$indent} component']);">
               <xsl:attribute name="rel">
                  <xsl:value-of select="concat('#',@id)"/>
               </xsl:attribute>
               <xsl:attribute name="href">
                  <xsl:choose>
                     <xsl:when test="($query != '0') and ($query != '')">
                        <xsl:value-of select="$xtfURL"/><xsl:value-of select="$dynaxmlPath"/>?<xsl:value-of select="$content.href"/>
                     </xsl:when>
                     <xsl:when test="$basicchoice2='nomatch_for_id'">
                        <xsl:value-of select="$xtfURL"/><xsl:value-of select="$dynaxmlPath"/>?<xsl:value-of select="$content.href"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="$href2"/>
                     </xsl:otherwise>
                  </xsl:choose>
                  <!--<xsl:value-of select="concat('#',@id)"/>-->
               </xsl:attribute>
               <div class="tocItem">
                  <xsl:choose>
                     <xsl:when test="$indent = 2">
                        <xsl:attribute name="class">inventory</xsl:attribute>
                     </xsl:when>
                     <xsl:when test="$indent = 3">
                        <xsl:attribute name="class">inventory2</xsl:attribute>
                     </xsl:when>
                     <xsl:otherwise/>
                  </xsl:choose>
                  <xsl:value-of select="$name"/>
                  <div class="hit-count">
                     <xsl:if test="$hit.count"> (<xsl:value-of select="$hit.count"/>) </xsl:if>
                  </div>
               </div>
            </a>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="$dao = 'true'">
         <img src="/xtf/icons/default/dao.gif" alt="Contains digital objects" title="Contains digital objects"/>
      </xsl:if>
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- Print Template                                                         -->
   <!-- ====================================================================== -->
   <!-- RAC uses pdf display, see at_eadToPDF.xsl-->
   <xsl:template name="print">
      <html xml:lang="en" lang="en">
         <head>
            <title>
               <xsl:value-of select="$doc.title"/>
            </title>
         </head>
         <body>
            <hr/>
            <div align="center">
               <table width="95%">
                  <tr>
                     <td>
                        <xsl:call-template name="body"/>
                     </td>
                  </tr>
               </table>
            </div>
            <hr/>
         </body>
      </html>
   </xsl:template>

</xsl:stylesheet>
