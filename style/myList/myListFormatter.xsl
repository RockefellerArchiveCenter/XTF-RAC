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
                    <xsl:variable name="octothorpe">
                        <xsl:value-of select="replace(meta/title, '#', 'No.')"/>
                    </xsl:variable>
                    <xsl:variable name="quot">"</xsl:variable>
                    <xsl:variable name="apos">'</xsl:variable>
                    <xsl:value-of select="replace($octothorpe, $quot, $apos)"/>
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
                        <xsl:value-of select="meta/callNo"/>
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
                        <xsl:if test="not(contains(meta/accessrestrict,'open for research') or contains(meta/accessrestrict,'Open for research') or contains(meta/accessrestrict,'open for scholarly') or contains(meta/accessrestrict,'Open for scholarly'))">
                           <xsl:value-of select="meta/accessrestrict"/>
                        </xsl:if>
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
                <xsl:choose>
                    <xsl:when test="meta/seriesID !=''">
                        <xsl:value-of select="concat(meta/seriesID, '-', $container1)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="meta/identifier"/>
                    </xsl:otherwise>
                </xsl:choose>            
            </xsl:variable>
            <xsl:variable name="type">
                <xsl:choose>
                    <xsl:when test="meta/type='ead'">Archival</xsl:when>
                    <xsl:when test="meta/type='mods'">Library</xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="barcode"/>
            <a href="#" class="list-add" data-identifier="{$identifier}"
                data-ItemNumber="{$barcode}" data-ItemTitle="{$collectionTitle}"
                data-ItemSubtitle="{$parents}" data-ItemAuthor="{$creator}" data-ItemDate="{$date}"
                data-CallNumber="{$callNo}" data-ItemVolume="{$container1}"
                data-ItemIssue="{$container2}" data-ItemInfo1="{$title}"
                data-ItemInfo2="{$restrictions}" data-ItemInfo3="{$url}"
                data-GroupingField="{$groupingfield}" onClick="_gaq.push(['_trackEvent', 'My List', 'Add', '{$type} Search Results']);">
                <img src="/xtf/icons/default/addlist.png" alt="Add to My List" title="Add to My List"/>
            </a>
        </xsl:if>
    </xsl:template>

    <!--Creates links to add items to bookbag on finding aid pages-->
    <xsl:template name="myListEad">
        <xsl:param name="rootID"/>
        <xsl:variable name="identifier" select="concat($rootID,'-',@id)"/>
        <xsl:variable name="title">
            <xsl:variable name="octothorpe">
                <xsl:value-of select="replace(xtf:meta/title, '#', 'No.')"/>
            </xsl:variable>
            <xsl:variable name="quot">"</xsl:variable>
            <xsl:variable name="apos">'</xsl:variable>
            <xsl:value-of select="replace($octothorpe, $quot, $apos)"/>
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
                    <xsl:if test="not(contains(xtf:meta/accessrestrict,'open for research') or contains(xtf:meta/accessrestrict,'Open for research') or contains(xtf:meta/accessrestrict,'open for scholarly') or contains(xtf:meta/accessrestrict,'Open for scholarly'))">
                       <xsl:value-of select="xtf:meta/accessrestrict"/>
                    </xsl:if>
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
            data-GroupingField="{$groupingfield}" onClick="_gaq.push(['_trackEvent', 'My List', 'Add', 'Archival Container List']);">
            <img src="/xtf/icons/default/addlist.png" alt="Add to My List" title="Add to My List"/>
        </a>
    </xsl:template>

    <!--Creates links to add items to bookbag on library materials pages-->
    <xsl:template name="myListMods">
        <xsl:param name="url"/>
        <xsl:variable name="identifier">
            <xsl:value-of select="/mods:mods/mods:identifier[@type='local']"/>
        </xsl:variable>
        <xsl:variable name="title">
            <xsl:value-of select="/mods:mods/xtf:meta/*:title"/>
        </xsl:variable>
        <xsl:variable name="creator">
            <xsl:value-of select="/mods:mods/xtf:meta/*:creator"/>
        </xsl:variable>
        <xsl:variable name="date">
            <xsl:value-of select="/mods:mods/xtf:meta/*:date"/>
        </xsl:variable>
        <xsl:variable name="callno">
            <xsl:value-of select="/mods:mods/xtf:meta/*:callNo"/>
        </xsl:variable>
        <xsl:variable name="groupingfield">
            <xsl:value-of select="/mods:mods/xtf:meta/*:identifier"></xsl:value-of>
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
                    data-ItemInfo3="{$url}" data-GroupingField="{$groupingfield}"
                    onClick="_gaq.push(['_trackEvent', 'My List', 'Add', 'Library Record']);">
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
                <button id="myListButton" type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown"
                    ><img src="/xtf/icons/default/add.png"/> My List (<span class="listCount"><xsl:value-of
                            select="count($bag/bag/savedDoc)"/></span>)&#160;<span class="caret"/>
                </button>
                <ul class="dropdown-menu pull-right" role="menu">
                    <li>
                        <a href="{$xtfURL}{$crossqueryPath}?smode=showBag" onClick="_gaq.push(['_trackEvent', 'My List', 'View', 'My List Button']);">View</a>
                    </li>
                    <li>
                        <a href="#" class="myListEmail" onClick="_gaq.push(['_trackEvent', 'My List', 'Email', 'My List Button']);">Email</a>
                    </li>
                    <li>
                        <a href="#" class="myListPrint" onClick="_gaq.push(['_trackEvent', 'My List', 'Print', 'My List Button']);">Print</a>
                    </li>
                    <li>
                        <a href="#" class="myListRequest" onClick="_gaq.push(['_trackEvent', 'My List', 'Reading Room Request', 'My List Button']);">Request in Reading Room</a>
                    </li>
                    <li>
                        <a href="#" class="myListCopies" onClick="_gaq.push(['_trackEvent', 'My List', 'Duplication Request', 'My List Button']);">Request copies</a>
                    </li>
                </ul>
            </div>
            <a href="https://raccess.rockarch.org/aeon.dll" class="btn btn-default" target="new" onClick="_gaq.push(['_trackEvent', 'My List', 'Log In', 'Log In Button']);"
                >Login to RACcess</a>
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
            <a class="btn btn-default myListEmail" onClick="_gaq.push(['_trackEvent', 'My List', 'Email', 'My List Header']);"><img src="/xtf/icons/default/email-list.png"/> E-mail My Bookbag</a>
            <a class="btn btn-default myListPrint" onClick="_gaq.push(['_trackEvent', 'My List', 'Print', 'My List Header']);"><img src="/xtf/icons/default/print-list.png"/> Print</a>
            <a class="btn btn-default myListRequest" onClick="_gaq.push(['_trackEvent', 'My List', 'Reading Room Request', 'My List Header']);"><img src="/xtf/icons/default/reading-room-request.png"/> Request in Reading Room</a>
            <a class="btn btn-default myListCopies" onClick="_gaq.push(['_trackEvent', 'My List', 'Duplication Request', 'My List Header']);"><img src="/xtf/icons/default/duplication-request.png"/> Request Copies</a>
            <a class="btn btn-default myListRemoveAll" onClick="_gaq.push(['_trackEvent', 'My List', 'Remove All Items', 'My List Header']);"><img src="/xtf/icons/default/delete-all.png"/> Remove All Items</a>
        </div>
    </xsl:template>

    <!-- Emails items in My List to specified address -->
    <xsl:template name="myListEmail">
        <!--<xsl:variable name="bookbagContents" select="session:getData('bag')/bag"/>-->
        <div class="overlay" id="myListEmail">
            <div class="myListContents dialog">
                <xsl:call-template name="emptyList"/>
            </div>
            <p class="help-block text-danger contentError">There's nothing to email!</p>
            <form id="myListMail" action="{$xtfURL}script/rac/myListMail.php" method="POST"
                class="form" role="form">
                <div class="half">
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
                <div class="half">
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
            <div class="myListContents dialog">
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
                <input type="hidden" name="GroupingOption_ItemInfo3" value="FirstValue"/>
                <input type="hidden" name="SubmitButton" value="Submit Request"/>
                <input type="hidden" name="UserReview" value="No"/>
                <div class="myListContents dialog">
                    <xsl:call-template name="emptyList"/>
                </div>
                <div class="third">
                    <div>
                        <div class="radio">
                            <input id="VisitReview" name="Visit" type="radio"> Keep for My
                                Review</input>
                        </div>
                        <div class="radio">
                            <input id="VisitScheduled" name="Visit" type="radio" checked="checked">
                                Schedule Retrieval</input>
                        </div>
                    </div>

                    <div class="form-group scheduledDate">
                        <label class="control-label required" for="scheduledDate">Scheduled
                            Date</label>
                        <input id="ScheduledDate" class="form-control" name="ScheduledDate"
                            type="text" placeholder="Enter the date of your research visit"/>
                        <div id="dateError" class="error">Please enter the date of your research visit.</div>
                    </div>
                    <div class="form-group userReview">
                        <span class="help-block">This request will be saved in RACcess, but won't be
                            retrieved until you submit it for processing.</span>
                    </div>
                </div>
                <div class="third notes">
                    <div class="form-group">
                        <label class="control-label" for="SpecialRequest">Special Requests/Questions</label>
                        <textarea class="form-control" rows="2" name="SpecialRequest"/>
                        <span class="help-block">Please enter any special requests or questions for RAC staff.</span>
                    </div>
                </div>
                <div class="third notes">
                    <div class="form-group">
                        <label class="control-label" for="Notes">Notes</label>
                        <textarea class="form-control" rows="2" name="Notes"/>
                        <span class="help-block">Enter any notes about this request for your personal reference here.</span>
                    </div>
                </div>
            </form>
            <div class="register">
                <strong>Good to know:</strong> Folders in the same box may be grouped together in a
                single request. </div>
        </div>

        <div class="overlay" id="myListRequestConfirm">
            <div class="confirm">
                <h1>Your request has been submitted to RACcess!</h1>
                <p><a href="https://raccess.rockarch.org/aeon.dll" target="_blank" onClick="_gaq.push(['_trackEvent', 'My List', 'Log In', 'Reading Room Request Confirm Dialog']);">
                    Click here</a> to see your requests.</p>
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
                <input type="hidden" name="GroupingOption_ItemInfo3" value="FirstValue"/>
                <input type="hidden" name="SkipOrderEstimate" value="Yes"/>
                <input type="hidden" name="SubmitButton" value="Submit Request"/>
                <div class="myListContents dialog">
                    <xsl:call-template name="emptyList"/>
                </div>
                <div class="register"><input id="costagree" type="checkbox"/> I agree to pay the duplication costs for this request. See our <a href="http://rockarch.org/research/inforesearch.php#photocopying" target="_blank" onClick="_gaq.push(['_trackEvent', 'My List', 'Fee Schedule', 'Duplication Dialog']);">fee schedule</a>.</div>
                <div class="third">
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
                    <div class="form-group">
                        <input id="ForPublication" name="ForPublication" type="checkbox" value="Yes"/>
                        <xsl:text> If you intend to publish this material, check this box</xsl:text>
                    </div>
                </div>
                <div class="third notes">
                    <div class="form-group">
                        <label class="control-label" for="SpecialRequest">Special Requests/Questions</label>
                        <textarea class="form-control" rows="2" name="SpecialRequest"/>
                        <span class="help-block">Please enter any special requests or questions for RAC staff.</span>
                    </div>
                </div>
                <div class="third notes">
                    <div class="form-group">
                        <label class="control-label" for="Notes">Notes</label>
                        <textarea class="form-control" rows="2" name="Notes"/>
                        <span class="help-block">Enter any notes about this request for your personal reference here.</span>
                    </div>
                </div>
            </form>
            <div class="register">
                <strong>Good to know:</strong> If you want a cost estimate for your order, email an archivist at <a href="mailto:archive@rockarch.org" onClick="_gaq.push(['_trackEvent', 'My List', 'Contact Us', 'Duplication Dialog']);">archive@rockarch.org</a>.
                Folders in the same box may be grouped together in a single request. </div>
        </div>

        <div class="overlay" id="myListCopiesConfirm">
            <div class="confirm">
                <h1>Your request has been submitted to RACcess!</h1>
                <p><a href="https://raccess.rockarch.org/aeon.dll" target="_blank" onClick="_gaq.push(['_trackEvent', 'My List', 'Log In', 'Reading Room Request Confirm Dialog']);">
                    Click here</a> to see your requests.</p>
            </div>
        </div>
    </xsl:template>

    <!-- Creates placeholder display when My List is empty -->
    <xsl:template name="emptyList">
        <div class="empty">Your List is empty! Click on the icon that looks like this <img
                alt="bookbag icon" src="/xtf/icons/default/addlist.png"/> next to one or more items
            in your <a href="">Search Results</a> to add it to your list.</div>
    </xsl:template>

</xsl:stylesheet>
