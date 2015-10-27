<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xtf="http://cdlib.org/xtf" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:mets="http://www.loc.gov/METS/"
   xmlns:lxslt="http://xml.apache.org/xslt" xmlns:result="http://www.example.com/results" xmlns:mods="http://www.loc.gov/mods/v3" xmlns="http://www.w3.org/1999/xhtml"
   xmlns:session="java:org.cdlib.xtf.xslt.Session" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:FileUtils="java:org.cdlib.xtf.xslt.FileUtils" extension-element-prefixes="session result" exclude-result-prefixes="#all">
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
   <xsl:param name="restricted"/>

   <!-- ====================================================================== -->
   <!-- Root Template                                                          -->
   <!-- ====================================================================== -->
   <xsl:template match="/mets:mets">
      <xsl:choose>
         <!-- DAO tables in EAD container lists -->
         <xsl:when test="$smode='daoTable'">
            <xsl:for-each select=".">
               <xsl:call-template name="daoSummary"/>
            </xsl:for-each>
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
      <xsl:variable name="collectionId">
         <xsl:value-of select="substring-before(xtf:meta/*:collectionId, '.xml')"/>
      </xsl:variable>
      <xsl:variable name="formattedCollectionId">
         <xsl:value-of select="concat('(',$collectionId,')')"/>
      </xsl:variable>
      <xsl:result-document exclude-result-prefixes="#all">
         <html xml:lang="en" lang="en">
            <head>
               <xsl:copy-of select="$brand.links"/>
               <script src="/xtf/script/rac/fb.js"/>
               <!-- copy to clipboard scrips -->
               <script type="text/javascript" src="/xtf/script/rac/ZeroClipboard.min.js"/>
               <script type="text/javascript">
                  $(document).ready(function() {
                  var client = new ZeroClipboard($('#copy-link'));
                  });
               </script>
               <!-- Twitter script -->
               <script>
                  window.twttr=(function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],t=window.twttr||{};if(d.getElementById(id))return;js=d.createElement(s);js.id=id;js.src="https://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);t._e=[];t.ready=function(f){t._e.push(f);};return t;}(document,"script","twitter-wjs"));
               </script>
               <title>
                  <xsl:value-of select="xtf:meta/*:filename"/>
                  <xsl:text> - </xsl:text>
                  <xsl:value-of select="xtf:meta/*:collectionTitle"/>
                  <xsl:value-of select="$formattedCollectionId"/>
               </title>
               <!-- Twitter Card meta tags -->
               <meta name="twitter:card" content="summary_large_image"/>
               <meta name="twitter:site" content="@rockarch_org"/>
               <meta name="twitter:title" content="{xtf:meta/*:filename}"/>
               <meta name="twitter:description" content="From {xtf:meta/*:collectionTitle} {$formattedCollectionId}. {mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/*:xmlData/mods:mods/mods:note[@displayLabel='Scope and Contents Note']}"/>
               <meta name="twitter:image" content="{concat(substring-before(mets:fileSec/mets:fileGrp/mets:file/mets:FLocat/@xlink:href, '.pdf'), '_thumb300.jpg')}"/>
               <!-- Open Graph meta tags -->
               <meta property="og:url" content="{concat(substring-before($xtfURL, 'xtf/'), xtf:meta/*:identifier)}"/>
               <meta property="og:title" content="{xtf:meta/*:filename}"/>
               <meta property="og:description" content="From {xtf:meta/*:collectionTitle} {$formattedCollectionId}. {mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/*:xmlData/mods:mods/mods:note[@displayLabel='Scope and Contents Note']}"/>
               <meta property="og:image" content="{concat(substring-before(mets:fileSec/mets:fileGrp/mets:file/mets:FLocat/@xlink:href, '.pdf'), '_thumbfb.jpg')}"/>
               <meta property="og:image:width" content="600"/>
               <meta property="og:image:height" content="316"/>
            </head>
            <body>
               <!-- schema.org meta tags -->
               <div itemscope="" itemtype="http://schema.org/ItemPage">
                  <xsl:if
                     test="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/*:xmlData/mods:mods/mods:abstract | mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/*:xmlData/mods:mods/mods:note[@displayLabel='Scope and Contents Note']">
                     <meta itemprop="http://schema.org/description">
                        <xsl:attribute name="content">
                           <xsl:value-of select="concat('From ', xtf:meta/*:collectionTitle, ' ',$formattedCollectionId,'. ',mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/*:xmlData/mods:mods/mods:note[@displayLabel='Scope and Contents Note'])"/>
                        </xsl:attribute>
                     </meta>
                  </xsl:if>
                  <meta itemprop="http://schema.org/name">
                     <xsl:attribute name="content">
                        <xsl:value-of select="xtf:meta/*:filename"/>
                     </xsl:attribute>
                  </meta>
                  <div itemprop="http://schema.org/contentLocation" itemtype="http://schema.org/Place" itemscope="">
                     <meta itemprop="http://schema.org/name" content="Rockefeller Archive Center"/>
                     <meta itemprop="http://schema.org/url" content="http://www.rockarch.org"/>
                     <div itemprop="http://schema.org/address" itemscope="" itemtype="http://schema.org/PostalAddress">
                        <meta itemprop="streetAddress" content="15 Dayton Avenue"/>
                        <meta itemprop="addressLocality" content="Sleepy Hollow"/>
                        <meta itemprop="addressRegion" content="NY"/>
                        <meta itemprop="postalCode" content="10591"/>
                     </div>
                     <div itemprop="http://schema.org/geo" itemscope="" itemtype="http://schema.org/GeoCoordinates">
                        <meta itemprop="http://schema.org/latitude" content="41.091845"/>
                        <meta itemprop="http://schema.org/longitude" content="-73.835265"/>
                     </div>
                     <meta itemprop="http://schema.org/telephone" content="(914) 366-6300"/>
                  </div>
                  <xsl:for-each select="xtf:meta/*:creator">
                     <meta itemprop="http://schema.org/creator">
                        <xsl:attribute name="content">
                           <xsl:value-of select="."/>
                        </xsl:attribute>
                     </meta>
                  </xsl:for-each>
                  <meta itemprop="http://schema.org/dateCreated">
                     <xsl:attribute name="content">
                        <xsl:value-of select="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/*:xmlData/mods:mods/mods:originInfo/mods:dateCreated"/>
                     </xsl:attribute>
                  </meta>
                  <meta itemprop="http:/schema.org/keywords">
                     <xsl:attribute name="content">
                        <xsl:for-each select="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/*:xmlData/mods:mods/mods:subject/mods:topic">
                           <xsl:value-of select="."/>
                           <xsl:if test="position() != last()">
                              <xsl:text>, </xsl:text>
                           </xsl:if>
                        </xsl:for-each>
                     </xsl:attribute>
                  </meta>
               </div>
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
               <div id="daoView">
                  <xsl:call-template name="daoView"/>
               </div>
               <div id="copyLink">
                  <xsl:call-template name="copyLink"/>
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
            <form action="{$xtfURL}{$crossqueryPath}" method="get" class="bbform">
               <input name="keyword" type="text">
                  <xsl:attribute name="value">
                     <xsl:value-of select="$query"/>
                  </xsl:attribute>
               </input>
               <select id="searchTarget">
                  <option data-url="{$xtfURL}{$crossqueryPath}" selected="selected">Everything</option>
                  <option data-url="{$xtfURL}{$dynaxmlPath}">This collection</option>
               </select>
               <input type="hidden" name="docId" value="{$collectionId}" disabled="disabled"/>
               <input type="hidden" name="chunk.id" value="contentsLink" disabled="disabled"/>
               <input type="hidden" name="doc.view" value="contentsSearch" disabled="disabled"/>
               <input type="submit" value="Search" onclick="_gaq.push(['_trackEvent', 'finding aid', 'search', 'Digital Object details']);"/>
            </form>
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
      <div id="content-wrapper">
         <div id="content-right">
            <xsl:call-template name="bookmarkMenu"/>
            <div class="digital-thumbnail">
               <xsl:variable name="href">
                  <xsl:choose>
                     <xsl:when test="xtf:meta/*:viewable='true'">
                        <xsl:value-of select="concat(substring-before(mets:fileSec/mets:fileGrp/mets:file/mets:FLocat/@xlink:href, '.pdf'), '_thumb300.jpg')"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of>/xtf/icons/default/thumbnail-large.svg</xsl:value-of>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>
               <img src="{$href}" width="100%">
                  <xsl:if test="xtf:meta/*:viewable='true'">
                     <xsl:attribute name="class">view</xsl:attribute>
                  </xsl:if>
               </img>
               <xsl:if test="xtf:meta/*:viewable='true' or xtf:meta/*:rights='allow'">
                 <div class="thumbnailButtons">
                    <xsl:if test="xtf:meta/*:rights='allow'">
                        <a href="{mets:fileSec/mets:fileGrp/mets:file/mets:FLocat/@xlink:href}" download="true" class="btn btn-default download"><img src="/xtf/icons/default/download.svg"/> Download</a>
                    </xsl:if>
                    <xsl:if test="xtf:meta/*:viewable='true'">
                        <a href="#" class="btn btn-default view"><img src="/xtf/icons/default/view.svg"/> View</a>
                    </xsl:if>
                 </div>
               </xsl:if>
            </div>
            <div class="description">
               <div class="title">
                  <h2>
                     <xsl:value-of select="xtf:meta/*:filename"/>
                  </h2>
               </div>
               <div class="creator">
                  <xsl:for-each select="xtf:meta/*:creator">
                     <p>
                        <xsl:value-of select="."/>
                     </p>
                  </xsl:for-each>
               </div>
               <div class="extent">
                  <p>
                     <xsl:value-of select="xtf:meta/*:format"/>
                     <xsl:if test="xtf:meta/*:size !='unknown'">
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="FileUtils:humanFileSize(xtf:meta/*:size)"/>
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

   <!-- Handle restrictions notes -->
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
      <xsl:if test="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mets:xmlData/mods:mods/mods:subject/mods:topic">
         <div class="subjects">
            <h4>Subjects</h4>
            <ul class="none">
               <xsl:apply-templates select="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mets:xmlData/mods:mods/mods:subject/mods:topic"/>
            </ul>
         </div>
      </xsl:if>
      <xsl:if test="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mets:xmlData/mods:mods/mods:subject/mods:geographic">
         <div class="subjects">
            <h4>Places</h4>
            <ul class="none">
               <xsl:apply-templates select="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mets:xmlData/mods:mods/mods:subject/mods:geographic"/>
            </ul>
         </div>
      </xsl:if>
      <xsl:if test="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mets:xmlData/mods:mods/mods:name[@type='personal']">
         <div class="subjects">
            <h4>People</h4>
            <ul class="none">
               <xsl:apply-templates select="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mets:xmlData/mods:mods/mods:name[@type='personal']"/>
            </ul>
         </div>
      </xsl:if>
      <xsl:if test="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mets:xmlData/mods:mods/mods:name[@type='corporate']">
         <div class="subjects">
            <h4>Organizations</h4>
            <ul class="none">
               <xsl:apply-templates select="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mets:xmlData/mods:mods/mods:name[@type='corporate']"/>
            </ul>
         </div>
      </xsl:if>
      <xsl:if test="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mets:xmlData/mods:mods/mods:name[@type='family']">
         <div class="subjects">
            <h4>Families</h4>
            <ul class="none">
               <xsl:apply-templates select="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mets:xmlData/mods:mods/mods:name[@type='family']"/>
            </ul>
         </div>
      </xsl:if>
      <xsl:if test="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mets:xmlData/mods:mods/mods:name[@type='conference']">
         <div class="subjects">
            <h4>Conferences</h4>
            <ul class="none">
               <xsl:apply-templates select="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mets:xmlData/mods:mods/mods:name[@type='conference']"/>
            </ul>
         </div>
      </xsl:if>
      <xsl:if test="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mets:xmlData/mods:mods/mods:genre">
         <div class="subjects">
            <h4>Formats</h4>
            <ul class="none">
               <xsl:apply-templates select="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mets:xmlData/mods:mods/mods:genre"/>
            </ul>
         </div>
      </xsl:if>
   </xsl:template>

   <xsl:template match="mods:subject/mods:topic | mods:subject/mods:geographic | mods:subject/mods:genre">
      <xsl:for-each select=".">
         <li>
            <xsl:value-of select="."/>
         </li>
      </xsl:for-each>
   </xsl:template>

   <xsl:template match="mods:name">
      <li>
         <xsl:choose>
            <xsl:when test="@type='personal'">
               <xsl:value-of select="normalize-space(mods:namePart[@type='family'])"/>
               <xsl:if test="mods:namePart[@type='given']">
                  <xsl:text>, </xsl:text>
                  <xsl:value-of select="normalize-space(mods:namePart[@type='given'])"/>
               </xsl:if>
            </xsl:when>
            <xsl:otherwise>
               <xsl:for-each select="mods:namePart">
                  <xsl:value-of select="normalize-space(.)"/>
                  <xsl:if test="position() != last()">
                     <xsl:text> </xsl:text>
                  </xsl:if>
               </xsl:for-each>
            </xsl:otherwise>
         </xsl:choose>
      </li>
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
         <h4>Found In</h4>
         <p style="color:#c45414;margin-top:1em;" data-collectionId="{$collectionId}" data-componentId="{$componentId}" data-filename="{xtf:meta/*:filename}" data-identifier="{xtf:meta/*:identifier}">
            <img style="margin:0 .5em 0 1em;" src="/xtf/icons/default/loading.gif"/> Loading </p>
      </div>
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- Bookmark options menu                                                  -->
   <!-- ====================================================================== -->

   <xsl:template name="bookmarkMenu">
      <div class="pull-right" id="bookmarkMenu">
         <div class="button">
            <a href="https://twitter.com/share" class="twitter-share-button" data-dnt="true" data-count="none" data-via="rockarch_org"
               data-url="{concat(substring-before($xtfURL, 'xtf/'), xtf:meta/*:identifier)}"/>
         </div>
         <div class="button">
            <div class="fb-share-button" data-href="{concat(substring-before($xtfURL, 'xtf/'), xtf:meta/*:identifier)}" data-layout="button"/>
         </div>
         <div class="button">
            <button class="btn btn-default link">
               <img src="/xtf/icons/default/link.svg"/> Link </button>
         </div>
      </div>
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- DAO summary for tables                                                 -->
   <!-- ====================================================================== -->

   <xsl:template name="daoSummary">
      <xsl:variable name="link">
         <xsl:value-of select="concat(substring-before($xtfURL, 'xtf/'), xtf:meta/*:identifier)"/>
      </xsl:variable>
      <xsl:variable name="downloadLink">
         <xsl:value-of select="concat('http://storage.rockarch.org/', xtf:meta/*:identifier, '-', xtf:meta/*:filename)"/>
      </xsl:variable>
      <div class="row">
         <a href="{$link}">
            <div class="filename">
               <xsl:value-of select="xtf:meta/*:filename"/>
            </div>
            <div class="format">
               <xsl:value-of select="xtf:meta/*:format"/>
            </div>
            <div class="size">
               <xsl:choose>
                  <xsl:when test="string(number(xtf:meta/*:size)) != 'NaN'">
                     <xsl:value-of select="FileUtils:humanFileSize(xtf:meta/*:size)"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="xtf:meta/*:size"></xsl:value-of>
                  </xsl:otherwise>
               </xsl:choose>
            </div>
         </a>
      </div>
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- DAO modal windows                                                      -->
   <!-- ====================================================================== -->

   <xsl:template name="daoView">
      <xsl:if test="xtf:meta/*:viewable='true'">
      <xsl:variable name="srcUrl">
         <xsl:choose>
            <xsl:when test="ends-with(mets:fileSec/mets:fileGrp/mets:file/mets:FLocat/@xlink:href, '.pdf')">
               <xsl:value-of select="concat(mets:fileSec/mets:fileGrp/mets:file/mets:FLocat/@xlink:href, '#zoom=100')"></xsl:value-of>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="mets:fileSec/mets:fileGrp/mets:file/mets:FLocat/@xlink:href"></xsl:value-of>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <iframe frameborder="0" marginwidth="0" marginheight="0" src="{$srcUrl}"/>
      </xsl:if>
   </xsl:template>

   <xsl:template name="copyLink">
      <input type="text" value="{concat(substring-before($xtfURL, 'xtf/'), xtf:meta/*:identifier)}"/>
      <button class="btn btn-sm" id="copy-link" href="#" data-clipboard-text="{concat(substring-before($xtfURL, 'xtf/'), xtf:meta/*:identifier)}"> Copy to clipboard </button>
      <div class="success">
         <p>Link copied to clipboard!</p>
      </div>
   </xsl:template>

</xsl:stylesheet>
