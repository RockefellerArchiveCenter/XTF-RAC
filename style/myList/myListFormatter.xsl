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
                <xsl:if test="meta/type='ead'">
                    <xsl:value-of select="meta/title"/>
                </xsl:if>
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
                <xsl:choose>
                    <xsl:when test="meta/type='ead'">
                        <xsl:value-of select="meta/collectionTitle"/>
                    </xsl:when>
                    <xsl:when test="meta/type='mods'">
                        <xsl:value-of select="meta/title"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="restrictions">
                <xsl:choose>
                    <xsl:when test="meta/filelevelaccessrestrict">
                        <xsl:value-of select="meta/filelevelaccessrestrict"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains(meta/accessrestrict,'open for research') or contains(meta/accessrestrict,'Open for research') or contains(meta/accessrestrict,'open for scholarly') or contains(meta/accessrestrict,'Open for scholarly')">
                                <xsl:if test="contains(meta/accessrestrict, 'years')">
                                        <xsl:value-of select="meta/accessrestrict"/>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="meta/accessrestrict"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
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
            <xsl:variable name="groupingfield">
                <xsl:value-of select="concat(meta/seriesID, '-', $container1)"/>
            </xsl:variable>
            <xsl:variable name="barcode"/>
            <a href="#" class="list-add" data-identifier="{$identifier}"
                data-ItemNumber="{$barcode}" data-ItemTitle="{$collectionTitle}"
                data-ItemSubtitle="{$parents}" data-ItemAuthor="{$creator}" data-ItemDate="{$date}"
                data-CallNumber="{$callNo}" data-ItemVolume="{$container1}"
                data-ItemIssue="{$container2}" data-ItemInfo1="{$title}"
                data-ItemInfo2="{$restrictions}" data-ItemInfo3="{$url}"
                data-GroupingField="{$groupingfield}">
                <img src="/xtf/icons/default/addlist.png" alt="Add to My List" title="Add to My List"/>
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
            <xsl:choose>
                <xsl:when test="xtf:meta/filelevelaccessrestrict">
                    <xsl:value-of select="xtf:meta/filelevelaccessrestrict"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="contains(xtf:meta/accessrestrict,'open for research') or contains(xtf:meta/accessrestrict,'Open for research') or contains(xtf:meta/accessrestrict,'open for scholarly') or contains(xtf:meta/accessrestrict,'Open for scholarly')">
                            <xsl:if test="contains(xtf:meta/accessrestrict, 'years')">
                                <xsl:value-of select="xtf:meta/accessrestrict"/>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="xtf:meta/accessrestrict"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
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
        <xsl:variable name="groupingfield">
            <xsl:value-of select="concat(xtf:meta/seriesID, '-', $container1)"/>
        </xsl:variable>
        <xsl:variable name="barcode"/>
        <a href="#" class="list-add" data-identifier="{$identifier}" data-ItemNumber="{$barcode}"
            data-ItemTitle="{$collectionTitle}" data-ItemSubtitle="{$parents}"
            data-ItemAuthor="{$creator}" data-ItemDate="{$date}" data-CallNumber="{$rootID}"
            data-ItemVolume="{$container1}" data-ItemIssue="{$container2}" data-ItemInfo1="{$title}"
            data-ItemInfo2="{$restrictions}" data-ItemInfo3="{$url}"
            data-GroupingField="{$groupingfield}">
            <img src="/xtf/icons/default/addlist.png" alt="Add to My List" title="Add to My List"/>
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
                    <img src="/xtf/icons/default/addlist.png" alt="Add to My List" title="Add to My List"/>
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
                            select="count($bag/bag/savedDoc)"/></span>)&#160;<span class="caret"/>
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
            <a href="http://raccess.rockarch.org/aeon.dll" class="btn btn-default" target="new"
                >Login</a>
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
            <form id="myListMail" action="{$xtfURL}script/rac/myListMail.php" method="POST"
                class="form" role="form">
                <div class="left">
                    <div class="form-group">
                        <label class="control-label required" for="email">Email Address</label>
                        <input class="form-control" type="text" name="email"/>
                        <p class="help-block text-danger" id="emailError">Please enter a valid
                            email.</p>
                    </div>
                    <div class="form-group">
                        <label class="control-label" for="subject">Subject</label>
                        <input class="form-control" type="text" name="subject"
                            placeholder="My List from dimes.rockarch.org"/>
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
                <!-- confirm message is appended to this element by dialog.js -->
                <h2/>
            </div>
        </div>

        <div class="overlay" id="myListEmailError">
            <div class="confirm">
                <h2>We're sorry, but there was a problem sending your e-mail.</h2>
                <p>Please try again, or contact us at <a href="mailto:archive@rockarch.org"
                        >archive@rockarch.org</a>.</p>
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
                <!-- Aeon inputs -->
                <input type="hidden" name="AeonForm" value="EADRequest"/>
                <input type="hidden" name="WebRequestForm" value="DefaultRequest"/>
                <input type="hidden" name="RequestType" value="Loan"/>
                <input type="hidden" name="DocumentType" value="Default"/>
                <input type="hidden" name="GroupingIdentifier" value="GroupingField"/>
                <input type="hidden" name="GroupingOption_ItemInfo1" value="Concatenate"/>
                <input type="hidden" name="GroupingOption_ItemDate" value="Concatenate"/>
                <input type="hidden" name="GroupingOption_ItemTitle" value="FirstValue"/>
                <input type="hidden" name="GroupingOption_ItemAuthor" value="FirstValue"/>
                <input type="hidden" name="GroupingOption_ItemSubtitle" value="FirstValue"/>
                <input type="hidden" name="GroupingOption_ItemVolume" value="FirstValue"/>
                <input type="hidden" name="GroupingOption_ItemIssue" value="Concatenate"/>
                <input type="hidden" name="GroupingOption_ItemInfo2" value="Concatenate"/>
                <input type="hidden" name="GroupingOption_CallNumber" value="FirstValue"/>
                <input type="hidden" name="GroupingOption_ItemInfo3" value="Concatenate"/>
                <input type="hidden" name="SubmitButton" value="Submit Request"/>
                <input type="hidden" name="UserReview" value="No"/>
                <div class="myListContents">
                    <xsl:call-template name="emptyList"/>
                </div>
                <div class="left">
                    <div>
                        <div class="radio">
                            <input id="VisitScheduled" name="Visit" type="radio" checked="checked">
                                Schedule Retrieval</input>
                        </div>
                        <div class="radio">
                            <input id="VisitReview" name="Visit" type="radio"> Keep for My
                                Review</input>
                        </div>
                    </div>

                    <div class="form-group scheduledDate">
                        <label class="control-label required" for="scheduledDate">Scheduled
                            Date</label>
                        <input id="ScheduledDate" class="form-control" name="ScheduledDate"
                            type="text" placeholder="Enter the date of your research visit"/>
                    </div>
                    <div class="form-group userReview">
                        <span class="help-text">This request will be saved in RACcess, but won't be
                            retrieved until you submit it for processing.</span>
                    </div>
                </div>
                <div class="right notes">
                    <div class="form-group">
                        <label class="control-label" for="Notes">Notes</label>
                        <textarea class="form-control" rows="4" name="Notes"/>
                    </div>
                </div>
            </form>
            <div class="register">
                <strong>Got an account?</strong> If not, make sure you <a
                    href="http://raccess.rockarch.org" target="_blank">register</a> and log in
                before requesting materials to view in the reading room or you will need to submit
                your request again.<br/>
                <strong>Good to know:</strong> Folders in the same box may be grouped together in a
                single request. </div>
        </div>

        <div class="overlay" id="myListRequestConfirm">
            <div class="confirm">
                <h2>Your request to view these materials has been submitted to RACcess!</h2>
                <p>Your request will open in a new browser tab, but you can also <a
                        href="https://raccess.rockarch.org/aeon.dll" target="_blank">click here</a>
                    to see your requests.</p>
                <p>If you tried to submit a request before registering for an account, you'll have
                    to submit your request again. Sorry about that!</p>
            </div>
        </div>
    </xsl:template>

    <!-- Submits an Aeon duplication request for items in My List -->
    <xsl:template name="myListCopies">
        <div class="overlay" id="myListCopies">
            <form id="duplicationForm" method="post" target="new"
                action="https://raccess.rockarch.org/aeon.dll">
                <input type="hidden" name="AeonForm" value="EADRequest"/>
                <input type="hidden" name="WebRequestForm" value="PhotoduplicationRequest"/>
                <input type="hidden" name="RequestType" value="Copy"/>
                <input type="hidden" name="DocumentType" value="Default"/>
                <input type="hidden" name="GroupingIdentifier" value="GroupingField"/>
                <input type="hidden" name="GroupingOption_ItemInfo1" value="Concatenate"/>
                <input type="hidden" name="GroupingOption_ItemDate" value="Concatenate"/>
                <input type="hidden" name="GroupingOption_ItemTitle" value="FirstValue"/>
                <input type="hidden" name="GroupingOption_ItemAuthor" value="FirstValue"/>
                <input type="hidden" name="GroupingOption_ItemSubtitle" value="FirstValue"/>
                <input type="hidden" name="GroupingOption_ItemVolume" value="FirstValue"/>
                <input type="hidden" name="GroupingOption_ItemIssue" value="Concatenate"/>
                <input type="hidden" name="GroupingOption_ItemInfo2" value="Concatenate"/>
                <input type="hidden" name="GroupingOption_CallNumber" value="FirstValue"/>
                <input type="hidden" name="GroupingOption_ItemInfo3" value="Concatenate"/>
                <input type="hidden" name="SkipOrderEstimate" value="Yes"/>
                <input type="hidden" name="SubmitButton" value="Submit Request"/>
                <div class="myListContents">
                    <xsl:call-template name="emptyList"/>
                </div>
                <div class="left">
                    <div class="form-group">
                        <label class="control-label required" for="Format">Format</label>
                        <!-- These options mush match exactly the list in the Aeon list of formats -->
                        <select id="Format" class="form-control" name="Format">
                            <option/>
                            <option>JPEG</option>
                            <option>PDF</option>
                            <option>Photocopy</option>
                            <option>TIFF</option>
                        </select>
                        <p class="help-block text-danger" id="formatError">Please select a
                            format.</p>
                    </div>
                    <div class="form-group">
                        <label class="control-label required" for="ItemPages">Description of
                            Materials</label>
                        <input id="ItemPages" class="form-control" name="ItemPages" type="text"
                            placeholder="Describe the materials you want reproduced"/>
                        <p class="help-block text-danger" id="itemPagesError">Please enter a
                            description of the materials you want reproduced.</p>
                    </div>
                </div>
                <div class="right notes">
                    <div class="form-group">
                        <label class="control-label" for="Notes">Notes</label>
                        <textarea class="form-control" rows="4" name="Notes"/>
                    </div>
                </div>
            </form>
            <div class="register">
                <strong>Important:</strong> By submitting this request you're agreeing to pay the
                costs. See our <a href="#" target="_blank">fee schedule</a>.<br/>
                <strong>Got an account?</strong> If not, make sure you <a
                    href="http://raccess.rockarch.org" target="_blank">register</a> and log in
                before requesting copies, or you will need to submit your request again.<br/>
                <strong>Good to know:</strong> Folders in the same box may be grouped together in a
                single request. </div>
        </div>

        <div class="overlay" id="myListCopiesConfirm">
            <div class="confirm">
                <h2>Your request for copies has been submitted to RACcess!</h2>
                <p>Your request will open in a new browser tab, but you can also <a
                        href="https://raccess.rockarch.org/aeon.dll" target="_blank">click here</a>
                    to see your requests.</p>
                <p>If you tried to submit a request before registering for an account, you'll have
                    to submit your request again. Sorry about that!</p>
            </div>
        </div>
    </xsl:template>

    <!-- Creates placeholder display when My List is empty -->
    <xsl:template name="emptyList">
        <div class="empty">Your Bookbag is empty! Click on the icon that looks like this <img
                alt="bookbag icon" src="/xtf/icons/default/addbag.gif"/> next to one or more items
            in your <a href="">Search Results</a> to add it to your bookbag.</div>
    </xsl:template>

</xsl:stylesheet>
