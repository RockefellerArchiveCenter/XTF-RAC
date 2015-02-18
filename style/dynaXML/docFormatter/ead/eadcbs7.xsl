<!-- EAD Cookbook Style 7      Version 0.9   19 January 2004 -->
<!--  This stylesheet generates a Table of Contents in an HTML frame along
   the left side of the screen. It is an update to eadcbs3.xsl designed
   to work with EAD 2002.-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xtf="http://cdlib.org/xtf" xmlns:ns2="http://www.w3.org/1999/xlink" xmlns:xlink="http://www.w3.org/1999/xlink"
   xmlns="http://www.w3.org/1999/xhtml" xmlns:session="java:org.cdlib.xtf.xslt.Session" extension-element-prefixes="session" exclude-result-prefixes="#all"
   xpath-default-namespace="urn:isbn:1-931666-22-9">

   <xsl:import href="../common/docFormatterCommon.xsl"/>
   <xsl:import href="../../../xtfCommon/xtfCommon.xsl"/>
   <xsl:import href="../../../myList/myListFormatter.xsl"/>

   <!-- Creates a variable equal to the value of the number in eadid which serves as the base
      for file names for the various components of the frameset.-->
   <xsl:variable name="file">
      <xsl:value-of select="ead/eadheader/eadid"/>
   </xsl:variable>
   <xsl:variable name="rootID">
      <xsl:choose>
         <xsl:when test="/ead/archdesc/did/unitid">
            <identifier xtf:meta="true" xtf:tokenize="no">
               <xsl:value-of select="string(/ead/archdesc/did/unitid[1])"/>
            </identifier>
         </xsl:when>
         <xsl:when test="/ead/eadheader/eadid" xtf:tokenize="no">
            <identifier xtf:meta="true" xtf:tokenize="no">
               <xsl:value-of select="string(substring-before(/ead/eadheader/eadid[1],'.xml'))"/>
            </identifier>
         </xsl:when>
         <xsl:otherwise>
            <identifier xtf:meta="true" xtf:tokenize="no">
               <xsl:value-of select="'unknown'"/>
            </identifier>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:variable>
   <!--This template creates HTML meta tags that are inserted into the HTML ouput
      for use by web search engines indexing this file.   The content of each
      resulting META tag uses Dublin Core semantics and is drawn from the text of
      the finding aid.-->
   <xsl:template name="metadata">
      <meta http-equiv="Content-Type" name="dc.title" content="{eadheader/filedesc/titlestmt/titleproper&#x20; }{eadheader/filedesc/titlestmt/subtitle}"/>
      <meta http-equiv="Content-Type" name="dc.author" content="{archdesc/did/origination}"/>

      <xsl:for-each select="xtf:meta/subject">
         <meta http-equiv="Content-Type" name="dc.subject" content="{.}"/>
      </xsl:for-each>

      <meta http-equiv="Content-Type" name="dc.title" content="{archdesc/did/unittitle}"/>
      <meta http-equiv="Content-Type" name="dc.type" content="text"/>
      <meta http-equiv="Content-Type" name="dc.format" content="manuscripts"/>
      <meta http-equiv="Content-Type" name="dc.format" content="finding aids"/>

   </xsl:template>

   <!-- Creates the body of the finding aid.-->
   <xsl:template name="body">
      <xsl:variable name="file">
         <xsl:value-of select="/ead/eadheader/eadid"/>
      </xsl:variable>
      <div id="content-wrapper" data-spy="scroll" data-target="#toc" data-offset="100">
         <div id="{$chunk.id}">
            <xsl:choose>
               <xsl:when test="$chunk.id = 'headerlink'">
                  <xsl:apply-templates select="/ead/archdesc/did"/>
               </xsl:when>
               <xsl:when test="$chunk.id = 'restrictlink'">
                  <xsl:call-template name="archdesc-restrict"/>
               </xsl:when>
               <xsl:when test="$chunk.id = 'relatedmatlink'">
                  <xsl:call-template name="archdesc-relatedmaterial"/>
               </xsl:when>
               <xsl:when test="$chunk.id = 'adminlink'">
                  <xsl:call-template name="archdesc-admininfo"/>
               </xsl:when>
               <xsl:when test="$chunk.id = 'arrangementlink'">
                  <xsl:apply-templates select="/ead/archdesc/arrangement"/>
               </xsl:when>
               <xsl:when test="$chunk.id = 'scopecontentlink'">
                  <xsl:apply-templates select="/ead/archdesc/scopecontent"/>
               </xsl:when>
               <xsl:when test="$chunk.id = 'controlaccesslink'">
                  <xsl:apply-templates select="/ead/archdesc/controlaccess"/>
               </xsl:when>
               <xsl:when test="$chunk.id = 'physdesclink'">
                  <xsl:apply-templates select="/ead/archdesc/did/physdesc[@label = 'General Physical Description note']"/>
                  <xsl:apply-templates select="/ead/archdesc/did/physdesc[not(@altrender)]"/>
               </xsl:when>
               <xsl:when test="$chunk.id = 'contentsLink'">
                  <xsl:choose>
                     <xsl:when test="$doc.view='contentsSearch'">
                        <xsl:call-template name="containerHits"/>
                        <xsl:apply-templates select="/ead/archdesc/dsc/child::*[@level and @xtf:hitCount]"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:apply-templates select="/ead/archdesc/dsc/child::*[@level]"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:when>
               <xsl:when test="$chunk.id = 'digitalLink'">
                  <div typeof="schema:ImageGallery">
                     <xsl:apply-templates select="/ead/archdesc/dsc/child::*[xtf:meta/*:type = 'dao'][@level]"/>
                  </div>
               </xsl:when>
               <xsl:when test="$chunk.id = 'bioghist'">
                  <xsl:apply-templates select="/ead/archdesc/bioghist"/>
               </xsl:when>
               <xsl:when test="$chunk.id != '0'">
                  <xsl:choose>
                     <xsl:when test="$doc.view='contentsSearch'">
                        <xsl:call-template name="containerHits"/>
                        <xsl:apply-templates select="key('chunk-id', $chunk.id)"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:apply-templates select="key('chunk-id', $chunk.id)"/>
                     </xsl:otherwise>
                  </xsl:choose>

               </xsl:when>
               <xsl:otherwise>
                  <!--<xsl:apply-templates select="/ead/eadheader"/>-->
                  <xsl:apply-templates select="/ead/archdesc/did"/>
               </xsl:otherwise>
            </xsl:choose>
         </div>
      </div>

   </xsl:template>
   <!-- Creates anchors within the document -->
   <xsl:template name="anchor">
      <xsl:choose>
         <xsl:when test="@id">
            <xsl:attribute name="id">
               <xsl:value-of select="@id"/>
            </xsl:attribute>
         </xsl:when>
         <xsl:otherwise>
            <xsl:attribute name="id">
               <xsl:value-of select="generate-id(.)"/>
            </xsl:attribute>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- The following general templates format the display of various RENDER
      attributes.-->
   <xsl:template match="emph[@render='bold']">
      <strong>
         <xsl:apply-templates/>
      </strong>
   </xsl:template>
   <xsl:template match="emph[@render='italic']">
      <i>
         <xsl:apply-templates/>
      </i>
   </xsl:template>
   <xsl:template match="emph[@render='underline']">
      <u>
         <xsl:apply-templates/>
      </u>
   </xsl:template>
   <xsl:template match="emph[@render='sub']">
      <sub>
         <xsl:apply-templates/>
      </sub>
   </xsl:template>
   <xsl:template match="emph[@render='super']">
      <super>
         <xsl:apply-templates/>
      </super>
   </xsl:template>
   <xsl:template match="emph[@render='quoted']">
      <xsl:text>"</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>"</xsl:text>
   </xsl:template>
   <xsl:template match="emph[@render='doublequote']">
      <xsl:text>"</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>"</xsl:text>
   </xsl:template>
   <xsl:template match="emph[@render='singlequote']">
      <xsl:text>'</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>'</xsl:text>
   </xsl:template>
   <xsl:template match="emph[@render='bolddoublequote']">
      <strong>
         <xsl:text>"</xsl:text>
         <xsl:apply-templates/>
         <xsl:text>"</xsl:text>
      </strong>
   </xsl:template>
   <xsl:template match="emph[@render='boldsinglequote']">
      <strong>
         <xsl:text>'</xsl:text>
         <xsl:apply-templates/>
         <xsl:text>'</xsl:text>
      </strong>
   </xsl:template>
   <xsl:template match="emph[@render='boldunderline']">
      <strong>
         <u>
            <xsl:apply-templates/>
         </u>
      </strong>
   </xsl:template>
   <xsl:template match="emph[@render='bolditalic']">
      <strong>
         <i>
            <xsl:apply-templates/>
         </i>
      </strong>
   </xsl:template>
   <xsl:template match="emph[@render='boldsmcaps']">
      <font style="font-variant: small-caps">
         <strong>
            <xsl:apply-templates/>
         </strong>
      </font>
   </xsl:template>
   <xsl:template match="emph[@render='smcaps']">
      <font style="font-variant: small-caps">
         <xsl:apply-templates/>
      </font>
   </xsl:template>
   <xsl:template match="title[@render='bold']">
      <strong>
         <xsl:apply-templates/>
      </strong>
   </xsl:template>
   <xsl:template match="title[@render='italic']">
      <i>
         <xsl:apply-templates/>
      </i>
   </xsl:template>
   <xsl:template match="title[@render='underline']">
      <u>
         <xsl:apply-templates/>
      </u>
   </xsl:template>
   <xsl:template match="title[@render='sub']">
      <sub>
         <xsl:apply-templates/>
      </sub>
   </xsl:template>
   <xsl:template match="title[@render='super']">
      <super>
         <xsl:apply-templates/>
      </super>
   </xsl:template>
   <xsl:template match="title[@render='quoted']">
      <xsl:text>"</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>"</xsl:text>
   </xsl:template>
   <xsl:template match="title[@render='doublequote']">
      <xsl:text>"</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>"</xsl:text>
   </xsl:template>
   <xsl:template match="title[@render='singlequote']">
      <xsl:text>'</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>'</xsl:text>
   </xsl:template>
   <xsl:template match="title[@render='bolddoublequote']">
      <strong>
         <xsl:text>"</xsl:text>
         <xsl:apply-templates/>
         <xsl:text>"</xsl:text>
      </strong>
   </xsl:template>
   <xsl:template match="title[@render='boldsinglequote']">
      <strong>
         <xsl:text>'</xsl:text>
         <xsl:apply-templates/>
         <xsl:text>'</xsl:text>
      </strong>
   </xsl:template>
   <xsl:template match="title[@render='boldunderline']">
      <strong>
         <u>
            <xsl:apply-templates/>
         </u>
      </strong>
   </xsl:template>
   <xsl:template match="title[@render='bolditalic']">
      <strong>
         <i>
            <xsl:apply-templates/>
         </i>
      </strong>
   </xsl:template>
   <xsl:template match="title[@render='boldsmcaps']">
      <font style="font-variant: small-caps">
         <strong>
            <xsl:apply-templates/>
         </strong>
      </font>
   </xsl:template>
   <xsl:template match="title[@render='smcaps']">
      <font style="font-variant: small-caps">
         <xsl:apply-templates/>
      </font>
   </xsl:template>

   <!-- This template converts a Ref element into an HTML anchor.-->
   <xsl:template match="ref">
      <a href="#{@target}">
         <xsl:apply-templates/>
      </a>
   </xsl:template>

   <!--Bibref, choose statement decides if the citation is inline, if there is a parent element
      or if it is its own line, typically when it is a child of the bibliography element.-->
   <xsl:template match="bibref">
      <xsl:choose>
         <xsl:when test="parent::p">
            <xsl:choose>
               <xsl:when test="@ns2:href | @xlink:href">
                  <a href="{@ns2:href | @xlink:href}">
                     <xsl:apply-templates/>
                  </a>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:apply-templates/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <p>
               <xsl:choose>
                  <xsl:when test="@ns2:href | @xlink:href">
                     <a href="{@ns2:href | @xlink:href}">
                        <xsl:apply-templates/>
                     </a>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:apply-templates/>
                  </xsl:otherwise>
               </xsl:choose>
            </p>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- Output for a variety of list types -->
   <xsl:template match="list">
      <xsl:if test="head">
         <h4>
            <xsl:value-of select="head"/>
         </h4>
      </xsl:if>
      <xsl:choose>
         <xsl:when test="defitem">
            <dl>
               <xsl:apply-templates select="defitem"/>
            </dl>
         </xsl:when>
         <xsl:otherwise>
            <xsl:choose>
               <xsl:when test="@type = 'ordered'">
                  <ol>
                     <xsl:attribute name="class">
                        <xsl:value-of select="@numeration"/>
                     </xsl:attribute>
                     <xsl:apply-templates/>
                  </ol>
               </xsl:when>
               <xsl:when test="@numeration">
                  <ol>
                     <xsl:attribute name="class">
                        <xsl:value-of select="@numeration"/>
                     </xsl:attribute>
                     <xsl:apply-templates/>
                  </ol>
               </xsl:when>
               <xsl:when test="@type='simple'">
                  <ul>
                     <xsl:attribute name="class">simple</xsl:attribute>
                     <xsl:apply-templates select="child::*[not(head)]"/>
                  </ul>
               </xsl:when>
               <xsl:otherwise>
                  <ul>
                     <xsl:apply-templates/>
                  </ul>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="list/head"/>
   <xsl:template match="list/item">
      <li>
         <xsl:apply-templates/>
      </li>
   </xsl:template>
   <xsl:template match="defitem">
      <dt>
         <xsl:apply-templates select="label"/>
      </dt>
      <dd>
         <xsl:apply-templates select="item"/>
      </dd>
   </xsl:template>

   <!-- Formats list as tabel if list has listhead element  -->
   <xsl:template match="list[child::listhead]">
      <table>
         <tr>
            <th>
               <xsl:value-of select="listhead/head01"/>
            </th>
            <th>
               <xsl:value-of select="listhead/head02"/>
            </th>
         </tr>
         <xsl:for-each select="defitem">
            <tr>
               <td>
                  <xsl:apply-templates select="label"/>
               </td>
               <td>
                  <xsl:apply-templates select="item"/>
               </td>
            </tr>
         </xsl:for-each>
      </table>
   </xsl:template>

   <!--Formats a simple table. The width of each column is defined by the colwidth attribute in a colspec element.-->
   <xsl:template match="table">
      <table width="75%" style="margin-left: 25pt">
         <tr>
            <td colspan="3">
               <h4>
                  <xsl:apply-templates select="head"/>
               </h4>
            </td>
         </tr>
         <xsl:for-each select="tgroup">
            <tr>
               <xsl:for-each select="colspec">
                  <td width="{@colwidth}"/>
               </xsl:for-each>
            </tr>
            <xsl:for-each select="thead">
               <xsl:for-each select="row">
                  <tr>
                     <xsl:for-each select="entry">
                        <td valign="top">
                           <strong>
                              <xsl:apply-templates/>
                           </strong>
                        </td>
                     </xsl:for-each>
                  </tr>
               </xsl:for-each>
            </xsl:for-each>

            <xsl:for-each select="tbody">
               <xsl:for-each select="row">
                  <tr>
                     <xsl:for-each select="entry">
                        <td valign="top">
                           <xsl:apply-templates/>
                        </td>
                     </xsl:for-each>
                  </tr>
               </xsl:for-each>
            </xsl:for-each>
         </xsl:for-each>
      </table>
   </xsl:template>
   <!--This template rule formats a chronlist element.-->
   <xsl:template match="chronlist">
      <table style="margin-left:18pt;border:1px solid #333;">
         <xsl:apply-templates/>
         <tr>
            <td width="5%"> </td>
            <td width="15%"> </td>
            <td width="80%"> </td>
         </tr>
      </table>
   </xsl:template>

   <xsl:template match="chronlist/head">
      <tr>
         <td colspan="3">
            <h4>
               <xsl:apply-templates/>
            </h4>
         </td>
      </tr>
   </xsl:template>

   <xsl:template match="chronlist/listhead">
      <tr>
         <td> </td>
         <td>
            <strong>
               <xsl:apply-templates select="head01"/>
            </strong>
         </td>
         <td>
            <strong>
               <xsl:apply-templates select="head02"/>
            </strong>
         </td>
      </tr>
   </xsl:template>

   <xsl:template match="chronitem">
      <!--Determine if there are event groups.-->
      <xsl:choose>
         <xsl:when test="eventgrp">
            <!--Put the date and first event on the first line.-->
            <tr>
               <td> </td>
               <td valign="top">
                  <xsl:apply-templates select="date"/>
               </td>
               <td valign="top">
                  <xsl:apply-templates select="eventgrp/event[position()=1]"/>
               </td>
            </tr>
            <!--Put each successive event on another line.-->
            <xsl:for-each select="eventgrp/event[not(position()=1)]">
               <tr>
                  <td> </td>
                  <td> </td>
                  <td valign="top">
                     <xsl:apply-templates select="."/>
                  </td>
               </tr>
            </xsl:for-each>
         </xsl:when>
         <!--Put the date and event on a single line.-->
         <xsl:otherwise>
            <tr>
               <td> </td>
               <td valign="top">
                  <xsl:apply-templates select="date"/>
               </td>
               <td valign="top">
                  <xsl:apply-templates select="event"/>
               </td>
            </tr>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--Suppreses all other elements of eadheader.-->
   <xsl:template match="eadheader">
      <h2 style="text-align:center">
         <xsl:value-of select="filedesc/titlestmt/titleproper"/>
      </h2>
      <h3 style="text-align:center">
         <xsl:value-of select="filedesc/titlestmt/subtitle"/>
      </h3>
      <br/>
   </xsl:template>

   <!--This template creates a table for the did, inserts the head and then
      each of the other did elements.  To change the order of appearance of these
      elements, change the sequence of the apply-templates statements.-->
   <xsl:template match="archdesc/did">
      <div class="overview">
         <h2>Overview</h2>
         <!--One can change the order of appearance for the children of did
            by changing the order of the following statements.-->
         <!-- Commenting out repository,unitid, langmaterial for now -->
         <!--         <xsl:apply-templates select="repository"/>-->
         <xsl:call-template name="creators"/>
         <xsl:apply-templates select="unittitle"/>
         <xsl:apply-templates select="../scopecontent" mode="overview"/>
         <xsl:apply-templates select="unitdate"/>
         <xsl:apply-templates select="physdesc[extent]"/>
         <xsl:apply-templates select="abstract"/>
         <!--         <xsl:apply-templates select="unitid"/>-->
         <!--         <xsl:apply-templates select="physloc"/>-->
         <!--         <xsl:apply-templates select="langmaterial"/>-->
         <xsl:apply-templates select="materialspec"/>
         <xsl:apply-templates select="note"/>
         <xsl:call-template name="contributors"/>
         <!-- Added link to Contents list -->
         <xsl:variable name="nodesLst">
            <xsl:choose>
               <xsl:when test="/ead/archdesc/dsc/child::*[1][@level = 'file']">archdesc/dsc/child::*</xsl:when>
               <xsl:otherwise>archdesc/dsc/child::*[1]</xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <!-- 8/28/12 HA: Added condition to test for finding aids with no contents list and supress this tab -->
         <xsl:if test="/ead/archdesc/dsc/child::*">
            <div style="margin-top:12px">
               <xsl:call-template name="make-tab-link">
                  <xsl:with-param name="name" select="'Go to Contents List'"/>
                  <xsl:with-param name="id" select="'contentsLink'"/>
                  <xsl:with-param name="doc.view" select="'contents'"/>
                  <xsl:with-param name="nodes" select="$nodesLst"/>
               </xsl:call-template>
            </div>
         </xsl:if>
      </div>
   </xsl:template>

   <!-- 1/19/12 WS: Special template to handle creator/contributor/source rules for RA -->
   <xsl:template name="creators">
      <xsl:if test="origination/child::*[starts-with(@role,'Author')]|origination/child::*[starts-with(@role,'aut')]">
         <h4>Creator</h4>
         <div>
            <xsl:for-each select="origination/child::*[starts-with(@role,'Author')]|origination/child::*[starts-with(@role,'aut')]">
               <div>
                  <xsl:apply-templates/>
               </div>
            </xsl:for-each>
         </div>
      </xsl:if>
   </xsl:template>

   <!-- 1/19/12 WS: Special template to handle creator/contributor/source rules for RA -->
   <xsl:template name="contributors">
      <xsl:if test="origination/child::*[starts-with(@role,'Source')]">
         <h4>Source</h4>
         <div>
            <xsl:for-each select="origination/child::*[starts-with(@role,'Source')]">
               <div>
                  <xsl:apply-templates/>
               </div>
            </xsl:for-each>
         </div>
      </xsl:if>
      <xsl:if test="origination/child::*[(not(starts-with(@role,'Author')) and not(starts-with(@role,'Source')) and not(starts-with(@role,'aut')) and not(starts-with(../@label,'source')))]">
         <h4>Contributor(s)</h4>
         <div>
            <xsl:for-each
               select="origination/child::*[(not(starts-with(@role,'Author')) and not(starts-with(@role,'Source')) and not(starts-with(@role,'aut'))and not(starts-with(../@label,'source')))]">
               <div>
                  <xsl:apply-templates/>
               </div>
            </xsl:for-each>
         </div>
      </xsl:if>
   </xsl:template>
   <!--This template formats the repostory, origination, abstract,
      unitid, physloc and materialspec elements of archdesc/did which share a common presentaiton.
      The sequence of their appearance is governed by the previous template.
      archdesc/did/langmaterial
   -->

   <xsl:template match="archdesc/did/repository | archdesc/did/unitid   
      | archdesc/did/abstract | archdesc/did/langmaterial | archdesc/did/materialspec | archdesc/did/container">
      <!--The template tests to see if there is a label attribute,
         inserting the contents if there is or adding display textif there isn't.
         The content of the supplied label depends on the element.  To change the
         supplied label, simply alter the template below.-->
      <h4>
         <xsl:choose>
            <xsl:when test="self::repository">Repository </xsl:when>
            <xsl:when test="self::physloc">Location </xsl:when>
            <xsl:when test="self::unitid">Resource ID </xsl:when>
            <xsl:when test="self::abstract">Abstract </xsl:when>
            <xsl:when test="self::langmaterial">Language </xsl:when>
            <xsl:when test="self::materialspec">Material Specific Details </xsl:when>
            <!--<xsl:otherwise><xsl:value-of select="@label"/></xsl:otherwise>-->
         </xsl:choose>
      </h4>
      <div>
         <xsl:apply-templates/>
      </div>
   </xsl:template>

   <xsl:template match="archdesc/did/unitdate">
      <xsl:choose>
         <xsl:when test="@type='inclusive'">
            <h4>Date</h4>
            <div>
               <xsl:apply-templates/>
            </div>
         </xsl:when>
         <xsl:otherwise/>
      </xsl:choose>
   </xsl:template>

   <!-- The following two templates test for and processes various permutations
      of unittitle and unitdate.-->
   <xsl:template match="archdesc/did/unittitle">
      <!--The template tests to see if there is a label attribute for unittitle,
         inserting the contents if there is or adding one if there isn't. -->
      <h4>Title</h4>
      <div>
         <xsl:apply-templates select="text() |* [not(self::unitdate)]"/>
      </div>
   </xsl:template>

   <!--This template processes the note element.-->
   <xsl:template match="archdesc/did/note">
      <xsl:for-each select="p">
         <!--The template tests to see if there is a label attribute,
            inserting the contents if there is or adding one if there isn't. -->
         <xsl:choose>
            <xsl:when test="parent::note[@label]">
               <!--This nested choose tests for and processes the first paragraph. Additional paragraphs do not get a label.-->
               <xsl:choose>
                  <xsl:when test="position()=1">
                     <h4>
                        <xsl:value-of select="@label"/>
                     </h4>
                     <div>
                        <xsl:apply-templates/>
                     </div>
                  </xsl:when>
                  <xsl:otherwise>
                     <h4>Note</h4>
                     <div>
                        <xsl:apply-templates/>
                     </div>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:when>
            <!--Processes situations where there is no
               label attribute by supplying default text.-->
            <xsl:otherwise>
               <!--This nested choose tests for and processes the first paragraph. Additional paragraphs do not get a label.-->
               <xsl:choose>
                  <xsl:when test="position()=1">
                     <h4>Note</h4>
                     <div>
                        <xsl:apply-templates/>
                     </div>
                  </xsl:when>
                  <xsl:otherwise>
                     <div>
                        <xsl:apply-templates/>
                     </div>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:otherwise>
         </xsl:choose>
         <!--Closes each paragraph-->
      </xsl:for-each>
   </xsl:template>

   <xsl:template match="scopecontent" mode="overview">
      <h4>Collection Description</h4>
      <div>
         <xsl:apply-templates select="child::*[not(name()='head')]"/>
      </div>
   </xsl:template>

   <!-- Access and Use -->
   <xsl:template name="archdesc-restrict">
      <div class="archdesc-restrict">
         <h2><a id="restrictlink"/>Access and Use</h2>
         <!--         <xsl:apply-templates select="archdesc/did/physloc"/>-->
         <xsl:apply-templates select="archdesc/accessrestrict"/>
         <xsl:apply-templates select="archdesc/userestrict"/>
         <xsl:apply-templates select="archdesc/phystech"/>
         <!--         <xsl:apply-templates select="archdesc/prefercite"/>-->
         <xsl:apply-templates select="archdesc/otherfindaid"/>
         <xsl:apply-templates select="archdesc/relatedmaterial"/>
         <xsl:apply-templates select="archdesc/altformavail"/>
         <xsl:apply-templates select="archdesc/originalsloc"/>
         <xsl:apply-templates select="archdesc/bibliography"/>
      </div>
   </xsl:template>

   <!--  10/30/11 WS for RA: Template to format scope and conents notes -->
   <xsl:template match="scopecontent">
      <h4>
         <xsl:choose>
            <xsl:when test="parent::archdesc">
               <xsl:call-template name="anchor"/>Collection Description </xsl:when>
            <xsl:when test="parent::*[@level = 'recordgrp']">Record Group Description</xsl:when>
            <xsl:when test="parent::*[@level = 'subgrp']">Subgroup Description</xsl:when>
            <xsl:when test="parent::*[@level = 'collection']">Collection Description</xsl:when>
            <xsl:when test="parent::*[@level = 'fonds']">Fonds Description</xsl:when>
            <xsl:when test="parent::*[@level = 'subfonds']">Sub-Fonds Description</xsl:when>
            <xsl:when test="parent::*[@level = 'series']">Series Description</xsl:when>
            <xsl:when test="parent::*[@level = 'subseries']">Subseries Description</xsl:when>
            <xsl:when test="parent::*[@level = 'item']">Item Description</xsl:when>
            <xsl:when test="parent::*[@level = 'file']">File Description</xsl:when>
            <xsl:otherwise>Description</xsl:otherwise>
         </xsl:choose>
      </h4>
      <xsl:apply-templates select="child::*[name() != 'head']"/>
   </xsl:template>

   <!-- Template calls and formats all other children of archdesc many of 
      these elements are repeatable within the dsc section as well.-->
   <xsl:template
      match="physloc |  accessrestrict |  userestrict |  phystech |  otherfindaid | 
      relatedmaterial |  altformavail |  originalsloc | 
      odd | custodhist | fileplan | acqinfo | processinfo | separatedmaterial | appraisal | materialspec | prefercite">
      <h4>
         <xsl:choose>
            <xsl:when test="self::physloc">Location</xsl:when>
            <xsl:when test="self::accessrestrict">
               <xsl:choose>
                  <xsl:when test="legalstatus">Access Restrictions / Legal Status</xsl:when>
                  <xsl:otherwise>Access Restrictions</xsl:otherwise>
               </xsl:choose>
            </xsl:when>
            <xsl:when test="self::userestrict">Use Restrictions</xsl:when>
            <xsl:when test="self::phystech">Physical Characteristics and Technical Requirements</xsl:when>
            <xsl:when test="self::otherfindaid">Other Finding Aids</xsl:when>
            <xsl:when test="self::relatedmaterial">Related Archival Materials</xsl:when>
            <xsl:when test="self::originalsloc">Location of Originals</xsl:when>
            <xsl:when test="self::odd">General Note</xsl:when>
            <xsl:when test="self::custodhist">Custodial History</xsl:when>
            <xsl:when test="self::altformavail">Location of Copies</xsl:when>
            <xsl:when test="self::fileplan">File Plan</xsl:when>
            <xsl:when test="self::acqinfo">Acquisition Information</xsl:when>
            <xsl:when test="self::processinfo">Processing Information</xsl:when>
            <xsl:when test="self::separatedmaterial">Separated Materials</xsl:when>
            <xsl:when test="self::prefercite">Preferred Citation</xsl:when>
            <xsl:when test="self::appraisal">Appraisal</xsl:when>
            <xsl:when test="self::accruals">Accruals</xsl:when>
            <xsl:when test="self::materialspec">Material Specific Details</xsl:when>
            <xsl:when test="self::prefercite">Preferred Citation</xsl:when>
         </xsl:choose>
      </h4>
      <xsl:choose>
         <xsl:when test="self::accessrestrict">
            <xsl:apply-templates select="p"/>
            <xsl:apply-templates select="child::*[name() != 'head' and name() != 'p']"/>
         </xsl:when>
         <xsl:when test="self::userestrict">
            <xsl:apply-templates select="p"/>
            <xsl:apply-templates select="child::*[name() != 'head' and name() != 'p']"/>
         </xsl:when>
         <xsl:when test="self::bioghist">
            <xsl:apply-templates select="p"/>
            <xsl:apply-templates select="child::*[name() != 'head' and name() != 'p']"/>
         </xsl:when>
         <xsl:when test="self::materialspec">
            <p>
               <xsl:apply-templates/>
            </p>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="child::*[name() != 'head']"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- 11/2/11 WS for RA: templates added for special handeling of physdesc notes and language -->
   <xsl:template match="physdesc">
      <xsl:choose>
         <xsl:when test="@label = 'General Physical Description note'">
            <xsl:choose>
               <xsl:when test="parent::*/parent::archdesc">
                  <h4>Physical Description of Material</h4>
                  <xsl:apply-templates/>
               </xsl:when>
               <xsl:otherwise>
                  <h4>Physical Description of Material</h4>
                  <xsl:apply-templates/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:when test="@label='Physical Facet note'">
            <h4>Physical Facet Note</h4>
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:when test="dimensions">
            <h4>Dimensions</h4>
            <xsl:apply-templates select="*[not(head)]"/>
         </xsl:when>
         <xsl:when test="extent">
            <h4>Extent</h4>
            <p>
               <xsl:value-of select="extent[1]"/>
               <xsl:if test="extent[position() &gt; 1]">, <xsl:value-of select="extent[position() &gt; 1]"/>
               </xsl:if>
            </p>
         </xsl:when>
         <xsl:otherwise>
            <h4>Physical Description of Material</h4>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="langmaterial">
      <h4>Language</h4>
      <xsl:if test="language[@langcode]">
         <p>
            <xsl:value-of select="language/@langcode"/>
         </p>
      </xsl:if>
      <xsl:apply-templates/>
   </xsl:template>

   <!-- 10/30/11 WS for RA: added choose statment to print accruals and bibliography at collection level only-->
   <xsl:template match="accruals | bibliography">
      <xsl:choose>
         <xsl:when test="parent::archdesc">
            <xsl:choose>
               <xsl:when test="self::bibliography">
                  <h4>Bibliography</h4>
               </xsl:when>
               <xsl:when test="self::accruals">
                  <h4>Accruals</h4>
               </xsl:when>
            </xsl:choose>
            <xsl:apply-templates select="child::*[name() != 'head']"/>
         </xsl:when>
         <xsl:otherwise/>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="arrangement | bioghist">
      <xsl:choose>
         <xsl:when test="parent::archdesc">
            <h2>
               <xsl:choose>
                  <xsl:when test="self::arrangement">Arrangement</xsl:when>
                  <xsl:otherwise>Biographical/Historical Note</xsl:otherwise>
               </xsl:choose>
            </h2>
         </xsl:when>
         <xsl:otherwise>
            <h4>
               <xsl:choose>
                  <xsl:when test="self::arrangement">Arrangement</xsl:when>
                  <xsl:otherwise>Biographical/Historical note</xsl:otherwise>
               </xsl:choose>
            </h4>
         </xsl:otherwise>
      </xsl:choose>
      <div>
         <xsl:apply-templates select="child::*[name() != 'head']"/>
      </div>
   </xsl:template>

   <!--This template rule formats the top-level related material
      elements by combining any related or separated materials
      elements. It begins by testing to see if there related or separated
      materials elements with content.-->

   <xsl:template name="archdesc-relatedmaterial">
      <xsl:if test="string(archdesc/relatedmaterial) or string(archdesc/*/relatedmaterial) or
         string(archdesc/separatedmaterial) or
         string(archdesc/*/separatedmaterial)">
         <h4>
            <a id="relatedmatlink">Related Material</a>
         </h4>
         <xsl:apply-templates
            select="archdesc/relatedmaterial/p
            | archdesc/*/relatedmaterial/p
            | archdesc/relatedmaterial/note/p
            | archdesc/*/relatedmaterial/note/p"/>
         <xsl:apply-templates
            select="archdesc/separatedmaterial/p
            | archdesc/*/separatedmaterial/p
            | archdesc/separatedmaterial/note/p
            | archdesc/*/separatedmaterial/note/p"/>
      </xsl:if>

   </xsl:template>

   <xsl:template match="extref">
      <xsl:choose>
         <xsl:when test="@href">
            <a href="{@href}">
               <xsl:value-of select="."/>
            </a>
         </xsl:when>
         <xsl:when test="@ns2:href | @xlink:href">
            <a href="{@ns2:href | @xlink:href}">
               <xsl:value-of select="."/>
            </a>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>


   <!--This template formats the top-level controlaccess element.
      It begins by testing to see if there is any controlled
      access element with content. It then invokes one of two templates
      for the children of controlaccess.  -->

   <xsl:template match="archdesc/controlaccess">
      <xsl:if test="string(child::*)">
         <xsl:apply-templates select="head"/>
         <p style="text-indent:25pt">
            <xsl:apply-templates select="p | note/p"/>
         </p>
         <xsl:choose>
            <!--Apply this template when there are recursive controlaccess
               elements.-->
            <xsl:when test="controlaccess">
               <xsl:apply-templates mode="recursive" select="."/>
            </xsl:when>
            <!--Apply this template when the controlled terms are entered
               directly under the controlaccess element.-->
            <xsl:otherwise>
               <xsl:apply-templates mode="direct" select="."/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
   </xsl:template>

   <!--This template formats controlled terms that are entered
      directly under the controlaccess element.  Elements are alphabetized.-->
   <xsl:template mode="direct" match="archdesc/controlaccess">
      <xsl:for-each select="subject |corpname | famname | persname | genreform | title | geogname | occupation">
         <xsl:sort select="." data-type="text" order="ascending"/>
         <div style="margin-left:50pt">
            <xsl:apply-templates/>
         </div>
      </xsl:for-each>
   </xsl:template>

   <!--When controlled terms are nested within recursive
      controlaccess elements, the template for controlaccess/controlaccess
      is applied.-->
   <xsl:template mode="recursive" match="archdesc/controlaccess">
      <xsl:apply-templates select="controlaccess"/>
   </xsl:template>

   <!--This template formats controlled terms that are nested within recursive
      controlaccess elements.   Terms are alphabetized within each grouping.-->
   <xsl:template match="archdesc/controlaccess/controlaccess">
      <h4 style="margin-left:25pt">
         <xsl:apply-templates select="head"/>
      </h4>
      <xsl:for-each select="subject |corpname | famname | persname | genreform | title | geogname | occupation">
         <xsl:sort select="." data-type="text" order="ascending"/>
         <div style="margin-left:50pt">
            <xsl:apply-templates/>
         </div>
      </xsl:for-each>
   </xsl:template>

   <!--This templates consolidates all the other administrative information
      elements into one block under a common heading.  It formats these elements
      regardless of which of three encodings has been utilized.  They may be
      children of archdesc, admininfo, or descgrp.
      It begins by testing to see if there are any elements of this type
      with content.-->
   <xsl:template name="archdesc-admininfo">
      <h2>
         <p name="adminlink">
            <xsl:text>Administrative Information</xsl:text>
         </p>
      </h2>
      <xsl:apply-templates select="/ead/eadheader/filedesc/publicationstmt" mode="admin"/>
      <xsl:apply-templates select="/ead/eadheader/revisiondesc" mode="admin"/>
      <xsl:apply-templates select="archdesc/acqinfo"/>
      <xsl:apply-templates select="archdesc/fileplan"/>
      <xsl:apply-templates select="archdesc/custodhist"/>
      <xsl:apply-templates select="archdesc/accruals"/>
      <xsl:apply-templates select="archdesc/processinfo"/>
      <xsl:apply-templates select="archdesc/appraisal"/>
      <xsl:apply-templates select="archdesc/separatedmaterial"/>
      <xsl:apply-templates select="archdesc/altformavail"/>
      <xsl:apply-templates select="archdesc/prefercite"/>
      <!--</xsl:if>-->

   </xsl:template>

   <!-- Templates for publication information  -->
   <xsl:template match="/ead/eadheader/filedesc/publicationstmt" mode="admin">
      <h4>Publication Information</h4>
      <div>
         <div>
            <xsl:apply-templates select="publisher"/>
         </div>
         <xsl:if test="date">&#160;<xsl:apply-templates select="date"/></xsl:if>
      </div>
   </xsl:template>

   <!-- Templates for revision description  -->
   <xsl:template match="/ead/eadheader/revisiondesc" mode="admin">
      <h4>Revision Description</h4>
      <p>
         <xsl:if test="change/item">
            <xsl:apply-templates select="change/item"/>
         </xsl:if>
         <xsl:if test="change/date">&#160;<xsl:apply-templates select="change/date"/></xsl:if>
      </p>
   </xsl:template>

   <xsl:template match="p">
      <p>
         <xsl:apply-templates/>
      </p>
   </xsl:template>

   <!--This template rule tests for and formats the top-level index element. It begins
      by testing to see if there is an index element with content.-->
   <xsl:template match="archdesc/index
      | archdesc/*/index">
      <table width="100%">
         <tr>
            <td width="5%"> </td>
            <td width="45%"> </td>
            <td width="50%"> </td>
         </tr>
         <tr>
            <td colspan="3">
               <h3>
                  <strong>
                     <xsl:apply-templates select="head"/>
                  </strong>
               </h3>
            </td>
         </tr>
         <xsl:for-each select="p | note/p">
            <tr>
               <td/>
               <td colspan="2">
                  <xsl:apply-templates/>
               </td>
            </tr>
         </xsl:for-each>

         <!--Processes each index entry.-->
         <xsl:for-each select="indexentry">

            <!--Sorts each entry term.-->
            <xsl:sort select="corpname | famname | function | genreform | geogname | name | occupation | persname | subject"/>
            <tr>
               <td/>
               <td>
                  <xsl:apply-templates select="corpname | famname | function | genreform | geogname | name | occupation | persname | subject"/>
               </td>
               <!--Supplies whitespace and punctuation if there is a pointer
                  group with multiple entries.-->

               <xsl:choose>
                  <xsl:when test="ptrgrp">
                     <td>
                        <xsl:for-each select="ptrgrp">
                           <xsl:for-each select="ref | ptr">
                              <xsl:apply-templates/>
                              <xsl:if test="preceding-sibling::ref or preceding-sibling::ptr">
                                 <xsl:text>, </xsl:text>
                              </xsl:if>
                           </xsl:for-each>
                        </xsl:for-each>
                     </td>
                  </xsl:when>
                  <!--If there is no pointer group, process each reference or pointer.-->
                  <xsl:otherwise>
                     <td>
                        <xsl:for-each select="ref | ptr">
                           <xsl:apply-templates/>
                        </xsl:for-each>
                     </td>
                  </xsl:otherwise>
               </xsl:choose>
            </tr>
            <!--Closes the indexentry.-->
         </xsl:for-each>
      </table>
   </xsl:template>

   <!-- *** Begin templates for Container List *** -->
   <xsl:template match="archdesc/dsc">
      <h2>Contents List</h2>
      <!-- Call children of dsc -->
      <xsl:apply-templates select="*"/>
   </xsl:template>

   <xsl:template match="arcdesc/dsc/head"/>

   <xsl:template name="containerHits">
      <xsl:variable name="sum">
         <xsl:choose>
            <xsl:when test="string(number(/ead/archdesc/dsc/@xtf:hitCount))='NaN'">
               <xsl:text>0</xsl:text>
            </xsl:when>
            <xsl:when test="($query != '0') and ($query != '')">
               <xsl:value-of select="number(/ead/archdesc/dsc/@xtf:hitCount)"/>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="occur">
         <xsl:choose>
            <xsl:when test="$sum != 1">occurrences</xsl:when>
            <xsl:otherwise>occurrence</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <div id="results">
         <span class="hit-count">
            <xsl:value-of select="$sum"/>
         </span>
         <xsl:text> </xsl:text>
         <xsl:value-of select="$occur"/>
         <xsl:text> of </xsl:text>
         <span class="hit-count">
            <xsl:value-of select="$query"/>
         </span>
         <xsl:text> in this Contents List</xsl:text>
         <a class="resultsButton btn btn-default">
            <xsl:attribute name="href">
               <xsl:value-of select="$doc.path"/>
               <xsl:text>;chunk.id=</xsl:text>
               <xsl:value-of select="$chunk.id"/>
               <xsl:text>;brand=</xsl:text>
               <xsl:value-of select="$brand"/>
               <xsl:text>;doc.view=contents</xsl:text>
            </xsl:attribute>
            <xsl:text>Clear Search</xsl:text>
         </a>
      </div>
   </xsl:template>

   <!--This section of the stylesheet creates a div for each c01 or c 
        It then recursively processes each child component of the c01 by 
        calling the clevel template. -->
   <xsl:template match="c|c01">
      <xsl:choose>
         <xsl:when test="$doc.view = 'dao'">
            <div class="{@level} c01" style="width:100%;float:left;">
               <xsl:call-template name="anchor"/>
               <xsl:call-template name="clevel_dao"/>
               <xsl:for-each select="c|c02">
                  <xsl:if test="dao | did/dao | xtf:meta/*:type = 'dao'">
                     <div class="{@level} c02" style="width:99%;float:right;">
                        <xsl:call-template name="anchor"/>
                        <xsl:call-template name="clevel_dao"/>
                        <xsl:for-each select="c|c03">
                           <xsl:if test="dao | did/dao | xtf:meta/*:type = 'dao'">
                              <div class="{@level} c03" style="width:99%;float:right;">
                                 <xsl:call-template name="anchor"/>
                                 <xsl:call-template name="clevel_dao"/>
                                 <xsl:for-each select="c|c04">
                                    <xsl:if test="dao | did/dao | xtf:meta/*:type = 'dao'">
                                       <div class="{@level} c04" style="width:99%;float:right;">
                                          <xsl:call-template name="anchor"/>
                                          <xsl:call-template name="clevel_dao"/>
                                          <xsl:for-each select="c|c05">
                                             <xsl:if test="dao | did/dao | xtf:meta/*:type = 'dao'">
                                                <div class="{@level} c05" style="width:99%;float:right;">
                                                   <xsl:call-template name="anchor"/>
                                                   <xsl:call-template name="clevel_dao"/>
                                                   <xsl:for-each select="c|c06">
                                                      <xsl:if test="dao | did/dao | xtf:meta/*:type = 'dao'">
                                                         <div class="{@level} c06" style="width:99%;float:right;">
                                                            <xsl:call-template name="anchor"/>
                                                            <xsl:call-template name="clevel_dao"/>
                                                            <xsl:for-each select="c|c07">
                                                               <xsl:if test="dao | did/dao | xtf:meta/*:type = 'dao'">
                                                                  <div class="{@level} c07" style="width:99%;float:right;">
                                                                     <xsl:call-template name="anchor"/>
                                                                     <xsl:call-template name="clevel_dao"/>
                                                                     <xsl:for-each select="c|c08">
                                                                        <xsl:if test="dao | did/dao | xtf:meta/*:type = 'dao'">
                                                                           <div class="{@level} c08" style="width:99%;float:right;">
                                                                              <xsl:call-template name="anchor"/>
                                                                              <xsl:call-template name="clevel_dao"/>
                                                                              <xsl:for-each select="c|c09">
                                                                                 <xsl:if test="dao | did/dao | xtf:meta/*:type = 'dao'">
                                                                                    <div class="{@level} c09" style="width:99%;float:right;">
                                                                                       <xsl:call-template name="anchor"/>
                                                                                       <xsl:call-template name="clevel_dao"/>
                                                                                    </div>
                                                                                 </xsl:if>
                                                                              </xsl:for-each>
                                                                           </div>
                                                                        </xsl:if>
                                                                     </xsl:for-each>
                                                                  </div>
                                                               </xsl:if>
                                                            </xsl:for-each>
                                                         </div>
                                                      </xsl:if>
                                                   </xsl:for-each>
                                                </div>
                                             </xsl:if>
                                          </xsl:for-each>
                                       </div>
                                    </xsl:if>
                                 </xsl:for-each>
                              </div>
                           </xsl:if>
                        </xsl:for-each>
                     </div>
                  </xsl:if>
               </xsl:for-each>
            </div>
         </xsl:when>
         <xsl:when test="$doc.view='contentsSearch'">
            <div class="{@level} c01" style="width:100%;float:left;">
               <xsl:call-template name="anchor"/>
               <xsl:call-template name="clevel">
                  <xsl:with-param name="level">01</xsl:with-param>
               </xsl:call-template>
               <xsl:for-each select="c|c02">
                  <xsl:if test="@xtf:hitCount">
                     <div class="{@level} c02" style="width:99%;float:right;">
                        <xsl:call-template name="anchor"/>
                        <xsl:call-template name="clevel">
                           <xsl:with-param name="level">01</xsl:with-param>
                        </xsl:call-template>
                        <xsl:for-each select="c|c03">
                           <xsl:if test="@xtf:hitCount">
                              <div class="{@level} c03" style="width:99%;float:right;">
                                 <xsl:call-template name="anchor"/>
                                 <xsl:call-template name="clevel">
                                    <xsl:with-param name="level">01</xsl:with-param>
                                 </xsl:call-template>
                                 <xsl:for-each select="c|c04">
                                    <xsl:if test="@xtf:hitCount">
                                       <div class="{@level} c04" style="width:99%;float:right;">
                                          <xsl:call-template name="anchor"/>
                                          <xsl:call-template name="clevel">
                                             <xsl:with-param name="level">01</xsl:with-param>
                                          </xsl:call-template>
                                          <xsl:for-each select="c|c05">
                                             <xsl:if test="@xtf:hitCount">
                                                <div class="{@level} c05" style="width:99%;float:right;">
                                                   <xsl:call-template name="anchor"/>
                                                   <xsl:call-template name="clevel">
                                                      <xsl:with-param name="level">01</xsl:with-param>
                                                   </xsl:call-template>
                                                   <xsl:for-each select="c|c06">
                                                      <xsl:if test="@xtf:hitCount">
                                                         <div class="{@level} c06" style="width:99%;float:right;">
                                                            <xsl:call-template name="anchor"/>
                                                            <xsl:call-template name="clevel">
                                                               <xsl:with-param name="level">01</xsl:with-param>
                                                            </xsl:call-template>
                                                            <xsl:for-each select="c|c07">
                                                               <xsl:if test="@xtf:hitCount">
                                                                  <div class="{@level} c07" style="width:99%;float:right;">
                                                                     <xsl:call-template name="anchor"/>
                                                                     <xsl:call-template name="clevel">
                                                                        <xsl:with-param name="level">01</xsl:with-param>
                                                                     </xsl:call-template>
                                                                     <xsl:for-each select="c|c08">
                                                                        <xsl:if test="@xtf:hitCount">
                                                                           <div class="{@level} c08" style="width:99%;float:right;">
                                                                              <xsl:call-template name="anchor"/>
                                                                              <xsl:call-template name="clevel">
                                                                                 <xsl:with-param name="level">01</xsl:with-param>
                                                                              </xsl:call-template>
                                                                              <xsl:for-each select="c|c09">
                                                                                 <xsl:if test="@xtf:hitCount">
                                                                                    <div class="{@level} c09" style="width:99%;float:right;">
                                                                                       <xsl:call-template name="anchor"/>
                                                                                       <xsl:call-template name="clevel_dao"/>
                                                                                    </div>
                                                                                 </xsl:if>
                                                                              </xsl:for-each>
                                                                           </div>
                                                                        </xsl:if>
                                                                     </xsl:for-each>
                                                                  </div>
                                                               </xsl:if>
                                                            </xsl:for-each>
                                                         </div>
                                                      </xsl:if>
                                                   </xsl:for-each>
                                                </div>
                                             </xsl:if>
                                          </xsl:for-each>
                                       </div>
                                    </xsl:if>
                                 </xsl:for-each>
                              </div>
                           </xsl:if>
                        </xsl:for-each>
                     </div>
                  </xsl:if>
               </xsl:for-each>
            </div>
         </xsl:when>
         <xsl:otherwise>
            <div class="{@level} c01" style="width:100%;float:left;">
               <xsl:call-template name="anchor"/>
               <xsl:call-template name="clevel">
                  <xsl:with-param name="level">01</xsl:with-param>
               </xsl:call-template>
               <xsl:for-each select="c|c02">
                  <div class="{@level} c02" style="width:99%;float:right;">
                     <xsl:call-template name="anchor"/>
                     <xsl:call-template name="clevel">
                        <xsl:with-param name="level">02</xsl:with-param>
                     </xsl:call-template>
                     <xsl:for-each select="c|c03">
                        <div class="{@level} c03" style="width:99%;float:right;">
                           <xsl:call-template name="anchor"/>
                           <xsl:call-template name="clevel">
                              <xsl:with-param name="level">03</xsl:with-param>
                           </xsl:call-template>
                           <xsl:for-each select="c|c04">
                              <div class="{@level} c04" style="width:99%;float:right;">
                                 <xsl:call-template name="anchor"/>
                                 <xsl:call-template name="clevel">
                                    <xsl:with-param name="level">04</xsl:with-param>
                                 </xsl:call-template>
                                 <xsl:for-each select="c|c05">
                                    <div class="{@level} c05" style="width:99%;float:right;">
                                       <xsl:call-template name="anchor"/>
                                       <xsl:call-template name="clevel">
                                          <xsl:with-param name="level">05</xsl:with-param>
                                       </xsl:call-template>
                                       <xsl:for-each select="c|c06">
                                          <div class="{@level} c06" style="width:99%;float:right;">
                                             <xsl:call-template name="anchor"/>
                                             <xsl:call-template name="clevel">
                                                <xsl:with-param name="level">06</xsl:with-param>
                                             </xsl:call-template>
                                             <xsl:for-each select="c|c07">
                                                <div class="{@level} c07" style="width:99%;float:right;">
                                                   <xsl:call-template name="anchor"/>
                                                   <xsl:call-template name="clevel">
                                                      <xsl:with-param name="level">07</xsl:with-param>
                                                   </xsl:call-template>
                                                   <xsl:for-each select="c|c08">
                                                      <div class="{@level} c08" style="width:99%;float:right;">
                                                         <xsl:call-template name="anchor"/>
                                                         <xsl:call-template name="clevel">
                                                            <xsl:with-param name="level">08</xsl:with-param>
                                                         </xsl:call-template>
                                                         <xsl:for-each select="c|c09">
                                                            <div class="{@level} c09" style="width:99%;float:right;">
                                                               <xsl:call-template name="anchor"/>
                                                               <xsl:call-template name="clevel">
                                                                  <xsl:with-param name="level">09</xsl:with-param>
                                                               </xsl:call-template>
                                                            </div>
                                                         </xsl:for-each>
                                                      </div>
                                                   </xsl:for-each>
                                                </div>
                                             </xsl:for-each>
                                          </div>
                                       </xsl:for-each>
                                    </div>
                                 </xsl:for-each>
                              </div>
                           </xsl:for-each>
                        </div>
                     </xsl:for-each>
                  </div>
               </xsl:for-each>
            </div>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!--This is a named template that processes all c0* elements  -->
   <xsl:template name="clevel">
      <!-- Establishes which level is being processed in order to provided indented displays. 
           Indents handled by CSS margins-->
      <xsl:param name="level"/>
      <xsl:variable name="clevelMargin">
         <xsl:choose>
            <xsl:when test="$level = 01">c01</xsl:when>
            <xsl:when test="$level = 02">c02</xsl:when>
            <xsl:when test="$level = 03">c03</xsl:when>
            <xsl:when test="$level = 04">c04</xsl:when>
            <xsl:when test="$level = 05">c05</xsl:when>
            <xsl:when test="$level = 06">c06</xsl:when>
            <xsl:when test="$level = 07">c07</xsl:when>
            <xsl:when test="$level = 08">c08</xsl:when>
            <xsl:when test="$level = 09">c09</xsl:when>
            <xsl:when test="$level = 10">c10</xsl:when>
            <xsl:when test="$level = 11">c11</xsl:when>
            <xsl:when test="$level = 12">c12</xsl:when>
            <xsl:when test="../c">c</xsl:when>
            <xsl:when test="../c01">c01</xsl:when>
            <xsl:when test="../c02">c02</xsl:when>
            <xsl:when test="../c03">c03</xsl:when>
            <xsl:when test="../c04">c04</xsl:when>
            <xsl:when test="../c05">c05</xsl:when>
            <xsl:when test="../c06">c06</xsl:when>
            <xsl:when test="../c07">c07</xsl:when>
            <xsl:when test="../c08">c08</xsl:when>
            <xsl:when test="../c08">c09</xsl:when>
            <xsl:when test="../c08">c10</xsl:when>
            <xsl:when test="../c08">c11</xsl:when>
            <xsl:when test="../c08">c12</xsl:when>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="clevelChildMargin">
         <xsl:choose>
            <xsl:when test="$level = 01">c02</xsl:when>
            <xsl:when test="$level = 02">c03</xsl:when>
            <xsl:when test="$level = 03">c04</xsl:when>
            <xsl:when test="$level = 04">c05</xsl:when>
            <xsl:when test="$level = 05">c06</xsl:when>
            <xsl:when test="$level = 06">c07</xsl:when>
            <xsl:when test="$level = 07">c08</xsl:when>
            <xsl:when test="$level = 08">c09</xsl:when>
            <xsl:when test="$level = 09">c10</xsl:when>
            <xsl:when test="$level = 10">c11</xsl:when>
            <xsl:when test="$level = 11">c12</xsl:when>
         </xsl:choose>
      </xsl:variable>
      <!-- Processes the all child elements of the c or c0* level -->
      <xsl:for-each select=".">
         <xsl:choose>
            <!--Formats Series and Groups  -->
            <xsl:when
               test="@level='subcollection' or @level='subgrp' or @level='series' 
                       or @level='subseries' or @level='collection'or @level='fonds' or 
                       @level='recordgrp' or @level='subfonds' or @level='class' or (@level='otherlevel' and not(child::did/container))">
               <div class="inventoryNotes">
                  <div class="seriesTitle">
                     <xsl:apply-templates select="did" mode="dsc"/>
                  </div>
                  <xsl:apply-templates select="did/origination" mode="dsc"/>
                  <xsl:apply-templates select="scopecontent"/>
                  <xsl:apply-templates select="unitdate[not(@type)] | unitdate[@type != 'bulk']" mode="dsc"/>
                  <xsl:for-each select="did/physdesc[extent]">
                     <h4 font-weight="bold">Extent</h4>
                     <p space-after="8pt">
                        <xsl:value-of select="extent[1]"/>
                        <xsl:if test="extent[position() &gt; 1]">, <xsl:value-of select="extent[position() &gt; 1]"/>
                        </xsl:if>
                     </p>
                  </xsl:for-each>
                  <xsl:apply-templates select="accruals"/>
                  <xsl:apply-templates select="appraisal"/>
                  <xsl:apply-templates select="arrangement"/>
                  <xsl:apply-templates select="bioghist"/>
                  <xsl:apply-templates select="accessrestrict[not(child::legalstatus)]"/>
                  <xsl:apply-templates select="userestrict"/>
                  <xsl:apply-templates select="custodhist"/>
                  <xsl:apply-templates select="altformavail"/>
                  <xsl:apply-templates select="originalsloc"/>
                  <xsl:apply-templates select="did/physdesc[@label='Dimensions note']"/>
                  <xsl:apply-templates select="fileplan"/>
                  <xsl:apply-templates select="did/physdesc[@label = 'General Physical Description note']"/>
                  <xsl:apply-templates select="odd"/>
                  <xsl:apply-templates select="acqinfo"/>
                  <xsl:apply-templates select="did/langmaterial"/>
                  <xsl:apply-templates select="accessrestrict[child::legalstatus]"/>
                  <xsl:apply-templates select="did/materialspec"/>
                  <xsl:apply-templates select="otherfindaid"/>
                  <xsl:apply-templates select="phystech"/>
                  <xsl:apply-templates select="did/physdesc[@label='Physical Facet note']"/>
                  <xsl:apply-templates select="processinfo"/>
                  <xsl:apply-templates select="relatedmaterial"/>
                  <xsl:apply-templates select="separatedmaterial"/>
                  <xsl:if test="controlaccess">
                     <xsl:if test="controlaccess/subject">
                        <h4>Subjects</h4>
                        <xsl:for-each select="controlaccess/subject">
                           <span>
                              <xsl:value-of select="."/>
                           </span>
                           <br/>
                        </xsl:for-each>
                     </xsl:if>
                     <xsl:if test="controlaccess/persname|controlaccess/famname">
                        <h4>People</h4>
                        <xsl:for-each select="controlaccess/persname|controlaccess/famname">
                           <span>
                              <xsl:value-of select="."/>
                           </span>
                           <br/>
                        </xsl:for-each>
                     </xsl:if>
                     <xsl:if test="controlaccess/corpname">
                        <h4>Organizations</h4>
                        <xsl:for-each select="controlaccess/corpname">
                           <span>
                              <xsl:value-of select="."/>
                           </span>
                           <br/>
                        </xsl:for-each>
                     </xsl:if>
                     <xsl:if test="controlaccess/geogname">
                        <h4>Places</h4>
                        <xsl:for-each select="controlaccess/geogname">
                           <span>
                              <xsl:value-of select="."/>
                           </span>
                           <br/>
                        </xsl:for-each>
                     </xsl:if>
                     <xsl:if test="controlaccess/genreform">
                        <h4>Formats</h4>
                        <xsl:for-each select="controlaccess/genreform">
                           <span>
                              <xsl:value-of select="."/>
                           </span>
                           <br/>
                        </xsl:for-each>
                     </xsl:if>
                  </xsl:if>
               </div>
               <!-- ADDED 1/4/11: Adds container headings if series/subseries is followed by a file -->
               <xsl:if test="child::*[@level][1]/@level='file' or child::*[@level][1]/@level='item' or (child::*[@level][1]/@level='otherlevel'and child::*[@level][1]/child::did/container)">
                  <div class="inventoryTitle {$clevelChildMargin}">Inventory</div>
                  <div class="inventoryHeader {$clevelChildMargin}">
                     <span class="inventoryHeaderTitle">Title</span>
                     <span class="inventoryHeaderFormat">Format</span>
                     <span class="inventoryHeaderContainers">Containers</span>
                     <span class="inventoryHeaderNotes">Notes</span>
                     <span class="inventoryHeaderBookbag">My List</span>
                  </div>
               </xsl:if>
            </xsl:when>

            <!--Items/Files with multiple formats linked using parent and id attributes -->
            <xsl:when test="@level='file' or @level='item' or (@level='otherlevel'and child::did/container)">
               <!-- Tests to see if current container type is different from previous container type, if it is a new row with container type headings is outout -->
               <xsl:if test="not(preceding-sibling::*) and parent::dsc">
                  <div class="inventoryTitle {$clevelChildMargin}">Inventory</div>
                  <div class="inventoryHeader {$clevelChildMargin}">
                     <span class="inventoryHeaderTitle">Title</span>
                     <span class="inventoryHeaderFormat">Format</span>
                     <span class="inventoryHeaderContainers">Containers</span>
                     <span class="inventoryHeaderNotes">Notes</span>
                     <span class="inventoryHeaderBookbag">Bookbag</span>
                  </div>
               </xsl:if>

               <xsl:apply-templates select="did" mode="dsc"/>
               <div class="instances">
                  <xsl:for-each select="child::*/container[not(@parent)]">
                     <div class="instance">
                        <div class="format">
                           <xsl:variable name="label">
                              <xsl:choose>
                                 <xsl:when test="contains(@label, ' (')">
                                    <xsl:value-of select="substring-before(@label,' (')"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="concat(upper-case(substring(@label,1,1)),substring(@label,2))"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:variable>
                           <xsl:if test="$label != 'Mixed materials' and $label != 'Mixed Materials' and $label != 'mixed materials'">
                              <xsl:value-of select="$label"/>
                           </xsl:if>
                           <xsl:text>&#160;</xsl:text>
                        </div>
                        <!--7/16/11 WS: Adjusted Containers -->
                        <!-- ADDED 3/14/10: Sorts containers alpha numerically -->
                        <!--<xsl:sort select="."/>-->
                        <xsl:variable name="id" select="@id"/>
                        <xsl:variable name="containerSib" select="count(../container[@parent = $id] | ../container[@id = $id])"/>
                        <div class="containerWrapper">
                           <span class="container" style="padding-right: 1em;">
                              <xsl:value-of select="concat(upper-case(substring(@type,1,1)),substring(@type,2))"/>&#160; <xsl:apply-templates select="."/>
                           </span>
                           <span class="container">
                              <xsl:value-of select="concat(upper-case(substring(../container[@parent = $id]/@type,1,1)),substring(../container[@parent = $id]/@type,2))"/>&#160; <xsl:value-of
                                 select="../container[@parent = $id]"/>
                           </span>
                        </div>
                     </div>
                  </xsl:for-each>
                  <xsl:text>&#160;</xsl:text>
               </div>
               <span class="moreInfo">
                  <xsl:variable name="didHitCount">
                     <xsl:value-of select="count(descendant-or-self::xtf:hit) - count(did/descendant::xtf:hit)"/>
                  </xsl:variable>
                  <xsl:if
                     test="child::scopecontent |  child::accruals |  child::appraisal |  child::arrangement | 
                                child::bioghist |  child::custodhist |  child::altformavail |  child::originalsloc |  child::did/physdesc[@label='Dimensions note'] | 
                                child::fileplan |  child::did/physdesc[@label = 'General Physical Description note'] |  child::odd | 
                                child::acqinfo |  child::did/langmaterial |  child::accessrestrict[child::legalstatus] |  child::did/materialspec |
                                child::otherfindaid |  child::phystech |  child::did/physdesc[@label='Physical Facet note'] |  child::processinfo | child::relatedmaterial | 
                                child::separatedmaterial |  child::controlaccess">
                     <span class="dialog_dsc">
                        <a href="#" onClick="_gaq.push(['_trackEvent', 'finding aid', 'view', 'Additional Description']);">Additional description</a>
                     </span>
                     <xsl:if test="$didHitCount &gt; 0">
                        <span class="hit"> (<xsl:value-of select="$didHitCount"/>)</span>
                     </xsl:if>
                     <div id="{@id}_details" class="overlay" rel="{child::did/unittitle}">
                        <div class="details">
                           <xsl:apply-templates select="." mode="moreInfo"/>
                        </div>
                     </div>
                  </xsl:if>
                  <xsl:if test="child::accessrestrict[not(child::legalstatus)] | child::userestrict">
                     <span class="restrict_dsc">
                        <a href="#" onClick="_gaq.push(['_trackEvent', 'finding aid', 'view', 'Restrictions']);">Restrictions</a>
                     </span>
                     <xsl:if test="$didHitCount &gt; 0">
                        <span class="hit"> (<xsl:value-of select="$didHitCount"/>)</span>
                     </xsl:if>
                     <div id="{@id}_restrictions" class="overlay" rel="{child::did/unittitle}">
                        <div class="restrictions">
                           <xsl:apply-templates select="." mode="restrictions"/>
                        </div>
                     </div>
                  </xsl:if>
               </span>

               <span class="inventoryBookbag bookbag">
                  <xsl:if test="child::did/container and not(child::*[@level='file' or @level='item'])">
                     <xsl:call-template name="myListEad">
                        <xsl:with-param name="rootID" select="$rootID"/>
                     </xsl:call-template>
                  </xsl:if>
               </span>

            </xsl:when>
            <xsl:otherwise>
               <div class="{$clevelMargin}">
                  <xsl:apply-templates select="did" mode="dsc"/>
                  <xsl:apply-templates
                     select="child::scopecontent |  child::accruals |  child::appraisal |  child::arrangement | 
                                 child::bioghist |  child::accessrestrict[not(child::legalstatus)] |   child::userestrict | 
                                 child::custodhist |  child::altformavail |  child::originalsloc |  child::did/physdesc[@label='Dimensions note'] | 
                                 child::fileplan |  child::did/physdesc[@label = 'General Physical Description note'] |  child::odd | 
                                 child::acqinfo |  child::did/langmaterial |  child::accessrestrict[child::legalstatus] |  child::did/materialspec |
                                 child::otherfindaid |  child::phystech |  child::did/physdesc[@label='Physical Facet note'] |  child::processinfo | child::relatedmaterial | 
                                 child::separatedmaterial |  child::controlaccess"
                  />
               </div>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:for-each>
   </xsl:template>

   <xsl:template name="clevel_dao">
      <!-- Establishes which level is being processed in order to provided indented displays. 
           Indents handled by CSS margins-->
      <xsl:param name="level"/>
      <!-- Processes the all child elements of the c or c0* level -->
      <xsl:for-each select=".">
         <xsl:choose>
            <!--Formats Series and Groups  -->
            <xsl:when
               test="@level='subcollection' or @level='subgrp' or @level='series' 
                       or @level='subseries' or @level='collection'or @level='fonds' or 
                       @level='recordgrp' or @level='subfonds' or @level='class' or (@level='otherlevel' and not(child::did/container))">

               <div class="seriesTitle">
                  <xsl:apply-templates select="did" mode="dsc"/>
               </div>
            </xsl:when>
            <!-- Items/Files-->
            <xsl:when test="dao">
               <xsl:apply-templates select="dao" mode="popout"/>
            </xsl:when>
            <xsl:when test="did/dao">
               <xsl:apply-templates select="did/dao" mode="popout"/>
            </xsl:when>
         </xsl:choose>
      </xsl:for-each>
   </xsl:template>
   <!-- 8/17/11 WS for RA: added a test to include Series/Subseries and unitid, customized display -->
   <xsl:template match="did" mode="dsc">
      <xsl:choose>
         <xsl:when
            test="../@level='series' or ../@level='subseries'  or ../@level='collection' or ../@level='subcollection' or  ../@level='fonds' or ../@level='subfonds' or  ../@level='recordgrp' or ../@level='subgrp'">
            <div id="{generate-id(.)}">
               <xsl:if test="unitid">
                  <xsl:choose>
                     <xsl:when test="../@level='series'">Series <xsl:value-of select="unitid"/>: </xsl:when>
                     <xsl:when test="../@level='subseries'">Subseries <xsl:value-of select="unitid"/>: </xsl:when>
                     <xsl:when test="../@level='subsubseries'">Sub-Subseries <xsl:value-of select="unitid"/>: </xsl:when>
                     <xsl:when test="../@level='collection'">Collection <xsl:value-of select="unitid"/>: </xsl:when>
                     <xsl:when test="../@level='subcollection'">Subcollection <xsl:value-of select="unitid"/>: </xsl:when>
                     <xsl:when test="../@level='fonds'">Fonds <xsl:value-of select="unitid"/>: </xsl:when>
                     <xsl:when test="../@level='subfonds'">Subfonds <xsl:value-of select="unitid"/>: </xsl:when>
                     <xsl:when test="../@level='recordgrp'">Record Group <xsl:value-of select="unitid"/>: </xsl:when>
                     <xsl:when test="../@level='subgrp'">Subgroup <xsl:value-of select="unitid"/>: </xsl:when>
                     <xsl:otherwise><xsl:value-of select="unitid"/>: </xsl:otherwise>
                  </xsl:choose>
               </xsl:if>
               <xsl:apply-templates select="unittitle"/>
               <xsl:if test="unitdate[not(@type)] or unitdate[@type != 'bulk']">, <xsl:apply-templates select="unitdate[not(@type)] | unitdate[@type != 'bulk']"/></xsl:if>
            </div>
         </xsl:when>
         <!--Otherwise render the text in its normal font.-->
         <xsl:otherwise>
            <div class="daoLink">
               <xsl:choose>
                  <xsl:when test="../dao | dao">
                     <xsl:if test="count(../dao | dao) &gt; 1">
                        <xsl:call-template name="component-did-core"/>
                        <br/>
                     </xsl:if>
                     <xsl:for-each select="../dao | dao ">
                        <xsl:variable name="daoLink" select="@ns2:href | @xlink:href"/>
                        <xsl:variable name="daoTitle" select="@ns2:title | @xlink:title"/>
                        <xsl:variable name="citation">
                           <xsl:call-template name="daoCitation"/>
                        </xsl:variable>
                        <xsl:choose>
                           <xsl:when test="(@ns2:actuate | @xlink:actuate) and (@ns2:actuate | @xlink:actuate) != 'none'">
                              <a href="{$daoLink}" data-citation="{$citation}" data-title="{$daoTitle}" data-width="512" data-height="384"
                                 onClick="_gaq.push(['_trackEvent', 'digital object', 'view', '{$doc.view}']);" title="Digital object">
                                 <xsl:if test="count(../dao | dao) &gt; 1">
                                    <xsl:attribute name="style">margin-left:1em;</xsl:attribute>
                                 </xsl:if>
                                 <xsl:choose>
                                    <xsl:when test="count(../dao | dao) &gt; 1">
                                       <xsl:value-of select="$daoTitle"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:for-each select="../did | ../.">
                                          <xsl:call-template name="component-did-core"/>
                                       </xsl:for-each>
                                    </xsl:otherwise>
                                 </xsl:choose>
                                 <img src="/xtf/icons/default/dao.gif" alt="digital materials" align="top"/>
                              </a>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:choose>
                                 <xsl:when test="count(../dao | dao) &gt; 1">
                                    <xsl:value-of select="$daoTitle"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:for-each select="../did">
                                       <xsl:call-template name="component-did-core"/>
                                    </xsl:for-each>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:for-each>

                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:call-template name="component-did-core"/>
                  </xsl:otherwise>
               </xsl:choose>
            </div>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="dao" mode="popout">
      <xsl:if test="$doc.view = 'dao'">
         <div class="daoItemDisplay" style="float:left; padding:.5em; width:100%;">
            <xsl:variable name="daoLink" select="@ns2:href | @xlink:href"/>
            <xsl:variable name="daoTitle" select="@ns2:title | @xlink:title"/>
            <xsl:variable name="citation">
               <xsl:call-template name="daoCitation"/>
            </xsl:variable>
            <xsl:variable name="daoFile" select="substring-before(tokenize($daoLink,'/')[position()=last()],'.')"/>
            <xsl:variable name="daoImg" select="concat(string-join(tokenize($daoLink,'/')[position()!=last()],'/'),'/',$daoFile,'_thumb.jpg')"/>
            <div class="daoLink" style="float:left; width:15%">
               <a href="{$daoLink}" data-citation="{$citation}" data-title="{$daoTitle}" data-width="512" data-height="384"
                  onClick="_gaq.push(['_trackEvent', 'digital object', 'view', '{$doc.view}']);">
                  <xsl:call-template name="component-did-core"/>
                  <img src="{$daoImg}"/>
               </a>
            </div>
            <div class="caption" style="float:left;padding: 3em 0 0 1em;width: 75%;font-size:1em;">
               <a href="{$daoLink}" data-citation="{$citation}" data-title="{$daoTitle}" data-width="512" data-height="384"
                  onClick="_gaq.push(['_trackEvent', 'digital object', 'view', '{$doc.view}']);">
                  <xsl:if test="../did/unittitle != ''">
                     <xsl:value-of select="../did/unittitle"/>
                     <xsl:if test="../did/unitdate">
                        <xsl:text>,&#160;</xsl:text>
                     </xsl:if>
                  </xsl:if>
                  <xsl:if test="../unittitle != ''">
                     <xsl:value-of select="../unittitle"/>
                     <xsl:if test="../unitdate">
                        <xsl:text>,&#160;</xsl:text>
                     </xsl:if>
                  </xsl:if>
                  <xsl:if test="../unittitle != ''">
                     <xsl:value-of select="../unittitle"/>
                     <xsl:if test="../unitdate">
                        <xsl:text>,&#160;</xsl:text>
                     </xsl:if>
                  </xsl:if>
                  <xsl:if test="../did/unitdate">
                     <xsl:value-of select="../did/unitdate"/>
                  </xsl:if>
                  <xsl:if test="../unitdate">
                     <xsl:value-of select="../unitdate"/>
                  </xsl:if>
               </a>
            </div>
         </div>
      </xsl:if>
   </xsl:template>
   <xsl:template name="daoCitation">
      <xsl:for-each select="ancestor::*[@level]">
         <xsl:variable name="level">
            <xsl:choose>
               <xsl:when test="self::archdesc">Collection</xsl:when>
               <xsl:when test="@level = 'series'">Series</xsl:when>
               <xsl:when test="@level = 'subseries'">Subseries</xsl:when>
               <xsl:when test="@level = 'recordgrp'">Record Group</xsl:when>
               <xsl:when test="@level = 'subgrp'">Subgroup</xsl:when>
               <xsl:when test="@level = 'fonds'">Fonds</xsl:when>
               <xsl:when test="@level = 'subfonds'">Subfonds</xsl:when>
               <xsl:when test="@level = 'class'">Class</xsl:when>
               <xsl:when test="@level = 'otherlevel'">otherlevel</xsl:when>
               <xsl:when test="@level = 'file'">File</xsl:when>
               <xsl:when test="@level = 'item'">Item</xsl:when>
            </xsl:choose>
         </xsl:variable>
         <xsl:variable name="id">
            <xsl:if test="did/unitid">
               <xsl:value-of select="concat(' ',did/unitid)"/>
            </xsl:if>
         </xsl:variable>
         <xsl:variable name="title">
            <xsl:choose>
               <xsl:when test="did/unittitle != ''">
                  <xsl:value-of select="did/unittitle"/>
               </xsl:when>
               <xsl:when test="did/unitdate !=''">
                  <xsl:value-of select="did/unitdate"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="'Unknown'"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:choose>
            <xsl:when test="$level='Collection'">
               <xsl:value-of select="concat('&lt;strong&gt;',$level,'&lt;/strong&gt;',': ',$title,'&lt;br/&gt;')"/>
            </xsl:when>
            <xsl:when test="self::archdesc">
               <xsl:if test="parent::*[@level]"/>
               <xsl:value-of select="concat('&lt;strong&gt;',$level,'&lt;/strong&gt;',': ',$title,'&lt;br/&gt;')"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:if test="parent::*[@level]"/>
               <xsl:value-of select="concat('&lt;strong&gt;',$level,$id,'&lt;/strong&gt;',': ',$title,'&lt;br/&gt;')"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:for-each>
      <xsl:text>&lt;div class="repository"&gt;Rockefeller Archive Center, Sleepy Hollow, NY.&lt;/div&gt;</xsl:text>
   </xsl:template>
   <xsl:template name="component-did-core">
      <!--Inserts unitid and a space if it exists in the markup.-->
      <xsl:if test="unitid">
         <span style="font-style:italic;">
            <xsl:apply-templates select="unitid"/>
         </span>
         <xsl:if test="unittitle | origination">:</xsl:if>
         <xsl:text>&#160;</xsl:text>
      </xsl:if>
      <!--This choose statement selects between cases where unitdate is a child of unittitle and where it is a separate child of did.-->
      <xsl:choose>
         <!--This code processes the elements when unitdate is a child of unittitle.-->
         <xsl:when test="unittitle/unitdate">
            <xsl:apply-templates select="unittitle"/>
            <xsl:text>&#160;</xsl:text>
         </xsl:when>
         <!--This code process the elements when unitdate is not a child of untititle-->
         <xsl:otherwise>
            <xsl:apply-templates select="unittitle"/>
            <xsl:if test="unitdate">
               <xsl:if test="string-length(unittitle) &gt; 0">, </xsl:if>
            </xsl:if>
            <xsl:for-each select="unitdate">
               <xsl:apply-templates/>
               <xsl:text>&#160;</xsl:text>
            </xsl:for-each>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="physdesc/extent">
         <xsl:text>&#160;</xsl:text>
         <!-- 9/16/11 WS for RA: added parentheses --> (<xsl:for-each select="physdesc">
            <xsl:value-of select="extent[1]"/>
            <xsl:if test="extent[position() &gt; 1]">, <xsl:value-of select="extent[position() &gt; 1]"/>
            </xsl:if>
         </xsl:for-each>) </xsl:if>
   </xsl:template>
   <xsl:template match="did/unittitle | did/origination | unitdate[not(@type)] | unitdate[@type != 'bulk']" mode="dsc">
      <h4>
         <xsl:choose>
            <xsl:when test="self::unittitle">Title </xsl:when>
            <xsl:when test="self::origination">
               <xsl:choose>
                  <xsl:when test="@label != 'creator'">
                     <xsl:value-of select="@label"/>
                  </xsl:when>
                  <xsl:otherwise>Creator</xsl:otherwise>
               </xsl:choose>
            </xsl:when>
            <xsl:when test="self::unitdate">Dates </xsl:when>
         </xsl:choose>
      </h4>
      <p>
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   <xsl:template match="xtf:meta"/>
   <xsl:template match="dao" mode="moreInfo"/>
   <xsl:template match="*" mode="moreInfo">
      <xsl:apply-templates select="did/origination | did/unitdate[not(@type)] | did/unitdate[@type != 'bulk']" mode="dsc"/>
      <xsl:apply-templates select="did/physdesc"/>
      <xsl:apply-templates select="did/materialspec"/>
      <xsl:apply-templates select="*[not(name() = 'did' or name() = 'accessrestrict' or name() = 'userestrict' or name() = 'c' or name()='dao' or name()='controlaccess')]"/>
      <xsl:if test="string(controlaccess)">
         <h4>Subjects</h4>
         <xsl:for-each
            select="controlaccess/subject | controlaccess/corpname | controlaccess/famname | controlaccess/persname | controlaccess/genreform | controlaccess/title | controlaccess/geogname | controlaccess/occupation">
            <xsl:sort select="." data-type="text" order="ascending"/>
            <div>
               <xsl:apply-templates/>
            </div>
         </xsl:for-each>
      </xsl:if>
   </xsl:template>
   <xsl:template match="*" mode="restrictions">
      <xsl:apply-templates select="did/origination | did/unitdate[not(@type)] | did/unitdate[@type != 'bulk']" mode="dsc"/>
      <xsl:apply-templates select="did/physdesc"/>
      <xsl:apply-templates select="*[(name() = 'accessrestrict' or name() = 'userestrict')]"/>
   </xsl:template>

   <xsl:template name="make-popup-link">
      <xsl:param name="name"/>
      <xsl:param name="id"/>
      <xsl:param name="nodes"/>
      <xsl:param name="doc.view"/>
      <xsl:variable name="content.href"><xsl:value-of select="$query.string"/>;chunk.id=<xsl:value-of select="$id"/>;brand=<xsl:value-of select="$brand"/><xsl:value-of select="$search"
            />&amp;doc.view=<xsl:value-of select="$doc.view"/></xsl:variable>
      <a href="{$xtfURL}{$dynaxmlPath}?{$content.href}" data-citation="" data-title="{$name}" data-width="400" data-height="200"
         onClick="_gaq.push(['_trackEvent', 'finding aid', 'view', 'additional information']);">
         <xsl:value-of select="$name"/>
      </a>
   </xsl:template>
</xsl:stylesheet>
