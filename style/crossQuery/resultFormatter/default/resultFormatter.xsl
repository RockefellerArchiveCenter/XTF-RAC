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
   <xsl:param name="level"/>   

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
         <xsl:when test="$browse-title or $browse-creator or $browse-geogname or $browse-subject or $browse-subjectname or $browse-updated">
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
            <title>DIMES: Search Results</title>
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
            <div id="header">
               <a href="/xtf/search">
                  <h1>dimes.rockarch.org</h1>
                  <p class="tagline">The Online Collections and Catalog of Rockefeller Archive
                     Center</p>
               </a>
            </div>
            <div id="bookbag">
               <xsl:if test="$smode != 'showBag'">
                  <xsl:variable name="bag" select="session:getData('bag')"/>
                  <a href="{$xtfURL}{$crossqueryPath}?smode=showBag"
                     onClick="_gaq.push(['_trackEvent', 'interaction', 'view', 'bookbag']);">
                     <img src="/xtf/icons/default/bookbag.gif" alt="Bookbag"
                        style="vertical-align:bottom;"/>
                  </a>
                  <span>(<span id="bagCount"><xsl:value-of select="count($bag/bag/savedDoc)"
                        /></span>)</span>
               </xsl:if>
            </div>
            <!--<table class="searchNav">
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
                        <a href="search?smode=browse">
                           <xsl:text>BROWSE</xsl:text>
                        </a>
                     </div>
                  </td>
               </tr>
            </table>-->
            
            <div class="resultsHeader">
               <form method="get" action="{$xtfURL}{$crossqueryPath}">

                  <xsl:if test="$smode='showBag'">
                     <h2>Your Bookbag: <xsl:variable name="items" select="@totalDocs"/>
                        <xsl:choose>
                           <xsl:when test="$items = 1"><span id="bookbagCount">1</span>
                              <xsl:text> Item</xsl:text>
                              <!--<div class="ra-query"><xsl:call-template name="format-query"/></div>-->
                           </xsl:when>
                           <xsl:otherwise>
                              <span id="bookbagCount"><xsl:value-of select="$items"/></span>
                              <xsl:text> Items</xsl:text>
                              <!--<div class="ra-query"><xsl:call-template name="format-query"/></div>-->
                           </xsl:otherwise>
                        </xsl:choose></h2>
                     
                     <div class="actions">
                        <xsl:variable name="bag" select="session:getData('bag')"/>
                        <xsl:variable name="bagCount" select="count($bag/bag/savedDoc)"/>
                        <a href="javascript://"
                           onclick="javascript:window.open('{$xtfURL}{$crossqueryPath}?smode=getAddress;docsPerPage={$bagCount}','popup','width=650,height=400,resizable=no,scrollbars=no')"
                           onClick="_gaq.push(['_trackEvent', 'interaction', 'view', 'bookbag email preview']);"
                           >E-mail My Bookbag</a>
                        
                        <xsl:text> | </xsl:text>
                     
                     <!-- 3/26/12 WS: Added template to clear all items from bookbag -->
                     <script type="text/javascript">
                              removeAll = function() {
                                 var span = YAHOO.util.Dom.get('removeAll');
                                 var bbCount = YAHOO.util.Dom.get('bookbagCount');
                                 span.innerHTML = "Deleting...";
                                 YAHOO.util.Connect.asyncRequest('GET', 
                                    '<xsl:value-of select="concat($xtfURL, $crossqueryPath, '?smode=removeAllFromBag')"/>',
                                    {  success: function(o) { document.location.reload();},
                                       failure: function(o) { span.innerHTML = 'Failed to delete!'; }
                                    }, null);
                              };
                           </script>
                        <a id="removeAll" href="javascript:removeAll()">Remove All Items</a>        
                     </div>
                  </xsl:if>
                  
                  <xsl:if test="$smode != 'showBag'">
                     <div id="searchForm">
                     <div id="searchTop">
                        <div id="searchtip" class="box">
                           <ul>
                              <li>Want help? See these <a href="#searchTips" class="searchTips"
                                    onClick="_gaq.push(['_trackEvent', 'about', 'view', 'search tips on keyword search page']);"
                                    >search tips</a>. </li>
                           </ul>
                        </div>
                        <div id="searchbox">
                           <input class="searchbox" type="text" name="keyword" value="{$text}"/>
                           <div id="advancedSearch">
                              <div id="boolean">
                                 <xsl:choose>
                                    <xsl:when test="$text-join = 'or'">
                                       <input type="radio" name="text-join" value=""/>
                                       <xsl:text> all of </xsl:text>
                                       <input type="radio" name="text-join" value="or"
                                          checked="checked"/>
                                       <xsl:text> any of </xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <input type="radio" name="text-join" value=""
                                          checked="checked"/>
                                       <xsl:text> all of </xsl:text>
                                       <input type="radio" name="text-join" value="or"/>
                                       <xsl:text> any of </xsl:text>
                                    </xsl:otherwise>
                                 </xsl:choose>
                                 <xsl:text>these words</xsl:text>
                              </div>
                              <div id="materialType">
                                 <xsl:text>Type of materials: </xsl:text>
                                 <select name="type" id="type">
                                    <option value="">All Materials</option>
                                    <option value="ead">Archival Collections</option>
                                    <option value="dao">Digital Materials</option>
                                    <option value="mods">Library Materials</option>
                                 </select>
                                 <!-- 6/21/2013 HA: adding advanced search to home page -->
                                 <!--<select name="sectionType" id="library">
                           <option value="">All Library Materials</option>
                           <option value="title">Title</option>
                           <option value="creator">Author</option>
                           <option value="callNumber">Call Number</option>
                           <option value="isbn">ISBN/ISSN</option>
                           <option value="lccn">LCCN</option>
                        </select>
                        <select name="sectionType" id="collections">
                           <option value="">All Archival Collections</option>
                           <option value="title">Title</option>
                           <option value="creator">Creator</option>
                           <option value="bioghist">Biographical or Historical Note</option>
                           <option value="scopecontent">Scope and Content Note</option>
                           <option value="file">Folder Title</option>
                           <option value="item">Item</option>
                           <option value="series">Series Description</option>
                           <option value="subseries">Subseries Description</option>
                           <option value="controlaccess">Subject Headings</option>
                        </select>
                        <select name="sectionType" id="dao">
                           <option value="">All Digital Materials</option>
                           <option value="title">Title</option>
                           <option value="creator">Creator</option>
                           <option value="bioghist">Biographical or Historical Note</option>
                           <option value="scopecontent">Scope and Content Note</option>
                           <option value="file">Folder Title</option>
                           <option value="item">Item</option>
                           <option value="series">Series Description</option>
                           <option value="subseries">Subseries Description</option>
                           <option value="controlaccess">Subject Headings</option>
                        </select>-->
                              </div>
                              <div id="date">
                                 <xsl:text>Years: </xsl:text>
                                 <input class="date" type="text" name="year" size="20"
                                    value="{$year}"/>
                                 <div id="searchtipDate" class="box">
                                    <ul>
                                       <li>Enter a single year or range of years, for example 1997
                                          or 1892-1942.</li>
                                    </ul>
                                 </div>
                              </div>
                              <!--<input type="hidden" name="smode" value="advanced" id="start"/>-->
                              <div class="showAdvanced open">
                                 <a href="#">close</a>
                              </div>
                           </div>
                           <input class="searchbox" type="submit" value="Search"/>
                           <!--<input type="hidden" value="series" name="level"/>-->
                           <!-- 6/30/2013 HA: removing clear button <input type="reset" onclick="location.href='{$xtfURL}{$crossqueryPath}'" value="Clear"/> -->
                           <!-- Uncomment and complete code when digital objects are included -->
                           <!--    <input type="checkbox" id="dao"/> Search only digitized material-->
                           <a href="#" class="showAdvanced closed">show more search options</a>
                        </div>
                     </div>
                     <!--<div id="browse">
                     <div class="dropdownButton">
                        <h3>Browse</h3></div>
                        <div class="dropdownContent">
                           <ul>
                              <li><a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=ead">Archival Collections</a></li>
                              <li><a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=mods">Library Materials</a></li>
                              <li><a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=dao">Digital Materials</a></li>
                           </ul>
                        </div>
                  </div> -->
                  </div>
                  </xsl:if>

                  <div id="pages">
                     <xsl:call-template name="pages"/>
                  </div>
               </form>
            </div>
            
            <!-- results -->
            <div class="results">
               <xsl:if test="//spelling">
                  <div class="spelling">
                     <xsl:call-template name="did-you-mean">
                        <xsl:with-param name="baseURL"
                           select="concat($xtfURL, $crossqueryPath, '?', $queryString)"/>
                        <xsl:with-param name="spelling" select="//spelling"/>
                     </xsl:call-template>
                  </div>
               </xsl:if>

               <xsl:choose>
                  <xsl:when test="docHit">
                     <xsl:if test="not($smode='showBag')">
                        <div class="facets">
                           <div id="facets">
                              <!-- 3/26/12 WS: Added some if statements to only show facets if facet data is available -->
                              <xsl:if
                                 test="facet[@field='facet-subject']/child::* or facet[@field='facet-subjectname']/child::* or facet[@field='facet-geogname']/child::*">
                                 <h2>Filter Search Results</h2>
                                 <xsl:if test="facet[@field='facet-subject']/child::*">
                                    <xsl:apply-templates select="facet[@field='facet-subject']"/>
                                 </xsl:if>
                                 <xsl:if test="facet[@field='facet-subjectname']/child::*">
                                    <xsl:apply-templates select="facet[@field='facet-subjectname']"
                                    />
                                 </xsl:if>
                                 <xsl:if test="facet[@field='facet-geogname']/child::*">
                                    <xsl:apply-templates select="facet[@field='facet-geogname']"/>
                                 </xsl:if>
                                 <xsl:apply-templates select="facet[@field='facet-format']"/>
                                 <!-- 10/31/12 WS: Commented out date facet 
                                       <xsl:apply-templates select="facet[@field='facet-date']"/>
                                    -->
                              </xsl:if>
                           </div>
                           <div class="browse">
                              <h2>Browse</h2>
                              <div class="accordionButton category"><h3><img src="/xtf/icons/default/collections.gif" alt="archival collections" height="25px"/>Archival Collections</h3></div>
                              <div class="accordionContent">
                                 <li class="browseOption"><a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=ead">Browse All</a></li>
                                 <li class="browseOption"><a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title&amp;browse-all=yes;level=collection;type=ead">By Title</a></li>
                                 <li class="browseOption"><a href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=title&amp;browse-all=yes;level=collection;type=ead">By Creator</a></li>
                              </div>
                              <div class="accordionButton category"><h3><img src="/xtf/icons/default/book.gif" alt="library materials" height="25px"/>Library Materials</h3></div>
                              <div class="accordionContent">
                                 <li class="browseOption"><a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=mods">Browse All</a></li>
                                 <li class="browseOption"><a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title&amp;browse-all=yes;level=collection;type=mods">By Title</a></li>
                                 <li class="browseOption"><a href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=title&amp;browse-all=yes;level=collection;type=mods">By Creator</a></li>
                              </div>
                              <div class="accordionButton category"><h3><img src="/xtf/icons/default/dao_large.gif" alt="digital materials" height="25px"/>Digital Materials</h3></div>
                              <div class="accordionContent">
                                 <li class="browseOption"><a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=dao">Browse All</a></li>
                                 <li class="browseOption"><a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title&amp;browse-all=yes;level=collection;type=dao">By Title</a></li>
                                 <li class="browseOption"><a href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=title&amp;browse-all=yes;level=collection;type=dao">By Creator</a></li>
                              </div>
                           </div>
                        </div>
                        <div id="docHits">
                           <div id="results">
                              <div id="rss">
                                 <xsl:if test="docHit">
                                    <xsl:variable name="cleanString"
                                       select="replace(replace($queryString,';*smode=docHits',''),'^;','')"/>
                                    <a href="search?{$cleanString};rmode=rss;sort=rss">
                                       <img src="{$icon.path}/i_rss.png" alt="rss icon"
                                          style="vertical-align:bottom;"/>
                                    </a>
                                 </xsl:if>
                              </div>
                              <div id="hits">
                                 <xsl:variable name="items" select="@totalDocs"/>
                                 <xsl:choose>
                                    <xsl:when test="$type='ead' or $type = 'mods' or $type = 'dao'">
                                       <span id="itemCount">
                                          <xsl:value-of select="$items"/>
                                       </span>
                                       <xsl:text> Result</xsl:text>
                                       <xsl:if test="$items &gt; 1">s</xsl:if>
                                       <xsl:value-of
                                          select="if($smode='showBag') then ':' else ' for '"/>
                                       <div class="ra-query">
                                          <xsl:call-template name="currentBrowse"/>
                                       </div>
                                    </xsl:when>
                                    <xsl:when test="$items = 1">
                                       <span id="itemCount">1</span>
                                       <xsl:text> Result</xsl:text>
                                       <xsl:value-of
                                          select="if($smode='showBag') then ':' else ' for '"/>
                                       <div class="ra-query">
                                          <xsl:call-template name="format-query"/>
                                       </div>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <span id="itemCount">
                                          <xsl:value-of select="$items"/>
                                       </span>
                                       <xsl:text> Results</xsl:text>
                                       <xsl:value-of
                                          select="if($smode='showBag') then ':' else ' for '"/>
                                       <div class="ra-query">
                                          <xsl:call-template name="format-query"/>
                                       </div>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </div>
                              <div id="sort">
                                 <form method="get" action="{$xtfURL}{$crossqueryPath}"> Sorted by:
                                       <xsl:call-template name="sort.options"/>
                                    <xsl:call-template name="hidden.query">
                                       <xsl:with-param name="queryString"
                                          select="editURL:remove($queryString, 'sort')"/>
                                    </xsl:call-template>
                                    <xsl:text>&#160;</xsl:text>
                                    <input type="submit" value="Go!"/>
                                 </form>
                              </div>
                           </div>

                           <xsl:for-each-group select="docHit" group-by="@path">
                              <xsl:call-template name="docHitColl"/>
                           </xsl:for-each-group>
                        </div>
                     </xsl:if>

                     <xsl:if test="($smode='showBag')">
                        <xsl:for-each-group select="docHit" group-by="@path">
                           <xsl:call-template name="docHitColl"/>
                        </xsl:for-each-group>
                     </xsl:if>

                     <xsl:if test="@totalDocs > $docsPerPage">
                        <div class="pages">
                           <xsl:call-template name="pages"/>
                        </div>
                     </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:choose>
                        <xsl:when test="$smode = 'showBag'">
                           <div class="empty">Your Bookbag is empty! Click on the icon that looks like this <img alt="bookbag icon" src="/xtf/icons/default/addbag.gif"/> next to one or more items in your <a
                                 href="{session:getData('queryURL')}">Search Results</a> to add it to your bookbag.</div>
                        </xsl:when>
                        <xsl:otherwise>
                           <div class="nohits">Oops, I couldn't find anything! Do you want to try <a
                                 href="{$xtfURL}{$crossqueryPath}">another search</a>?</div>
                           <!--<div class="forms">
                                       <xsl:choose>
                                          <xsl:when test="matches($smode,'advanced')">
                                             <xsl:call-template name="advancedForm"/>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <xsl:call-template name="simpleForm"/>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </div>-->
                        </xsl:otherwise>
                     </xsl:choose>

                  </xsl:otherwise>
               </xsl:choose>
            </div>
            
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
      <xsl:variable name="bookbagContents" select="session:getData('bag')/bag"/>
      <html xml:lang="en" lang="en">
         <head>
            <title>E-mail My Bookbag: Get Address</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:copy-of select="$brand.links"/>
         </head>
         <body>
            <div class="getAddress" style="margin:.5em;">
               <h2>E-mail My Bookbag</h2>
              <xsl:variable name="bagCount" select="count($bookbagContents//savedDoc)"/>
