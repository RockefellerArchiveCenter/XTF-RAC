<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:session="java:org.cdlib.xtf.xslt.Session" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:xtf="http://cdlib.org/xtf" xmlns="http://www.w3.org/1999/xhtml"
    extension-element-prefixes="session" exclude-result-prefixes="#all" version="2.0">

    <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
    <!--  Digital objects stylesheet                                            -->
    <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->

    <!-- Written by Hillel Arnold, Rockefeller Archive Center, February 2015 -->

    <!-- This stylesheet formats the appearance of pages containing born-g      -->
    <!-- digital and digitized objects.                                         -->

    <!-- ====================================================================== -->
    <!-- DAO Table                                                              -->
    <!-- ====================================================================== -->

    <xsl:template name="daoTable">
        <!-- HA todo: add dao table template here -->
        <table class="daoTable">
            <tr>
                <th>Filename</th>
                <th>Last Modified</th>
                <th>Format</th>
                <th>Size</th>
            </tr>
        </table>
    </xsl:template>
    
    <!-- ====================================================================== -->
    <!-- DAO Details Page                                                       -->
    <!-- ====================================================================== -->
    
    <xsl:template match="dao" mode="daoDetails">
        <div>Hello world!</div>
        <div class="main">
            <div id="tocWrapper">
                <div id="foundIn"></div>
                <div class="subjects"></div>
            </div>
            <div id="content-wrapper">
                <div class="thumbnail">
                    <div class="thumbnailButtons"></div>
                </div>
                <div class="description">
                    <div class="title"></div>
                    <div class="creator"></div>
                    <div class="extent"></div>
                    <div class="parents"></div>
                    <div class="scopeContent"></div>
                    <div class="restrictions"></div>
                </div>
            </div>
        </div>
    </xsl:template>
    
</xsl:stylesheet>
