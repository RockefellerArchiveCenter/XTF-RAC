<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xtf="http://cdlib.org/xtf" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:mets="http://www.loc.gov/METS/"
   xmlns:mods="http://www.loc.gov/mods/v3" xmlns="http://www.w3.org/1999/xhtml" xmlns:session="java:org.cdlib.xtf.xslt.Session" xmlns:xlink="http://www.w3.org/1999/xlink"
   extension-element-prefixes="session" exclude-result-prefixes="#all">
   <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
   <!-- METS dynaXML Stylesheet                                                -->
   <!-- Author: Hillel Arnold, Rockefeller Archive Center                      -->
   <!-- Date: 2015-03                                                          -->
   <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
   <!-- ====================================================================== -->
   <!-- Import Common Templates                                                -->
   <!-- ====================================================================== -->
   <xsl:import href="../common/docFormatterCommon.xsl"/>
   <xsl:import href="../../../myList/myListFormatter.xsl"/>
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
   <xsl:include href="../mods/parameter.xsl"/>
   <xsl:include href="../mods/search.xsl"/>
   <!--<xsl:include href="metsToHTML.xsl"/>-->
   <!-- ====================================================================== -->
   <!-- Define Keys                                                            -->
   <!-- ====================================================================== -->
   <xsl:key name="chunk-id" match="*[parent::mods:mods]" use="@id"/>
   <!-- ====================================================================== -->
   <!-- METS-specific parameters                                                -->
   <!-- ====================================================================== -->
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
   <xsl:param name="parentID"/>
   <!-- ====================================================================== -->
   <!-- Root Template                                                          -->
   <!-- ====================================================================== -->
   <xsl:template match="/mets:mets">
      <xsl:choose>
         <!-- robot solution -->
         <!-- HA todo: add robot template -->
         <xsl:when test="matches($http.user-agent,$robots)">
            <xsl:call-template name="robot"/>
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
      <xsl:result-document exclude-result-prefixes="#all">
         <html xml:lang="en" lang="en">
            <head>
               <xsl:copy-of select="$brand.links"/>
               <title>
                  <!-- HA todo: this should be filename plus FA title -->
                  <xsl:value-of select="meta/title"/>
               </title>
            </head>
            <body>
               <!-- HA todo: check these values -->
               <div itemscope="" typeof="http:/schema.org/ItemPage">
                  <xsl:if test="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mods:xmlData/mods:mods/mods:abstract">
                     <meta itemprop="http:/schema.org/description">
                        <xsl:attribute name="content">
                           <xsl:value-of select="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mods:xmlData/mods:mods/mods:abstract"/>
                        </xsl:attribute>
                     </meta>
                  </xsl:if>
                  <meta itemprop="http:/schema.org/name">
                     <xsl:attribute name="content">
                        <xsl:value-of select="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mods:xmlData/mods:mods/mods:titleInfo/mods:title"/>
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
                  <xsl:for-each select="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mods:xmlData/mods:mods/mods:subject/mods:name[@encodinganalog=('700' or '710')]">
                     <meta itemprop="http:/schema.org/contributor">
                        <xsl:attribute name="content">
                           <xsl:apply-templates/>
                        </xsl:attribute>
                     </meta>
                  </xsl:for-each>
                  <xsl:for-each select="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mods:xmlData/mods:mods/mods:name/mods:namePart">
                     <meta itemprop="http:/schema.org/creator">
                        <xsl:attribute name="content">
                           <xsl:apply-templates/>
                        </xsl:attribute>
                     </meta>
                  </xsl:for-each>
                  <div itemprop="http:/schema.org/dateCreated" itemscope="" itemtype="Date">
                     <meta itemprop="date">
                        <xsl:attribute name="content">
                           <xsl:value-of select="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mods:xmlData/mods:mods/mods:originInfo/mods:dateIssued"/>
                        </xsl:attribute>
                     </meta>
                  </div>
               </div>
               <xsl:copy-of select="$brand.header"/>
               <div id="header">
                  <a href="/xtf/search">
                     <img src="http://www.rockarch.org/images/RAC-logo.png" width="103" height="140" alt="The Rockefeller Archive Center" border="0"/>
                     <h1>dimes.rockarch.org</h1>
                     <p class="tagline">The Online Collections and Catalog of Rockefeller Archive Center</p>
                  </a>
               </div>
               <xsl:call-template name="bbar_custom"/>
               <xsl:call-template name="bookmarkMenu"/>
               <div class="main">
                  <div id="tocWrapper">
                     <xsl:call-template name="foundIn"/>
                     <xsl:call-template name="subjects"/>
                  </div>
                  <xsl:call-template name="body"/>
               </div>
               <div class="fixedFooter">
                  <xsl:copy-of select="$brand.footer"/>
               </div>
            </body>
         </html>
      </xsl:result-document>
   </xsl:template>
   <!-- ====================================================================== -->
   <!-- Document header for finding aid to which digital object is attached    -->
   <!-- ====================================================================== -->
   <xsl:template name="bbar_custom">
      <!-- HA todo: need to add variables to get this data from somewhere else? -->
      <div class="bbar_custom">
         <!--<div class="documentTitle ead">
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
         <xsl:variable name="identifier" select="/ead/xtf:meta/child::*[1]"/>
         <xsl:variable name="indexId" select="$identifier"/>
         <div class="headerIcons">
            <ul>
               <xsl:if test="$doc.view != 'dao'">
                  <li>
                     <xsl:variable name="pdfID" select="substring-before($docId,'.xml')"/>
                     <a href="{$xtfURL}/media/pdf/{$pdfID}.pdf"
                        onClick="_gaq.push(['_trackEvent', 'finding aid', 'view', 'pdf']);">
                        <img src="/xtf/icons/default/pdf.gif" alt="PDF" title="PDF"/>
                     </a>
                  </li>
               </xsl:if>
            </ul>
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
         <xsl:call-template name="tabs"/>-->
      </div>
   </xsl:template>
   <!-- ====================================================================== -->
   <!-- Tabs Templates                                                          -->
   <!-- ====================================================================== -->
   <xsl:template name="tabs">
      <!-- HA todo: needs to be heavily edited -->
      <!-- HA todo: see if we can get some of this stuff indexed -->
      <!--<xsl:variable name="content.href"><xsl:value-of select="$query.string"/>;brand=<xsl:value-of select="$brand"/><xsl:value-of select="$search"/></xsl:variable>
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
            <!-\- 7/24/12 WS: Added condition to test for finding aids with no contents list and supress this tab -\->
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
            <!-\- Need to insure only shows up if digital material is available -\->
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
      </div>-->
   </xsl:template>
   <xsl:template name="make-tab-link">
      <!--<xsl:param name="name"/>
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
         
         <!-\- 5/17/2012 DG: create variables for the new href: documentname2, basicchoice2, xtfURL2, href2. Just use chunk.id and doc name for now-\->
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
            <!-\- remove xtf/ from end, if there.  -\->
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
         <!-\-  end new  DG: created $href2 -\->
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
      </xsl:if>-->
   </xsl:template>
   <!-- ====================================================================== -->
   <!-- Main body template                                                     -->
   <!-- ====================================================================== -->
   <xsl:template name="body">
      <!--<xsl:variable name="file">
         <xsl:value-of select="/mods:mods/mods:identifier"/>
      </xsl:variable>-->
      <div id="content-wrapper">
         <div id="content-right">
            <div class="thumbnail">
               <img src="/xtf/icons/default/thumbnail-large.png" height="300px"/>
               <div class="thumbnailButtons">
                  <button class="download"><img src="/xtf/icons/default/download.png"/> Download</button>
                  <button class="view"><img src="/xtf/icons/default/view.png"/> View</button>
               </div>
            </div>
            <div class="description">
               <div class="title">
                  <h2>
                     <xsl:value-of select="xtf:meta/*:filename"/>
                  </h2>
               </div>
               <div class="creator">
                  <p>
                     <xsl:value-of select="xtf:meta/*:creator"/>
                  </p>
               </div>
               <div class="extent">
                  <p>
                     <xsl:variable name="fileid">
                        <xsl:value-of select="/mets:mets/mets:fileSec/mets:fileGrp/mets:file/@ID"/>
                     </xsl:variable>
                     <xsl:value-of select="/mets:mets/mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mets:xmlData/*:mods/*:identifier"/>
                     <xsl:if test="xtf:meta/*:size">
                        <xtf:text>, </xtf:text>
                        <xsl:value-of select="xtf:meta/*:size"/>
                     </xsl:if>
                  </p>
               </div>
               <div class="notes">
                  <xsl:for-each select="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mets:xmlData/mods:mods/mods:note[not(@type='originalsloc')]">
                     <xsl:apply-templates select="."/>
                  </xsl:for-each>
               </div>
               <div class="restrictions">
                  <xsl:for-each select="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mets:xmlData/mods:mods/mods:accessCondition">
                     <xsl:apply-templates select="."/>
                  </xsl:for-each>
               </div>
            </div>
         </div>
      </div>
   </xsl:template>

   <!-- Handle notes -->
   <xsl:template match="mods:note">
      <h4>
         <xsl:value-of select="@displayLabel"/>
      </h4>
      <p>
         <xsl:value-of select="."/>
      </p>
   </xsl:template>

   <xsl:template match="mods:accessCondition">
      <xsl:variable name="heading">
         <xsl:choose>
            <xsl:when test="@type='restrictionOnAccess'">Access Restrictions</xsl:when>
            <xsl:when test="@type='useAndReproduction'">Use Restrictions</xsl:when>
            <xsl:otherwise>Restrictions</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <h4>
         <xsl:value-of select="$heading"/>
      </h4>
      <p>
         <xsl:value-of select="."/>
      </p>
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- Controlled Terms Templates                                             -->
   <!-- ====================================================================== -->
   <xsl:template name="subjects">
      <div class="subjects">
         <xsl:if test="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mets:xmlData/mods:mods/mods:subject">
            <xsl:apply-templates select="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mets:xmlData/mods:mods/mods:subject"/>
         </xsl:if>
      </div>
   </xsl:template>

   <xsl:template match="mods:subject">
      <xsl:if test="mods:topic">
         <h4>Subjects</h4>
         <ul>
            <xsl:for-each select="mods:topic">
               <li>
                  <xsl:value-of select="."/>
               </li>
            </xsl:for-each>
         </ul>
      </xsl:if>
      <xsl:if test="mods:geographic">
      <h4>Places</h4>
      <ul>
         <xsl:for-each select="mods:geographic">
            <li>
               <xsl:value-of select="."/>
            </li>
         </xsl:for-each>
      </ul>
      </xsl:if>
      <xsl:if test="mods:name">
         <xsl:if test="mods:name[@type='personal']">
            <h4>People</h4>
            <xsl:for-each select="mods:name[@type='personal']">
               <li>
                  <xsl:value-of select="mods:namePart"/>
               </li>
            </xsl:for-each>
         </xsl:if>
         <xsl:if test="mods:name[@type='corporate']">
            <h4>Organizations</h4>
            <xsl:for-each select="mods:name[@type='corporate']">
               <li>
                  <xsl:value-of select="mods:namePart"/>
               </li>
            </xsl:for-each>
         </xsl:if>
         <xsl:if test="mods:name[@type='family']">
            <h4>Families</h4>
            <xsl:for-each select="mods:name[@type='family']">
               <li>
                  <xsl:value-of select="mods:namePart"/>
               </li>
            </xsl:for-each>
         </xsl:if>
         <xsl:if test="mods:name[@type='conference']">
            <h4>Conferences</h4>
            <xsl:for-each select="mods:name[@type='conference']">
               <li>
                  <xsl:value-of select="mods:namePart"/>
               </li>
            </xsl:for-each>
         </xsl:if>
      </xsl:if>
      <xsl:if test="mods:genre">
         <h4>Formats</h4>
         <ul>
            <xsl:for-each select="mods:genre">
               <li>
                  <xsl:value-of select="."/>
               </li>
            </xsl:for-each>
         </ul>
      </xsl:if>
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- EAD Hierarchy Templates                                                -->
   <!-- ====================================================================== -->
   <xsl:template name="foundIn">
      <div class="foundIn">
         <h3>Found In</h3>
      </div>
   </xsl:template>
   <!-- ====================================================================== -->
   <!-- Bookmark options menu                                                  -->
   <!-- ====================================================================== -->
   <xsl:template name="bookmarkMenu">
      <div class="pull-right" id="bookmarkMenu">
         <div class="btn-group">
            <button id="myListButton" type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
               <img src="/xtf/icons/default/share.png"/> Share <span class="caret"/>
            </button>
            <ul class="dropdown-menu pull-right" role="menu">
               <li>
                  <a href="#">Facebook</a>
               </li>
               <li>
                  <a href="#">Twitter</a>
               </li>
               <li>
                  <a href="#">Email</a>
               </li>
               <li>
                  <a href="#">Link</a>
               </li>
            </ul>
         </div>
      </div>
   </xsl:template>
</xsl:stylesheet>