<!--               <p><xsl:value-of select="$bagCount"/> items in your bookbag</p>-->
               <form action="{$xtfURL}{$crossqueryPath}" method="get">
                  <table style="width: 200px;border:0;">
                     <tr>
                        <td>Address:</td>
                        <td><input type="text" name="email"/></td>
                     </tr>
                     <tr>
                        <td>Subject:</td>
                        <td><input type="text" name="subject"/></td>
                     </tr>
                     <tr>

                        <td colspan="2" style="text-align:right;">
                           <input type="reset" value="CLEAR"/>
                           <xsl:text>&#160;</xsl:text>
                           <input type="submit" value="SUBMIT" onClick="_gaq.push(['_trackEvent', 'interaction', 'send', 'bookbag']);"/>
                           <input type="hidden" name="smode" value="emailFolder"/>
                           <input type="hidden" name="docsPerPage" value="{$bagCount}"/>
                        </td>
                     </tr>
                  </table>
               </form>
               <div style="margin:2em;">
                  <a  onclick="showHide('preview');return false;" class="showLink" id="preview-show" href="#">+ Show preview</a>
                  <div id="preview" class="more" style=" width: 550px; height: 450px; overflow-y: scroll; display:none; border:1px solid #ccc; margin:.5em; padding: .5em; word-wrap: break-word;">
                   <xsl:call-template name="savedDoc"/>  
