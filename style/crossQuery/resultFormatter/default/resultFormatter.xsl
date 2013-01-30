<<<<<<< HEAD
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns:session="java:org.cdlib.xtf.xslt.Session"
   xmlns:editURL="http://cdlib.org/xtf/editURL"
   xmlns="http://www.w3.org/1999/xhtml"
   extension-element-prefixes="session"
   exclude-result-prefixes="#all"
   version="2.0">
   
   <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
   <!-- Query result formatter stylesheet                                      -->
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
   
   <!-- this stylesheet implements very simple search forms and query results. 
      Alpha and facet browsing are also included. Formatting has been kept to a 
      minimum to make the stylesheets easily adaptable. -->
   
   <!-- ====================================================================== -->
   <!-- Import Common Templates                                                -->
   <!-- ====================================================================== -->
   
   <xsl:import href="../common/resultFormatterCommon.xsl"/>
   <xsl:import href="rss.xsl"/>
   <xsl:include href="searchForms.xsl"/>
   
   <xsl:param name="browse-collections"/>
   <xsl:param name="type"/>   

   <!-- ====================================================================== -->
   <!-- Output                                                                 -->
   <!-- ====================================================================== -->
   
   <xsl:output method="xhtml" indent="no" 
      encoding="UTF-8" media-type="text/html; charset=UTF-8" 
      doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" 
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" 
      omit-xml-declaration="yes"
      exclude-result-prefixes="#all"/>
   
   <!-- ====================================================================== -->
   <!-- Local Parameters                                                       -->
   <!-- ====================================================================== -->
   
   <xsl:param name="css.path" select="concat($xtfURL, 'css/default/')"/>
   <xsl:param name="icon.path" select="concat($xtfURL, 'icons/default/')"/>
   <xsl:param name="docHits" select="/crossQueryResult/docHit"/>
   <xsl:param name="email"/>
  
   <!-- ====================================================================== -->
   <!-- Root Template                                                          -->
   <!-- ====================================================================== -->
   
   <xsl:template match="/" exclude-result-prefixes="#all">
      <xsl:choose>
         <!-- robot response -->
         <xsl:when test="matches($http.user-agent,$robots)">
            <xsl:apply-templates select="crossQueryResult" mode="robot"/>
         </xsl:when>
         <xsl:when test="$smode = 'showBag'">
            <xsl:apply-templates select="crossQueryResult" mode="results"/>
         </xsl:when>
         <!-- book bag -->
         <xsl:when test="$smode = 'addToBag'">
            <span>Added</span>
         </xsl:when>
         <xsl:when test="$smode = 'removeFromBag'">
            <!-- no output needed -->
         </xsl:when>
         <xsl:when test="$smode='getAddress'">
            <xsl:call-template name="getAddress"/>
         </xsl:when>
         <xsl:when test="$smode='getLang'">
            <xsl:call-template name="getLang"/>
         </xsl:when>
         <xsl:when test="$smode='setLang'">
            <xsl:call-template name="setLang"/>
         </xsl:when>
         <!-- rss feed -->
         <xsl:when test="$rmode='rss'">
            <xsl:apply-templates select="crossQueryResult" mode="rss"/>
         </xsl:when>
         <xsl:when test="$smode='emailFolder'">
            <xsl:call-template name="translate">
               <xsl:with-param name="resultTree">
                  <xsl:apply-templates select="crossQueryResult" mode="emailFolder"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <!-- similar item -->
         <xsl:when test="$smode = 'moreLike'">
            <xsl:call-template name="translate">
               <xsl:with-param name="resultTree">
                  <xsl:apply-templates select="crossQueryResult" mode="moreLike"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <!-- modify search -->
         <xsl:when test="contains($smode, '-modify')">
            <xsl:call-template name="translate">
               <xsl:with-param name="resultTree">
                  <xsl:apply-templates select="crossQueryResult" mode="form"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <!-- browse pages -->
         <xsl:when test="$browse-title or $browse-creator or $browse-geogname or $browse-subject or $browse-subjectname">
            <xsl:call-template name="translate">
               <xsl:with-param name="resultTree">
                  <xsl:apply-templates select="crossQueryResult" mode="browse"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <!-- show results -->
         <xsl:when test="crossQueryResult/query/*/*">
            <xsl:call-template name="translate">
               <xsl:with-param name="resultTree">
                  <xsl:apply-templates select="crossQueryResult" mode="results"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <!-- show form -->
         <xsl:otherwise>
            <xsl:call-template name="translate">
               <xsl:with-param name="resultTree">
                  <xsl:apply-templates select="crossQueryResult" mode="form"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Results Template                                                       -->
   <!-- ====================================================================== -->
   
   <xsl:template match="crossQueryResult" mode="results" exclude-result-prefixes="#all">
      
      <!-- modify query URL -->
      <xsl:variable name="modify" select="if(matches($smode,'simple')) then 'simple-modify' else 'advanced-modify'"/>
      <xsl:variable name="modifyString" select="editURL:set($queryString, 'smode', $modify)"/>
      
      <html xml:lang="en" lang="en">
         <head>
            <title>XTF: Search Results</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:copy-of select="$brand.links"/>
            <!-- AJAX support -->
            <script src="script/yui/yahoo-dom-event.js" type="text/javascript"/> 
            <script src="script/yui/connection-min.js" type="text/javascript"/>
         </head>
         <body>
            
            <!-- header -->
            <xsl:copy-of select="$brand.header"/>
            
            <!-- result header -->
            <!-- 9/27/11 WS:  Adjusted results header for a cleaner look-->
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
                        <xsl:if test="$smode != 'showBag'">
                           <a href="{$xtfURL}{$crossqueryPath}?{$modifyString}">
                              <xsl:text>MODIFY SEARCH</xsl:text>
                           </a>
                           <xsl:text>&#160;|&#160;</xsl:text>
                        </xsl:if>
                        <a href="{$xtfURL}{$crossqueryPath}">
                           <xsl:text>NEW SEARCH</xsl:text>
                        </a>
                        <xsl:if test="$smode = 'showBag'">
                           <xsl:text>&#160;|&#160;</xsl:text>
                           <a href="{session:getData('queryURL')}">
                              <xsl:text>RETURN TO SEARCH RESULTS</xsl:text>
                           </a>
                        </xsl:if>
                        <xsl:text>&#160;|&#160;</xsl:text>
                        <!--<a href="search?browse-all=yes">
                           <xsl:text>BROWSE</xsl:text>
                        </a>-->
                        <a href="search?smode=browse">
                           <xsl:text>BROWSE</xsl:text>
                        </a>
                     </div>
                  </td>
               </tr>
            </table>
            
            <div class="resultsHeader">
              <table>
                  <tr>
                     <xsl:choose>
                        <xsl:when test="$browse-all">
                           <td colspan="2">
                              <strong>Browse by: </strong><xsl:call-template name="currentBrowseLinks"/>
                           </td>
                           <td class="right" style="vertical-align:top;">
                              <xsl:if test="$smode != 'showBag'">
                                 <xsl:variable name="bag" select="session:getData('bag')"/>
                                 <div>
                                    <a href="{$xtfURL}{$crossqueryPath}?smode=showBag"><img src="/xtf/icons/default/bookbag.gif" alt="Bookbag" style="vertical-align:bottom;"/></a>
                                    <span>(<span id="bagCount"><xsl:value-of select="count($bag/bag/savedDoc)"/></span>)</span>
                                 <xsl:if test="docHit">
                                    <xsl:text>&#160;&#160;</xsl:text>
                                    <xsl:variable name="cleanString" select="replace(replace($queryString,';*smode=docHits',''),'^;','')"/>
                                    <span><img src="{$icon.path}/i_rss.png" alt="rss icon" style="vertical-align:bottom;"/></span>
                                    <xsl:text>&#160;</xsl:text>
                                    <a href="search?{$cleanString};docsPerPage=100;rmode=rss;sort=rss">RSS</a>
                                    <xsl:text>&#160;</xsl:text>
                                 </xsl:if>
                                 </div>                                 
                              </xsl:if>
                           </td>
                        </xsl:when>
                        <xsl:otherwise>
                           <td colspan="3" class="right">
                              <xsl:if test="$smode != 'showBag'">
                                 <xsl:variable name="bag" select="session:getData('bag')"/>
                                 <div>
                                    <a href="{$xtfURL}{$crossqueryPath}?smode=showBag"><img src="/xtf/icons/default/bookbag.gif" alt="Bookbag" style="vertical-align:bottom;"/></a>
                                    <span>(<span id="bagCount"><xsl:value-of select="count($bag/bag/savedDoc)"/></span>)</span>
                                 <xsl:if test="docHit">
                                    <xsl:text>&#160;&#160;</xsl:text>
                                    <xsl:variable name="cleanString" select="replace(replace($queryString,';*smode=docHits',''),'^;','')"/>
                                    <span><img src="{$icon.path}/i_rss.png" alt="rss icon" style="vertical-align:bottom;"/></span>
                                    <xsl:text>&#160;</xsl:text>
                                    <a href="search?{$cleanString};docsPerPage=100;rmode=rss;sort=rss">RSS</a>
                                    <xsl:text>&#160;</xsl:text>
                                 </xsl:if>
                                 </div>
                              </xsl:if>
                           </td>
                        </xsl:otherwise>
                     </xsl:choose>
                  </tr>
                  <tr>
                     <td colspan="3">
                        <xsl:choose>
                           <xsl:when test="$smode='showBag'">
                              <a>
                                 <xsl:attribute name="href">javascript://</xsl:attribute>
                                 <xsl:attribute name="onclick">
                                    <xsl:text>javascript:window.open('</xsl:text><xsl:value-of
                                       select="$xtfURL"/>search?smode=getAddress<xsl:text>','popup','width=500,height=200,resizable=no,scrollbars=no')</xsl:text>
                                 </xsl:attribute>
                                 <xsl:text>E-mail My Bookbag</xsl:text>
                              </a>
                           </xsl:when>
                           <xsl:otherwise>
                              <!--<div class="query">
                                 <div class="label">
                                    <b><xsl:value-of select="if($browse-all) then 'Browse by' else 'Search'"/>:</b>
                                 </div>
                                 <xsl:call-template name="format-query"/>
                              </div>-->
                           </xsl:otherwise>
                        </xsl:choose>
                     </td>
                  </tr>
                  <tr>
                     <td>
                        <strong><xsl:value-of select="if($smode='showBag') then 'Bookbag' else 'Results'"/>:</strong>&#160;
                        <xsl:variable name="items" select="@totalDocs"/>
                        <xsl:choose>
                           <xsl:when test="$type='ead' or $type = 'mods'">
                              <span id="bookbagCount">
                                 <span id="itemCount"><xsl:value-of select="$items"/></span>
                                 <xsl:text> Item</xsl:text><xsl:if test="$items &gt; 1">s</xsl:if>
                                 <xsl:value-of select="if($smode='showBag') then ':' else ' for '"/>
                                 <div class="ra-query"><xsl:call-template name="currentBrowse"/></div>
                              </span>
                           </xsl:when>
                           <xsl:when test="$items = 1">
                              <span id="bookbagCount">
                                 <span id="itemCount">1</span>
                                 <xsl:text> Item</xsl:text><xsl:value-of select="if($smode='showBag') then ':' else ' for '"/>
                                 <div class="ra-query"><xsl:call-template name="format-query"/></div>
                              </span>
                           </xsl:when>
                           <xsl:otherwise>
                              <span id="bookbagCount">
                                 <span id="itemCount">
                                    <xsl:value-of select="$items"/>
                                 </span>
                                 <xsl:text> Items</xsl:text><xsl:value-of select="if($smode='showBag') then ':' else ' for '"/>
                                 <div class="ra-query"><xsl:call-template name="format-query"/></div>
                              </span>
                           </xsl:otherwise>
                        </xsl:choose>
                        <!-- 3/26/12 WS: Added template to clear all items from bookbag -->
                        <xsl:if test="$smode='showBag'">
                        <script type="text/javascript">
                              removeAll = function() {
                                 var span = YAHOO.util.Dom.get('removeAll');
                                 var bbCount = YAHOO.util.Dom.get('bookbagCount');
                                 span.innerHTML = "Deleting...";
                                 YAHOO.util.Connect.asyncRequest('GET', 
                                    '<xsl:value-of select="concat($xtfURL, $crossqueryPath, '?smode=removeAllFromBag')"/>',
                                    {  success: function(o) { 
                                          var main = YAHOO.util.Dom.get('docHits');
                                          main.parentNode.removeChild(main);
                                          bbCount.innerHTML="0";
                                          span.innerHTML = "Your Bookbag is empty";
                                       },
                                       failure: function(o) { span.innerHTML = 'Failed to delete!'; }
                                    }, null);
                              };
                           </script>
                        <p id="removeAll" style="margin-top:4px;">
                           <a href="javascript:removeAll()">Clear All</a><br/>
                        </p>
                        </xsl:if>
                     </td>
                     <td>
                        <form method="get" action="{$xtfURL}{$crossqueryPath}">
                           <input type="text" name="keyword" size="40" value="{$keyword}"/>
                           <xsl:text>&#160;</xsl:text>
                           <input type="submit" value="Search"/>
                           <input type="hidden" value="collection" name="sort"/>
                           <input type="reset" onclick="location.href='{$xtfURL}{$crossqueryPath}'" value="Clear"/>
                        </form>
                        &#160;&#160;
                        <form method="get" action="{$xtfURL}{$crossqueryPath}">
                           <b>Sorted by:&#160;</b>
                           <xsl:call-template name="sort.options"/>
                           <xsl:call-template name="hidden.query">
                              <xsl:with-param name="queryString" select="editURL:remove($queryString, 'sort')"/>
                           </xsl:call-template>
                           <xsl:text>&#160;</xsl:text>
                           <input type="submit" value="Go!"/>
                        </form>
                     </td>
                     <td class="right">
                        <xsl:call-template name="pages"/>
                     </td>
                  </tr>
                  <xsl:if test="//spelling">
                     <tr>
                        <td>
                           <xsl:call-template name="did-you-mean">
                              <xsl:with-param name="baseURL" select="concat($xtfURL, $crossqueryPath, '?', $queryString)"/>
                              <xsl:with-param name="spelling" select="//spelling"/>
                           </xsl:call-template>
                        </td>
                        <td class="right">&#160;</td>
                     </tr>
                  </xsl:if>
                  <xsl:if test="docHit">
                     
                  </xsl:if>
               </table>
            </div>
            
            <!-- results -->
            <xsl:choose>
               <xsl:when test="docHit">
                  <div class="results">
                     <table>
                        <tr>
                           <xsl:if test="not($smode='showBag')">
                              <td class="facet">
                                 <!-- 3/26/12 WS: Added some if statements to only show facets if facet data is available -->
                                 <xsl:if test="facet[@field='facet-subject']/child::* or facet[@field='facet-subjectname']/child::* or facet[@field='facet-geogname']/child::*">
                                 <h3>Refine Search</h3>
                                    <xsl:if test="facet[@field='facet-subject']/child::*">  
                                       <xsl:apply-templates select="facet[@field='facet-subject']"/>
                                    </xsl:if>
                                    <xsl:if test="facet[@field='facet-subjectname']/child::*">
                                       <xsl:apply-templates select="facet[@field='facet-subjectname']"/>                                    
                                    </xsl:if>
                                    <xsl:if test="facet[@field='facet-geogname']/child::*">
                                       <xsl:apply-templates select="facet[@field='facet-geogname']"/>                                    
                                    </xsl:if>
                                    <xsl:apply-templates select="facet[@field='facet-format']"/>
                                    <!-- 10/31/12 WS: Commented out date facet 
                                       <xsl:apply-templates select="facet[@field='facet-date']"/>
                                    -->                                 
                                 </xsl:if>
                              </td>
                           </xsl:if>
                           <td class="docHit">
                              <div id="docHits">
<!--                                 <xsl:apply-templates select="facet[@field='facet-collection']"/>-->
                               
                                 <xsl:for-each-group select="docHit" group-by="@path">
                                    <xsl:call-template name="docHitColl"/>
                                </xsl:for-each-group>
                               
<!--                                 <xsl:apply-templates select="docHit"/> -->
                              </div>
                           </td>
                        </tr>
                        <xsl:if test="@totalDocs > $docsPerPage">
                           <tr>
                              <td colspan="2" class="center">
                                 <xsl:call-template name="pages"/>
                              </td>
                           </tr>
                        </xsl:if>
                     </table>
                  </div>
               </xsl:when>
               <xsl:otherwise>
                  <div class="results" id="docHits">
                     <table>
                        <tr>
                           <td>
                              <xsl:choose>
                                 <xsl:when test="$smode = 'showBag'">
                                    <p>Your Bookbag is empty.</p>
                                    <p>Click on the 'Add' link next to one or more items in your <a href="{session:getData('queryURL')}">Search Results</a>.</p>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <p>Sorry, no results...</p>
                                    <p>Try modifying your search:</p>
                                    <div class="forms">
                                       <xsl:choose>
                                          <xsl:when test="matches($smode,'advanced')">
                                             <xsl:call-template name="advancedForm"/>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <xsl:call-template name="simpleForm"/>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </div></xsl:otherwise>
                              </xsl:choose>
                           </td>
                        </tr>
                     </table>
                  </div>
               </xsl:otherwise>
            </xsl:choose>
            
            <!-- feedback and footer -->
            <xsl:copy-of select="$brand.feedback"/>
            <xsl:copy-of select="$brand.footer"/>
            
         </body>
      </html>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Bookbag Templates                                                      -->
   <!-- ====================================================================== -->
   
   <xsl:template name="getAddress" exclude-result-prefixes="#all">
      <html xml:lang="en" lang="en">
         <head>
            <title>E-mail My Bookbag: Get Address</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:copy-of select="$brand.links"/>
         </head>
         <body>
            <div class="getAddress">
               <h2>E-mail My Bookbag</h2>
               <form action="{$xtfURL}{$crossqueryPath}" method="get">
                  <xsl:text>Address: </xsl:text>
                  <input type="text" name="email"/>
                  <xsl:text>&#160;</xsl:text>
                  <input type="reset" value="CLEAR"/>
                  <xsl:text>&#160;</xsl:text>
                  <input type="submit" value="SUBMIT"/>
                  <input type="hidden" name="smode" value="emailFolder"/>
               </form>
               <div class="closeWindow">
                  <a>
                     <xsl:attribute name="href">javascript://</xsl:attribute>
                     <xsl:attribute name="onClick">
                        <xsl:text>javascript:window.close('popup')</xsl:text>
                     </xsl:attribute>
                     X Close this Window
                  </a>
               </div>
            </div>
         </body>
      </html>
   </xsl:template>
   
   <xsl:template match="crossQueryResult" mode="emailFolder" exclude-result-prefixes="#all">
      
      <xsl:variable name="bookbagContents" select="session:getData('bag')/bag"/>
      
      <!-- Change the values for @smtpHost and @from to those valid for your domain -->
      <mail:send xmlns:mail="java:/org.cdlib.xtf.saxonExt.Mail" 
         xsl:extension-element-prefixes="mail" 
         smtpHost="mail.rockarch.org" 
         useSSL="no" 
         from="archive@rockarch.org"
         to="{$email}" 
         subject="XTF: My Bookbag">
            Your XTF Bookbag:
            <xsl:apply-templates select="$bookbagContents/savedDoc" mode="emailFolder"/>            
      </mail:send>
      
      <html xml:lang="en" lang="en">
         <head>
            <title>E-mail My Citations: Success</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:copy-of select="$brand.links"/>
         </head>
         <body>
            <xsl:copy-of select="$brand.header"/>
            <h1>E-mail My Citations</h1>
            <b>Your citations have been sent.</b>
            <div class="closeWindow">
               <a>
                  <xsl:attribute name="href">javascript://</xsl:attribute>
                  <xsl:attribute name="onClick">
                     <xsl:text>javascript:window.close('popup')</xsl:text>
                  </xsl:attribute>
                  X Close this Window
               </a>
            </div>
         </body>
      </html>
      
   </xsl:template>
   
   <xsl:template match="savedDoc" mode="emailFolder" exclude-result-prefixes="#all">
      <xsl:variable name="num" select="position()"/>
      <xsl:variable name="id" select="@id"/>
      <xsl:for-each select="$docHits[string(meta/identifier[1]) = $id][1]">
         <xsl:variable name="path" select="@path"/>
         <xsl:variable name="chunk.id" select="@subDocument"/>     
         <!-- 1/12/12 WS: Added docPath variable to enable scrolling to sub-document hits -->
         <xsl:variable name="docPath">
            <xsl:variable name="uri">
               <xsl:call-template name="dynaxml.url">
                  <xsl:with-param name="path" select="$path"/>
               </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
               <xsl:when test="$chunk.id != ''">
                  <xsl:value-of select="concat($xtfURL,$uri,';chunk.id=contentsLink;doc.view=contents','#',$chunk.id)"/>
                  <!-- Link used to get sub-document out of context               
                     <xsl:value-of select="concat($uri,';doc.view=contents',';chunk.id=',$chunk.id)"/> 
                  -->
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="$uri"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <!-- Need to add choose statement to get correct url when subdocument -->
         <xsl:variable name="url">
            <xsl:value-of select="$docPath"/>
            <!--<xsl:choose>
               <xsl:when test="matches(meta/display, 'dynaxml')">
                  <xsl:call-template name="dynaxml.url">
                     <xsl:with-param name="path" select="$path"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:call-template name="rawDisplay.url">
                     <xsl:with-param name="path" select="$path"/>
                  </xsl:call-template>
               </xsl:otherwise>
               </xsl:choose>-->
         </xsl:variable>
            Item number <xsl:value-of select="$num"/>: 
        <xsl:if test="meta/creator !='unknown'"><xsl:value-of select="meta/creator"/>. </xsl:if><xsl:value-of select="meta/title"/>. <xsl:if test="meta/collectionTitle"><xsl:value-of select="meta/collectionTitle"/>.</xsl:if> <xsl:value-of select="meta/subtitle"/>.
         <!-- 1/27/12 WS: changed meta/year to meta/date -->         
         <xsl:value-of select="meta/date"/>. 
         [<xsl:value-of select="$url"/>]
         
      </xsl:for-each>
   </xsl:template>
   
   
   
   <!-- ====================================================================== -->
   <!-- Browse Template                                                        -->
   <!-- ====================================================================== -->
   
   <xsl:template match="crossQueryResult" mode="browse" exclude-result-prefixes="#all">
      
      <xsl:variable name="alphaList" select="'A B C D E F G H I J K L M N O P Q R S T U V W Y Z OTHER'"/>
      
      <html xml:lang="en" lang="en">
         <head>
            <title>XTF: Search Results</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:copy-of select="$brand.links"/>
            <!-- AJAX support -->
            <script src="script/yui/yahoo-dom-event.js" type="text/javascript"/> 
            <script src="script/yui/connection-min.js" type="text/javascript"/> 
         </head>
         <body>            
            <!-- header -->
            <xsl:copy-of select="$brand.header"/>
            
            <!-- result header -->
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
                           <a href="{$xtfURL}{$crossqueryPath}">
                              <xsl:text>NEW SEARCH</xsl:text>
                           </a>
                           <xsl:if test="$smode = 'showBag'">
                              <xsl:text>&#160;|&#160;</xsl:text>
                              <a href="{session:getData('queryURL')}">
                                 <xsl:text>RETURN TO SEARCH RESULTS</xsl:text>
                              </a>
                           </xsl:if>
                           <xsl:text>&#160;|&#160;</xsl:text>
                           <!--<a href="search?browse-all=yes">
                              <xsl:text>BROWSE</xsl:text>
                              </a>-->
                           <a href="search?smode=browse">
                              <xsl:text>BROWSE</xsl:text>
                           </a>
                        </div>
                     </td>
                  </tr>
               </table>
               <div class="resultsHeader">
                  <table>
                     <tr>
                        <td colspan="2">
                           <strong>Browse by: </strong>
                           <xsl:call-template name="currentBrowseLinks"/>
                        </td>
                        <td class="right">
                        <xsl:variable name="bag" select="session:getData('bag')"/>
                           <div>
                              <a href="{$xtfURL}{$crossqueryPath}?smode=showBag"><img src="/xtf/icons/default/bookbag.gif" alt="Bookbag" style="vertical-align:middle;"/></a>
                              <span>(<span id="bagCount"><xsl:value-of select="count($bag/bag/savedDoc)"/></span>)</span>
                           </div>
                           
                        </td>
                     </tr>
                     <tr>
                     <td>
                        
                     </td>
                     <td class="right">
                        <xsl:if test="$smode = 'showBag'">
                           <xsl:text>&#160;|&#160;</xsl:text>
                           <a href="{session:getData('queryURL')}">
                              <xsl:text>Return to Search Results</xsl:text>
                           </a>
                        </xsl:if>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="3">
                         <strong>Browsing:&#160;</strong><xsl:call-template name="currentBrowse"/>
                        <!--<strong>Results:&#160;</strong>
                        <xsl:variable name="items" select="facet/group[docHit]/@totalDocs"/>
                        <xsl:choose>
                           <xsl:when test="$items &gt; 1">
                              <xsl:value-of select="$items"/>
                              <xsl:text> Items</xsl:text>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$items"/>
                              <xsl:text> Item</xsl:text>
                           </xsl:otherwise>
                        </xsl:choose>-->
                     </td>
                  </tr>
                  <tr>
                     <td colspan="2" class="center">
                        <xsl:call-template name="alphaList">
                           <xsl:with-param name="alphaList" select="$alphaList"/>
<!--                           <xsl:with-param name="level" select="'collection'"/>-->
                        </xsl:call-template>
                        <xsl:choose>
                           <xsl:when test="$browse-title">
                              &#160;| <a href="{$xtfURL}{$crossqueryPath}?browse-all=yes;level=collection;sort=title">BROWSE ALL</a>
                           </xsl:when>
                           <xsl:when test="$browse-creator">
                              &#160;| <a href="{$xtfURL}{$crossqueryPath}?browse-all=yes;level=collection;sort=creator">BROWSE ALL</a>
                           </xsl:when>
                        </xsl:choose>

                     </td>
                  </tr>
                  
               </table>
            </div>
            
            <!-- results -->
            <div class="results">
               <table>
                  <tr>
                     <td>
                        <xsl:choose>
                           <xsl:when test="$browse-title">
                              <xsl:apply-templates select="facet[@field='browse-title']/group/docHit"/>
                           </xsl:when>
                           <xsl:when test="$browse-creator">
                              <xsl:apply-templates select="facet[@field='browse-creator']/group/docHit"/>
                           </xsl:when>
                           <!-- 9/26/11 WS: Added browse options -->
                           <xsl:when test="$browse-subject">
                              <xsl:apply-templates select="facet[@field='browse-subject']/group/docHit"/>
                           </xsl:when>
                           <xsl:when test="$browse-subjectname">
                              <xsl:apply-templates select="facet[@field='browse-subjectname']/group/docHit"/>
                           </xsl:when>
                           <xsl:when test="$browse-geogname">
                              <xsl:apply-templates select="facet[@field='browse-geogname']/group/docHit"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:apply-templates select="facet[@field='browse-creator']/group/docHit"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </td>
                  </tr>
               </table>
            </div>
            
            <!-- feedback and footer -->
            <xsl:copy-of select="$brand.feedback"/>
            <xsl:copy-of select="$brand.footer"/>
            
         </body>
      </html>
   </xsl:template>
   
   <xsl:template name="browseLinks">
         <div class="browselinks">
            <table style="width:90%;margin-left:2em;">
               <tr><td colspan="2"><span style="margin:left:60px; font-size:1.2em;"><a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection">Browse All</a></span></td></tr>
               <tr>
                  <td style="width:250px;">
                     <dl style="background: url(/xtf/icons/default/collections.gif) left no-repeat; min-height: 50px;">
                        <dt>
                              <h4 style="margin-left:60px; font-size:1.2em;">
                                 <a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=ead">Browse Archival Collections</a>
                              </h4>
                        </dt>
                        <dd style="margin-left:70px;"><a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title&amp;browse-all=yes;level=collection;type=ead">by Title</a></dd>
                        <dd style="margin-left:70px;"><a href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=title&amp;browse-all=yes;level=collection;type=ead">by Creator</a></dd>
                     </dl>
                  </td>
                  <td style="width:250px;">
                     <dl style="background: url(/xtf/icons/default/book.gif) left no-repeat; min-height: 50px;">
                        <dt>
                           <h4 style="margin-left:60px; font-size:1.2em;">
                              <a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=mods">Browse Library Materials</a>
                           </h4>
                        </dt>
                        <dd style="margin-left:70px;"><a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title&amp;browse-all=yes;level=collection;type=mods">by Title</a></dd>
                        <dd style="margin-left:70px;"><a href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=title&amp;browse-all=yes;level=collection;type=mods">by Creator</a></dd>
                     </dl>
                  </td>
                  <!--<td style="width:250px;">
                     <dl style="background: url(/xtf/icons/default/video.gif) left no-repeat; min-height: 50px;">
                        <dt>
                           <h4 style="margin-left:60px; font-size:1.2em;">
                              <a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=other">Browse Other Material</a>
                           </h4>
                        </dt>
                        <dd style="margin-left:70px;"><a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title&amp;browse-all=yes;level=collection;type=other">by Title</a></dd>
                        <dd style="margin-left:70px;"><a href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=title&amp;browse-all=yes;level=collection;type=other">by Creator</a></dd>
                     </dl>
                  </td>-->
               </tr>
            </table>
         </div>
 </xsl:template>
   
   <xsl:template name="currentBrowseLinks">
      <span class="currentBrowse">
            <a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection">All</a>
          |
            <a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=ead">
               <xsl:if test="$type='ead' and not($browse-title) and not($browse-creator)">
                  <xsl:attribute name="class">active</xsl:attribute>
               </xsl:if>
               Archival Collections</a> |  
            <a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=mods">
               <xsl:if test="$type='mods' and not($browse-title) and not($browse-creator)">
                  <xsl:attribute name="class">active</xsl:attribute>
               </xsl:if>
               Library Materials</a>           
      </span>
   </xsl:template>   
   
   <xsl:template name="currentBrowse">
      <xsl:choose>
         <xsl:when test="$type='ead'">
            <xsl:choose>
               <xsl:when test="$browse-title">Collections by Title</xsl:when>
               <xsl:when test="$browse-creator">Collections by Creator</xsl:when>
               <xsl:otherwise>All Collections</xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:when test="$type='mods'">
            <xsl:choose>
               <xsl:when test="$browse-title">Library Materials by Title</xsl:when>
               <xsl:when test="$browse-creator">Library Materials by Creator</xsl:when>
               <xsl:otherwise>All Library Materials</xsl:otherwise>
            </xsl:choose>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   <!-- ====================================================================== -->
   <!-- Document Hit Template                                                  -->
   <!-- ====================================================================== -->
   
   <xsl:template match="docHit" exclude-result-prefixes="#all">
      <xsl:variable name="chunk.id" select="@subDocument"/>         
      <xsl:variable name="level" select="meta/level"/>
      <xsl:variable name="path" select="@path"/>
      <xsl:variable name="identifier" select="meta/identifier[1]"/>
      <xsl:variable name="quotedID" select="concat('&quot;', $identifier, '&quot;')"/>
      <xsl:variable name="indexId" select="replace($identifier, '.*/', '')"/>
      <!-- 1/12/12 WS: Added docPath variable to enable scrolling to sub-document hits -->
      <xsl:variable name="docPath">
         <xsl:variable name="uri">
            <xsl:call-template name="dynaxml.url">
               <xsl:with-param name="path" select="$path"/>
            </xsl:call-template>
         </xsl:variable>
         <xsl:choose>
            <xsl:when test="$chunk.id != ''">
               <xsl:value-of select="concat($uri,';chunk.id=contentsLink;doc.view=contents','#',$chunk.id)"/>
<!-- Link used to get sub-document out of context               
   <xsl:value-of select="concat($uri,';doc.view=contents',';chunk.id=',$chunk.id)"/> 
-->
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$uri"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <!-- scrolling anchor -->
      <xsl:variable name="anchor">
         <xsl:choose>
            <xsl:when test="$sort = 'creator'">
               <xsl:value-of select="substring(string(meta/creator[1]), 1, 1)"/>
            </xsl:when>
            <xsl:when test="$sort = 'title'">
               <xsl:value-of select="substring(string(meta/title[1]), 1, 1)"/>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>
      <div id="main_{@rank}" class="docHit">    
         <table>
            <!-- 9/26/11 WS: Moved title above Author -->
            <tr>
               <td style="width:1em;">
                  <xsl:choose>
                     <xsl:when test="$sort = ''">
                        <b><xsl:value-of select="@rank"/></b>
                     </xsl:when>
                     <xsl:otherwise>
                        <b><xsl:value-of select="@rank"/></b>
                        <xsl:text>&#160;</xsl:text>
                     </xsl:otherwise>
                  </xsl:choose>
               </td>
               <td rowspan="3"  style="width:3em; text-align:center;">
                  <xsl:choose>
                     <xsl:when test="meta/genre[contains(.,'DVD')]">
                        <img src="/xtf/icons/default/video.gif" alt="Moving Image"/>
                        <span style="font-size:.75em;color:#C45428;display:block;">Moving Image</span>
                     </xsl:when>
                     <xsl:when test="meta/genre[contains(.,'Videocassette')]">
                        <img src="/xtf/icons/default/video.gif" alt="Moving Image"/> 
                        <span style="font-size:.75em;color:#C45428;display:block;">Moving Image</span>
                     </xsl:when>
                     <xsl:when test="meta/genre[contains(.,'Reel')]">
                        <img src="/xtf/icons/default/microfilm.gif" alt="microfilm"/> 
                        <span style="font-size:.75em;color:#C45428;display:block;">Microfilm</span>
                     </xsl:when>                     
                     <xsl:when test="meta/genre[contains(.,'Volume')]">
                        <img src="/xtf/icons/default/book.gif" alt="Book"/>   
                        <span style="font-size:.75em;color:#C45428;display:block;">Book</span>                        
                     </xsl:when>
                     <xsl:when test="meta/type = 'ead'">
                        <img src="/xtf/icons/default/collections.gif" alt="Collection"/>
                        <span style="font-size:.75em;color:#C45428;display:block;">Collection</span>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="meta/genre"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </td>
               <td style="width:10em !important; text-align:right;">
                  <xsl:if test="$sort = 'title'">
                     <a name="{$anchor}"/>
                  </xsl:if>
                  <b>Title:&#160;&#160;</b>
               </td>
               <td>
                  <a>
                     <xsl:attribute name="href">
                        <xsl:value-of select="$docPath"/>
                     </xsl:attribute>
                     <xsl:choose>
                        <xsl:when test="meta/title">
                           <xsl:choose>
                              <xsl:when test="count(meta/title) &gt; 1">
                                 <xsl:apply-templates select="meta/title[2]"/>      
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:apply-templates select="meta/title[1]"/>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:when>
                        <xsl:when test="meta/subtitle">
                           <xsl:choose>
                              <xsl:when test="count(meta/subtitle) &gt; 1">
                                 <xsl:apply-templates select="meta/subtitle[2]"/>      
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:apply-templates select="meta/subtitle[1]"/>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>none</xsl:otherwise>
                     </xsl:choose>
                  </a>
                  <xsl:text>&#160;</xsl:text>
                  <!--
                  <xsl:variable name="type" select="meta/type"/>
                  <span class="typeIcon">
                     <img src="{$icon.path}i_{$type}.gif" class="typeIcon"/>
                  </span>
                  -->
               </td>
               <td style="width:10em; text-align:center;">
                  <!-- Add/remove logic for the session bag (only if session tracking enabled) -->
                  <span class="addToBag">
                  <xsl:if test="session:isEnabled()">
                     <xsl:choose>
                        <xsl:when test="$smode = 'showBag'">
                           <script type="text/javascript">
                              remove_<xsl:value-of select="@rank"/> = function() {
                                 var span = YAHOO.util.Dom.get('remove_<xsl:value-of select="@rank"/>');
                                 span.innerHTML = "Deleting...";
                                 YAHOO.util.Connect.asyncRequest('GET', 
                                    '<xsl:value-of select="concat($xtfURL, $crossqueryPath, '?smode=removeFromBag;identifier=', $identifier)"/>',
                                    {  success: function(o) { 
                                          var main = YAHOO.util.Dom.get('main_<xsl:value-of select="@rank"/>');
                                          main.parentNode.removeChild(main);
                                          --(YAHOO.util.Dom.get('itemCount').innerHTML);
                                       },
                                       failure: function(o) { span.innerHTML = 'Failed to delete!'; }
                                    }, null);
                              };
                           </script>
                           <span id="remove_{@rank}">
                              <a href="javascript:remove_{@rank}()">Delete</a>
                           </span>
                        </xsl:when>
                        <xsl:when test="session:noCookie()">
                           <span><a href="javascript:alert('To use the bag, you must enable cookies in your web browser.')">Requires cookie*</a></span>                                 
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:choose>
                              <xsl:when test="session:getData('bag')/bag/savedDoc[@id=$indexId]">
                                 <img src="/xtf/icons/default/addbag.gif" alt="Added to bookbag" title="Added to bookbag"/><br/>
                                 <span class="caption">Added</span>
                              </xsl:when>
                              <xsl:otherwise>
                                 <script type="text/javascript">
                                    add_<xsl:value-of select="@rank"/> = function() {
                                       var span = YAHOO.util.Dom.get('add_<xsl:value-of select="@rank"/>');
                                       span.innerHTML = "Adding...";
                                       YAHOO.util.Connect.asyncRequest('GET', 
                                          '<xsl:value-of select="concat($xtfURL, $crossqueryPath, '?smode=addToBag;identifier=', $identifier)"/>',
                                          {  success: function(o) { 
                                                span.innerHTML = o.responseText;
                                                ++(YAHOO.util.Dom.get('bagCount').innerHTML);
                                             },
                                             failure: function(o) { span.innerHTML = 'Failed to add!'; }
                                          }, null);
                                    };
                                 </script>
                                 <a href="javascript:add_{@rank}()"><img src="/xtf/icons/default/addbag.gif" alt="Add to bookbag" title="Add to bookbag"/></a><br/>
                                 <span id="add_{@rank}" class="caption">
                                    <span class="caption"><a href="javascript:add_{@rank}()">Add</a></span>
                                 </span>
                              </xsl:otherwise>
                           </xsl:choose>
                           <xsl:value-of select="session:setData('queryURL', concat($xtfURL, $crossqueryPath, '?', $queryString))"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:if>
               </span>
               </td>
            </tr>            
            <tr>
               <td class="col1">
                  <xsl:text>&#160;</xsl:text>
               </td>
               <td style="text-align:right;">
                  <xsl:if test="$sort = 'creator'">
                     <a name="{$anchor}"/>
                  </xsl:if>
                  <!-- 9/26/11 WS: changed author to creator-->
                  <b>Creator:&#160;&#160;</b>
               </td>
               <td class="col3">
                  <xsl:choose>
                     <xsl:when test="meta/creator">
                        <xsl:apply-templates select="meta/creator[1]"/>
                     </xsl:when>
                     <xsl:otherwise>none</xsl:otherwise>
                  </xsl:choose>
               </td>
               <td class="col4">
                  <xsl:text>&#160;</xsl:text> 
               </td>
            </tr>

            <tr>
               <td>
                  <xsl:text>&#160;</xsl:text>
               </td>
               <td style="text-align:right;">
                  <!-- 9/26/11 WS: changed Published to Date -->
                  <b>Date(s):&#160;&#160;</b>
               </td>
               <td>
                  <!-- 9/27/11 WS: Changed date to always grab from meta/date -->
                  <xsl:choose>
                     <xsl:when test="meta/date">
                        <xsl:apply-templates select="meta/date"/>      
                     </xsl:when>
                     <xsl:otherwise>
                        unknown
                     </xsl:otherwise>
                  </xsl:choose>
                  <!--  
                  <xsl:choose>
                     <xsl:when test="meta/year">
                        <xsl:value-of select="replace(meta/year[1],'^.+ ','')"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:apply-templates select="meta/date"/>
                     </xsl:otherwise>
                  </xsl:choose>
                  -->
               </td>
               <td>
                  <xsl:text>&#160;</xsl:text>
               </td>
            </tr>
            <xsl:if test="meta/subject">
               <tr>
                  <td colspan="2">
                     <xsl:text>&#160;</xsl:text>
                  </td>
                  <td style="text-align:right;">
                     <b>Subjects:&#160;&#160;</b>
                  </td>
                  <td>
                     <xsl:apply-templates select="meta/subject"/>
                  </td>
                  <td>
                     <xsl:text>&#160;</xsl:text>
                  </td>
               </tr>
            </xsl:if>
            <!-- 1/26/12 WS: Added descendant-or-self to catch deeply nested matches -->
            <xsl:if test="descendant-or-self::snippet">
               <tr>
                  <td colspan="2">
                     <xsl:text>&#160;</xsl:text>
                  </td>
                  <td style="text-align:right;">
                     <b>Matches:&#160;&#160;</b>
                     <br/>
                     <xsl:value-of select="@totalHits"/> 
                     <xsl:value-of select="if (@totalHits = 1) then ' hit' else ' hits'"/>&#160;&#160;&#160;&#160;
                  </td>
                  <td colspan="2">
                     <xsl:apply-templates select="descendant-or-self::snippet" mode="text"/>
                  </td>
               </tr>
            </xsl:if>
            <!-- "more like this" -->
            <tr>
               <td colspan="2">
                  <xsl:text>&#160;</xsl:text>
               </td>
               <td style="text-align:right;">
                  <b>Similar&#160;Items:&#160;&#160;</b>
               </td>
               <td colspan="2">
                  <script type="text/javascript">
                     getMoreLike_<xsl:value-of select="@rank"/> = function() {
                        var span = YAHOO.util.Dom.get('moreLike_<xsl:value-of select="@rank"/>');
                        span.innerHTML = "Fetching...";
                        YAHOO.util.Connect.asyncRequest('GET', 
                           '<xsl:value-of select="concat('search?smode=moreLike;docsPerPage=5;identifier=', $identifier)"/>',
                           { success: function(o) { span.innerHTML = o.responseText; },
                             failure: function(o) { span.innerHTML = "Failed!" } 
                           }, null);
                     };
                  </script>
                  <span id="moreLike_{@rank}">
                     <a href="javascript:getMoreLike_{@rank}()">Find</a>
                  </span>
               </td>
            </tr> 
         </table>
      </div>
   </xsl:template>
   
   <xsl:template name="docHitColl" exclude-result-prefixes="#all">
      <xsl:variable name="chunk.id" select="@subDocument"/>         
      <xsl:variable name="level" select="meta/level"/>
      <xsl:variable name="path" select="@path"/>
      <xsl:variable name="identifier" select="meta/identifier[1]"/>
      <xsl:variable name="quotedID" select="concat('&quot;', $identifier, '&quot;')"/>
      <xsl:variable name="indexId" select="replace($identifier, '.*/', '')"/>
      <!-- 1/12/12 WS: Added docPath variable to enable scrolling to sub-document hits -->
      <xsl:variable name="docPath">
         <xsl:variable name="uri">
            <xsl:call-template name="dynaxml.url">
               <xsl:with-param name="path" select="$path"/>
            </xsl:call-template>
         </xsl:variable>
         <xsl:choose>
            <xsl:when test="$chunk.id != ''">
               <xsl:value-of select="concat($uri,';chunk.id=contentsLink;doc.view=contents','#',$chunk.id)"/>
               <!-- Link used to get sub-document out of context               
                  <xsl:value-of select="concat($uri,';doc.view=contents',';chunk.id=',$chunk.id)"/> 
               -->
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$uri"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="collPath">
         <xsl:variable name="uri">
            <xsl:call-template name="dynaxml.url">
               <xsl:with-param name="path" select="$path"/>
            </xsl:call-template>
         </xsl:variable>
         <xsl:value-of select="$uri"/>
      </xsl:variable>
      <!-- scrolling anchor -->
      <xsl:variable name="anchor">
         <xsl:choose>
            <xsl:when test="$sort = 'creator'">
               <xsl:value-of select="substring(string(meta/creator[1]), 1, 1)"/>
            </xsl:when>
            <xsl:when test="$sort = 'title'">
               <xsl:value-of select="substring(string(meta/title[1]), 1, 1)"/>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>

      <div id="main_{@rank}" class="docHit">    
         <table>
            <!-- Deals with collections vrs. series/files -->
            <xsl:choose>
               <xsl:when test="meta/level = 'collection'">
                  <tr>
                     <td class="col1" style="width:2em;">
                        <xsl:choose>
                           <xsl:when test="$sort = ''">
                              <b><xsl:value-of select="@rank"/></b>
                           </xsl:when>
                           <xsl:otherwise>
                              <b><xsl:value-of select="@rank"/></b>
                              <xsl:text>&#160;</xsl:text>
                           </xsl:otherwise>
                        </xsl:choose>
                     </td>
                     <td rowspan="3"  style="width:3em; text-align:center;">
                        <xsl:choose>
                           <xsl:when test="meta/genre[contains(.,'DVD')]">
                              <img src="/xtf/icons/default/video.gif" alt="Moving Image"/>
                              <span style="font-size:.75em;color:#C45428;display:block;">Moving Image</span>
                           </xsl:when>
                           <xsl:when test="meta/genre[contains(.,'Videocassette')]">
                              <img src="/xtf/icons/default/video.gif" alt="Moving Image"/> 
                              <span style="font-size:.75em;color:#C45428;display:block;">Moving Image</span>
                           </xsl:when>
                           <xsl:when test="meta/genre[contains(.,'Reel')]">
                              <img src="/xtf/icons/default/microfilm.gif" alt="microfilm"/> 
                              <span style="font-size:.75em;color:#C45428;display:block;">Microfilm</span>
                           </xsl:when>                     
                           <xsl:when test="meta/genre[contains(.,'Volume')]">
                              <img src="/xtf/icons/default/book.gif" alt="Book"/>   
                              <span style="font-size:.75em;color:#C45428;display:block;">Book</span>                        
                           </xsl:when>
                           <xsl:when test="meta/type = 'ead'">
                              <img src="/xtf/icons/default/collections.gif" alt="Collection"/>
                              <span style="font-size:.75em;color:#C45428;display:block;">Collection</span>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="meta/genre"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </td>
                     <td class="col2">
                        <xsl:if test="$sort = 'title'">
                           <a name="{$anchor}"/>
                        </xsl:if>
                        <b>Title:&#160;&#160;</b>
                     </td>
                     <td class="col3">
                        <a>
                           <xsl:attribute name="href">
                              <xsl:value-of select="$docPath"/>
                           </xsl:attribute>
                           <xsl:choose>
                              <xsl:when test="meta/title">
                                 <xsl:choose>
                                    <xsl:when test="count(meta/title) &gt; 1">
                                       <xsl:apply-templates select="meta/title[2]"/>      
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:apply-templates select="meta/title[1]"/>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </xsl:when>
                              <xsl:when test="meta/subtitle">
                                 <xsl:choose>
                                    <xsl:when test="count(meta/subtitle) &gt; 1">
                                       <xsl:apply-templates select="meta/subtitle[2]"/>      
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:apply-templates select="meta/subtitle[1]"/>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </xsl:when>
                              <xsl:otherwise>none</xsl:otherwise>
                           </xsl:choose>
                        </a>
                        <xsl:text>&#160;</xsl:text>
                        <!--
                        <xsl:variable name="type" select="meta/type"/>
                           <span class="typeIcon">
                           <img src="{$icon.path}i_{$type}.gif" class="typeIcon"/>
                           </span>
                        -->
                     </td>
                     <td class="col4" style="text-align:center">
                        <!-- Add/remove logic for the session bag (only if session tracking enabled) -->
                        <span class="addToBag">
                           <xsl:if test="session:isEnabled()">
                              <xsl:choose>
                                 <xsl:when test="$smode = 'showBag'">
                                    <script type="text/javascript">
                              remove_<xsl:value-of select="@rank"/> = function() {
                                 var span = YAHOO.util.Dom.get('remove_<xsl:value-of select="@rank"/>');
                                 span.innerHTML = "Deleting...";
                                 YAHOO.util.Connect.asyncRequest('GET', 
                                    '<xsl:value-of select="concat($xtfURL, $crossqueryPath, '?smode=removeFromBag;identifier=', $identifier)"/>',
                                    {  success: function(o) { 
                                          var main = YAHOO.util.Dom.get('main_<xsl:value-of select="@rank"/>');
                                          main.parentNode.removeChild(main);
                                          --(YAHOO.util.Dom.get('itemCount').innerHTML);
                                       },
                                       failure: function(o) { span.innerHTML = 'Failed to delete!'; }
                                    }, null);
                              };
                           </script>
                                    <span id="remove_{@rank}">
                                       <a href="javascript:remove_{@rank}()">Delete</a>
                                    </span>
                                 </xsl:when>
                                 <xsl:when test="session:noCookie()">
                                    <span><a href="javascript:alert('To use the bag, you must enable cookies in your web browser.')">Requires cookie*</a></span>                                 
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:choose>
                                       <xsl:when test="session:getData('bag')/bag/savedDoc[@id=$indexId]">
                                          <img src="/xtf/icons/default/addbag.gif" alt="Added to bookbag" title="Added to bookbag"/><br/>
                                             <span class="caption">Added</span>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <script type="text/javascript">
                                    add_<xsl:value-of select="@rank"/> = function() {
                                       var span = YAHOO.util.Dom.get('add_<xsl:value-of select="@rank"/>');
                                       span.innerHTML = "Adding...";
                                       YAHOO.util.Connect.asyncRequest('GET', 
                                          '<xsl:value-of select="concat($xtfURL, $crossqueryPath, '?smode=addToBag;identifier=', $identifier)"/>',
                                          {  success: function(o) { 
                                                span.innerHTML = o.responseText;
                                                ++(YAHOO.util.Dom.get('bagCount').innerHTML);
                                             },
                                             failure: function(o) { span.innerHTML = 'Failed to add!'; }
                                          }, null);
                                    };
                                          </script>
                                          <a href="javascript:add_{@rank}()"><img src="/xtf/icons/default/addbag.gif" alt="Add to bookbag" title="Add to bookbag"/></a><br/>
                                          <span id="add_{@rank}" class="caption">
                                             <a href="javascript:add_{@rank}()">Add</a>
                                          </span>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:value-of select="session:setData('queryURL', concat($xtfURL, $crossqueryPath, '?', $queryString))"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:if>
                        </span>
                     </td>
                  </tr> 
                  <tr>
                     <td class="col1">
                        <xsl:text>&#160;</xsl:text>
                     </td>
                     <td class="col2">
                        <xsl:if test="$sort = 'creator'">
                           <a name="{$anchor}"/>
                        </xsl:if>
                        <!-- 9/26/11 WS: changed author to creator-->
                        <b>Creator:&#160;&#160;</b>
                     </td>
                     <td class="col3">
                        <xsl:choose>
                           <xsl:when test="meta/creator">
                              <xsl:apply-templates select="meta/creator[1]"/>
                           </xsl:when>
                           <xsl:otherwise>none</xsl:otherwise>
                        </xsl:choose>
                     </td>
                     <td class="col4">
                        <xsl:text>&#160;</xsl:text> 
                     </td>
                  </tr>
                     <tr>
                        <td class="col1" colspan="2">
                           <xsl:text>&#160;</xsl:text>
                        </td>
                        <td class="col2">
                           <b>Publisher:&#160;&#160;</b>
                        </td>
                        <td class="col3">
                           <xsl:apply-templates select="meta/publisher"/>
                        </td>
                        <td class="col4">
                           <!-- Removed add to bag, when on a file, because it was buggy -->
                        </td>
                     </tr>
                  <tr>
                     <td class="col1" colspan="2">
                        <xsl:text>&#160;</xsl:text>
                     </td>
                     <td class="col2">
                        <!-- 9/26/11 WS: changed Published to Date -->
                        <b>Date(s):&#160;&#160;</b>
                     </td>
                     <td class="col3">
                        <!-- 9/27/11 WS: Changed date to always grab from meta/date -->
                        <xsl:choose>
                           <xsl:when test="meta/date">
                              <xsl:apply-templates select="meta/date"/>      
                           </xsl:when>
                           <xsl:otherwise>
                              unknown
                           </xsl:otherwise>
                        </xsl:choose>
                     </td>
                     <td class="col4">
                        <xsl:text>&#160;</xsl:text>
                     </td>
                  </tr>
                  <xsl:if test="meta/callNo">
                     <tr>
                        <td class="col1" colspan="2">
                           <xsl:text>&#160;</xsl:text>
                        </td>
                        <td class="col2">
                           <b>Call number:&#160;&#160;</b>
                        </td>
                        <td class="col3">
                           <xsl:apply-templates select="meta/callNo"/>
                        </td>
                        <td class="col4">
                           <!-- Removed add to bag, when on a file, because it was buggy -->
                        </td>
                     </tr>
                  </xsl:if>                   
                <!-- 1/26/12 WS: Added descendant-or-self to catch deeply nested matches -->
                  <xsl:if test="descendant-or-self::snippet">
                     <tr>
                        <td class="col1" colspan="2">
                           <xsl:text>&#160;</xsl:text>
                        </td>
                        <td class="col2">
                           <b>Matches:&#160;&#160;</b>
                           <br/>
                           <xsl:value-of select="@totalHits"/> 
                           <xsl:value-of select="if (@totalHits = 1) then ' hit' else ' hits'"/>&#160;&#160;&#160;&#160;
                        </td>
                        <td class="col3" colspan="2">
                           <xsl:apply-templates select="descendant-or-self::snippet" mode="text"/>
                        </td>
                     </tr>
                  </xsl:if>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:variable name="collectionId" select="substring-before(meta/identifier[1],'|')"/>
                  <tr>
                     <td class="col1">
                        <xsl:choose>
                           <xsl:when test="$sort = ''">
                              <b><xsl:value-of select="@rank"/></b>
                           </xsl:when>
                           <xsl:otherwise>
                              <b><xsl:value-of select="@rank"/></b>
                              <xsl:text>&#160;</xsl:text>
                           </xsl:otherwise>
                        </xsl:choose>
                     </td>
                     <td rowspan="2"  style="width:3em; text-align:center;">
                        <xsl:choose>
                           <xsl:when test="meta/genre[contains(.,'DVD')]">
                              <img src="/xtf/icons/default/video.gif" alt="Moving Image"/>
                              <span style="font-size:.75em;color:#C45428;display:block;">Moving Image</span>
                           </xsl:when>
                           <xsl:when test="meta/genre[contains(.,'Videocassette')]">
                              <img src="/xtf/icons/default/video.gif" alt="Moving Image"/> 
                              <span style="font-size:.75em;color:#C45428;display:block;">Moving Image</span>
                           </xsl:when>
                           <xsl:when test="meta/genre[contains(.,'Reel')]">
                              <img src="/xtf/icons/default/microfilm.gif" alt="microfilm"/> 
                              <span style="font-size:.75em;color:#C45428;display:block;">Microfilm</span>
                           </xsl:when>                     
                           <xsl:when test="meta/genre[contains(.,'Volume')]">
                              <img src="/xtf/icons/default/book.gif" alt="Book"/>   
                              <span style="font-size:.75em;color:#C45428;display:block;">Book</span>                        
                           </xsl:when>
                           <xsl:when test="meta/type = 'ead'">
                              <img src="/xtf/icons/default/collections.gif" alt="Collection"/>
                              <span style="font-size:.75em;color:#C45428;display:block;">Collection</span>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="meta/genre"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </td>
                     <td class="col2">
                        <xsl:if test="$sort = 'title'">
                           <a name="{$anchor}"/>
                        </xsl:if>
                        <b>Title:&#160;&#160;</b>
                     </td>
                     <td class="col3">
                        <a>
                           <xsl:attribute name="href">
                              <xsl:value-of select="$collPath"/>
                           </xsl:attribute>
                           <xsl:choose>
                              <xsl:when test="meta/collectionTitle">
                                 <xsl:apply-templates select="meta/collectionTitle"/>
                              </xsl:when>
                              <xsl:when test="meta/subtitle">
                                 <xsl:apply-templates select="meta/subtitle"/>
                              </xsl:when>
                              <xsl:when test="meta/title">
                                 <xsl:apply-templates select="meta/title"/>
                              </xsl:when>
                              <xsl:otherwise>none</xsl:otherwise>
                           </xsl:choose>
                        </a>
                        <xsl:text>&#160;</xsl:text>
                        <!--
                        <xsl:variable name="type" select="meta/type"/>
                           <span class="typeIcon">
                           <img src="{$icon.path}i_{$type}.gif" class="typeIcon"/>
                           </span>
                        -->
                     </td>
                     <td class="col4">
                        <!-- Removed add to bag, when on a file, because it was buggy -->
                    </td>
                  </tr> 
                  <tr>
                     <td class="col1">
                        <xsl:text>&#160;</xsl:text>
                     </td>
                     <td class="col2">
                        <xsl:if test="$sort = 'creator'">
                           <a name="{$anchor}"/>
                        </xsl:if>
                        <!-- 9/26/11 WS: changed author to creator-->
                        <b>Creator:&#160;&#160;</b>
                     </td>
                     <td class="col3">
                        <xsl:choose>
                           <xsl:when test="meta/collectionCreator">
                              <xsl:apply-templates select="meta/collectionCreator[1]"/>
                           </xsl:when>
                           <xsl:when test="meta/creator">
                              <xsl:apply-templates select="meta/creator[1]"/>
                           </xsl:when>
                           <xsl:otherwise>none</xsl:otherwise>
                        </xsl:choose>
                     </td>
                     <td class="col4">
                        <xsl:text>&#160;</xsl:text> 
                     </td>
                  </tr>                
               </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="meta/subject">
               <tr>
                  <td class="col1" colspan="2">
                     <xsl:text>&#160;</xsl:text>
                  </td>
                  <td class="col2">
                     <b>Subjects:&#160;&#160;</b>
                  </td>
                  <td class="col3">
                     <xsl:apply-templates select="meta/subject"/>
                  </td>
                  <td class="col4">
                     <xsl:text>&#160;</xsl:text>
                  </td>
               </tr>
            </xsl:if>
            <xsl:for-each select="current-group()[meta/level != 'collection']">
<!--            <xsl:for-each select="current-group()[position() &lt; 5][meta/level != 'collection']">-->
               <tr>
                  <td class="col1" colspan="2"></td>
                  <td></td>
                  <td colspan="3">
                  <xsl:call-template name="subDocument"/>
                  </td>
               </tr>
            </xsl:for-each>
            <!-- "more like this" -->
            <tr>
               <td class="col1" colspan="2">
                  <xsl:text>&#160;</xsl:text>
               </td>
               <td class="col2">
                  <b>Similar&#160;Items:&#160;&#160;</b>
               </td>
               <td class="col3" colspan="2">
                  <script type="text/javascript">
                     getMoreLike_<xsl:value-of select="@rank"/> = function() {
                        var span = YAHOO.util.Dom.get('moreLike_<xsl:value-of select="@rank"/>');
                        span.innerHTML = "Fetching...";
                        YAHOO.util.Connect.asyncRequest('GET', 
                           '<xsl:value-of select="concat('search?smode=moreLike;docsPerPage=5;identifier=', $identifier)"/>',
                           { success: function(o) { span.innerHTML = o.responseText; },
                             failure: function(o) { span.innerHTML = "Failed!" } 
                           }, null);
                     };
                  </script>
                  <span id="moreLike_{@rank}">
                     <a href="javascript:getMoreLike_{@rank}()">Find</a>
                  </span>
               </td>
            </tr> 
         </table>
      </div>
      
         <!-- 
        <xsl:for-each select="current-group()[position() &lt; 5]">
        <div>
        <xsl:apply-templates select="docHit" mode="subDoc"/>
        </div>
        </xsl:for-each>
        
     --> 
   </xsl:template>
   
   <xsl:template name="subDocument">
      <xsl:variable name="chunk.id" select="@subDocument"/>         
      <xsl:variable name="level" select="meta/level"/>
      <xsl:variable name="path" select="@path"/>
      <xsl:variable name="identifier" select="meta/identifier[1]"/>
      <xsl:variable name="quotedID" select="concat('&quot;', $identifier, '&quot;')"/>
      <xsl:variable name="indexId" select="replace($identifier, '.*/', '')"/>
      <!-- 1/12/12 WS: Added docPath variable to enable scrolling to sub-document hits -->
      <xsl:variable name="docPath">
         <xsl:variable name="uri">
            <xsl:call-template name="dynaxml.url">
               <xsl:with-param name="path" select="$path"/>
            </xsl:call-template>
         </xsl:variable>
         <xsl:choose>
            <xsl:when test="meta/seriesID">
               <xsl:variable name="seriesID" select="meta/seriesID"/>
               <xsl:value-of select="concat($uri,';chunk.id=',$seriesID,';doc.view=contents','#',$chunk.id)"/>
            </xsl:when>
            <xsl:when test="$chunk.id != ''">
               <xsl:value-of select="concat($uri,';chunk.id=',$chunk.id,';doc.view=contents')"/>
               <!-- Link used to get sub-document out of context               
                  <xsl:value-of select="concat($uri,';doc.view=contents',';chunk.id=',$chunk.id)"/> 
               -->
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$uri"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <!-- scrolling anchor -->
      <xsl:variable name="anchor">
         <xsl:choose>
            <xsl:when test="$sort = 'creator'">
               <xsl:value-of select="substring(string(meta/creator[1]), 1, 1)"/>
            </xsl:when>
            <xsl:when test="$sort = 'title'">
               <xsl:value-of select="substring(string(meta/title[1]), 1, 1)"/>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>
      <table style="width:100%;">
         <tr>
            <td class="col1">
               <xsl:choose>
                  <xsl:when test="$sort = ''">
                     <b><xsl:value-of select="@rank"/></b>
                  </xsl:when>
                  <xsl:otherwise>
                     <b><xsl:value-of select="@rank"/></b>
                     <xsl:text>&#160;</xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
            </td>
            <td class="col3" colspan="2">
               <a>
                  <xsl:attribute name="href">
                     <xsl:value-of select="$docPath"/>
                  </xsl:attribute>
                  <xsl:choose>
                     <xsl:when test="meta/title">
                        <xsl:choose>
                           <xsl:when test="count(meta/title) &gt; 1">
                              <xsl:apply-templates select="meta/title[2]"/>      
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:apply-templates select="meta/title[1]"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:when>
                     <xsl:when test="meta/subtitle">
                        <xsl:choose>
                           <xsl:when test="count(meta/subtitle) &gt; 1">
                              <xsl:apply-templates select="meta/subtitle[2]"/>      
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:apply-templates select="meta/subtitle[1]"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:when>
                     <xsl:otherwise>none</xsl:otherwise>
                  </xsl:choose>
               </a>
               <xsl:text>&#160;</xsl:text>
               <!--
               <xsl:variable name="type" select="meta/type"/>
                  <span class="typeIcon">
                  <img src="{$icon.path}i_{$type}.gif" class="typeIcon"/>
                  </span>
               -->
            </td>
            <td class="col4" style="text-align:center">
               <!-- Add/remove logic for the session bag (only if session tracking enabled) -->
               <span class="addToBag">
                  <xsl:if test="session:isEnabled()">
                     <xsl:choose>
                        <xsl:when test="$smode = 'showBag'">
                           <script type="text/javascript">
                              remove_<xsl:value-of select="@rank"/> = function() {
                                 var span = YAHOO.util.Dom.get('remove_<xsl:value-of select="@rank"/>');
                                 span.innerHTML = "Deleting...";
                                 YAHOO.util.Connect.asyncRequest('GET', 
                                    '<xsl:value-of select="concat($xtfURL, $crossqueryPath, '?smode=removeFromBag;identifier=', $identifier)"/>',
                                    {  success: function(o) { 
                                          var main = YAHOO.util.Dom.get('main_<xsl:value-of select="@rank"/>');
                                          main.parentNode.removeChild(main);
                                          --(YAHOO.util.Dom.get('itemCount').innerHTML);
                                       },
                                       failure: function(o) { span.innerHTML = 'Failed to delete!'; }
                                    }, null);
                              };
                           </script>
                           <span id="remove_{@rank}">
                              <a href="javascript:remove_{@rank}()">Delete</a>
                           </span>
                        </xsl:when>
                        <xsl:when test="session:noCookie()">
                           <span><a href="javascript:alert('To use the bag, you must enable cookies in your web browser.')">Requires cookie*</a></span>                                 
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:choose>
                              <xsl:when test="session:getData('bag')/bag/savedDoc[@id=$indexId]">
                                 <img src="/xtf/icons/default/addbag.gif" alt="Added to bookbag" title="Added to bookbag"/><br/>
                                    <span class="caption">Added</span>
                              </xsl:when>
                              <xsl:otherwise>
                                 <script type="text/javascript">
                                    add_<xsl:value-of select="@rank"/> = function() {
                                       var span = YAHOO.util.Dom.get('add_<xsl:value-of select="@rank"/>');
                                       span.innerHTML = "Adding...";
                                       YAHOO.util.Connect.asyncRequest('GET', 
                                          '<xsl:value-of select="concat($xtfURL, $crossqueryPath, '?smode=addToBag;identifier=', $identifier)"/>',
                                          {  success: function(o) { 
                                                span.innerHTML = o.responseText;
                                                ++(YAHOO.util.Dom.get('bagCount').innerHTML);
                                             },
                                             failure: function(o) { span.innerHTML = 'Failed to add!'; }
                                          }, null);
                                    };
                                 </script>
                                 <a href="javascript:add_{@rank}()"><img src="/xtf/icons/default/addbag.gif" alt="Added to bookbag" title="Added to bookbag"/></a><br/>
                                 <span id="add_{@rank}" class="caption">
                                    <a href="javascript:add_{@rank}()">Add</a>
                                 </span>
                              </xsl:otherwise>
                           </xsl:choose>
                           <xsl:value-of select="session:setData('queryURL', concat($xtfURL, $crossqueryPath, '?', $queryString))"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:if>
               </span>
            </td>
         </tr> 
         <!-- 1/26/12 WS: Added descendant-or-self to catch deeply nested matches -->
         <xsl:if test="descendant-or-self::snippet">
            <tr style="font-size:.95em;">
               <td class="col1">
                  <xsl:text>&#160;</xsl:text>
               </td>
               <td class="col3" colspan="3">
                  <b>Matches:&#160;&#160;</b>
                  (<xsl:value-of select="@totalHits"/>
                  <xsl:value-of select="if (@totalHits = 1) then ' hit' else ' hits'"/>)&#160;&#160;&#160;&#160;
                  <xsl:apply-templates select="descendant-or-self::snippet" mode="text"/>
               </td>
            </tr>
         </xsl:if>         
      </table>
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- Snippet Template (for snippets in the full text)                       -->
   <!-- ====================================================================== -->
   
   <xsl:template match="snippet" mode="text" exclude-result-prefixes="#all">
      <xsl:text>...</xsl:text>
      <xsl:apply-templates mode="text"/>
      <xsl:text>...</xsl:text>
      <br/>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Term Template (for snippets in the full text)                          -->
   <!-- ====================================================================== -->
   
   <xsl:template match="term" mode="text" exclude-result-prefixes="#all">
      <xsl:variable name="path" select="ancestor::docHit/@path"/>
      <xsl:variable name="display" select="ancestor::docHit/meta/display[1]"/>
      <xsl:variable name="hit.rank"><xsl:value-of select="ancestor::snippet/@rank"/></xsl:variable>
      <xsl:variable name="snippet.link">    
         <xsl:call-template name="dynaxml.url">
            <xsl:with-param name="path" select="$path"/>
         </xsl:call-template>
         <xsl:value-of select="concat(';hit.rank=', $hit.rank)"/>
      </xsl:variable>
      
      <xsl:choose>
         <xsl:when test="ancestor::query"/>
         <xsl:when test="not(ancestor::snippet) or not(matches($display, 'dynaxml'))">
            <span class="hit"><xsl:apply-templates/></span>
         </xsl:when>
         <xsl:otherwise>
            <a href="{$snippet.link}" class="hit"><xsl:apply-templates/></a>
         </xsl:otherwise>
      </xsl:choose> 
      
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Term Template (for snippets in meta-data fields)                       -->
   <!-- ====================================================================== -->
   
   <xsl:template match="term" exclude-result-prefixes="#all">
      <xsl:choose>
         <xsl:when test="ancestor::query"/>
         <xsl:otherwise>
            <span class="hit"><xsl:apply-templates/></span>
         </xsl:otherwise>
      </xsl:choose> 
      
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- More Like This Template                                                -->
   <!-- ====================================================================== -->
   
   <!-- results -->
   <xsl:template match="crossQueryResult" mode="moreLike" exclude-result-prefixes="#all">
      <xsl:choose>
         <xsl:when test="docHit">
            <div class="moreLike">
               <ol>
                  <xsl:apply-templates select="docHit" mode="moreLike"/>
               </ol>
            </div>
         </xsl:when>
         <xsl:otherwise>
            <div class="moreLike">
               <b>No similar documents found.</b>
            </div>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- docHit -->
   <xsl:template match="docHit" mode="moreLike" exclude-result-prefixes="#all">
      
      <xsl:variable name="path" select="@path"/>
      
      <li>
         <xsl:apply-templates select="meta/creator[1]"/>
         <xsl:text>. </xsl:text>
         <a>
            <xsl:attribute name="href">
               <xsl:choose>
                  <xsl:when test="matches(meta/display[1], 'dynaxml')">
                     <xsl:call-template name="dynaxml.url">
                        <xsl:with-param name="path" select="$path"/>
                     </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:call-template name="rawDisplay.url">
                        <xsl:with-param name="path" select="$path"/>
                     </xsl:call-template>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="meta/title[1]"/>
         </a>
         <xsl:text>. </xsl:text>
         <!-- 12/1/11 WS for RAC: changed from meta/year[1] to meta/date[1] -->
         <xsl:apply-templates select="meta/date[1]"/>
         <xsl:text>. </xsl:text>
      </li>
      
   </xsl:template>
   
</xsl:stylesheet>
=======
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns:session="java:org.cdlib.xtf.xslt.Session"
   xmlns:editURL="http://cdlib.org/xtf/editURL"
   xmlns="http://www.w3.org/1999/xhtml"
   extension-element-prefixes="session"
   exclude-result-prefixes="#all"
   version="2.0">
   
   <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
   <!-- Query result formatter stylesheet                                      -->
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
   
   <!-- this stylesheet implements very simple search forms and query results. 
      Alpha and facet browsing are also included. Formatting has been kept to a 
      minimum to make the stylesheets easily adaptable. -->
   
   <!-- ====================================================================== -->
   <!-- Import Common Templates                                                -->
   <!-- ====================================================================== -->
   
   <xsl:import href="../common/resultFormatterCommon.xsl"/>
   <xsl:import href="rss.xsl"/>
   <xsl:include href="searchForms.xsl"/>
   
   <xsl:param name="browse-collections"/>
   <xsl:param name="type"/>   

   <!-- ====================================================================== -->
   <!-- Output                                                                 -->
   <!-- ====================================================================== -->
   
   <xsl:output method="xhtml" indent="no" 
      encoding="UTF-8" media-type="text/html; charset=UTF-8" 
      doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" 
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" 
      omit-xml-declaration="yes"
      exclude-result-prefixes="#all"/>
   
   <!-- ====================================================================== -->
   <!-- Local Parameters                                                       -->
   <!-- ====================================================================== -->
   
   <xsl:param name="css.path" select="concat($xtfURL, 'css/default/')"/>
   <xsl:param name="icon.path" select="concat($xtfURL, 'icons/default/')"/>
   <xsl:param name="docHits" select="/crossQueryResult/docHit"/>
   <xsl:param name="email"/>
  
   <!-- ====================================================================== -->
   <!-- Root Template                                                          -->
   <!-- ====================================================================== -->
   
   <xsl:template match="/" exclude-result-prefixes="#all">
      <xsl:choose>
         <!-- robot response -->
         <xsl:when test="matches($http.user-agent,$robots)">
            <xsl:apply-templates select="crossQueryResult" mode="robot"/>
         </xsl:when>
         <xsl:when test="$smode = 'showBag'">
            <xsl:apply-templates select="crossQueryResult" mode="results"/>
         </xsl:when>
         <!-- book bag -->
         <xsl:when test="$smode = 'addToBag'">
            <span>Added</span>
         </xsl:when>
         <xsl:when test="$smode = 'removeFromBag'">
            <!-- no output needed -->
         </xsl:when>
         <xsl:when test="$smode='getAddress'">
            <xsl:call-template name="getAddress"/>
         </xsl:when>
         <xsl:when test="$smode='getLang'">
            <xsl:call-template name="getLang"/>
         </xsl:when>
         <xsl:when test="$smode='setLang'">
            <xsl:call-template name="setLang"/>
         </xsl:when>
         <!-- rss feed -->
         <xsl:when test="$rmode='rss'">
            <xsl:apply-templates select="crossQueryResult" mode="rss"/>
         </xsl:when>
         <xsl:when test="$smode='emailFolder'">
            <xsl:call-template name="translate">
               <xsl:with-param name="resultTree">
                  <xsl:apply-templates select="crossQueryResult" mode="emailFolder"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <!-- similar item -->
         <xsl:when test="$smode = 'moreLike'">
            <xsl:call-template name="translate">
               <xsl:with-param name="resultTree">
                  <xsl:apply-templates select="crossQueryResult" mode="moreLike"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <!-- modify search -->
         <xsl:when test="contains($smode, '-modify')">
            <xsl:call-template name="translate">
               <xsl:with-param name="resultTree">
                  <xsl:apply-templates select="crossQueryResult" mode="form"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <!-- browse pages -->
         <xsl:when test="$browse-title or $browse-creator or $browse-geogname or $browse-subject or $browse-subjectname">
            <xsl:call-template name="translate">
               <xsl:with-param name="resultTree">
                  <xsl:apply-templates select="crossQueryResult" mode="browse"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <!-- show results -->
         <xsl:when test="crossQueryResult/query/*/*">
            <xsl:call-template name="translate">
               <xsl:with-param name="resultTree">
                  <xsl:apply-templates select="crossQueryResult" mode="results"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <!-- show form -->
         <xsl:otherwise>
            <xsl:call-template name="translate">
               <xsl:with-param name="resultTree">
                  <xsl:apply-templates select="crossQueryResult" mode="form"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Results Template                                                       -->
   <!-- ====================================================================== -->
   
   <xsl:template match="crossQueryResult" mode="results" exclude-result-prefixes="#all">
      
      <!-- modify query URL -->
      <xsl:variable name="modify" select="if(matches($smode,'simple')) then 'simple-modify' else 'advanced-modify'"/>
      <xsl:variable name="modifyString" select="editURL:set($queryString, 'smode', $modify)"/>
      
      <html xml:lang="en" lang="en">
         <head>
            <title>XTF: Search Results</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:copy-of select="$brand.links"/>
            <!-- AJAX support -->
            <script src="script/yui/yahoo-dom-event.js" type="text/javascript"/> 
            <script src="script/yui/connection-min.js" type="text/javascript"/>
         </head>
         <body>
            
            <!-- header -->
            <xsl:copy-of select="$brand.header"/>
            
            <!-- result header -->
            <!-- 9/27/11 WS:  Adjusted results header for a cleaner look-->
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
                        <xsl:if test="$smode != 'showBag'">
                           <a href="{$xtfURL}{$crossqueryPath}?{$modifyString}">
                              <xsl:text>MODIFY SEARCH</xsl:text>
                           </a>
                           <xsl:text>&#160;|&#160;</xsl:text>
                        </xsl:if>
                        <a href="{$xtfURL}{$crossqueryPath}">
                           <xsl:text>NEW SEARCH</xsl:text>
                        </a>
                        <xsl:if test="$smode = 'showBag'">
                           <xsl:text>&#160;|&#160;</xsl:text>
                           <a href="{session:getData('queryURL')}">
                              <xsl:text>RETURN TO SEARCH RESULTS</xsl:text>
                           </a>
                        </xsl:if>
                        <xsl:text>&#160;|&#160;</xsl:text>
                        <!--<a href="search?browse-all=yes">
                           <xsl:text>BROWSE</xsl:text>
                        </a>-->
                        <a href="search?smode=browse">
                           <xsl:text>BROWSE</xsl:text>
                        </a>
                     </div>
                  </td>
               </tr>
            </table>
            
            <div class="resultsHeader">
              <table>
                  <tr>
                     <xsl:choose>
                        <xsl:when test="$browse-all">
                           <td colspan="2">
                              <strong>Browse by: </strong><xsl:call-template name="currentBrowseLinks"/>
                           </td>
                           <td class="right" style="vertical-align:top;">
                              <xsl:if test="$smode != 'showBag'">
                                 <xsl:variable name="bag" select="session:getData('bag')"/>
                                 <div>
                                    <a href="{$xtfURL}{$crossqueryPath}?smode=showBag"><img src="/xtf/icons/default/bookbag.gif" alt="Bookbag" style="vertical-align:bottom;"/></a>
                                    <span>(<span id="bagCount"><xsl:value-of select="count($bag/bag/savedDoc)"/></span>)</span>
                                 <xsl:if test="docHit">
                                    <xsl:text>&#160;&#160;</xsl:text>
                                    <xsl:variable name="cleanString" select="replace(replace($queryString,';*smode=docHits',''),'^;','')"/>
                                    <span><img src="{$icon.path}/i_rss.png" alt="rss icon" style="vertical-align:bottom;"/></span>
                                    <xsl:text>&#160;</xsl:text>
                                    <a href="search?{$cleanString};docsPerPage=100;rmode=rss;sort=rss">RSS</a>
                                    <xsl:text>&#160;</xsl:text>
                                 </xsl:if>
                                 </div>                                 
                              </xsl:if>
                           </td>
                        </xsl:when>
                        <xsl:otherwise>
                           <td colspan="3" class="right">
                              <xsl:if test="$smode != 'showBag'">
                                 <xsl:variable name="bag" select="session:getData('bag')"/>
                                 <div>
                                    <a href="{$xtfURL}{$crossqueryPath}?smode=showBag"><img src="/xtf/icons/default/bookbag.gif" alt="Bookbag" style="vertical-align:bottom;"/></a>
                                    <span>(<span id="bagCount"><xsl:value-of select="count($bag/bag/savedDoc)"/></span>)</span>
                                 <xsl:if test="docHit">
                                    <xsl:text>&#160;&#160;</xsl:text>
                                    <xsl:variable name="cleanString" select="replace(replace($queryString,';*smode=docHits',''),'^;','')"/>
                                    <span><img src="{$icon.path}/i_rss.png" alt="rss icon" style="vertical-align:bottom;"/></span>
                                    <xsl:text>&#160;</xsl:text>
                                    <a href="search?{$cleanString};docsPerPage=100;rmode=rss;sort=rss">RSS</a>
                                    <xsl:text>&#160;</xsl:text>
                                 </xsl:if>
                                 </div>
                              </xsl:if>
                           </td>
                        </xsl:otherwise>
                     </xsl:choose>
                  </tr>
                  <tr>
                     <td colspan="3">
                        <xsl:choose>
                           <xsl:when test="$smode='showBag'">
                              <a>
                                 <xsl:attribute name="href">javascript://</xsl:attribute>
                                 <xsl:attribute name="onclick">
                                    <xsl:text>javascript:window.open('</xsl:text><xsl:value-of
                                       select="$xtfURL"/>search?smode=getAddress<xsl:text>','popup','width=500,height=200,resizable=no,scrollbars=no')</xsl:text>
                                 </xsl:attribute>
                                 <xsl:text>E-mail My Bookbag</xsl:text>
                              </a>
                           </xsl:when>
                           <xsl:otherwise>
                              <!--<div class="query">
                                 <div class="label">
                                    <b><xsl:value-of select="if($browse-all) then 'Browse by' else 'Search'"/>:</b>
                                 </div>
                                 <xsl:call-template name="format-query"/>
                              </div>-->
                           </xsl:otherwise>
                        </xsl:choose>
                     </td>
                  </tr>
                  <tr>
                     <td>
                        <strong><xsl:value-of select="if($smode='showBag') then 'Bookbag' else 'Results'"/>:</strong>&#160;
                        <xsl:variable name="items" select="@totalDocs"/>
                        <xsl:choose>
                           <xsl:when test="$type='ead' or $type = 'mods'">
                              <span id="bookbagCount">
                                 <span id="itemCount"><xsl:value-of select="$items"/></span>
                                 <xsl:text> Item</xsl:text><xsl:if test="$items &gt; 1">s</xsl:if>
                                 <xsl:value-of select="if($smode='showBag') then ':' else ' for '"/>
                                 <div class="ra-query"><xsl:call-template name="currentBrowse"/></div>
                              </span>
                           </xsl:when>
                           <xsl:when test="$items = 1">
                              <span id="bookbagCount">
                                 <span id="itemCount">1</span>
                                 <xsl:text> Item</xsl:text><xsl:value-of select="if($smode='showBag') then ':' else ' for '"/>
                                 <div class="ra-query"><xsl:call-template name="format-query"/></div>
                              </span>
                           </xsl:when>
                           <xsl:otherwise>
                              <span id="bookbagCount">
                                 <span id="itemCount">
                                    <xsl:value-of select="$items"/>
                                 </span>
                                 <xsl:text> Items</xsl:text><xsl:value-of select="if($smode='showBag') then ':' else ' for '"/>
                                 <div class="ra-query"><xsl:call-template name="format-query"/></div>
                              </span>
                           </xsl:otherwise>
                        </xsl:choose>
                        <!-- 3/26/12 WS: Added template to clear all items from bookbag -->
                        <xsl:if test="$smode='showBag'">
                        <script type="text/javascript">
                              removeAll = function() {
                                 var span = YAHOO.util.Dom.get('removeAll');
                                 var bbCount = YAHOO.util.Dom.get('bookbagCount');
                                 span.innerHTML = "Deleting...";
                                 YAHOO.util.Connect.asyncRequest('GET', 
                                    '<xsl:value-of select="concat($xtfURL, $crossqueryPath, '?smode=removeAllFromBag')"/>',
                                    {  success: function(o) { 
                                          var main = YAHOO.util.Dom.get('docHits');
                                          main.parentNode.removeChild(main);
                                          bbCount.innerHTML="0";
                                          span.innerHTML = "Your Bookbag is empty";
                                       },
                                       failure: function(o) { span.innerHTML = 'Failed to delete!'; }
                                    }, null);
                              };
                           </script>
                        <p id="removeAll" style="margin-top:4px;">
                           <a href="javascript:removeAll()">Clear All</a><br/>
                        </p>
                        </xsl:if>
                     </td>
                     <td>
                        <form method="get" action="{$xtfURL}{$crossqueryPath}">
                           <input type="text" name="keyword" size="40" value="{$keyword}"/>
                           <xsl:text>&#160;</xsl:text>
                           <input type="submit" value="Search"/>
                           <input type="hidden" value="collection" name="sort"/>
                           <input type="reset" onclick="location.href='{$xtfURL}{$crossqueryPath}'" value="Clear"/>
                        </form>
                        &#160;&#160;
                        <form method="get" action="{$xtfURL}{$crossqueryPath}">
                           <b>Sorted by:&#160;</b>
                           <xsl:call-template name="sort.options"/>
                           <xsl:call-template name="hidden.query">
                              <xsl:with-param name="queryString" select="editURL:remove($queryString, 'sort')"/>
                           </xsl:call-template>
                           <xsl:text>&#160;</xsl:text>
                           <input type="submit" value="Go!"/>
                        </form>
                     </td>
                     <td class="right">
                        <xsl:call-template name="pages"/>
                     </td>
                  </tr>
                  <xsl:if test="//spelling">
                     <tr>
                        <td>
                           <xsl:call-template name="did-you-mean">
                              <xsl:with-param name="baseURL" select="concat($xtfURL, $crossqueryPath, '?', $queryString)"/>
                              <xsl:with-param name="spelling" select="//spelling"/>
                           </xsl:call-template>
                        </td>
                        <td class="right">&#160;</td>
                     </tr>
                  </xsl:if>
                  <xsl:if test="docHit">
                     
                  </xsl:if>
               </table>
            </div>
            
            <!-- results -->
            <xsl:choose>
               <xsl:when test="docHit">
                  <div class="results">
                     <table>
                        <tr>
                           <xsl:if test="not($smode='showBag')">
                              <td class="facet">
                                 <!-- 3/26/12 WS: Added some if statements to only show facets if facet data is available -->
                                 <xsl:if test="facet[@field='facet-subject']/child::* or facet[@field='facet-subjectname']/child::* or facet[@field='facet-geogname']/child::*">
                                 <h3>Refine Search</h3>
                                    <xsl:if test="facet[@field='facet-subject']/child::*">  
                                       <xsl:apply-templates select="facet[@field='facet-subject']"/>
                                    </xsl:if>
                                    <xsl:if test="facet[@field='facet-subjectname']/child::*">
                                       <xsl:apply-templates select="facet[@field='facet-subjectname']"/>                                    
                                    </xsl:if>
                                    <xsl:if test="facet[@field='facet-geogname']/child::*">
                                       <xsl:apply-templates select="facet[@field='facet-geogname']"/>                                    
                                    </xsl:if>
                                    <xsl:apply-templates select="facet[@field='facet-format']"/>
                                    <!-- 10/31/12 WS: Commented out date facet 
                                       <xsl:apply-templates select="facet[@field='facet-date']"/>
                                    -->                                 
                                 </xsl:if>
                              </td>
                           </xsl:if>
                           <td class="docHit">
                              <div id="docHits">
<!--                                 <xsl:apply-templates select="facet[@field='facet-collection']"/>-->
                               
                                 <xsl:for-each-group select="docHit" group-by="@path">
                                    <xsl:call-template name="docHitColl"/>
                                </xsl:for-each-group>
                               
<!--                                 <xsl:apply-templates select="docHit"/> -->
                              </div>
                           </td>
                        </tr>
                        <xsl:if test="@totalDocs > $docsPerPage">
                           <tr>
                              <td colspan="2" class="center">
                                 <xsl:call-template name="pages"/>
                              </td>
                           </tr>
                        </xsl:if>
                     </table>
                  </div>
               </xsl:when>
               <xsl:otherwise>
                  <div class="results" id="docHits">
                     <table>
                        <tr>
                           <td>
                              <xsl:choose>
                                 <xsl:when test="$smode = 'showBag'">
                                    <p>Your Bookbag is empty.</p>
                                    <p>Click on the 'Add' link next to one or more items in your <a href="{session:getData('queryURL')}">Search Results</a>.</p>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <p>Sorry, no results...</p>
                                    <p>Try modifying your search:</p>
                                    <div class="forms">
                                       <xsl:choose>
                                          <xsl:when test="matches($smode,'advanced')">
                                             <xsl:call-template name="advancedForm"/>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <xsl:call-template name="simpleForm"/>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </div></xsl:otherwise>
                              </xsl:choose>
                           </td>
                        </tr>
                     </table>
                  </div>
               </xsl:otherwise>
            </xsl:choose>
            
            <!-- footer -->
            <xsl:copy-of select="$brand.footer"/>
            
         </body>
      </html>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Bookbag Templates                                                      -->
   <!-- ====================================================================== -->
   
   <xsl:template name="getAddress" exclude-result-prefixes="#all">
      <html xml:lang="en" lang="en">
         <head>
            <title>E-mail My Bookbag: Get Address</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:copy-of select="$brand.links"/>
         </head>
         <body>
            <div class="getAddress">
               <h2>E-mail My Bookbag</h2>
               <form action="{$xtfURL}{$crossqueryPath}" method="get">
                  <xsl:text>Address: </xsl:text>
                  <input type="text" name="email"/>
                  <xsl:text>&#160;</xsl:text>
                  <input type="reset" value="CLEAR"/>
                  <xsl:text>&#160;</xsl:text>
                  <input type="submit" value="SUBMIT"/>
                  <input type="hidden" name="smode" value="emailFolder"/>
               </form>
               <div class="closeWindow">
                  <a>
                     <xsl:attribute name="href">javascript://</xsl:attribute>
                     <xsl:attribute name="onClick">
                        <xsl:text>javascript:window.close('popup')</xsl:text>
                     </xsl:attribute>
                     X Close this Window
                  </a>
               </div>
            </div>
         </body>
      </html>
   </xsl:template>
   
   <xsl:template match="crossQueryResult" mode="emailFolder" exclude-result-prefixes="#all">
      
      <xsl:variable name="bookbagContents" select="session:getData('bag')/bag"/>
      
      <!-- Change the values for @smtpHost and @from to those valid for your domain -->
      <mail:send xmlns:mail="java:/org.cdlib.xtf.saxonExt.Mail" 
         xsl:extension-element-prefixes="mail" 
         smtpHost="mail.rockarch.org" 
         useSSL="no" 
         from="archive@rockarch.org"
         to="{$email}" 
         subject="XTF: My Bookbag">
            Your XTF Bookbag:
            <xsl:apply-templates select="$bookbagContents/savedDoc" mode="emailFolder"/>            
      </mail:send>
      
      <html xml:lang="en" lang="en">
         <head>
            <title>E-mail My Citations: Success</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:copy-of select="$brand.links"/>
         </head>
         <body>
            <xsl:copy-of select="$brand.header"/>
            <h1>E-mail My Citations</h1>
            <b>Your citations have been sent.</b>
            <div class="closeWindow">
               <a>
                  <xsl:attribute name="href">javascript://</xsl:attribute>
                  <xsl:attribute name="onClick">
                     <xsl:text>javascript:window.close('popup')</xsl:text>
                  </xsl:attribute>
                  X Close this Window
               </a>
            </div>
         </body>
      </html>
      
   </xsl:template>
   
   <xsl:template match="savedDoc" mode="emailFolder" exclude-result-prefixes="#all">
      <xsl:variable name="num" select="position()"/>
      <xsl:variable name="id" select="@id"/>
      <xsl:for-each select="$docHits[string(meta/identifier[1]) = $id][1]">
         <xsl:variable name="path" select="@path"/>
         <xsl:variable name="chunk.id" select="@subDocument"/>     
         <!-- 1/12/12 WS: Added docPath variable to enable scrolling to sub-document hits -->
         <xsl:variable name="docPath">
            <xsl:variable name="uri">
               <xsl:call-template name="dynaxml.url">
                  <xsl:with-param name="path" select="$path"/>
               </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
               <xsl:when test="$chunk.id != ''">
                  <xsl:value-of select="concat($xtfURL,$uri,';chunk.id=contentsLink;doc.view=contents','#',$chunk.id)"/>
                  <!-- Link used to get sub-document out of context               
                     <xsl:value-of select="concat($uri,';doc.view=contents',';chunk.id=',$chunk.id)"/> 
                  -->
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="$uri"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <!-- Need to add choose statement to get correct url when subdocument -->
         <xsl:variable name="url">
            <xsl:value-of select="$docPath"/>
            <!--<xsl:choose>
               <xsl:when test="matches(meta/display, 'dynaxml')">
                  <xsl:call-template name="dynaxml.url">
                     <xsl:with-param name="path" select="$path"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:call-template name="rawDisplay.url">
                     <xsl:with-param name="path" select="$path"/>
                  </xsl:call-template>
               </xsl:otherwise>
               </xsl:choose>-->
         </xsl:variable>
            Item number <xsl:value-of select="$num"/>: 
         <xsl:value-of select="meta/creator"/>. <xsl:value-of select="meta/title"/>. <xsl:if test="meta/collectionTitle"><xsl:value-of select="meta/collectionTitle"/>.</xsl:if> <xsl:value-of select="meta/subtitle"/>.
         <!-- 1/27/12 WS: changed meta/year to meta/date -->         
         <xsl:value-of select="meta/date"/>. 
         [<xsl:value-of select="$url"/>]   
      </xsl:for-each>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Browse Template                                                        -->
   <!-- ====================================================================== -->
   
   <xsl:template match="crossQueryResult" mode="browse" exclude-result-prefixes="#all">
      
      <xsl:variable name="alphaList" select="'A B C D E F G H I J K L M N O P Q R S T U V W Y Z OTHER'"/>
      
      <html xml:lang="en" lang="en">
         <head>
            <title>XTF: Search Results</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:copy-of select="$brand.links"/>
            <!-- AJAX support -->
            <script src="script/yui/yahoo-dom-event.js" type="text/javascript"/> 
            <script src="script/yui/connection-min.js" type="text/javascript"/> 
         </head>
         <body>            
            <!-- header -->
            <xsl:copy-of select="$brand.header"/>
            
            <!-- result header -->
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
                           <a href="{$xtfURL}{$crossqueryPath}">
                              <xsl:text>NEW SEARCH</xsl:text>
                           </a>
                           <xsl:if test="$smode = 'showBag'">
                              <xsl:text>&#160;|&#160;</xsl:text>
                              <a href="{session:getData('queryURL')}">
                                 <xsl:text>RETURN TO SEARCH RESULTS</xsl:text>
                              </a>
                           </xsl:if>
                           <xsl:text>&#160;|&#160;</xsl:text>
                           <!--<a href="search?browse-all=yes">
                              <xsl:text>BROWSE</xsl:text>
                              </a>-->
                           <a href="search?smode=browse">
                              <xsl:text>BROWSE</xsl:text>
                           </a>
                        </div>
                     </td>
                  </tr>
               </table>
               <div class="resultsHeader">
                  <table>
                     <tr>
                        <td colspan="2">
                           <strong>Browse by: </strong>
                           <xsl:call-template name="currentBrowseLinks"/>
                        </td>
                        <td class="right">
                        <xsl:variable name="bag" select="session:getData('bag')"/>
                           <div>
                              <a href="{$xtfURL}{$crossqueryPath}?smode=showBag"><img src="/xtf/icons/default/bookbag.gif" alt="Bookbag" style="vertical-align:middle;"/></a>
                              <span>(<span id="bagCount"><xsl:value-of select="count($bag/bag/savedDoc)"/></span>)</span>
                           </div>
                           
                        </td>
                     </tr>
                     <tr>
                     <td>
                        
                     </td>
                     <td class="right">
                        <xsl:if test="$smode = 'showBag'">
                           <xsl:text>&#160;|&#160;</xsl:text>
                           <a href="{session:getData('queryURL')}">
                              <xsl:text>Return to Search Results</xsl:text>
                           </a>
                        </xsl:if>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="3">
                         <strong>Browsing:&#160;</strong><xsl:call-template name="currentBrowse"/>
                        <!--<strong>Results:&#160;</strong>
                        <xsl:variable name="items" select="facet/group[docHit]/@totalDocs"/>
                        <xsl:choose>
                           <xsl:when test="$items &gt; 1">
                              <xsl:value-of select="$items"/>
                              <xsl:text> Items</xsl:text>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$items"/>
                              <xsl:text> Item</xsl:text>
                           </xsl:otherwise>
                        </xsl:choose>-->
                     </td>
                  </tr>
                  <tr>
                     <td colspan="2" class="center">
                        <xsl:call-template name="alphaList">
                           <xsl:with-param name="alphaList" select="$alphaList"/>
<!--                           <xsl:with-param name="level" select="'collection'"/>-->
                        </xsl:call-template>
                        <xsl:choose>
                           <xsl:when test="$browse-title">
                              &#160;| <a href="{$xtfURL}{$crossqueryPath}?browse-all=yes;level=collection;sort=title">BROWSE ALL</a>
                           </xsl:when>
                           <xsl:when test="$browse-creator">
                              &#160;| <a href="{$xtfURL}{$crossqueryPath}?browse-all=yes;level=collection;sort=creator">BROWSE ALL</a>
                           </xsl:when>
                        </xsl:choose>

                     </td>
                  </tr>
                  
               </table>
            </div>
            
            <!-- results -->
            <div class="results">
               <table>
                  <tr>
                     <td>
                        <xsl:choose>
                           <xsl:when test="$browse-title">
                              <xsl:apply-templates select="facet[@field='browse-title']/group/docHit"/>
                           </xsl:when>
                           <xsl:when test="$browse-creator">
                              <xsl:apply-templates select="facet[@field='browse-creator']/group/docHit"/>
                           </xsl:when>
                           <!-- 9/26/11 WS: Added browse options -->
                           <xsl:when test="$browse-subject">
                              <xsl:apply-templates select="facet[@field='browse-subject']/group/docHit"/>
                           </xsl:when>
                           <xsl:when test="$browse-subjectname">
                              <xsl:apply-templates select="facet[@field='browse-subjectname']/group/docHit"/>
                           </xsl:when>
                           <xsl:when test="$browse-geogname">
                              <xsl:apply-templates select="facet[@field='browse-geogname']/group/docHit"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:apply-templates select="facet[@field='browse-creator']/group/docHit"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </td>
                  </tr>
               </table>
            </div>
            
            <!-- footer -->
            <xsl:copy-of select="$brand.footer"/>
            
         </body>
      </html>
   </xsl:template>
   
   <xsl:template name="browseLinks">
         <div class="browselinks">
            <table style="width:90%;margin-left:2em;">
               <tr><td colspan="2"><span style="margin:left:60px; font-size:1.2em;"><a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection">Browse All</a></span></td></tr>
               <tr>
                  <td style="width:250px;">
                     <dl style="background: url(/xtf/icons/default/collections.gif) left no-repeat; min-height: 50px;">
                        <dt>
                              <h4 style="margin-left:60px; font-size:1.2em;">
                                 <a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=ead">Browse Archival Collections</a>
                              </h4>
                        </dt>
                        <dd style="margin-left:70px;"><a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title&amp;browse-all=yes;level=collection;type=ead">by Title</a></dd>
                        <dd style="margin-left:70px;"><a href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=title&amp;browse-all=yes;level=collection;type=ead">by Creator</a></dd>
                     </dl>
                  </td>
                  <td style="width:250px;">
                     <dl style="background: url(/xtf/icons/default/book.gif) left no-repeat; min-height: 50px;">
                        <dt>
                           <h4 style="margin-left:60px; font-size:1.2em;">
                              <a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=mods">Browse Library Materials</a>
                           </h4>
                        </dt>
                        <dd style="margin-left:70px;"><a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title&amp;browse-all=yes;level=collection;type=mods">by Title</a></dd>
                        <dd style="margin-left:70px;"><a href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=title&amp;browse-all=yes;level=collection;type=mods">by Creator</a></dd>
                     </dl>
                  </td>
                  <!--<td style="width:250px;">
                     <dl style="background: url(/xtf/icons/default/video.gif) left no-repeat; min-height: 50px;">
                        <dt>
                           <h4 style="margin-left:60px; font-size:1.2em;">
                              <a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=other">Browse Other Material</a>
                           </h4>
                        </dt>
                        <dd style="margin-left:70px;"><a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title&amp;browse-all=yes;level=collection;type=other">by Title</a></dd>
                        <dd style="margin-left:70px;"><a href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=title&amp;browse-all=yes;level=collection;type=other">by Creator</a></dd>
                     </dl>
                  </td>-->
               </tr>
            </table>
         </div>
 </xsl:template>
   
   <xsl:template name="currentBrowseLinks">
      <span class="currentBrowse">
            <a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection">All</a>
          |
            <a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=ead">
               <xsl:if test="$type='ead' and not($browse-title) and not($browse-creator)">
                  <xsl:attribute name="class">active</xsl:attribute>
               </xsl:if>
               Archival Collections</a> |  
            <a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=mods">
               <xsl:if test="$type='mods' and not($browse-title) and not($browse-creator)">
                  <xsl:attribute name="class">active</xsl:attribute>
               </xsl:if>
               Library Materials</a>           
      </span>
   </xsl:template>   
   
   <xsl:template name="currentBrowse">
      <xsl:choose>
         <xsl:when test="$type='ead'">
            <xsl:choose>
               <xsl:when test="$browse-title">Collections by Title</xsl:when>
               <xsl:when test="$browse-creator">Collections by Creator</xsl:when>
               <xsl:otherwise>All Collections</xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:when test="$type='mods'">
            <xsl:choose>
               <xsl:when test="$browse-title">Library Materials by Title</xsl:when>
               <xsl:when test="$browse-creator">Library Materials by Creator</xsl:when>
               <xsl:otherwise>All Library Materials</xsl:otherwise>
            </xsl:choose>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   <!-- ====================================================================== -->
   <!-- Document Hit Template                                                  -->
   <!-- ====================================================================== -->
   
   <xsl:template match="docHit" exclude-result-prefixes="#all">
      <xsl:variable name="chunk.id" select="@subDocument"/>         
      <xsl:variable name="level" select="meta/level"/>
      <xsl:variable name="path" select="@path"/>
      <xsl:variable name="identifier" select="meta/identifier[1]"/>
      <xsl:variable name="quotedID" select="concat('&quot;', $identifier, '&quot;')"/>
      <xsl:variable name="indexId" select="replace($identifier, '.*/', '')"/>
      <!-- 1/12/12 WS: Added docPath variable to enable scrolling to sub-document hits -->
      <xsl:variable name="docPath">
         <xsl:variable name="uri">
            <xsl:call-template name="dynaxml.url">
               <xsl:with-param name="path" select="$path"/>
            </xsl:call-template>
         </xsl:variable>
         <xsl:choose>
            <xsl:when test="$chunk.id != ''">
               <xsl:value-of select="concat($uri,';chunk.id=contentsLink;doc.view=contents','#',$chunk.id)"/>
<!-- Link used to get sub-document out of context               
   <xsl:value-of select="concat($uri,';doc.view=contents',';chunk.id=',$chunk.id)"/> 
-->
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$uri"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <!-- scrolling anchor -->
      <xsl:variable name="anchor">
         <xsl:choose>
            <xsl:when test="$sort = 'creator'">
               <xsl:value-of select="substring(string(meta/creator[1]), 1, 1)"/>
            </xsl:when>
            <xsl:when test="$sort = 'title'">
               <xsl:value-of select="substring(string(meta/title[1]), 1, 1)"/>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>
      <div id="main_{@rank}" class="docHit">    
         <table>
            <!-- 9/26/11 WS: Moved title above Author -->
            <tr>
               <td style="width:1em;">
                  <xsl:choose>
                     <xsl:when test="$sort = ''">
                        <b><xsl:value-of select="@rank"/></b>
                     </xsl:when>
                     <xsl:otherwise>
                        <b><xsl:value-of select="@rank"/></b>
                        <xsl:text>&#160;</xsl:text>
                     </xsl:otherwise>
                  </xsl:choose>
               </td>
               <td rowspan="3"  style="width:3em; text-align:center;">
                  <xsl:choose>
                     <xsl:when test="meta/genre[contains(.,'DVD')]">
                        <img src="/xtf/icons/default/video.gif" alt="Moving Image"/>
                        <span style="font-size:.75em;color:#C45428;display:block;">Moving Image</span>
                     </xsl:when>
                     <xsl:when test="meta/genre[contains(.,'Videocassette')]">
                        <img src="/xtf/icons/default/video.gif" alt="Moving Image"/> 
                        <span style="font-size:.75em;color:#C45428;display:block;">Moving Image</span>
                     </xsl:when>
                     <xsl:when test="meta/genre[contains(.,'Reel')]">
                        <img src="/xtf/icons/default/microfilm.gif" alt="microfilm"/> 
                        <span style="font-size:.75em;color:#C45428;display:block;">Microfilm</span>
                     </xsl:when>                     
                     <xsl:when test="meta/genre[contains(.,'Volume')]">
                        <img src="/xtf/icons/default/book.gif" alt="Book"/>   
                        <span style="font-size:.75em;color:#C45428;display:block;">Book</span>                        
                     </xsl:when>
                     <xsl:when test="meta/type = 'ead'">
                        <img src="/xtf/icons/default/collections.gif" alt="Collection"/>
                        <span style="font-size:.75em;color:#C45428;display:block;">Collection</span>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="meta/genre"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </td>
               <td style="width:10em !important; text-align:right;">
                  <xsl:if test="$sort = 'title'">
                     <a name="{$anchor}"/>
                  </xsl:if>
                  <b>Title:&#160;&#160;</b>
               </td>
               <td>
                  <a>
                     <xsl:attribute name="href">
                        <xsl:value-of select="$docPath"/>
                     </xsl:attribute>
                     <xsl:choose>
                        <xsl:when test="meta/title">
                           <xsl:choose>
                              <xsl:when test="count(meta/title) &gt; 1">
                                 <xsl:apply-templates select="meta/title[2]"/>      
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:apply-templates select="meta/title[1]"/>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:when>
                        <xsl:when test="meta/subtitle">
                           <xsl:choose>
                              <xsl:when test="count(meta/subtitle) &gt; 1">
                                 <xsl:apply-templates select="meta/subtitle[2]"/>      
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:apply-templates select="meta/subtitle[1]"/>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>none</xsl:otherwise>
                     </xsl:choose>
                  </a>
                  <xsl:text>&#160;</xsl:text>
                  <!--
                  <xsl:variable name="type" select="meta/type"/>
                  <span class="typeIcon">
                     <img src="{$icon.path}i_{$type}.gif" class="typeIcon"/>
                  </span>
                  -->
               </td>
               <td style="width:10em; text-align:center;">
                  <!-- Add/remove logic for the session bag (only if session tracking enabled) -->
                  <span class="addToBag">
                  <xsl:if test="session:isEnabled()">
                     <xsl:choose>
                        <xsl:when test="$smode = 'showBag'">
                           <script type="text/javascript">
                              remove_<xsl:value-of select="@rank"/> = function() {
                                 var span = YAHOO.util.Dom.get('remove_<xsl:value-of select="@rank"/>');
                                 span.innerHTML = "Deleting...";
                                 YAHOO.util.Connect.asyncRequest('GET', 
                                    '<xsl:value-of select="concat($xtfURL, $crossqueryPath, '?smode=removeFromBag;identifier=', $identifier)"/>',
                                    {  success: function(o) { 
                                          var main = YAHOO.util.Dom.get('main_<xsl:value-of select="@rank"/>');
                                          main.parentNode.removeChild(main);
                                          --(YAHOO.util.Dom.get('itemCount').innerHTML);
                                       },
                                       failure: function(o) { span.innerHTML = 'Failed to delete!'; }
                                    }, null);
                              };
                           </script>
                           <span id="remove_{@rank}">
                              <a href="javascript:remove_{@rank}()">Delete</a>
                           </span>
                        </xsl:when>
                        <xsl:when test="session:noCookie()">
                           <span><a href="javascript:alert('To use the bag, you must enable cookies in your web browser.')">Requires cookie*</a></span>                                 
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:choose>
                              <xsl:when test="session:getData('bag')/bag/savedDoc[@id=$indexId]">
                                 <img src="/xtf/icons/default/addbag.gif" alt="Added to bookbag" title="Added to bookbag"/><br/>
                                 <span class="caption">Added</span>
                              </xsl:when>
                              <xsl:otherwise>
                                 <script type="text/javascript">
                                    add_<xsl:value-of select="@rank"/> = function() {
                                       var span = YAHOO.util.Dom.get('add_<xsl:value-of select="@rank"/>');
                                       span.innerHTML = "Adding...";
                                       YAHOO.util.Connect.asyncRequest('GET', 
                                          '<xsl:value-of select="concat($xtfURL, $crossqueryPath, '?smode=addToBag;identifier=', $identifier)"/>',
                                          {  success: function(o) { 
                                                span.innerHTML = o.responseText;
                                                ++(YAHOO.util.Dom.get('bagCount').innerHTML);
                                             },
                                             failure: function(o) { span.innerHTML = 'Failed to add!'; }
                                          }, null);
                                    };
                                 </script>
                                 <a href="javascript:add_{@rank}()"><img src="/xtf/icons/default/addbag.gif" alt="Add to bookbag" title="Add to bookbag"/></a><br/>
                                 <span id="add_{@rank}" class="caption">
                                    <span class="caption"><a href="javascript:add_{@rank}()">Add</a></span>
                                 </span>
                              </xsl:otherwise>
                           </xsl:choose>
                           <xsl:value-of select="session:setData('queryURL', concat($xtfURL, $crossqueryPath, '?', $queryString))"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:if>
               </span>
               </td>
            </tr>            
            <tr>
               <td class="col1">
                  <xsl:text>&#160;</xsl:text>
               </td>
               <td style="text-align:right;">
                  <xsl:if test="$sort = 'creator'">
                     <a name="{$anchor}"/>
                  </xsl:if>
                  <!-- 9/26/11 WS: changed author to creator-->
                  <b>Creator:&#160;&#160;</b>
               </td>
               <td class="col3">
                  <xsl:choose>
                     <xsl:when test="meta/creator">
                        <xsl:apply-templates select="meta/creator[1]"/>
                     </xsl:when>
                     <xsl:otherwise>none</xsl:otherwise>
                  </xsl:choose>
               </td>
               <td class="col4">
                  <xsl:text>&#160;</xsl:text> 
               </td>
            </tr>

            <tr>
               <td>
                  <xsl:text>&#160;</xsl:text>
               </td>
               <td style="text-align:right;">
                  <!-- 9/26/11 WS: changed Published to Date -->
                  <b>Date(s):&#160;&#160;</b>
               </td>
               <td>
                  <!-- 9/27/11 WS: Changed date to always grab from meta/date -->
                  <xsl:choose>
                     <xsl:when test="meta/date">
                        <xsl:apply-templates select="meta/date"/>      
                     </xsl:when>
                     <xsl:otherwise>
                        unknown
                     </xsl:otherwise>
                  </xsl:choose>
                  <!--  
                  <xsl:choose>
                     <xsl:when test="meta/year">
                        <xsl:value-of select="replace(meta/year[1],'^.+ ','')"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:apply-templates select="meta/date"/>
                     </xsl:otherwise>
                  </xsl:choose>
                  -->
               </td>
               <td>
                  <xsl:text>&#160;</xsl:text>
               </td>
            </tr>
            <xsl:if test="meta/subject">
               <tr>
                  <td colspan="2">
                     <xsl:text>&#160;</xsl:text>
                  </td>
                  <td style="text-align:right;">
                     <b>Subjects:&#160;&#160;</b>
                  </td>
                  <td>
                     <xsl:apply-templates select="meta/subject"/>
                  </td>
                  <td>
                     <xsl:text>&#160;</xsl:text>
                  </td>
               </tr>
            </xsl:if>
            <!-- 1/26/12 WS: Added descendant-or-self to catch deeply nested matches -->
            <xsl:if test="descendant-or-self::snippet">
               <tr>
                  <td colspan="2">
                     <xsl:text>&#160;</xsl:text>
                  </td>
                  <td style="text-align:right;">
                     <b>Matches:&#160;&#160;</b>
                     <br/>
                     <xsl:value-of select="@totalHits"/> 
                     <xsl:value-of select="if (@totalHits = 1) then ' hit' else ' hits'"/>&#160;&#160;&#160;&#160;
                  </td>
                  <td colspan="2">
                     <xsl:apply-templates select="descendant-or-self::snippet" mode="text"/>
                  </td>
               </tr>
            </xsl:if>
            <!-- "more like this" -->
            <tr>
               <td colspan="2">
                  <xsl:text>&#160;</xsl:text>
               </td>
               <td style="text-align:right;">
                  <b>Similar&#160;Items:&#160;&#160;</b>
               </td>
               <td colspan="2">
                  <script type="text/javascript">
                     getMoreLike_<xsl:value-of select="@rank"/> = function() {
                        var span = YAHOO.util.Dom.get('moreLike_<xsl:value-of select="@rank"/>');
                        span.innerHTML = "Fetching...";
                        YAHOO.util.Connect.asyncRequest('GET', 
                           '<xsl:value-of select="concat('search?smode=moreLike;docsPerPage=5;identifier=', $identifier)"/>',
                           { success: function(o) { span.innerHTML = o.responseText; },
                             failure: function(o) { span.innerHTML = "Failed!" } 
                           }, null);
                     };
                  </script>
                  <span id="moreLike_{@rank}">
                     <a href="javascript:getMoreLike_{@rank}()">Find</a>
                  </span>
               </td>
            </tr> 
         </table>
      </div>
   </xsl:template>
   
   <xsl:template name="docHitColl" exclude-result-prefixes="#all">
      <xsl:variable name="chunk.id" select="@subDocument"/>         
      <xsl:variable name="level" select="meta/level"/>
      <xsl:variable name="path" select="@path"/>
      <xsl:variable name="identifier" select="meta/identifier[1]"/>
      <xsl:variable name="quotedID" select="concat('&quot;', $identifier, '&quot;')"/>
      <xsl:variable name="indexId" select="replace($identifier, '.*/', '')"/>
      <!-- 1/12/12 WS: Added docPath variable to enable scrolling to sub-document hits -->
      <xsl:variable name="docPath">
         <xsl:variable name="uri">
            <xsl:call-template name="dynaxml.url">
               <xsl:with-param name="path" select="$path"/>
            </xsl:call-template>
         </xsl:variable>
         <xsl:choose>
            <xsl:when test="$chunk.id != ''">
               <xsl:value-of select="concat($uri,';chunk.id=contentsLink;doc.view=contents','#',$chunk.id)"/>
               <!-- Link used to get sub-document out of context               
                  <xsl:value-of select="concat($uri,';doc.view=contents',';chunk.id=',$chunk.id)"/> 
               -->
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$uri"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="collPath">
         <xsl:variable name="uri">
            <xsl:call-template name="dynaxml.url">
               <xsl:with-param name="path" select="$path"/>
            </xsl:call-template>
         </xsl:variable>
         <xsl:value-of select="$uri"/>
      </xsl:variable>
      <!-- scrolling anchor -->
      <xsl:variable name="anchor">
         <xsl:choose>
            <xsl:when test="$sort = 'creator'">
               <xsl:value-of select="substring(string(meta/creator[1]), 1, 1)"/>
            </xsl:when>
            <xsl:when test="$sort = 'title'">
               <xsl:value-of select="substring(string(meta/title[1]), 1, 1)"/>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>

      <div id="main_{@rank}" class="docHit">    
         <table>
            <!-- Deals with collections vrs. series/files -->
            <xsl:choose>
               <xsl:when test="meta/level = 'collection'">
                  <tr>
                     <td class="col1" style="width:2em;">
                        <xsl:choose>
                           <xsl:when test="$sort = ''">
                              <b><xsl:value-of select="@rank"/></b>
                           </xsl:when>
                           <xsl:otherwise>
                              <b><xsl:value-of select="@rank"/></b>
                              <xsl:text>&#160;</xsl:text>
                           </xsl:otherwise>
                        </xsl:choose>
                     </td>
                     <td rowspan="3"  style="width:3em; text-align:center;">
                        <xsl:choose>
                           <xsl:when test="meta/genre[contains(.,'DVD')]">
                              <img src="/xtf/icons/default/video.gif" alt="Moving Image"/>
                              <span style="font-size:.75em;color:#C45428;display:block;">Moving Image</span>
                           </xsl:when>
                           <xsl:when test="meta/genre[contains(.,'Videocassette')]">
                              <img src="/xtf/icons/default/video.gif" alt="Moving Image"/> 
                              <span style="font-size:.75em;color:#C45428;display:block;">Moving Image</span>
                           </xsl:when>
                           <xsl:when test="meta/genre[contains(.,'Reel')]">
                              <img src="/xtf/icons/default/microfilm.gif" alt="microfilm"/> 
                              <span style="font-size:.75em;color:#C45428;display:block;">Microfilm</span>
                           </xsl:when>                     
                           <xsl:when test="meta/genre[contains(.,'Volume')]">
                              <img src="/xtf/icons/default/book.gif" alt="Book"/>   
                              <span style="font-size:.75em;color:#C45428;display:block;">Book</span>                        
                           </xsl:when>
                           <xsl:when test="meta/type = 'ead'">
                              <img src="/xtf/icons/default/collections.gif" alt="Collection"/>
                              <span style="font-size:.75em;color:#C45428;display:block;">Collection</span>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="meta/genre"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </td>
                     <td class="col2">
                        <xsl:if test="$sort = 'title'">
                           <a name="{$anchor}"/>
                        </xsl:if>
                        <b>Title:&#160;&#160;</b>
                     </td>
                     <td class="col3">
                        <a>
                           <xsl:attribute name="href">
                              <xsl:value-of select="$docPath"/>
                           </xsl:attribute>
                           <xsl:choose>
                              <xsl:when test="meta/title">
                                 <xsl:choose>
                                    <xsl:when test="count(meta/title) &gt; 1">
                                       <xsl:apply-templates select="meta/title[2]"/>      
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:apply-templates select="meta/title[1]"/>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </xsl:when>
                              <xsl:when test="meta/subtitle">
                                 <xsl:choose>
                                    <xsl:when test="count(meta/subtitle) &gt; 1">
                                       <xsl:apply-templates select="meta/subtitle[2]"/>      
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:apply-templates select="meta/subtitle[1]"/>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </xsl:when>
                              <xsl:otherwise>none</xsl:otherwise>
                           </xsl:choose>
                        </a>
                        <xsl:text>&#160;</xsl:text>
                        <!--
                        <xsl:variable name="type" select="meta/type"/>
                           <span class="typeIcon">
                           <img src="{$icon.path}i_{$type}.gif" class="typeIcon"/>
                           </span>
                        -->
                     </td>
                     <td class="col4" style="text-align:center">
                        <!-- Add/remove logic for the session bag (only if session tracking enabled) -->
                        <span class="addToBag">
                           <xsl:if test="session:isEnabled()">
                              <xsl:choose>
                                 <xsl:when test="$smode = 'showBag'">
                                    <script type="text/javascript">
                              remove_<xsl:value-of select="@rank"/> = function() {
                                 var span = YAHOO.util.Dom.get('remove_<xsl:value-of select="@rank"/>');
                                 span.innerHTML = "Deleting...";
                                 YAHOO.util.Connect.asyncRequest('GET', 
                                    '<xsl:value-of select="concat($xtfURL, $crossqueryPath, '?smode=removeFromBag;identifier=', $identifier)"/>',
                                    {  success: function(o) { 
                                          var main = YAHOO.util.Dom.get('main_<xsl:value-of select="@rank"/>');
                                          main.parentNode.removeChild(main);
                                          --(YAHOO.util.Dom.get('itemCount').innerHTML);
                                       },
                                       failure: function(o) { span.innerHTML = 'Failed to delete!'; }
                                    }, null);
                              };
                           </script>
                                    <span id="remove_{@rank}">
                                       <a href="javascript:remove_{@rank}()">Delete</a>
                                    </span>
                                 </xsl:when>
                                 <xsl:when test="session:noCookie()">
                                    <span><a href="javascript:alert('To use the bag, you must enable cookies in your web browser.')">Requires cookie*</a></span>                                 
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:choose>
                                       <xsl:when test="session:getData('bag')/bag/savedDoc[@id=$indexId]">
                                          <img src="/xtf/icons/default/addbag.gif" alt="Added to bookbag" title="Added to bookbag"/><br/>
                                             <span class="caption">Added</span>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <script type="text/javascript">
                                    add_<xsl:value-of select="@rank"/> = function() {
                                       var span = YAHOO.util.Dom.get('add_<xsl:value-of select="@rank"/>');
                                       span.innerHTML = "Adding...";
                                       YAHOO.util.Connect.asyncRequest('GET', 
                                          '<xsl:value-of select="concat($xtfURL, $crossqueryPath, '?smode=addToBag;identifier=', $identifier)"/>',
                                          {  success: function(o) { 
                                                span.innerHTML = o.responseText;
                                                ++(YAHOO.util.Dom.get('bagCount').innerHTML);
                                             },
                                             failure: function(o) { span.innerHTML = 'Failed to add!'; }
                                          }, null);
                                    };
                                          </script>
                                          <a href="javascript:add_{@rank}()"><img src="/xtf/icons/default/addbag.gif" alt="Add to bookbag" title="Add to bookbag"/></a><br/>
                                          <span id="add_{@rank}" class="caption">
                                             <a href="javascript:add_{@rank}()">Add</a>
                                          </span>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:value-of select="session:setData('queryURL', concat($xtfURL, $crossqueryPath, '?', $queryString))"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:if>
                        </span>
                     </td>
                  </tr> 
                  <tr>
                     <td class="col1">
                        <xsl:text>&#160;</xsl:text>
                     </td>
                     <td class="col2">
                        <xsl:if test="$sort = 'creator'">
                           <a name="{$anchor}"/>
                        </xsl:if>
                        <!-- 9/26/11 WS: changed author to creator-->
                        <b>Creator:&#160;&#160;</b>
                     </td>
                     <td class="col3">
                        <xsl:choose>
                           <xsl:when test="meta/creator">
                              <xsl:apply-templates select="meta/creator[1]"/>
                           </xsl:when>
                           <xsl:otherwise>none</xsl:otherwise>
                        </xsl:choose>
                     </td>
                     <td class="col4">
                        <xsl:text>&#160;</xsl:text> 
                     </td>
                  </tr>
                     <tr>
                        <td class="col1" colspan="2">
                           <xsl:text>&#160;</xsl:text>
                        </td>
                        <td class="col2">
                           <b>Publisher:&#160;&#160;</b>
                        </td>
                        <td class="col3">
                           <xsl:apply-templates select="meta/publisher"/>
                        </td>
                        <td class="col4">
                           <!-- Removed add to bag, when on a file, because it was buggy -->
                        </td>
                     </tr>
                  <tr>
                     <td class="col1" colspan="2">
                        <xsl:text>&#160;</xsl:text>
                     </td>
                     <td class="col2">
                        <!-- 9/26/11 WS: changed Published to Date -->
                        <b>Date(s):&#160;&#160;</b>
                     </td>
                     <td class="col3">
                        <!-- 9/27/11 WS: Changed date to always grab from meta/date -->
                        <xsl:choose>
                           <xsl:when test="meta/date">
                              <xsl:apply-templates select="meta/date"/>      
                           </xsl:when>
                           <xsl:otherwise>
                              unknown
                           </xsl:otherwise>
                        </xsl:choose>
                     </td>
                     <td class="col4">
                        <xsl:text>&#160;</xsl:text>
                     </td>
                  </tr>
                  <xsl:if test="meta/callNo">
                     <tr>
                        <td class="col1" colspan="2">
                           <xsl:text>&#160;</xsl:text>
                        </td>
                        <td class="col2">
                           <b>Call number:&#160;&#160;</b>
                        </td>
                        <td class="col3">
                           <xsl:apply-templates select="meta/callNo"/>
                        </td>
                        <td class="col4">
                           <!-- Removed add to bag, when on a file, because it was buggy -->
                        </td>
                     </tr>
                  </xsl:if>                   
                <!-- 1/26/12 WS: Added descendant-or-self to catch deeply nested matches -->
                  <xsl:if test="descendant-or-self::snippet">
                     <tr>
                        <td class="col1" colspan="2">
                           <xsl:text>&#160;</xsl:text>
                        </td>
                        <td class="col2">
                           <b>Matches:&#160;&#160;</b>
                           <br/>
                           <xsl:value-of select="@totalHits"/> 
                           <xsl:value-of select="if (@totalHits = 1) then ' hit' else ' hits'"/>&#160;&#160;&#160;&#160;
                        </td>
                        <td class="col3" colspan="2">
                           <xsl:apply-templates select="descendant-or-self::snippet" mode="text"/>
                        </td>
                     </tr>
                  </xsl:if>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:variable name="collectionId" select="substring-before(meta/identifier[1],'|')"/>
                  <tr>
                     <td class="col1">
                        <xsl:choose>
                           <xsl:when test="$sort = ''">
                              <b><xsl:value-of select="@rank"/></b>
                           </xsl:when>
                           <xsl:otherwise>
                              <b><xsl:value-of select="@rank"/></b>
                              <xsl:text>&#160;</xsl:text>
                           </xsl:otherwise>
                        </xsl:choose>
                     </td>
                     <td rowspan="2"  style="width:3em; text-align:center;">
                        <xsl:choose>
                           <xsl:when test="meta/genre[contains(.,'DVD')]">
                              <img src="/xtf/icons/default/video.gif" alt="Moving Image"/>
                              <span style="font-size:.75em;color:#C45428;display:block;">Moving Image</span>
                           </xsl:when>
                           <xsl:when test="meta/genre[contains(.,'Videocassette')]">
                              <img src="/xtf/icons/default/video.gif" alt="Moving Image"/> 
                              <span style="font-size:.75em;color:#C45428;display:block;">Moving Image</span>
                           </xsl:when>
                           <xsl:when test="meta/genre[contains(.,'Reel')]">
                              <img src="/xtf/icons/default/microfilm.gif" alt="microfilm"/> 
                              <span style="font-size:.75em;color:#C45428;display:block;">Microfilm</span>
                           </xsl:when>                     
                           <xsl:when test="meta/genre[contains(.,'Volume')]">
                              <img src="/xtf/icons/default/book.gif" alt="Book"/>   
                              <span style="font-size:.75em;color:#C45428;display:block;">Book</span>                        
                           </xsl:when>
                           <xsl:when test="meta/type = 'ead'">
                              <img src="/xtf/icons/default/collections.gif" alt="Collection"/>
                              <span style="font-size:.75em;color:#C45428;display:block;">Collection</span>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="meta/genre"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </td>
                     <td class="col2">
                        <xsl:if test="$sort = 'title'">
                           <a name="{$anchor}"/>
                        </xsl:if>
                        <b>Title:&#160;&#160;</b>
                     </td>
                     <td class="col3">
                        <a>
                           <xsl:attribute name="href">
                              <xsl:value-of select="$collPath"/>
                           </xsl:attribute>
                           <xsl:choose>
                              <xsl:when test="meta/collectionTitle">
                                 <xsl:apply-templates select="meta/collectionTitle"/>
                              </xsl:when>
                              <xsl:when test="meta/subtitle">
                                 <xsl:apply-templates select="meta/subtitle"/>
                              </xsl:when>
                              <xsl:when test="meta/title">
                                 <xsl:apply-templates select="meta/title"/>
                              </xsl:when>
                              <xsl:otherwise>none</xsl:otherwise>
                           </xsl:choose>
                        </a>
                        <xsl:text>&#160;</xsl:text>
                        <!--
                        <xsl:variable name="type" select="meta/type"/>
                           <span class="typeIcon">
                           <img src="{$icon.path}i_{$type}.gif" class="typeIcon"/>
                           </span>
                        -->
                     </td>
                     <td class="col4">
                        <!-- Removed add to bag, when on a file, because it was buggy -->
                    </td>
                  </tr> 
                  <tr>
                     <td class="col1">
                        <xsl:text>&#160;</xsl:text>
                     </td>
                     <td class="col2">
                        <xsl:if test="$sort = 'creator'">
                           <a name="{$anchor}"/>
                        </xsl:if>
                        <!-- 9/26/11 WS: changed author to creator-->
                        <b>Creator:&#160;&#160;</b>
                     </td>
                     <td class="col3">
                        <xsl:choose>
                           <xsl:when test="meta/collectionCreator">
                              <xsl:apply-templates select="meta/collectionCreator[1]"/>
                           </xsl:when>
                           <xsl:when test="meta/creator">
                              <xsl:apply-templates select="meta/creator[1]"/>
                           </xsl:when>
                           <xsl:otherwise>none</xsl:otherwise>
                        </xsl:choose>
                     </td>
                     <td class="col4">
                        <xsl:text>&#160;</xsl:text> 
                     </td>
                  </tr>                
               </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="meta/subject">
               <tr>
                  <td class="col1" colspan="2">
                     <xsl:text>&#160;</xsl:text>
                  </td>
                  <td class="col2">
                     <b>Subjects:&#160;&#160;</b>
                  </td>
                  <td class="col3">
                     <xsl:apply-templates select="meta/subject"/>
                  </td>
                  <td class="col4">
                     <xsl:text>&#160;</xsl:text>
                  </td>
               </tr>
            </xsl:if>
            <xsl:for-each select="current-group()[meta/level != 'collection']">
<!--            <xsl:for-each select="current-group()[position() &lt; 5][meta/level != 'collection']">-->
               <tr>
                  <td class="col1" colspan="2"></td>
                  <td></td>
                  <td colspan="3">
                  <xsl:call-template name="subDocument"/>
                  </td>
               </tr>
            </xsl:for-each>
            <!-- "more like this" -->
            <tr>
               <td class="col1" colspan="2">
                  <xsl:text>&#160;</xsl:text>
               </td>
               <td class="col2">
                  <b>Similar&#160;Items:&#160;&#160;</b>
               </td>
               <td class="col3" colspan="2">
                  <script type="text/javascript">
                     getMoreLike_<xsl:value-of select="@rank"/> = function() {
                        var span = YAHOO.util.Dom.get('moreLike_<xsl:value-of select="@rank"/>');
                        span.innerHTML = "Fetching...";
                        YAHOO.util.Connect.asyncRequest('GET', 
                           '<xsl:value-of select="concat('search?smode=moreLike;docsPerPage=5;identifier=', $identifier)"/>',
                           { success: function(o) { span.innerHTML = o.responseText; },
                             failure: function(o) { span.innerHTML = "Failed!" } 
                           }, null);
                     };
                  </script>
                  <span id="moreLike_{@rank}">
                     <a href="javascript:getMoreLike_{@rank}()">Find</a>
                  </span>
               </td>
            </tr> 
         </table>
      </div>
      
         <!-- 
        <xsl:for-each select="current-group()[position() &lt; 5]">
        <div>
        <xsl:apply-templates select="docHit" mode="subDoc"/>
        </div>
        </xsl:for-each>
        
     --> 
   </xsl:template>
   
   <xsl:template name="subDocument">
      <xsl:variable name="chunk.id" select="@subDocument"/>         
      <xsl:variable name="level" select="meta/level"/>
      <xsl:variable name="path" select="@path"/>
      <xsl:variable name="identifier" select="meta/identifier[1]"/>
      <xsl:variable name="quotedID" select="concat('&quot;', $identifier, '&quot;')"/>
      <xsl:variable name="indexId" select="replace($identifier, '.*/', '')"/>
      <!-- 1/12/12 WS: Added docPath variable to enable scrolling to sub-document hits -->
      <xsl:variable name="docPath">
         <xsl:variable name="uri">
            <xsl:call-template name="dynaxml.url">
               <xsl:with-param name="path" select="$path"/>
            </xsl:call-template>
         </xsl:variable>
         <xsl:choose>
            <xsl:when test="meta/seriesID">
               <xsl:variable name="seriesID" select="meta/seriesID"/>
               <xsl:value-of select="concat($uri,';chunk.id=',$seriesID,';doc.view=contents','#',$chunk.id)"/>
            </xsl:when>
            <xsl:when test="$chunk.id != ''">
               <xsl:value-of select="concat($uri,';chunk.id=',$chunk.id,';doc.view=contents')"/>
               <!-- Link used to get sub-document out of context               
                  <xsl:value-of select="concat($uri,';doc.view=contents',';chunk.id=',$chunk.id)"/> 
               -->
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$uri"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <!-- scrolling anchor -->
      <xsl:variable name="anchor">
         <xsl:choose>
            <xsl:when test="$sort = 'creator'">
               <xsl:value-of select="substring(string(meta/creator[1]), 1, 1)"/>
            </xsl:when>
            <xsl:when test="$sort = 'title'">
               <xsl:value-of select="substring(string(meta/title[1]), 1, 1)"/>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>
      <table style="width:100%;">
         <tr>
            <td class="col1">
               <xsl:choose>
                  <xsl:when test="$sort = ''">
                     <b><xsl:value-of select="@rank"/></b>
                  </xsl:when>
                  <xsl:otherwise>
                     <b><xsl:value-of select="@rank"/></b>
                     <xsl:text>&#160;</xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
            </td>
            <td class="col3" colspan="2">
               <a>
                  <xsl:attribute name="href">
                     <xsl:value-of select="$docPath"/>
                  </xsl:attribute>
                  <xsl:choose>
                     <xsl:when test="meta/title">
                        <xsl:choose>
                           <xsl:when test="count(meta/title) &gt; 1">
                              <xsl:apply-templates select="meta/title[2]"/>      
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:apply-templates select="meta/title[1]"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:when>
                     <xsl:when test="meta/subtitle">
                        <xsl:choose>
                           <xsl:when test="count(meta/subtitle) &gt; 1">
                              <xsl:apply-templates select="meta/subtitle[2]"/>      
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:apply-templates select="meta/subtitle[1]"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:when>
                     <xsl:otherwise>none</xsl:otherwise>
                  </xsl:choose>
               </a>
               <xsl:text>&#160;</xsl:text>
               <!--
               <xsl:variable name="type" select="meta/type"/>
                  <span class="typeIcon">
                  <img src="{$icon.path}i_{$type}.gif" class="typeIcon"/>
                  </span>
               -->
            </td>
            <td class="col4" style="text-align:center">
               <!-- Add/remove logic for the session bag (only if session tracking enabled) -->
               <span class="addToBag">
                  <xsl:if test="session:isEnabled()">
                     <xsl:choose>
                        <xsl:when test="$smode = 'showBag'">
                           <script type="text/javascript">
                              remove_<xsl:value-of select="@rank"/> = function() {
                                 var span = YAHOO.util.Dom.get('remove_<xsl:value-of select="@rank"/>');
                                 span.innerHTML = "Deleting...";
                                 YAHOO.util.Connect.asyncRequest('GET', 
                                    '<xsl:value-of select="concat($xtfURL, $crossqueryPath, '?smode=removeFromBag;identifier=', $identifier)"/>',
                                    {  success: function(o) { 
                                          var main = YAHOO.util.Dom.get('main_<xsl:value-of select="@rank"/>');
                                          main.parentNode.removeChild(main);
                                          --(YAHOO.util.Dom.get('itemCount').innerHTML);
                                       },
                                       failure: function(o) { span.innerHTML = 'Failed to delete!'; }
                                    }, null);
                              };
                           </script>
                           <span id="remove_{@rank}">
                              <a href="javascript:remove_{@rank}()">Delete</a>
                           </span>
                        </xsl:when>
                        <xsl:when test="session:noCookie()">
                           <span><a href="javascript:alert('To use the bag, you must enable cookies in your web browser.')">Requires cookie*</a></span>                                 
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:choose>
                              <xsl:when test="session:getData('bag')/bag/savedDoc[@id=$indexId]">
                                 <img src="/xtf/icons/default/addbag.gif" alt="Added to bookbag" title="Added to bookbag"/><br/>
                                    <span class="caption">Added</span>
                              </xsl:when>
                              <xsl:otherwise>
                                 <script type="text/javascript">
                                    add_<xsl:value-of select="@rank"/> = function() {
                                       var span = YAHOO.util.Dom.get('add_<xsl:value-of select="@rank"/>');
                                       span.innerHTML = "Adding...";
                                       YAHOO.util.Connect.asyncRequest('GET', 
                                          '<xsl:value-of select="concat($xtfURL, $crossqueryPath, '?smode=addToBag;identifier=', $identifier)"/>',
                                          {  success: function(o) { 
                                                span.innerHTML = o.responseText;
                                                ++(YAHOO.util.Dom.get('bagCount').innerHTML);
                                             },
                                             failure: function(o) { span.innerHTML = 'Failed to add!'; }
                                          }, null);
                                    };
                                 </script>
                                 <a href="javascript:add_{@rank}()"><img src="/xtf/icons/default/addbag.gif" alt="Added to bookbag" title="Added to bookbag"/></a><br/>
                                 <span id="add_{@rank}" class="caption">
                                    <a href="javascript:add_{@rank}()">Add</a>
                                 </span>
                              </xsl:otherwise>
                           </xsl:choose>
                           <xsl:value-of select="session:setData('queryURL', concat($xtfURL, $crossqueryPath, '?', $queryString))"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:if>
               </span>
            </td>
         </tr> 
         <!-- 1/26/12 WS: Added descendant-or-self to catch deeply nested matches -->
         <xsl:if test="descendant-or-self::snippet">
            <tr style="font-size:.95em;">
               <td class="col1">
                  <xsl:text>&#160;</xsl:text>
               </td>
               <td class="col3" colspan="3">
                  <b>Matches:&#160;&#160;</b>
                  (<xsl:value-of select="@totalHits"/>
                  <xsl:value-of select="if (@totalHits = 1) then ' hit' else ' hits'"/>)&#160;&#160;&#160;&#160;
                  <xsl:apply-templates select="descendant-or-self::snippet" mode="text"/>
               </td>
            </tr>
         </xsl:if>         
      </table>
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- Snippet Template (for snippets in the full text)                       -->
   <!-- ====================================================================== -->
   
   <xsl:template match="snippet" mode="text" exclude-result-prefixes="#all">
      <xsl:text>...</xsl:text>
      <xsl:apply-templates mode="text"/>
      <xsl:text>...</xsl:text>
      <br/>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Term Template (for snippets in the full text)                          -->
   <!-- ====================================================================== -->
   
   <xsl:template match="term" mode="text" exclude-result-prefixes="#all">
      <xsl:variable name="path" select="ancestor::docHit/@path"/>
      <xsl:variable name="display" select="ancestor::docHit/meta/display[1]"/>
      <xsl:variable name="hit.rank"><xsl:value-of select="ancestor::snippet/@rank"/></xsl:variable>
      <xsl:variable name="snippet.link">    
         <xsl:call-template name="dynaxml.url">
            <xsl:with-param name="path" select="$path"/>
         </xsl:call-template>
         <xsl:value-of select="concat(';hit.rank=', $hit.rank)"/>
      </xsl:variable>
      
      <xsl:choose>
         <xsl:when test="ancestor::query"/>
         <xsl:when test="not(ancestor::snippet) or not(matches($display, 'dynaxml'))">
            <span class="hit"><xsl:apply-templates/></span>
         </xsl:when>
         <xsl:otherwise>
            <a href="{$snippet.link}" class="hit"><xsl:apply-templates/></a>
         </xsl:otherwise>
      </xsl:choose> 
      
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Term Template (for snippets in meta-data fields)                       -->
   <!-- ====================================================================== -->
   
   <xsl:template match="term" exclude-result-prefixes="#all">
      <xsl:choose>
         <xsl:when test="ancestor::query"/>
         <xsl:otherwise>
            <span class="hit"><xsl:apply-templates/></span>
         </xsl:otherwise>
      </xsl:choose> 
      
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- More Like This Template                                                -->
   <!-- ====================================================================== -->
   
   <!-- results -->
   <xsl:template match="crossQueryResult" mode="moreLike" exclude-result-prefixes="#all">
      <xsl:choose>
         <xsl:when test="docHit">
            <div class="moreLike">
               <ol>
                  <xsl:apply-templates select="docHit" mode="moreLike"/>
               </ol>
            </div>
         </xsl:when>
         <xsl:otherwise>
            <div class="moreLike">
               <b>No similar documents found.</b>
            </div>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- docHit -->
   <xsl:template match="docHit" mode="moreLike" exclude-result-prefixes="#all">
      
      <xsl:variable name="path" select="@path"/>
      
      <li>
         <xsl:apply-templates select="meta/creator[1]"/>
         <xsl:text>. </xsl:text>
         <a>
            <xsl:attribute name="href">
               <xsl:choose>
                  <xsl:when test="matches(meta/display[1], 'dynaxml')">
                     <xsl:call-template name="dynaxml.url">
                        <xsl:with-param name="path" select="$path"/>
                     </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:call-template name="rawDisplay.url">
                        <xsl:with-param name="path" select="$path"/>
                     </xsl:call-template>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="meta/title[1]"/>
         </a>
         <xsl:text>. </xsl:text>
         <!-- 12/1/11 WS for RAC: changed from meta/year[1] to meta/date[1] -->
         <xsl:apply-templates select="meta/date[1]"/>
         <xsl:text>. </xsl:text>
      </li>
      
   </xsl:template>
   
</xsl:stylesheet>
>>>>>>> result formatter update
