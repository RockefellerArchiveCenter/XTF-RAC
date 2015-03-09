<xsl:stylesheet version="2.0" xmlns:parse="http://cdlib.org/xtf/parse" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xtf="http://cdlib.org/xtf" xmlns:html="http://www.w3.org/1999/xhtml"
   xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns="http://www.w3.org/1999/xhtml" xmlns:session="java:org.cdlib.xtf.xslt.Session"
   extension-element-prefixes="session" exclude-result-prefixes="#all" xpath-default-namespace="http://www.loc.gov/METS/">

   <!-- HA: new preFilter for handling RAC METS records  -->

   <!-- ====================================================================== -->
   <!-- Import Common Templates and Functions                                  -->
   <!-- ====================================================================== -->

   <xsl:import href="../common/preFilterCommon.xsl"/>

   <!-- ====================================================================== -->
   <!-- Output parameters                                                      -->
   <!-- ====================================================================== -->

   <xsl:output method="xml" indent="yes" encoding="UTF-8"/>


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
      <xsl:call-template name="mets-copy">
         <xsl:with-param name="node" select="."/>
         <xsl:with-param name="chunk.id" select="string(position())"/>
      </xsl:call-template>
   </xsl:template>

   <xsl:template name="mets-copy">
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
   <!-- METS Indexing                                                           -->
   <!-- ====================================================================== -->


   <!-- sectionType Indexing and Element Boosting -->
   <!--<xsl:template match="mods:title">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="xtf:sectionType" select="'title'"/>
         <xsl:attribute name="xtf:wordBoost" select="120.0"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>-->

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
               <xsl:call-template name="get-mets-techmd"/>
               <xsl:call-template name="get-mets-creator"/>
               <xsl:call-template name="get-mets-title"/>
               <xsl:call-template name="get-mets-parents"/>
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
   <xsl:template name="get-mets-techmd">
      <xsl:variable name="identifier">
         <xsl:value-of select="/mets/dmdSec/mdWrap[@MDTYPE='MODS']/xmlData/*:mods/*:identifier"/>
      </xsl:variable>
      <xsl:variable name="uri">
         <xsl:value-of select="/mets/fileSec/fileGrp/file/FLocat/@xlink:href"/>
      </xsl:variable>
      <xsl:variable name="fileid">
         <xsl:value-of select="/mets/fileSec/fileGrp/file/@ID"/>
      </xsl:variable>
      <xsl:variable name="filename">
         <xsl:value-of select="substring-after($uri, concat($identifier, '-'))"/>
      </xsl:variable>
      <identifier xtf:meta="true" xtf:tokenize="no">
         <xsl:value-of select="$identifier"/>
      </identifier>
      <filename xtf:meta="true" xtf:tokenize="no">
         <xsl:value-of select="$filename"/>
      </filename>
      <format xtf:meta="true">
         <xsl:choose>
            <xsl:when test="/mets/amdSec/techMD[@ID=$fileid]/mdWrap/xmlData/*:object/*:objectCharacteristics/*:format/*:formatDesignation">
               <xsl:value-of select="/mets/amdSec/techMD[@ID=$fileid]/mdWrap/xmlData/*:object/*:objectCharacteristics/*:format/*:formatDesignation/*:formatName"/>
               <xsl:if test="/mets/amdSec/techMD[@ID=$fileid]/mdWrap/xmlData/*:object/*:objectCharacteristics/*:format/*:formatDesignation/*:formatVersion">
                  <xsl:text> (version </xsl:text>
                  <xsl:value-of select="/mets/amdSec/techMD[@ID=$fileid]/mdWrap/xmlData/*:object/*:objectCharacteristics/*:format/*:formatDesignation/*:formatVersion"/>
                  <xsl:text>)</xsl:text>
               </xsl:if>
            </xsl:when>
            <xsl:otherwise>
               <xsl:variable name="extension">
                  <xsl:value-of select="substring-after($uri, $filename)"/>
               </xsl:variable>
               <xsl:choose>
                  <xsl:when test="$extension='.pdf'">PDF</xsl:when>
                  <xsl:when test="$extension='.doc'">Word Document</xsl:when>
                  <xsl:when test="$extension='.docx'">Word Document</xsl:when>
               </xsl:choose>
            </xsl:otherwise>
         </xsl:choose>
      </format>
      <xsl:if test="/mets/amdSec/techMD[@ID=$fileid]/mdWrap/xmlData/*:object/*:objectCharacteristics/*:size !=''">
         <size xtf:meta="true" xtf:tokenize="no">
            <xsl:variable name="byteSize">
               <xsl:value-of select="number(/mets/amdSec/techMD[@ID=$fileid]/mdWrap/xmlData/*:object/*:objectCharacteristics/*:size)"/>
            </xsl:variable>
            <xsl:choose>
               <xsl:when test="$byteSize &gt; 1099511627776">
                  <!-- convert to TB -->
                  <xsl:value-of select="format-number($byteSize div 1099511627776, '#.##')"/>
                  <xsl:text> TB</xsl:text>
               </xsl:when>
               <xsl:when test="$byteSize &gt; 1073741824">
                  <!-- convert to GB -->
                  <xsl:value-of select="format-number($byteSize div 1073741824, '#.##')"/>
                  <xsl:text> GB</xsl:text>
               </xsl:when>
               <xsl:when test="$byteSize &gt; 1048576">
                  <!-- convert to MB -->
                  <xsl:value-of select="format-number($byteSize div 1048576, '#.##')"/>
                  <xsl:text> MB</xsl:text>
               </xsl:when>
               <xsl:when test="$byteSize &gt; 1024">
                  <!-- convert to KB -->
                  <xsl:value-of select="format-number($byteSize div 1024, '#.##')"/>
                  <xsl:text> KB</xsl:text>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="$byteSize"/>
                  <xsl:text> Bytes</xsl:text>
               </xsl:otherwise>
            </xsl:choose>
         </size>
      </xsl:if>
   </xsl:template>

   <!-- creator -->
   <xsl:template name="get-mets-creator">
      <xsl:if
         test="/mets/dmdSec/mdWrap[@MDTYPE='MODS']/xmlData/mods:mods/mods:name[mods:role/mods:roleTerm[starts-with(., 'author')]] | 
         /mets/dmdSec/mdWrap[@MDTYPE='MODS']/xmlData/mods:mods/mods:name[mods:role/mods:roleTerm[starts-with(., 'contributor')]] | 
         /mets/dmdSec/mdWrap[@MDTYPE='MODS']/xmlData/mods:mods/mods:name[mods:role/mods:roleTerm[starts-with(., 'creator')]]">
         <xsl:for-each
            select="/mets/dmdSec/mdWrap[@MDTYPE='MODS']/xmlData/mods:mods/mods:name[mods:role/mods:roleTerm[starts-with(., 'author')]] | 
            /mets/dmdSec/mdWrap[@MDTYPE='MODS']/xmlData/mods:mods/mods:name[mods:role/mods:roleTerm[starts-with(., 'contributor')]] | 
            /mets/dmdSec/mdWrap[@MDTYPE='MODS']/xmlData/mods:mods/mods:name[mods:role/mods:roleTerm[starts-with(., 'creator')]]">
            <creator xtf:meta="true">
               <xsl:for-each select="mods:namePart">
                  <xsl:value-of select="normalize-space(.)"/>
                  <xsl:if test="position() != last()">&#160;</xsl:if>
               </xsl:for-each>
            </creator>
         </xsl:for-each>
      </xsl:if>
   </xsl:template>

   <!-- title -->
   <xsl:template name="get-mets-title">
      <xsl:choose>
         <xsl:when test="/mets/dmdSec/mdWrap[@MDTYPE='MODS']/xmlData/mods:mods/mods:titleInfo/mods:title">
            <title xtf:meta="true">
               <xsl:for-each select="/mets/dmdSec/mdWrap[@MDTYPE='MODS']/xmlData/mods:mods/mods:titleInfo/child::*">
                  <xsl:value-of select="."/>
                  <xsl:if test="position()!=last()"> </xsl:if>
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
   
   <!-- get component and resource parents -->
   <xsl:template name="get-mets-parents">
      <xsl:if test="/mets/dmdSec/mdWrap[@MDTYPE='MODS']/xmlData/mods:mods/mods:relatedItem[@type='host']">
         <xsl:apply-templates select="/mets/dmdSec/mdWrap[@MDTYPE='MODS']/xmlData/mods:mods/mods:relatedItem[@type='host']"/>
      </xsl:if>
   </xsl:template>
   
   <xsl:template match="mods:relatedItem[@type='host']">
      <xsl:if test="@displayLabel='resource'">
         <collectionTitle xtf:meta="true"><xsl:value-of select="mods:name"/></collectionTitle>
         <collectionId xtf:meta="true"><xsl:value-of select="mods:identifier"/></collectionId>
      </xsl:if>
      <xsl:if test="@displayLabel='component'">
         <componentTitle xtf:meta="true"><xsl:value-of select="mods:name"/></componentTitle>
         <componentId xtf:meta="true"><xsl:value-of select="mods:identifier"/></componentId>
      </xsl:if>
   </xsl:template>

</xsl:stylesheet>
