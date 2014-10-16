$(document).ready(function() {
var windowWidth = $(window).width();
var windowHeight = $(window).height();

$(function () {
    var dialogSearchTips = $('#searchTips').dialog({
        create: function(event, ui) {
            var widget = $(this).dialog("widget");
            $(".ui-dialog-titlebar-close span", widget).removeClass("ui-icon-closethick").addClass("ui-icon-myCloseButton");
            },
        autoOpen: false,
        modal: true,
        resizable: true,
        width: windowWidth/1.5,
        close: function () {
            $('.ui-dialog').hide();
        }
    });

    $(".searchTips").on("click", function (e) {
        e.preventDefault();
        dialogSearchTips.dialog("option", "title", 'Searching Tips and Tricks').dialog("open");
    });
});

$(function () {
        var iframe = $('<iframe frameborder="0" marginwidth="0" marginheight="0"></iframe>');
        var dialog = $('<div class="dao-container"></div>').append(iframe).appendTo('body').dialog({
            create: function(event, ui) {
                var widget = $(this).dialog("widget");
                $(".ui-dialog-titlebar-close span", widget).removeClass("ui-icon-closethick").addClass("ui-icon-myCloseButton dao");
                },
            autoOpen: false,
            modal: true,
            resizable: true,
            width: windowWidth/1.2,
            height: "550",
            close: function () {
                $('.ui-dialog').hide();
                $('.dao-container > iframe').attr("src", "");
                $('.daoCitation').remove();
                
                }
            //close: function () {
            //    iframe.attr("src", "");
            //    $('.daoCitation').remove();
            //}
        });
                            
        $(".daoLink a, .caption a").on("click", function (e) {
            e.preventDefault();
            var dialogClass = 'dao';
            var src = $(this).attr("href");
            var title = $(this).attr("data-title");
            var width = $(this).attr("data-width");
            var height = "550";
            var citation = $(this).attr("data-citation");
            var buildCitation = $('<div class="daoCitation" style="margin-left:1em; font-size:.9em;"></div>').append(citation)
            iframe.attr({
                width: +width,
                height: +height,
                src: src
            });
                                dialog.dialog("option", "title", title).dialog("open").before(buildCitation);
                            });
                            
                            //checks for hash tag jumps to location and opens appropriate diolog 
                            if(window.location.hash) {
                              var hash = window.location.hash; //Puts hash in variable, and removes the # character
                              var offset = $(hash).position().top - 50;
                              $(hash).addClass("active");
                              setTimeout(function() {
                                    scrollActive($(hash));}, 100);
                                        
                               function scrollActive(element){
                                    $('div#content-wrapper').animate({scrollTop: offset}, 500); 
                                    }
                                    
                              if($(hash + " > .daoLink a[href]").length) {
                              $(hash + " .daoLink a").each(function (e) {
                                 var dialogClass = 'dao';
                                 var src = $(this).attr("href");
                                 var title = $(this).attr("data-title");
                                 var citation = $(this).attr("data-citation");
                                 var width = $(this).attr("data-width");
                                 var height = "550";
                                 var buildCitation = $('<div class="daoCitation"></div>').append(citation)
                                    iframe.attr({
                                    width: +width,
                                    height: +height,
                                    src: src
                                 });
                                 dialog.dialog("option", "title", title).dialog("open").before(buildCitation);
                              });
                            } 
                          }
                        });
                    
$(function () {
    var dialogDimes = $('#dimes').dialog({
        create: function(event, ui) {
            var widget = $(this).dialog("widget");
            $(".ui-dialog-titlebar-close span", widget).removeClass("ui-icon-closethick").addClass("ui-icon-myCloseButton");
            },
        autoOpen: false,
        modal: true,
        resizable: true,
        width: windowWidth/2,
        close: function () {
            $('.ui-dialog').hide();
                }
        });
       
    $("a.dimes").on("click", function (e) {
        e.preventDefault();
        dialogDimes.dialog("option", "title", 'Why DIMES?').dialog("open");
    });
});
    
$(function () {
    var dialogTakedown = $('#takedown').dialog({
        create: function(event, ui) {
            var widget = $(this).dialog("widget");
            $(".ui-dialog-titlebar-close span", widget).removeClass("ui-icon-closethick").addClass("ui-icon-myCloseButton");
            },
        autoOpen: false,
        modal: true,
        resizable: true,
        width: windowWidth/3,
        close: function () {
            $('.ui-dialog').hide();
        }
    });

    $("a.takedown").on("click", function (e) {
        e.preventDefault();
        dialogTakedown.dialog("option", "title", 'Take-Down Policy').dialog("open");
    });
});
$(function () {
    var dialogDscDescription = $('#dscDescription').dialog({
        create: function(event, ui) {
            var widget = $(this).dialog("widget");
            $(".ui-dialog-titlebar-close span", widget).removeClass("ui-icon-closethick").addClass("ui-icon-myCloseButton");
            },
        autoOpen: false,
        modal: true,
        resizable: true,
        width: windowWidth/3,
        close: function () {
            $('.ui-dialog').hide();
        }
    });

    $("a.dscDescription").on("click", function (e) {
        e.preventDefault();
        dialogDscDescription.dialog("option", "title", 'About Collection Guides').dialog("open");
    });
});
$(function () {
    var dialogTakedown = $('#license').dialog({
        create: function(event, ui) {
            var widget = $(this).dialog("widget");
            $(".ui-dialog-titlebar-close span", widget).removeClass("ui-icon-closethick").addClass("ui-icon-myCloseButton");
            },
        autoOpen: false,
        modal: true,
        resizable: true,
        width: windowWidth/1.5,
        close: function () {
            $('.ui-dialog').hide();
        }
    });

    $("a.license").on("click", function (e) {
        e.preventDefault();
        dialogTakedown.dialog("option", "title", 'Licensing for our descriptive metadata').dialog("open");
    });
});

$(function () {
    var dialogHoldings = $('#holdings').dialog({
        create: function(event, ui) {
            var widget = $(this).dialog("widget");
            $(".ui-dialog-titlebar-close span", widget).removeClass("ui-icon-closethick").addClass("ui-icon-myCloseButton");
            },
        autoOpen: false,
        modal: true,
        resizable: true,
        width: windowWidth/3,
        close: function () {
            $('.ui-dialog').hide();
        }
    });

    $("a.holdings").on("click", function (e) {
        e.preventDefault();
        dialogHoldings.dialog("option", "title", 'Rockefeller Archive Center Holdings').dialog("open");
        });
    });

$(function () {                      
        var dscOptions = {
            autoOpen: false,
            modal: true,
            resizable: true,
            width: windowWidth/3,
            close: function () {
                $('.ui-dialog').hide();
            }
        }
                         
        $(".dialog_dsc").click(function (e) {
            e.preventDefault();
            var id = '#' + $(this).parent().parent('div').attr('id') + '_details';
            $(id).dialog(dscOptions).dialog("option", "title", $(id).attr('rel')).dialog("open");
        });
        $(".restrict_dsc").click(function (e) {
            e.preventDefault();
            var id = '#' + $(this).parent().parent('div').attr('id') + '_restrictions';
            $(id).dialog(dscOptions).dialog("option", "title", $(id).attr('rel')).dialog("open");
        });
    });
$(function () {
    var dialogArchivalMat = $('#archivalMat').dialog({
        create: function(event, ui) {
            var widget = $(this).dialog("widget");
            $(".ui-dialog-titlebar-close span", widget).removeClass("ui-icon-closethick").addClass("ui-icon-myCloseButton");
            },
        autoOpen: false,
        modal: true,
        resizable: true,
        width: windowWidth/3,
        close: function () {
            $('.ui-dialog').hide();
        }
    });

    $("a.archivalMat").on("click", function (e) {
        e.preventDefault();
        dialogArchivalMat.dialog("option", "title", 'Archival Materials').dialog("open");
        });
});
$(function () {
    var dialogFeedback = $('#feedback').dialog({
        create: function(event, ui) {
            var widget = $(this).dialog("widget");
            $(".ui-dialog-titlebar-close span", widget).removeClass("ui-icon-closethick").addClass("ui-icon-myCloseButton");
            },
        autoOpen: false,
        modal: true,
        resizable: true,
        width: windowWidth/2,
        close: function () {
            $('.ui-dialog').hide();
        }
    });

    $(".feedback-tab").on("click", function (e) {
        e.preventDefault();
        dialogFeedback.dialog("option", "title", "Site Feedback").dialog("open");
        });
    });
$(function () {
    var dialogMyListEmail = $('#myListEmail').dialog({
        create: function(event, ui) {
            var widget = $(this).dialog("widget");
            $(".ui-dialog-titlebar-close span", widget).removeClass("ui-icon-closethick").addClass("ui-icon-myCloseButton");
            $(".ui-dialog-content").addClass("myList");
            },
        autoOpen: false,
        modal: true,
        resizable: true,
        buttons: [ 
            { text: "Send Email"},
            { text: "Cancel", click: function() { $( this ).dialog( "close" ); } }
            ],
        width: windowWidth/1.2,
        close: function () {
            $('.ui-dialog').hide();
        }
    });

    $(".myListEmail").on("click", function (e) {
        e.preventDefault();
        dialogMyListEmail.dialog("option", "title", "Email My List").dialog("open");
        });
    });
// $(function () {
//     var dialogMyListPrint = $('#myListPrint').dialog({
//         create: function(event, ui) {
//             var widget = $(this).dialog("widget");
//             $(".ui-dialog-titlebar-close span", widget).removeClass("ui-icon-closethick").addClass("ui-icon-myCloseButton");
//             $(".ui-dialog-content").addClass("myList");
//             },
//         autoOpen: false,
//         modal: true,
//         resizable: true,
//         buttons: [ 
//             { text: "Print", click: function(){window.print();}},
//             { text: "Cancel", click: function() { $( this ).dialog( "close" ); } }
//             ],
//         width: windowWidth/1.2,
//         close: function () {
//             $('.ui-dialog').hide();
//         }
//     });

//     $(".myListPrint").on("click", function (e) {
//         e.preventDefault();
//         dialogMyListPrint.dialog("option", "title", "Print My List").dialog("open");
//         });
//     });
$(function () {
    var dialogMyListRequest = $('#myListRequest').dialog({
        create: function(event, ui) {
            var widget = $(this).dialog("widget");
            $(".ui-dialog-titlebar-close span", widget).removeClass("ui-icon-closethick").addClass("ui-icon-myCloseButton");
            $(".ui-dialog-content").addClass("myList");
            },
        autoOpen: false,
        modal: true,
        resizable: true,
        buttons: [ 
            { text: "Request Materials"},
            { text: "Cancel", click: function() { $( this ).dialog( "close" ); } }
            ],
        width: windowWidth/1.2,
        close: function () {
            $('.ui-dialog').hide();
        }
    });

    $(".myListRequest").on("click", function (e) {
        e.preventDefault();
        dialogMyListRequest.dialog("option", "title", "Request in Reading Room").dialog("open");
        });
    });
    $(function () {
    var dialogMyListCopies = $('#myListCopies').dialog({
        create: function(event, ui) {
            var widget = $(this).dialog("widget");
            $(".ui-dialog-titlebar-close span", widget).removeClass("ui-icon-closethick").addClass("ui-icon-myCloseButton");
            $(".ui-dialog-content").addClass("myList");
            },
        autoOpen: false,
        modal: true,
        resizable: true,
        buttons: [ 
            { text: "Request Copies"},
            { text: "Cancel", click: function() { $( this ).dialog( "close" ); } }
            ],
        width: windowWidth/1.2,
        close: function () {
            $('.ui-dialog').hide();
        }
    });

    $(".myListCopies").on("click", function (e) {
        e.preventDefault();
        dialogMyListCopies.dialog("option", "title", "Print My List").dialog("open");
        });
    });
});