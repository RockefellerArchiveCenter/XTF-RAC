<!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!-- Error page generation stylesheet                                       -->
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

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

   <xsl:output method="xhtml" indent="no" 
      encoding="UTF-8" media-type="text/html; charset=UTF-8" 
      doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" 
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" 
      exclude-result-prefixes="#all"
      omit-xml-declaration="yes"/>

<!-- =====================================================================
    
    When an error occurs (either authorization or an internal error),
    a stylesheet is used to produce a nicely formatted page for the
    requester. This tag specifies the path to the stylesheet, relative
    to the servlet base directory.

    The stylesheet receives one of the following mini-documents as input:

        <InvalidDocument>
            <docId>document identifier requested</docId>
        </InvalidDocument>

    or

        <NoPermission>
            <docId>document identifier requested</docId>
            <ipAddr>requester's IP address</ipAddr>
        </NoIPPermission>
        
    or

        <some general exception>
            <docId>document identifier requested</docId>
            <message>a descriptive error message (if any)</message>
            <stackTrace>HTML-formatted Java stack trace</stackTrace>
        </some general exception>

    For convenience, all of this information is also made available in XSLT
    parameters:

        $docId        Identifier of requested document

        $exception    Name of the exception that occurred - "InvalidDocument",
                      "NoPermission", or other names.

        $message      More descriptive details about what occurred

        $ipAddr       Requestor's IP address (if applicable)

        $stackTrace   JAVA stack trace for non-standard exceptions.

======================================================================= -->


<!-- ====================================================================== -->
<!-- Parameters                                                             -->
<!-- ====================================================================== -->

<xsl:param name="docId"/>
<xsl:param name="exception"/>
<xsl:param name="message"/>
<xsl:param name="ipAddr" select="''"/>
<xsl:param name="stackTrace" select="''"/>
<xsl:param name="smode"/>

<!-- ====================================================================== -->
<!-- Root Template                                                          -->
<!-- ====================================================================== -->

<!-- ======================================================================
    For this sample error generation stylesheet, we use the input mini-
    document instead of the parameters.
-->

<xsl:variable name="subDir" select="substring($docId, 9, 2)"/>

<xsl:variable name="sourceDir" select="concat('data/', $subDir, '/', $docId, '/')"/>

<xsl:variable name="METS" select="document(concat('../../', $sourceDir, $docId, '.mets.xml'))"/>


<xsl:variable name="project-name">
   <xsl:text>DIMES: Online Collections and Catalog of Rockefeller Archive Center</xsl:text>
</xsl:variable>

