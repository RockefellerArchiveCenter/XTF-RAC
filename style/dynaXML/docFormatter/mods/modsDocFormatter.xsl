<xsl:stylesheet version="2.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xtf="http://cdlib.org/xtf"
   xmlns:html="http://www.w3.org/1999/xhtml"
   xmlns:mods="http://www.loc.gov/mods/v3"
   xmlns="http://www.w3.org/1999/xhtml"
   xmlns:session="java:org.cdlib.xtf.xslt.Session"
   extension-element-prefixes="session"
   exclude-result-prefixes="#all">
   <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
   <!-- MODS dynaXML Stylesheet                                                -->
   <!-- Author: Winona Salesky wsalesky@gmail.com                              -->
   <!-- Date:   10/10/12                                                       -->
   <!--         Created for  for Rockefeller Archives Center                   -->
	<!-- 
	   This files goes in  /var/lib/tomcat6/webapps/xtf/style/dynaXML/docFormatter/mods/
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
 
   
   <!-- ====================================================================== -->
   <!-- Import Common Templates                                                -->
   <!-- ====================================================================== -->
   
   <xsl:import href="../common/docFormatterCommon.xsl"/>
   
   <!-- ====================================================================== -->
   <!-- Output Format                                                          -->
   <!-- ====================================================================== -->
   
   <xsl:output method="xhtml" indent="yes" 
      encoding="UTF-8" media-type="text/html; charset=UTF-8" 
      doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" 
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
      exclude-result-prefixes="#all"
      omit-xml-declaration="yes"/>
   
   <!-- ====================================================================== -->
   <!-- Strip Space                                                            -->
   <!-- ====================================================================== -->
   
   <xsl:strip-space elements="*"/>
   
   <!-- ====================================================================== -->
   <!-- Included Stylesheets                                                   -->
   <!-- ====================================================================== -->

   <xsl:include href="parameter.xsl"/>
   <xsl:include href="search.xsl"/>
   <xsl:include href="modsToHTML.xsl"/>
   
   <!-- ====================================================================== -->
   <!-- Define Keys                                                            -->
   <!-- ====================================================================== -->
   
   <xsl:key name="chunk-id" match="*[parent::mods:mods]" use="@id"/>
   
   <!-- ====================================================================== -->
   <!-- MODS-specific parameters                                                -->
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
   
   <xsl:param name="parentID"/>  
   <!-- ====================================================================== -->
   <!-- Root Template                                                          -->
   <!-- ====================================================================== -->
   
   <xsl:template match="/mods:mods">
      <xsl:choose>
         <!-- robot solution -->
         <xsl:when test="matches($http.user-agent,$robots)">
            <xsl:call-template name="robot"/>
         </xsl:when>
         <!-- Creates the body.-->
         <xsl:when test="$doc.view = 'content'">
            <xsl:call-template name="body"/>
         </xsl:when>
         <!-- pdf view -->
         <xsl:when test="$doc.view='print'">
            <xsl:call-template name="print"/>
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
               <script src="script/yui/yahoo-dom-event.js" type="text/javascript"/> 
               <script src="script/yui/connection-min.js" type="text/javascript"/> 
               <xsl:copy-of select="$brand.links"/>
               <title><xsl:value-of select="mods:titleInfo/mods:title"/></title>
            </head>
            <body>
               <xsl:copy-of select="$brand.header"/>
               <div id="header">
                  <img src="http://www.rockarch.org/images/RAC-logo.png" width="103" height="140"
                     alt="The Rockefeller Archive Center" border="0"/>
                  <a href="/xtf/search">
                     <h1>dimes.rockarch.org</h1>
                     <p class="tagline">The Online Collections and Catalog of Rockefeller Archive
                        Center</p>
                  </a>
               </div>
               
               <div id="bookbag">
                  <xsl:variable name="bag" select="session:getData('bag')"/>
                  <a href="{$xtfURL}{$crossqueryPath}?smode=showBag"
                     onClick="_gaq.push(['_trackEvent', 'interaction', 'view', 'bookbag']);">
                     <img src="/xtf/icons/default/bookbag.gif" alt="Bookbag"
                        style="vertical-align:bottom;"/>
                  </a>
                  <span>(<span id="bagCount"><xsl:value-of
                     select="count(session:getData('bag')/child::*/child::*)"/></span>)</span>
               </div>
               
                  <xsl:call-template name="bbar_custom"/>
               
               <div class="main">
                  <xsl:call-template name="toc"/>
                  <xsl:call-template name="body"/>
               </div>
               <xsl:copy-of select="$brand.feedback"/>
               <div class="fixedFooter"><xsl:copy-of select="$brand.footer"/></div>
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
               <xsl:value-of select="number(/mods:mods/@xtf:hitCount)"/>
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
         <div class="documentTitle">
            <xsl:attribute name="style">
               <xsl:choose>
                  <xsl:when test="/mods:mods/mods:genre[contains(.,'Volume')]">background:
                     url(/xtf/icons/default/book.gif) left no-repeat;</xsl:when>
                  <xsl:when test="/mods:mods/mods:genre[contains(.,'DVD')]">background:
                     url(/xtf/icons/default/video.gif) left no-repeat;</xsl:when>
                  <xsl:when test="/mods:mods/mods:genre[contains(.,'Videocassette')]">background:
                     url(/xtf/icons/default/video.gif) left no-repeat;</xsl:when>
                  <xsl:when test="/mods:mods/mods:genre[contains(.,'Reel')]">background:
                     url(/xtf/icons/default/microfilm.gif) left no-repeat;</xsl:when>
               </xsl:choose>
               <xsl:text>min-height: 50px;</xsl:text>
            </xsl:attribute>
            <h1>
               <xsl:if
                  test="string-length(/mods:mods/mods:titleInfo[not(@type)]/mods:title) &gt; 125">
                  <xsl:attribute name="style"> font-size:1.15em; </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="/mods:mods/mods:titleInfo[not(@type)]/mods:title"/>
            </h1>
         </div>
         <div class="headerIcons">
            <ul>
               <li>
                  <xsl:variable name="identifier" select="/mods:mods/mods:identifier[1]"/>
                  <xsl:variable name="indexId" select="$identifier"/>
                  <xsl:choose>
                     <xsl:when test="session:getData('bag')/bag/savedDoc[@id=$indexId]">
                        <img src="/xtf/icons/default/addbag.gif" alt="Add to bookbag"
                           title="Added to bookbag"/>
                        <span class="caption">Added</span>
                     </xsl:when>
                     <xsl:otherwise>
                        <script type="text/javascript">
                                    add_1 = function() {
                                       var span = YAHOO.util.Dom.get('add_1');
                                       span.innerHTML = "Adding...";
                                       YAHOO.util.Connect.asyncRequest('GET', 
                                          '<xsl:value-of select="concat($xtfURL, 'search?smode=addToBag;identifier=', $identifier)"/>',
                                          {  success: function(o) { 
                                                span.innerHTML = o.responseText;
                                                ++(YAHOO.util.Dom.get('bagCount').innerHTML);
                                             },
                                             failure: function(o) { span.innerHTML = 'Failed to add!'; }
                                          }, null);
                                    };
                                 </script>
                        <a href="javascript:add_1()"
                           onClick="_gaq.push(['_trackEvent', 'interaction', 'add-library', 'bookbag']);">
                           <img src="/xtf/icons/default/addbag.gif" alt="Add to bookbag"
                              title="Add to bookbag"/>
                        </a>
                        <span id="add_1" class="caption">
                           <a href="javascript:add_1()">Add</a>
                        </span>
                     </xsl:otherwise>
                  </xsl:choose>
               </li>
               <!-- Commented out citation until digital objects are added-->
               <!--
                           <a>
                           <xsl:attribute name="href">javascript://</xsl:attribute>
                           <xsl:attribute name="onclick">
                           <xsl:text>javascript:window.open('</xsl:text><xsl:value-of select="$xtfURL"/><xsl:value-of select="$dynaxmlPath"/><xsl:text>?docId=</xsl:text><xsl:value-of
                           select="$docId"/><xsl:text>;doc.view=citation</xsl:text><xsl:text>','popup','width=500,height=200,resizable=yes,scrollbars=no')</xsl:text>
                           </xsl:attribute>
                           <xsl:text>Citation</xsl:text>
                           </a>
                           <xsl:text> | </xsl:text>
                        -->
            </ul>
         </div>
         <div class="headerSearch">
         <xsl:if test="($query != '0') and ($query != '')">
            <div class="headerResults">
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
            <xsl:text> [</xsl:text>
            <a>
               <xsl:attribute name="href">
                  <xsl:value-of select="$doc.path"/>;brand=<xsl:value-of select="$brand"/>
               </xsl:attribute>
               <xsl:text>Clear Hits</xsl:text>
            </a>
            <xsl:text>]</xsl:text>
            <xsl:choose>
               <xsl:when test="$docId"/>
               <xsl:otherwise> &#160;[ <a href="{session:getData('queryURL')}"> Back to Search
                     Results </a> ] </xsl:otherwise>
            </xsl:choose>
            </div>
         </xsl:if>
      </div>
         <xsl:call-template name="tabs"/> 
      </div>
   </xsl:template>
   <xsl:template match="mods:titleproper/mods:num"><br/><xsl:value-of select="."/></xsl:template>
   <!-- ====================================================================== -->
   <!-- Tabs Templates                                                          -->
   <!-- ====================================================================== -->
   
   <xsl:template name="tabs">
         <xsl:variable name="content.href"><xsl:value-of select="$query.string"/>;brand=<xsl:value-of select="$brand"/><xsl:value-of select="$search"/></xsl:variable>
         <div class="tabs">
            <div class="tab select">Item Description</div>
         </div>
      
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- TOC Templates                                                          -->
   <!-- ====================================================================== -->
   
   <xsl:template name="toc">
      <xsl:call-template name="translate">
         <xsl:with-param name="resultTree"> 
            <div id="tocWrapper">
               <div id="toc">
                  <div class="contents">
                  <h4>Contents</h4>
                  <div class="tocRow"><a href="#overview"><div class="tocItem">Overview</div></a></div>
                     <div class="tocRow"><a href="#location"><div class="tocItem">Location</div></a></div>
                     <div class="tocRow"><a href="#details"><div class="tocItem">Details</div></a></div>
                  </div>
                  <div class="subjects">
                     <xsl:if test="mods:subject">
                        <h4>Subjects</h4>
                        <ul class="none">
                           <xsl:for-each select="mods:subject">
                              <xsl:for-each select="mods:topic">
                                 <li>
                                    <a href="{$xtfURL}search?browse-all=yes;f1-subject={.}">
                                       <xsl:apply-templates select="."/>
                                    </a>
                                 </li>
                              </xsl:for-each>
                              <xsl:for-each select="mods:name">
                                 <li>
                                    <a href="{$xtfURL}/search?browse-all=yes;f1-subjectname={child::*}">
                                       <xsl:for-each select="child::*">
                                          <xsl:apply-templates select="."/> 
                                       </xsl:for-each>
                                    </a>
                                 </li>
                              </xsl:for-each> 
                              <xsl:for-each select="mods:geographic">
                                 <li>
                                    <a href="{$xtfURL}/search?browse-all=yes;f1-geogname={.}">
                                       <xsl:apply-templates select="."/>
                                    </a>
                                 </li>
                              </xsl:for-each>                                             
                           </xsl:for-each>
                        </ul>
                     </xsl:if>
                  </div>
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
   <!-- DG:  5/17/12

