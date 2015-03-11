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
         <xsl:when test="$smode='daoTable'">
            <xsl:call-template name="daoSummary"/>
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
                  <xsl:value-of select="xtf:meta/*:filename"/>
                  <xsl:text> - </xsl:text>
                  <xsl:value-of select="xtf:meta/*:collectionTitle"/>
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
                        <xsl:value-of select="xtf:meta/*:filename"/>
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
                  <xsl:for-each select="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mods:xmlData/mods:mods/mods:subject/mods:name[mods:role/mods:roleTerm='contributor']">
                     <meta itemprop="http:/schema.org/contributor">
                        <xsl:attribute name="content">
                           <xsl:apply-templates/>
                        </xsl:attribute>
                     </meta>
                  </xsl:for-each>
                  <xsl:for-each select="xtf:meta/*:creator">
                     <meta itemprop="http:/schema.org/creator">
                        <xsl:attribute name="content">
                           <xsl:value-of select="."/>
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
               <div class="main">
                  <div id="tocWrapper">
                     <div id="toc">
                        <xsl:call-template name="foundIn"/>
                        <xsl:call-template name="subjects"/>
                     </div>
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
      <xsl:variable name="collectionTitle">
         <xsl:value-of select="xtf:meta/*:collectionTitle"/>
      </xsl:variable>
      <xsl:if test="string-length($collectionTitle) &gt; 175">
         <xsl:attribute name="style"> font-size:1.15em; </xsl:attribute>
      </xsl:if>
      <xsl:variable name="eadId">
         <xsl:value-of select="xtf:meta/*:collectionId"/>
      </xsl:variable>
      <xsl:variable name="collectionId">
         <xsl:value-of select="substring-before($eadId, '.xml')"/>
      </xsl:variable>
      <div class="bbar_custom">
         <div class="documentTitle ead">
            <h1>
               <xsl:text>A Guide to the </xsl:text>
               <xsl:value-of select="$collectionTitle"/>
               <br/>
               <xsl:value-of select="$collectionId"/>
            </h1>
         </div>
         <div class="headerIcons">
            <ul>
               <li>
                  <a href="{$xtfURL}/media/pdf/{$collectionId}.pdf" onClick="_gaq.push(['_trackEvent', 'finding aid', 'view', 'pdf']);">
                     <img src="/xtf/icons/default/pdf.gif" alt="PDF" title="PDF"/>
                  </a>
               </li>
            </ul>
         </div>
         <div class="headerSearch">
            <form action="{$xtfURL}{$dynaxmlPath}" method="get" class="bbform">
               <input name="query" type="text"/>
               <input type="hidden" name="docId" value="ead/{$collectionId}/{$eadId}"/>
               <input type="hidden" name="chunk.id" value="contentsLink"/>
               <input type="hidden" name="doc.view" value="contentsSearch"/>
               <input type="submit" value="Search Contents List" onclick="_gaq.push(['_trackEvent', 'finding aid', 'search', 'Digital Materials Detail']);"/>
            </form>
            <div class="searchAll">
               <a href="{$xtfURL}{$crossqueryPath}">Search all collections</a>
            </div>
         </div>
         <xsl:call-template name="tabs"/>
      </div>
   </xsl:template>
   <!-- ====================================================================== -->
   <!-- Tabs Templates                                                          -->
   <!-- ====================================================================== -->
   <xsl:template name="tabs">
      <div class="tabs">
         <div class="tab collectionTab">
            <xsl:call-template name="make-tab-link">
               <xsl:with-param name="name" select="'Collection Description'"/>
               <xsl:with-param name="id" select="'headerlink'"/>
               <xsl:with-param name="doc.view" select="'collection'"/>
            </xsl:call-template>
         </div>
         <div class="tab contentsTab">
            <xsl:choose>
               <xsl:when test="xtf:meta/*:componentTitle != ''">
                  <xsl:call-template name="make-tab-link">
                     <xsl:with-param name="name" select="'Contents List'"/>
                     <xsl:with-param name="id" select="'contentsLink'"/>
                     <xsl:with-param name="doc.view" select="'contents'"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:attribute name="class">clear</xsl:attribute>
               </xsl:otherwise>
            </xsl:choose>
         </div>
         <div class="tab digitalTab select">
            <xsl:call-template name="make-tab-link">
               <xsl:with-param name="name" select="'Digital Materials'"/>
               <xsl:with-param name="id" select="'digitalLink'"/>
               <xsl:with-param name="doc.view" select="'dao'"/>
            </xsl:call-template>
         </div>
      </div>
   </xsl:template>

   <xsl:template name="make-tab-link">
      <xsl:param name="name"/>
      <xsl:param name="id"/>
      <xsl:param name="doc.view"/>
      <xsl:param name="indent" select="1"/>
      <xsl:variable name="collectionId">
         <xsl:value-of select="substring-before(xtf:meta/*:collectionId, '.xml')"/>
      </xsl:variable>
      <!-- HA todo: hits??? -->
      <!-- HA todo: add support for queries -->
      <!--<xsl:variable name="hit.count">
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
      </xsl:variable>-->
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
      <a onclick="_gaq.push(['_trackEvent', 'finding aid', 'tab', '{$tracking-id}']);">

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

         <xsl:attribute name="href">
            <xsl:value-of select="concat($xtfURL2, $collectionId, '/', $basicchoice2)"/>
         </xsl:attribute>
         <xsl:value-of select="$name"/>
      </a>
      <!--<xsl:if test="string-length($hit.count) &gt; 0 and $hit.count != '0'">
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
            <xsl:call-template name="bookmarkMenu"/>
            <div class="thumbnail">
               <img src="/xtf/icons/default/thumbnail-large.png" height="300px"/>
               <div class="thumbnailButtons">
                  <button class="btn btn-default download"><img src="/xtf/icons/default/download.png"/> Download</button>
                  <button class="btn btn-default view"><img src="/xtf/icons/default/view.png"/> View</button>
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
                     <xsl:value-of select="xtf:meta/*:format"/>
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
      <!-- HA todo: link subject terms -->
      <div class="subjects">
         <xsl:if test="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mets:xmlData/mods:mods/mods:subject">
            <xsl:apply-templates select="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mets:xmlData/mods:mods/mods:subject"/>
         </xsl:if>
      </div>
   </xsl:template>

   <xsl:template match="mods:subject">
      <!-- HA todo: check if this is correct. names may not export as subjects -->
      <xsl:if test="mods:topic">
         <h4>Subjects</h4>
         <ul class="none">
            <xsl:for-each select="mods:topic">
               <li>
                  <xsl:value-of select="."/>
               </li>
            </xsl:for-each>
         </ul>
      </xsl:if>
      <xsl:if test="mods:geographic">
         <h4>Places</h4>
         <ul class="none">
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
            <ul class="none">
               <xsl:for-each select="mods:name[@type='personal']">
                  <li>
                     <xsl:apply-templates/>
                  </li>
               </xsl:for-each>
            </ul>
         </xsl:if>
         <xsl:if test="mods:name[@type='corporate']">
            <h4>Organizations</h4>
            <ul class="none">
               <xsl:for-each select="mods:name[@type='corporate']">
                  <li>
                     <xsl:apply-templates/>
                  </li>
               </xsl:for-each>
            </ul>
         </xsl:if>
         <xsl:if test="mods:name[@type='family']">
            <h4>Families</h4>
            <ul class="none">
               <xsl:for-each select="mods:name[@type='family']">
                  <li>
                     <xsl:apply-templates/>
                  </li>
               </xsl:for-each>
            </ul>
         </xsl:if>
         <xsl:if test="mods:name[@type='conference']">
            <h4>Conferences</h4>
            <ul class="none">
               <xsl:for-each select="mods:name[@type='conference']">
                  <li>
                     <xsl:apply-templates/>
                  </li>
               </xsl:for-each>
            </ul>
         </xsl:if>
      </xsl:if>
      <xsl:if test="mods:genre">
         <h4>Formats</h4>
         <ul class="none">
            <xsl:for-each select="mods:genre">
               <li>
                  <xsl:value-of select="."/>
               </li>
            </xsl:for-each>
         </ul>
      </xsl:if>

   </xsl:template>

   <xsl:template match="mods:name">
      <xsl:for-each select="mods:namePart">
         <xsl:value-of select="normalize-space(.)"/>
         <xsl:if test="position() != last()">&#160;</xsl:if>
      </xsl:for-each>
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- EAD Hierarchy Templates                                                -->
   <!-- ====================================================================== -->
   <xsl:template name="foundIn">
      <xsl:variable name="collectionId">
         <xsl:value-of select="xtf:meta/*:collectionId"/>
      </xsl:variable>
      <xsl:variable name="componentId">
         <xsl:value-of select="xtf:meta/*:componentId"/>
      </xsl:variable>
      <div class="foundIn">
         <h3>Found In</h3>
         <p data-collectionId="{$collectionId}" componentId="{$componentId}"/>
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
   
   <!-- ====================================================================== -->
   <!-- DAO summary for tables                                                 -->
   <!-- ====================================================================== -->
   
   <xsl:template name="daoSummary">
      <xsl:variable name="link">
         <xsl:value-of select="concat('/xtf/view?docId=mets/', xtf:meta/*:identifier, '_mets/', xtf:meta/*:identifier, '_mets.xml')"/>
      </xsl:variable>
      <tr>
         <td>
            <xsl:value-of select="xtf:meta/*:filename"/>
         </td>
         <td>
            <xsl:value-of select="xtf:meta/*:format"/>
         </td>
         <td>
            <xsl:value-of select="xtf:meta/*:size"/>
         </td>
         <td><a href="{$link}">details</a></td>
      </tr>
   </xsl:template>
   
   
</xsl:stylesheet>