<xsl:variable name="reason">
  <xsl:choose>
    <xsl:when test="//InvalidDocument">
      <xsl:text>DIMES: Invalid Document</xsl:text>
    </xsl:when>
    <xsl:when test="//NoPermission">
      <xsl:text>DIMES: Permission Denied</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>DIMES: Servlet Error</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:template match="/">
   <xsl:choose>
      <xsl:when test="$smode = 'daoTable'">
         <p>missing <xsl:value-of select="$docId"/></p>
      </xsl:when>
      <xsl:otherwise>

  <html>
    <head>
      <title><xsl:value-of select="$reason"/></title>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <meta name="viewport" content="width=device-width,initial-scale=1"/>
      <link href='http://fonts.googleapis.com/css?family=Questrial' rel='stylesheet' type='text/css'/>
      <link rel="stylesheet" href="css/default/racustom.css" type="text/css"/>
      <link rel="stylesheet" href="css/default/results.css" type="text/css"/>
      <link rel="shortcut icon" href="icons/default/favicon.png"/>
      <link rel="stylesheet" rev="stylesheet" type="text/css"
        href="http://www.rockarch.org/css/globalStyle.css"/>
      <link rel="stylesheet" rev="stylesheet" type="text/css"
        href="http://www.rockarch.org/css/more.css"/>
    </head>

    <body>
      <!-- 7/12/13 HA: Changed to match updated RA header -->
      <div>
         <!--[if IE ]>
                  <div class="chromeframe"><p>You are using Microsoft Internet Explorer, which is not fully supported by this site. For better results, <a href="http://browsehappy.com/">use a different browser</a> or <a href="http://www.google.com/chromeframe/?redirect=true">install Google Chrome Frame</a> to better experience this site.</p></div>
                  <![endif]-->
      </div>
      <!--  *** Begin section: Sub-navigation ***  -->
      <!-- This begins ABOUT US SubMenu -->
      <div id="navOption0sub"
         style="visibility: hidden; position: absolute; right: 629px; top: 29px; z-index:99;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption0suba">
                     <table width="167" border="0" cellspacing="0" cellpadding="0" bgcolor="#777777">
                        <tr>
                           <td width="6">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="6" height="1" alt=""/>
                           </td>
                           <td width="155">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="http://www.rockarch.org/about/" class="subNav">Overview</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td width="6">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="6" height="1" alt=""/>
                           </td>
                        </tr>

                        <tr>
                           <td colspan="3" bgcolor="#ffffff">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="http://www.rockarch.org/research/inforesearch.php" class="subNav">General
                                 Information</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>

                        <tr>
                           <td colspan="3" bgcolor="#ffffff">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="http://www.rockarch.org/about/staff.php" class="subNav">Staff</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td colspan="3" bgcolor="#ffffff">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>

                        <tr>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="http://www.rockarch.org/about/careers.php" class="subNav">Employment
                                 Opportunities</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td colspan="3" bgcolor="#ffffff">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>

                        <tr>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="http://www.rockarch.org/about/contact.php" class="subNav">Contact Us</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                     </table>
                  </layer>
               </ilayer>
            </div>
         </layer>
      </div>

      <!-- This begins RESEARCH SubMenu -->
      <div id="navOption1sub"
         style="visibility: hidden; position: absolute; right: 132px; top: 29px; z-index:99;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption1suba">
                     <table width="167" border="0" cellspacing="0" cellpadding="0" bgcolor="#777777">

                        <tr>
                           <td width="6">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="6" height="1" alt=""/>
                           </td>
                           <td width="155">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="http://www.rockarch.org/research/inforesearch.php"
                                 onmouseover="dhtmlShow('navOption1sub_1', '5');" class="subNav"
                                 >Information for Researchers</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td width="6">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="6" height="1" alt=""/>
                           </td>
                        </tr>

                        <tr>
                           <td colspan="3" bgcolor="#ffffff">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="http://www.rockarch.org/research/inquiryform.php"
                                 onmouseover="dhtmlShow('navOption1sub_2', '5');" class="subNav"
                                 >Research Inquiries</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>

                        <!--  
                    
                    <tr><td colspan="3" bgcolor="#ffffff"><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td></tr>
					<tr>
						<td><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td>
						<td>
							<img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/><br/><a href="/grants/" onmouseover="dhtmlShow('navOption1sub_3', '5');" class="subNav">Grant Info</a><br/><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/></td>
						<td><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td>
					</tr>	
                    
                    -->

                        <!--
                    <tr><td colspan="3" bgcolor="#ffffff"><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td></tr>
					<tr>
						<td><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td>
						<td>
							<img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/><br/><a href="#" onmouseover="dhtmlShow('navOption1sub_4', '5');" class="subNav">Forms</a><br/><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/></td>
						<td><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td>
					</tr> -->

                        <tr>
                           <td colspan="3" bgcolor="#ffffff">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="http://www.rockarch.org/research/citations.php"
                                 onmouseover="dhtmlShow('navOption1sub_5', '5');" class="subNav"
                                 >Sample Citations</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                     </table>
                  </layer>
               </ilayer>
            </div>
         </layer>
      </div>


      <!-- This begins GRANTS SubMenu -->
      <div id="navOption2sub"
         style="visibility: hidden; position: absolute; right: 544px; top: 29px; z-index:99;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption2suba">
                     <table width="167" border="0" cellspacing="0" cellpadding="0" bgcolor="#777777">
                        <tr>
                           <td width="6">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="6" height="1" alt=""/>
                           </td>
                           <td width="155">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="http://www.rockarch.org/grants/" class="subNav">Overview</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td width="6">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="6" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td colspan="3" bgcolor="#ffffff">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="http://www.rockarch.org/grants/generalgia.php" class="subNav">Grant-in-Aid</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>

                        <tr>
                           <td colspan="3" bgcolor="#ffffff">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <!--				
                    <tr>
						<td><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td>
						<td>
							<img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/><br/><a href="/grants/hospitalgrant.php" class="subNav">Grants to Study the History of the Rockefeller University Hospital</a><br/><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/></td>
						<td><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td>
					</tr>		
					<tr><td colspan="3" bgcolor="#ffffff"><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td></tr> 

	-->

                        <!--
					<tr>
						<td><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td>
						<td>
							<img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/><br/><a href="/grants/scholarinresidence.php" class="subNav">Scholar-in-Residence Program</a><br/><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/></td>
						<td><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td>
					</tr>
					<tr><td colspan="3" bgcolor="#ffffff"><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td></tr>
					-->
                        <tr>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="http://www.rockarch.org/grants/ehrlichgrant.php" class="subNav">Grants to Support
                                 Research in the Paul Ehrlich Collection</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td colspan="3" bgcolor="#ffffff">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <!--
                    <tr>
						<td><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td>
						<td>
							<img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/><br/><a href="/grants/visitingarchivist.php" class="subNav">Fellowship for a Visiting Archivist from the Developing World</a><br/><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/></td>
						<td><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td>
					</tr>
					<tr><td colspan="3" bgcolor="#ffffff"><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td></tr>
                    -->
                        <tr>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="http://www.rockarch.org/research/inforesearch.php" class="subNav">Information for
                                 Researchers</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td colspan="3" bgcolor="#ffffff">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="http://www.rockarch.org/grants/currentawards.php" class="subNav">Grant Awards</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td colspan="3" bgcolor="#ffffff">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="http://www.rockarch.org/grants/essentials.php" class="subNav">&quot;Essentials of a
                                 Good Application&quot;</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>

                        <tr>
                           <td colspan="3" bgcolor="#ffffff">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="http://www.rockarch.org/publications/resrep/" class="subNav">Research Reports</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                     </table>
                  </layer>
               </ilayer>
            </div>
         </layer>
      </div>

      <!-- This begins COLLECTIONS SubMenu -->
      <div id="navOption3sub"
         style="visibility: hidden; position: absolute; right: 475px; top: 29px; z-index:99;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="161" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption3suba">
                     <table width="167" border="0" cellspacing="0" cellpadding="0" bgcolor="#777777">


                        <tr>
                           <td colspan="3" bgcolor="#ffffff">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="http://dimes.rockarch.org/xtf/search"
                                 onmouseover="dhtmlShow('navOption3sub_11', '11');" class="subNav"
                                 >Search All Collection Guides</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>

                        <tr>
                           <td colspan="3" bgcolor="#ffffff">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="#" onmouseover="dhtmlShow('navOption3sub_5', '11');"
                                 class="subNav">Foundations (A - F)</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>

                        <tr>
                           <td colspan="3" bgcolor="#ffffff">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="#" onmouseover="dhtmlShow('navOption3sub_6', '11');"
                                 class="subNav">Foundations (G - M)</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>

                        <tr>
                           <td colspan="3" bgcolor="#ffffff">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="#" onmouseover="dhtmlShow('navOption3sub_8', '11');"
                                 class="subNav">Foundations (N - Z)</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>

                        <tr>
                           <td colspan="3" bgcolor="#ffffff">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="#" onmouseover="dhtmlShow('navOption3sub_9', '11');"
                                 class="subNav">Other Organizations </a>

                              <br/>
                              <a href="#" onmouseover="dhtmlShow('navOption3sub_9', '11');"
                                 class="subNav">(A - H)</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>

                        <tr>
                           <td colspan="3" bgcolor="#ffffff">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="#" onmouseover="dhtmlShow('navOption3sub_10', '11');"
                                 class="subNav">Other Organizations </a>

                              <br/>
                              <a href="#" onmouseover="dhtmlShow('navOption3sub_10', '11');"
                                 class="subNav">(I - Z)</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>

                        <tr>
                           <td colspan="3" bgcolor="#ffffff">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="http://www.rockarch.org/collections/ru/"
                                 onmouseover="dhtmlShow('navOption3sub_2', '11');" class="subNav"
                                 >Rockefeller University</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>


                        <tr>
                           <td colspan="3" bgcolor="#ffffff">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td width="6">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="6" height="1" alt=""/>
                           </td>
                           <td width="155">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="http://www.rockarch.org/collections/family/"
                                 onmouseover="dhtmlShow('navOption3sub_1', '11');" class="subNav"
                                 >Rockefeller Family</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td width="6">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="6" height="1" alt=""/>
                           </td>
                        </tr>

                        <tr>
                           <td colspan="3" bgcolor="#ffffff">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="#" onmouseover="dhtmlShow('navOption3sub_7', '11');"
                                 class="subNav">Papers of Individuals</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>

                        <!--             
                
				<tr><td colspan="3" bgcolor="#ffffff"><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td></tr>
					<tr>
						<td><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td>
						<td>
							<img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/><br/><a href="/collections/ford/" onmouseover="dhtmlShow('navOption3sub_9', '11');" class="subNav">Ford Foundation</a><br/><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/></td>
						<td><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td>
					</tr>
                    
                    <tr><td colspan="3" bgcolor="#ffffff"><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td></tr>
                    
				<tr><td colspan="3" bgcolor="#ffffff"><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td></tr>
					<tr>
						<td width="6"><img src="http://www.rockarch.org/images/spacer.gif" width="6" height="1" alt=""/></td>
						<td width="155">
							<img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/><br/><a href="/collections/family/" onmouseover="dhtmlShow('navOption3sub_1', '11');" class="subNav">Rockefeller Family</a><br/><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/></td>
						<td width="6"><img src="http://www.rockarch.org/images/spacer.gif" width="6" height="1" alt=""/></td>
					</tr>		
					<tr><td colspan="3" bgcolor="#ffffff"><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td></tr>
					<tr>
						<td><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td>
						<td>
							<img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/><br/><a href="/collections/ru/" onmouseover="dhtmlShow('navOption3sub_2', '11');" class="subNav">Rockefeller University</a><br/><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/></td>
						<td><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td>
					</tr>
					
					<tr><td colspan="3" bgcolor="#ffffff"><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td></tr>
					<tr>
						<td><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td>
						<td>
							<img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/><br/><a href="/collections/rbf/" onmouseover="dhtmlShow('navOption3sub_4', '11');" class="subNav">Rockefeller Brothers Fund</a><br/><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/></td>
						<td><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td>
					</tr>
                    
                    <tr><td colspan="3" bgcolor="#ffffff"><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td></tr>
					<tr>
						<td><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td>
						<td>
							<img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/><br/><a href="/collections/nonrockorgs/commonwealth.php/" onmouseover="dhtmlShow('navOption3sub_10', '11');" class="subNav">Commonwealth Fund</a><br/><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/></td>
						<td><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td>
					</tr>	
                    
					<tr><td colspan="3" bgcolor="#ffffff"><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td></tr>
					<tr>
						<td><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td>
						<td>
							<img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/><br/><a href="#" onmouseover="dhtmlShow('navOption3sub_5', '11');" class="subNav">Rockefeller Related Organizations</a><br/><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/></td>
						<td><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td>
					</tr>
							<tr><td colspan="3" bgcolor="#ffffff"><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td></tr>
					<tr>
						<td><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td>
						<td>
							<img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/><br/><a href="#" onmouseover="dhtmlShow('navOption3sub_6', '11');" class="subNav">Other Foundations and Non-profits</a><br/><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/></td>
						<td><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td>
					</tr>	
					<tr><td colspan="3" bgcolor="#ffffff"><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td></tr>
					<tr>
						<td><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td>
						<td>
							<img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/><br/><a href="#" onmouseover="dhtmlShow('navOption3sub_7', '11');" class="subNav">Papers of Individuals</a><br/><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/></td>
						<td><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td>
					</tr> -->

                        <!--					
					<tr><td colspan="3" bgcolor="#ffffff"><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td></tr>
					<tr>
						<td><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td>
						<td>
							<img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/><br/><a href="/collections/oralhistory.php" onmouseover="dhtmlShow('navOption3sub_8', '8');" class="subNav">Oral History</a><br/><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/></td>
						<td><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/></td>
					</tr>															
