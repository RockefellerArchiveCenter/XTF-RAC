/*=================================================================================================
This script provides functionality to add and remove documents from a user's bookbag.

It assumes that all bookbag links have a common CSS selector, as well as an attribute that uniquely
identifies a document. It also assumes that the element displaying the number of items in a bookbag
has a unique CSS selector. These values are controlled by variables:

bookbag - the CSS selector for all bookbag links.
bagCount - the element which displays the number of items in the bookbag.
================================================================================================ */

$(function () {
    // Sets global variables
    var bookbagAdd = '.bookbag';
    var bookbagDelete = '.bookbag .delete';
    var bagCount = '#bagCount';
    
    // Removes link and changes text displayed if cookies are not enabled
    if (! navigator.cookieEnabled) {
        $(bookbag).text('Cookies not enabled');
    };

    //gets list items from localStorage
    function getList() {
        JSON.parse(localStorage.getItem("myList"));
    };

    //saves list items to localStorage
    function saveList(collection) {
        localStorage.setItem("myList", JSON.stringify(collection));
        console.log("list saved");
    };

    //update list on bookbag page and in dialogs
    function updateDisplay() {
        var myList = getList();
        console.log("myList: " + myList);
        for(var i =0; i <= myList.length -1; i++) {
            item = myList.getItem(i);
            console.log("item: " + item);
            $('.myListContents').append('<div><div>' + 
                item.title + ', ' + item.get('date') + '</div><div>' + 
                item.parents + '</div><div>' + 
                item.collectionTitle + '</div><div>' + 
                item.creator + '</div><div>' + 
                item.containers + '</div><div>' + 
                item.accessRestrict + '</div><div>' + 
                item.callNumber + '</div><div>' + 
                item.dateAdded + '</div></div>');
        };
    };

    //Might need some functions to sort by various fields, maybe title, collection, creator, date added
    //function sortList(param) {}
    
    // Main function to add and delete documents from bookbag
    $(bookbagAdd).on('click', function (e) {

            var a = $(this);

            //data variables
            var identifier = $(a).attr('data-identifier');
            var url = $(a).attr('data-url');
            var title = $(a).attr('data-title');
            var collectionTitle = $(a).attr('data-collectionTitle');
            var creator = $(a).attr('data-creator');
            var parents = $(a).attr('data-parents');
            var containers = $(a).attr('data-containers');
            var accessRestrict = $(a).attr('data-accessRestrict');
            var callNumber = $(a).attr('data-callNumber');
            var url = $(a).attr('data-url');

            //Let the user know something is happpening
            a.text('Adding...');

            // Add document to myList in localStorage
            var myList = new Array();
            var localStorage = getList();
            if (localStorage) {
                console.log("localStorage is not undefined")
                var myList = myList.push(localStorage);
            };
            var dateAdded = Date.now();
            console.log(myList);
            //may need to find a way to yank out attributes with undefined values
            // function replaceUndefined(variable) {
            //     if (variable === undefined) {
            //         return '';
            //     } else {
            //         return variable;
            //     };
            // };
            var doc = {
                'identifier': identifier,
                'title': title,
                'collectionTitle': collectionTitle,
                'creator': creator,
                'parents': parents,
                'containers': containers,
                'accessRestrict': accessRestrict,
                'callNumber': callNumber,
                'URL': url,
                // 'dateAdded': dateAdded
            }
            console.log(doc);
            myList.push(doc);
            console.log(myList);
            saveList(myList);

            // update display
            // updateDisplay();
            
            // Increase bookbag item count and change text
            var count = $(bagCount).text();
            $(bagCount).text(++ count);
            a.text('Added');
   
        e.preventDefault();

        //need this so function doesn't run twice
        return false;   
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