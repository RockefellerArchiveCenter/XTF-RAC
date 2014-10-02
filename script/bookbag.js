/*=================================================================================================
This script provides functionality to add and remove documents from a user's bookbag.

It assumes that all bookbag links have a common CSS selector, as well as an attribute that uniquely
identifies a document. It also assumes that the element displaying the number of items in a bookbag
has a unique CSS selector. These values are controlled by variables:

bookbag - the CSS selector for all bookbag links.
bagCount - the element which displays the number of items in the bookbag.
================================================================================================ */

$(document).ready(function () {
    // Sets global variables
    var bookbagAdd = '.bookbag';
    var bookbagDelete = '.bookbag .delete';
    var bagCount = '#bagCount';
    //data variables
    var identifier = 'data-identifier';
    var url = 'data-url';
    var title = 'data-title';
    var collectionTitle = 'data-collectionTitle';
    var creator = 'data-creator';
    var parents = 'data-parents';
    var containers = 'data-containers';
    var accessRestrict = 'data-accessRestrict';
    var callNumber = 'data-callNumber';
    var url = 'data-url';
    
    // Removes link and changes text displayed if cookies are not enabled
    if (! navigator.cookieEnabled) {
        $(bookbag).text('Cookies not enabled');
    };

    function getList() {
        JSON.parse(localStorage.getItem("myList"));
    };
    function saveList(collection) {
        localStorage.setItem("myList",JSON.stringify(collection));
    };

    //update list on bookbag page and in dialogs
    function updateDisplay() {
        var myList = getList();
        console.log(myList);
        for(var i =0; i <= myList.length -1; i++) {
            item = myList.getItem(i);
            console.log(item);
            $('.myListContents').append('<div>
                <div>' + item.title + ', ' + item.get('date') + '</div>
                <div>' + item.parents + '</div>
                <div>' + item.collectionTitle + '</div>
                <div>' + item.creator + '</div>
                <div>' + item.containers + '</div>
                <div>' + item.accessRestrict + '</div>
                <div>' + item.callNumber + '</div>
                <div>' + item.dateAdded + '</div>
                </div>');
        };
    };

    //Might need some functions to sort by various fields, maybe title, collection, creator, date added
    //function sortList(param) {}
    
    // Main function to add and delete documents from bookbag
    //may want to change this up so it's less based on text and more on classes?
    $(bookbagAdd).click(function (e) {
        var a = $(this);
            a.text('Adding...');

            // Add document to myList in localStorage
            var myList = getList();
            console.log(myList);
            var doc = {
                'identifier': $(a).attr(identifier),
                'title': $(a).attr(title),
                'collectionTitle': $(a).attr(collectionTitle),
                'creator': $(a).attr(creator),
                'date': $(a).attr(date),
                'parents': $(a).attr(parents),
                'containers': $(a).attr(containers),
                'accessRestrict': $(a).attr(accessRestrict),
                'callNumber': $(a).attr(callNumber),
                'URL': $(a).attr(url)
                'dateAdded': new Date();
            }
            console.log(doc);
            var newList = myList.push(doc);
            console.log(newList);
            saveList(newList);
            updateDisplay();
            
            // Increase bookbag item count and change text
            var count = $(bagCount).text();
            $(bagCount).text(++ count);
            a.replaceWith('<span>Added</span>');

        }
        e.preventDefault();
    });

    $(bookbagDelete).click(function(e) {
        var a = $(this);
        // Remove document from bookbag
            console.log('Deleting component ' + $(a).attr(identifier))
            a.text('Deleting...');
            var myList  = getList();

            for(var i=0; i <= myList.length -1; i++) {
                var item = myList.getItem(i);
                if (item.identifier === $(a).attr(identifier)) {
                    myList.splice(i, 1)
                }
            }
            
            saveList(newList);
            updateDisplay();
    })

});