-->
                     </table>
                  </layer>
               </ilayer>
            </div>
         </layer>
      </div>

      <!-- This begins PUBLICATIONS SubMenu -->
      <div id="navOption4sub"
         style="visibility: hidden; position: absolute; right: 369px; top: 29px; z-index:99;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="161" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption4suba">
                     <table width="167" border="0" cellspacing="0" cellpadding="0" bgcolor="#777777">
                        <tr>
                           <td width="6">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="6" height="1" alt=""/>
                           </td>
                           <td width="155">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="http://www.rockarch.org/programs/digital/"
                                 onmouseover="dhtmlShow('navOption4sub_6', '5');" class="subNav"
                                 >Digital</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td width="6">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="6" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td colspan="3" bgcolor="#ffffff">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="6" height="1" alt=""/>
                           </td>
                           <td width="155">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="http://www.rockarch.org/programs/research/"
                                 onmouseover="dhtmlShow('navOption4sub_7', '5');" class="subNav"
                                 >Research &amp; Education</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td width="6">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="6" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td colspan="3" bgcolor="#ffffff">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="#" onmouseover="dhtmlShow('navOption4sub_3', '5');"
                                 class="subNav">Publications</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                     </table>
                  </layer>
               </ilayer>
            </div>
         </layer>
      </div>

      <!-- This begins ROCKEFELLER's SubMenu -->
      <div id="navOption5sub"
         style="visibility: hidden; position: absolute; right: 278px; top: 29px; z-index:99;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="161" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption5suba">
                     <table width="167" border="0" cellspacing="0" cellpadding="0" bgcolor="#777777">
                        <tr>
                           <td width="6">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="6" height="1" alt=""/>
                           </td>
                           <td width="155">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="http://www.rockarch.org/bio/famtree.php" class="subNav">Virtual Family Tree</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td width="6">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="6" height="1" alt=""/>
                           </td>
                        </tr>

                        <tr>
                           <td colspan="3" bgcolor="#ffffff">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="http://www.rockarch.org/bio/" class="subNav">Selected Biographies</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>

                        <tr>
                           <td colspan="3" bgcolor="#ffffff">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="http://www.rockarch.org/inownwords/" class="subNav">In Their Own Words</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>

                        <tr>
                           <td colspan="3" bgcolor="#ffffff">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="http://www.rockarch.org/philanthropy/" class="subNav">Rockefeller Philanthropy</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>

                        <tr>
                           <td colspan="3" bgcolor="#ffffff">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="http://www.rockarch.org/publications/biblio/bibliofamily.php" class="subNav"
                                 >Bibliography on the Rockefeller Family and Philanthropies</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1" alt=""/>
                           </td>
                        </tr>
                     </table>
                  </layer>
               </ilayer>
            </div>
         </layer>
      </div>

      <!-- This begins SEARCH OUR COLLECTIONS SubMenu -->
      <div id="navOption6sub"
         style="visibility: hidden; position: absolute; right: 4px; top: 29px; z-index:99;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="138" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption6suba">
                     <table width="167" border="0" cellspacing="0" cellpadding="0" bgcolor="#777777">
                        <tr>
                           <td width="6">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="6" height="1" alt=""/>
                           </td>
                           <td width="155">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                              <br/>
                              <a href="http://www.rockarch.org/search/searchmain.php" class="subNav"> Search Collections
                                 Database</a>
                              <br/>
                              <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="6" alt=""/>
                           </td>
                           <td width="6">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="6" height="1" alt=""/>
                           </td>
                        </tr>
                     </table>
                  </layer>
               </ilayer>
            </div>
         </layer>
      </div>

      <!--  *** End section: Sub-navigation ***  -->
      <!--  *** Begin section: Sub-navigation ***  -->
      <!-- This begins ABOUT US SubMenu -->

      <!-- This begins RESEARCH SubMenu -->
      <div id="navOption1sub_1"
         style="visibility: hidden; position: absolute; left: 259px; top: 187px;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption1sub_1"> </layer>
               </ilayer>
            </div>
         </layer>
      </div>
      <div id="navOption1sub_2"
         style="visibility: hidden; position: absolute; left: 259px; top: 187px;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption1sub_2"> </layer>
               </ilayer>
            </div>
         </layer>
      </div>
      <div id="navOption1sub_3"
         style="visibility: hidden; position: absolute; left: 259px; top: 187px;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption1sub_3"> </layer>
               </ilayer>
            </div>
         </layer>
      </div>
      <div id="navOption1sub_4"
         style="visibility: hidden; position: absolute; left: 604px; top: 187px;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption1sub_4">
                     <table width="161" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                           <td valign="top" bgcolor="#b2cce0">
                              <table width="147" border="0" cellspacing="0" cellpadding="0">
                                 <tr>
                                    <td width="147" valign="top">
                                       <table width="147" border="0" cellspacing="0" cellpadding="0"
                                          bgcolor="#b2cce0">

                                          <!--                      
                                    <tr>
										<td width="15"><img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1" alt=""/></td>
										<td width="117">
											<img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7" alt=""/><br/><a href="/research/forms/reprocost.pdf" target="_blank" class="subNav">Photo Reproduction Charges</a><br/><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7" alt=""/></td>
										<td width="15"><img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1" alt=""/></td>
									</tr>	-->


                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>

                                          <tr>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="117">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/research/forms/photocopy.pdf"
                                                  target="_blank" class="subNav">Photocopying
                                                  Information</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>

                                          <tr>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="117">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/research/forms/copyrequest.pdf"
                                                  target="_blank" class="subNav">Request for
                                                  Copies</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="117">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/research/forms/ccform.pdf" target="_blank"
                                                  class="subNav">Credit Card Form</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                       </table>
                                    </td>
                                 </tr>
                              </table>
                           </td>
                           <td width="14" align="center" valign="top">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="14" height="1" alt=""/>
                           </td>
                        </tr>
                     </table>
                  </layer>
               </ilayer>
            </div>
         </layer>
      </div>
      <div id="navOption1sub_5"
         style="visibility: hidden; position: absolute; left: 259px; top: 187px;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption1sub_5"> </layer>
               </ilayer>
            </div>
         </layer>
      </div>


      <!-- This begins GRANTS SubMenu -->
      <div id="navOption2sub_1"
         style="visibility: hidden; position: absolute; left: 466px; top: 180px;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption2sub_1">
                     <table width="161" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                           <td valign="top" bgcolor="#b2cce0">
                              <table width="147" border="0" cellspacing="0" cellpadding="0">
                                 <tr>
                                    <td width="147" valign="top">
                                       <table width="147" border="0" cellspacing="0" cellpadding="0"
                                          bgcolor="#b2cce0">
                                          <tr>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="117">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="#" class="subNav">Application</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                       </table>
                                    </td>
                                 </tr>
                              </table>
                           </td>
                           <td width="14" align="center" valign="top">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="14" height="166" alt=""/>
                           </td>
                        </tr>
                     </table>
                  </layer>
               </ilayer>
            </div>
         </layer>
      </div>
      <div id="navOption2sub_2"
         style="visibility: hidden; position: absolute; left: 466px; top: 180px;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption2sub_2">
                     <table width="161" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                           <td valign="top" bgcolor="#b2cce0">
                              <table width="147" border="0" cellspacing="0" cellpadding="0">
                                 <tr>
                                    <td width="147" valign="top">
                                       <table width="147" border="0" cellspacing="0" cellpadding="0"
                                          bgcolor="#b2cce0">
                                          <tr>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="117">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="#" class="subNav">Application</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                       </table>
                                    </td>
                                 </tr>
                              </table>
                           </td>
                           <td width="14" align="center" valign="top">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="14" height="166" alt=""/>
                           </td>
                        </tr>
                     </table>
                  </layer>
               </ilayer>
            </div>
         </layer>
      </div>
      <div id="navOption2sub_3"
         style="visibility: hidden; position: absolute; left: 466px; top: 180px;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption2sub_3">
                     <table width="161" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                           <td valign="top" bgcolor="#b2cce0">
                              <table width="147" border="0" cellspacing="0" cellpadding="0">
                                 <tr>
                                    <td width="147" valign="top">
                                       <table width="147" border="0" cellspacing="0" cellpadding="0"
                                          bgcolor="#b2cce0">
                                          <tr>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="117">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="#" class="subNav">Application</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                       </table>
                                    </td>
                                 </tr>
                              </table>
                           </td>
                           <td width="14" align="center" valign="top">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="14" height="166" alt=""/>
                           </td>
                        </tr>
                     </table>
                  </layer>
               </ilayer>
            </div>
         </layer>
      </div>
      <div id="navOption2sub_4"
         style="visibility: hidden; position: absolute; left: 466px; top: 180px;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption2sub_4">
                     <table width="161" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                           <td valign="top" bgcolor="#b2cce0">
                              <table width="147" border="0" cellspacing="0" cellpadding="0">
                                 <tr>
                                    <td width="147" valign="top">
                                       <table width="147" border="0" cellspacing="0" cellpadding="0"
                                          bgcolor="#b2cce0">
                                          <tr>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="117">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="#" class="subNav">Application</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                       </table>
                                    </td>
                                 </tr>
                              </table>
                           </td>
                           <td width="14" align="center" valign="top">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="14" height="166" alt=""/>
                           </td>
                        </tr>
                     </table>
                  </layer>
               </ilayer>
            </div>
         </layer>
      </div>
      <div id="navOption2sub_5"
         style="visibility: hidden; position: absolute; left: 466px; top: 180px;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption2sub_5">
                     <table width="161" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                           <td valign="top" bgcolor="#b2cce0">
                              <table width="147" border="0" cellspacing="0" cellpadding="0">
                                 <tr>
                                    <td width="147" valign="top">
                                       <table width="147" border="0" cellspacing="0" cellpadding="0"
                                          bgcolor="#b2cce0">
                                          <tr>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="117">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="#" class="subNav">Application</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                       </table>
                                    </td>
                                 </tr>
                              </table>
                           </td>
                           <td width="14" align="center" valign="top">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="14" height="166" alt=""/>
                           </td>
                        </tr>
                     </table>
                  </layer>
               </ilayer>
            </div>
         </layer>
      </div>

      <!-- This begins COLLECTIONS SubMenu -->
      <div id="navOption3sub_1"
         style="visibility: hidden; position: absolute; right: 309px; top: 29px; z-index:100;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption3sub_1">
                     <table width="161" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                           <td valign="top" bgcolor="#b2cce0">
                              <table width="147" border="0" cellspacing="0" cellpadding="0">
                                 <tr>
                                    <td width="151" valign="top">
                                       <table width="151" border="0" cellspacing="0" cellpadding="0"
                                          bgcolor="#999999">
                                          <tr>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/family/jdrsr/" class="subNav"
                                                  >John D. Rockefeller Papers</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/family/william.php"
                                                  class="subNav">William Rockefeller Papers</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/family/omr.php" class="subNav"
                                                  >Office of the Messrs. Rockefeller</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/family/jdrjr/" class="subNav"
                                                  >John D. Rockefeller, Jr. Personal Papers</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/family/abby/" class="subNav"
                                                  >Abby Aldrich Rockefeller, Personal Papers</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/family/abbymauze.php"
                                                  class="subNav">Abby R. Mauz&#233; Papers</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/family/jdr3/" class="subNav"
                                                  >John D. Rockefeller 3rd Papers</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>

                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a
                                                   href="http://www.rockarch.org/collections/family/blanchetterockefeller.php"
                                                  class="subNav">Blanchette H. Rockefeller
                                                  Papers</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/family/laurance.php"
                                                  class="subNav">Laurance S. Rockefeller Papers</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>

                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/family/nar/" class="subNav"
                                                  >Nelson A. Rockefeller Papers</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <!-- <tr>
										<td><img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1" alt=""/></td>
										<td width="100%">
											<img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7" alt=""/><br/><a href="/collections/family/nar/narnew.php" class="subNav">New Nelson A. Rockefeller Materials Available for Research</a><br/><img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7" alt=""/></td>
										<td><img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1" alt=""/></td>
									</tr> -->
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/family/winthrop.php"
                                                  class="subNav">Winthrop Rockefeller Papers</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                       </table>
                                    </td>
                                 </tr>
                              </table>
                           </td>
                           <td width="14" align="center" valign="top">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="14" height="166" alt=""/>
                           </td>

                        </tr>
                     </table>
                  </layer>
               </ilayer>
            </div>
         </layer>
      </div>
      <div id="navOption3sub_2"
         style="visibility: hidden; position: absolute; right: 309px; top: 29px; z-index:100;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption3sub_2">
                     <table width="161" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                           <td valign="top" bgcolor="#b2cce0">
                              <table width="147" border="0" cellspacing="0" cellpadding="0">
                                 <tr>
                                    <td width="151" valign="top">
                                       <table width="151" border="0" cellspacing="0" cellpadding="0"
                                          bgcolor="#999999">
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/ru/" class="subNav"
                                                  >Collections Overview</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/ru/rgdescriptions.php"
                                                  class="subNav">Record Group Descriptions</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                       </table>
                                    </td>
                                 </tr>
                              </table>
                           </td>
                           <td width="14" align="center" valign="top">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="14" height="1" alt=""/>
                           </td>
                        </tr>
                     </table>
                  </layer>
               </ilayer>
            </div>
         </layer>
      </div>
      <div id="navOption3sub_3"
         style="visibility: hidden; position: absolute; right: 309px; top: 29px; z-index:100;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption3sub_3">
                     <table width="161" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                           <td valign="top" bgcolor="#b2cce0">
                              <table width="147" border="0" cellspacing="0" cellpadding="0">
                                 <tr>
                                    <td width="151" valign="top">
                                       <table width="151" border="0" cellspacing="0" cellpadding="0"
                                          bgcolor="#999999">
                                          <tr>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rf/" class="subNav"
                                                  >Collections Overview</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rf/rfparis.php" class="subNav"
                                                  >RF Paris Field Office</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rf/rfnewdehli.php"
                                                  class="subNav">RF New Dehli Field Office</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rf/rfcolombia.php"
                                                  class="subNav">RF Cali, Colombia Field Office</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rf/rfmexico.php"
                                                  class="subNav">RF Mexico Field Office</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rf/countrycodes.php"
                                                  class="subNav">Guide to Country Codes in the RF
                                                  Archives</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                       </table>
                                    </td>
                                 </tr>
                              </table>
                           </td>
                           <td width="14" align="center" valign="top">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="14" height="166" alt=""/>
                           </td>

                        </tr>
                     </table>
                  </layer>
               </ilayer>
            </div>
         </layer>
      </div>
      <div id="navOption3sub_4"
         style="visibility: hidden; position: absolute; right: 309px; top: 29px; z-index:100;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption4sub_2">
                     <table width="161" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                           <td valign="top" bgcolor="#b2cce0">
                              <table width="147" border="0" cellspacing="0" cellpadding="0">
                                 <tr>
                                    <td width="151" valign="top">
                                       <table width="151" border="0" cellspacing="0" cellpadding="0"
                                          bgcolor="#999999">
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rbf/" class="subNav"
                                                  >Collections Overview</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="/collections/rbf/rbfseries3.php"
                                                  class="subNav">Series 3, Grants List</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                       </table>
                                    </td>
                                 </tr>
                              </table>
                           </td>
                           <td width="14" align="center" valign="top">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="14" height="1" alt=""/>
                           </td>
                        </tr>
                     </table>
                  </layer>
               </ilayer>
            </div>
         </layer>
      </div>
      <div id="navOption3sub_5"
         style="visibility: hidden; position: absolute; right: 309px; top: 29px; z-index:100;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption3sub_5">
                     <table width="161" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                           <td valign="top" bgcolor="#b2cce0">
                              <table width="151" border="0" cellspacing="0" cellpadding="0">
                                 <tr>
                                    <td width="151" valign="top">
                                       <table width="151" border="0" cellspacing="0" cellpadding="0"
                                          bgcolor="#999999">
                                          <tr>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rockorgs/jdr3orgs.php#acc"
                                                  class="subNav">Asian Cultural Council</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/nonrockorgs/culpeper.php"
                                                  class="subNav">Charles E. Culpeper Foundation</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rockorgs/cmbny.php"
                                                  class="subNav">China Medical Board of New York</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/nonrockorgs/commonwealth.php"
                                                  class="subNav">Commonwealth Fund</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a
                                                   href="http://www.rockarch.org/collections/rockorgs/jdrjrorgs.php#davison"
                                                  class="subNav">Davison Fund</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/ford/" class="subNav">Ford
                                                  Foundation</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/nonrockorgs/fcd.php"
                                                  class="subNav">Foundation for Child
                                                  Development</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                       </table>
                                    </td>
                                 </tr>
                              </table>
                           </td>
                           <td width="14" align="center" valign="top">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="14" height="166" alt=""/>
                           </td>
                        </tr>
                     </table>
                  </layer>
               </ilayer>
            </div>
         </layer>
      </div>

      <div id="navOption3sub_6"
         style="visibility: hidden; position: absolute; right: 309px; top: 29px; z-index:100;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption3sub_6">
                     <table width="161" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                           <td valign="top" bgcolor="#b2cce0">
                              <table width="151" border="0" cellspacing="0" cellpadding="0">
                                 <tr>
                                    <td width="151" valign="top">
                                       <table width="151" border="0" cellspacing="0" cellpadding="0"
                                          bgcolor="#999999">
                                          <tr>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rockorgs/geb.php"
                                                  class="subNav">General Education Board</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/nonrockorgs/hrf.php"
                                                  class="subNav">Health Research Fund</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>

                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rockorgs/jdrjrorgs.php#ieb"
                                                  class="subNav">International Education Board</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>

                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/nonrockorgs/markle.php"
                                                  class="subNav">John and Mary Markle Foundation</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>

                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rockorgs/jdr3orgs.php#jdr3"
                                                  class="subNav">JDR 3rd Fund</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>

                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rockorgs/lsrm.php"
                                                  class="subNav">Laura Spelman Rockefeller
                                                  Memorial</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/nonrockorgs/markey.php"
                                                  class="subNav">Lucille P. Markey Charitable
                                                  Trust</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rockorgs/miscorgs.php#mbr"
                                                  class="subNav">Martha Baird Rockefeller Fund for
                                                  Music</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>

                                          </tr>
                                       </table>
                                    </td>
                                 </tr>
                              </table>
                           </td>
                           <td width="14" align="center" valign="top">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="14" height="166" alt=""/>
                           </td>
                        </tr>
                     </table>
                  </layer>
               </ilayer>
            </div>
         </layer>
      </div>
      <div id="navOption3sub_7"
         style="visibility: hidden; position: absolute; right: 309px; top: 29px; z-index:100;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption3sub_7">
                     <table width="161" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                           <td valign="top" bgcolor="#b2cce0">
                              <table width="151" border="0" cellspacing="0" cellpadding="0">
                                 <tr>
                                    <td width="151" valign="top">
                                       <table width="151" border="0" cellspacing="0" cellpadding="0"
                                          bgcolor="#999999">
                                          <tr>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/individuals/rf/"
                                                  class="subNav">Foundation Related</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/individuals/family/"
                                                  class="subNav">Rockefeller Family Related</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/individuals/ru/"
                                                  class="subNav">Rockefeller University Related</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                       </table>
                                    </td>
                                 </tr>
                              </table>
                           </td>
                           <td width="14" align="center" valign="top">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="14" height="1" alt=""/>
                           </td>
                        </tr>
                     </table>
                  </layer>
               </ilayer>
            </div>
         </layer>
      </div>
      <div id="navOption3sub_8"
         style="visibility: hidden; position: absolute; right: 309px; top: 29px; z-index:100;">

         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption3sub_8">


                     <table width="161" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                           <td valign="top" bgcolor="#b2cce0">
                              <table width="151" border="0" cellspacing="0" cellpadding="0">
                                 <tr>
                                    <td width="151" valign="top">
                                       <table width="151" border="0" cellspacing="0" cellpadding="0"
                                          bgcolor="#999999">
                                          <tr>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/nonrockorgs/neareast.php"
                                                  class="subNav">Near East Foundation</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rbf/" class="subNav"
                                                  >Rockefeller Brothers Fund</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>

                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rf/" class="subNav"
                                                  >Rockefeller Foundation</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>

                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/nonrockorgs/sage.php"
                                                  class="subNav">Russell Sage Foundation</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>

                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a
                                                   href="http://www.rockarch.org/collections/rockorgs/jdrjrorgs.php#sealantic"
                                                  class="subNav">Sealantic Fund</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>

                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rockorgs/miscorgs.php#spelman"
                                                  class="subNav">Spelman Fund of New York</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/nonrockorgs/wtgrant.php"
                                                  class="subNav">William T. Grant Foundation</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/nonrockorgs/wwilson.php"
                                                  class="subNav">Woodrow Wilson National Fellowship
                                                  Foundation</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                       </table>
                                    </td>
                                 </tr>
                              </table>
                           </td>
                           <td width="14" align="center" valign="top">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="14" height="166" alt=""/>
                           </td>
                        </tr>
                     </table>
                  </layer>
               </ilayer>
            </div>
         </layer>
      </div>

      <div id="navOption3sub_9"
         style="visibility: hidden; position: absolute; right: 309px; top: 29px; z-index:100;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption3sub_9">
                     <table width="161" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                           <td valign="top" bgcolor="#b2cce0">
                              <table width="151" border="0" cellspacing="0" cellpadding="0">
                                 <tr>
                                    <td width="151" valign="top">
                                       <table width="151" border="0" cellspacing="0" cellpadding="0"
                                          bgcolor="#999999">
                                          <tr>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rockorgs/jdr3orgs.php#adc"
                                                  class="subNav">Agricultural Development
                                                  Council</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rockorgs/narorgs.php"
                                                  class="subNav">American International Assoc. for
                                                  Economic and Social Development</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>

                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rockorgs/miscorgs.php#aeap"
                                                  class="subNav">Arts, Education and Americans
                                                  Panel</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>

                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rockorgs/jdr3orgs.php#asiasoc"
                                                  class="subNav">Asia Society</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>

                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rockorgs/bsh.php"
                                                  class="subNav">Bureau of Social Hygiene</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>

                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/nonrockorgs/counfound.php"
                                                  class="subNav">Council on Foundations</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rockorgs/miscorgs.php#dlma"
                                                  class="subNav">Downtown-Lower Manhattan
                                                  Association, Inc.</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a
                                                   href="http://www.rockarch.org/collections/nonrockorgs/foundationcenter.php"
                                                  class="subNav">Foundation Center</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a
                                                   href="http://www.rockarch.org/collections/rockorgs/miscorgs.php#goldhinz"
                                                  class="subNav">Goldstone &amp; Hinz</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rockorgs/jdrjrorgs.php#hhv"
                                                  class="subNav">Historic Hudson Valley Manuscript
                                                  Collection</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                       </table>
                                    </td>
                                 </tr>
                              </table>
                           </td>
                           <td width="14" align="center" valign="top">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="14" height="166" alt=""/>
                           </td>
                        </tr>
                     </table>
                  </layer>
               </ilayer>
            </div>
         </layer>
      </div>

      <div id="navOption3sub_10"
         style="visibility: hidden; position: absolute; right: 309px; top: 29px; z-index:100;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption3sub_10">
                     <table width="161" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                           <td valign="top" bgcolor="#b2cce0">
                              <table width="151" border="0" cellspacing="0" cellpadding="0">
                                 <tr>
                                    <td width="151" valign="top">
                                       <table width="151" border="0" cellspacing="0" cellpadding="0"
                                          bgcolor="#999999">
                                          <tr>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rockorgs/narorgs.php"
                                                  class="subNav">International Basic Economy
                                                  Corporation</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rockorgs/miscorgs.php#mskcc"
                                                  class="subNav">Memorial Sloan-Kettering Cancer
                                                  Center</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>

                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rockorgs/popcouncil.php"
                                                  class="subNav">Population Council</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>

                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rockorgs/jdr3orgs.php#poa"
                                                  class="subNav">Products of Asia</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>

                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rockorgs/hookworm.php"
                                                  class="subNav">Rockefeller Sanitary Commission</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>

                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/nonrockorgs/ssrc.php"
                                                  class="subNav">Social Science Research Council</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a
                                                   href="http://www.rockarch.org/collections/rockorgs/miscorgs.php#trilateral"
                                                  class="subNav">Trilateral Commission</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a
                                                   href="http://www.rockarch.org/collections/rockorgs/miscorgs.php#uniontank"
                                                  class="subNav">Union Tank Car Company</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/collections/rockorgs/miscorgs.php#wcph"
                                                  class="subNav">Women's Club of Pocantico Hills</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>

                                       </table>
                                    </td>
                                 </tr>
                              </table>
                           </td>
                           <td width="14" align="center" valign="top">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="14" height="166" alt=""/>
                           </td>
                        </tr>
                     </table>
                  </layer>
               </ilayer>
            </div>
         </layer>
      </div>

      <div id="navOption3sub_11"
         style="visibility: hidden; position: absolute; left: 320px; top: 187px;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption3sub_11"> </layer>
               </ilayer>
            </div>
         </layer>
      </div>



      <!-- This begins PUBLICATIONS SubMenu -->
      <div id="navOption4sub_1"
         style="visibility: hidden; position: absolute; left: 401px; top: 187px;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption4sub_1"> </layer>
               </ilayer>
            </div>
         </layer>
      </div>
      <div id="navOption4sub_2"
         style="visibility: hidden; position: absolute; left: 401px; top: 187px;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption4sub_2"> </layer>
               </ilayer>
            </div>
         </layer>
      </div>
      <div id="navOption4sub_3"
         style="visibility: hidden; position: absolute; right: 203px; top: 29px; z-index:100;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption4sub_3">
                     <table width="161" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                           <td valign="top" bgcolor="#b2cce0">
                              <table width="147" border="0" cellspacing="0" cellpadding="0">
                                 <tr>
                                    <td width="151" valign="top">
                                       <table width="151" border="0" cellspacing="0" cellpadding="0"
                                          bgcolor="#999999">
                                          <tr>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/publications/guides/" class="subNav"
                                                  >Guides and Subject Surveys</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/publications/newsletter/" class="subNav"
                                                  >Newsletters</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/publications/resrep/" class="subNav"
                                                  >Research Reports</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td colspan="3" bgcolor="#e6eef5">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                             <td width="100%">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                <br/>
                                                <a href="http://www.rockarch.org/publications/biblio/" class="subNav"
                                                  >Bibliographies</a>
                                                <br/>
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                             </td>

                                             <tr>
                                                <td colspan="3" bgcolor="#e6eef5">
                                                  <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="1"
                                                  alt=""/>
                                                </td>
                                             </tr>
                                             <tr>
                                                <td width="15">
                                                  <img src="http://www.rockarch.org/images/spacer.gif" width="15"
                                                  height="1" alt=""/>
                                                </td>
                                                <td width="100%">
                                                  <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                  <br/>
                                                   <a href="http://www.rockarch.org/publications/conferences/"
                                                  class="subNav">Conference Proceedings</a>
                                                  <br/>
                                                  <img src="http://www.rockarch.org/images/spacer.gif" width="1" height="7"
                                                  alt=""/>
                                                </td>
                                                <td width="15">
                                                  <img src="http://www.rockarch.org/images/spacer.gif" width="15"
                                                  height="1" alt=""/>
                                                </td>
                                             </tr>
                                             <td width="15">
                                                <img src="http://www.rockarch.org/images/spacer.gif" width="15" height="1"
                                                  alt=""/>
                                             </td>
                                          </tr>
                                       </table>
                                    </td>
                                 </tr>
                              </table>
                           </td>
                           <td width="14" align="center" valign="top">
                              <img src="http://www.rockarch.org/images/spacer.gif" width="14" height="1" alt=""/>
                           </td>
                        </tr>
                     </table>
                  </layer>
               </ilayer>
            </div>
         </layer>
      </div>
      <div id="navOption4sub_4"
         style="visibility: hidden; position: absolute; left: 401px; top: 187px;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption4sub_4"> </layer>
               </ilayer>
            </div>
         </layer>
      </div>
      <div id="navOption4sub_5"
         style="visibility: hidden; position: absolute; left: 401px; top: 187px;">
         <layer>
            <div onMouseOver="submenuIE(this)" onMouseOut="submenuoffIE(this)">
               <ilayer>
                  <layer width="147" onMouseOver="submenuNS(this)" onMouseOut="submenuoffNS(this)"
                     name="navOption4sub_5"> </layer>
               </ilayer>
            </div>
         </layer>
      </div>

      <!-- This begins ROCKEFELLER's SubMenu -->

      <!-- This begins SEARCH OUR COLLECTIONS SubMenu -->

      <!--  *** End section: Sub-navigation ***  -->
      <!--/htdig_noindex-->
      <table id="menu" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
         <tr>
            <td height="80">
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                     <td width="40" height="80" rowspan="3">
                        <img src="http://www.rockarch.org/images/spacer.gif" width="40" height="80" alt=""/>
                     </td>
                     <td width="120" rowspan="3">
                        <!--<a href="/">
                           <img src="http://www.rockarch.org/images/RAC-logo.png" width="103" height="140"
                              alt="The Rockefeller Archive Center" border="0"/>
                        </a>-->
                     </td>
                     <td width="100%" height="34" align="right" class="comment" valign="top">


                        <table width="100" border="0" cellspacing="0" cellpadding="0">
                           <tr>
                              <td width="40">
                                 <img src="http://www.rockarch.org/images/spacer.gif" width="40" height="26" alt=""/>
                              </td>
                              <td>
                                 <a href="#"
                                    onmouseover="showMenu('navOption0'); window.status='about'; changeImages('navOption0', '/http://www.rockarch.orgimages/nav2_about.gif'); return true;"
                                    onmouseout="hideMenu('navOption0'); window.status=''; changeImages('navOption0', 'http://www.rockarch.org/images/nav1_about.gif'); return true;">
                                    <img src="http://www.rockarch.org/images/nav1_about.gif" width="77" height="32"
                                       alt="About Us" border="0" name="navOption0" id="navOption0"/>
                                 </a>
                              </td>

                              <td width="8">
                                 <img src="http://www.rockarch.org/images/spacer.gif" width="8" height="1" alt=""/>
                              </td>

                              <td>
                                 <a href="#"
                                    onmouseover="showMenu('navOption2'); window.status='about'; changeImages('navOption2', 'http://www.rockarch.org/images/nav2_grants.gif'); return true;"
                                    onmouseout="hideMenu('navOption2'); window.status=''; changeImages('navOption2', 'http://www.rockarch.org/images/nav1_grants.gif'); return true;">
                                    <img src="http://www.rockarch.org/images/nav1_grants.gif" width="61" height="32"
                                       alt="Grants" border="0" name="navOption2" id="navOption2"/>
                                 </a>
                              </td>

                              <td width="8">
                                 <img src="http://www.rockarch.org/images/spacer.gif" width="8" height="1" alt=""/>
                              </td>

                              <td>
                                 <a href="#"
                                    onmouseover="showMenu('navOption3'); window.status='about'; changeImages('navOption3', 'http://www.rockarch.org/images/nav2_collections.gif'); return true;"
                                    onmouseout="hideMenu('navOption3'); window.status=''; changeImages('navOption3', 'http://www.rockarch.org/images/nav1_collections.gif'); return true;">
                                    <img src="http://www.rockarch.org/images/nav1_collections.gif" width="98" height="32"
                                       alt="Collections" border="0" name="navOption3"
                                       id="navOption3"/>
                                 </a>
                              </td>

                              <td width="8">
                                 <img src="http://www.rockarch.org/images/spacer.gif" width="8" height="1" alt=""/>
                              </td>

                              <td>
                                 <a href="#"
                                    onmouseover="showMenu('navOption4'); window.status='about'; changeImages('navOption4', 'http://www.rockarch.org/images/nav2_programs.gif'); return true;"
                                    onmouseout="hideMenu('navOption4'); window.status=''; changeImages('navOption4', 'http://www.rockarch.org/images/nav1_programs.gif'); return true;">
                                    <img src="http://www.rockarch.org/images/nav1_programs.gif" width="83" height="32"
                                       alt="Programs" border="0" name="navOption4" id="navOption4"/>
                                 </a>
                              </td>

                              <td width="8">
                                 <img src="http://www.rockarch.org/images/spacer.gif" width="8" height="1" alt=""/>
                              </td>

                              <td>
                                 <a href="#"
                                    onmouseover="showMenu('navOption5'); window.status='about'; changeImages('navOption5', 'http://www.rockarch.org/images/nav2_rockefellers.gif'); return true;"
                                    onmouseout="hideMenu('navOption5'); window.status=''; changeImages('navOption5', 'http://www.rockarch.org/images/nav1_rockefellers.gif'); return true;">
                                    <img src="http://www.rockarch.org/images/nav1_rockefellers.gif" width="138" height="32"
                                       alt="The Rockefellers" border="0" name="navOption5"
                                       id="navOption5"/>
                                 </a>
                              </td>

                              <td width="8">
                                 <img src="http://www.rockarch.org/images/spacer.gif" width="8" height="1" alt=""/>
                              </td>

                              <td>
                                 <a href="#"
                                    onmouseover="showMenu('navOption1'); window.status='about'; changeImages('navOption1', 'http://www.rockarch.org/images/nav2_researchers.gif'); return true;"
                                    onmouseout="hideMenu('navOption1'); window.status=''; changeImages('navOption1', 'http://www.rockarch.org/images/nav1_researchers.gif'); return true;">
                                    <img src="http://www.rockarch.org/images/nav1_researchers.gif" width="225" height="32"
                                       alt="Information for Researchers" border="0"
                                       name="navOption1" id="navOption1"/>
                                 </a>
                              </td>

                              <td width="8">
                                 <img src="http://www.rockarch.org/images/spacer.gif" width="8" height="1" alt=""/>
                              </td>

                              <td>
                                 <a href="http://www.rockarch.org/search/searchmain.php"
                                    onmouseover="window.status='about'; changeImages('navOption6', 'http://www.rockarch.org/images/nav2_search.gif'); return true;"
                                    onmouseout="window.status=''; changeImages('navOption6', 'http://www.rockarch.org/images/nav1_search.gif'); return true;">
                                    <img src="http://www.rockarch.org/images/nav1_search.gif" width="61" height="32"
                                       alt="Search" border="0" name="navOption6" id="navOption6"/>
                                 </a>
                              </td>
                           </tr>
                        </table>
                        <script type="text/javascript" language="JavaScript">
                           <!--
					if (!uselayers) {
						for (i=0; i<document.getElementsByTagName('div').length; i++) {
							if (document.getElementsByTagName('div')[i].id.length>5) {
								divobj[divcount] = document.getElementsByTagName('div')[i];divcount++;
							}
						}
					}
				//  -->
                        </script>
                     </td>
                     <td width="5" rowspan="3">
                        <img src="http://www.rockarch.org/images/spacer.gif" width="5" height="1" alt=""/>
                     </td>
                  </tr>
                  <tr>
                     <td width="100%" align="right" class="comment" valign="top">
                        <!--htdig_noindex-->
                        <a href="http://www.rockarch.org" class="home">Home</a> | <a href="http://www.rockarch.org/faqs/" class="home">FAQs</a> |
                        <a href="http://www.rockarch.org/links.php" class="home">Links</a> | <a
                           href="http://www.rockarch.org/about/contact.php" class="home">E-Mail</a> | <br/>
                        <br/>
                        <a href="http://www.facebook.com/RockefellerArchiveCenter" target="_blank"
                           ><img src="http://www.rockarch.org/images/fb-icon.gif" width="20" height="20" alt="FB"
                              border="0" align="top"/></a> | <a
                           href="https://twitter.com/rockarch_org" class="twitter-follow-button"
                           data-show-count="false" data-show-screen-name="false"/>
                        <script>!function(d,s,id){var
                           js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document,
                           'script', 'twitter-wjs');</script>
                        <!--/htdig_noindex-->
                     </td>
                  </tr>
               </table>
            </td>
         </tr>
      </table>
      <div id="header">
        <a href="/xtf/search">
          <img src="http://www.rockarch.org/images/RAC-logo.png" width="103" height="140"
            alt="The Rockefeller Archive Center" border="0"/>
          <h1>dimes.rockarch.org</h1>
          <p class="tagline">The Online Collections and Catalog of Rockefeller Archive
            Center</p>
        </a>
      </div>

      <div class="searchPage">
        <div class="forms" style="padding:1%;width:98%">
        <h1>Oops, there was an error!</h1>
        <xsl:choose>
          <xsl:when test="InvalidDocument 
                          or NoPermission">
            <xsl:apply-templates/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="*">
              <xsl:call-template name="GeneralError"/>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>

      </div>
      </div>
     </body>
  </html>
      </xsl:otherwise>
   </xsl:choose>

