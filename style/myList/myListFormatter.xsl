<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:session="java:org.cdlib.xtf.xslt.Session" 
    xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:xtf="http://cdlib.org/xtf" xmlns="http://www.w3.org/1999/xhtml"
    extension-element-prefixes="session" exclude-result-prefixes="#all" version="2.0">

    <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
    <!-- My List stylesheet                                                     -->
    <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->

    <!-- Written by Hillel Arnold, Rockefeller Archive Center, October 2014 -->

    <!-- This stylesheet formats the appearance of My List page and dialog      -->
    <!-- windows. Changes made in this stylesheet will impact functionality of  -->
    <!-- script/bookbag.js, since it relies on DOM structure generated here.    -->

    <!-- ====================================================================== -->
    <!-- My List Templates                                                      -->
    <!-- ====================================================================== -->


    <!--Creates links to add items to bookbag on search results pages-->
    <xsl:template name="myList">
        <xsl:param name="title"/>
        <xsl:param name="chunk.id"/>
        <xsl:param name="path"/>
        <xsl:param name="docPath"/>
        <xsl:param name="callNo"/>
        <xsl:variable name="url">
            <xsl:value-of select="concat($xtfURL, $docPath)"/>
        </xsl:variable>
        <xsl:variable name="creator">
            <xsl:value-of select="meta/creator[1]"/>
        </xsl:variable>
        <xsl:if test="meta/level='file' or meta/level='item'">
            <xsl:variable name="identifier">
                <xsl:value-of select="meta/identifier"/>
            </xsl:variable>
            <xsl:variable name="containers">
                <xsl:value-of select="normalize-space(meta/containers)"/>
                <xsl:if test="meta/extent != ''">
                    <xsl:text>, </xsl:text>
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="parents">
                <xsl:for-each select="meta/parent[position()&gt;1]">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">
                        <xsl:text>|</xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$smode = 'showBag'">
                    <a href="#" class="bookbag delete" data-identifier="{$identifier}">
                        <xsl:text>Delete</xsl:text>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="session:getData('bag')/bag/savedDoc[@id=$identifier]">
                            <span>Added</span>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- Need to add collectionTitle, accessRestrict. Look at variables in bookbag.js -->
                            <a href="#" class="bookbag" data-identifier="{$identifier}"
                                data-title="{$title}" data-url="{$url}" data-creator="{$creator}"
                                data-callNo="{$callNo}" data-containers="{$containers}"
                                data-parents="{$parents}">
                                <img src="/xtf/icons/default/addbag.gif" alt="Add to My List"/>
                            </a>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <!--Creates links to add items to bookbag on finding aid pages-->
    <xsl:template name="myListEad">
        <xsl:param name="rootID"/>
        <xsl:variable name="identifier" select="concat($rootID,'-',@id)"/>
        <xsl:variable name="title">
            <xsl:value-of select="xtf:meta/title"/>
        </xsl:variable>
        <xsl:variable name="url">
            <xsl:variable name="docID">
                <xsl:value-of select="concat('?docId=ead/', $rootID, '/', $rootID, '.xml')"/>
            </xsl:variable>
            <xsl:variable name="uri">
                <xsl:value-of select="concat($xtfURL, $dynaxmlPath, $docID)"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="string(xtf:meta/seriesID)">
                    <xsl:value-of select="concat($uri, ';chunk.id=', xtf:meta/seriesID, ';doc.view=contents;#', @id)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($uri, ';doc.view=contents;#', @id)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="creator">
            <xsl:value-of select="xtf:meta/creator[1]"/>
        </xsl:variable>
        <xsl:variable name="parents">
            <xsl:for-each select="xtf:meta/parent[position()&gt;1]">
                <xsl:value-of select="."/>
                <xsl:if test="position() != last()">
                    <xsl:text>|</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="containers">
            <xsl:value-of select="normalize-space(xtf:meta/containers)"/>
            <xsl:if test="xtf:meta/extent != ''">
                <xsl:text>, </xsl:text>
            </xsl:if>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="session:getData('bag')/child::*/child::*[@id=$identifier]">
                <span>Added</span>
            </xsl:when>
            <xsl:otherwise>
                <a href="#" class="bookbag" data-identifier="{$identifier}" data-title="{$title}"
                    data-url="{$url}" data-creator="{$creator}" data-containers="{$containers}" 
                    data-parents="{$parents}">
                    <img src="/xtf/icons/default/addbag.gif" alt="Add to My List"/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--Creates links to add items to bookbag on library materials pages-->
    <xsl:template name="myListMods">
        <xsl:variable name="identifier" select="/mods:mods/mods:identifier[1]"/>
        <xsl:variable name="title" select="mods:titleInfo/mods:title"/>
        <xsl:choose>
            <xsl:when test="session:getData('bag')/child::*/child::*[@id=$identifier]">
                <span>Added</span>
            </xsl:when>
            <xsl:otherwise>
                <a href="#" class="bookbag" data-identifier="{$identifier}" data-title="{$title}">
                    <img src="/xtf/icons/default/addbag.gif" alt="Add to My List"/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="myListNav">
        <div class="pull-right" id="myListNav">
            <xsl:variable name="bag" select="session:getData('bag')"/>
            <div class="btn-group">
                <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown"
                    > My List (<span id="bagCount"><xsl:value-of select="count($bag/bag/savedDoc)"
                        /></span>)<span class="caret"/>
                </button>
                <ul class="dropdown-menu pull-right" role="menu">
                    <li>
                        <a href="{$xtfURL}{$crossqueryPath}?smode=showBag">View</a>
                    </li>
                    <li>
                        <a href="#" class="myListEmail">Email</a>
                    </li>
                    <li>
                        <a href="#" class="myListPrint">Print</a>
                    </li>
                    <li>
                        <a href="#" class="myListRequest">Request in Reading Room</a>
                    </li>
                    <li>
                        <a href="#" class="myListCopies">Request copies</a>
                    </li>
                </ul>
            </div>
            <a href="http://raccess.rockarch.org" class="btn btn-default">Login</a>
        </div>
    </xsl:template>

    <xsl:template name="myListHeader">
        <h2>My List: <xsl:variable name="items" select="@totalDocs"/>
            <xsl:choose>
                <xsl:when test="$items = 1"><span id="bookbagCount">1</span>
                    <xsl:text> Item</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <span id="bookbagCount"><xsl:value-of select="$items"/></span>
                    <xsl:text> Items</xsl:text>
                </xsl:otherwise>
            </xsl:choose></h2>

        <div class="actions">
            <xsl:variable name="bag" select="session:getData('bag')"/>
            <xsl:variable name="bagCount" select="count($bag/bag/savedDoc)"/>
            <a class="btn btn-default myListEmail">E-mail My Bookbag</a>
            <a class="btn btn-default myListPrint">Print</a>
            <a class="btn btn-default myListRequest">Request in Reading Room</a>
            <a class="btn btn-default myListCopies">Request Copies</a>
            <a class="btn btn-default">Remove All Items</a>
        </div>
    </xsl:template>

    <xsl:template name="myListEmail">
        <xsl:variable name="bookbagContents" select="session:getData('bag')/bag"/>
        <div class="overlay" id="myListEmail">
            <div class="dscDescription">
                <div class="myListContents">
                    <xsl:call-template name="emptyList"/>
                </div>
                <xsl:variable name="bagCount" select="count($bookbagContents//savedDoc)"/>
                <form action="{$xtfURL}{$crossqueryPath}" method="get">
                    <label>Address:</label>
                    <input type="text" name="email"/>
                    <label>Subject:</label>
                    <input type="text" name="subject"/>
                    <input type="textarea" name="message"/>
                    <input class="btn btn-default" type="reset" value="Cancel"/>
                    <input class="btn btn-primary" type="submit" value="Send"/>
                    <input type="hidden" name="smode" value="emailFolder"/>
                    <input type="hidden" name="docsPerPage" value="{$bagCount}"/>
                </form>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="myListPrint">
        <xsl:variable name="bookbagContents" select="session:getData('bag')/bag"/>
        <div class="overlay" id="myListPrint">
            <div class="dscDescription">
                <div class="myListContents">
                    <xsl:call-template name="emptyList"/>
                </div>
                <xsl:variable name="bagCount" select="count($bookbagContents//savedDoc)"/>
                <form action="{$xtfURL}{$crossqueryPath}" method="get">
                    <input class="btn btn-default" type="reset" value="Cancel"/>
                    <input class="btn btn-primary" type="submit" value="Print"/>
                </form>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="myListRequest">
        <xsl:variable name="bookbagContents" select="session:getData('bag')/bag"/>
        <div class="overlay" id="myListRequest">
            <div class="myListContents">
                <xsl:call-template name="emptyList"/>
            </div>
            <xsl:variable name="bagCount" select="count($bookbagContents//savedDoc)"/>
            <form action="{$xtfURL}{$crossqueryPath}" method="get">
                <input class="btn btn-default" type="reset" value="Cancel"/>
                <input class="btn btn-primary" type="submit" value="Request in Reading Room"/>
            </form>
        </div>
    </xsl:template>

    <xsl:template name="myListCopies">
        <xsl:variable name="bookbagContents" select="session:getData('bag')/bag"/>
        <div class="overlay" id="myListCopies">
            <div class="myListContents">
                <xsl:call-template name="emptyList"/>
            </div>
            <xsl:variable name="bagCount" select="count($bookbagContents//savedDoc)"/>
            <form action="{$xtfURL}{$crossqueryPath}" method="get">
                <input class="btn btn-default" type="reset" value="Cancel"/>
                <input class="btn btn-primary" type="submit" value="Request Copies"/>
            </form>
        </div>
    </xsl:template>

    <xsl:template name="getAddress" exclude-result-prefixes="#all">
        <xsl:variable name="totalDocs" select="@totalDocs"/>
        <xsl:variable name="bookbagContents" select="session:getData('bag')/bag"/>
        <html xml:lang="en" lang="en">
            <head>
                <title>E-mail My List: Get Address</title>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                <xsl:copy-of select="$brand.links"/>
            </head>
            <body>
                <div class="getAddress" style="margin:.5em;">
                    <h2>E-mail My List</h2>
                    <xsl:variable name="bagCount" select="count($bookbagContents//savedDoc)"/>
                    <!--               <p><xsl:value-of select="$bagCount"/> items in your bookbag</p>-->
                    <form action="{$xtfURL}{$crossqueryPath}" method="get">
                        <table style="width: 200px;border:0;">
                            <tr>
                                <td>Address:</td>
                                <td>
                                    <input type="text" name="email"/>
                                </td>
                            </tr>
                            <tr>
                                <td>Subject:</td>
                                <td>
                                    <input type="text" name="subject"/>
                                </td>
                            </tr>
                            <tr>

                                <td colspan="2" style="text-align:right;">
                                    <input type="reset" value="CLEAR"/>
                                    <xsl:text>&#160;</xsl:text>
                                    <input type="submit" value="SUBMIT"
                                        onClick="_gaq.push(['_trackEvent', 'bookbag', 'send', '{@totalDocs}'])"/>
                                    <input type="hidden" name="smode" value="myListEmail"/>
                                    <input type="hidden" name="docsPerPage" value="{$bagCount}"/>
                                </td>
                            </tr>
                        </table>
                    </form>
                    <div style="margin:2em;">
                        <a class="showLink" id="preview-show" href="#">+ Show preview</a>
                        <div id="preview" class="more"
                            style=" width: 550px; height: 450px; overflow-y: scroll; display:none; border:1px solid #ccc; margin:.5em; padding: .5em; word-wrap: break-word;">
                            <xsl:call-template name="emptyList"/>
                            <!--                     <xsl:apply-templates select="$bookbagContents/savedDoc" mode="emailFolder"/>-->
                        </div>
                        <script type="text/javascript">
                     $('#preview-show').click(function() {
                        $('#preview').toggle();
                     });
                  </script>
                    </div>
                    <div class="closeWindow">
                        <a>
                            <xsl:attribute name="href">javascript://</xsl:attribute>
                            <xsl:attribute name="onClick">
                                <xsl:text>javascript:window.close('popup')</xsl:text>
                            </xsl:attribute> X Close this Window </a>
                    </div>
                </div>
            </body>
        </html>
    </xsl:template>

    <!--<xsl:template match="crossQueryResult" mode="myListEmail" exclude-result-prefixes="#all">
        <xsl:variable name="bookbagContents" select="session:getData('bag')/bag"/>

        <mail:send xmlns:mail="java:/org.cdlib.xtf.saxonExt.Mail"
            xsl:extension-element-prefixes="mail" smtpHost="" useSSL="no"
            from="archive@rockarch.org" to="{$email}" subject="{$subject}">
            <xsl:value-of select="$message"/>
            <xsl:call-template name="savedDoc"/>
        </mail:send>

        <div class="getAddress">
            <h1>E-mail My List</h1>
            <strong>Your items have been sent.</strong>
        </div>

    </xsl:template>-->
    
    <xsl:template name="emptyList">
        <div class="empty">Your Bookbag is empty! Click on the icon that looks like this <img alt="bookbag icon" src="/xtf/icons/default/addbag.gif" /> next to one or more items in your <a href="">Search Results</a> to add it to your bookbag.</div>
    </xsl:template>

    <!-- <xsl:template name="savedDoc">
        <xsl:variable name="bookbagContents" select="session:getData('bag')/bag"/>
        <xsl:for-each select="$bookbagContents/savedDoc">
            <h2>
                <a href="{url}">
                    <xsl:apply-templates select="title"/>
                </a>
            </h2>
            <h4>
                <xsl:value-of select="creator" disable-output-escaping="yes"/>
            </h4>
            <xsl:if test="string(containers)">
                <p>
                    <xsl:value-of select="containers" disable-output-escaping="yes"/>
                </p>
            </xsl:if>
            <xsl:if test="string(parents)">
                <p>
                    <xsl:value-of select="parents" disable-output-escaping="yes"/>
                </p>
            </xsl:if>
            <xsl:if test="string(date)">
                <p>
                    <xsl:value-of select="date" disable-output-escaping="yes"/>
                </p>
            </xsl:if>
            <xsl:if test="string(callNo)">
                <p>Call Number: <xsl:value-of select="callNo" disable-output-escaping="yes"/></p>
            </xsl:if>
            <xsl:text>&#xA;</xsl:text>
        </xsl:for-each>
    </xsl:template> -->

    <!--<xsl:template match="savedDoc" mode="myListEmail" exclude-result-prefixes="#all">
        <xsl:variable name="num" select="position()"/>
        <xsl:variable name="id" select="@id"/>
        <pre>myListEmail Mode</pre>
        <xsl:for-each select="$docHits[string(meta/identifier[1]) = $id]">
            <xsl:variable name="path" select="@path"/>
            <xsl:variable name="chunk.id" select="@subDocument"/>
            <xsl:variable name="docPath">
                <xsl:variable name="uri">
                    <xsl:call-template name="dynaxml.url">
                        <xsl:with-param name="path" select="$path"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$chunk.id != ''">
                        <xsl:value-of
                            select="concat($xtfURL,$uri,';chunk.id=',meta/seriesID,';doc.view=contents','#',$chunk.id)"
                        />
                    </xsl:when>
                    <xsl:when test="starts-with($uri,'view')">
                        <xsl:value-of select="concat($xtfURL,$uri)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$uri"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="url">
                <xsl:value-of select="$docPath"/>
            </xsl:variable>
            <xsl:variable name="level">
                <xsl:choose>
                    <xsl:when test="meta/level = 'collection'">Collection</xsl:when>
                    <xsl:when test="meta/level = 'series'">Series</xsl:when>
                    <xsl:when test="meta/level = 'subseries'">Subseries</xsl:when>
                    <xsl:when test="meta/level = 'recordgrp'">Record Group</xsl:when>
                    <xsl:when test="meta/level = 'subgrp'">Subgroup</xsl:when>
                    <xsl:when test="meta/level = 'fonds'">Fonds</xsl:when>
                    <xsl:when test="meta/level = 'subfonds'">Subfonds</xsl:when>
                    <xsl:when test="meta/level = 'class'">Class</xsl:when>
                    <xsl:when test="meta/level = 'otherlevel'">otherlevel</xsl:when>
                    <xsl:when test="meta/level = 'file'">File</xsl:when>
                    <xsl:when test="meta/level = 'item'">Item</xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="meta/type='mods'">
                    <pre>
                  <xsl:text>&#xA;</xsl:text>Title: <xsl:value-of select="normalize-space(meta/title)"/>
                  <xsl:text>&#xA;</xsl:text>Creator: <xsl:value-of select="meta/creator"/>
                  <xsl:if test="meta/date"><xsl:text>&#xA;</xsl:text>Date:  <xsl:value-of select="meta/date"/></xsl:if>
                  <xsl:if test="meta/callNo"><xsl:text>&#xA;</xsl:text>Call Number:  <xsl:value-of select="meta/callNo"/></xsl:if>
                  <xsl:text>&#xA;</xsl:text>URL: <xsl:value-of select="$url"/>
                  <xsl:text>&#xA;</xsl:text>  <xsl:text>&#xA;</xsl:text>
                </pre>
                </xsl:when>
                <xsl:otherwise>
                    <pre>
                  <xsl:text>&#xA;</xsl:text>
                  <xsl:if test="meta/format = 'Collection'">
                     <xsl:for-each select="meta/parent">
                        <xsl:value-of select="."/><xsl:text>&#xA;</xsl:text>
                     </xsl:for-each>
                  </xsl:if>
                  <xsl:if test="meta/level"/><xsl:value-of select="normalize-space(meta/title)"/><xsl:if test="meta/date"><xsl:text> ,</xsl:text><xsl:value-of select="meta/date"/></xsl:if>
                  <xsl:if test="meta/containers"><xsl:text>&#xA;</xsl:text><xsl:value-of select="meta/containers"/></xsl:if>
                  <xsl:text>&#xA;</xsl:text><xsl:value-of select="$url"/>
                  <xsl:text>&#xA;</xsl:text>  
                  <xsl:text>&#xA;</xsl:text>
                </pre>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>-->

</xsl:stylesheet>
