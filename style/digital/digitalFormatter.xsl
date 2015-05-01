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
        <table class="daoTable">
            <thead>
            <tr>
                <th>Filename</th>
                <th>Format</th>
                <th>Size</th>
                <th> </th>
                <th> </th>
            </tr>
            </thead>
            <tbody>
            <xsl:for-each select="meta/daoLink | xtf:meta/*:daoLink">
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
                    <tr class="dao" data-identifier="{$identifier}">
                        <td><img alt="loading data" src="/xtf/icons/default/loading.gif"/> <span style="color:#c45414;margin-left:.5em;">Loading</span></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                </xsl:if>
            </xsl:for-each>
                <xsl:for-each select="meta/daoLinkRestricted | xtf:meta/*:daoLinkRestricted">
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
                        <tr class="dao" data-identifier="{$identifier}" data-restricted="restricted">
                            <td><img alt="loading data" src="/xtf/icons/default/loading.gif"/> <span style="color:#c45414;margin-left:.5em;">Loading</span></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                    </xsl:if>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>
    
</xsl:stylesheet>
