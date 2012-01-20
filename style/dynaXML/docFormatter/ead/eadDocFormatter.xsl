<xsl:stylesheet version="2.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xtf="http://cdlib.org/xtf"
   xmlns="http://www.w3.org/1999/xhtml"
   xmlns:session="java:org.cdlib.xtf.xslt.Session"
   extension-element-prefixes="session"
   exclude-result-prefixes="#all"
   xpath-default-namespace="urn:isbn:1-931666-22-9">
   
   <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
   <!-- EAD dynaXML Stylesheet                                                 -->
   <!-- 9/27/11 WS: Edited for Rockefeller Archives Center                     -->
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
<!--   <xsl:import href="at_eadToPDF.xsl"/>-->
   <!-- ====================================================================== -->
   <!-- Output Format                                                          -->
   <!-- ====================================================================== -->
   
   <xsl:output method="xhtml" indent="yes" 
      encoding="UTF-8" media-type="text/html; charset=UTF-8" 
      doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" 
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
      exclude-result-prefixes="#all"
      omit-xml-declaration="yes"/>
      
<!--   <xsl:output method="xml"/>-->
   
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
   <!--          
      <xsl:when test="$chunk.id != 0">
      <xsl:apply-templates select="key('chunk-id', $chunk.id)"/>
      </xsl:when>
   -->
   <!-- ====================================================================== -->
   
   <xsl:key name="chunk-id" match="*[parent::archdesc or matches(local-name(), '^(c|c[0-9][0-9])$')][@id]" use="@id"/>
   
   <!-- ====================================================================== -->
   <!-- EAD-specific parameters                                                -->
   <!-- ====================================================================== -->

   <!-- If a query was specified but no particular hit rank, jump to the first hit 
        (in document order) 
   -->
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
            <xsl:value-of select="'0'"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:param>
   
   <!-- ====================================================================== -->
   <!-- Root Template                                                          -->
   <!-- ====================================================================== -->
   
   <xsl:template match="/ead">
      <xsl:choose>
         <!-- robot solution -->
         <xsl:when test="matches($http.user-agent,$robots)">
            <xsl:call-template name="robot"/>
         </xsl:when>
         <!-- Creates the button bar.-->
         <xsl:when test="$doc.view = 'bbar'">
            <xsl:call-template name="bbar"/>
         </xsl:when>
         <!-- Creates the basic table of contents.-->
         <xsl:when test="$doc.view = 'toc'">
            <xsl:call-template name="toc"/>
         </xsl:when>
         <!-- Creates the body of the finding aid.-->
         <xsl:when test="$doc.view = 'content'">
            <xsl:call-template name="body"/>
         </xsl:when>
         <!-- pdf view -->
         <xsl:when test="$doc.view='print'">
            <xsl:call-template name="print"/>
         </xsl:when>
         <!-- popup for additional formats -->
         <xsl:when test="$doc.view='additionalFormats'">
            <xsl:call-template name="additionalFormats"/>
         </xsl:when>
         <!-- popup for file level descriptions -->
         <xsl:when test="$doc.view='dscDescription'">
            <xsl:call-template name="dscDescription"/>
         </xsl:when>
         <xsl:when test="$doc.view='dscRelatedmaterial'">
            <xsl:call-template name="dscRelatedmaterial"/>
         </xsl:when>
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
      <xsl:variable name="toc.href"><xsl:value-of select="$query.string"/>;doc.view=toc;brand=<xsl:value-of select="$brand"/>;chunk.id=<xsl:value-of select="$chunk.id"/>;<xsl:value-of select="$search"/>#X</xsl:variable>
      <xsl:variable name="content.href"><xsl:value-of select="$query.string"/>;doc.view=content;brand=<xsl:value-of select="$brand"/>;chunk.id=<xsl:value-of select="$chunk.id"/><xsl:value-of select="$search"/></xsl:variable>
      
      <xsl:result-document exclude-result-prefixes="#all">
   
         <html xml:lang="en" lang="en">
            <head>
               <link rel="stylesheet" type="text/css" href="{$css.path}ead.css"/>
               <xsl:copy-of select="$brand.links"/>
               <title>
                  <xsl:value-of select="eadheader/filedesc/titlestmt/titleproper"/>
                  <xsl:text>  </xsl:text>
                  <xsl:value-of select="eadheader/filedesc/titlestmt/subtitle"/>
               </title>
            </head>
            <body>
               <div class="fixedHeader">
                  <xsl:copy-of select="$brand.header"/>
                  <xsl:call-template name="bbar_custom"/>
                  <br class="clear"/>
               </div>
               <div class="main">
                  <xsl:call-template name="toc"/>
                  <xsl:call-template name="body"/>    
                  <br class="clear"/>
               </div>
          </body>
         </html>
      </xsl:result-document>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- 9/27/11 WS: Internal navbar ammended from docFormatterCommon           -->
   <!-- ====================================================================== -->
   <xsl:template name="bbar_custom">
      <xsl:variable name="sum">
         <xsl:choose>
            <xsl:when test="($query != '0') and ($query != '')">
               <xsl:value-of select="number(/*[1]/@xtf:hitCount)"/>
            </xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="occur">
         <xsl:choose>
            <xsl:when test="$sum != 1">occurrences</xsl:when>
            <xsl:otherwise>occurrence</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <div class="bbar_custom">
         <h1 id="collectionGuides">
            <a href="/xtf/search">
               <span></span>
               Collection Guides
            </a>
         </h1>
         <table class="searchNav">
            <tr>
               <td colspan="2">
                  <div class="searchLinks">
                     <xsl:if test="$query !=''">
                        <!-- DOES not work, the urls are exactly the same!
                           1/19/12 WS: added back to search results link, only if search is NOT internal
                        <xsl:choose>
                           <xsl:when test="$brand != ''">
                              <a href="{session:getData('queryURL')}">
                                 <xsl:text>SEARCH RESULTS</xsl:text>
                              </a> | 
                              <a href="{session:getData('queryURL')}">
                                 <xsl:text>MODIFY SEARCH</xsl:text>
                              </a> |                                                            
                           </xsl:when>
                           <xsl:otherwise/>                           
                           </xsl:choose>-->
                        <a href="{session:getData('queryURL')}">
                           <xsl:text>SEARCH RESULTS</xsl:text>
                        </a> | 
                     </xsl:if>
                     <a href="{$xtfURL}/search">
                        <xsl:text>NEW SEARCH</xsl:text>
                     </a>
                     <xsl:text>&#160;|&#160;</xsl:text>
                     <a href="search?smode=browse">
                        <xsl:text>BROWSE</xsl:text>
                     </a>
                  </div>
               </td>
            </tr>
         </table>
         <div class="navright">
            <div class="right">
               <!-- <a href="javascript://" onclick="javascript:window.open('/xtf/search?smode=getLang','popup','width=500,height=200,resizable=no,scrollbars=no')">Choose Language</a>-->
               <form action="{$xtfURL}{$dynaxmlPath}" target="_top" method="get">
                  <input name="query" type="text" size="15"/> 
                  <input type="hidden" name="docId" value="{$docId}"/>
                  <input type="hidden" name="chunk.id" value="{$chunk.id}"/>
                  <input type="submit" value="Search this Collection"/>
               </form>               
               <!--   <xsl:variable name="bag" select="session:getData('bag')"/>
                  <a href="/xtf/search?smode=showBag">Bookbag</a>
                  (<span id="bagCount"><xsl:value-of select="count($bag/bag/savedDoc)"/></span>)
                | -->
               <a>
                  <xsl:attribute name="href">javascript://</xsl:attribute>
                  <xsl:attribute name="onclick">
                     <xsl:text>javascript:window.open('</xsl:text><xsl:value-of select="$xtfURL"/><xsl:value-of select="$dynaxmlPath"/><xsl:text>?docId=</xsl:text><xsl:value-of
                        select="$docId"/><xsl:text>;doc.view=citation</xsl:text><xsl:text>','popup','width=500,height=200,resizable=yes,scrollbars=no')</xsl:text>
                  </xsl:attribute>
                  <xsl:text>Citation</xsl:text>
               </a>
               <xsl:text> | </xsl:text>
               <a href="{$doc.path}&#038;doc.view=print;chunk.id={$chunk.id}" target="_top">Print View</a>
            </div>
            <div class="eadtitle">
               <h1><xsl:value-of select="eadheader/filedesc/titlestmt/titleproper"/></h1>
            </div>
            <br class="clear"/> 
            <div class="left">
               <xsl:if test="($query != '0') and ($query != '')">
                  <div>
                     <strong>
                        <span class="hit-count">
                           <xsl:value-of select="$sum"/>
                        </span>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$occur"/>
                        <xsl:text> of </xsl:text>
                        <span class="hit-count">
                           <xsl:value-of select="$query"/>
                        </span>
                     </strong>
                     <br/>
                     <xsl:text> [</xsl:text>
                     <a>
                        <xsl:attribute name="href">
                           <xsl:value-of select="$doc.path"/>;brand=<xsl:value-of select="$brand"/>
                        </xsl:attribute>
                        <xsl:text>Clear Hits</xsl:text>
                     </a>
                     <xsl:text>]</xsl:text>
                     <!-- 1/19/12 WS: added back to search results link, only if search is NOT internal-->
                     <xsl:choose>
                        <xsl:when test="$docId"/>
                        <xsl:otherwise>
                           &#160;[
                           <a href="{session:getData('queryURL')}">
                              Back to Search Results
                           </a>
                           ]
                        </xsl:otherwise>
                     </xsl:choose>
                  </div>
               </xsl:if>
            </div>   
            <xsl:call-template name="tabs"/>            
         </div>
      </div>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Tabs Templates                                                          -->
   <!-- ====================================================================== -->
   
   <xsl:template name="tabs">
      <div class="tabs">
         <xsl:variable name="content.href"><xsl:value-of select="$query.string"/>;brand=<xsl:value-of select="$brand"/><xsl:value-of select="$search"/></xsl:variable>
         <ul>
            <li>               
               <xsl:choose>
                  <xsl:when test="$doc.view = 'collection'">
                     <xsl:attribute name="class">select</xsl:attribute>
                  </xsl:when>
                  <xsl:when test="$doc.view = 'contents'">
                     <xsl:attribute name="class"/>
                  </xsl:when>
                  <xsl:when test="$doc.view = 'digital'">
                     <xsl:attribute name="class"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:attribute name="class">select</xsl:attribute>                     
                  </xsl:otherwise>
               </xsl:choose>  
                  <xsl:call-template name="make-tab-link">
                     <xsl:with-param name="name" select="'Collection Description'"/>
                     <xsl:with-param name="id" select="'headerlink'"/>
                     <xsl:with-param name="doc.view" select="'collection'"/>
                     <xsl:with-param name="nodes" select="archdesc/did|archdesc/scopecontent"/>
                  </xsl:call-template>
               