<a href="{$xtfURL}{$dynaxmlPath}?{$content.href}&amp;doc.view=collection">Collection Description</a>
 <xsl:value-of select="$xtfURL"/><xsl:value-of select="$dynaxmlPath"/>?<xsl:value-of select="$content.href"/>


example:  http://192.168.50.18/xtf/view?docId=ead/FA068/FA068.xml;chunk.id=headerlink;brand=default&doc.view=collection


$query.string example - docId=ead/FA068/FA068.xml
$id = chunk.id value
content.href  = calculated later to be everything after "?"
document = FA068 eg.
$xtfURL + $dynaxmlPath =  http://192.168.50.18/xtf/view
   -->
      <xsl:param name="submenuID"/>
      <xsl:param name="name"/>
      <xsl:param name="id"/>
      <xsl:param name="nodes"/>
      <xsl:param name="indent" select="1"/>
      <xsl:variable name="hit.count" select="sum($nodes/@xtf:hitCount)"/>
     <!-- 5/17/2012 DG:  a new variable for the new href.
      Just use chunk.id and doc name for now
        -->
      <xsl:variable name="documentname2">
 					 <xsl:analyze-string select="$query.string" regex="(.*)ead/([A-Z0-9^/]+)/([A-Z0-9^/]+).xml" flags="i">

					 <!--   "/xtf/view\?docId=ead/([a-z0-9^/]+)/([a-z0-9^/]+).xml;query=;brand=default" -->
					
					    <xsl:matching-substring>
					     <xsl:value-of select="regex-group(2)" />
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
      <xsl:variable name="xtfURL2"> <!-- remove xtf/ from end, if there.  -->
 					 <xsl:analyze-string select="$xtfURL" regex="(.*)xtf/">
					    <xsl:matching-substring>
					      <xsl:value-of select="regex-group(1)" />
					    </xsl:matching-substring>
					    <xsl:non-matching-substring>
					      <xsl:value-of select="$xtfURL"/>
					    </xsl:non-matching-substring>
					  </xsl:analyze-string>
      </xsl:variable>
      <xsl:variable name="href2">
         <xsl:value-of select="concat($xtfURL2,$documentname2,'/',$basicchoice2)"/>
      </xsl:variable>
   <!--  end new  DG: Just created $href2 -->   

      <xsl:variable name="content.href"><xsl:value-of select="$query.string"/>;chunk.id=<xsl:value-of 
         select="$id"/>;brand=<xsl:value-of select="$brand"/>&amp;parentID=<xsl:value-of select="$submenuID"/><xsl:value-of 
            select="$search"/>&amp;doc.view=<xsl:value-of 
               select="$doc.view"/></xsl:variable>
      
      <xsl:if test="@id = $chunk.id">
         <a name="X"/>
      </xsl:if>
      <div class="tocItem">
         <div class="moreLess">
            <xsl:if
               test=".[@level='series' or @level='collection' or @level='recordgrp' or @level='fonds']">
               <xsl:if test="child::*[@level='subgrp' or @level='subseries' or @level='subfonds']">
                  <xsl:choose>
                     <xsl:when test="$parentID = $submenuID">
                        <a onclick="showHide('{$submenuID}');return false;" id="{$submenuID}-hide"
                           href="#">- </a>
                     </xsl:when>
                     <xsl:otherwise>
                        <a onclick="showHide('{$submenuID}');return false;" class="showLink"
                           id="{$submenuID}-show" href="#">+ </a>
                        <a class="more" onclick="showHide('{$submenuID}');return false;"
                           id="{$submenuID}-hide" href="#">- </a>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:if>
            </xsl:if>
         </div>
         <div class="tocLink">
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
                     <!-- if basicchoice2 = "nomatch_for_id" then use the original -->
                     <xsl:attribute name="href">
                        <!--   <xsl:value-of select="$xtfURL"/><xsl:value-of select="$dynaxmlPath"/>?<xsl:value-of select="$content.href"/>   (old had &amp;menu=more)-->
                        <xsl:choose>
                           <xsl:when test="$basicchoice2='nomatch_for_id'">
                              <xsl:value-of select="$xtfURL"/><xsl:value-of select="$dynaxmlPath"
                                 />?<xsl:value-of select="$content.href"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <!-- 5/17/12 DG for RA: rewrite -->
                              <xsl:value-of select="$href2"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                     <xsl:value-of select="$name"/>
                  </a>
               </xsl:when>
               <xsl:otherwise>
                  <a>
                     <xsl:attribute name="onclick">showHide('<xsl:value-of select="$submenuID"
                        />');</xsl:attribute>
                     <xsl:attribute name="href">
                        <xsl:choose>
                           <xsl:when test="($query != '0') and ($query != '')">
                              <xsl:value-of select="$xtfURL"/><xsl:value-of select="$dynaxmlPath"
                                 />?<xsl:value-of select="$content.href"/>
                           </xsl:when>
                           <xsl:when test="$basicchoice2='nomatch_for_id'">
                              <xsl:value-of select="$xtfURL"/><xsl:value-of select="$dynaxmlPath"
                                 />?<xsl:value-of select="$content.href"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$href2"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>

                     <xsl:value-of select="$name"/>
                  </a>
               </xsl:otherwise>
            </xsl:choose>
            <span class="hit-count">
               <xsl:if test="$hit.count"> (<xsl:value-of select="$hit.count"/>) </xsl:if>
            </span>
         </div>
      </div>
      
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
