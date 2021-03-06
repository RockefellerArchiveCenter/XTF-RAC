<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:session="java:org.cdlib.xtf.xslt.Session" xmlns:editURL="http://cdlib.org/xtf/editURL" xmlns="http://www.w3.org/1999/xhtml"
   extension-element-prefixes="session" exclude-result-prefixes="#all" version="2.0">

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
   <xsl:include href="../../../myList/myListFormatter.xsl"/>
   <xsl:include href="../../../digital/digitalFormatter.xsl"/>

   <xsl:param name="browse-collections"/>
   <xsl:param name="type"/>
   <xsl:param name="level"/>

   <!-- ====================================================================== -->
   <!-- Output                                                                 -->
   <!-- ====================================================================== -->

   <xsl:output method="xhtml" indent="no" encoding="UTF-8" media-type="text/html; charset=UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" omit-xml-declaration="yes" exclude-result-prefixes="#all"/>

   <!-- ====================================================================== -->
   <!-- Local Parameters                                                       -->
   <!-- ====================================================================== -->

   <xsl:param name="css.path" select="concat($xtfURL, 'css/default/')"/>
   <xsl:param name="icon.path" select="concat($xtfURL, 'icons/default/')"/>
   <xsl:param name="docHits" select="/crossQueryResult/docHit"/>
   <xsl:param name="email"/>
   <xsl:param name="message"/>

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
         <!--<xsl:when test="$smode = 'addToBag'">
            <a href="#">Delete</a>
         </xsl:when>
         <xsl:when test="$smode = 'removeFromBag'">
            <a href="#">Add</a>
         </xsl:when>-->
         <!-- HA 11/6/2014 This template is no longer used -->
         <!--<xsl:when test="$smode='getAddress'">
            <xsl:call-template name="getAddress"/>
         </xsl:when> -->
         <!-- templates not in use -->
         <!--<xsl:when test="$smode='getLang'">
            <xsl:call-template name="getLang"/>
         </xsl:when>
         <xsl:when test="$smode='setLang'">
            <xsl:call-template name="setLang"/>
         </xsl:when>-->
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
         <!-- HA this template is no longer used -->
         <!--<xsl:when test="$smode = 'moreLike'">
            <xsl:call-template name="translate">
               <xsl:with-param name="resultTree">
                  <xsl:apply-templates select="crossQueryResult" mode="moreLike"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:when>-->
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
      <xsl:variable name="min">
         <xsl:value-of select="facet[@field='facet-date']/group[last()]/@value"/>
      </xsl:variable>
      <xsl:variable name="max">
         <xsl:value-of select="facet[@field='facet-date']/group[@rank='1']/@value"/>
      </xsl:variable>
      <xsl:variable name="sliderMin">
         <xsl:choose>
            <xsl:when test="parameters/param[@name = 'year']">
               <xsl:value-of select="parameters/param[@name='year']/@value"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$min"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="sliderMax">
         <xsl:choose>
            <xsl:when test="parameters/param[@name = 'year-max']">
               <xsl:value-of select="parameters/param[@name='year-max']/@value"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$max"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <html xml:lang="en" lang="en">
         <head>
            <title>DIMES: Search Results</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:copy-of select="$brand.links"/>
            <script src="script/rac/facets.js" type="text/javascript"/>
            <script src="script/rac/jquery.sparkline.min.js" type="text/javascript"/>
            <xsl:if test="($min | $max) != ''">
               <script>
               $(function() {
                  $( "#slider-range" ).slider({
                     range: true,
                     min: <xsl:value-of select="$min"/>,
                     max: <xsl:value-of select="$max"/>,
                     values: [ <xsl:value-of select="$sliderMin"/>,
                               <xsl:value-of select="$sliderMax"/> ],
                     slide: function( event, ui ) {
                       $( "#from" ).val( ui.values[ 0 ] );
                       $( "#to" ).val( ui.values[ 1 ] );
                     }
                });
               $( "#from" ).val($( "#slider-range" ).slider( "values", 0 ));
               $( "#to" ).val($( "#slider-range" ).slider( "values", 1 ));
               $( "#range" ).val($( "#slider-range" ).slider( "values", 0 ) + '-' + $( "#slider-range" ).slider( "values", 1 ));
               });
            </script>
            </xsl:if>
            <script type="text/javascript">
               $(function() {
                    var myvalues = [<xsl:for-each select="facet[@field='facet-date']/group">
                     <xsl:value-of select="@totalDocs"/><xsl:text>, </xsl:text>
                     </xsl:for-each>];
                  $('#histogram').sparkline(myvalues, {type: 'line', lineColor: '#c45414', fillColor: '#c45414', width:'94%', height:'20', disableTooltips:true, disableHighlight:true});
                  });
            </script>

         </head>
         <body>
            <!-- search tips -->
            <xsl:copy-of select="$brand.searchtips"/>

            <div typeof="SearchResultsPage">
               <!-- header -->
               <xsl:copy-of select="$brand.header"/>

               <!-- result header -->
               <!-- 9/27/11 WS:  Adjusted results header for a cleaner look-->
               <div id="header">
                  <a href="/xtf/search">
                     <img src="/xtf/css/default/images/rockefeller_archive_center_logo.png" height="140" alt="The Rockefeller Archive Center"/>
                     <h1>dimes.rockarch.org</h1>
                     <p class="tagline">The Online Collections and Catalog of Rockefeller Archive Center</p>
                  </a>
               </div>

               <xsl:call-template name="myListNav"/>

               <div class="resultsHeader">
                  <form id="searchResults" method="get" action="{$xtfURL}{$crossqueryPath}">
                     <xsl:choose>
                        <xsl:when test="$smode='showBag'">
                           <xsl:call-template name="myListHeader"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <div id="searchForm">
                              <div id="searchTop">
                                 <div id="searchtip" class="box">
                                    <ul>
                                       <li>Want help? See these <a href="#searchTips"
                                             class="searchTips"
                                             onClick="ga('send', 'event', 'about', 'view', 'search tips on results page');"
                                             >search tips</a>. </li>
                                    </ul>
                                 </div>
                                 <div id="searchbox">
                                    <input class="searchbox" type="text" name="keyword">
                                       <xsl:attribute name="value">
                                          <xsl:if test="$keyword">
                                             <xsl:value-of select="$keyword"/>
                                          </xsl:if>
                                          <xsl:if test="$text">
                                             <xsl:value-of select="$text"/>
                                          </xsl:if>
                                       </xsl:attribute>
                                    </input>
                                    <div id="advancedSearch">
                                       <div id="boolean">
                                          <xsl:choose>
                                             <xsl:when test="$text-join = 'or'">
                                                <input type="radio" name="text-join" value=""/>
                                                <xsl:text> all of </xsl:text>
                                                <input type="radio" name="text-join" value="or" checked="checked"/>
                                                <xsl:text> any of </xsl:text>
                                             </xsl:when>
                                             <xsl:otherwise>
                                                <input type="radio" name="text-join" value="" checked="checked"/>
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
                                             <option value="ead">
                                                <xsl:if test="$type = 'ead'">
                                                   <xsl:attribute name="selected">selected</xsl:attribute>
                                                </xsl:if>Archival Collections </option>
                                             <option value="dao">
                                                <xsl:if test="$type = 'dao'">
                                                   <xsl:attribute name="selected">selected</xsl:attribute>
                                                </xsl:if> Digital Materials</option>
                                             <option value="mods">
                                                <xsl:if test="$type = 'mods'">
                                                   <xsl:attribute name="selected">selected</xsl:attribute>
                                                </xsl:if> Library Materials</option>
                                          </select>
                                          <!-- 6/21/2013 HA: adding advanced search to home page -->
                                          <select name="sectionType" id="library">
                                             <option value="">All Fields</option>
                                             <option value="title">Title</option>
                                             <option value="creator">Author</option>
                                             <option value="callNumber">Call Number</option>
                                             <option value="isbn">ISBN/ISSN</option>
                                             <option value="lccn">LCCN</option>
                                          </select>
                                          <select name="sectionType" id="collections">
                                             <option value="">All Fields</option>
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
                                             <option value="">All Fields</option>
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
                                       </div>
                                       <div id="date">
                                          <label for="year">From: </label>
                                          <input class="date" type="text" name="year"/>
                                          <label for="year">To: </label>
                                          <input class="date" type="text" name="year-max"/>
                                          <div id="searchtipDate" class="box">
                                             <ul>
                                                <li>Enter the date as a single year, for example 1942 or 1973.</li>
                                             </ul>
                                          </div>
                                       </div>
                                       <div class="showAdvanced open">
                                          <a href="#">close</a>
                                       </div>
                                    </div>

                                    <input class="searchbox" type="submit" value="Search"
                                       onClick="ga('send', 'event', 'search', 'keyword', 'results page');"/>
                                    <script type="text/javascript">
                                    $("#searchResults").submit(function() {
                                    $('input[value=]',this).remove();
                                    $('select[value=]',this).remove();
                                    return true;
                                    });
                              </script>
                                    <a href="#" class="showAdvanced closed"
                                       onClick="ga('send', 'event', 'search', 'advanced', 'results page');">more search options</a>
                                 </div>
                              </div>
                           </div>
                        </xsl:otherwise>
                     </xsl:choose>
                  </form>
               </div>

               <!-- results -->
               <div class="results">
                  <xsl:if test="$smode='showBag'">
                     <xsl:attribute name="class">results bookbagView</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="//spelling">
                     <div class="spelling">
                        <xsl:call-template name="did-you-mean">
                           <xsl:with-param name="baseURL" select="concat($xtfURL, $crossqueryPath, '?', $queryString)"/>
                           <xsl:with-param name="spelling" select="//spelling"/>
                        </xsl:call-template>
                     </div>
                  </xsl:if>

                  <xsl:choose>
                     <xsl:when test="docHit">
                        <xsl:if test="not($smode='showBag')">
                           <div class="facets">
                              <div id="facets">
                                 <!--3/26/12 WS: Added some if statements to only show facets if facet data is available -->
                                 <xsl:if
                                    test="facet[@field='facet-subject']/child::* or facet[@field='facet-subjectpers']/child::* or facet[@field='facet-subjectcorp']/child::* or facet[@field='facet-geogname']/child::*">
                                    <h2>Narrow Search Results</h2>
                                    <xsl:if test="facet[@field='facet-date']/@totalGroups > 1">
                                       <div class="facet category">
                                          <h3>Dates</h3>
                                       </div>

                                       <xsl:variable name="queryURL" select="$queryString"> </xsl:variable>
                                       <div class="facetGroup">
                                          <form method="get" action="{$xtfURL}{$crossqueryPath}">
                                             <xsl:if test="parameters/param">
                                                <xsl:for-each select="parameters/param">
                                                   <xsl:if test="@name !='year' and @name !='year-max'">
                                                      <input type="hidden" name="{@name}" value="{@value}"/>
                                                   </xsl:if>
                                                </xsl:for-each>
                                             </xsl:if>

                                             <input type="text" name="year" id="from" size="4"
                                                onClick="ga('send', 'event', 'results', 'date', 'set from date');"/>
                                             <input type="text" name="year-max" id="to" size="4"
                                                onClick="ga('send', 'event', 'results', 'date', 'set to date');"/>
                                             <input type="submit" value="Filter"
                                                onClick="ga('send', 'event', 'results', 'date', 'filter dates');"
                                             />

                                          </form>
                                          <div id="histogram"/>
                                          <div id="slider-range"/>
                                       </div>
                                    </xsl:if>
                                    <xsl:if test="facet[@field='facet-subject']/child::*">
                                       <xsl:apply-templates select="facet[@field='facet-subject']"/>
                                    </xsl:if>
                                    <xsl:if test="facet[@field='facet-subjectpers']/child::*">
                                       <xsl:apply-templates select="facet[@field='facet-subjectpers']"/>
                                    </xsl:if>
                                    <xsl:if test="facet[@field='facet-subjectcorp']/child::*">
                                       <xsl:apply-templates select="facet[@field='facet-subjectcorp']"/>
                                    </xsl:if>
                                    <xsl:if test="facet[@field='facet-geogname']/child::*">
                                       <xsl:apply-templates select="facet[@field='facet-geogname']"/>
                                    </xsl:if>
                                    <xsl:if test="facet[@field='facet-format']/child::*">
                                       <xsl:apply-templates select="facet[@field='facet-format']"/>
                                    </xsl:if>

                                 </xsl:if>
                              </div>
                              <div class="browse">
                                 <h2>Browse</h2>
                                 <div class="accordionButton category">
                                    <h3><img src="/xtf/icons/default/collections.gif" alt="archival collections" height="25px"/>Archival Collections</h3>
                                 </div>
                                 <div class="accordionContent">
                                    <li class="browseOption">
                                       <a
                                          href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=ead"
                                          onClick="ga('send', 'event', 'search', 'results browse', 'archival');"
                                          >Browse All</a>
                                    </li>
                                    <li class="browseOption">
                                       <a
                                          href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title&amp;browse-all=yes;level=collection;type=ead"
                                          onClick="ga('send', 'event', 'search', 'results browse', 'archival-title');"
                                          >By Title</a>
                                    </li>
                                    <li class="browseOption">
                                       <a
                                          href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=title&amp;browse-all=yes;level=collection;type=ead"
                                          onClick="ga('send', 'event', 'search', 'results browse', 'archival-creator');"
                                          >By Creator</a>

                                    </li>
                                 </div>
                                 <div class="accordionButton category">
                                    <h3><img src="/xtf/icons/default/book.gif" alt="library materials" height="25px"/>Library Materials</h3>
                                 </div>
                                 <div class="accordionContent">
                                    <li class="browseOption">
                                       <a
                                          href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=mods"
                                          onClick="ga('send', 'event', 'search', 'results browse', 'library');"
                                          >Browse All</a>
                                    </li>
                                    <li class="browseOption">
                                       <a
                                          href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title&amp;browse-all=yes;level=collection;type=mods"
                                          onClick="ga('send', 'event', 'search', 'results browse', 'library-title');"
                                          >By Title</a>
                                    </li>
                                    <li class="browseOption">
                                       <a
                                          href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=title&amp;browse-all=yes;level=collection;type=mods"
                                          onClick="ga('send', 'event', 'search', 'results browse', 'library-creator');"
                                          >By Creator</a>
                                    </li>
                                 </div>
                                 <div class="accordionButton category">
                                    <h3><img src="/xtf/icons/default/dao_large.gif" alt="digital materials" height="25px"/>Digital Materials</h3>
                                 </div>
                                 <div class="accordionContent">
                                    <li class="browseOption">
                                       <a
                                          href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=file;type=dao"
                                          onClick="ga('send', 'event', 'search', 'results browse', 'digital');"
                                          >Browse All</a>
                                    </li>
                                    <li class="browseOption">
                                       <a
                                          href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title&amp;browse-all=yes;level=file;type=dao"
                                          onClick="ga('send', 'event', 'search', 'results browse', 'digital-title');"
                                          >By Title</a>
                                    </li>
                                    <li class="browseOption">
                                       <a
                                          href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=title&amp;browse-all=yes;level=file;type=dao"
                                          onClick="ga('send', 'event', 'search', 'results browse', 'digital-creator');"
                                          >By Creator</a>
                                    </li>
                                 </div>
                              </div>

                           </div>
                           <div id="docHits">
                              <div id="results">
                                 <div id="hits">
                                    <xsl:if test="(/crossQueryResult/@totalDocs &gt; 1)">
                                       <xsl:text>Showing </xsl:text>
                                       <xsl:value-of select="$startDoc"/>
                                       <xsl:text>-</xsl:text>
                                       <xsl:choose>
                                          <xsl:when test="(/crossQueryResult/@totalDocs &lt; $docsPerPage)">
                                             <xsl:value-of select="/crossQueryResult/@totalDocs"/>
                                          </xsl:when>
                                          <xsl:when test="(/crossQueryResult/@totalDocs &lt; ($docsPerPage + ($startDoc - 1)))">
                                             <xsl:value-of select="/crossQueryResult/@totalDocs"/>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <xsl:value-of select="($docsPerPage + ($startDoc - 1))"/>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                       <xsl:text> of </xsl:text>
                                    </xsl:if>
                                    <xsl:variable name="items" select="@totalDocs"/>
                                    <xsl:choose>
                                       <xsl:when test="$items = 1">
                                          <span id="itemCount">1</span>
                                          <xsl:text> result</xsl:text>
                                          <div class="ra-query">
                                             <xsl:call-template name="format-query"/>
                                             <xsl:call-template name="currentBrowse"/>
                                          </div>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <span id="itemCount">
                                             <xsl:value-of select="$items"/>
                                          </span>
                                          <xsl:text> results</xsl:text>
                                          <div class="resultsQuery">
                                             <xsl:call-template name="format-query"/>
                                             <xsl:call-template name="currentBrowse"/>
                                          </div>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </div>
                                 <xsl:if test="@totalDocs > $docsPerPage">
                                    <div class="pages">
                                       <xsl:call-template name="pages"/>
                                    </div>
                                 </xsl:if>
                                 <div id="sort">
                                    <form id="sortForm" method="get" action="{$xtfURL}{$crossqueryPath}">
                                       <b>Sort: </b>
                                       <xsl:call-template name="sort.options"/>
                                       <xsl:call-template name="hidden.query">
                                          <xsl:with-param name="queryString" select="editURL:remove($queryString, 'sort')"/>
                                       </xsl:call-template>
                                       <noscript>
                                          <input type="submit" value="Go!"
                                             onClick="ga('send', 'event', 'results', 'sort', '{$sort}');"
                                          />
                                       </noscript>
                                    </form>
                                 </div>
                              </div>

                              <xsl:choose>
                                 <xsl:when test="$type = 'dao'">
                                    <xsl:for-each select="docHit">
                                       <xsl:if test="meta/daoLink!=''">
                                          <xsl:apply-templates select="." mode="docHit"/>
                                       </xsl:if>
                                    </xsl:for-each>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:for-each-group select="docHit[*:meta/*:type]" group-by="@path">
                                       <xsl:call-template name="docHitColl"/>
                                    </xsl:for-each-group>
                                 </xsl:otherwise>
                              </xsl:choose>

                              <xsl:if test="@totalDocs > $docsPerPage">
                                 <div class="pages">
                                    <xsl:call-template name="pages"/>
                                 </div>
                              </xsl:if>
                           </div>
                        </xsl:if>

                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:choose>
                           <xsl:when test="$smode = 'showBag'">
                              <div class="myListContents">
                                 <xsl:call-template name="emptyList"/>
                              </div>
                           </xsl:when>
                           <xsl:otherwise>
                              <div class="nohits">Oops, I couldn't find anything! Do you want to try <a href="{$xtfURL}{$crossqueryPath}">another search</a>? </div>
                           </xsl:otherwise>
                        </xsl:choose>

                     </xsl:otherwise>
                  </xsl:choose>
               </div>

               <!-- feedback and footer -->
               <xsl:copy-of select="$brand.footer"/>
               <xsl:call-template name="myListEmail"/>
               <xsl:call-template name="myListPrint"/>
               <xsl:call-template name="myListRequest"/>
               <xsl:call-template name="myListSave"/>
               <xsl:call-template name="myListCopies"/>
            </div>
         </body>
      </html>
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- Browse Template                                                        -->
   <!-- ====================================================================== -->

   <xsl:template match="crossQueryResult" mode="browse" exclude-result-prefixes="#all">

      <xsl:variable name="alphaList" select="'A B C D E F G H I J K L M N O P Q R S T U V W Y Z'"/>

      <html xml:lang="en" lang="en">
         <head>
            <title>DIMES: Search Results</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:copy-of select="$brand.links"/>
         </head>
         <body>
            <!-- search tips -->
            <xsl:copy-of select="$brand.searchtips"/>
            <!-- header -->
            <xsl:copy-of select="$brand.header"/>

            <!-- result header -->
            <div id="header">
               <a href="/xtf/search">
                  <img src="/xtf/css/default/images/rockefeller_archive_center_logo.png" height="140" alt="The Rockefeller Archive Center" border="0"/>
                  <h1>dimes.rockarch.org</h1>
                  <p class="tagline">The Online Collections and Catalog of Rockefeller Archive Center</p>
               </a>
            </div>

            <xsl:call-template name="myListNav"/>

            <div class="resultsHeader">
               <div id="currentBrowse">
                  <strong>Browsing:&#160;</strong>
                  <xsl:call-template name="currentBrowse"/>
               </div>

               <xsl:variable name="browse-name">
                  <xsl:choose>
                     <xsl:when test="$browse-creator">
                        <xsl:value-of select="'creator'"/>
                     </xsl:when>
                     <xsl:when test="$browse-title">
                        <xsl:value-of select="'title'"/>
                     </xsl:when>
                     <!-- 9/26/11 WS: added new browse options -->
                     <xsl:when test="$browse-subject">
                        <xsl:value-of select="'Subject - Topical Term'"/>
                     </xsl:when>
                     <xsl:when test="$browse-subjectname">
                        <xsl:value-of select="'Subject - Personal, Family, or Corporate Name'"/>
                     </xsl:when>
                     <xsl:when test="$browse-geogname">
                        <xsl:value-of select="'Subject - Geographic Name'"/>
                     </xsl:when>
                  </xsl:choose>
               </xsl:variable>

               <xsl:variable name="browse-value">
                  <xsl:choose>
                     <xsl:when test="$browse-creator">
                        <xsl:value-of select="$browse-creator"/>
                     </xsl:when>
                     <xsl:when test="$browse-title">
                        <xsl:value-of select="$browse-title"/>
                     </xsl:when>
                     <!-- 2/28/2013 HA: Adding new browse option -->
                     <xsl:when test="$browse-updated">
                        <xsl:value-of select="$browse-updated"/>
                     </xsl:when>
                     <!-- 9/26/11 WS: Added new browse options -->
                     <xsl:when test="$browse-subject">
                        <xsl:value-of select="$browse-subject"/>
                     </xsl:when>
                     <xsl:when test="$browse-subjectname">
                        <xsl:value-of select="$browse-subjectname"/>
                     </xsl:when>
                     <xsl:when test="$browse-geogname">
                        <xsl:value-of select="$browse-geogname"/>
                     </xsl:when>
                  </xsl:choose>
               </xsl:variable>

               <div id="alphaList">
                  <div id="alphaLinksSelect">
                    <b>Jump to: </b>
                    <select id="alphaLinksOptions">
                      <xsl:call-template name="alphaList">
                          <xsl:with-param name="select" select="'select'"/>
                          <xsl:with-param name="alphaList" select="$alphaList"/>
                      </xsl:call-template>
                    </select>
                  </div>
                  <div id="alphaLinks">
                    <xsl:call-template name="alphaList">
                       <xsl:with-param name="alphaList" select="$alphaList"/>
                    </xsl:call-template>
                  </div>
               </div>
            </div>

            <!-- results -->
            <div class="results">
               <div class="facets">
                  <div class="browse">
                     <h2>Browse</h2>
                     <div class="accordionButton category">
                        <h3><img src="/xtf/icons/default/collections.gif" alt="archival collections" height="25px"/>Archival Collections</h3>
                     </div>
                     <div class="accordionContent">
                        <li class="browseOption">
                           <a
                              href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=ead"
                              onClick="ga('send', 'event', 'search', 'browse', 'archival');"
                              >Browse All</a>
                        </li>
                        <li class="browseOption">
                           <a
                              href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title&amp;browse-all=yes;level=collection;type=ead"
                              onClick="ga('send', 'event', 'search', 'browse', 'archival-title');"
                              >By Title</a>
                        </li>
                        <li class="browseOption">
                           <a
                              href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=title&amp;browse-all=yes;level=collection;type=ead"
                              onClick="ga('send', 'event', 'search', 'browse', 'archival-creator');"
                              >By Creator</a>
                        </li>
                     </div>
                     <div class="accordionButton category">
                        <h3><img src="/xtf/icons/default/book.gif" alt="library materials" height="25px"/>Library Materials</h3>
                     </div>
                     <div class="accordionContent">
                        <li class="browseOption">
                           <a
                              href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=mods"
                              onClick="ga('send', 'event', 'search', 'browse', 'library');"
                              >Browse All</a>
                        </li>
                        <li class="browseOption">
                           <a
                              href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title&amp;browse-all=yes;level=collection;type=mods"
                              onClick="ga('send', 'event', 'search', 'browse', 'library-title');"
                              >By Title</a>
                        </li>
                        <li class="browseOption">
                           <a
                              href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=title&amp;browse-all=yes;level=collection;type=mods"
                              onClick="ga('send', 'event', 'search', 'browse', 'library-creator');"
                              >By Creator</a>
                        </li>
                     </div>
                     <div class="accordionButton category">
                        <h3><img src="/xtf/icons/default/dao_large.gif" alt="digital materials" height="25px"/>Digital Materials</h3>
                     </div>
                     <div class="accordionContent">
                        <li class="browseOption">
                           <a
                              href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=file;type=dao"
                              onClick="ga('send', 'event', 'search', 'browse', 'digital');"
                              >Browse All</a>
                        </li>
                        <li class="browseOption">
                           <a
                              href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title&amp;browse-all=yes;level=file;type=dao"
                              onClick="ga('send', 'event', 'search', 'browse', 'digital-title');"
                              >By Title</a>
                        </li>
                        <li class="browseOption">
                           <a
                              href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=title&amp;browse-all=yes;level=file;type=dao"
                              onClick="ga('send', 'event', 'search', 'browse', 'digital-creator');"
                              >By Creator</a>
                        </li>
                     </div>
                  </div>

               </div>
               <div id="docHits">
                  <xsl:choose>
                     <xsl:when test="$browse-title">
                        <xsl:apply-templates select="facet[@field='browse-title']/group/docHit" mode="docHit"/>
                     </xsl:when>
                     <xsl:when test="$browse-creator">
                        <xsl:apply-templates select="facet[@field='browse-creator']/group/docHit" mode="docHit"/>
                     </xsl:when>
                     <!-- 2/28/2013 HA: added browse option -->
                     <xsl:when test="$browse-updated">
                        <xsl:apply-templates select="facet[@field='browse-updated']/group/docHit" mode="docHit"/>
                     </xsl:when>
                     <!-- 9/26/11 WS: Added browse options -->
                     <xsl:when test="$browse-subject">
                        <xsl:apply-templates select="facet[@field='browse-subject']/group/docHit" mode="docHit"/>
                     </xsl:when>
                     <xsl:when test="$browse-subjectname">
                        <xsl:apply-templates select="facet[@field='browse-subjectname']/group/docHit" mode="docHit"/>
                     </xsl:when>
                     <xsl:when test="$browse-geogname">
                        <xsl:apply-templates select="facet[@field='browse-geogname']/group/docHit" mode="docHit"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:apply-templates select="facet[@field='browse-creator']/group/docHit" mode="docHit"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </div>
            </div>

            <!-- feedback and footer -->
            <xsl:copy-of select="$brand.footer"/>
            <xsl:call-template name="myListEmail"/>
            <xsl:call-template name="myListPrint"/>
            <xsl:call-template name="myListRequest"/>
            <xsl:call-template name="myListSave"/>
            <xsl:call-template name="myListCopies"/>

         </body>
      </html>
   </xsl:template>

   <xsl:template name="browseLinks">
      <div class="browselinks">
         <h3>
            <a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection">Browse All</a>
         </h3>
         <div class="boxLeft">
            <img class="categoryImage" src="/xtf/icons/default/collections.gif" alt="archival collections"/>
            <h4>Archival Collections</h4>
            <ul>
               <li>
                  <a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=ead">Browse All Archival Collections</a>
               </li>
               <li>
                  <a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title&amp;browse-all=yes;level=collection;type=ead">Collections by Title</a>
               </li>
               <li>
                  <a href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=title&amp;browse-all=yes;level=collection;type=ead">Collections by Creator</a>
               </li>
               <li>
                  <a href="{$xtfURL}{$crossqueryPath}?sort=dateStamp&amp;browse-all=yes;level=collection;type=ead">Recently Updated Collections</a>
               </li>
            </ul>
         </div>
         <div class="boxCenter">
            <img class="categoryImage" src="/xtf/icons/default/book.gif" alt="library materials"/>
            <h4>Library Materials</h4>
            <ul>
               <li>
                  <a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=mods">Browse All Library Materials</a>
               </li>
               <li>
                  <a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title&amp;browse-all=yes;level=collection;type=mods">Library Materials by Title</a>
               </li>
               <li>
                  <a href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=title&amp;browse-all=yes;level=collection;type=mods">Library Materials by Creator</a>
               </li>
            </ul>
         </div>
         <div class="boxRight">
            <img class="categoryImage" src="/xtf/icons/default/dao_large.gif" alt="digital materials"/>
            <h4>Digital Materials</h4>
            <ul>
               <li>
                  <a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=file;type=dao">Browse All Digital Materials</a>
               </li>
               <li>
                  <a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title&amp;browse-all=yes;level=file;type=dao">by Title</a>
               </li>
               <li>
                  <a href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=title&amp;browse-all=yes;level=file;type=dao">by Creator</a>
               </li>
            </ul>
         </div>
      </div>
   </xsl:template>

   <xsl:template name="currentBrowseLinks">
      <span class="currentBrowse">
         <a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection">All</a> | <a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=ead">
            <xsl:if test="$type='ead' and not($browse-title) and not($browse-creator) and not($browse-updated)">
               <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if> Archival Collections</a> | <a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=mods">
            <xsl:if test="$type='mods' and not($browse-title) and not($browse-creator)">
               <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if> Library Materials</a>
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

   <xsl:template mode="docHit" match="docHit" exclude-result-prefixes="#all">
      <xsl:variable name="chunk.id" select="@subDocument"/>
      <xsl:variable name="level" select="meta/level"/>
      <xsl:variable name="path" select="@path"/>
      <xsl:variable name="identifier" select="meta/identifier[1]"/>
      <xsl:variable name="quotedID" select="concat('&quot;', $identifier, '&quot;')"/>
      <!-- 1/12/12 WS: Added docPath variable to enable scrolling to sub-document hits -->
      <xsl:variable name="docPath">
         <xsl:variable name="uri">
            <xsl:call-template name="dynaxml.url">
               <xsl:with-param name="path" select="$path"/>
            </xsl:call-template>
         </xsl:variable>
         <xsl:choose>
            <xsl:when test="$chunk.id != ''">
                <xsl:choose>
                  <xsl:when test="meta/seriesID != ''">
                    <xsl:value-of select="concat($uri,';chunk.id=',meta/seriesID,';doc.view=contents','#',$chunk.id)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="concat($uri,';chunk.id=contentsLink;doc.view=contents','#',$chunk.id)"/>
                  </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="concat($uri,';chunk.id=headerlink')"/>
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
         <xsl:if test="meta/type = 'dao' and meta/type = 'ead' and meta/level = 'file'">
            <xsl:attribute name="class">docHit dao</xsl:attribute>
         </xsl:if>
         <div id="top-level_{@rank}" class="top-level component">
            <!-- 11/15/2013 HA: streamlining display, removing labels, similar items and subjects -->
            <!-- 7/10/2013 HA: turning results list into divs rather than table -->
            <!-- 9/26/11 WS: Moved title above Author -->
            <div class="resultIcon">
               <xsl:choose>
                  <xsl:when test="meta/type = 'dao' and meta/type = 'ead' and meta/level = 'file'">
                     <xsl:variable name="daoImg">
                        <xsl:choose>
                           <xsl:when test="count(meta/daoLink) &gt; 1">
                              <xsl:value-of>/xtf/icons/default/thumbnail-multi.svg</xsl:value-of>
                           </xsl:when>
                           <xsl:when test="meta/viewable='true'">
                              <xsl:variable name="daoFile" select="substring-before(meta/daoLink,'.pdf')"/>
                              <xsl:value-of select="concat($daoFile,'_thumb75.jpg')"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of>/xtf/icons/default/thumbnail-large.svg</xsl:value-of>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <img src="{$daoImg}" alt="Digital object thumbnail" width="90%"/>
                  </xsl:when>
                  <xsl:when test="meta/genre[contains(.,'dvd')]">
                     <img src="/xtf/icons/default/video.gif" alt="Moving Image" title="Moving Image"/>
                  </xsl:when>
                  <xsl:when test="meta/genre[contains(.,'videocassette')]">
                     <img src="/xtf/icons/default/video.gif" alt="Moving Image" title="Moving Image"/>
                  </xsl:when>
                  <xsl:when test="meta/genre[contains(.,'reel')]">
                     <img src="/xtf/icons/default/microfilm.gif" alt="Microfilm" title="Microfilm"/>
                  </xsl:when>
                  <xsl:when test="meta/genre[contains(.,'volume')]">
                     <img src="/xtf/icons/default/book.gif" alt="Book" title="Book"/>
                  </xsl:when>
                  <xsl:when test="meta/type = 'ead' and meta/type != 'dao'">
                     <img src="/xtf/icons/default/collections.gif" alt="Archival collection" title="Archival collection"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="meta/genre"/>
                  </xsl:otherwise>
               </xsl:choose>
            </div>

            <div class="resultContent">
               <div class="result title">
                  <a
                     onClick="ga('send', 'event', 'component info', 'view finding aid', 'results main collection');"
                     title="Go to finding aid">
                     <xsl:attribute name="href">
                        <xsl:value-of select="$docPath"/>
                     </xsl:attribute>
                     <xsl:if test="meta/type = 'dao' and meta/type = 'ead' and meta/level = 'file'">
                        <xsl:attribute name="onClick">
                           <xsl:text>ga('send', 'event', 'digital object', 'view', 'results page');</xsl:text>
                        </xsl:attribute>
                     </xsl:if>
                     <xsl:choose>
                        <xsl:when test="meta/title != ''">
                           <xsl:apply-templates select="meta/title"/>
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
                     </xsl:choose>

                     <!-- 11/15/2013 HA: moving date after title, changing logic so only appears if exists -->
                     <xsl:if test="meta/date">
                        <!-- 9/27/11 WS: Changed date to always grab from meta/date -->
                        <xsl:if test="meta/title != ''">
                           <xsl:text>, </xsl:text>
                        </xsl:if>
                        <xsl:apply-templates select="meta/date"/>
                     </xsl:if>
                     <xsl:if test="meta/type = 'ead' and meta/level='collection'">
                        <span class="identifier">
                           <xsl:text> (</xsl:text>
                           <xsl:choose>
                              <xsl:when test="contains(meta/identifier, '-')">
                                 <xsl:value-of select="substring-before(meta/identifier, '-')"/>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:value-of select="meta/identifier"/>
                              </xsl:otherwise>
                           </xsl:choose>
                           <xsl:text>)</xsl:text>
                        </span>
                     </xsl:if>
                  </a>
               </div>

               <!-- 11/15/2013 HA: removing label and changing logic -->
               <xsl:if test="meta/creator">
                  <div class="result creator">
                     <xsl:for-each select="meta/creator">
                        <xsl:apply-templates select="."/>
                        <br/>
                     </xsl:for-each>
                  </div>
               </xsl:if>

               <!-- 9/5/2013 HA: adding collection for DAO browse -->
               <xsl:if test="meta/type = 'dao' and meta/type = 'ead' and meta/level !='collection'">
                  <div class="parents">
                     <xsl:for-each select="meta/parent">
                        <xsl:value-of select="."/>
                        <xsl:if test="position() != last()">
                           <xsl:text> &gt; </xsl:text>
                        </xsl:if>
                     </xsl:for-each>
                  </div>
               </xsl:if>


               <!-- 11/15/2013 HA: removing label -->
               <!-- 11/14/2013 HA: changing logic to only display snippets for hits not already visible -->
               <!-- 1/26/12 WS: Added descendant-or-self to catch deeply nested matches -->
               <xsl:choose>
                  <xsl:when test="$browse-all"/>
                  <xsl:otherwise>
                     <xsl:if test="descendant-or-self::snippet[@sectionType = 'bioghist' or @sectionType = 'scopecontent']">
                        <div class="result matches">
                           <xsl:apply-templates select="descendant-or-self::snippet[@sectionType = 'bioghist' or @sectionType = 'scopecontent']" mode="text"/>
                        </div>
                     </xsl:if>
                  </xsl:otherwise>
               </xsl:choose>
            </div>

            <div class="bookbag">
               <xsl:call-template name="myList">
                  <xsl:with-param name="chunk.id" select="$chunk.id"/>
                  <xsl:with-param name="path" select="$path"/>
                  <xsl:with-param name="docPath" select="$docPath"/>
               </xsl:call-template>
            </div>

            <!-- dao table -->
            <xsl:if test="meta/daoLink != ''">
               <xsl:call-template name="daoTable"/>
            </xsl:if>

         </div>
         <div class="activeArrow"/>

      </div>
      <div id="componentInfo_{@rank}" class="componentInfo">
         <xsl:apply-templates select="." mode="collection"/>
      </div>

   </xsl:template>

   <!-- HA todo: can this call docHit template for first part of code? -->
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
               <xsl:value-of select="concat($uri,';chunk.id=',meta/seriesID,';doc.view=contents','#',$chunk.id)"/>
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
               <xsl:with-param name="chunk.id" select="'headerlink'"/>
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
         <xsl:variable name="collectionId" select="substring-before(meta/identifier[1],'-')"/>
         <!-- 11/15/2013 HA: streamlining display, removing subjects, labels and find similar -->
         <!-- 7/10/2013 HA: turning results list into divs rather than table -->
         <!-- Deals with collections vrs. series/files -->
         <div id="top-level_{@rank}-collection" class="top-level component">
            <div class="resultIcon">
               <xsl:choose>
                  <xsl:when test="meta/genre[contains(.,'DVD')]">
                     <img src="/xtf/icons/default/video.gif" alt="Moving Image" title="Moving Image"/>
                  </xsl:when>
                  <xsl:when test="meta/genre[contains(.,'Videocassette')]">
                     <img src="/xtf/icons/default/video.gif" alt="Moving Image" title="Moving Image"/>
                  </xsl:when>
                  <xsl:when test="meta/genre[contains(.,'Reel')]">
                     <img src="/xtf/icons/default/microfilm.gif" alt="Microfilm" title="Microfilm"/>
                  </xsl:when>
                  <xsl:when test="meta/genre[contains(.,'Volume')]">
                     <img src="/xtf/icons/default/book.gif" alt="Book" title="Book"/>
                  </xsl:when>
                  <xsl:when test="meta/type = 'ead' and meta/type != 'dao'">
                     <img src="/xtf/icons/default/collections.gif" alt="Archival collection" title="Archival collection"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="meta/genre"/>
                  </xsl:otherwise>
               </xsl:choose>
            </div>
            <div class="resultContent">
               <div class="result title">
                 <a onClick="ga('send', 'event', 'component info', 'view finding aid', 'results main collection');" title="Go to finding aid">
                     <xsl:attribute name="href">
                        <xsl:value-of select="$collPath"/>
                     </xsl:attribute>
                     <xsl:choose>
                        <xsl:when test="meta/level = 'collection'">
                           <xsl:choose>
                              <xsl:when test="meta/filingTitle">
                                 <xsl:apply-templates select="meta/filingTitle"/>
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
                              <xsl:otherwise>
                                 <xsl:apply-templates select="meta/title"/>
                              </xsl:otherwise>
                           </xsl:choose>

                           <!-- 11/15/2013 HA: moving date after title, changing logic so only appears if exists -->
                           <xsl:if test="meta/date">
                              <!-- 9/27/11 WS: Changed date to always grab from meta/date -->
                              <xsl:text>, </xsl:text>
                              <xsl:apply-templates select="meta/date"/>
                           </xsl:if>
                           <!--<xsl:if test="meta/*:type = 'dao'">
                              <img src="/xtf/icons/default/dao.gif" alt="digital object"
                                 title="Digital object"/>
                           </xsl:if>-->
                           <xsl:if test="meta/type = 'ead' and meta/level='collection'">
                              <span class="identifier">
                                 <xsl:text> (</xsl:text>
                                 <xsl:choose>
                                    <xsl:when test="contains(meta/identifier, '|')">
                                       <xsl:value-of select="substring-before(meta/identifier, '|')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:value-of select="meta/identifier"/>
                                    </xsl:otherwise>
                                 </xsl:choose>
                                 <xsl:text>)</xsl:text>
                              </span>
                           </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:choose>
                              <xsl:when test="meta/collectionTitle">
                                 <xsl:apply-templates select="meta/collectionTitle"/>
                              </xsl:when>
                              <xsl:when test="meta/subtitle">
                                 <xsl:apply-templates select="meta/subtitle"/>
                              </xsl:when>
                              <xsl:when test="meta/title != ''">
                                 <xsl:apply-templates select="meta/title"/>
                              </xsl:when>
                              <xsl:otherwise>none</xsl:otherwise>
                           </xsl:choose>

                           <!-- 11/15/2013 HA: moving date after title, changing logic so only appears if exists -->
                           <xsl:if test="meta/collectionDate">
                              <!-- 9/27/11 WS: Changed date to always grab from meta/date -->
                              <xsl:text>, </xsl:text>
                              <xsl:apply-templates select="meta/collectionDate"/>
                           </xsl:if>
                           <!--<xsl:if test="meta/*:type = 'dao'">
                              <img src="/xtf/icons/default/dao.gif" alt="digital object"
                                 title="Digital object"/>
                           </xsl:if>-->
                        </xsl:otherwise>
                     </xsl:choose>
                  </a>
               </div>
               <!-- 11/15/2013 HA: removing label and changing logic -->
               <xsl:if test="meta/creator">
                  <div class="result creator">
                     <xsl:for-each select="meta/creator">
                        <xsl:apply-templates select="."/>
                        <br/>
                     </xsl:for-each>
                  </div>
               </xsl:if>

               <!-- 11/14/2013 HA: changing logic to only display snippets not already visible -->
               <!-- 1/26/12 WS: Added descendant-or-self to catch deeply nested matches -->
               <xsl:choose>
                  <xsl:when test="$browse-all"/>
                  <xsl:otherwise>
                     <xsl:if test="descendant-or-self::snippet[@sectionType = 'bioghist' or @sectionType = 'scopecontent']">
                        <div class="result matches">
                           <xsl:apply-templates select="descendant-or-self::snippet[@sectionType = 'bioghist' or @sectionType = 'scopecontent']" mode="text"/>
                        </div>
                     </xsl:if>
                  </xsl:otherwise>
               </xsl:choose>
            </div>

            <xsl:if test="meta/type='mods'">
               <div class="bookbag">
                  <xsl:call-template name="myList">
                     <xsl:with-param name="chunk.id" select="$chunk.id"/>
                     <xsl:with-param name="path" select="$path"/>
                     <xsl:with-param name="docPath" select="$docPath"/>
                  </xsl:call-template>
               </div>
            </xsl:if>

         </div>
         <div class="activeArrow"/>

         <xsl:if test="current-group()[meta/level != 'collection']">
            <div class="subdocuments">
               <xsl:for-each select="current-group()[meta/level != 'collection']">
                  <div class="subdocumentWrap">
                     <div id="subdocument_{@rank}" class="subdocument component">
                        <xsl:if test="position() mod 2 = 1">
                           <xsl:attribute name="class">subdocument component odd</xsl:attribute>
                        </xsl:if>
                        <xsl:call-template name="subDocument"/>
                     </div>
                     <div class="activeArrow"/>
                  </div>
                  <div id="componentInfo_{@rank}" class="componentInfo">
                     <xsl:apply-templates select="." mode="subdocument"/>
                  </div>
               </xsl:for-each>
            </div>
         </xsl:if>
      </div>
      <div id="componentInfo_{@rank}-collection" class="componentInfo">
         <xsl:apply-templates select="." mode="collection"/>
      </div>
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
               <xsl:value-of select="concat($uri,';chunk.id=contentsLink',';doc.view=contents','#',$chunk.id)"/>
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
      <xsl:variable name="title">
         <xsl:choose>
            <xsl:when test="meta/level = 'series'">Series </xsl:when>
            <xsl:when test="meta/level = 'subseries'">Subseries </xsl:when>
            <xsl:when test="meta/level = 'recordgrp'">Record Group </xsl:when>
            <xsl:when test="meta/level = 'subgrp'">Subgroup </xsl:when>
            <xsl:otherwise/>
         </xsl:choose>
         <xsl:if test="meta/componentID != ''">
            <xsl:apply-templates select="meta/componentID"/>
            <xsl:text>: </xsl:text>
         </xsl:if>
         <xsl:choose>
            <xsl:when test="meta/title = meta/date">
               <xsl:apply-templates select="meta/title"/>
            </xsl:when>
            <xsl:otherwise>
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
               </xsl:choose>
               <!-- 11/15/2013 HA: moving date after title, changing logic so only appears if exists -->
               <xsl:if test="meta/date != ''">
                  <!-- 9/27/11 WS: Changed date to always grab from meta/date -->
                  <xsl:if test="meta/title != ''">
                     <xsl:text>, </xsl:text>
                  </xsl:if>
                  <xsl:apply-templates select="meta/date"/>
               </xsl:if>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <div class="result title">
         <a
            onClick="ga('send', 'event', 'component info', 'view finding aid', 'results main subdocument');"
            title="Go to finding aid">
            <xsl:attribute name="href">
               <xsl:value-of select="$docPath"/>
            </xsl:attribute>
            <xsl:value-of select="$title"/>
         </a>
         <div class="parents">
            <xsl:for-each select="meta/parent[position()&gt;1]">
               <div class="parent" style="padding-left:{(position() -1)}em">
                  <xsl:value-of select="."/>
               </div>
            </xsl:for-each>
         </div>
      </div>

      <div class="bookbag">
         <xsl:if test="meta/containers !=''">
         <xsl:call-template name="myList">
            <xsl:with-param name="chunk.id" select="$chunk.id"/>
            <xsl:with-param name="path" select="$path"/>
            <xsl:with-param name="docPath" select="$docPath"/>
         </xsl:call-template>
         </xsl:if>
      </div>

      <!-- 11/14/2013 HA: added logic to display only snippets not already visible -->
      <!-- 1/26/12 WS: Added descendant-or-self to catch deeply nested matches -->
      <xsl:choose>
         <xsl:when test="$browse-all"/>
         <xsl:otherwise>
            <xsl:if test="descendant-or-self::snippet[(@sectionType = 'file' or @sectionType = 'series' or @sectionType = 'subseries' or @sectionType = 'otherlevel' or @sectionType = 'collection')]">
               <div class="result matches">
                  <xsl:apply-templates
                     select="descendant-or-self::snippet[(@sectionType = 'file' or @sectionType = 'series' or @sectionType = 'subseries' or @sectionType = 'otherlevel' or @sectionType = 'collection')]"
                     mode="text"/>
               </div>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>

      <!-- dao table -->
      <xsl:if test="meta/daoLink != ''">
         <xsl:call-template name="daoTable"/>
      </xsl:if>

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
      <xsl:variable name="hit.rank">
         <xsl:value-of select="ancestor::snippet/@rank"/>
      </xsl:variable>
      <xsl:variable name="snippet.link">
         <xsl:call-template name="dynaxml.url">
            <xsl:with-param name="path" select="$path"/>
         </xsl:call-template>
         <!--<xsl:value-of select="concat(';hit.rank=', $hit.rank)"/>-->
      </xsl:variable>

      <xsl:choose>
         <xsl:when test="ancestor::query"/>
         <xsl:when test="not(ancestor::snippet) or not(matches($display, 'dynaxml'))">
            <span class="hit">
               <xsl:apply-templates/>
            </span>
         </xsl:when>
         <xsl:otherwise>
            <!--<a href="{$snippet.link}" class="hit"><xsl:apply-templates/></a>-->
            <span class="hit">
               <xsl:apply-templates/>
            </span>
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
            <span class="hit">
               <xsl:apply-templates/>
            </span>
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
               <strong>No similar documents found.</strong>
            </div>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- docHit 2013-11-12 HA: No longer in use -->
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

   <!-- ====================================================================== -->
   <!-- Detailed Component Information Template                                -->
   <!-- ====================================================================== -->
   <xsl:template match="docHit" mode="subdocument" exclude-result-prefixes="#all">
      <xsl:variable name="chunk.id" select="@subDocument"/>
      <xsl:variable name="path" select="@path"/>
      <xsl:variable name="docPath">
         <xsl:variable name="uri">
            <xsl:call-template name="dynaxml.url">
               <xsl:with-param name="path" select="$path"/>
               <!--<xsl:with-param name="chunk.id" select="'headerlink'"/>-->
            </xsl:call-template>
         </xsl:variable>
         <xsl:choose>
            <xsl:when test="$chunk.id != ''">
               <xsl:value-of select="concat($uri,';chunk.id=',meta/seriesID,';doc.view=contents','#',$chunk.id)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$uri"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <div class="title">
         <a
            onClick="ga('send', 'event', 'component info', 'view finding aid', 'results details subdocument');"
            title="Go to finding aid">
            <xsl:attribute name="href">
               <xsl:value-of select="$docPath"/>
            </xsl:attribute>
            <xsl:if test="meta/*:type = 'dao'">
               <xsl:attribute name="onClick">
                  <xsl:text>ga('send', 'event', 'digital object', 'view', 'results page');</xsl:text>
               </xsl:attribute>
            </xsl:if>
            <xsl:choose>
               <xsl:when test="meta/level = 'series'">Series </xsl:when>
               <xsl:when test="meta/level = 'subseries'">Subseries </xsl:when>
               <xsl:when test="meta/level = 'recordgrp'">Record Group </xsl:when>
               <xsl:when test="meta/level = 'subgrp'">Subgroup </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
            <xsl:if test="meta/componentID != ''">
               <xsl:apply-templates select="meta/componentID"/>
               <xsl:text>: </xsl:text>
            </xsl:if>
            <xsl:choose>
               <xsl:when test="meta/title = meta/date">
                  <xsl:apply-templates select="meta/title"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:apply-templates select="meta/title"/>
                  <xsl:if test="meta/date != ''">
                     <xsl:if test="meta/title != ''">
                        <xsl:text>, </xsl:text>
                     </xsl:if>
                     <xsl:apply-templates select="meta/date"/>
                  </xsl:if>
               </xsl:otherwise>
            </xsl:choose>
         </a>
      </div>
      <xsl:if test="meta/level = 'file'">
         <xsl:if test="meta/container">
            <div class="containers">
               <xsl:for-each select="meta/container">
                  <div class="container">
                     <xsl:value-of select="."/>
                  </div>
               </xsl:for-each>
            </div>
         </xsl:if>
      </xsl:if>
      <xsl:if test="meta/extent != ''">
         <div class="extent">
            <xsl:apply-templates select="meta/extent"/>
         </div>
      </xsl:if>
      <div class="parents">
         <xsl:for-each select="meta/parent">
            <div class="parent" style="padding-left:{(position() -1)}em">
               <xsl:value-of select="."/>
            </div>
         </xsl:for-each>
      </div>
      <xsl:if test="meta/scopecontent != ''">
         <div class="notes">
            <div>
               <h4>Additional Description</h4>
               <p>
                  <xsl:apply-templates select="meta/scopecontent"/>
               </p>
            </div>
         </div>
         <div class="notesMore">
            <div class="button">
               <a href="#"
                  onClick="ga('send', 'event', 'component info', 'notes more', 'results page');"
                  >more</a>
            </div>
         </div>
         <div class="notesLess">
            <div class="button">
               <a href="#"
                  onClick="ga('send', 'event', 'component info', 'notes less', 'results page');"
                  >less</a>
            </div>
         </div>
      </xsl:if>
      <xsl:if test="meta/accessrestrict != ''">
         <div class="restrictions notes">
            <div>
               <h4>Access Restrictions</h4>
               <p>
                  <xsl:apply-templates select="meta/accessrestrict"/>
               </p>
            </div>
         </div>
         <div class="notesMore">
            <div class="button">
               <a href="#"
                  onClick="ga('send', 'event', 'component info', 'notes more', 'results page');"
                  >more</a>
            </div>
         </div>
         <div class="notesLess">
            <div class="button">
               <a href="#"
                  onClick="ga('send', 'event', 'component info', 'notes less', 'results page');"
                  >less</a>
            </div>
         </div>
      </xsl:if>
      <xsl:if test="meta/userestrict != ''">
         <div class="restrictions notes">
            <div>
               <h4>Use Restrictions</h4>
               <p>
                  <xsl:apply-templates select="meta/userestrict"/>
               </p>
            </div>
         </div>
         <div class="notesMore">
            <div class="button">
               <a href="#"
                  onClick="ga('send', 'event', 'component info', 'notes more', 'results page');"
                  >more</a>
            </div>
         </div>
         <div class="notesLess">
            <div class="button">
               <a href="#"
                  onClick="ga('send', 'event', 'component info', 'notes less', 'results page');"
                  >less</a>
            </div>
         </div>
      </xsl:if>
      <xsl:if test="meta/language != ''">
         <div class="language">
            <h4>Language(s)</h4>
            <p>
               <xsl:text>Materials are in </xsl:text>
               <xsl:apply-templates select="meta/language"/>
               <xsl:text>.</xsl:text>
            </p>
         </div>
      </xsl:if>
   </xsl:template>

   <xsl:template match="docHit" mode="collection" exclude-result-prefixes="#all">
      <xsl:variable name="chunk.id" select="@subDocument"/>
      <xsl:variable name="path" select="@path"/>
      <xsl:variable name="docPath">
         <xsl:variable name="uri">
            <xsl:call-template name="dynaxml.url">
               <xsl:with-param name="path" select="$path"/>
            </xsl:call-template>
         </xsl:variable>
         <xsl:choose>
            <xsl:when test="$chunk.id != ''">
               <xsl:value-of select="concat($uri,';chunk.id=',meta/seriesID,';doc.view=contents','#',$chunk.id)"/>
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
               <xsl:with-param name="chunk.id" select="'headerlink'"/>
            </xsl:call-template>
         </xsl:variable>
         <xsl:value-of select="$uri"/>
      </xsl:variable>
      <div class="title">
         <a
            onClick="ga('send', 'event', 'component info', 'view finding aid', 'results details collection');"
            title="Go to finding aid">
            <xsl:attribute name="href">
               <xsl:choose>
                  <xsl:when test="meta/level='collection'">
                     <xsl:value-of select="$collPath"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="$docPath"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <xsl:if test="meta/*:type = 'dao'">
               <xsl:attribute name="onClick">
                  <xsl:text>ga('send', 'event', 'digital object', 'view', 'results page');</xsl:text>
               </xsl:attribute>
            </xsl:if>

            <xsl:choose>
               <xsl:when test="$type='dao'">
                  <xsl:apply-templates select="meta/title"/>
                  <xsl:if test="meta/date != ''">
                     <xsl:if test="meta/title !=''">
                        <xsl:text>, </xsl:text>
                     </xsl:if>
                     <xsl:apply-templates select="meta/date"/>
                  </xsl:if>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:choose>
                     <xsl:when test="meta/collectionTitle">
                        <xsl:apply-templates select="meta/collectionTitle"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:apply-templates select="meta/title"/>
                     </xsl:otherwise>
                  </xsl:choose>
                  <xsl:if test="meta/collectionDate != ''">
                     <xsl:text>, </xsl:text>
                     <xsl:apply-templates select="meta/collectionDate"/>
                  </xsl:if>
               </xsl:otherwise>
            </xsl:choose>
            <!--<xsl:if test="meta/*:type = 'dao'">
               <img src="/xtf/icons/default/dao.gif" alt="digital object" title="Digital object"/>
            </xsl:if>-->
         </a>
      </div>
      <xsl:if test="meta/collectionExtent != ''">
         <div class="extent">
            <xsl:apply-templates select="meta/collectionExtent"/>
         </div>
      </xsl:if>
      <xsl:if test="meta/publisher and meta/type = 'mods'">
         <div class="publisher">
            <p>
               <xsl:apply-templates select="meta/publisher"/>
            </p>
         </div>
      </xsl:if>
      <xsl:if test="meta/callNo">
         <div class="callNo">
            <xsl:apply-templates select="meta/callNo"/>
         </div>
      </xsl:if>
      <xsl:if test="meta/collectionScopecontent != ''">
         <div class="notes">
            <div>
               <h4>Additional Description</h4>
               <p>
                  <xsl:apply-templates select="meta/collectionScopecontent"/>
               </p>
            </div>
         </div>
         <div class="notesMore">
            <div class="button">
               <a href="#"
                  onClick="ga('send', 'event', 'component info', 'notes more', 'results page');"
                  >more</a>
            </div>
         </div>
         <div class="notesLess">
            <div class="button">
               <a href="#"
                  onClick="ga('send', 'event', 'component info', 'notes less', 'results page');"
                  >less</a>
            </div>
         </div>
      </xsl:if>
      <xsl:if test="meta/notes">
         <div class="notes">
            <div>
               <p>
                  <xsl:apply-templates select="meta/notes"/>
               </p>
            </div>
         </div>
         <div class="notesMore">
            <div class="button">
               <a href="#"
                  onClick="ga('send', 'event', 'component info', 'notes more', 'results page');"
                  >more</a>
            </div>
         </div>
         <div class="notesLess">
            <div class="button">
               <a href="#"
                  onClick="ga('send', 'event', 'component info', 'notes less', 'results page');"
                  >less</a>
            </div>
         </div>
      </xsl:if>

      <xsl:if test="meta/accessrestrict != ''">
         <div class="restrictions notes">
            <div>
               <h4>Access Restrictions</h4>
               <p>
                  <xsl:apply-templates select="meta/accessrestrict"/>
               </p>
            </div>
         </div>
         <div class="notesMore">
            <div class="button">
               <a href="#"
                  onClick="ga('send', 'event', 'component info', 'notes more', 'results page');"
                  >more</a>
            </div>
         </div>
         <div class="notesLess">
            <div class="button">
               <a href="#"
                  onClick="ga('send', 'event', 'component info', 'notes less', 'results page');"
                  >less</a>
            </div>
         </div>
      </xsl:if>
      <xsl:if test="meta/userestrict != ''">
         <div class="restrictions notes">
            <div>
               <h4>Use Restrictions</h4>
               <p>
                  <xsl:apply-templates select="meta/userestrict"/>
               </p>
            </div>
         </div>
         <div class="notesMore">
            <div class="button">
               <a href="#"
                  onClick="ga('send', 'event', 'component info', 'notes more', 'results page');"
                  >more</a>
            </div>
         </div>
         <div class="notesLess">
            <div class="button">
               <a href="#"
                  onClick="ga('send', 'event', 'component info', 'notes less', 'results page');"
                  >less</a>
            </div>
         </div>
      </xsl:if>
      <xsl:if test="meta/language != ''">
         <div class="language">
            <h4>Language(s)</h4>
            <p>
               <xsl:text>Materials are in </xsl:text>
               <xsl:apply-templates select="meta/language"/>
               <xsl:text>.</xsl:text>
            </p>
         </div>
      </xsl:if>
   </xsl:template>

</xsl:stylesheet>
