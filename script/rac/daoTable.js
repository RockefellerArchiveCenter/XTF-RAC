$(document).ready(function () {
    // Sets global variables
    var daoTable = '.daoTable .dao';
    var parents = '.foundIn p';
    
    $(daoTable).each(function () {
        var a = $(this);
        var identifier = $(this).attr('data-identifier');
        var restricted = $(this).attr('data-restricted')
        var search = '/xtf/view?docId=mets/' + identifier + '/' + identifier + '.xml;smode=daoTable;restricted='+restricted;
        $.ajax(search).success(function (data) {
            parsedData = $.parseHTML(data);
            // If there is no filename, remove this row
            if($(parsedData).find(".filename").length == 0){
                a.remove();
            }
            // Otherwise, display results
            else {
                a.replaceWith(data);
            }
        }).fail(function () {
            // If no results were retrieved, change text
            a.replaceWith('<span>Failed!</span>');
        });
    });
    
    $(function () {
        if ($('.foundIn').length) {
            var collectionId = $(parents).attr('data-collectionId');
            var componentId = $(parents).attr('data-componentId');
            var resourceId = collectionId.substring(0, collectionId.indexOf('.xml'));
            var filename = $(parents).attr('data-filename');
            var identifier = $(parents).attr('data-identifier');
            var search = '/xtf/view?docId=ead/' + resourceId + '/' + collectionId + ';chunk.id=' + componentId + ';doc.view=parents;filename=' + filename + ';identifier=' + identifier;
            $.ajax(search).success(function (data) {
                // If results were retrieved, display them
                $(parents).replaceWith(data);
            }).fail(function () {
                // If no results were retrieved, change text
                $(parents).replaceWith('<span>Failed!</span>');
            });
        }
    });
    
});