<!--                     <xsl:apply-templates select="$bookbagContents/savedDoc" mode="emailFolder"/>-->
                  </div>
               </div>
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
         smtpHost="" 
         useSSL="no" 
         from="archive@rockarch.org"
         to="{$email}" 
         subject="{$subject}">
         <xsl:call-template name="savedDoc"/>
<!--                  <xsl:apply-templates select="$bookbagContents/savedDoc" mode="emailFolder"/>-->
      </mail:send>
      
      <html xml:lang="en" lang="en">
         <head>
            <title>E-mail My Citations: Success</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:copy-of select="$brand.links"/>
         </head>
         <body>
            <div class="getAddress" style="margin:.5em;">
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
            </div>
         </body>
      </html>
      
   </xsl:template>
   
   <!-- 
      <xsl:for-each-group select="$bookbagContents/savedDoc" group-by="@id">
      <xsl:for-each select="current-group()">
   -->
   <xsl:template name="savedDoc">
      <xsl:for-each select="$docHits">
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
            <xsl:when test="starts-with($uri,'view')">
               <xsl:value-of select="concat($xtfURL,$uri)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$uri"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <!-- Need to add choose statement to get correct url when subdocument -->
      <xsl:variable name="url">
         <xsl:value-of select="$docPath"/>
      </xsl:variable>
      <xsl:variable name="level">
         <xsl:choose>
            <xsl:when test="meta/level = 'collection'">Collection</xsl:when>
            <xsl:when test="meta/level = 'series'">Series</xsl:when>
            <xsl:when test="meta/level = 'subseries'">Subseries</xsl:when>
            <xsl:when test="meta/level = 'recordgrp'">Record Group</xsl:when>
            <xsl:when test="meta/level = 'subgrp'">Subgroup</xsl:when>
            <xsl:when test="meta/level = 'fonds'">Fonds</xsl:when>
            <xsl:when test="meta/level = 'subfonds'">Subfonds</xsl:when>
            <xsl:when test="meta/level = 'class'">Class</xsl:when>
            <xsl:when test="meta/level = 'otherlevel'">otherlevel</xsl:when>
            <xsl:when test="meta/level = 'file'">File</xsl:when>
            <xsl:when test="meta/level = 'item'">Item</xsl:when>
         </xsl:choose>   
      </xsl:variable>
      <!-- 1/30/13 WS: bookbag modifications -->          
      <xsl:choose>
         <xsl:when test="meta/type='mods'">
            <pre>
                  <xsl:text>&#xA;</xsl:text>Title: <xsl:value-of select="normalize-space(meta/title)"/>
                  <xsl:text>&#xA;</xsl:text>Creator: <xsl:value-of select="meta/creator"/>
                  <xsl:if test="meta/date"><xsl:text>&#xA;</xsl:text>Date:  <xsl:value-of select="meta/date"/></xsl:if>
                  <xsl:if test="meta/callNo"><xsl:text>&#xA;</xsl:text>Call Number:  <xsl:value-of select="meta/callNo"/></xsl:if>
                  <xsl:text>&#xA;</xsl:text>URL: <xsl:value-of select="$url"/>
                  <xsl:text>&#xA;</xsl:text>  <xsl:text>&#xA;</xsl:text>
                </pre>            
         </xsl:when>
         <xsl:otherwise>
            <pre>
                  <xsl:text>&#xA;</xsl:text>
                  <xsl:if test="meta/format = 'Collection'">
                     <xsl:for-each select="meta/parent">
                        <xsl:value-of select="."/><xsl:text>&#xA;</xsl:text>
                     </xsl:for-each>
                  </xsl:if>
                  <xsl:if test="meta/level"></xsl:if><xsl:value-of select="normalize-space(meta/title)"/> 
                  <xsl:if test="meta/date"><xsl:text>&#xA;</xsl:text>Date:  <xsl:value-of select="meta/date"/></xsl:if>
                  <xsl:text>&#xA;</xsl:text>URL: <xsl:value-of select="$url"/>
                  <xsl:text>&#xA;</xsl:text>  
                  <xsl:text>&#xA;</xsl:text>
                </pre>            
         </xsl:otherwise>
      </xsl:choose>
      </xsl:for-each>
   </xsl:template>
   
   <xsl:template match="savedDoc" mode="emailFolder" exclude-result-prefixes="#all">
      <xsl:variable name="num" select="position()"/>
      <xsl:variable name="id" select="@id"/>
      <xsl:for-each select="$docHits[string(meta/identifier[1]) = $id]">
