<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:mods="http://www.loc.gov/mods/v3"
   xmlns:xtf="http://cdlib.org/xtf" 
   xmlns="http://www.w3.org/1999/xhtml"
   xmlns:session="java:org.cdlib.xtf.xslt.Session"
   extension-element-prefixes="session"
   exclude-result-prefixes="#all"
   version="2.0">


      <xsl:import href="../common/docFormatterCommon.xsl"/>
      <xsl:import href="../../../xtfCommon/xtfCommon.xsl"/>
      
   
   <!-- Creates a variable equal to the value of the number in eadid which serves as the base
      for file names for the various components of the frameset.-->
   <xsl:variable name="file">
      <xsl:value-of select="mods/identifier"/>
   </xsl:variable>
   
   <!--This template creates HTML meta tags that are inserted into the HTML ouput
      for use by web search engines indexing this file.   The content of each
      resulting META tag uses Dublin Core semantics and is drawn from the text of
      the finding aid.-->
   <xsl:template name="metadata">
      <meta http-equiv="Content-Type" name="dc.title"  content="{/mods:mods/mods:titleInfo/child::*}"/>
      <meta http-equiv="Content-Type" name="dc.author" content="{/mods:mods/mods:name/mods:namePart}"/>
      
      <xsl:for-each select="//mods:subject/mods:name">
         <xsl:choose>
            <xsl:when test="@encodinganalog='600'">
               <meta http-equiv="Content-Type" name="dc.subject" content="{child::*}"/>
            </xsl:when>            
            <xsl:when test="//@encodinganalog='610'">
               <meta http-equiv="Content-Type" name="dc.subject" content="{child::*}"/>
            </xsl:when>            
            <xsl:when test="//@encodinganalog='611'">
               <meta http-equiv="Content-Type" name="dc.subject" content="{child::*}"/>
            </xsl:when>            
            <xsl:when test="//@encodinganalog='700'">
               <meta http-equiv="Content-Type" name="dc.contributor" content="{child::*}"/>
            </xsl:when>            
            <xsl:when test="//@encodinganalog='710'">
               <meta http-equiv="Content-Type" name="dc.contributor" content="{child::*}"/>
            </xsl:when>            
            <xsl:otherwise>
               <meta http-equiv="Content-Type" name="dc.contributor" content="{child::*}"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:for-each>
      <xsl:for-each select="//mods:subject/mods:topic">
         <meta http-equiv="Content-Type" name="dc.subject" content="{child::*}"/>
      </xsl:for-each>
      <xsl:for-each select="//mods:subject/mods:geographic">
         <meta http-equiv="Content-Type" name="dc.subject" content="{child::*}"/>
      </xsl:for-each>
      <meta http-equiv="Content-Type" name="dc.format" content="{/mods:mods/mods:genre}"/>
      
   </xsl:template>
   
   <!-- Creates the body of the finding aid.-->
   <xsl:template name="body">
      <xsl:variable name="file">
         <xsl:value-of select="/mods:mods/mods:identifier"/>
      </xsl:variable> 
      <div id="content-wrapper">
         <div id="content-right">
            <div id="overview" class="modsInfo" style="margin-top:1em;">
               <h3>Overview</h3>
               <xsl:if test="mods:titleInfo[not(@type='uniform' and @type='alternative')]">
                  <h4>Title</h4>
                  <p>
                     <xsl:apply-templates select="mods:titleInfo[not(@type='uniform' and @type='alternative')]"/>
                  </p>
               </xsl:if>
               <xsl:if test="mods:name[mods:role/mods:roleTerm != 'pub']">
                  <h4>Author/Creator</h4>
                  <p>
                     <xsl:apply-templates select="mods:name[mods:role/mods:roleTerm != 'pub']"/>
                  </p>
               </xsl:if>
               <xsl:if test="mods:titleInfo[@type='uniform' or @type='alternative']">
                  <h4>Variant titles</h4>
                  <p>
                     <xsl:apply-templates select="mods:titleInfo[@type='uniform'] | mods:titleInfo[@type='alternative']"/>
                  </p>
               </xsl:if>
               <xsl:if test="mods:originInfo/mods:edition">
                  <h4>Edition</h4>
                  <p>
                     <xsl:apply-templates select="mods:originInfo/mods:edition"/>
                  </p>
               </xsl:if>
               <xsl:if test="string-length(mods:originInfo/mods:publisher[1]) &gt; 1">
                  <h4>Publication Note</h4>
                  <p>
                     <xsl:apply-templates select="mods:originInfo"/>
                  </p>
               </xsl:if>
               <xsl:if test="mods:originInfo/mods:dateIssued">
                  <h4>Date</h4>
                  <p>
                     <xsl:apply-templates select="mods:originInfo/mods:dateIssued"/>
                  </p>
               </xsl:if>
            </div>
            <div id="location" class="modsInfo">
               <h3>Location</h3>
               <xsl:if test="/mods:mods/mods:note[@type='original location']">
                  <h4>RAC Library</h4>
                  <p>
                     <xsl:apply-templates select="/mods:mods/mods:note[@type='original location']"/> 
                  </p>
               </xsl:if>
               <xsl:if test="/mods:mods/mods:note[@type='additional physical form']">
                  <h4>RAC Library</h4>
                  <p>
                     <xsl:apply-templates select="/mods:mods/mods:note[@type='additional physical form']"/> 
                  </p>
               </xsl:if>
               <xsl:if test="/mods:mods/mods:classification">
                  <h4>Call Number</h4>
                  <p>
                     <xsl:apply-templates select="/mods:mods/mods:classification"/>
                  </p>
               </xsl:if>
            </div>
            <div id="details" class="modsInfo">
               <h3>Details</h3>
               <xsl:if test="/mods:mods/mods:abstract">
                  <h4>Contents</h4>   
                  <xsl:for-each select="/mods:mods/mods:abstract">
                     <p>
                        <xsl:apply-templates/>
                     </p>
                  </xsl:for-each>
               </xsl:if>
               <xsl:if test="/mods:mods/mods:note[@displayLabel='Summary']">
                  <h4>Summary</h4>   
                  <xsl:for-each select="/mods:mods/mods:abstract">
                     <p>
                        <xsl:apply-templates/>
                     </p>
                  </xsl:for-each>
               </xsl:if>
               <xsl:if test="/mods:mods/mods:physicalDescription">
                     <xsl:apply-templates select="/mods:mods/mods:physicalDescription"/>
               </xsl:if>
               <xsl:if test="/mods:mods/mods:relatedItem[@type='series']">
                  <h4>Series/Volume</h4>
                  <p>
                     <xsl:apply-templates select="/mods:mods/mods:relatedItem[@type='series']"/>
                  </p>
               </xsl:if>
               <xsl:if test="/mods:mods/mods:relatedItem[@type='host'][not(@displayLabel='Researcher Publication')]">
                  <h4>Collection</h4>
                  <p>
                     <xsl:apply-templates select="/mods:mods/mods:relatedItem[@type='host'][not(@displayLabel='Researcher Publication')]"/>
                  </p>
               </xsl:if>
               <xsl:if test="/mods:mods/mods:acquisition">
                  <h4>Provenance</h4>
                  <xsl:apply-templates select="/mods:mods/mods:acquisition"/>
               </xsl:if>
               <xsl:if test="/mods:mods/mods:note[not(@type)]">
                  <xsl:for-each select="/mods:mods/mods:note[not(@type)]">
                     <xsl:choose>
                        <xsl:when test="@displayLabel='Summary'">
                           <h4>Summary</h4>
                           <p>
                              <xsl:apply-templates/>  
                           </p>
                        </xsl:when>
                        <xsl:when test="@displayLabel='Production Credits for Motion Picture'">
                           <h4>Production Credits for Motion Picture</h4>
                           <p>
                              <xsl:apply-templates/>  
                           </p>
                        </xsl:when>
                        <xsl:when test="@displayLabel='Participants Note'">
                           <h4>Participants</h4>
                           <p>
                              <xsl:apply-templates/>  
                           </p>
                        </xsl:when>
                        <xsl:when test="@displayLabel='Dissertation'">
                           <h4>Dissertation</h4>
                           <p>
                              <xsl:apply-templates/>  
                           </p>
                        </xsl:when>
                        <xsl:when test="@displayLabel='Date and Place (Conference)'">
                           <h4>Conference Date and Place</h4>
                           <p>
                              <xsl:apply-templates/>  
                           </p>
                        </xsl:when>
                        <xsl:when test="@displayLabel='Language'">
                           <h4>Language</h4>
                           <p>
                              <xsl:apply-templates/>  
                           </p>
                        </xsl:when>
                        <xsl:when test="@displayLabel='Conference Name'">
                           <h4>Conference Name</h4>
                           <p>
                              <xsl:apply-templates/>  
                           </p>
                        </xsl:when>
                        <xsl:when test="@displayLabel='Correspondence File'">
                           <h4>Correspondence File</h4>
                           <p>
                              <xsl:apply-templates/>  
                           </p>
                        </xsl:when>
                        <xsl:otherwise>
                           <h4>Notes</h4>
                              <p>
                                 <xsl:apply-templates/>  
                              </p>
                        </xsl:otherwise>
                     </xsl:choose>                     
                  </xsl:for-each>
               </xsl:if>
               <xsl:if test="/mods:mods/mods:identifier[@type='isbn' or @type='issn']">
                  <h4>ISBN/ISSN</h4>
                  <p>
                     <xsl:apply-templates select="/mods:mods/mods:identifier[@type='isbn' or @type='issn']"/>
                  </p>
               </xsl:if>
               <xsl:if test="/mods:mods/mods:identifier[@type='oclc']">
                  <h4>OCLC Number</h4>
                  <p>
                     <xsl:apply-templates select="/mods:mods/mods:identifier[@type='oclc']"/>
                  </p>
               </xsl:if>
               <xsl:if test="/mods:mods/mods:identifier[@type='lccn']">
                  <h4>LC Number</h4>
                  <p>
                     <xsl:apply-templates select="/mods:mods/mods:identifier[@type='lccn']"/>
                  </p>
               </xsl:if>
               <xsl:if test="/mods:mods/mods:genre">
                  <h4>Item Type</h4>
                  <p>
                     <xsl:apply-templates select="/mods:mods/mods:genre"/>
                  </p>
               </xsl:if>
            </div>                    
         </div>
 
     </div>
   </xsl:template>		
  
   <xsl:template match="mods:titleInfo[@type='uniform'] | mods:titleInfo[@type='alternative']">
            <xsl:for-each select="child::*">
               <xsl:apply-templates/>&#160;
            </xsl:for-each>
         <br/>
   </xsl:template>
   
   <xsl:template match="mods:name[mods:role/mods:roleTerm != 'pub']">
      <xsl:for-each select="mods:namePart[not(@type='date')]">
         <xsl:apply-templates select="."/><xsl:if test="position()!=last()"> &#160;</xsl:if>
         </xsl:for-each>
      <xsl:if test="mods:namePart[@type='date']">, <xsl:apply-templates select="mods:namePart[@type='date']"/></xsl:if>
      <xsl:if test="mods:role">
         <xsl:choose>
            <xsl:when test="mods:role/mods:roleTerm = 'aut'"/>
            <xsl:otherwise>
               (<xsl:value-of select="substring-before(mods:role/mods:roleTerm,' (')"/>)
            </xsl:otherwise>
         </xsl:choose>
         </xsl:if>
      <br/>
   </xsl:template>
   
   <xsl:template match="mods:classification">
      <xsl:apply-templates/><br/>
   </xsl:template>
   <xsl:template match="mods:genre">
         <xsl:choose>
            <xsl:when test=".='Volume'">
               Bound volume
            </xsl:when>
            <xsl:otherwise>
               <xsl:apply-templates/>
            </xsl:otherwise>
         </xsl:choose><br/>
   </xsl:template>
   <xsl:template match="mods:physicalDescription">
      <xsl:for-each select="mods:extent">
         <h4>Collation</h4>
         <xsl:apply-templates/>
      </xsl:for-each>
      <xsl:for-each select="mods:note">
         <h4>General Physical Description</h4>
         <xsl:apply-templates/>
      </xsl:for-each>
   </xsl:template>
   <xsl:template match="mods:originInfo">
      <xsl:if test="string-length(mods:palce[1]) &gt; 1">
         <xsl:value-of select="mods:place[1]"/>
         <xsl:if test="string-length(mods:publisher[1])&gt; 1"><xsl:text> : </xsl:text></xsl:if>
      </xsl:if>
      <xsl:if test="string-length(mods:publisher[1])&gt; 1">
         <xsl:value-of select="mods:publisher[1]"/>   
      </xsl:if>      
      <xsl:choose>
         <xsl:when test="string-length(mods:place[2]) &gt; 1">
            <xsl:value-of select="mods:place[1]"/><xsl:text> : </xsl:text><xsl:value-of select="mods:publisher[2]"/>, <xsl:value-of select="mods:dateIssued"/>
         </xsl:when>
         <xsl:otherwise>, <xsl:value-of select="mods:dateIssued"/></xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="mods:originInfo/mods:edition">
         <xsl:value-of select="."/><br/>
   </xsl:template>
   <xsl:template match="mods:note">
      <xsl:apply-templates/><br/>
   </xsl:template>
   <xsl:template match="mods:relatedItem[@type='series']">
      <xsl:apply-templates select="mods:titleInfo/mods:title"/><br/>
   </xsl:template>
   
</xsl:stylesheet>