<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:session="java:org.cdlib.xtf.xslt.Session" xmlns:mods="http://www.loc.gov/mods/v3"
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
        <xsl:param name="chunk.id"/>
        <xsl:param name="path"/>
        <xsl:param name="docPath"/>
        <xsl:if test="meta/level='file' or meta/level='item' or meta/type='mods'">
            <xsl:variable name="title">
                <xsl:value-of select="meta/title"/>
            </xsl:variable>
            <xsl:variable name="url">
                <xsl:value-of select="concat($xtfURL, $docPath)"/>
            </xsl:variable>
            <xsl:variable name="creator">
                <xsl:value-of select="meta/creator[1]"/>
            </xsl:variable>
            <xsl:variable name="callNo">
                <xsl:choose>
                    <xsl:when test="meta/type='mods'">
                        <xsl:value-of select="meta/identifier"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-before(meta/identifier, '-')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="date">
                <xsl:value-of select="meta/date"/>
            </xsl:variable>
            <xsl:variable name="collectionTitle">
                <xsl:value-of select="meta/collectionTitle"/>
            </xsl:variable>
            <xsl:variable name="restrictions">
                <xsl:value-of select="meta/accessrestrict"/>
            </xsl:variable>
            <xsl:variable name="identifier">
                <xsl:value-of select="meta/identifier"/>
            </xsl:variable>
            <xsl:variable name="container1">
                <xsl:choose>
                    <xsl:when test="contains(meta/containers, ',')">
                        <xsl:value-of
                            select="normalize-space(substring-before(meta/containers, ', '))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(meta/containers)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="container2">
                <xsl:if test="contains(meta/containers, ',')">
                    <xsl:value-of select="normalize-space(substring-after(meta/containers, ', '))"/>
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="parents">
                <xsl:for-each select="meta/parent[position()&gt;1]">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">
                        <xsl:text>; </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="barcode"/>
            <a href="#" class="list-add" data-identifier="{$identifier}"
                data-ItemNumber="{$barcode}" data-ItemTitle="{$collectionTitle}"
                data-ItemSubtitle="{$parents}" data-ItemAuthor="{$creator}" data-ItemDate="{$date}"
                data-CallNumber="{$callNo}" data-ItemVolume="{$container1}"
                data-ItemIssue="{$container2}" data-ItemInfo1="{$title}"
                data-ItemInfo2="{$restrictions}" data-ItemInfo3="{$url}">
                <img src="/xtf/icons/default/addbag.gif" alt="Add to My List"/>
            </a>
        </xsl:if>
    </xsl:template>

    <!--Creates links to add items to bookbag on finding aid pages-->
    <xsl:template name="myListEad">
        <xsl:param name="rootID"/>
        <xsl:variable name="identifier" select="concat($rootID,'-',@id)"/>
        <xsl:variable name="title">
            <xsl:value-of select="xtf:meta/title"/>
        </xsl:variable>
        <xsl:variable name="collectionTitle">
            <xsl:value-of select="xtf:meta/collectionTitle"/>
        </xsl:variable>
        <xsl:variable name="restrictions">
            <xsl:value-of select="xtf:meta/accessrestrict"/>
        </xsl:variable>
        <xsl:variable name="date">
            <xsl:value-of select="xtf:meta/date"/>
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
                    <xsl:value-of
                        select="concat($uri, ';chunk.id=', xtf:meta/seriesID, ';doc.view=contents;#', @id)"
                    />
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
                    <xsl:text>; </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="container1">
            <xsl:choose>
                <xsl:when test="contains(xtf:meta/containers, ',')">
                    <xsl:value-of
                        select="normalize-space(substring-before(xtf:meta/containers, ', '))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space(xtf:meta/containers)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="container2">
            <xsl:if test="contains(xtf:meta/containers, ',')">
                <xsl:value-of select="normalize-space(substring-after(xtf:meta/containers, ', '))"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="barcode"/>
        <a href="#" class="list-add" data-identifier="{$identifier}" data-ItemNumber="{$barcode}"
            data-ItemTitle="{$collectionTitle}" data-ItemSubtitle="{$parents}"
            data-ItemAuthor="{$creator}" data-ItemDate="{$date}" data-CallNumber="{$rootID}"
            data-ItemVolume="{$container1}" data-ItemIssue="{$container2}" data-ItemInfo1="{$title}"
            data-ItemInfo2="{$restrictions}" data-ItemInfo3="{$url}">
            <img src="/xtf/icons/default/addbag.gif" alt="Add to My List"/>
        </a>
    </xsl:template>

    <!--Creates links to add items to bookbag on library materials pages-->
    <xsl:template name="myListMods">
        <xsl:param name="url"/>
        <xsl:variable name="identifier">
            <xsl:value-of select="/mods:mods/mods:identifier"/>
        </xsl:variable>
        <xsl:variable name="title">
            <xsl:value-of select="mods:titleInfo/mods:title"/>
        </xsl:variable>
        <xsl:variable name="creator">
            <xsl:value-of select="mods:name[mods:role/mods:roleTerm != 'Publisher']"/>
        </xsl:variable>
        <xsl:variable name="date">
            <xsl:value-of select="mods:originInfo/mods:dateIssued"/>
        </xsl:variable>
        <xsl:variable name="callno">
            <xsl:value-of select="/mods:mods/mods:classification"/>
        </xsl:variable>
        <xsl:variable name="barcode"/>

        <xsl:choose>
            <xsl:when test="session:getData('bag')/child::*/child::*[@id=$identifier]">
                <span>Added</span>
            </xsl:when>
            <xsl:otherwise>
                <a href="#" class="list-add" data-identifier="{$identifier}"
                    data-ItemNumber="{$barcode}" data-ItemTitle="{$title}"
                    data-ItemAuthor="{$creator}" data-ItemDate="{$date}" data-CallNumber="{$callno}"
                    data-ItemInfo3="{$url}">
                    <img src="/xtf/icons/default/addbag.gif" alt="Add to My List"/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- navigation buttons for My List -->
    <xsl:template name="myListNav">
        <div class="pull-right" id="myListNav">
            <xsl:variable name="bag" select="session:getData('bag')"/>
            <div class="btn-group">
                <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown"
                    > My List (<span class="listCount"><xsl:value-of
                            select="count($bag/bag/savedDoc)"/></span>)<span class="caret"/>
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
            <a href="http://raccess.rockarch.org/aeon.dll" class="btn btn-default">Login</a>
        </div>
    </xsl:template>

    <!-- Header for My List page -->
    <xsl:template name="myListHeader">
        <h2>My List: <xsl:variable name="items" select="@totalDocs"/>
            <xsl:choose>
                <xsl:when test="$items = 1"><span class="listCount">1</span>
                    <xsl:text> Item</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <span class="listCount"><xsl:value-of select="$items"/></span>
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
            <a class="btn btn-default myListRemoveAll">Remove All Items</a>
        </div>
    </xsl:template>

    <!-- Emails items in My List to specified address -->
    <xsl:template name="myListEmail">
        <!--<xsl:variable name="bookbagContents" select="session:getData('bag')/bag"/>-->
        <div class="overlay" id="myListEmail">
            <div class="myListContents">
                <xsl:call-template name="emptyList"/>
            </div>
            <p class="help-block text-danger contentError">There's nothing to email!</p>
            <form id="myListMail" action="{$xtfURL}script/rac/myListMail.php" method="POST" class="form" role="form">
                <div class="left">
                    <div class="form-group">
                        <label class="control-label" for="email">Address</label>
                        <input class="form-control" type="text" name="email"/>
                        <p class="help-block text-danger" id="emailError">Please enter a valid email.</p>
                    </div>
                    <div class="form-group">
                        <label class="control-label" for="subject">Subject</label>
                        <input class="form-control" type="text" name="subject" placeholder="My List from dimes.rockarch.org"/>
                    </div>
                </div>
                <div class="right">
                    <div class="form-group">
                        <label class="control-label" for="message">Message</label>
                        <textarea class="form-control" type="textarea" name="message" rows="4"/>
                    </div>
                </div>
            </form>
        </div>

        <div class="overlay" id="myListEmailConfirm">
            <div class="confirm">
                <h2>Your request has been emailed!</h2>
            </div>
        </div>
        
        <div class="overlay" id="myListEmailError">
            <div class="confirm">
                <h2>We're sorry, but there was a problem sending your email.</h2>
                <p>Please try again, or contact us at <a href="mailto:archive@rockarch.org">archive@rockarch.org</a>.</p>
            </div>
        </div>
    </xsl:template>

    <!-- Prints My List -->
    <xsl:template name="myListPrint">
        <xsl:variable name="bookbagContents" select="session:getData('bag')/bag"/>
        <div class="overlay" id="myListPrint">
            <div class="myListContents">
                <xsl:call-template name="emptyList"/>
            </div>
            <p class="help-block text-danger contentError">There's nothing to print!</p>
        </div>
    </xsl:template>

    <!-- Submits an Aeon materials request for items in My List -->
    <xsl:template name="myListRequest">
        <div class="overlay" id="myListRequest">
            <form id="requestForm" method="post" target="new"
                action="https://raccess.rockarch.org/aeon.dll">
                <input name="AeonForm" value="EADRequest" type="hidden"/>
                <input name="RequestType" value="Loan" type="hidden"/>
                <input name="DocumentType" value="Default" type="hidden"/>
                <div class="myListContents">
                    <xsl:call-template name="emptyList"/>
                </div>
                <div class="left scheduledDate">
                    <div class="form-group">
                        <label class="control-label" for="scheduledDate">Scheduled Date</label>
                        <input class="form-control" name="ScheduledDate" type="text" value="12/20/2015"/>
                        <p class="help-block" id="dateError">Please enter the scheduled date of your research visit.</p>
                        <input type="hidden" name="UserReview" value="No"/>
                    </div>
                </div>
                <div class="right notes">
                    <div class="form-group">
                        <label class="control-label" for="Notes">Notes</label>
                        <textarea class="form-control" rows="4" name="Notes"/>
                    </div>
                </div>
            </form>
        </div>

        <div class="overlay" id="myListRequestConfirm">
            <div class="confirm">
                <h2>Your request has been submitted!</h2>
            </div>
        </div>
    </xsl:template>

    <!-- Submits an Aeon duplication request for items in My List -->
    <xsl:template name="myListCopies">
        <div class="overlay" id="myListCopies">
            <form id="duplicationForm" method="post" target="new"
                action="https://raccess.rockarch.org/aeon.dll">
                <input name="AeonForm" value="EADRequest" type="hidden"/>
                <input name="RequestType" value="Copy" type="hidden"/>
                <div class="myListContents">
                    <xsl:call-template name="emptyList"/>
                </div>
            </form>
        </div>

        <div class="overlay" id="myListCopiesConfirm">
            <div class="confirm">
                <h2>Your request has been submitted!</h2>
            </div>
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

    <!-- Creates placeholder display when My List is empty -->
    <xsl:template name="emptyList">
        <div class="empty">Your Bookbag is empty! Click on the icon that looks like this <img
                alt="bookbag icon" src="/xtf/icons/default/addbag.gif"/> next to one or more items
            in your <a href="">Search Results</a> to add it to your bookbag.</div>
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