<!--         <xsl:sort select="meta/collectionTitle"/>-->
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
               <xsl:when test="starts-with($uri,'view')">
                  <xsl:value-of select="concat($xtfURL,$uri)"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="$uri"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <!-- Need to add choose statement to get correct url when subdocument -->
         <xsl:variable name="url">
            <xsl:value-of select="$docPath"/>
         </xsl:variable>
         <xsl:variable name="level">
            <xsl:choose>
               <xsl:when test="meta/level = 'collection'">Collection</xsl:when>
               <xsl:when test="meta/level = 'series'">Series</xsl:when>
               <xsl:when test="meta/level = 'subseries'">Subseries</xsl:when>
               <xsl:when test="meta/level = 'recordgrp'">Record Group</xsl:when>
               <xsl:when test="meta/level = 'subgrp'">Subgroup</xsl:when>
               <xsl:when test="meta/level = 'fonds'">Fonds</xsl:when>
               <xsl:when test="meta/level = 'subfonds'">Subfonds</xsl:when>
               <xsl:when test="meta/level = 'class'">Class</xsl:when>
               <xsl:when test="meta/level = 'otherlevel'">otherlevel</xsl:when>
               <xsl:when test="meta/level = 'file'">File</xsl:when>
               <xsl:when test="meta/level = 'item'">Item</xsl:when>
            </xsl:choose>   
         </xsl:variable>
         <!-- 1/30/13 WS: bookbag modifications -->          
         <xsl:choose>
            <xsl:when test="meta/type='mods'">
               <pre>
                  <xsl:text>&#xA;</xsl:text>Title: <xsl:value-of select="normalize-space(meta/title)"/>
                  <xsl:text>&#xA;</xsl:text>Creator: <xsl:value-of select="meta/creator"/>
                  <xsl:if test="meta/date"><xsl:text>&#xA;</xsl:text>Date:  <xsl:value-of select="meta/date"/></xsl:if>
                  <xsl:if test="meta/callNo"><xsl:text>&#xA;</xsl:text>Call Number:  <xsl:value-of select="meta/callNo"/></xsl:if>
                  <xsl:text>&#xA;</xsl:text>URL: <xsl:value-of select="$url"/>
                  <xsl:text>&#xA;</xsl:text>  <xsl:text>&#xA;</xsl:text>
                </pre>            
            </xsl:when>
            <xsl:otherwise>
               <pre>
                  <xsl:text>&#xA;</xsl:text>
                  <xsl:if test="meta/format = 'Collection'">
                     <xsl:for-each select="meta/parent">
                        <xsl:value-of select="."/><xsl:text>&#xA;</xsl:text>
                     </xsl:for-each>
                  </xsl:if>
                  <xsl:if test="meta/level"></xsl:if><xsl:value-of select="normalize-space(meta/title)"/> 
                  <xsl:if test="meta/date"><xsl:text>&#xA;</xsl:text>Date:  <xsl:value-of select="meta/date"/></xsl:if>
                  <xsl:text>&#xA;</xsl:text>URL: <xsl:value-of select="$url"/>
                  <xsl:text>&#xA;</xsl:text>  
                  <xsl:text>&#xA;</xsl:text>
                </pre>            
            </xsl:otherwise>
         </xsl:choose>
      </xsl:for-each>
   </xsl:template>
   
   
   
   <!-- ====================================================================== -->
   <!-- Browse Template                                                        -->
   <!-- ====================================================================== -->
   
   <xsl:template match="crossQueryResult" mode="browse" exclude-result-prefixes="#all">
      
      <xsl:variable name="alphaList" select="'A B C D E F G H I J K L M N O P Q R S T U V W Y Z OTHER'"/>
      
      <html xml:lang="en" lang="en">
         <head>
            <title>DIMES: Search Results</title>
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
            <div id="header">
               <a href="/xtf/search">
                  <h1>dimes.rockarch.org</h1>
                  <p class="tagline">The Online Collections and Catalog of Rockefeller Archive
                     Center</p>
               </a>
            </div>
            <div id="bookbag">
               <xsl:if test="$smode != 'showBag'">
                  <xsl:variable name="bag" select="session:getData('bag')"/>
                  <a href="{$xtfURL}{$crossqueryPath}?smode=showBag"
                     onClick="_gaq.push(['_trackEvent', 'interaction', 'view', 'bookbag']);">
                     <img src="/xtf/icons/default/bookbag.gif" alt="Bookbag"
                        style="vertical-align:bottom;"/>
                  </a>
                  <span>(<span id="bagCount"><xsl:value-of select="count($bag/bag/savedDoc)"
                  /></span>)</span>
               </xsl:if>
            </div>
               <!--<div class="searchNav">
                  <div>
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
                           <a href="search?browse-all=yes">
                              <xsl:text>BROWSE</xsl:text>
                              </a>
                           <a href="search?smode=browse">
                              <xsl:text>BROWSE</xsl:text>
                           </a>
                        </div>
                     </div>
               </div>-->
            <div class="resultsHeader">
               <div id="currentBrowse">
                  <strong>Browsing:&#160;</strong>
                  <xsl:call-template name="currentBrowse"/>
               </div>
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

               <!--<div class="right">
                  <xsl:variable name="bag" select="session:getData('bag')"/>
                  <div class="bookbag">
                     <a href="{$xtfURL}{$crossqueryPath}?smode=showBag"
                        onClick="_gaq.push(['_trackEvent', 'interaction', 'view', 'bookbag']);">
                        <img src="/xtf/icons/default/bookbag.gif" alt="Bookbag"
                           style="vertical-align:middle;"/>
                     </a>
                     <span>(<span id="bagCount"><xsl:value-of select="count($bag/bag/savedDoc)"
                           /></span>)</span>
                  </div>

                  <div>
                     <xsl:if test="$smode = 'showBag'">
                        <xsl:text>&#160;|&#160;</xsl:text>
                        <a href="{session:getData('queryURL')}">
                           <xsl:text>Return to Search Results</xsl:text>
                        </a>
                     </xsl:if>
                  </div>
               </div> -->
               
               <div id="alphaList">
                  <xsl:call-template name="alphaList">
                     <xsl:with-param name="alphaList" select="$alphaList"/>
                     <!--<xsl:with-param name="level" select="'collection'"/>-->
                  </xsl:call-template>
                  <!--<xsl:choose>
                     <xsl:when test="$browse-title"> &#160;| <a
                           href="{$xtfURL}{$crossqueryPath}?browse-all=yes;level=collection;sort=title"
                           >BROWSE ALL</a>
                     </xsl:when>
                     <xsl:when test="$browse-creator"> &#160;| <a
                           href="{$xtfURL}{$crossqueryPath}?browse-all=yes;level=collection;sort=creator"
                           >BROWSE ALL</a>
                     </xsl:when>
                  </xsl:choose>-->
               </div>
            </div>
            
            <!-- results -->
            <div class="results">
               <div class="facets">
                  <div class="browse">
                              <h2>Browse</h2>
                              <div class="accordionButton category"><h3><img src="/xtf/icons/default/collections.gif" alt="archival collections" height="25px"/>Archival Collections</h3></div>
                              <div class="accordionContent">
                                 <li class="browseOption"><a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=ead">Browse All</a></li>
                                 <li class="browseOption"><a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title&amp;browse-all=yes;level=collection;type=ead">By Title</a></li>
                                 <li class="browseOption"><a href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=title&amp;browse-all=yes;level=collection;type=ead">By Creator</a></li>
                              </div>
                              <div class="accordionButton category"><h3><img src="/xtf/icons/default/book.gif" alt="library materials" height="25px"/>Library Materials</h3></div>
                              <div class="accordionContent">
                                 <li class="browseOption"><a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=mods">Browse All</a></li>
                                 <li class="browseOption"><a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title&amp;browse-all=yes;level=collection;type=mods">By Title</a></li>
                                 <li class="browseOption"><a href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=title&amp;browse-all=yes;level=collection;type=mods">By Creator</a></li>
                              </div>
                              <div class="accordionButton category"><h3><img src="/xtf/icons/default/dao_large.gif" alt="digital materials" height="25px"/>Digital Materials</h3></div>
                              <div class="accordionContent">
                                 <li class="browseOption"><a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=dao">Browse All</a></li>
                                 <li class="browseOption"><a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title&amp;browse-all=yes;level=collection;type=dao">By Title</a></li>
                                 <li class="browseOption"><a href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=title&amp;browse-all=yes;level=collection;type=dao">By Creator</a></li>
                              </div>
                           </div>
                  
               </div>
               <div id="docHits">
               <xsl:choose>
                  <xsl:when test="$browse-title">
                     <xsl:apply-templates select="facet[@field='browse-title']/group/docHit"/>
                  </xsl:when>
                  <xsl:when test="$browse-creator">
                     <xsl:apply-templates select="facet[@field='browse-creator']/group/docHit"/>
                  </xsl:when>
                  <!-- 2/28/2013 HA: added browse option -->
                  <xsl:when test="$browse-updated">
                     <xsl:apply-templates select="facet[@field='browse-updated']/group/docHit"/>
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
               </div>
            </div>
            
            
            <!-- feedback and footer -->
            <xsl:copy-of select="$brand.feedback"/>
            <xsl:copy-of select="$brand.footer"/>
            
         </body>
      </html>
   </xsl:template>
   
   <xsl:template name="browseLinks">
      <div class="browselinks">
         <h3><a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection">Browse
            All</a></h3>
         <div class="boxLeft">
            <img class="categoryImage" src="/xtf/icons/default/collections.gif"
               alt="archival collections"/>
            <h4>Archival Collections</h4>
            <ul>
               <li>
                  <a
                     href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=ead"
                     >Browse All Archival Collections</a>
               </li>
               <li>
                  <a
                     href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title&amp;browse-all=yes;level=collection;type=ead"
                     >Collections by Title</a>
               </li>
               <li>
                  <a
                     href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=title&amp;browse-all=yes;level=collection;type=ead"
                     >Collections by Creator</a>
               </li>
               <li>
                  <a
                     href="{$xtfURL}{$crossqueryPath}?sort=dateStamp&amp;browse-all=yes;level=collection;type=ead"
                     >Recently Updated Collections</a>
               </li>
            </ul>
         </div>
         <div class="boxCenter">
            <img class="categoryImage" src="/xtf/icons/default/book.gif" alt="library materials"/>
            <h4>Library Materials</h4>
            <ul>
               <li>
                  <a
                     href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=mods"
                     >Browse All Library Materials</a>
               </li>
               <li>
                  <a
                     href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title&amp;browse-all=yes;level=collection;type=mods"
                     >Library Materials by Title</a>
               </li>
               <li>
                  <a
                     href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=title&amp;browse-all=yes;level=collection;type=mods"
                     >Library Materials by Creator</a>
               </li>
            </ul>
         </div>
         <div class="boxRight">
            <img class="categoryImage" src="/xtf/icons/default/dao_large.gif"
               alt="digital materials"/>
            <h4>Digital Materials</h4>
            <ul>
               <li>
                  <a
                     href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=dao"
                     >Browse All Digital Materials</a>
               </li>
               <li>
                  <a
                     href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title&amp;browse-all=yes;level=collection;type=dao"
                     >by Title</a>
               </li>
               <li>
                  <a
                     href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=title&amp;browse-all=yes;level=collection;type=dao"
                     >by Creator</a>
               </li>
            </ul>
         </div>
      </div>
   </xsl:template>
   
   <xsl:template name="currentBrowseLinks">
      <span class="currentBrowse">
            <a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection">All</a>
          |
            <a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=ead">
               <xsl:if test="$type='ead' and not($browse-title) and not($browse-creator) and not($browse-updated)">
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
               <xsl:when test="$browse-title">Archival Collections by Title</xsl:when>
               <xsl:when test="$browse-creator">Archival Collections by Creator</xsl:when>
               <xsl:otherwise>All Archival Collections</xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:when test="$type='mods'">
            <xsl:choose>
               <xsl:when test="$browse-title">Library Materials by Title</xsl:when>
               <xsl:when test="$browse-creator">Library Materials by Creator</xsl:when>
               <xsl:otherwise>All Library Materials</xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:when test="$type='dao'">
            <xsl:choose>
               <xsl:when test="$browse-title">Digital Materials by Title</xsl:when>
               <xsl:when test="$browse-creator">Digital Materials by Creator</xsl:when>
               <xsl:otherwise>All Digital Materials</xsl:otherwise>
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
         <!-- 7/10/2013 HA: turning results list into divs rather than table -->
            <!-- 9/26/11 WS: Moved title above Author -->
         <div class="hitRank">
            <xsl:choose>
               <xsl:when test="$sort = ''">
                  <b>
                     <xsl:value-of select="@rank"/>
                  </b>
               </xsl:when>
               <xsl:otherwise>
                  <b>
                     <xsl:value-of select="@rank"/>
                  </b>
                  <xsl:text>&#160;</xsl:text>
               </xsl:otherwise>
            </xsl:choose>
         </div>
         <div class="resultIcon">
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
         </div>
         <div class="resultContent">
            <div class="result">
               <div class="resultLabel">
                  <xsl:if test="$sort = 'title'">
                     <a name="{$anchor}"/>
                  </xsl:if>
                  <b>Title:&#160;&#160;</b>
               </div>
               <div class="resultText">
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
               </div>
            </div>

            <div class="result">
               <div class="resultLabel">
                  <xsl:if test="$sort = 'creator'">
                     <a name="{$anchor}"/>
                  </xsl:if>
                  <!-- 9/26/11 WS: changed author to creator-->
                  <b>Creator:&#160;&#160;</b>
               </div>
               <div class="resultText">
                  <xsl:choose>
                     <xsl:when test="meta/creator">
                        <xsl:apply-templates select="meta/creator[1]"/>
                     </xsl:when>
                     <xsl:otherwise>none</xsl:otherwise>
                  </xsl:choose>
               </div>
            </div>

            <div class="result">
               <div class="resultLabel">
                  <!-- 9/26/11 WS: changed Published to Date -->
                  <b>Date(s):&#160;&#160;</b>
               </div>
               <div class="resultText">
                  <!-- 9/27/11 WS: Changed date to always grab from meta/date -->
                  <xsl:choose>
                     <xsl:when test="meta/date">
                        <xsl:apply-templates select="meta/date"/>
                     </xsl:when>
                     <xsl:otherwise> unknown </xsl:otherwise>
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
               </div>
            </div>
            <xsl:if test="meta/subject">
               <div class="result">
                  <div class="resultLabel">
                     <b>Subjects:&#160;&#160;</b>
                  </div>
                  <div class="resultText">
                     <!-- 4/16/2013 HA: added logic to limit number of subjects that display -->
                     <xsl:for-each select="meta/subject">
                        <xsl:if test="position() = 1">
                           <xsl:apply-templates select="."/>
                        </xsl:if>
                        <xsl:if test="position() &gt;= 2 and position() &lt;= 4">
                           <xsl:text>&#160;|&#160;</xsl:text>
                           <xsl:apply-templates select="."/>
                        </xsl:if>
                     </xsl:for-each>
                     <xsl:if test="position() = 5">
                        <xsl:text>&#160;...more</xsl:text>
                     </xsl:if>
                  </div>
               </div>
            </xsl:if>
            <!-- 1/26/12 WS: Added descendant-or-self to catch deeply nested matches -->
            <xsl:choose>
               <xsl:when test="$browse-all"/>
               <xsl:otherwise>
                  <xsl:if test="descendant-or-self::snippet">

                     <div class="result">
                        <div class="resultLabel">
                           <b>Matches:&#160;&#160;</b>
                           <br/>
                           <xsl:value-of select="@totalHits"/>
                           <xsl:value-of select="if (@totalHits = 1) then ' hit' else ' hits'"
                           />&#160;&#160;&#160;&#160; </div>
                        <div class="resultText">
                           <xsl:apply-templates select="descendant-or-self::snippet" mode="text"/>
                        </div>
                     </div>
                  </xsl:if>
               </xsl:otherwise>
            </xsl:choose>

            <!-- "more like this" -->
            <div class="result">
               <div class="resultLabel">
                  <b>Similar&#160;Items:&#160;&#160;</b>
               </div>
               <div class="resultText">
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
               </div>
            </div>
         </div>

         <div class="bookbag">
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
                        <span>
                           <a
                              href="javascript:alert('To use the bag, you must enable cookies in your web browser.')"
                              >Requires cookie*</a>
                        </span>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:choose>
                           <xsl:when test="session:getData('bag')/bag/savedDoc[@id=$indexId]">
                              <img src="/xtf/icons/default/addbag.gif" alt="Added to bookbag"
                                 title="Added to bookbag"/>
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
                              <xsl:choose>
                                 <xsl:when test="meta/type = 'ead'">
                                    <a href="javascript:add_{@rank}()"
                                       onClick="_gaq.push(['_trackEvent', 'interaction', 'add-archival', 'bookbag']);">
                                       <img src="/xtf/icons/default/addbag.gif" alt="Add to bookbag"
                                          title="Add to bookbag"/>
                                    </a>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <a href="javascript:add_{@rank}()"
                                       onClick="_gaq.push(['_trackEvent', 'interaction', 'add-library', 'bookbag']);">
                                       <img src="/xtf/icons/default/addbag.gif" alt="Add to bookbag"
                                          title="Add to bookbag"/>
                                    </a>
                                 </xsl:otherwise>
                              </xsl:choose>
                              <span id="add_{@rank}" class="caption">
                                 <span class="caption">
                                    <a href="javascript:add_{@rank}()">Add</a>
                                 </span>
                              </span>
                           </xsl:otherwise>
                        </xsl:choose>
                        <xsl:value-of
                           select="session:setData('queryURL', concat($xtfURL, $crossqueryPath, '?', $queryString))"
                        />
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:if>
            </span>
         </div>
         
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
         <!-- 7/10/2013 HA: turning results list into divs rather than table -->
            <!-- Deals with collections vrs. series/files -->
            <xsl:choose>
               <xsl:when test="meta/level = 'collection'">
                     <div class="hitRank">
                        <xsl:choose>
                           <xsl:when test="$sort = ''">
                              <b><xsl:value-of select="@rank"/></b>
                           </xsl:when>
                           <xsl:otherwise>
                              <b><xsl:value-of select="@rank"/></b>
                              <xsl:text>&#160;</xsl:text>
                           </xsl:otherwise>
                        </xsl:choose>
                     </div>
                     <div class="resultIcon">
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
                     </div>
                  <div class="resultContent">
                     <div class="result">
                        <div class="resultLabel">
                        <xsl:if test="$sort = 'title'">
                           <a name="{$anchor}"/>
                        </xsl:if>
                        <b>Title:&#160;&#160;</b>
                     </div>
                     <div class="resultText">
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
                        <!--
                        <xsl:variable name="type" select="meta/type"/>
                           <span class="typeIcon">
                           <img src="{$icon.path}i_{$type}.gif" class="typeIcon"/>
                           </span>
                        -->
                     </div>
                     </div>

                     <div class="result">
                        <div class="resultLabel">
                        <xsl:if test="$sort = 'creator'">
                           <a name="{$anchor}"/>
                        </xsl:if>
                        <!-- 9/26/11 WS: changed author to creator-->
                        <b>Creator:&#160;&#160;</b>
                     </div>
                     <div class="resultText">
                        <xsl:choose>
                           <xsl:when test="meta/creator">
                              <xsl:apply-templates select="meta/creator[1]"/>
                           </xsl:when>
                           <xsl:otherwise>none</xsl:otherwise>
                        </xsl:choose>
                     </div>
                     </div>
                     
                        <div class="result">
                        <div class="resultLabel">
                           <b>Publisher:&#160;&#160;</b>
                        </div>
                        <div class="resultText">
                           <xsl:apply-templates select="meta/publisher"/>
                        </div>
                        </div>
                     
                     <div class="result">
                     <div class="resultLabel">
                        <!-- 9/26/11 WS: changed Published to Date -->
                        <b>Date(s):&#160;&#160;</b>
                     </div>
                     <div class="resultText">
                        <!-- 9/27/11 WS: Changed date to always grab from meta/date -->
                        <xsl:choose>
                           <xsl:when test="meta/date">
                              <xsl:apply-templates select="meta/date"/>      
                           </xsl:when>
                           <xsl:otherwise>
                              unknown
                           </xsl:otherwise>
                        </xsl:choose>
                     </div>
                     </div>


                     
                  <xsl:if test="meta/callNo">
                     <div class="result">
                        <div class="resultLabel">
                           <b>Call number:&#160;&#160;</b>
                        </div>
                        <div class="resultText">
                           <xsl:apply-templates select="meta/callNo"/>
                        </div>
                     </div>
                  </xsl:if>

                     
                <!-- 1/26/12 WS: Added descendant-or-self to catch deeply nested matches -->
                  <xsl:choose>
                     <xsl:when test="$browse-all"/>
                     <xsl:otherwise>
                        <xsl:if test="descendant-or-self::snippet">
                              <div class="result">
                                 <div class="resultLabel">
                                 <b>Matches:&#160;&#160;</b>
                                 <br/>
                                 <xsl:value-of select="@totalHits"/> 
                                 <xsl:value-of select="if (@totalHits = 1) then ' hit' else ' hits'"/>&#160;&#160;&#160;&#160;
                              </div>
                              <div class="resultText">
                                 <xsl:apply-templates select="descendant-or-self::snippet" mode="text"/>
                              </div>
                              </div>
                           
                        </xsl:if>
                     </xsl:otherwise>
                  </xsl:choose>
                     <xsl:if test="meta/subject">
                        <div class="result">
                           <div class="resultLabel">
                              <b>Subjects:&#160;&#160;</b>
                           </div>
                           <div class="resultText">
                              <!-- 4/16/2013 HA: added logic to limit number of subjects that display -->
                              <xsl:for-each select="meta/subject">
                                 <xsl:if test="position() = 1">
                                    <xsl:apply-templates select="."/>
                                 </xsl:if>
                                 <xsl:if test="position() &gt;= 2 and position() &lt;= 4">
                                    <xsl:text>&#160;|&#160;</xsl:text>
                                    <xsl:apply-templates select="."/>
                                 </xsl:if>
                                 <xsl:if test="position() = 5">
                                    <xsl:text>&#160;...more</xsl:text>
                                 </xsl:if>
                              </xsl:for-each>
                           </div>
                        </div>
                     </xsl:if>
                     <xsl:for-each select="current-group()[meta/level != 'collection']">
                        <!--            <xsl:for-each select="current-group()[position() &lt; 5][meta/level != 'collection']">-->
                        <div class="subdocument">
                           <xsl:call-template name="subDocument"/>
                        </div>
                     </xsl:for-each>
                     <!-- "more like this" -->
                     <div class="result">
                        <div class="resultLabel">
                           <b>Similar&#160;Items:&#160;&#160;</b>
                        </div>
                        <div class="resultText">
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
                        </div>
                     </div>
                  </div>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:variable name="collectionId" select="substring-before(meta/identifier[1],'|')"/>
                     <div class="hitRank">
                        <xsl:choose>
                           <xsl:when test="$sort = ''">
                              <b><xsl:value-of select="@rank"/></b>
                           </xsl:when>
                           <xsl:otherwise>
                              <b><xsl:value-of select="@rank"/></b>
                              <xsl:text>&#160;</xsl:text>
                           </xsl:otherwise>
                        </xsl:choose>
                     </div>
                     <div class="resultIcon">
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
                     </div>

               <div class="resultContent">
                  <div class="result">
                  <div class="resultLabel">
                     <xsl:if test="$sort = 'title'">
                        <a name="{$anchor}"/>
                     </xsl:if>
                     <b>Title:&#160;&#160;</b>
                  </div>
                  <div class="resultText">
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

                     <!--
                        <xsl:variable name="type" select="meta/type"/>
                           <span class="typeIcon">
                           <img src="{$icon.path}i_{$type}.gif" class="typeIcon"/>
                           </span>
                        -->
                  </div>
               </div>
                     
               <div class="result">
                  <div class="resultLabel">
                     <xsl:if test="$sort = 'creator'">
                        <a name="{$anchor}"/>
                     </xsl:if>
                     <!-- 9/26/11 WS: changed author to creator-->
                     <b>Creator:&#160;&#160;</b>
                  </div>
                  <div class="resultText">
                     <xsl:choose>
                        <xsl:when test="meta/collectionCreator">
                           <xsl:apply-templates select="meta/collectionCreator[1]"/>
                        </xsl:when>
                        <xsl:when test="meta/creator">
                           <xsl:apply-templates select="meta/creator[1]"/>
                        </xsl:when>
                        <xsl:otherwise>none</xsl:otherwise>
                     </xsl:choose>
                  </div>
               </div>
                  <xsl:if test="meta/subject">
                     <div class="result">
                        <div class="resultLabel">
                           <b>Subjects:&#160;&#160;</b>
                        </div>
                        <div class="resultText">
                           <!-- 4/16/2013 HA: added logic to limit number of subjects that display -->
                           <xsl:for-each select="meta/subject">
                              <xsl:if test="position() = 1">
                                 <xsl:apply-templates select="."/>
                              </xsl:if>
                              <xsl:if test="position() &gt;= 2 and position() &lt;= 4">
                                 <xsl:text>&#160;|&#160;</xsl:text>
                                 <xsl:apply-templates select="."/>
                              </xsl:if>
                              <xsl:if test="position() = 5">
                                 <xsl:text>&#160;...more</xsl:text>
                              </xsl:if>
                           </xsl:for-each>
                        </div>
                     </div>
                  </xsl:if>
                  <xsl:for-each select="current-group()[meta/level != 'collection']">
                     <!--            <xsl:for-each select="current-group()[position() &lt; 5][meta/level != 'collection']">-->
                     <div class="subdocument">
                        <xsl:call-template name="subDocument"/>
                     </div>
                  </xsl:for-each>
                  <!-- "more like this" -->
                  <div class="result">
                     <div class="resultLabel">
                        <b>Similar&#160;Items:&#160;&#160;</b>
                     </div>
                     <div class="resultText">
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
                     </div>
                  </div>
               </div>

               </xsl:otherwise>
            </xsl:choose>
         
      <div class="bookbag">
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
                     <span>
                        <a
                           href="javascript:alert('To use the bag, you must enable cookies in your web browser.')"
                           >Requires cookie*</a>
                     </span>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:choose>
                        <xsl:when
                           test="session:getData('bag')/bag/savedDoc[@id=$indexId]">
                           <img src="/xtf/icons/default/addbag.gif"
                              alt="Added to bookbag" title="Added to bookbag"/>
                           <br/>
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
                           <xsl:choose>
                              <xsl:when test="meta/type = 'ead'">
                                 <a href="javascript:add_{@rank}()"
                                    onClick="_gaq.push(['_trackEvent', 'interaction', 'add-archival', 'bookbag']);">
                                    <img src="/xtf/icons/default/addbag.gif"
                                       alt="Add to bookbag" title="Add to bookbag"/>
                                 </a>

                              </xsl:when>
                              <xsl:otherwise>
                                 <a href="javascript:add_{@rank}()"
                                    onClick="_gaq.push(['_trackEvent', 'interaction', 'add-library', 'bookbag']);">
                                    <img src="/xtf/icons/default/addbag.gif"
                                       alt="Add to bookbag" title="Add to bookbag"/>
                                 </a>

                              </xsl:otherwise>
                           </xsl:choose>

                           <span id="add_{@rank}" class="caption">
                              <a href="javascript:add_{@rank}()">Add</a>
                           </span>
                        </xsl:otherwise>
                     </xsl:choose>
                     <xsl:value-of
                        select="session:setData('queryURL', concat($xtfURL, $crossqueryPath, '?', $queryString))"
                     />
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:if>
         </span>
      </div>
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
      <div class="hitRank">
         <div style="height:18px; overflow:hidden;">
                  <xsl:if test="meta/type = 'dao'">
                     <img src="/xtf/icons/default/dao.gif" alt="digital object" title="digital object" style="float:right; padding-right:.75em;"/>
                  </xsl:if>
                  <xsl:choose>
                     <xsl:when test="$sort = ''">
                       <strong><xsl:value-of select="string(@rank)"/></strong>
                     </xsl:when>
                     <xsl:otherwise>
                       <strong><xsl:value-of select="string(@rank)"/></strong>&#160;
                     </xsl:otherwise>
                  </xsl:choose>
               </div>
            </div>
      <div class="title">
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
      </div>
            
      <div class="bookbag">
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
                     <span>
                        <a
                           href="javascript:alert('To use the bag, you must enable cookies in your web browser.')"
                           >Requires cookie*</a>
                     </span>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:choose>
                        <xsl:when test="session:getData('bag')/bag/savedDoc[@id=$indexId]">
                           <img src="/xtf/icons/default/addbag.gif" alt="Added to bookbag"
                              title="Added to bookbag"/>
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
                           <a href="javascript:add_{@rank}()">
                              <img src="/xtf/icons/default/addbag.gif" alt="Added to bookbag"
                                 title="Added to bookbag"/>
                           </a>
                           <span id="add_{@rank}" class="caption">
                              <a href="javascript:add_{@rank}()">Add</a>
                           </span>
                        </xsl:otherwise>
                     </xsl:choose>
                     <xsl:value-of
                        select="session:setData('queryURL', concat($xtfURL, $crossqueryPath, '?', $queryString))"
                     />
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:if>
         </span>
      </div>

         <!-- 1/26/12 WS: Added descendant-or-self to catch deeply nested matches -->
         <xsl:choose>
            <xsl:when test="$browse-all"/>
            <xsl:otherwise>
               <xsl:if test="descendant-or-self::snippet">
                     <div class="result">
                        <div class="resultLabel">
                        <b>Matches:&#160;&#160;</b>
                           <br/>
                        (<xsl:value-of select="@totalHits"/>
                           <xsl:value-of select="if (@totalHits = 1) then ' hit' else ' hits'"/>)&#160;&#160;
                        </div>
                        <div class="resultText">
                        <xsl:apply-templates select="descendant-or-self::snippet" mode="text"/>
                        </div>
                     </div>
               </xsl:if>
            </xsl:otherwise>
         </xsl:choose>    

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
