$(document).ready(function () {
    // Sets global variables
    var daoTable = '.daoTable .dao';
    var parents = '.foundIn p';
    
    $(daoTable).each(function () {
        var a = $(this);
        var identifier = $(this).attr('data-identifier');
        a.text('Loading...');
        var search = '/xtf/view?docId=mets/'+identifier+'_mets/'+identifier+'_mets.xml;smode=daoTable';
        $.ajax(search).success(function (data) {
            // If results were retrieved, display them
            a.replaceWith(data);
        }).fail(function () {
            // If no results were retrieved, change text
            a.replaceWith('<span>Failed!</span>');
        });
    });
    
    $(function () {
        var collectionId = $(parents).attr('data-collectionId');
        var componentId = $(parents).attr('data-componentId');
        var resourceId = collectionId.substring(0, collectionId.indexOf('.xml');
        $(parents).text('Loading...');
        var search = '/xtf/view?docId=ead/'+resourceId+'/'+collectionId+';chunk.id=aspace_'+componentId+';doc.view=parents';
        $.ajax(search).success(function (data) {
            // If results were retrieved, display them
            $(parents).replaceWith(data);
        }).fail(function () {
            // If no results were retrieved, change text
            $(parents).replaceWith('<span>Failed!</span>');
        });
    });
});