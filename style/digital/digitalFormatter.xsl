<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:session="java:org.cdlib.xtf.xslt.Session" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xtf="http://cdlib.org/xtf"
    xmlns="http://www.w3.org/1999/xhtml" extension-element-prefixes="session" exclude-result-prefixes="#all" version="2.0">

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
        <div class="daoTable">
            <div class="head">
                <div class="filename">Filename</div>
                <div class="format">Format</div>
                <div class="size">Size</div>
            </div>
            <xsl:for-each select="meta/daoLink | xtf:meta/*:daoLink | meta/daoLinkRestricted | xtf:meta/*:daoLinkRestricted">
                <xsl:if test=".!=''">
                    <xsl:variable name="identifier">
                        <!--http://storage.rockarch.org/46d03fe1-c30d-49b9-b1ff-da164a414ec3-rac_rfdiaries_12-2_mason_1928-1936_006.pdf-->
                        <xsl:analyze-string select="." regex="http://storage.rockarch.org/(([A-Z0-9^/]+)\-([A-Z0-9^/]+)\-([A-Z0-9^/]+)\-([A-Z0-9^/]+)\-([A-Z0-9^/]+))\-(.*)" flags="i">
                            <xsl:matching-substring>
                                <xsl:value-of select="regex-group(1)"/>
                            </xsl:matching-substring>
                            <xsl:non-matching-substring>
                                <xsl:value-of select="'none'"/>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </xsl:variable>
                    <div class="dao row" data-identifier="{$identifier}">
                        <img alt="loading data" src="/xtf/icons/default/loading.gif"/>
                        <span style="color:#c45414;margin-left:.5em;">Loading</span>
                    </div>
                </xsl:if>
            </xsl:for-each>
        </div>
    </xsl:template>

</xsl:stylesheet>
