<xsl:stylesheet version="2.0" xmlns:parse="http://cdlib.org/xtf/parse" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xtf="http://cdlib.org/xtf" xmlns:html="http://www.w3.org/1999/xhtml"
   xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns="http://www.w3.org/1999/xhtml" xmlns:session="java:org.cdlib.xtf.xslt.Session" xmlns:FileUtils="java:org.cdlib.xtf.xslt.FileUtils"
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
               <xsl:call-template name="get-mets-rights"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <!-- Add display and sort fields to the data, and output the result. -->
      <xsl:call-template name="add-fields">
         <xsl:with-param name="display" select="'dynaxml'"/>
         <xsl:with-param name="meta" select="$meta"/>
      </xsl:call-template>
   </xsl:template>

   <!-- technical metadata -->
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
      <xsl:choose>
         <xsl:when test="/mets/amdSec/techMD[@ID=$fileid]/mdWrap/xmlData/*:object/*:objectCharacteristics/*:format/*:formatDesignation/*:formatName !=''">
            <format xtf:meta="true">
               <xsl:choose>
                  <xsl:when test="/mets/amdSec/techMD[@ID=$fileid]/mdWrap/xmlData/*:object/*:objectCharacteristics/*:format/*:formatDesignation/*:formatVersion !=''">
                     <xsl:value-of select="/mets/amdSec/techMD[@ID=$fileid]/mdWrap/xmlData/*:object/*:objectCharacteristics/*:format/*:formatDesignation/*:formatVersion"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="/mets/amdSec/techMD[@ID=$fileid]/mdWrap/xmlData/*:object/*:objectCharacteristics/*:format/*:formatDesignation/*:formatName"/>
                  </xsl:otherwise>
               </xsl:choose>
            </format>
         </xsl:when>
         <xsl:otherwise>
            <xsl:variable name="extension">
               <xsl:value-of select="substring-after($filename, '.')"/>
            </xsl:variable>
            <format xtf:meta="true">
               <xsl:choose>
                  <xsl:when test="$extension='pdf'">
                     <xsl:text>PDF</xsl:text>
                  </xsl:when>
                  <xsl:when test="$extension='doc'">
                     <xsl:text>Word</xsl:text>
                  </xsl:when>
                  <xsl:when test="$extension='docx'">
                     <xsl:text>Word 2007-2013</xsl:text>
                  </xsl:when>
                  <xsl:when test="$extension='html'">
                    <xsl:text>HTML</xsl:text>
                  </xsl:when>
                  <xsl:when test="$extension='htm'">
                     <xsl:text>HTML</xsl:text>
                  </xsl:when>
                  <xsl:when test="$extension='iso'">
                    <xsl:text>Disk image</xsl:text>
                  </xsl:when>
                  <xsl:when test="$extension='ppt'">
                    <xsl:text>PowerPoint</xsl:text>
                  </xsl:when>
                  <xsl:when test="$extension='pptx'">
                    <xsl:text>PowerPoint (2007-2013)</xsl:text>
                  </xsl:when>
                  <xsl:when test="$extension='xls'">
                    <xsl:text>Excel</xsl:text>
                  </xsl:when>
                  <xsl:when test="$extension='xlsx'">
                    <xsl:text>Excel (2007-2013)</xsl:text>
                  </xsl:when>
               </xsl:choose>
            </format>
            <viewable xtf:meta="true">
               <xsl:choose>
                  <xsl:when test="$extension='pdf' or $extension='jpg'">true</xsl:when>
                  <xsl:otherwise>false</xsl:otherwise>
               </xsl:choose>
            </viewable>
         </xsl:otherwise>
      </xsl:choose>
      <size xtf:meta="true" xtf:tokenize="no">
         <xsl:choose>
            <xsl:when test="/mets/amdSec/techMD[@ID=$fileid]/mdWrap/xmlData/*:object/*:objectCharacteristics/*:size !=''">
                <xsl:value-of select="/mets/amdSec/techMD[@ID=$fileid]/mdWrap/xmlData/*:object/*:objectCharacteristics/*:size"/>
            </xsl:when>
            <xsl:when test="FileUtils:exists(concat('/mnt/images/', substring-after($uri, 'http://storage.rockarch.org')))">
               <xsl:value-of select="FileUtils:length(concat('/mnt/images/', substring-after($uri, 'http://storage.rockarch.org')))"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>unknown</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
      </size>
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
               <xsl:choose>
                  <xsl:when test="@type='personal'">
                     <xsl:value-of select="normalize-space(mods:namePart[@type='family'])"/>
                     <xsl:if test="mods:namePart[@type='given']">
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="normalize-space(mods:namePart[@type='given'])"/>
                     </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:for-each select="mods:namePart">
                        <xsl:value-of select="normalize-space(.)"/>
                        <xsl:if test="position() != last()">
                           <xsl:text> </xsl:text>
                        </xsl:if>
                     </xsl:for-each>
                  </xsl:otherwise>
               </xsl:choose>
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

   <!-- rights -->
   <xsl:template name="get-mets-rights">
      <xsl:variable name="uri">
         <xsl:value-of select="/mets/fileSec/fileGrp/file/FLocat/@xlink:href"/>
      </xsl:variable>
      <rights xtf:meta="true">
       <xsl:choose>
          <!-- Look for PREMIS rights statement that allows us to publish -->
          <xsl:when test="/mets/amdSec/rightsMD/mdWrap/xmlData/*:rightsStatement/*:rightsGranted/*:act='publish'">
               <xsl:choose>
                  <xsl:when test="/mets/amdSec/rightsMD/mdWrap/xmlData/*:rightsStatement/*:rightsGranted[*:act='publish']/*:permissions='allow'">
                     <xsl:text>allow</xsl:text>
                  </xsl:when>
                  <xsl:when test="/mets/amdSec/rightsMD/mdWrap/xmlData/*:rightsStatement/*:rightsGranted[*:act='publish']/*:restrictions='conditional'">
                     <xsl:text>conditional</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:text>disallow</xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="FileUtils:exists(concat('/mnt/images/', substring-after($uri, 'http://storage.rockarch.org')))">
                <xsl:text>allow</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>disallow</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
       </xsl:choose>
      </rights>
   </xsl:template>

   <xsl:template match="mods:relatedItem[@type='host']">
      <xsl:if test="@displayLabel='resource'">
         <collectionTitle xtf:meta="true">
            <xsl:value-of select="mods:name"/>
         </collectionTitle>
         <collectionId xtf:meta="true">
            <xsl:value-of select="mods:identifier"/>
         </collectionId>
      </xsl:if>
      <xsl:if test="@displayLabel='component'">
         <componentTitle xtf:meta="true">
            <xsl:value-of select="mods:name"/>
         </componentTitle>
         <componentId xtf:meta="true">
            <xsl:value-of select="mods:identifier"/>
         </componentId>
      </xsl:if>
   </xsl:template>

</xsl:stylesheet>
