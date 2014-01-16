<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   exclude-result-prefixes="#all"
   version="2.0">

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
   
   <xsl:output method="xhtml" indent="no" 
      encoding="UTF-8" media-type="text/html; charset=UTF-8" 
      doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" 
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" 
      omit-xml-declaration="yes"/>
   
   <!-- 
      
      When an error occurs (either authorization or an internal error),
      a stylesheet is used to produce a nicely formatted page for the
      requester. This tag specifies the path to the stylesheet, relative
      to the servlet base directory.
      
      The stylesheet receives one of the following mini-documents as input:
      
      <UnsupportedQuery>
      <message>error message</message>
      </UnsupportedQuery>
      
      or
      
      <QueryFormat>
      <message>error message</message>
      </QueryFormat>
      
      or
      
      <TermLimit>
      <message>error message</message>
      </TermLimit>
      
      or
      
      <ExcessiveWork>
      <message>error message</message>
      </ExcessiveWork>
      
      or
      
      <some general exception>
      <message>a descriptive error message (if any)</message>
      <stackTrace>HTML-formatted Java stack trace</stackTrace>
      </some general exception>
      
      For convenience, all of this information is also made available in XSLT
      parameters:
      
      $exception    Name of the exception that occurred - "TermLimit",
      "QueryFormat", or other names.
      
      $message      More descriptive details about what occurred
      
      $stackTrace   JAVA stack trace for non-standard exceptions.
      
                                                                               -->
   
   
   <!-- ====================================================================== -->
   <!-- Parameters                                                             -->
   <!-- ====================================================================== -->
   
   <xsl:param name="exception"/>
   <xsl:param name="message"/>
   <xsl:param name="stackTrace" select="''"/>
   
   <!-- ====================================================================== -->
   <!-- Root Template                                                          -->
   <!-- ====================================================================== -->
   
   <!-- 
      For this sample error generation stylesheet, we use the input mini-
      document instead of the parameters.
   -->
   
   <xsl:variable name="reason">
      <xsl:choose>
         <xsl:when test="//QueryFormat">
            <xsl:text>crossQuery Error: Query Format</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>crossQuery Error: Servlet Error</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:variable>
   
   <xsl:template match="/">
      <html>
         <head>
            <title><xsl:value-of select="$reason"/></title>
            <meta name="viewport" content="width=device-width,initial-scale=1"/>
               <meta name="viewport" content="width=device-width,initial-scale=1"/>
               <link href='http://fonts.googleapis.com/css?family=Questrial' rel='stylesheet' type='text/css'/>
               <link rel="stylesheet" type="text/css" href="/xtf/css/jquery-ui/css/rac-custom/jquery-ui.css"/>
               <link rel="stylesheet" href="css/default/results.css" type="text/css"/>
               <link rel="stylesheet" href="http://www.rockarch.org/css/more.css" type="text/css"/>
               <!-- 9/27/11 WS: Added new stylesheet to contain all RA specific css -->
               <link rel="shortcut icon" href="icons/default/favicon.png"/>
               <!-- 9/27/11 WS: RA links and javascript -->
               <link rel="stylesheet" type="text/css" href="http://www.rockarch.org/css/bootstrap.css"/>
               <link rel="stylesheet" href="css/default/racustom.css" type="text/css"/>
               <script id="twitter-wjs" src="http://platform.twitter.com/widgets.js"></script>
               <script type='text/javascript' src='http://code.jquery.com/jquery-1.8.3.js'></script>
               <script type="text/javascript" src="http://code.jquery.com/ui/1.9.2/jquery-ui.js"></script>
               <script type="text/javascript" src="http://www.rockarch.org/js/bootstrap.js"></script>
               <script type="text/javascript" language="JavaScript" src="http://www.rockarch.org/js/browserDetect.js"/>
               <script type="text/javascript" src="/xtf/script/rac/dropdown.js"/>
               <script type="text/javascript" src="/xtf/script/rac/searchbox.js"/>
               <script type="text/javascript" src="/xtf/script/rac/accordion.js"/>
               <script type="text/javascript" src="/xtf/script/rac/active.js"/>
               <script type="text/javascript" src="/xtf/script/rac/jquery.cookie.js"></script>
               <script type="text/javascript"> var _gaq = _gaq || []; _gaq.push(['_setAccount',
         'UA-10013579-1']); _gaq.push(['_trackPageview']); (function() { var ga =
         document.createElement('script'); ga.type = 'text/javascript'; ga.async = true; ga.src =
         ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') +
         '.google-analytics.com/ga.js'; var s = document.getElementsByTagName('script')[0];
         s.parentNode.insertBefore(ga, s); })(); </script>
         </head>
         <body>
            <!-- 1/10/14 HA: Changed to match updated RA header -->

               <div class="navbar">
                  <div class="navbar-inner">
                     <div class="container">
                        
                        <!-- .btn-navbar is used as the toggle for collapsed navbar content -->
                        <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
                           <span class="icon-bar"></span>
                           <span class="icon-bar"></span>
                           <span class="icon-bar"></span>
                        </a>
                        
                        <!-- Everything you want hidden at 940px or less, place within here -->
                        <div class="nav-collapse collapse">
                           <ul class="nav">
                              <li class="dropdown">
                                 <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                    About Us
                                    <b class="caret"></b>
                                 </a>
                                 <ul class="dropdown-menu">
                                    <li><a tabindex="-1" href="http://www.rockarch.org/about/" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'About Us', 'Overview']);">Overview</a></li>
                                    <li><a tabindex="-1" href="http://www.rockarch.org/research/inforesearch.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'About Us', 'General Information']);">General Information</a></li>
                                    <li><a tabindex="-1" href="http://www.rockarch.org/about/staff.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'About Us', 'Staff']);">Staff</a></li>
                                    <li><a tabindex="-1" href="http://www.rockarch.org/about/careers.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'About Us', 'Employment Opportunities']);">Employment Opportunities</a></li>
                                    <li><a tabindex="-1" href="http://www.rockarch.org/about/contact.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'About Us', 'Contact Us']);">Contact Us</a></li>
                                 </ul>
                              </li>
                              <li class="dropdown">
                                 <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                    Grants
                                    <b class="caret"></b>
                                 </a>
                                 <ul class="dropdown-menu">
                                    <li><a tabindex="-1" href="http://www.rockarch.org/grants/generalgia.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Grants', 'Grant-in-Aid']);">Grant-in-Aid</a></li>
                                    <li><a tabindex="-1" href="http://www.rockarch.org/grants/ehrlichgrant.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Grants', 'Ehrlich Grants']);">Grants to Support Research in the Paul Ehrlich Collection</a></li>
                                    <li><a tabindex="-1" href="http://www.rockarch.org/research/inforesearch.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Grants', 'Information for Researchers']);">Information for Researchers</a></li>
                                    <li><a tabindex="-1" href="http://www.rockarch.org/grants/currentawards.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Grants', 'Grant Awards']);">Grant Awards</a></li>
                                    <li><a tabindex="-1" href="http://www.rockarch.org/publications/resrep/" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Grants', 'Research Reports']);">Research Reports</a></li>
                                 </ul>
                              </li>
                              <li class="dropdown">
                                 <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                    Collections
                                    <b class="caret"></b>
                                 </a>
                                 <ul class="dropdown-menu">
                                    <li><a tabindex="-1" href="http://dimes.rockarch.org/xtf/search" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Search All Collection Guides']);">Search All Collection Guides</a></li>
                                    <li class="dropdown-submenu">
                                       <a tabindex="-1" href="#">Foundations (A-F)</a>
                                       <ul class="dropdown-menu">
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rockorgs/jdr3orgs.php#acc" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Asian Cultural Council']);">Asian Cultural Council</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/nonrockorgs/culpeper.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Charles E. Culpeper Foundation']);">Charles E. Culpeper Foundation</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rockorgs/cmbny.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'China Medical Board']);">China Medical Board of New York</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/nonrockorgs/commonwealth.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Commonwealth Fund']);">Commonwealth Fund</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rockorgs/jdrjrorgs.php#davison" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Davison Fund']);">Davison Fund</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/ford/" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Ford Foundation']);">Ford Foundation</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/nonrockorgs/fcd.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Foundation for Child Development']);">Foundation for Child Development</a></li>
                                       </ul>
                                    </li>
                                    <li class="dropdown-submenu">
                                       <a tabindex="-1" href="#">Foundations (G-M)</a>
                                       <ul class="dropdown-menu">
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rockorgs/geb.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'General Education Board']);">General Education Board</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/nonrockorgs/hrf.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Health Research Fund']);">Health Research Fund</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rockorgs/jdrjrorgs.php#ieb" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'International Education Board']);">International Education Board</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/nonrockorgs/markle.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Markle Foundation']);">John and Mary Markle Foundation</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rockorgs/jdr3orgs.php#jdr3" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'JDR 3rd Fund']);">JDR 3rd Fund</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rockorgs/lsrm.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Laura Spelman Rockefeller Memorial']);">Laura Spelman Rockefeller Memorial</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/nonrockorgs/markey.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Lucille P. Markey Charitable Trust']);">Lucille P. Markey Charitable Trust</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rockorgs/miscorgs.php#mbr" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Martha Baird Rockefeller Fund for Music']);">Martha Baird Rockefeller Fund for Music</a></li>
                                       </ul>
                                    </li>
                                    <li class="dropdown-submenu">
                                       <a tabindex="-1" href="#">Foundations (N-Z)</a>
                                       <ul class="dropdown-menu">
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/nonrockorgs/neareast.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Near East Foundation']);">Near East Foundation</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rbf/" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Rockefeller Brothers Fund']);">Rockefeller Brothers Fund</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rf/" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Rockefeller Foundation']);">Rockefeller Foundation</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/nonrockorgs/sage.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Russell Sage Foundation']);">Russell Sage Foundation</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rockorgs/jdrjrorgs.php#sealantic" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Sealantic Fund']);">Sealantic Fund</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rockorgs/miscorgs.php#spelman" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Spelman Fund of New York']);">Spelman Fund of New York</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/nonrockorgs/wtgrant.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'William T. Grant Foundation']);">William T. Grant Foundation</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/nonrockorgs/wwilson.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Woodrow Wilson National Fellowship Foundation']);">Woodrow Wilson National Fellowship Foundation</a></li>
                                       </ul>
                                    </li>
                                    <li class="dropdown-submenu">
                                       <a tabindex="-1" href="#">Other Organizations (A-H)</a>
                                       <ul class="dropdown-menu">
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rockorgs/jdr3orgs.php#adc" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Agricultural Development Council']);">Agricultural Development Council</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rockorgs/narorgs.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'American International Association for Economic and Social Development']);">American International Association for Economic and Social Development</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rockorgs/miscorgs.php#aeap" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Arts, Education and Americans Panel']);">Arts, Education and Americans Panel</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rockorgs/jdr3orgs.php#asiasoc" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Asia Society']);">Asia Society</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rockorgs/bsh.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Bureau of Social Hygeiene']);">Bureau of Social Hygiene</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/nonrockorgs/counfound.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Council on Foundations']);">Council on Foundations</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rockorgs/miscorgs.php#dlma" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Downtown-Lower Manhattan Association']);">Downtown-Lower Manhattan Association, Inc.</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/nonrockorgs/foundationcenter.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Foundation Center']);">Foundation Center</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rockorgs/miscorgs.php#goldhinz" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Goldstone and Hinz']);">Goldstone &amp; Hinz</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rockorgs/jdrjrorgs.php#hhv" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Historic Hudson Valley Manuscript Collection']);">Historic Hudson Valley Manuscript Collection</a></li>
                                       </ul>
                                    </li>
                                    <li class="dropdown-submenu">
                                       <a tabindex="-1" href="#">Other Organizations (I-Z)</a>
                                       <ul class="dropdown-menu">
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rockorgs/narorgs.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'International Basic Economy Corporation']);">International Basic Economy Corporation</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rockorgs/miscorgs.php#mskcc" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Memorial Sloan-Kettering Cancer Center']);">Memorial Sloan-Kettering Cancer Center</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rockorgs/popcouncil.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Population Council']);">Population Council</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rockorgs/jdr3orgs.php#poa" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Products of Asia']);">Products of Asia</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rockorgs/hookworm.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Rockefeller Sanitary Commission']);">Rockefeller Sanitary Commission</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/nonrockorgs/ssrc.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Social Science Research Council']);">Social Science Research Council</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rockorgs/miscorgs.php#trilateral" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Trilateral Commission']);">Trilateral Commission</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rockorgs/miscorgs.php#uniontank" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Union Tank Car Company']);">Union Tank Car Company</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/rockorgs/miscorgs.php#wcph" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Women's Club of Pocantico Hills']);">Women's Club of Pocantico Hills</a></li>
                                       </ul>
                                    </li>
                                    <li class="dropdown-submenu">
                                       <a tabindex="-1" href="#">Rockefeller University</a>
                                       <ul class="dropdown-menu">
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/ru/" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Rockefeller University Collections Overview']);">Collections Overview</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/ru/rgdescriptions.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Rockefeller University Record Group Descriptions']);">Record Group Descriptions</a></li>
                                       </ul>
                                    </li>
                                    <li class="dropdown-submenu">
                                       <a tabindex="-1" href="#">Rockefeller Family</a>
                                       <ul class="dropdown-menu">
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/family/jdrsr/" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'John D. Rockefeller Papers']);">John D. Rockefeller Papers</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/family/william.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'William Rockefeller Papers']);">William Rockefeller Papers</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/family/omr.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Office of the Messrs. Rockefeller']);">Office of the Messrs. Rockefeller</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/family/jdrjr/" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'John D. Rockefeller, Jr. Papers']);">John D. Rockefeller, Jr. Papers</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/family/abby/" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Abby Aldrich Rockefeller Paper']);">Abby Aldrich Rockefeller Papers</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/family/abbymauze.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Abby R. Mauze Papers']);">Abby R. Mauzé Papers</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/family/jdr3/" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'John D. Rockefeller 3rd Papers']);">John D. Rockefeller 3rd Papers</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/family/blanchetterockefeller.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Blanchette H. Rockefeller Papers']);">Blanchette H. Rockefeller Papers</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/family/laurance.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Laurance S. Rockefeller Papers']);">Laurance S. Rockefeller Papers</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/family/nar/" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Nelson A. Rockefeller Papers']);">Nelson A. Rockefeller Papers</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/family/winthrop.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Winthrop Rockefeller Papers']);">Winthrop Rockefeller Papers</a></li>
                                       </ul>
                                    </li>
                                    <li class="dropdown-submenu">
                                       <a tabindex="-1" href="#">Papers of Individuals</a>
                                       <ul class="dropdown-menu">
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/individuals/rf/" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Papers of Individuals - Foundation Related']);">Foundation Related</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/individuals/family/" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Papers of Individuals - Rockefeller Family Related']);">Rockefeller Family Related</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/collections/individuals/ru/" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Collections', 'Papers of Individuals - Rockefeller University Related']);">Rockefeller University Related</a></li>
                                       </ul>
                                    </li>
                                 </ul>
                              </li>
                              <li class="dropdown">
                                 <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                    Programs
                                    <b class="caret"></b>
                                 </a>
                                 <ul class="dropdown-menu">
                                    <li><a tabindex="-1" href="http://www.rockarch.org/programs/digital/" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Programs', 'Digital']);">Digital</a></li>
                                    <li><a tabindex="-1" href="http://www.rockarch.org/programs/research/" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Programs', 'Research and Education']);">Research &amp; Education</a></li>
                                    <li class="dropdown-submenu">
                                       <a tabindex="-1" href="#">Publications</a>
                                       <ul class="dropdown-menu">
                                          <li><a tabindex="-1" href="http://www.rockarch.org/publications/guides/" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Programs', 'Publications - Guides and Subject Surveys']);">Guides and Subject Surveys</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/publications/newsletter/" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Programs', 'Publications - Newsletters']);">Newsletters</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/publications/resrep/" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Programs', 'Publications - Research Reports']);">Research Reports</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/publications/biblio/" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Programs', 'Publications - Bibliographies']);">Bibliographies</a></li>
                                          <li><a tabindex="-1" href="http://www.rockarch.org/publications/conferences/" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Programs', 'Publications - Conference Proceedings']);">Conference Proceedings</a></li>
                                       </ul>
                                    </li>
                                 </ul>
                              </li>
                              <li class="dropdown">
                                 <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                    The Rockefellers
                                    <b class="caret"></b>
                                 </a>
                                 <ul class="dropdown-menu">
                                    <li><a tabindex="-1" href="http://www.rockarch.org/bio/famtree.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'The Rockefellers', 'Virtual Family Tree']);">Virtual Family Tree</a></li>
                                    <li><a tabindex="-1" href="http://www.rockarch.org/bio/" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'The Rockefellers', 'Selected Biographies']);">Selected Biographies</a></li>
                                    <li><a tabindex="-1" href="http://www.rockarch.org/inownwords/" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'The Rockefellers', 'In Their Own Words']);">In Their Own Words</a></li>
                                    <li><a tabindex="-1" href="http://www.rockarch.org/philanthropy/" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'The Rockefellers', 'Rockefeller Philanthropy']);">Rockefeller Philanthropy</a></li>
                                    <li><a tabindex="-1" href="http://www.rockarch.org/publications/biblio/bibliofamily.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'The Rockefellers', 'Bibliography on the Rockefeller Family and Philanthropies']);">Bibliography on the Rockefeller Family and Philanthropies</a></li>
                                 </ul>
                              </li>
                              <li class="dropdown">
                                 <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                    Information for Researchers
                                    <b class="caret"></b>
                                 </a>
                                 <ul class="dropdown-menu">
                                    <li><a tabindex="-1" href="http://www.rockarch.org/research/inforesearch.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Information for Researchers', 'Information for Researchers']);">Information for Researchers</a></li>
                                    <li><a tabindex="-1" href="http://www.rockarch.org/about/contact.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Information for Researchers', 'Research Inquiries']);">Research Inquiries</a></li>
                                    <li><a tabindex="-1" href="http://www.rockarch.org/research/citations.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Information for Researchers', 'Sample Citations']);">Sample Citations</a></li>
                                 </ul>
                              </li>
                              <li><a tabindex="-1" href="http://www.rockarch.org/search/searchmain.php" onClick="_gaq.push(['_trackEvent', 'Rockarch Nav', 'Search', 'Navbar']);">Search</a>
                              </li>
                           </ul>
                        </div>
                     </div>
                  </div>
               </div>
               <div class="comment">									
                  <a href="http://www.rockarch.org/" class="home">Home</a> |
                  <a href="http://www.rockarch.org/faqs/" class="home">FAQs</a> | 
                  <a href="http://www.rockarch.org/links.php" class="home">Links</a> | 
                  <a href="http://www.rockarch.org/about/contact.php" class="home">E-Mail</a><br/>									
                  <a href="http://www.facebook.com/RockefellerArchiveCenter" onClick="_gaq.push(['_trackEvent', 'Rockarch Home', 'Social', 'Facebook']);" target="_blank"><img src="http://www.rockarch.org/images/fb-icon.gif" width="20" height="20" alt="FB" border="0" align="top"/></a>
                  <a href="https://twitter.com/rockarch_org" onClick="_gaq.push(['_trackEvent', 'Rockarch Home', 'Social', 'Twitter']);" class="twitter-follow-button" data-show-count="false" data-show-screen-name="false"></a>
                  <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
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
            <div class="searchPage">
               <div class="forms" style="padding:1%;width:98%">
               <xsl:choose>
                  <xsl:when test="QueryFormat 
                     or TermLimit
                     or ExcessiveWork
                     or UnsupportedQuery">
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
   </xsl:template>
   
   
   <!-- For a UnsupportedQuery exception, the message is irrelevant. -->
   <xsl:template match="UnsupportedQuery">
      <h1>Unsupported Query</h1>
      <p>Queries cannot be performed on content that isn't pre-indexed
         (for instance from a URL.)</p>
      <xsl:apply-templates/>
   </xsl:template>
   
   
   <!-- For a QueryFormat exception, the message is relevant. -->
   <xsl:template match="QueryFormat">
      <h1>Query format error</h1>
      <p>Your query was not understood.</p>
      <xsl:apply-templates/>
   </xsl:template>
   
   
   <!-- For a TermLimit exception, the message contains the first 50 matches. -->
   <xsl:template match="TermLimit">
      <h1>Term limit exceeded</h1>
      <p>Your query matched too many terms. Try using a smaller range, 
         eliminating wildcards, or making them more specific.</p>
      <xsl:apply-templates/>
   </xsl:template>
   
   
   <!-- For a ExcessiveWork exception, the message is not relevant. -->
   <xsl:template match="ExcessiveWork">
      <h1>Vague Query</h1>
      <p>Your query was too vague and produced only low-quality matches.
         Try making it more specific.</p>
   </xsl:template>
   
   
   <!-- For all other exceptions, output all the information we can. -->
   <xsl:template name="GeneralError">
      <h1>Servlet Error: <xsl:value-of select="name()"/></h1>
      <h3>An unexpected servlet error has occurred.</h3>
      <xsl:apply-templates/>
      <p>
         If you have questions, need further technical assistance, or believe that you have 
         reached this page in error, send email to the CDL 
         (<a href="{concat('mailto:cdl@www.cdlib.org?subject=Access%20denied%20-%20', encode-for-uri($reason))}">cdl@www.cdlib.org</a>) or call the CDL Helpline (510.987.0555). Be sure to include the above message and/or stack trace in your communication.</p>
   </xsl:template>
   
   
   <!-- If a message was passed in, format it. -->
   <xsl:template match="message">
      <p><b>Message:</b><br/><br/><span style="font-family: Courier"><xsl:apply-templates/></span></p>
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

