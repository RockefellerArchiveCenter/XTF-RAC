<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:session="java:org.cdlib.xtf.xslt.Session" 
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
      <xsl:choose>
         <xsl:when test="$smode='collectionGuides'">
            <xsl:call-template name="collectionGuides"/>
         </xsl:when>
         <xsl:when test="$smode='archivalMat'">
            <xsl:call-template name="archivalMat"/>
         </xsl:when>
         <xsl:otherwise>
            <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
               <head>
                  <title>RAC: Search Collection Guides</title>
                  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                  <xsl:copy-of select="$brand.links"/>
               </head>
               <body>
                  <xsl:copy-of select="$brand.header"/>
                  <h1 id="collectionGuides">
                     <a href="/xtf/search">
                        <span></span>
                        Collection Guides
                     </a>
                  </h1>
                  <div class="bookbag">
                     <xsl:if test="$smode != 'showBag'">
                        <xsl:variable name="bag" select="session:getData('bag')"/>
                        <a href="{$xtfURL}{$crossqueryPath}?smode=showBag">Bookbag</a>
                        (<span id="bagCount"><xsl:value-of select="count($bag/bag/savedDoc)"/></span>)
                     </xsl:if>
                  </div>
                  <div class="searchPage">
                     <div class="forms">
                        <table>
                           <tr>
                              <td class="{if(matches($smode,'simple')) then 'tab-select' else 'tab'}"><a href="search?smode=simple">Keyword</a></td>
                              <td class="{if(matches($smode,'advanced')) then 'tab-select' else 'tab'}"><a href="search?smode=advanced">Advanced</a></td>
                              <!-- 9/21/11 WS for RA: removed Freeform tab
                                 <td class="{if(matches($smode,'freeform')) then 'tab-select' else 'tab'}"><a href="search?smode=freeform">Freeform</a></td>
                              -->
                              <td class="{if(matches($smode,'browse')) then 'tab-select' else 'tab'}">
                                 <!--<a href="search?browse-all=yes">
                                    <xsl:text>Browse</xsl:text>
                                 </a>-->
                                 <a href="search?smode=browse">Browse</a>
                              </td>
                           </tr>
                           <tr>
                              <td colspan="4">
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
                                          <table>
                                             <tr>
                                                <td>
                                                   <p>Browse all documents by the available facets, or alphanumerically by author or title:</p>
                                                </td>
                                             </tr>
                                             <tr>
                                                <td>
                                                   <xsl:call-template name="browseLinks"/>
                                                </td>
                                             </tr>
                                          </table>
                                       </xsl:when>
                                    </xsl:choose>
                                 </div>
                              </td>
                           </tr>
                        </table>
                     </div>
                  </div>
                  <xsl:copy-of select="$brand.footer"/>
               </body>
            </html>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- simple form -->
   <xsl:template name="simpleForm" exclude-result-prefixes="#all">
      <form method="get" action="{$xtfURL}{$crossqueryPath}">
         <table>
            <tr>
               <td colspan="2">
                  <input type="text" name="keyword" size="40" value="{$keyword}"/>
                  <xsl:text>&#160;</xsl:text>
                  <input type="submit" value="Search"/>
                  <input type="reset" onclick="location.href='{$xtfURL}{$crossqueryPath}'" value="Clear"/>
                  <p>
                     <br/>
                 <!-- Uncomment and complete code when digital objects are included -->    
                 <!--    <input type="checkbox" id="dao"/> Search only digitized material-->
                  </p>
               </td>
               <td>
                  <ul class="nomark">
                     <!-- make popups, need text -->
                     <li>
                           <a href="javascript:openWin('{$xtfURL}{$crossqueryPath}?smode=collectionGuides')">About Collection Guides</a>
                     </li>
                     <li>
                        <a href="javascript:openWin('{$xtfURL}{$crossqueryPath}?smode=archivalMat')">About Archival Materials</a>
                     </li>
                     <li>
                        <a href="http://www.rockarch.org/collections/" target="_blank">Looking for our old collection guide pages?</a>
                     </li>
                  </ul>
               </td>
            </tr>
            <tr>
               <td colspan="3">
                  <h4>The Rockefeller Archive Center Holdings</h4>
                  <p>The Rockefeller Archive Center holdings encompass the records of the Rockefeller family and their wide-ranging philanthropic endeavors (including the Rockefeller Foundation, the Rockefeller Brothers Fund and Rockefeller University). Today, the Center's growing holdings include materials from numerous non-Rockefeller foundations and nonprofit organizations, making it a premier center for research on philanthropy and civil society. It is also a major repository for the personal papers of leaders of the philanthropic community, Nobel Prize laureates, and world-renowned investigators in science and medicine.
                  </p>
                  <p><strong>Researchers should note that collection guides may not identify collections or portions of collections whose access or use is restricted. When a researcher requests an appointment to visit the Center, the Head of Processing or Head of Reference will verify that the desired materials are open and available for research. 
                  </strong></p>
               </td>
            </tr>
            <tr>
               <td>
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
               </td>
            </tr>
         </table>
      </form>
   </xsl:template>
   
   <!-- advanced form -->
   <xsl:template name="advancedForm" exclude-result-prefixes="#all">
      <form method="get" action="{$xtfURL}{$crossqueryPath}">
         <table class="top_table">
            <tr>
               <td>
                  <table class="left_table">
                     <tr>
                        <td colspan="3">
                           <h4>Entire Text</h4>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td colspan="2">
                           <input type="text" name="text" size="30" value="{$text}"/>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td colspan="2">
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
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td><b>Exclude</b></td>
                        <td>
                           <input type="text" name="text-exclude" size="20" value="{$text-exclude}"/>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td><b>Proximity</b></td>
                        <td>
                           <select size="1" name="text-prox">
                              <xsl:choose>
                                 <xsl:when test="$text-prox = '1'">
                                    <option value=""></option>
                                    <option value="1" selected="selected">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                 </xsl:when>
                                 <xsl:when test="$text-prox = '2'">
                                    <option value=""></option>
                                    <option value="1">1</option>
                                    <option value="2" selected="selected">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                 </xsl:when>
                                 <xsl:when test="$text-prox = '3'">
                                    <option value=""></option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3" selected="selected">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                 </xsl:when>
                                 <xsl:when test="$text-prox = '4'">
                                    <option value=""></option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4" selected="selected">4</option>
                                    <option value="5">5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                 </xsl:when>
                                 <xsl:when test="$text-prox = '5'">
                                    <option value=""></option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5" selected="selected">5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                 </xsl:when>
                                 <xsl:when test="$text-prox = '10'">
                                    <option value=""></option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="10" selected="selected">10</option>
                                    <option value="20">20</option>
                                 </xsl:when>
                                 <xsl:when test="$text-prox = '20'">
                                    <option value=""></option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="10">10</option>
                                    <option value="20" selected="selected">20</option>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <option value="" selected="selected"></option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </select>
                           <xsl:text> word(s)</xsl:text>
                        </td>
                     </tr>           
                     <tr>
                        <td class="indent">&#160;</td>
                        <td><b>Section</b></td>
                        <td>
                           <xsl:choose>
                              <xsl:when test="$sectionType = 'head'">
                                 <input type="radio" name="sectionType" value=""/><xsl:text> any </xsl:text><br/>
                                 <input type="radio" name="sectionType" value="head" checked="checked"/><xsl:text> headings </xsl:text><br/>
                                 <input type="radio" name="sectionType" value="citation"/><xsl:text> citations </xsl:text>
                              </xsl:when>
                              <xsl:when test="$sectionType = 'note'"> 
                                 <input type="radio" name="sectionType" value=""/><xsl:text> any </xsl:text><br/>
                                 <input type="radio" name="sectionType" value="head"/><xsl:text> headings </xsl:text><br/>
                                 <input type="radio" name="sectionType" value="citation" checked="checked"/><xsl:text> citations </xsl:text>
                              </xsl:when>
                              <xsl:otherwise>
                                 <input type="radio" name="sectionType" value="" checked="checked"/><xsl:text> any </xsl:text><br/>
                                 <input type="radio" name="sectionType" value="head"/><xsl:text> headings </xsl:text><br/>
                                 <input type="radio" name="sectionType" value="citation"/><xsl:text> citations </xsl:text>
                              </xsl:otherwise>
                           </xsl:choose>
                        </td>
                     </tr>
                  </table>
               </td>
               <td>
                  <table class="right_table">
                     <tr>
                        <td colspan="3"><h4>Metadata</h4></td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td><b>Title</b></td>
                        <td>
                           <input type="text" name="title" size="20" value="{$title}"/>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td><b>Author</b></td>
                        <td>
                           <input type="text" name="creator" size="20" value="{$creator}"/>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td><b>Subject</b></td>
                        <td>
                           <input type="text" name="subject" size="20" value="{$subject}"/>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td><b>Year(s)</b></td>
                        <td>
                           <xsl:text>From </xsl:text>
                           <input type="text" name="year" size="4" value="{$year}"/>
                           <xsl:text> to </xsl:text>
                           <input type="text" name="year-max" size="4" value="{$year-max}"/>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td><b>Type</b></td>
                        <td>
                           <select size="1" name="type">
                              <option value="">All</option>
                              <option value="ead">EAD</option>
                              <option value="html">HTML</option>
                              <option value="word">Word</option>
                              <option value="nlm">NLM</option>
                              <option value="pdf">PDF</option>
                              <option value="tei">TEI</option>
                              <option value="text">Text</option>
                           </select>
                        </td>
                     </tr>
                     <tr>
                        <td colspan="3">&#160;</td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td>&#160;</td>
                        <td>
                           <input type="hidden" name="smode" value="advanced"/>
                           <input type="submit" value="Search"/>
                           <input type="reset" onclick="location.href='{$xtfURL}{$crossqueryPath}?smode=advanced'" value="Clear"/>
                        </td>
                     </tr>
                  </table>
               </td>
            </tr>
            <tr>
               <td colspan="2">
                  <table class="sampleTable">
                     <tr>
                        <td colspan="3">Examples:</td>                  
                     </tr>
                     <tr>
                        <td/>
                        <td class="sampleQuery">south africa</td>
                        <td class="sampleDescrip">Search full text for 'south' AND 'africa'</td>
                     </tr>
                     <tr>
                        <td>Exclude</td>
                        <td class="sampleQuery">race</td>
                        <td class="sampleDescrip">Exclude results which contain the term 'race'</td>
                     </tr>
                     <tr>
                        <td>Proximity</td>
                        <td><form action=""><select><option>5</option></select></form></td>
                        <td class="sampleDescrip">Match the full text terms, only if they are 5 or fewer words apart</td>
                     </tr>
                     <tr>
                        <td>Section</td>
                        <td><form action=""><input type="radio" checked="checked"/>headings</form></td>
                        <td class="sampleDescrip">Match the full text terms, only if they appear in document 'headings' (e.g. chapter titles)</td>
                     </tr>
                     <tr>
                        <td>Title</td>
                        <td class="sampleQuery">"south africa"</td>
                        <td class="sampleDescrip">Search for the phrase 'south africa' in the 'title' field</td>
                     </tr>
                     <tr>
                        <td>Year(s)</td>
                        <td><form action="">from <input type="text" value="2000" size="4"/> to <input type="text" value="2005" size="4"/></form></td>
                        <td class="sampleDescrip">Search for documents whose date falls in the range from '2000' to '2005'</td>
                     </tr>
                  </table>
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
   
   <!-- collection guides -->
   <xsl:template name="collectionGuides">
      <html xml:lang="en" lang="en">
         <head>
            <title/>
            <link rel="stylesheet" type="text/css" href="{$css.path}racustom.css"/>
         </head>
         <body>      
            <div class="dscDescription">
               <h4>About Collection Guides</h4>
               <p>Collection guides are documents that describe and map archival material held at a particular institution. Researchers use collection guides to find and identify archival holdings that may be pertinent to their research.</p>
               <p>Most collection guides include background information on the person or institution responsible for the creation of the records; a description of the contents, strengths, and weaknesses of the collection; as well as information on how the collection is arranged, how it has been managed, and how researchers can access and use it.</p>
               <p>Collection guides are only pointers to archival material. They describe the collection and its arrangement, but rarely the individual items contained within it. In many cases it is only by examining a file that one can know its exact contents. Most archival material at the RAC is not digitized and must be consulted on site. Researchers are invited to schedule an appointment to examine our holdings.</p>
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
   
   <!-- archival materials -->
   <xsl:template name="archivalMat">
      <html xml:lang="en" lang="en">
         <head>
            <title/>
            <link rel="stylesheet" type="text/css" href="{$css.path}racustom.css"/>
         </head>
         <body>      
            <div class="dscDescription">
               <h4>About Archival Materials</h4>
               <p>Archival holdings are generally comprised of original, unpublished material of enduring value created by a person, family, or organization. This material often includes primary source records and firsthand accounts of events and transactions. Archival material may include a variety of media or formats such as correspondence, memos, reports, bound diaries, scrapbooks, maps, blueprints, photographic negatives and prints, films, VHS or audio tapes, or electronic records.</p>
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
      <xsl:when test="$doc.view='collectionGuides'">
      <xsl:call-template name="collectionGuides"/>
      </xsl:when>
      <xsl:when test="$doc.view='archivalMat'">
      <xsl:call-template name="archivalMat"/>
      </xsl:when>
   -->
</xsl:stylesheet>