</xsl:template>


<!-- In the case of an InvalidDocument exception, the only relevant info is the document identifier. -->
<xsl:template match="InvalidDocument">
  <h1>Document Not Found</h1>
  <p>Document <b><xsl:value-of select="$docId"/></b> is not available. Please check that you have typed the address correctly or that the referring page does not have an error in its link.</p>
  <p>Document ID: <b><xsl:value-of select="$docId"/></b></p>
</xsl:template>


<!-- For a NoPermission exception, the document identifier and IP address are relevant. -->
<xsl:template match="NoPermission">
  <h1>Access Restricted</h1>
  <p>You have been denied access to this <xsl:value-of select="$project-name"/> Text. This book is available only to University of California faculty, staff, and students. If you <i>are</i> a member of the UC community and are off campus, you must use the <a href="http://www.cdlib.org/hlp/directory/proxy.html#proxyserver" target="_self">proxy server</a> for your campus to access this title.</p>
  <p>If you have questions, need further technical assistance, or believe that you have reached this page in error, send email to the CDL (<a href="{concat('mailto:cdl@www.cdlib.org?subject=Access%20denied%20-%20', encode-for-uri($reason))}">cdl@www.cdlib.org</a>) or call the CDL Helpline (510.987.0555). Be sure to include the following information in your communication:</p>
  <p>Document ID: <b><xsl:value-of select="$docId"/></b> and  IP Address:<b> <xsl:apply-templates select="ipAddr"/></b>.</p>
</xsl:template>


<!-- For all other exceptions, output all the information we can. -->
<xsl:template name="GeneralError">
  <h1>Servlet Error: <xsl:value-of select="name()"/></h1>
  <h3>An unexpected servlet error has occurred.</h3>
  <xsl:apply-templates/>
  <p>If you have questions, need further technical assistance, or believe that you have reached this page in error, send email to the CDL (<a href="{concat('mailto:cdl@www.cdlib.org?subject=Access%20denied%20-%20', encode-for-uri($reason))}">cdl@www.cdlib.org</a>) or call the CDL Helpline (510.987.0555). Be sure to include the above message and/or stack trace in your communication.</p>
</xsl:template>


<!-- If a message was passed in, format it. -->
<xsl:template match="message">
  <p><b>Message:</b><br/><br/><xsl:apply-templates/></p>
</xsl:template>


<!-- If stack trace was specified, format it. Note that it already contains internal <br/> tags to separate lines. -->
<xsl:template match="stackTrace">
  <p><b>Stack Trace:</b><br/><br/><xsl:apply-templates/></p>
</xsl:template>


<!-- Pass <br> tags through untouched. -->
<xsl:template match="br">
    <br/>
</xsl:template>


</xsl:stylesheet>

