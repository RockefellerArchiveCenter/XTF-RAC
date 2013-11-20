<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:parse="http://cdlib.org/xtf/parse"
   xmlns:xtf="http://cdlib.org/xtf"
   xmlns:ns2="http://www.w3.org/1999/xlink"
   exclude-result-prefixes="#all"
   xpath-default-namespace="urn:isbn:1-931666-22-9">
   
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
      <xsl:call-template name="ead-copy">
         <xsl:with-param name="node" select="."/>
         <xsl:with-param name="chunk.id" select="xs:string(position())"/>
      </xsl:call-template>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Rearrange the archdesc section to be in display order                  -->
   <!-- ====================================================================== -->
   
   <xsl:template match="archdesc" mode="addChunkId">
      <xsl:copy>
         <xsl:copy-of select="@*"/>         
         
         <xsl:apply-templates mode="addChunkId" select="did"/>
         <xsl:apply-templates mode="addChunkId" select="bioghist"/>
         <xsl:apply-templates mode="addChunkId" select="scopecontent"/>
         <xsl:apply-templates mode="addChunkId" select="arrangement"/>

         <!-- archdesc-restrict -->
         <xsl:apply-templates mode="addChunkId" select="userestrict"/>
         <xsl:apply-templates mode="addChunkId" select="accessrestrict"/>

         <!-- archdesc-relatedmaterial -->
         <xsl:apply-templates mode="addChunkId" select="relatedmaterial"/>
         <xsl:apply-templates mode="addChunkId" select="separatedmaterial"/>
         
         <xsl:apply-templates mode="addChunkId" select="controlaccess"/>
         <xsl:apply-templates mode="addChunkId" select="odd"/>
         <xsl:apply-templates mode="addChunkId" select="originalsloc"/>
         <xsl:apply-templates mode="addChunkId" select="phystech"/>

         <!-- archdesc-admininfo -->
         <xsl:apply-templates mode="addChunkId" select="custodhist"/>
         <xsl:apply-templates mode="addChunkId" select="altformavailable"/>
         <xsl:apply-templates mode="addChunkId" select="prefercite"/>
         <xsl:apply-templates mode="addChunkId" select="acqinfo"/>
         <xsl:apply-templates mode="addChunkId" select="processinfo"/>
         <xsl:apply-templates mode="addChunkId" select="appraisal"/>
         <xsl:apply-templates mode="addChunkId" select="accruals"/>

         <xsl:apply-templates mode="addChunkId" select="descgrp"/>
         <xsl:apply-templates mode="addChunkId" select="otherfindaid"/>
         <xsl:apply-templates mode="addChunkId" select="fileplan"/>
         <xsl:apply-templates mode="addChunkId" select="bibliography"/>
         <xsl:apply-templates mode="addChunkId" select="index"/>
         
         <!-- Lastly, the container list. -->
         <xsl:apply-templates mode="addChunkId" select="dsc"/>
      </xsl:copy>
   </xsl:template>

   <!-- Rearrange the <did> section to be in display order -->
   <!-- Rearranged to match html output -->
   <xsl:template match="did" mode="addChunkId">
      <xsl:copy>
         <xsl:copy-of select="@*"/>    
         <xsl:apply-templates/>         
      </xsl:copy>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Add a unique id to each child of archdesc and each c01, c02, and       --> 
   <!-- archdesc section...                                                    -->
   <!-- We do this by recording the position of each of the node's ancestors   -->
   <!-- (and the node itself)                                                  -->
   <!-- ====================================================================== -->
   
   <xsl:template name="ead-copy">
      <xsl:param name="node"/>
      <xsl:param name="chunk.id"/>
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:choose>
            <xsl:when test="self::c01 or self::c02 or (self::* and (parent::archdesc or parent::ead))">
               <xsl:if test="not(@id)">
                  <xsl:attribute name="id" select="concat(local-name(), '_', $chunk.id)"/>
               </xsl:if>
               <xsl:for-each select="node()">
                  <xsl:call-template name="ead-copy">
                     <xsl:with-param name="node" select="."/>
                     <xsl:with-param name="chunk.id" select="concat($chunk.id, xtf:posToChar(position()))"/>
                  </xsl:call-template>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:apply-templates select="node()"/>
            </xsl:otherwise>
         </xsl:choose>
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
   <!-- EAD Indexing                                                           -->
   <!-- ====================================================================== -->
   
   <xsl:template match="eadheader" mode="addChunkId">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates select="*" mode="addChunkId"/>
      </xsl:copy>
   </xsl:template>
   
   <!-- Ignored Elements -->
   <xsl:template match="eadid" mode="addChunkId">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="xtf:index" select="'no'"/>
         <xsl:apply-templates mode="addChunkId"/>
      </xsl:copy>
   </xsl:template>
   <xsl:template match="publicationstmt" mode="addChunkId">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="xtf:index" select="'no'"/>
         <xsl:apply-templates mode="addChunkId"/>
      </xsl:copy>
   </xsl:template>
   <xsl:template match="profiledesc" mode="addChunkId">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="xtf:index" select="'no'"/>
         <xsl:apply-templates mode="addChunkId"/>
      </xsl:copy>
   </xsl:template>
   <xsl:template match="revisiondesc" mode="addChunkId">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="xtf:index" select="'no'"/>
         <xsl:apply-templates mode="addChunkId"/>
      </xsl:copy>
   </xsl:template>
   
   <!-- sectionType Indexing and Element Boosting -->
   <xsl:template match="unittitle[parent::did]">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="xtf:sectionType" select="concat('head ', @type)"/>
         <xsl:attribute name="xtf:wordBoost" select="95.0"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="prefercite">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="xtf:sectionType" select="'citation'"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="titleproper[parent::titlestmt]">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="xtf:sectionType" select="'title'"/>
         <xsl:attribute name="xtf:wordBoost" select="120.0"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="origination[parent::did/parent::archdesc][starts-with(child::*/@role, 'Author')] | origination[parent::did/parent::archdesc][starts-with(child::*/@role, 'Contributor')]">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="xtf:sectionType" select="'creator'"/>
         <xsl:attribute name="xtf:wordBoost" select="95.0"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
   
  <!-- 1/26/12 WS: added bioghist and scopecontent templates for advanced search --> 
   <xsl:template match="archdesc/bioghist" mode="addChunkId">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="xtf:wordBoost" select="90.0"/>
         <xsl:attribute name="xtf:sectionType" select="'bioghist'"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="archdesc/scopecontent" mode="addChunkId">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="xtf:wordBoost" select="90.0"/>
         <xsl:attribute name="xtf:sectionType" select="'scopecontent'"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="controlaccess" mode="addChunkId">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="xtf:wordBoost" select="80.0"/>
         <xsl:attribute name="xtf:sectionType" select="'controlaccess'"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
   
   <!-- 1/27/12 WS: added sub-documents xtf:subDocument="mySubDocName" -->
   <xsl:template match="dsc" mode="addChunkId">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates mode="addChunkId" select="*"/>         
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="c | c01 | c02 | c03 | c04 | c05 | c06 | c07 | c08 | c09 | c10 | c11 | c12" mode="addChunkId">
      <xsl:copy>
         <xsl:namespace name="xtf" select="'http://cdlib.org/xtf'"/>
         <xsl:attribute name="xtf:subDocument" select="@id"/>
         <xsl:attribute name="xtf:inheritMeta">false</xsl:attribute>
         <xsl:attribute name="xtf:sectionType" select="@level"/>
         <xsl:copy-of select="@*"/>
         <xsl:call-template name="get-meta"/>
         <xsl:apply-templates mode="addChunkId"/>
      </xsl:copy>
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- Metadata Indexing                                                      -->
   <!-- ====================================================================== -->
   
   <!-- 2/2/12 WS: added metadata to c level records -->
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
<!--               <xsl:call-template name="get-ead-collection"/>-->
               <xsl:call-template name="get-ead-parent"/>
               <xsl:call-template name="get-ead-identifier"/>
               <xsl:call-template name="get-ead-level"/>
               <xsl:call-template name="get-ead-title"/>
               <xsl:call-template name="get-ead-containers"/>
               <xsl:call-template name="get-ead-creator"/>
               <xsl:call-template name="get-ead-subject"/>
               <xsl:call-template name="get-ead-subjectpers"/>
               <xsl:call-template name="get-ead-subjectcorp"/>
               <xsl:call-template name="get-ead-geogname"/>
               <xsl:call-template name="get-ead-description"/>
               <xsl:call-template name="get-ead-publisher"/>
               <xsl:call-template name="get-ead-contributor"/>
               <xsl:call-template name="get-ead-date"/>
               <xsl:call-template name="get-ead-type"/>
               <xsl:call-template name="get-ead-format"/>
