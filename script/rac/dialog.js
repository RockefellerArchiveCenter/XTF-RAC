$(document).ready(function() {
if($(window).width() > 950) {
$(function () {
    var dialogSearchTips = $('#searchTips').dialog({
        create: function(event, ui) {
            var widget = $(this).dialog("widget");
            $(".ui-dialog-titlebar-close span", widget).removeClass("ui-icon-closethick").addClass("ui-icon-myCloseButton");
            },
        autoOpen: false,
        modal: true,
        resizable: true,
        width: "950",
        close: function () {
            $('.ui-dialog').hide();
        }
    });

    $(".searchTips").on("click", function (e) {
        e.preventDefault();
        dialogSearchTips.dialog("option", "title", 'Searching Tips and Tricks').dialog("open");
    });
});
} if($(window).width() > 850) {
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
            width: "850",
            height: "600",
            close: function () {
                $('.ui-dialog').hide();
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
            var height = $(this).attr("data-height");
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
                              $(hash).addClass("active");
                              if($(hash + " > .daoLink a[href]").length) {
                              $(hash + " .daoLink a").each(function (e) {
                                 var dialogClass = 'dao';
                                 var src = $(this).attr("href");
                                 var title = $(this).attr("data-title");
                                 var citation = $(this).attr("data-citation");
                                 var width = $(this).attr("data-width");
                                 var height = $(this).attr("data-height");
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
                    
} if($(window).width() > 800) {
$(function () {
    var dialogDimes = $('#dimes').dialog({
        create: function(event, ui) {
            var widget = $(this).dialog("widget");
            $(".ui-dialog-titlebar-close span", widget).removeClass("ui-icon-closethick").addClass("ui-icon-myCloseButton");
            },
        autoOpen: false,
        modal: true,
        resizable: true,
        width: "800",
        close: function () {
            $('.ui-dialog').hide();
                }
        });
       
    $("a.dimes").on("click", function (e) {
        e.preventDefault();
        dialogDimes.dialog("option", "title", 'Why DIMES?').dialog("open");
    });
});
} if($(window).width() > 600) {
    $(function () {                      
        var dscOptions = {
            autoOpen: false,
            modal: true,
            resizable: true,
            width: "550",
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
    var dialogTakedown = $('#takedown').dialog({
        create: function(event, ui) {
            var widget = $(this).dialog("widget");
            $(".ui-dialog-titlebar-close span", widget).removeClass("ui-icon-closethick").addClass("ui-icon-myCloseButton");
            },
        autoOpen: false,
        modal: true,
        resizable: true,
        width: "600",
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
        width: "500",
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
        width: "800",
        close: function () {
            $('.ui-dialog').hide();
        }
    });

    $("a.license").on("click", function (e) {
        e.preventDefault();
        dialogTakedown.dialog("option", "title", 'Licensing for our descriptive metadata').dialog("open");
    });
});
} if($(window).width() > 500) {
$(function () {
    var dialogHoldings = $('#holdings').dialog({
        create: function(event, ui) {
            var widget = $(this).dialog("widget");
            $(".ui-dialog-titlebar-close span", widget).removeClass("ui-icon-closethick").addClass("ui-icon-myCloseButton");
            },
        autoOpen: false,
        modal: true,
        resizable: true,
        width: "500",
        close: function () {
            $('.ui-dialog').hide();
        }
    });

    $("a.holdings").on("click", function (e) {
        e.preventDefault();
        dialogHoldings.dialog("option", "title", 'Rockefeller Archive Center Holdings').dialog("open");
        });
    });
} if($(window).width() > 400) {
$(function () {
    var dialogArchivalMat = $('#archivalMat').dialog({
        create: function(event, ui) {
            var widget = $(this).dialog("widget");
            $(".ui-dialog-titlebar-close span", widget).removeClass("ui-icon-closethick").addClass("ui-icon-myCloseButton");
            },
        autoOpen: false,
        modal: true,
        resizable: true,
        width: "400",
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
        width: "400",
        close: function () {
            $('.ui-dialog').hide();
        }
    });

    $(".feedback-tab").on("click", function (e) {
        e.preventDefault();
        dialogFeedback.dialog("option", "title", "Site Feedback").dialog("open");
        });
    });
}
});