<!--               <a href="{$xtfURL}{$dynaxmlPath}?{$content.href}&amp;doc.view=collection">Collection Description</a>      -->
            </li>
            <li>
               <xsl:if test="$doc.view='contents'">
                  <xsl:attribute name="class">select</xsl:attribute>
               </xsl:if>
               <xsl:call-template name="make-tab-link">
                  <xsl:with-param name="name" select="'Contents List'"/>
                  <xsl:with-param name="id" select="'contentsLink'"/>
                  <xsl:with-param name="doc.view" select="'contents'"/>
                  <xsl:with-param name="nodes" select="archdesc/did/dcs"/>
               </xsl:call-template>
<!--               <a href="{$xtfURL}{$dynaxmlPath}?{$content.href}&amp;doc.view=contents">Contents List</a>-->
            </li>
            <li>
               <xsl:if test="$doc.view='digital'">
                  <xsl:attribute name="class">select</xsl:attribute>
               </xsl:if>
               Digitized Materials
            </li>
         </ul>
      </div>
   </xsl:template>
   
   <xsl:template name="make-tab-link">
      <xsl:param name="name"/>
      <xsl:param name="id"/>
      <xsl:param name="doc.view"/>
      <xsl:param name="nodes"/>
      <xsl:param name="indent" select="1"/>
      <xsl:variable name="hit.count" select="sum($nodes/@xtf:hitCount)"/>
      <xsl:variable name="content.href"><xsl:value-of select="$query.string"/>;chunk.id=<xsl:value-of select="$id"/>;brand=<xsl:value-of select="$brand"/><xsl:value-of select="$search"/>&amp;doc.view=<xsl:value-of select="$doc.view"/></xsl:variable>   
         <a>
            <xsl:attribute name="href">
               <xsl:value-of select="$xtfURL"/><xsl:value-of select="$dynaxmlPath"/>?<xsl:value-of select="$content.href"/>
            </xsl:attribute>
            <xsl:value-of select="$name"/>
         </a>      
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- TOC Templates                                                          -->
   <!-- ====================================================================== -->
   
   <xsl:template name="toc">
      <xsl:call-template name="translate">
         <xsl:with-param name="resultTree"> 
            <div id="tocWrapper">
                  <div id="toc">
 <!--                    <div class="results">
                        <table height="0">
                           <tr>
                              <td>
                                 <b>
                                    <xsl:attribute name="target">_top</xsl:attribute>
                                    <xsl:value-of select="$doc.title"/>
                                 </b>
                              </td>
                           </tr>
                        </table>
                     </div>
                     <br/>-->
                     <!-- The Table of Contents template performs a series of tests to
                        determine which elements will be included in the table
                        of contents.  Each if statement tests to see if there is
                        a matching element with content in the finding aid.-->
                     <xsl:choose>   
                        <xsl:when test="$doc.view='contents'">
                           <div class="contents">
                              <h4>Contents List</h4>
                              <xsl:if test="archdesc/dsc/child::*">
                                 <xsl:apply-templates select="archdesc/dsc/head" mode="tocLink"/>
                                 <!-- Displays the unittitle and unitdates for a c01 if it is a series (as
                                    evidenced by the level attribute series)and numbers them
                                    to form a hyperlink to each.   Delete this section if you do not
                                    wish the c01 titles to appear in the table of contents.-->
                                 <xsl:for-each select="archdesc/dsc/c01[@level='series' or @level='collection' or @level='recordgrp' or @level='fonds' or (@level='otherlevel' and not(child::did/container))]  | archdesc/dsc/c[@level='series' or @level='collection' or @level='recordgrp' or @level='fonds' or (@level='otherlevel' and not(child::did/container))]">
                                    <div class="series">
                                       <xsl:variable name="submenuID">
                                          <xsl:variable name="seriesID">
                                          <xsl:choose>
                                             <xsl:when test="child::*[@level = 'subfonds'] | child::*[@level = 'subgrp']  | child::*[@level = 'subseries'] | child::*[@level = 'collection'] | child::*[@level = 'recordgrp']  | child::*[@level = 'series'] | child::*[@level = 'fonds']">
                                                <xsl:value-of select="child::*[@level = 'subfonds'][1]/@id | child::*[@level = 'subgrp'][1]/@id  | child::*[@level = 'subseries'][1]/@id | child::*[@level = 'collection'][1]/@id | child::*[@level = 'recordgrp'][1]/@id  | child::*[@level = 'series'][1]/@id | child::*[@level = 'fonds'][1]/@id"/>           
                                             </xsl:when>
                                             <xsl:otherwise/>
                                          </xsl:choose>
                                          </xsl:variable>
                                          <xsl:value-of select="concat('dsc',$seriesID)"/>
                                       </xsl:variable>                              
                                       <xsl:call-template name="make-toc-link">
                                          <xsl:with-param name="name">
                                             <xsl:choose>
                                                <xsl:when test="did/unitid">
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
                                                         <xsl:otherwise><xsl:value-of select="did/unitid"/>: </xsl:otherwise>
                                                      </xsl:choose>                                          
                                                   </xsl:variable>
                                                   <xsl:value-of select="concat($levelID,did/unittitle)"/>
                                                </xsl:when>
                                                <xsl:when test="did/unittitle/unitdate">
                                                   <xsl:for-each select="did/unittitle">
                                                      <xsl:value-of select="text()"/>
                                                   </xsl:for-each>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                   <xsl:apply-templates select="did/unittitle"/>
                                                </xsl:otherwise>
                                             </xsl:choose>
                                          </xsl:with-param>
                                          <xsl:with-param name="id" select="@id"/>
                                          <xsl:with-param name="nodes" select="."/>
                                          <xsl:with-param name="indent" select="2"/>
                                       </xsl:call-template> 
                                       <!-- Displays the unittitle and unitdates for each c02 if it is a subseries 
                                          (as evidenced by the level attribute series) and forms a hyperlink to each.   
                                          Delete this section if you do not wish the c02 titles to appear in the 
                                          table of contents. -->
                                       <xsl:if test="child::*[@level='subgrp' or @level='subseries' or @level='subfonds']">
                                          <div class="more" id="{$submenuID}">
                                             <xsl:for-each select="c02[@level='subseries'] | c[@level='subgrp' or @level='subseries' or @level='subfonds']">                                                
                                                   <xsl:call-template name="make-toc-link">
                                                   <xsl:with-param name="name">
                                                      <xsl:choose>
                                                         <xsl:when test="did/unittitle/unitdate">
                                                            <xsl:for-each select="did/unittitle">
                                                               <xsl:value-of select="normalize-space(.)"/>
                                                            </xsl:for-each>
                                                         </xsl:when>
                                                         <xsl:otherwise>
                                                            <xsl:apply-templates select="did/unittitle"/>
                                                         </xsl:otherwise>
                                                      </xsl:choose>
                                                   </xsl:with-param>
                                                   <xsl:with-param name="id" select="@id"/>
                                                   <xsl:with-param name="nodes" select="."/>
                                                   <xsl:with-param name="indent" select="3"/>
                                                </xsl:call-template>
                                             </xsl:for-each>                                   
                                          </div>
                                       </xsl:if>
                                       <!--This ends the section that causes the c02 titles to appear in the table of contents.-->
                                    </div>
                                 </xsl:for-each>
                                 <!--This ends the section that causes the c01 titles to appear in the table of contents.-->
                              </xsl:if>
                           </div> 
                        </xsl:when>
                        <xsl:otherwise>  
                           <div class="contents">
                              <h4/>
                              <xsl:if test="archdesc/did">
                                 <xsl:call-template name="make-toc-link">
                                    <xsl:with-param name="name" select="'Overview'"/>
                                    <xsl:with-param name="id" select="'headerlink'"/>
                                    <xsl:with-param name="nodes" select="archdesc/did/child::*[not(name() = 'origination') and not(name() = 'repository')]|archdesc/scopecontent"/>
                                 </xsl:call-template>
                              </xsl:if>
                              <xsl:if test="archdesc/did/head">
                                 <xsl:apply-templates select="archdesc/did/head" mode="tocLink"/>
                              </xsl:if>
                              <xsl:if test="archdesc/userestrict/head   or archdesc/accessrestrict/head   or archdesc/*/userestrict/head   or archdesc/*/accessrestrict/head">
                                 <xsl:call-template name="make-toc-link">
                                    <xsl:with-param name="name" select="'Access and Use'"/>
                                    <xsl:with-param name="id" select="'restrictlink'"/>
                                    <xsl:with-param name="nodes" select="archdesc/relatedmaterial|archdesc/separatedmaterial|archdesc/accessrestrict|archdesc/userestrict|archdesc/phystech|archdesc/prefercite|archdesc/otherfindaid|archdesc/originalsloc|archdesc/altformavail"/>
                                 </xsl:call-template>                        
                              </xsl:if>
                              <xsl:if test="archdesc/arrangement/head">
                                 <xsl:call-template name="make-toc-link">
                                    <xsl:with-param name="name" select="'Arrangement'"/>
                                    <xsl:with-param name="id" select="'arrangementlink'"/>
                                    <xsl:with-param name="nodes" select="archdesc/arrangement"/>
                                 </xsl:call-template>
                                 <!--<xsl:apply-templates select="archdesc/arrangement/head" mode="tocLink"/>-->
                              </xsl:if>
                              <xsl:if test="archdesc/bioghist/head">                        
                                 <xsl:apply-templates select="archdesc/bioghist/head" mode="tocLink"/>
                              </xsl:if> 
                              <xsl:if test="archdesc/controlaccess/head">
                                 <xsl:call-template name="make-toc-link">
                                    <xsl:with-param name="name" select="'Controlled Access Headings'"/>
                                    <xsl:with-param name="id" select="'controlaccesslink'"/>
                                    <xsl:with-param name="nodes" select="archdesc/controlaccess"/>
                                 </xsl:call-template>
                              </xsl:if>
                              <xsl:if test="archdesc/acqinfo/* or  archdesc/processinfo/* or archdesc/prefercite/* or 
                                 archdesc/custodialhist/* or archdesc/processinfo/* or archdesc/appraisal/* or archdesc/accruals/* or archdesc/*/acqinfo/* or archdesc/*/processinfo/* or archdesc/*/prefercite/* or 
                                 archdesc/*/custodialhist/* or archdesc/*/procinfo/* or archdesc/*/appraisal/* or archdesc/*/accruals/*">
                                 <xsl:call-template name="make-toc-link">
                                    <xsl:with-param name="name" select="'Administrative Information'"/>
                                    <xsl:with-param name="id" select="'adminlink'"/>
                                    <xsl:with-param name="nodes" select="archdesc/acqinfo|archdesc/processinfo|archdesc/prefercite|archdesc/custodialhist|archdesc/processinfo|archdesc/appraisal|archdesc/accruals|archdesc/*/acqinfo|archdesc/*/processinfo|archdesc/*/prefercite|archdesc/*/custodialhist|archdesc/*/procinfo|archdesc/*/appraisal|archdesc/*/accruals"/>
                                 </xsl:call-template>
                              </xsl:if>
                              <xsl:if test="archdesc/did/physdesc[@label = 'General Physical Description note']">
                                 <xsl:call-template name="make-toc-link">
                                    <xsl:with-param name="name" select="'Physical Description'"/>
                                    <xsl:with-param name="id" select="'physdesclink'"/>
                                    <xsl:with-param name="nodes" select="archdesc/did/physdesc[@label = 'General Physical Description note']"/>
                                 </xsl:call-template>
                              </xsl:if>   
                           </div>
                           <div class="subjects">
                              <xsl:if test="archdesc/controlaccess">
                                 <hr/>
                                 <h4>Subjects</h4>
                                 <ul class="none">
                                    <xsl:for-each select="archdesc/controlaccess">
                                       <xsl:for-each select="subject |corpname | famname | persname | genreform | title | geogname | occupation">
                                          <li><xsl:apply-templates/></li>
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
   
   <xsl:template name="make-toc-link">
      <xsl:param name="name"/>
      <xsl:param name="id"/>
      <xsl:param name="nodes"/>
      <xsl:param name="indent" select="1"/>
      
      <xsl:variable name="hit.count" select="sum($nodes/@xtf:hitCount)"/>
      <xsl:variable name="content.href"><xsl:value-of select="$query.string"/>;chunk.id=<xsl:value-of select="$id"/>;brand=<xsl:value-of select="$brand"/><xsl:value-of select="$search"/>&amp;doc.view=<xsl:value-of select="$doc.view"/></xsl:variable>

      <xsl:variable name="submenuID">
         <xsl:variable name="seriesID">
            <xsl:choose>
               <xsl:when test="child::*[@level = 'subfonds'] | child::*[@level = 'subgrp']  | child::*[@level = 'subseries'] | child::*[@level = 'collection'] | child::*[@level = 'recordgrp']  | child::*[@level = 'series'] | child::*[@level = 'fonds']">
                  <xsl:value-of select="child::*[@level = 'subfonds'][1]/@id | child::*[@level = 'subgrp'][1]/@id  | child::*[@level = 'subseries'][1]/@id | child::*[@level = 'collection'][1]/@id | child::*[@level = 'recordgrp'][1]/@id  | child::*[@level = 'series'][1]/@id | child::*[@level = 'fonds'][1]/@id"/>           
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:variable>
         <xsl:value-of select="concat('dsc',$seriesID)"/>
      </xsl:variable>   
      <xsl:if test="@id = $chunk.id">
         <a name="X"/>
      </xsl:if>     
      <table>
      <tr>
         <td width="10px" class="moreLess">
            <xsl:if test=".[@level='series' or @level='collection' or @level='recordgrp' or @level='fonds']">
               <xsl:if test="child::*[@level='subgrp' or @level='subseries' or @level='subfonds']">
                  <a  onclick="showHide('{$submenuID}');return false;" class="showLink" id="{$submenuID}-show" href="#">+ </a>  
                  <a class="more" onclick="showHide('{$submenuID}');return false;" id="{$submenuID}-hide" href="#">- </a>
               </xsl:if>            
            </xsl:if>            
         </td>
         <td>
            <xsl:choose>
               <xsl:when test="$indent = 2">
                  <xsl:attribute name="class">inventory</xsl:attribute>
               </xsl:when>
               <xsl:when test="$indent = 3">
                  <xsl:attribute name="class">inventory2</xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
            <xsl:choose>
               <xsl:when test="$chunk.id = @id">
                  <a name="X"/>
                  <span class="toc-hi">
                     <xsl:value-of select="$name"/>
                  </span>
               </xsl:when>
               <xsl:when test="$indent = 3">
                  <a>
                     <xsl:attribute name="href">
                        <xsl:value-of select="$xtfURL"/><xsl:value-of select="$dynaxmlPath"/>?<xsl:value-of select="$content.href"/>
                     </xsl:attribute>
                     <xsl:value-of select="$name"/>
                  </a>
               </xsl:when>
               <xsl:otherwise>
                  <a>
                     <xsl:attribute name="href">
                        <xsl:value-of select="$xtfURL"/><xsl:value-of select="$dynaxmlPath"/>?<xsl:value-of select="$content.href"/>
                     </xsl:attribute>
                     <xsl:value-of select="$name"/>
                  </a>
               </xsl:otherwise>
            </xsl:choose>
            <span class="hit-count">
               <xsl:if test="$hit.count &gt; 0">
                  (<xsl:value-of select="$hit.count"/>)
               </xsl:if>  
            </span>
         </td>
      </tr>
      </table>
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