<!-- This is coded as 'unkown,' as it does not contain any useful information we are not including it              
   <xsl:call-template name="get-ead-source"/>
-->
               <xsl:call-template name="get-ead-language"/>
<!--               <xsl:call-template name="get-ead-relation"/>-->
               <xsl:call-template name="get-ead-coverage"/>
<!--  
               <xsl:call-template name="get-ead-scopecontent"/>
               <xsl:call-template name="get-ead-bioghist"/>
   -->
               <xsl:call-template name="get-ead-restrictions"/>
               <xsl:call-template name="get-ead-rights"/>
               <!-- 9/9/2013 HA: Adding template for dao links -->
               <xsl:call-template name="get-ead-url"/>
               <!-- special values for OAI -->
               <xsl:call-template name="oai-datestamp"/>
               <!-- 11/19/2013 HA: commenting out -->
               <!--<xsl:call-template name="oai-set"/>-->
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <!-- Add display and sort fields to the data, and output the result. -->
      <xsl:call-template name="add-fields">
         <xsl:with-param name="display" select="'dynaxml'"/>
         <xsl:with-param name="meta" select="$meta"/>
      </xsl:call-template>    
   </xsl:template>
   
   <!-- Collection ID and facet -->
   <xsl:template name="get-ead-collection">
      <xsl:variable name="parentID">
         <xsl:choose>
            <xsl:when test="/ead/archdesc/did/unitid">
               <collection xtf:meta="true" xtf:tokenize="no">
                  <xsl:value-of select="string(/ead/archdesc/did/unitid[1])"/>
               </collection>
            </xsl:when>
            <xsl:when test="/ead/eadheader/eadid" xtf:tokenize="no">
               <collection xtf:meta="true" xtf:tokenize="no">
                  <xsl:value-of select="string(substring-before(/ead/eadheader/eadid[1],'.xml'))"/>
               </collection>
            </xsl:when>
            <xsl:otherwise>
               <collection xtf:meta="true" xtf:tokenize="no">
                  <xsl:value-of select="'unknown'"/>
               </collection>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="@level">
            <collection xtf:meta="true" xtf:tokenize="no">
               <xsl:value-of select="concat($parentID,'::',@id)"/>
            </collection>
         </xsl:when>
         <xsl:otherwise>
            <collection xtf:meta="true" xtf:tokenize="no">
               <xsl:value-of select="$parentID"/>
            </collection>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>   
   
   <!-- Get parent for components -->
   <xsl:template name="get-ead-parent">
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
               <xsl:when test="(@level='otherlevel') and (string-length(@otherlevel) &gt; 1)"><xsl:value-of select="@otherlevel"/></xsl:when>
               <xsl:when test="(@level='otherlevel') and (string-length(@otherlevel) &lt; 1)">Other Level</xsl:when>
               <xsl:when test="@level = 'file'">File</xsl:when>
               <xsl:when test="@level = 'item'">Item</xsl:when>
            </xsl:choose>            
         </xsl:variable>
         <xsl:variable name="id"><xsl:if test="did/unitid"><xsl:value-of select="concat(' ',did/unitid)"/></xsl:if></xsl:variable>
         <xsl:choose>
            <xsl:when test="self::archdesc">
               <parent xtf:meta="true" xtf:tokenize="no">
                  <xsl:value-of select="concat($level,': ',did/unittitle)"/>
               </parent>
            </xsl:when>
            <xsl:otherwise>
               <parent xtf:meta="true" xtf:tokenize="no">
                  <xsl:value-of select="concat($level,$id,': ',did/unittitle)"/>
               </parent>
            </xsl:otherwise>
         </xsl:choose>         
      </xsl:for-each>
   </xsl:template>
  
   <!-- level -->
   <xsl:template name="get-ead-level">
      <xsl:choose>
         <xsl:when test="@level">
            <level xtf:meta="true" xtf:tokenize="no">
               <xsl:value-of select="@level"/>
            </level>
            <xsl:if test="@level != 'file' or @level != 'item'">
               <componentID xtf:meta="true" xtf:tokenize="no">
                  <xsl:value-of select="did/unitid"/>
               </componentID>
            </xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <level xtf:meta="true" xtf:tokenize="no">collection</level>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- title --> 
   <xsl:template name="get-ead-title">
      <xsl:choose>
         <xsl:when test="@level">
            <!--<xsl:variable name="seriesTitle">
               <xsl:choose>
                  <xsl:when test="@level='file' or @level='item' or (@level='otherlevel'and child::did/container)">
                        <xsl:text>File: </xsl:text>
                     <xsl:choose>
                        <xsl:when test="did/unitdate">
                           <xsl:choose>
                              <xsl:when test="string-length(normalize-space(did/unittitle)) &gt; 1">
                                 <xsl:value-of select="did/unittitle"/>, <xsl:value-of
                                    select="did/unitdate"/>. </xsl:when>
                              <xsl:when test="string-length(normalize-space(did/unittitle)) &lt; 1">
                                 <xsl:value-of select="did/unitdate"/>. </xsl:when>
                           </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>Unknown.</xsl:otherwise>
                     </xsl:choose>
                     <xsl:if test="child::did/container">
                           <xsl:for-each select="did/container">
                              <xsl:value-of select="concat(' ',@type,' ',.)"/>
                              <xsl:if test="position()!=last()">, </xsl:if>
                           </xsl:for-each>
                     </xsl:if>
                  </xsl:when>
                  
                  <xsl:otherwise>
                     <xsl:choose>
                        <xsl:when test="@level='series'">Series <xsl:value-of select="did/unitid"/>: </xsl:when>
                        <xsl:when test="@level='subseries'">Subseries <xsl:value-of select="did/unitid"/>: </xsl:when>
                        <xsl:when test="@level='subsubseries'">Sub-Subseries <xsl:value-of select="did/unitid"/>: </xsl:when>
                        <xsl:when test="@level='collection'">Collection <xsl:value-of select="did/unitid"/>: </xsl:when>
                        <xsl:when test="@level='subcollection'">Subcollection <xsl:value-of select="did/unitid"/>: </xsl:when>
                        <xsl:when test="@level='fonds'">Fonds <xsl:value-of select="did/unitid"/>: </xsl:when>
                        <xsl:when test="@level='subfonds'">Subfonds <xsl:value-of select="did/unitid"/>: </xsl:when>
                        <xsl:when test="@level='recordgrp'">Record Group <xsl:value-of select="did/unitid"/>: </xsl:when>
                        <xsl:when test="@level='subgrp'">Subgroup <xsl:value-of select="did/unitid"/>: </xsl:when>
                        <xsl:otherwise/>
                     </xsl:choose>
                     <xsl:choose>
                        <xsl:when test="string-length(did/unittitle) &gt; 1">
                           <xsl:value-of select="did/unittitle"/>       
                        </xsl:when>
                        <xsl:when test="string-length(did/unitdate) &gt; 1">
                           <xsl:value-of select="did/unitdate"/> 
                        </xsl:when>
                        <xsl:otherwise>Unknown</xsl:otherwise>
                     </xsl:choose>
                  </xsl:otherwise>
               </xsl:choose>         
            </xsl:variable>-->
            <xsl:variable name="collTitle">
               <xsl:choose>
                  <xsl:when test="/ead/eadheader/filedesc/titlestmt/titleproper[@type='filing']">
                     <xsl:value-of select="string(/ead/eadheader/filedesc/titlestmt/titleproper[@type='filing'])"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="string(/ead/eadheader/filedesc/titlestmt/titleproper)"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable> 
            <xsl:choose>
               <xsl:when test="did/unittitle">
                  <collectionTitle xtf:meta="true">
                     <xsl:value-of select="$collTitle"/>
                  </collectionTitle>
                  <title xtf:meta="true">
                     <xsl:value-of select="did/unittitle"/>
                  </title>
               </xsl:when>
               <xsl:otherwise>
                  <collectionTitle xtf:meta="true">
                     <xsl:value-of select="$collTitle"/>
                  </collectionTitle>
                  <title xtf:meta="true">
                     <xsl:value-of select="'Unknown'"/>
                  </title>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:when test="/ead/eadheader/filedesc/titlestmt/titleproper[@type='filing']">
            <xsl:variable name="titleproper" select="string(/ead/eadheader/filedesc/titlestmt/titleproper[@type='filing'])"/>
            <xsl:variable name="subtitle" select="string(/ead/eadheader/filedesc/titlestmt/subtitle)"/>
            <title xtf:meta="true">
               <xsl:value-of select="$titleproper"/>
               <xsl:if test="$subtitle">
                  <!-- Put a colon between main and subtitle, if none present already -->
                  <xsl:if test="not(matches($titleproper, ':\s*$') or matches($subtitle, '^\s*:'))">
                     <xsl:text>: </xsl:text>
                  </xsl:if>  
                  <xsl:value-of select="$subtitle"/>
               </xsl:if>
            </title>
         </xsl:when>
         <xsl:when test="/ead/eadheader/filedesc/titlestmt/titleproper">
            <xsl:variable name="titleproper" select="string(/ead/eadheader/filedesc/titlestmt/titleproper)"/>
            <xsl:variable name="subtitle" select="string(/ead/eadheader/filedesc/titlestmt/subtitle)"/>
            <title xtf:meta="true">
               <xsl:value-of select="$titleproper"/>
               <xsl:if test="$subtitle">
                  <!-- Put a colon between main and subtitle, if none present already -->
                  <xsl:if test="not(matches($titleproper, ':\s*$') or matches($subtitle, '^\s*:'))">
                     <xsl:text>: </xsl:text>
                  </xsl:if>  
                  <xsl:value-of select="$subtitle"/>
               </xsl:if>
            </title>
         </xsl:when>
         <xsl:when test="/ead/archdesc/did/unittitle">
            <title xtf:meta="true">
               <xsl:value-of select="/ead/archdesc/did/unittitle"/>
            </title>
         </xsl:when>
         <xsl:when test="/ead/eadheader/filedesc/titlestmt/titleproper">
            <xsl:variable name="titleproper" select="string(/ead/eadheader/filedesc/titlestmt/titleproper)"/>
            <xsl:variable name="subtitle" select="string(/ead/eadheader/filedesc/titlestmt/subtitle)"/>
            <title xtf:meta="true">
               <xsl:value-of select="$titleproper"/>
               <xsl:if test="$subtitle">
                  <!-- Put a colon between main and subtitle, if none present already -->
                  <xsl:if test="not(matches($titleproper, ':\s*$') or matches($subtitle, '^\s*:'))">
                     <xsl:text>: </xsl:text>
                  </xsl:if>  
                  <xsl:value-of select="$subtitle"/>
               </xsl:if>
            </title>
         </xsl:when>
         <xsl:otherwise>
            <title xtf:meta="true">
               <xsl:value-of select="'Unknown'"/>
            </title>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- containers -->
   <xsl:template name="get-ead-containers">
      <xsl:if test="child::did/container">
         <containers xtf:meta="true">
         <xsl:for-each select="did/container">
            <xsl:value-of select="concat(' ',@type,' ',.)"/>
            <xsl:if test="position()!=last()">, </xsl:if>
         </xsl:for-each>
         </containers>
      </xsl:if>
   </xsl:template>

   <!-- creator -->
   <xsl:template name="get-ead-creator">
      <xsl:choose>
         <xsl:when test="@level">
            <xsl:choose>
               <xsl:when test="did/origination">
                  <xsl:for-each select="/ead/archdesc/did/origination/child::*[starts-with(@role, 'Author')]">
                     <collectionCreator xtf:meta="true">
                        <xsl:value-of select="normalize-space(.)"/>
                     </collectionCreator>
                  </xsl:for-each>
                  <xsl:for-each select="did/origination">
                     <creator xtf:meta="true">
                        <xsl:value-of select="normalize-space(string(child::*))"/>
                     </creator>
                  </xsl:for-each>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:for-each select="/ead/archdesc/did/origination/child::*[starts-with(@role, 'Author')]">
                     <collectionCreator xtf:meta="true">
                        <xsl:value-of select="normalize-space(.)"/>
                     </collectionCreator>
                     <creator xtf:meta="true">
                        <xsl:value-of select="normalize-space(.)"/>
                     </creator>
                  </xsl:for-each>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <xsl:choose>
               <xsl:when test="/ead/archdesc/did/origination/child::*[starts-with(@role, 'Author')]">
                  <xsl:for-each select="/ead/archdesc/did/origination/child::*[starts-with(@role, 'Author')]">
                     <creator xtf:meta="true">
                        <xsl:value-of select="normalize-space(.)"/>
                     </creator>
                  </xsl:for-each>
               </xsl:when>
               <xsl:when test="/ead/archdesc/did/origination/child::*[1][starts-with(@role, 'Contributor')]">
                  <creator xtf:meta="true">
                     <xsl:value-of select="normalize-space(string(/ead/archdesc/did/origination[child::*[starts-with(@role, 'Contributor')]][1]/child::*))"/>
                  </creator>
               </xsl:when>
               <xsl:otherwise>
                  <creator xtf:meta="true">
                     <xsl:value-of select="'unknown'"/>
                  </creator>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
  
   <!-- subject --> 
   <!-- Note: we use for-each-group below to remove duplicate entries. -->
   <xsl:template name="get-ead-subject">
      <xsl:choose>
         <xsl:when test="@level">
            <xsl:for-each-group select="/ead/archdesc//controlaccess/subject" group-by="string()">
               <subject xtf:meta="true">
                  <xsl:value-of select="."/>
               </subject>
            </xsl:for-each-group>
            <xsl:for-each-group select="controlaccess/subject" group-by="string()">
               <subject xtf:meta="true">
                  <xsl:value-of select="."/>
               </subject>
            </xsl:for-each-group>
         </xsl:when>
         <xsl:when test="/ead/archdesc//controlaccess/subject">
            <xsl:for-each-group select="/ead/archdesc//controlaccess/subject" group-by="string()">
               <subject xtf:meta="true">
                  <xsl:value-of select="."/>
               </subject>
            </xsl:for-each-group>
         </xsl:when>
         <xsl:when test="/ead/eadheader/filedesc/notestmt/subject">
            <xsl:for-each-group select="/ead/eadheader/filedesc/notestmt/subject" group-by="string()">
               <subject xtf:meta="true">
                  <xsl:value-of select="."/>
               </subject>
            </xsl:for-each-group>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
  
   <!-- subject name --> 
   <!-- Note: we use for-each-group below to remove duplicate entries. -->
   <xsl:template name="get-ead-subjectpers">
      <xsl:choose>
         <xsl:when test="@level">
            <xsl:if test="controlaccess">
               <xsl:for-each-group select="/ead/archdesc//controlaccess/persname | /ead/archdesc//controlaccess/famname" group-by="string()">
                  <subjectpers xtf:meta="true">
                     <xsl:value-of select="."/>
                  </subjectpers>
               </xsl:for-each-group>
               <xsl:for-each-group select="controlaccess/persname | controlaccess/famname" group-by="string()">
                  <subjectpers xtf:meta="true">
                     <xsl:value-of select="."/>
                  </subjectpers>
               </xsl:for-each-group>
            </xsl:if>
         </xsl:when>
         <xsl:when test="/ead/archdesc//controlaccess/persname | /ead/archdesc//controlaccess/famname">
            <xsl:for-each-group select="/ead/archdesc//controlaccess/persname | /ead/archdesc//controlaccess/famname" group-by="string()">
               <subjectpers xtf:meta="true">
                  <xsl:value-of select="."/>
               </subjectpers>
            </xsl:for-each-group>
         </xsl:when>
         <xsl:when test="/ead/eadheader/filedesc/notestmt/persname | /ead/eadheader/filedesc/notestmt/famname">
            <xsl:for-each-group select="/ead/eadheader/filedesc/notestmt/persname | /ead/eadheader/filedesc/notestmt/famname" group-by="string()">
               <subjectpers xtf:meta="true">
                  <xsl:value-of select="."/>
               </subjectpers>
            </xsl:for-each-group>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template name="get-ead-subjectcorp">
      <xsl:choose>
         <xsl:when test="@level">
            <xsl:if test="controlaccess">
               <xsl:for-each-group select="/ead/archdesc//controlaccess/corpname" group-by="string()">
                  <subjectcorp xtf:meta="true">
                     <xsl:value-of select="."/>
                  </subjectcorp>
               </xsl:for-each-group>
               <xsl:for-each-group select="controlaccess/corpname" group-by="string()">
                  <subjectcorp xtf:meta="true">
                     <xsl:value-of select="."/>
                  </subjectcorp>
               </xsl:for-each-group>
            </xsl:if>
         </xsl:when>
         <xsl:when test="/ead/archdesc//controlaccess/corpname">
            <xsl:for-each-group select="/ead/archdesc//controlaccess/corpname" group-by="string()">
               <subjectcorp xtf:meta="true">
                  <xsl:value-of select="."/>
               </subjectcorp>
            </xsl:for-each-group>
         </xsl:when>
         <xsl:when test="/ead/eadheader/filedesc/notestmt/corpname">
            <xsl:for-each-group select="/ead/eadheader/filedesc/notestmt/corpname" group-by="string()">
               <subjectcorp xtf:meta="true">
                  <xsl:value-of select="."/>
               </subjectcorp>
            </xsl:for-each-group>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   
   <!-- subject geographic --> 
   <!-- Note: we use for-each-group below to remove duplicate entries. -->
   <xsl:template name="get-ead-geogname">
      <xsl:choose>
         <xsl:when test="@level">
            <xsl:for-each-group select="/ead/archdesc//controlaccess/geogname" group-by="string()">
               <geogname xtf:meta="true">
                  <xsl:value-of select="."/>
               </geogname>
            </xsl:for-each-group>
            <xsl:for-each-group select="controlaccess/geogname" group-by="string()">
               <geogname xtf:meta="true">
                  <xsl:value-of select="."/>
               </geogname>
            </xsl:for-each-group>
         </xsl:when>
         <xsl:when test="/ead/archdesc//controlaccess/geogname">
            <xsl:for-each-group select="/ead/archdesc//controlaccess/geogname" group-by="string()">
               <geogname xtf:meta="true">
                  <xsl:value-of select="."/>
               </geogname>
            </xsl:for-each-group>
         </xsl:when>
         <xsl:when test="/ead/eadheader/filedesc/notestmt/geogname">
            <xsl:for-each-group select="/ead/eadheader/filedesc/notestmt/geogname" group-by="string()">
               <geogname xtf:meta="true">
                  <xsl:value-of select="."/>
               </geogname>
            </xsl:for-each-group>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <!-- description --> 
   <xsl:template name="get-ead-description">
      <xsl:choose>
         <xsl:when test="@level != 'collection'">
            <xsl:if test="did/physdesc/extent">
               <extent xtf:meta="true">
                  <xsl:value-of select="did/physdesc/extent"/>
               </extent>
            </xsl:if>
            <xsl:if test="scopecontent">
               <scopecontent xtf:meta="true">
                  <xsl:value-of select="scopecontent/p"/>
               </scopecontent>
            </xsl:if>
         </xsl:when>
         <xsl:when test="/ead/archdesc/did/abstract">
            <description xtf:meta="true">
               <xsl:value-of select="string(/ead/archdesc/did/abstract[1])"/>
            </description>
         </xsl:when>
         <xsl:when test="/ead/eadheader/filedesc/notestmt/note">
            <description xtf:meta="true">
               <xsl:value-of select="string(/ead/eadheader/filedesc/notestmt/note[1])"/>
            </description>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   
   <!--restrictions-->
   <xsl:template name="get-ead-restrictions">
      <xsl:choose>
         <xsl:when test="@level">
            <xsl:choose>
               <xsl:when test="accessrestrict">
                  <accessrestrict xtf:meta="true">
                     <xsl:value-of select="accessrestrict/p"/>
                  </accessrestrict>
               </xsl:when>
               <xsl:when test="ancestor::*/child::accessrestrict">
                  <accessrestrict xtf:meta="true">
                     <xsl:value-of select="ancestor::*/child::accessrestrict/p"/>
                  </accessrestrict>
               </xsl:when>
               <xsl:otherwise>
                  <accessrestrict xtf:meta="true">
                     <xsl:value-of select="/ead/archdesc/accessrestrict/p"/>
                  </accessrestrict>
               </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
               <xsl:when test="userestrict">
                  <userestrict xtf:meta="true">
                     <xsl:value-of select="userestrict/p"/>
                  </userestrict>
               </xsl:when>
               <xsl:when test="ancestor::*/child::userestrict">
                  <userestrict xtf:meta="true">
                     <xsl:value-of select="ancestor::*/child::userestrict/p"/>
                  </userestrict>
               </xsl:when>
               <xsl:otherwise>
                  <userestrict xtf:meta="true">
                     <xsl:value-of select="/ead/archdesc/userestrict/p"/>
                  </userestrict>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
  
   <!-- publisher -->
   <xsl:template name="get-ead-publisher">
      <xsl:choose>
         <xsl:when test="@level"/>
         <xsl:when test="/ead/archdesc/did/repository">
            <publisher xtf:meta="true">
               <xsl:value-of select="string(/ead/archdesc/did/repository[1])"/>
            </publisher>
         </xsl:when>
         <xsl:when test="/ead/eadheader/filedesc/publicationstmt/publisher">
            <publisher xtf:meta="true">
               <xsl:value-of select="string(/ead/eadheader/filedesc/publicationstmt/publisher[1])"/>
            </publisher>
         </xsl:when>
         <xsl:otherwise>
            <publisher xtf:meta="true">
               <xsl:value-of select="'unknown'"/>
            </publisher>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- contributor -->
   <xsl:template name="get-ead-contributor">
      <xsl:choose>
         <xsl:when test="@level">
            <xsl:choose>
               <xsl:when test="did/origination/child::*[@role != 'Author (aut)']">
                  <xsl:for-each select="did/origination/child::*[@role != 'Author (aut)']">
                     <contributor xtf:meta="true">
                        <xsl:value-of select="."/>
                     </contributor>                     
                  </xsl:for-each>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:when>
         <xsl:when test="/ead/archdesc/did/origination/child::*[@role != 'Author (aut)']">
            <xsl:for-each select="/ead/archdesc/did/origination/child::*[@role != 'Author (aut)']">
               <contributor xtf:meta="true">
                  <xsl:value-of select="."/>
               </contributor>                     
            </xsl:for-each>
         </xsl:when>
         <!-- 9/26/11 WS: Removed as irrelevant
         <xsl:when test="/ead/eadheader/filedesc/titlestmt/author">
            <contributor xtf:meta="true">
               <xsl:value-of select="string(/ead/eadheader/filedesc/titlestmt/author[1])"/>
            </contributor>
         </xsl:when>
         -->
         <xsl:otherwise>
            <contributor xtf:meta="true">
               <xsl:value-of select="'unknown'"/>
            </contributor>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- date --> 
   <xsl:template name="get-ead-date">
      <!-- 9/27/11 WS: Changed date to grab from archdesc/did/unitdate/@type="inclusive" -->
      <xsl:choose>
         <xsl:when test="@level">
            <date xtf:meta="true">
               <xsl:choose>
                  <xsl:when test="did/unitdate[@type='inclusive']">
                     <xsl:value-of select="replace(string(did/unitdate[@type='inclusive']/@normal[1]),'/','-')"/>
                  </xsl:when>
                  <xsl:when test="did/unitdate">
                     <xsl:value-of select="did/unitdate"/>
                  </xsl:when>
               </xsl:choose>
            </date>
            <xsl:if test="/ead/archdesc/did/unitdate[@type='inclusive']">
               <collectionDate xtf:meta="true">
                  <xsl:value-of select="/ead/archdesc/did/unitdate[@type='inclusive']"/>
               </collectionDate>
            </xsl:if>
         </xsl:when>
         <xsl:when test="/ead/archdesc/did/unitdate[@type='inclusive']">
            <date xtf:meta="true">
               <xsl:value-of select="replace(string(/ead/archdesc/did/unitdate[@type='inclusive']/@normal[1]),'/','-')"/>
            </date>
            <collectionDate xtf:meta="true">
               <xsl:value-of select="/ead/archdesc/did/unitdate[@type='inclusive']"/>
            </collectionDate>
         </xsl:when>
      </xsl:choose>
      <!--
      <xsl:choose>
         <xsl:when test="/ead/eadheader/filedesc/publicationstmt/date">
            <date xtf:meta="true">
               <xsl:value-of select="string(/ead/eadheader/filedesc/publicationstmt/date[1])"/>
            </date>
         </xsl:when>
         <xsl:otherwise>
            <date xtf:meta="true">
               <xsl:value-of select="'unknown'"/>
            </date>
         </xsl:otherwise>
      </xsl:choose>
      -->
   </xsl:template>
   
   <!-- type -->
   <xsl:template name="get-ead-type">
      <type xtf:meta="true">ead</type>
      <xsl:if test="descendant-or-self::dao">
         <type xtf:meta="true">dao</type>
      </xsl:if>
   </xsl:template>
   
   <!-- format -->
   <xsl:template name="get-ead-format">
      <format xtf:meta="true">Collection</format>
      <xsl:if test="descendant-or-self::dao"><format xtf:meta="true">Digital Material</format></xsl:if>
   </xsl:template>
   
   <!-- identifier --> 
   <xsl:template name="get-ead-identifier">
      <xsl:variable name="parentID">
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
      <xsl:choose>
         <xsl:when test="@level">
            <xsl:variable name="id">
               <xsl:choose>
                  <xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
                  <xsl:otherwise><xsl:value-of select="generate-id(.)"/></xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <identifier xtf:meta="true" xtf:tokenize="no">
               <xsl:value-of select="concat($parentID,'|',$id)"/>
            </identifier>
         </xsl:when>
         <xsl:otherwise>
            <identifier xtf:meta="true" xtf:tokenize="no">
               <xsl:value-of select="$parentID"/>
            </identifier>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- source -->
   <xsl:template name="get-ead-source">
      <source xtf:meta="true">unknown</source>
   </xsl:template>
   
   <!-- language -->
   <xsl:template name="get-ead-language">
      <xsl:choose>
         <xsl:when test="did/langmaterial/language">
               <language xtf:meta="true">
                  <xsl:choose>
                     <xsl:when test="/ead/archdesc/did/langmaterial/language/@langcode = 'bur'">Burmese</xsl:when>
                     <xsl:when test="/ead/archdesc/did/langmaterial/language/@langcode = 'chi'">Chinese</xsl:when>
                     <xsl:when test="/ead/archdesc/did/langmaterial/language/@langcode = 'dut'">Dutch</xsl:when>
                     <xsl:when test="/ead/archdesc/did/langmaterial/language/@langcode = 'eng'">English</xsl:when>
                     <xsl:when test="/ead/archdesc/did/langmaterial/language/@langcode = 'fre'">French</xsl:when>
                     <xsl:when test="/ead/archdesc/did/langmaterial/language/@langcode = 'gre'">Modern Greek</xsl:when>
                     <xsl:when test="/ead/archdesc/did/langmaterial/language/@langcode = 'mul'">Multiple languages</xsl:when>
                     <xsl:when test="/ead/archdesc/did/langmaterial/language/@langcode = 'por'">Portuguese</xsl:when>
                     <xsl:when test="/ead/archdesc/did/langmaterial/language/@langcode = 'spa'">Spanish</xsl:when>
                     <xsl:when test="/ead/archdesc/did/langmaterial/language/@langcode = 'tha'">Thai</xsl:when>
                  </xsl:choose>
               </language>
            </xsl:when>
         <xsl:otherwise>
            <xsl:choose>
               <xsl:when test="/ead/archdesc/did/langmaterial/language[@langcode]">
                  <language xtf:meta="true">
                     <xsl:choose>
                        <xsl:when test="/ead/archdesc/did/langmaterial/language/@langcode = 'bur'">Burmese</xsl:when>
                        <xsl:when test="/ead/archdesc/did/langmaterial/language/@langcode = 'chi'">Chinese</xsl:when>
                        <xsl:when test="/ead/archdesc/did/langmaterial/language/@langcode = 'dut'">Dutch</xsl:when>
                        <xsl:when test="/ead/archdesc/did/langmaterial/language/@langcode = 'eng'">English</xsl:when>
                        <xsl:when test="/ead/archdesc/did/langmaterial/language/@langcode = 'fre'">French</xsl:when>
                        <xsl:when test="/ead/archdesc/did/langmaterial/language/@langcode = 'gre'">Modern Greek</xsl:when>
                        <xsl:when test="/ead/archdesc/did/langmaterial/language/@langcode = 'mul'">Multiple languages</xsl:when>
                        <xsl:when test="/ead/archdesc/did/langmaterial/language/@langcode = 'por'">Portuguese</xsl:when>
                        <xsl:when test="/ead/archdesc/did/langmaterial/language/@langcode = 'spa'">Spanish</xsl:when>
                        <xsl:when test="/ead/archdesc/did/langmaterial/language/@langcode = 'tha'">Thai</xsl:when>
                     </xsl:choose>
                  </language>
               </xsl:when>
               <xsl:otherwise>
                  <language xtf:meta="true">
                     <xsl:value-of select="'English'"/>
                  </language>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>  
   
   <!-- relation -->
   <xsl:template name="get-ead-relation">
      <relation xtf:meta="true">unknown</relation>
   </xsl:template>
   
   <!-- coverage -->
   <xsl:template name="get-ead-coverage">
      <xsl:choose>
         <xsl:when test="@level">
            <xsl:if test="did/unittitle/unitdate">
               <coverage xtf:meta="true">
                  <xsl:value-of select="string(did/unittitle/unitdate[1])"/>
               </coverage>
            </xsl:if>
         </xsl:when>
         <xsl:when test="/ead/archdesc/did/unittitle/unitdate">
            <coverage xtf:meta="true">
               <xsl:value-of select="string(/ead/archdesc/did/unittitle/unitdate[1])"/>
            </coverage>
         </xsl:when>
         <xsl:otherwise>
            <coverage xtf:meta="true">
               <xsl:value-of select="'unknown'"/>
            </coverage>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- rights -->
   <xsl:template name="get-ead-rights">
      <rights xtf:meta="true">public</rights>
   </xsl:template>
   
   <xsl:template name="get-ead-url">
      <xsl:if test="descendant-or-self::dao">
         <daoLink xtf:meta="true"><xsl:value-of select="dao/@ns2:href"/></daoLink>
      </xsl:if>
   </xsl:template>
   
   <!-- OAI dateStamp -->
   <xsl:template name="oai-datestamp">
      <dateStamp xtf:meta="true" xtf:tokenize="no">
         <!--<xsl:choose>
            <xsl:when test="/ead/eadheader/profiledesc/creation/date">
               <xsl:choose>
                  <xsl:when test="matches(/ead/eadheader/profiledesc/creation[1]/date[1],'^(\d{4})')">
                     <xsl:value-of select="concat(substring(string(/ead/eadheader/profiledesc/creation[1]/date[1]),1,4),'-01-01')"/>
                  </xsl:when>
                  <xsl:when test="contains(/ead/eadheader/profiledesc/creation[1]/date[1],'-')">
                     <xsl:value-of select="concat(parse:year(string(/ead/eadheader/profiledesc/creation[1]/date[1])),'-01-01')"/>                  
                  </xsl:when>
                  <xsl:otherwise>
                     <!-\- I don't know, what would you put? -\->
                     <xsl:value-of select="'1950-01-01'"/>                  
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
               <!-\- I don't know, what would you put? -\->
               <xsl:value-of select="'1950-01-01'"/>
            </xsl:otherwise>
         </xsl:choose>-->
         <xsl:value-of select="string(/ead/eadheader/profiledesc/creation/date[1])"/>
      </dateStamp>
   </xsl:template>
   
   <!-- OAI sets -->
   <xsl:template name="oai-set">
      <xsl:for-each-group select="/ead/archdesc//controlaccess/subject" group-by="string()">
         <set xtf:meta="true">
            <xsl:value-of select="."/>
         </set>
      </xsl:for-each-group>
      <xsl:for-each-group select="/ead/eadheader/filedesc/notestmt/subject" group-by="string()">
         <set xtf:meta="true">
            <xsl:value-of select="."/>
         </set>
      </xsl:for-each-group>
      <set xtf:meta="true">
         <xsl:value-of select="'public'"/>
      </set>
   </xsl:template>
   
</xsl:stylesheet>
