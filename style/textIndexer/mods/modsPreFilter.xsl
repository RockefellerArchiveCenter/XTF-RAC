<xsl:stylesheet version="2.0"
   xmlns:parse="http://cdlib.org/xtf/parse"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xtf="http://cdlib.org/xtf"
   xmlns:html="http://www.w3.org/1999/xhtml"
   xmlns="http://www.w3.org/1999/xhtml"
   xmlns:session="java:org.cdlib.xtf.xslt.Session"
   extension-element-prefixes="session"
   exclude-result-prefixes="#all"
   xpath-default-namespace="http://www.loc.gov/mods/v3">
   <!-- 10/10/12 WS: new preFilter for handling RAC mods records  -->
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
   <!-- Import Common Templates and Functions                                  -->
   <!-- ====================================================================== -->
   
   <xsl:import href="../common/preFilterCommon.xsl"/>
   
   <!-- ====================================================================== -->
   <!-- Output parameters                                                      -->
   <!-- ====================================================================== -->
   
   <xsl:output method="xml" 
      indent="yes" 
      encoding="UTF-8"/>
   
   
   <!-- ====================================================================== -->
   <!-- Default: identity transformation                                       -->
   <!-- ====================================================================== -->
   
   <xsl:template match="@*|node()">
      <xsl:copy>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Root Template                                                          -->
   <!-- ====================================================================== -->
   
   <xsl:template match="/*">
      <xsl:copy>
         <xsl:namespace name="xtf" select="'http://cdlib.org/xtf'"/>
         <xsl:copy-of select="@*"/>
         <xsl:call-template name="get-meta"/>
         <xsl:apply-templates mode="addChunkId"/>
      </xsl:copy>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Top-level transformation: add chunk.id to each element                 -->
   <!-- ====================================================================== -->
   
   <xsl:template match="node()" mode="addChunkId">
      <xsl:call-template name="mods-copy">
         <xsl:with-param name="node" select="."/>
         <xsl:with-param name="chunk.id" select="string(position())"/>
      </xsl:call-template>
   </xsl:template>
   
   <xsl:template name="mods-copy">
      <xsl:param name="node"/>
      <xsl:param name="chunk.id"/>
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates select="node()"/>
      </xsl:copy>
   </xsl:template>
   
   <!-- Used to generate compact IDs by encoding numbers 1..26 as letters instead -->
   <xsl:function name="xtf:posToChar">
      <xsl:param name="pos"/>
      <xsl:value-of select="
         if ($pos &lt; 27) then
         substring('ABCDEFGHIJKLMNOPQRSTUVWXYZ', $pos, 1)
         else
         concat('.', $pos)"/>
   </xsl:function>
   
   <!-- ====================================================================== -->
   <!-- MODS Indexing                                                           -->
   <!-- ====================================================================== -->
   
   <!-- Ignored Elements
   <xsl:template match="eadheader" mode="addChunkId">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="xtf:index" select="'no'"/>
         <xsl:apply-templates select="*" mode="addChunkId"/>
      </xsl:copy>
   </xsl:template>
   -->   

   <!-- sectionType Indexing and Element Boosting -->
   <xsl:template match="title">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="xtf:sectionType" select="'title'"/>
         <xsl:attribute name="xtf:wordBoost" select="120.0"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="name[role/roleTerm[starts-with(.,'aut')]] | name[role/roleTerm[starts-with(.,'ctb')]]">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="xtf:sectionType" select="'creator'"/>
         <xsl:attribute name="xtf:wordBoost" select="95.0"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="classification">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="xtf:sectionType" select="'callNumber'"/>
         <xsl:attribute name="xtf:wordBoost" select="80.0"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="identifier[@type='isbn']">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="xtf:sectionType" select="'isbn'"/>
         <xsl:attribute name="xtf:wordBoost" select="80.0"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
   <xsl:template match="identifier[@type='issn']">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="xtf:sectionType" select="'isbn'"/>
         <xsl:attribute name="xtf:wordBoost" select="80.0"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
   <xsl:template match="identifier[@type='lccn']">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="xtf:sectionType" select="'lccn'"/>
         <xsl:attribute name="xtf:wordBoost" select="80.0"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Metadata Indexing                                                      -->
   <!-- ====================================================================== -->
   
   <xsl:template name="get-meta">
      <!-- Access Dublin Core Record (if present) -->
      <xsl:variable name="dcMeta">
         <xsl:call-template name="get-dc-meta"/>
      </xsl:variable>
      
      <!-- If no Dublin Core present, then extract meta-data from the EAD -->
      <xsl:variable name="meta">
         <xsl:choose>
            <xsl:when test="$dcMeta/*">
               <xsl:copy-of select="$dcMeta"/>
            </xsl:when>
            <xsl:otherwise>
               <level xtf:meta="true" xtf:tokenize="no">collection</level>
               <xsl:call-template name="get-mods-id"/>
               <xsl:call-template name="get-mods-creator"/>
               <xsl:call-template name="get-mods-title"/>
