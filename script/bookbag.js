/*=================================================================================================
This script provides functionality to add and remove documents from a user's bookbag.

It assumes that all bookbag links have a common CSS selector, as well as an attribute that uniquely
identifies a document. It also assumes that the element displaying the number of items in a bookbag
has a unique CSS selector. These values are controlled by variables:

bookbag - the CSS selector for all bookbag links.
bagCount - the element which displays the number of items in the bookbag.
================================================================================================ */

$(document).ready(function () {
    // Sets global selector variables
    var listAdd = '.list-add';
    var listDelete = '.list-delete';
    var listCount = '.listCount';
    
    // Removes link and changes text displayed if cookies are not enabled
    if (! navigator.cookieEnabled) {
        $(listAdd).text('Cookies not enabled');
    };

    //gets list items from localStorage
    function getList() {
        var list = JSON.parse(localStorage.getItem("myList"));
        return list;
    };

    //saves list items to localStorage
    function saveList(collection) {
        localStorage.setItem("myList", JSON.stringify(collection));
    };

    //update list on bookbag page and in dialogs
    function updateDisplay() {
        var myList = getList();
        console.log(myList);
        if (myList) {
            $('.myListContents').empty();
            if (myList.length > 0) {
            $('.myListContents').append(
                '<div class="row header-row">' + 
                    '<div class="checkbox">&nbsp;</div>' + 
                    '<div class="title">Title</div>' + 
                    '<div class="date">Date</div>' + 
                    '<div class="collectionTitle">Collection</div>' +
                    '<div class="containers">Containers</div>' +
                    '<div class="dateAdded">Date Added</div>' +
                '</div>');
            }
        for(var i =0; i <= myList.length -1; i++) {
            item = myList[i];
            //create variables
            function sanitize(value) {
                if (value) {return value;}
                else {return '&nbsp;';}
            }

            function dateConvert(value){
                if(value){
                    var date = new Date(value);
                    var d = date.toDateString();
                    var h = date.getHours();
                    var m = date.getMinutes();
                    if (h > 12) {
                        var p = h-12;
                        return d + ', ' + p + ':' + m + ' pm';
                    } else {
                        return d + ', ' + h + ':' + m + ' am';
                    }
                } else {
                    return '&nbsp;';
                }
            };

            function containerJoin(container1, container2) {
                if (container1) {
                if (container2) {
                    return container1 + ', ' + container2;
                } else {
                    return container1
                    }
                } else {
                    return '&nbsp;';
                }
                e.preventDefault();
            };

            var title = sanitize(item.title);
            var date = sanitize(item.date);
            var collectionTitle = sanitize(item.collectionTitle);
            var creator = sanitize(item.creator);
            var dateAdded = dateConvert(item.dateAdded);
            var identifier = sanitize(item.identifier);
            var url = sanitize(item.URL);
            var parents = sanitize(item.parents);
            var container1 = item.container1;
            var container2 = item.container2;
            var containers = containerJoin(container1, container2);
            var callNumber = sanitize(item.callNumber);
            var accessRestrict = sanitize(item.accessRestrict);

            $('.myListContents').append(
                '<div class="row">' + 
                    '<div class="checkbox"><input type="checkbox" checked="checked" name="include"/></div>' + 
                    '<div class="title"><p><a href="' + url + '">' + title + '</a></p></div>' + 
                    '<div class="date"><p>' + date + '</p></div>' + 
                    //'<div class="parents">' + item.parents + '</div>' +
                    '<div class="collectionTitle"><p>' + collectionTitle + '</p>' +
                        '<div class="creator"><p>' + creator + '</p></div>' +
                    '</div>' +
                    '<div class="containers"><p>' + containers + '</p></div>' +
                    //'<div class="restrictions">' + item.accessRestrict + '</div>' +
                    //'<div class="callNumber">' + item.callNumber + '</div>' +
                    '<div class="dateAdded"><p>' + dateAdded + '</p></div>' + 
                    '<div class="inputs">' +
                        '<input type="hidden" name="ItemInfo1" value="' + title + '"/>' +
                        '<input type="hidden" name="ItemDate" value="' + date + '"/>' +
                        '<input type="hidden" name="ItemTitle" value="' + collectionTitle + '"/>' +
                        '<input type="hidden" name="ItemAuthor" value="' + creator + '"/>' +
                        '<input type="hidden" name="ItemSubtitle" value="' + parents + '"/>' +
                        '<input type="hidden" name="ItemVolume" value="' + container1 + '"/>' +
                        '<input type="hidden" name="ItemIssue" value="' + container2 + '"/>' +
                        '<input type="hidden" name="ItemInfo2" value="' + accessRestrict + '"/>' +
                        '<input type="hidden" name="CallNumber" value="' + callNumber + '"/>' +
                        '<input type="hidden" name="ItemInfo3" value="' + url + '"/>' +
                    '</div>' +
                    '<button class="list-delete btn btn-danger" href="#" data-identifier="'+ identifier + '">Delete</button>' +
                '</div>');

            // change text for components already in bookbag
            $('.list-add[data-identifier*=' + item.identifier + ']').replaceWith('<span>Added</span>');

        };

        //update list count
        var count = myList.length
        $(listCount).text(count);
        if (count < 1) {
            $('.myListContents').append('<div class="empty">Your Bookbag is empty! Click on the icon that looks like this <img alt="bookbag icon" src="/xtf/icons/default/addbag.gif"/> next to one or more items in your <a href="">Search Results</a> to add it to your bookbag.</div>');
        }

    } else {
        //if list is empty, set count to zero
        $(listCount).text('0');
    }

    return false;

    };

    //Might need some functions to sort by various fields, maybe title, collection, creator, date added
    //function sortList(param) {}
    
    //Adds documents to My List
    $(listAdd).on('click', function (e) {

        var a = $(this);

        //data variables
        var identifier = $(a).attr('data-identifier');
        var title = $(a).attr('data-iteminfo1');
        var date = $(a).attr('data-itemdate');
        var collectionTitle = $(a).attr('data-itemtitle');
        var creator = $(a).attr('data-itemauthor');
        var parents = $(a).attr('data-itemsubtitle');
        var container1 = $(a).attr('data-itemvolume');
        var container2 = $(a).attr('data-itemissue');
        var accessRestrict = $(a).attr('data-iteminfo2');
        var callNumber = $(a).attr('data-callnumber');
        var url = $(a).attr('data-iteminfo3');

        //Let the user know something is happpening
        a.text('Adding...');

        // Add document to myList in localStorage        
            // figure out if there's an existing list in localStorage
            var localStorage = getList();
            if (localStorage) {
                var myList = localStorage;
            } else {
                var myList = new Array();};

            //create a new object to add to the array    
            var dateAdded = Date.now();
            var doc = {
                'identifier': identifier,
                'title': title,
                'date': date,
                'collectionTitle': collectionTitle,
                'creator': creator,
                'parents': parents,
                'container1': container1,
                'container2': container2,
                'accessRestrict': accessRestrict,
                'callNumber': callNumber,
                'URL': url,
                'dateAdded': dateAdded
            }

            //add the new item to the existing array
            myList.push(doc);

            //save the new list in localStorage
            saveList(myList);

            // update display
            updateDisplay();
   
        e.preventDefault();

        //need this so function doesn't run twice
        return false;   
    });

    // Removes documents from My List
    $('body').on('click', listDelete, function(e) {
        var a = $(this);
        var identifier = $(a).attr('data-identifier')
        // Remove document from bookbag
            a.text('Deleting...');
            var myList  = getList();

            for(var i=0; i <= myList.length -1; i++) {
                var item = myList[i];
                if (item.identifier === identifier) {
                    myList.splice(i, 1)
                }
            }
            
            // save new list in localStorage
            saveList(myList);

            // update display
            updateDisplay();

            e.preventDefault();
    })

    // Remove all items from bookbag
    $('.myListRemoveAll').on('click', function(e){
        var myList = [];
        saveList(myList);
        updateDisplay();
    });


    // update display
    updateDisplay();

    return false;

});