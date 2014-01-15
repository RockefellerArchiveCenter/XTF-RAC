<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:session="java:org.cdlib.xtf.xslt.Session" xmlns:ead="urn:isbn:1-931666-22-9"
   xmlns="http://www.w3.org/1999/xhtml" extension-element-prefixes="session"
   version="2.0">
   
   <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
   <!-- Search forms stylesheet                                                -->
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
   
   <!-- ====================================================================== -->
   <!-- Global parameters                                                      -->
   <!-- ====================================================================== -->
   
   <xsl:param name="freeformQuery"/>
         
   <!-- ====================================================================== -->
   <!-- Form Templates                                                         -->
   <!-- ====================================================================== -->
   
   <!-- main form page -->
   <xsl:template match="crossQueryResult" mode="form" exclude-result-prefixes="#all">
      <!-- <xsl:choose>
         <xsl:when test="$smode='collectionGuides'">
            <xsl:call-template name="collectionGuides"/>
         </xsl:when>
         <xsl:when test="$smode='archivalMat'">
            <xsl:call-template name="archivalMat"/>
         </xsl:when>
         <xsl:when test="$smode='searchTips'">
            <xsl:call-template name="searchTips"/>
         </xsl:when>
         <xsl:otherwise> -->
            <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
               <head>
                  <title>DIMES: Online Collections and Catalog of Rockefeller Archive Center</title>
                  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                  <xsl:copy-of select="$brand.links"/>
                  
            <script type="text/javascript" src="/xtf/script/rac/featured.js"></script>
               </head>
               <body>
                  <xsl:copy-of select="$brand.header"/>
                  <div class="overlay" id="dscDescription">
                     <div class="homeDialog">
                        <p>Collection guides are documents that describe and map archival material held at a particular institution. Researchers use collection guides to find and identify archival holdings that may be pertinent to their research.</p>
                        <p>Most collection guides include background information on the person or institution responsible for the creation of the records; a description of the contents, strengths, and weaknesses of the collection; as well as information on how the collection is arranged, how it has been managed, and how researchers can access and use it.</p>
                        <p>Collection guides are only pointers to archival material. They describe the collection and its arrangement, but rarely the individual items contained within it. In many cases it is only by examining a file that one can know its exact contents. Most archival material at the RAC is not digitized and must be consulted on site. Researchers are invited to schedule an appointment to examine our holdings.</p>
                  </div>
                  </div>
                  <div class="overlay" id="searchTips">
                     <div class="searchtips">
                     <p>You can search across the RAC’s archival materials, books, DVDs, VHS and microfilm holdings from the home page or the Advanced Search page. You can search within an archival collection by selecting that collection and then using the "search within this collection" in the navigation bar.</p>
                     <p>An asterisk - * - will find from one to many characters within a word: hist* will retrieve history, histories, and historians, coo*tion will find cooperation and coordination</p>
                     <p>A question mark - ? - will find only one character within a word: america? will retrieve american and americas, wom?n will retrieve woman, women, and womyn</p>
                     <p>To search for an exact string, place quotation marks around the string: "south africa" will find south africa, but not south african</p>
                     <p>Search queries are not case sensitive. Except for the above examples, punctuation is ignored.</p>
                     <img src="./icons/default/facets.png" alt="facets" align="left" width="280px"/><h4>Refining your search</h4>
                     <p>On every search results screen you will see a box titled "Refine Search." It contains categories called facets, and you can discover relevant resources by browsing the contents of the facets. By selecting one or more facets (1) you can further narrow your initial search. In order to remove a facet and expand your search click on the [x] next to the search term (2) in the navigation bar. When you see a facet under "Refine Search" that is of interest to you, you can also dig in deeper by clicking the "more" link (3) to see additional terms.</p>
                     <h4>Get notified when we update the site</h4>
                     <p>When you see this icon <img src="./icons/default/i_rss.png" alt="rss feed"/> it means there is an RSS feed for this search. You can click on it to subscribe to see the most recent changes and additions in that search in your favorite feed reader.</p>
                     </div>
                  </div>
                  <div class="overlay" id="archivalMat">
                     <div class="homeDialog">
                        <p>Archival holdings are generally comprised of original, unpublished material of
                           enduring value created by a person, family, or organization. This material
                           often includes primary source records and firsthand accounts of events and
                           transactions. Archival material may include a variety of media or formats such
                           as correspondence, memos, reports, bound diaries, scrapbooks, maps, blueprints,
                           photographic negatives and prints, films, VHS or audio tapes, or electronic
                           records.</p>
                        
                     </div>
                  </div>
                  <div class="overlay" id="holdings">
                     <div class="homeDialog">
                     <p>The Rockefeller Archive Center holdings encompass the records of the Rockefeller
                        family and their wide-ranging philanthropic endeavors (including the Rockefeller
                        Foundation, the Rockefeller Brothers Fund and Rockefeller University). Today, the
                        Center's growing holdings include materials from numerous non-Rockefeller foundations
                        and nonprofit organizations, making it a premier center for research on philanthropy
                        and civil society. It is also a major repository for the personal papers of leaders
                        of the philanthropic community, Nobel Prize laureates, and world-renowned
                        investigators in science and medicine. </p>
                     </div>
                  </div>
                  <div class="overlay" id="dimes">
                     <div class="homeDialog" style="float:left;">
                        <img src="./icons/default/dimes.jpg" alt="John D. Rockefeller, Sr. handing out dimes" style="float:right; width:45%;"/>
                        <p style="float:left; width:50%;">DIMES is an acronym for Digital Information Management Engine for Searching. It's also a reference to John D. Rockefeller Sr.'s ritual practice of dispensing dimes to reward services exceptionally rendered, deliver a brief sermon on the virtues of frugality, and engage with the public in a way that did not involve signing autographs (a practice he hated).</p>
                        <p style="float:left; width:50%;">"I think it is easier," he said "to remember a lesson when we have some token to recall it by, something we can look at which reminds us of the idea."</p>
                     </div>
                  </div>
                  
               <div id="header">
                  <a href="/xtf/search">
                  <img src="http://www.rockarch.org/images/RAC-logo.png" width="103" height="140"
                     alt="The Rockefeller Archive Center" border="0"/>
                  <h1>dimes.rockarch.org</h1>
                  <p class="tagline">The Online Collections and Catalog of Rockefeller Archive
                     Center</p>
                  </a>
               </div>
            <div id="bookbag">
                  <xsl:variable name="bag" select="session:getData('bag')"/>
                  <a href="{$xtfURL}{$crossqueryPath}?smode=showBag"
                     onClick="_gaq.push(['_trackEvent', 'bookbag', 'view', 'home page']);">
                     <img src="/xtf/icons/default/bookbag.gif" alt="Bookbag"
                        style="vertical-align:bottom;"/>
                  </a>
                  <span>(<span id="bagCount"><xsl:value-of select="count($bag/bag/savedDoc)"
                        /></span>)</span>
            </div>
                 
                  <div class="searchPage">
                     <!--<div class="tabs">
                        <a href="search?smode=simple"><div class="{if(matches($smode,'simple')) then 'tab-select' else 'tab'}">Keyword</div></a>
                        <a href="search?smode=browse"><div class="{if(matches($smode,'browse')) then 'tab-select' else 'tab'}">Browse</div></a>
                     </div>-->
                     <div class="forms">
                        <!-- <table>
                           <tr>
                              <td class="{if(matches($smode,'simple')) then 'tab-select' else 'tab'}"><a href="search?smode=simple">Keyword</a></td>
                              6/21/2013 HA: remove advanced search tab <td class="{if(matches($smode,'advanced')) then 'tab-select' else 'tab'}"><a href="search?smode=advanced">Advanced</a></td> -->
                              <!-- 9/21/11 WS for RA: removed Freeform tab
                                 <td class="{if(matches($smode,'freeform')) then 'tab-select' else 'tab'}"><a href="search?smode=freeform">Freeform</a></td>
                              -->
                              <!--<td class="{if(matches($smode,'browse')) then 'tab-select' else 'tab'}">
                                 <a href="search?browse-all=yes">
                                    <xsl:text>Browse</xsl:text>
                                 </a>-->
                                 <!--<a href="search?smode=browse">Browse</a>
                              </td>
                           </tr>
                           <tr>
                              <td colspan="4">-->
                                 <div class="form">
                                    <xsl:choose>
                                       <xsl:when test="matches($smode,'simple')">
                                          <xsl:call-template name="simpleForm"/>
                                       </xsl:when>
                                       <xsl:when test="matches($smode,'advanced')">
                                          <xsl:call-template name="advancedForm"/>
                                       </xsl:when>
                                       <xsl:when test="matches($smode,'freeform')">
                                          <xsl:call-template name="freeformForm"/>
                                       </xsl:when>
                                       <xsl:when test="matches($smode,'browse')">
                                          <xsl:call-template name="browseLinks"/>
                                       </xsl:when>
                                    </xsl:choose>
                                 </div>
                              <!--</td>
                           </tr>
                        </table>-->
                     </div>
                  </div>
                  <xsl:copy-of select="$brand.feedback"/>
                  <xsl:copy-of select="$brand.footer"/>
               </body>
            </html>
         <!--</xsl:otherwise>
      </xsl:choose>-->
   </xsl:template>
   
   <!-- simple form -->
   <xsl:template name="simpleForm" exclude-result-prefixes="#all">
      <form method="get" action="{$xtfURL}{$crossqueryPath}">
         <div class="home">
            <div id="about">
               <div class="aboutButton dropdownButton"><h3>About</h3></div>
               <div class="aboutContent dropdownContent">
                  <ul>
                  <li><a href="#archivalMat" class="archivalMat"
                     onClick="_gaq.push(['_trackEvent', 'about', 'view', 'archival materials']);"
                     >Archival Materials</a></li>
                     <li><a href="#holdings" class="holdings" onClick="_gaq.push(['_trackEvent', 'about', 'view', 'our collections']);">Our Collections</a></li>
                  <li><a href="#dscDescription" class="dscDescription"
                     onClick="_gaq.push(['_trackEvent', 'about', 'view', 'collection guides']);"
                     >Collection Guides</a></li>
                  <li><a href="#dimes" class="dimes"
                     onClick="_gaq.push(['_trackEvent', 'about', 'view', 'website name']);">This
                     Website's Name</a></li>
                     <li><a href="#license" class="license" onClick="_gaq.push(['_trackEvent', 'about', 'view', 'license']);">Licensing for our Descriptive Metadata</a></li>
                     <li><a href="#takedown" class="takedown" onClick="_gaq.push(['_trackEvent', 'about', 'view', 'takedown']);">Our Take-Down Policy</a></li>
                  </ul>
               </div>
               
            </div>
            <div id="searchTop">
               <div id="searchtip" class="box">
                  <ul>
                     <li>Want help? See these
                        <a href="#searchTips" class="searchTips"
                           onClick="_gaq.push(['_trackEvent', 'about', 'view', 'search tips on home page']);"
                           >search tips</a>.
                     </li>
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
                           <option value="ead">Archival Collections</option>
                           <option value="dao">Digital Materials</option>
                           <option value="mods">Library Materials</option>
                        </select>
                        <!-- 6/21/2013 HA: adding advanced search to home page -->
                        <select name="sectionType" id="library">
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
                     <!--<input type="hidden" name="smode" value="advanced" id="start"/>-->
                     <div class="showAdvanced open">
                        <a href="#">close</a>
                     </div>
                  </div>
                  <input class="searchbox" type="submit" value="Search" onClick="_gaq.push(['_trackEvent', 'search', 'keyword', 'home page']);"/>
                  <!--<input type="hidden" value="series" name="level"/>-->
                  <!-- 6/30/2013 HA: removing clear button <input type="reset" onclick="location.href='{$xtfURL}{$crossqueryPath}'" value="Clear"/> -->
                  <!-- Uncomment and complete code when digital objects are included -->
                  <!--    <input type="checkbox" id="dao"/> Search only digitized material-->
                  <a href="#" class="showAdvanced closed" onClick="_gaq.push(['_trackEvent', 'search', 'advanced', 'home page']);">show more search options</a>
               </div>
            </div>
            
            <div id="browse" class="box">
               <h2>Browse</h2>
               <div class="accordionButton category"><h3><img src="/xtf/icons/default/collections.gif" alt="archival collections" height="25px"/>Archival Collections</h3></div>
                  <div class="accordionContent">
                     <li class="browseOption"><a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=ead" onClick="_gaq.push(['_trackEvent', 'search', 'browse', 'archival']);">Browse All</a></li>
                     <li class="browseOption"><a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title&amp;browse-all=yes;level=collection;type=ead" onClick="_gaq.push(['_trackEvent', 'search', 'browse', 'archival-title']);">By Title</a></li>
                     <li class="browseOption"><a href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=title&amp;browse-all=yes;level=collection;type=ead" onClick="_gaq.push(['_trackEvent', 'search', 'browse', 'archival-creator']);">By Creator</a></li>
                  </div>
               <div class="accordionButton category"><h3><img src="/xtf/icons/default/book.gif" alt="library materials" height="25px"/>Library Materials</h3></div>
                  <div class="accordionContent">
                     <li class="browseOption"><a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=collection;type=mods" onClick="_gaq.push(['_trackEvent', 'search', 'browse', 'library']);">Browse All</a></li>
                     <li class="browseOption"><a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title&amp;browse-all=yes;level=collection;type=mods" onClick="_gaq.push(['_trackEvent', 'search', 'browse', 'library-title']);">By Title</a></li>
                     <li class="browseOption"><a href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=title&amp;browse-all=yes;level=collection;type=mods" onClick="_gaq.push(['_trackEvent', 'search', 'browse', 'library-creator']);">By Creator</a></li>
                  </div>
               <div class="accordionButton category"><h3><img src="/xtf/icons/default/dao_large.gif" alt="digital materials" height="25px"/>Digital Materials</h3></div>
                  <div class="accordionContent">
                     <li class="browseOption"><a href="{$xtfURL}{$crossqueryPath}?sort=title&amp;browse-all=yes;level=file;type=dao" onClick="_gaq.push(['_trackEvent', 'search', 'browse', 'digital']);">Browse All</a></li>
                     <li class="browseOption"><a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title&amp;browse-all=yes;level=file;type=dao" onClick="_gaq.push(['_trackEvent', 'search', 'browse', 'digital-title']);">By Title</a></li>
                     <li class="browseOption"><a href="{$xtfURL}{$crossqueryPath}?browse-creator=first;sort=title&amp;browse-all=yes;level=file;type=dao" onClick="_gaq.push(['_trackEvent', 'search', 'browse', 'digital-creator']);">By Creator</a></li>
                  </div>
            </div>
            
            <div id="featured" class="box">
               <h2>From our collections</h2>
               <img src="/xtf/icons/default/featured/dimes.jpg" alt="John D. Rockefeller handing out dimes"></img>
               <p id="caption">John D. Rockefeller handing out dimes, the inspiration for this <a href="#dimes" class="dimes"
                  onClick="_gaq.push(['_trackEvent', 'about', 'view', 'website name']);">website's name</a>.</p>
            </div>

            <div id="news" class="box">
               <h2>News</h2>
               <ul>
                  <li>Guides for many Rockefeller University collections are <a
                        href="/xtf/search?text=rockefeller%20university;sectionType=title;smode=advanced;type=ead"
                        >now available</a>.</li>
                  <li>Guides for selected Ford Foundation collections are <a
                        href="/xtf/search?text=ford%20foundation;sectionType=title;type=ead"
                        >now available</a>.</li>
                  <li>Check out our website celebrating the <a href="http://rockefeller100.org/"
                        >Rockefeller Foundation's Centennial</a>, with lots of digitized
                     material!</li>
                  <li> View <a
                        href="{$xtfURL}{$crossqueryPath}?sort=dateStamp&amp;browse-all=yes;level=collection;type=ead"
                        onClick="_gaq.push(['_trackEvent', 'search', 'browse', 'archival-updated']);"
                        >Recently Updated Collections</a>. </li>
               </ul>
            </div>
            
            <div id="disclaimer">
               <p>We are still in the process of adding collections information to DIMES. Some
                  large collections, like those of the Ford Foundation, Population Council, and
                  Rockefeller University, are only partially represented; other
                  smaller collections, including some collections of personal papers and grant
                  records for the Ford Foundation, are not yet represented at all. Please <a
                     href="http://rockarch.org/about/contact.php">contact archival staff</a> for
                  further information.</p>
            </div>

         </div>
               
                  <!-- 9/21/11 WS: Moved to Advanced Search tab
                  <table class="sampleTable">
                     <tr>
                        <td colspan="2">Examples:</td>                  
                     </tr>
                     <tr>
                        <td class="sampleQuery">africa</td>
                        <td class="sampleDescrip">Search keywords (full text and metadata) for 'africa'</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">south africa</td>
                        <td class="sampleDescrip">Search keywords for 'south' AND 'africa'</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">"south africa"</td>
                        <td class="sampleDescrip">Search keywords for the phrase 'south africa'</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">africa*</td>
                        <td class="sampleDescrip">Search keywords for the string 'africa' followed by 0 or more characters</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">africa?</td>
                        <td class="sampleDescrip">Search keywords for the string 'africa' followed by a single character</td>
                     </tr>
                  </table>
                  -->
      </form>
     </xsl:template>
   
   <!-- advanced form -->
   <xsl:template name="advancedForm" exclude-result-prefixes="#all">
      <form method="get" action="{$xtfURL}{$crossqueryPath}">
         <table class="advancedSearch">
            <tr>
               <td style="text-align:right; padding-right:36px; width:200px">
                  <strong>Search full text:</strong>
               </td>
               <td>
                  <input type="text" name="text" size="60" value="{$text}"/>&#160;
                  <select name="type" id="type">
                     <option value="">All Materials</option>
                     <option value="ead">Archival Collections</option>
                     <option value="dao">Digital Materials</option>
                     <option value="mods">Library Materials</option>
                  </select>
                  &#160;
                  <select name="sectionType" id="library">
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
                  </select>
                  <br/>
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
                  <p/>
               </td>
            </tr>
            <tr>
               <td style="text-align:right; padding-right:36px;">
                  <strong>Year(s):</strong>
               </td>
               <td><input type="text" name="year" size="60" value="{$year}"/></td>
               <!-- 
                  <input type="text" name="s" id="s" 
                  value="Text to be displayed here" 
                  onfocus="if(this.value==this.defaultValue)this.value='';" 
                  onblur="if(this.value=='')this.value=this.defaultValue;"/>
               -->
            </tr>
            <tr><td></td><td><p class="searchtip">Enter a single year or range of years, for example 1997 or 1892-1942.</p></td></tr>
            <tr>
               <td>&#160;</td>
               <td colspan="2">
                  <input type="submit" value="Search"/>
                  <input type="hidden" name="smode" value="advanced" id="start"/>
                  <input type="reset" OnClick="location.href='{$xtfURL}{$crossqueryPath}'" value="Clear"/>
               </td>
             </tr>
            <tr>
               <td>&#160;</td>
               <td class="searchtiplink">
                  <a href="#" rel="#searchTips">Search Tips and Tricks</a>
            </td>
            </tr>            
         </table>  
      </form>
   </xsl:template>
   
   <!-- free-form form -->
   <xsl:template name="freeformForm" exclude-result-prefixes="#all">
      <form method="get" action="{$xtfURL}{$crossqueryPath}">
         <table>
            <tr>
               <td>
                  <p><i>Experimental feature:</i> "Freeform" complex query supporting -/NOT, |/OR, &amp;/AND, field names, and parentheses.</p>
                  <input type="text" name="freeformQuery" size="40" value="{$freeformQuery}"/>
                  <xsl:text>&#160;</xsl:text>
                  <input type="submit" value="Search"/>
                  <input type="reset" onclick="location.href='{$xtfURL}{$crossqueryPath}'" value="Clear"/>
               </td>
            </tr>
            <tr>
               <td>
                  <table class="sampleTable">
                     <tr>
                        <td colspan="2">Examples:</td>                  
                     </tr>
                     <tr>
                        <td class="sampleQuery">africa</td>
                        <td class="sampleDescrip">Search keywords (full text and metadata) for 'africa'</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">south africa</td>
                        <td class="sampleDescrip">Search keywords for 'south' AND 'africa'</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">south &amp; africa</td>
                        <td class="sampleDescrip">(same)</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">south AND africa</td>
                        <td class="sampleDescrip">(same; note 'AND' must be capitalized)</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">title:south africa</td>
                        <td class="sampleDescrip">Search title for 'south' AND 'africa'</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">creator:moodley title:africa</td>
                        <td class="sampleDescrip">Search creator for 'moodley' AND title for 'africa'</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">south | africa</td>
                        <td class="sampleDescrip">Search keywords for 'south' OR 'africa'</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">south OR africa</td>
                        <td class="sampleDescrip">(same; note 'OR' must be capitalized)</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">africa -south</td>
                        <td class="sampleDescrip">Search keywords for 'africa' not near 'south'</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">africa NOT south</td>
                        <td class="sampleDescrip">(same; note 'NOT' must be capitalized)</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">title:africa -south</td>
                        <td class="sampleDescrip">Search title for 'africa' not near 'south'</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">title:africa subject:-politics</td>
                        <td class="sampleDescrip">
                           Search items with 'africa' in title but not 'politics' in subject.
                           Note '-' must follow ':'
                        </td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">title:-south</td>
                        <td class="sampleDescrip">Match all items without 'south' in title</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">-africa</td>
                        <td class="sampleDescrip">Match all items without 'africa' in keywords</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">south (africa OR america)</td>
                        <td class="sampleDescrip">Search keywords for 'south' AND either 'africa' OR 'america'</td>
                     </tr>
                     <tr>
                        <td class="sampleQuery">south africa OR america</td>
                        <td class="sampleDescrip">(same, due to precedence)</td>
                     </tr>
                  </table>
               </td>
            </tr>
         </table>
      </form>
   </xsl:template>
   
  
   <!-- 
      <xsl:when test="$doc.view='collectionGuides'">
      <xsl:call-template name="collectionGuides"/>
      </xsl:when>
      <xsl:when test="$doc.view='archivalMat'">
      <xsl:call-template name="archivalMat"/>
      </xsl:when>
   -->
</xsl:stylesheet>