<!--               <xsl:call-template name="get-mods-edition"/>-->
<!--               <xsl:call-template name="get-li-imprint"/>-->
               <xsl:call-template name="get-mods-date"/>
               <xsl:call-template name="get-mods-genre"/>
<!--               <xsl:call-template name="get-li-collation"/>-->
               <xsl:call-template name="get-mods-series"/>
               <xsl:call-template name="get-mods-notes"/>
               <xsl:call-template name="get-mods-contents"/>
               <xsl:call-template name="get-mods-publisher"/>
               <xsl:call-template name="get-mods-callno"/>
               <xsl:call-template name="get-mods-subject"/>
               <xsl:call-template name="get-mods-subjectname"/>
               <xsl:call-template name="get-mods-geogname"/>
               <xsl:call-template name="get-mods-type"/>
               <xsl:call-template name="get-mods-format"/>
               <!-- special values for OAI -->
               <xsl:call-template name="oai-datestamp"/>
               <xsl:call-template name="oai-set"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <!-- Add display and sort fields to the data, and output the result. -->
      <xsl:call-template name="add-fields">
         <xsl:with-param name="display" select="'dynaxml'"/>
         <xsl:with-param name="meta" select="$meta"/>
      </xsl:call-template>    
   </xsl:template>
   
   <!-- identifier -->
   <xsl:template name="get-mods-id">
      <identifier xtf:meta="true" xtf:tokenize="no">
         <xsl:value-of select="/mods/identifier[@type='local']"/>
      </identifier>
   </xsl:template>
   <!-- creator -->
   <xsl:template name="get-mods-creator">
      <xsl:choose>
         <xsl:when test="/mods/name[role/roleTerm[starts-with(., 'aut')]] | /mods/name[role/roleTerm[starts-with(., 'ctb')]]">
            <xsl:for-each select="/mods/name[role/roleTerm[starts-with(., 'aut')]] | /mods/name[role/roleTerm[starts-with(., 'ctb')]]">
               <creator xtf:meta="true">
                  <xsl:for-each select="namePart">
                     <xsl:value-of select="normalize-space(.)"/><xsl:if test="position() != last()">&#160;</xsl:if>
                  </xsl:for-each>
               </creator>
            </xsl:for-each>
         </xsl:when>
         <xsl:otherwise>
            <creator xtf:meta="true">unknown</creator>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- title --> 
   <xsl:template name="get-mods-title">
      <xsl:choose>
         <xsl:when test="/mods/titleInfo/title">
            <title xtf:meta="true">
               <xsl:for-each select="/mods/titleInfo/child::*">
                  <xsl:value-of select="."/><xsl:if test="position()!=last()"> </xsl:if>
               </xsl:for-each>
            </title>
         </xsl:when>
         <xsl:otherwise>
            <title xtf:meta="true">
               <xsl:value-of select="'unknown'"/>
            </title>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- date --> 
   <xsl:template name="get-mods-date">
      <xsl:if test="/mods/originInfo/dateIssued">
            <date xtf:meta="true">
               <xsl:value-of select="string(/mods/originInfo/dateIssued[1])"/>
            </date>
         </xsl:if>      
   </xsl:template>
   
   <!-- series -->
   <xsl:template name="get-mods-series">
      <xsl:if test="/mods/relatedItem[@type='series']">
         <series xtf:meta="true">
            <xsl:value-of select="/mods/relatedItem[@type='series']/titleInfo/title"/>
         </series>
      </xsl:if>
   </xsl:template>
   
   <!-- notes -->
   <xsl:template name="get-mods-notes">
      <xsl:if test="/mods/note">
         <notes xtf:meta="true">
            <xsl:value-of select="/mods/note"/>
         </notes>
      </xsl:if>
   </xsl:template>
   
   <!-- genre -->
   <xsl:template name="get-mods-genre">
      <xsl:if test="/mods/genre">
         <genre xtf:meta="true">
            <xsl:value-of select="/mods/genre"/>
         </genre>
      </xsl:if>
   </xsl:template>
   <!-- contents -->
   <xsl:template name="get-mods-contents">
      <xsl:if test="/mods/abstract">
         <description xtf:meta="true">
            <xsl:value-of select="/mods/abstract"/>
         </description>
      </xsl:if>
   </xsl:template>
   
   <!-- Call No -->
   <xsl:template name="get-mods-callno">
      <xsl:if test="/mods/classification">
         <callNo xtf:meta="true">
            <xsl:value-of select="/mods/classification"/>
         </callNo>
      </xsl:if>
   </xsl:template>
   <!-- subject --> 
   <xsl:template name="get-mods-subject">
      <xsl:if test="/mods/subject[topic]">
         <xsl:for-each select="/mods/subject[topic]">
            <subject xtf:meta="true">
               <xsl:for-each select="topic">
                  <xsl:value-of select="normalize-space(.)"/><xsl:if test="position()!=last()"> -- </xsl:if>   
               </xsl:for-each>
            </subject>
         </xsl:for-each>
      </xsl:if>
   </xsl:template>
   
   <!-- subject name --> 
   <xsl:template name="get-mods-subjectname">
      <xsl:if test="/mods/subject[name]">
         <xsl:for-each select="/mods/subject[name]">
            <subjectname xtf:meta="true">
               <xsl:for-each select="namePart">
                  <xsl:value-of select="normalize-space(.)"/><xsl:if test="position()!=last()">&#160;</xsl:if>
               </xsl:for-each>
            </subjectname>
         </xsl:for-each>
      </xsl:if>
   </xsl:template>
   
   <!-- subject geographic --> 
   <!-- Note: we use for-each-group below to remove duplicate entries. -->
   <xsl:template name="get-mods-geogname">
      <xsl:if test="/mods/subject[geographic]">
         <xsl:for-each select="/mods/subject[geographic]">
            <geogname xtf:meta="true">
               <xsl:for-each select="geographic">
                  <xsl:value-of select="normalize-space(descendant-or-self::*)"/><xsl:if test="position()!=last()">&#160;</xsl:if>
               </xsl:for-each>
            </geogname>
         </xsl:for-each>
      </xsl:if>
   </xsl:template>

   <!-- publisher -->
   <xsl:template name="get-mods-publisher">
      <xsl:if test="/mods/originInfo[publisher]">      
         <publisher xtf:meta="true">
            <xsl:value-of select="/mods/originInfo/place[1]/placeTerm"/> : <xsl:value-of select="/mods/originInfo/publisher[1]"/>, <xsl:value-of select="/mods/originInfo/dateIssued[1]"/>
          </publisher>
      </xsl:if>      
   </xsl:template>
   
   <!-- rights -->
   <xsl:template name="get-ead-rights">
      <rights xtf:meta="true">public</rights>
   </xsl:template>

   <!-- type used for browsing -->
   <xsl:template name="get-mods-type">
         <type xtf:meta="true">mods</type>
   </xsl:template>
   
   <!-- format 
      <xsl:choose>
      <xsl:when test="/mods/genre[contains(.,'Volume')]">book</xsl:when>
      <xsl:when test="/mods/genre[contains(.,'DVD')]">other</xsl:when>
      <xsl:when test="/mods/genre[contains(.,'Videocassette')]">other</xsl:when>
      <xsl:when test="/mods/genre[contains(.,'Reel')]">other</xsl:when>
      <xsl:otherwise>other</xsl:otherwise>
      </xsl:choose>  
   -->
   <xsl:template name="get-mods-format">
      <format xtf:meta="true">
         <xsl:choose>
            <xsl:when test="/mods/genre[contains(.,'Volume')]">Book</xsl:when>
            <xsl:when test="/mods/genre[contains(.,'DVD')]">Moving Image</xsl:when>
            <xsl:when test="/mods/genre[contains(.,'Videocassette')]">Moving Image</xsl:when>
            <xsl:when test="/mods/genre[contains(.,'Reel')]">Microfilm</xsl:when>
            <xsl:otherwise>other</xsl:otherwise>
         </xsl:choose>
         </format>
   </xsl:template>
   
   <!-- OAI dateStamp -->
   <xsl:template name="oai-datestamp">
      <dateStamp xtf:meta="true" xtf:tokenize="no">
         <xsl:choose>
            <xsl:when test="/mods/originInfo/dateIssued">
               <xsl:choose>
                  <xsl:when test="matches(/mods/originInfo/dateIssued[1],'^(\d{4})')">
                     <xsl:value-of select="concat(substring(string(/mods/originInfo/dateIssued[1]),1,4),'-01-01')"/>
                  </xsl:when>
                  <xsl:when test="contains(/mods/originInfo/dateIssued[1],'-')">
                     <xsl:value-of select="concat(parse:year(string(/mods/originInfo/dateIssued[1])),'-01-01')"/>                  
                  </xsl:when>
               </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
               <!-- I don't know, what would you put? -->
               <xsl:value-of select="'1950-01-01'"/>
            </xsl:otherwise>
         </xsl:choose>
      </dateStamp>
   </xsl:template>
   
   <!-- OAI sets -->
   <xsl:template name="oai-set">
      <xsl:for-each select="/mods/subject">
         <set xtf:meta="true">
            <xsl:value-of select="child::*"/>
         </set>
      </xsl:for-each>
      <set xtf:meta="true">
         <xsl:value-of select="'public'"/>
      </set>
   </xsl:template>
   
</xsl:stylesheet>
