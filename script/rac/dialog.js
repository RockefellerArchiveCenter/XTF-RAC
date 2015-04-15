$(document).ready(function() {
var windowWidth = $(window).width();
var windowHeight = $(window).height();

$('#myListEmail #emailError').hide();
$('#myListRequest #dateError').hide();
$('#myListCopies #formatError').hide();
$('#myListCopies #itemPagesError').hide();
$('.contentError').hide();

function content() {
    if($('.myListContents .empty').length) {
        return false;
    } else {
        return true;
    }
}

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
            create: function(event, ui) {
            var widget = $(this).dialog("widget");
            $(".ui-dialog-titlebar-close span", widget).removeClass("ui-icon-closethick").addClass("ui-icon-myCloseButton");
            },
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
    // Validate the form
    function validate(){
        console.log('validating')
        var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
        var email= $('#myListEmail input[name="email"]').val();
        if(!regex.test(email)){
            console.log('email error')
            $('#myListEmail input[name="email"]').addClass('error');
            $('#myListEmail #emailError').show();
            return false;
        }
        else if(!content()) {
            console.log('content error')
            $('#myListEmail .contentError').show();
            return false;
        } else {
            return true;
        };
    }

    // Sends the email
    function sendEmail() {
        // Adds text for blank subject lines
        function checkSubject() {
            if($('#myListEmail input[name="subject"]').val()) {
                return $('#myListEmail input[name="subject"]').val();
            } else {
                return $('#myListEmail input[name="subject"]').attr('placeholder');
            }
        }

        // Add items in My List to the email
        function getItems(){
            var items = '';
                $('#myListEmail .row').each(function(){
                if($(this).find('.requestInputs input[name="Request"]').is(":checked")) {
                    var item = 
                    '<p><strong>' + $(this).children('.title').children('p').html() + '</strong><br />' +
                    $(this).children('.collectionTitle').children('p').text() + '<br/>' +
                    $(this).children('.containers').text() + '<br/>' +
                    $(this).find('.requestInputs input[name*="ItemSubtitle"]').attr('value')  + '</p>'

                    console.log(item)
                    
                    items = items + item;

                    }
                });
            return items;
        }

        var address = $('#myListEmail input[name="email"]').val();
        var subject = checkSubject();
        var text = $('#myListEmail textarea[name="message"]').val();
        var items = getItems();
        var message = text + '\r\n' + items;

            // Submit the form using AJAX.
            $.ajax({
                type: $('#myListMail').attr('method'),
                url: $('#myListMail').attr('action'),
                data: {
                    email: address,
                    subject: subject,
                    message: message
                }
            })
            .done(function(response) {
                // Clear the form.
                $('input[name="email"]').val('');
                $('input[name="subject"]').val('');
                $('textarea[name="message"]').val('');
                $('#myListEmailConfirm .confirm h2').empty().append('Your list has been emailed to '+ address +'!')
                return true;
            })
            .fail(function(data) {
                // Fail message
                return false;
            });

            return true;
        };

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
            { text: "Send Email", click: function() {
                if (validate()) {
                    if(sendEmail()) {
                        $(this).dialog("close");
                        $('#myListEmail input[name="email"]').removeClass('error');
                        $('#myListEmail #emailError').hide();
                        dialogMyListEmailConfirm.dialog("open");
                    } else {
                        $(this).dialog("close");
                        $('#myListEmail input[name="email"]').removeClass('error');
                        $('#myListEmail #emailError').hide();
                        dialogMyListEmailError.dialog("open");
                    }
                }
            } 
            },
            { text: "Cancel", click: function() { $( this ).dialog( "close" ); } }
            ],
        width: windowWidth/1.2,
        close: function () {
            $('.ui-dialog').hide();
        }
    });

    var dialogMyListEmailConfirm = $('#myListEmailConfirm').dialog({
        create: function(event, ui) {
            var widget = $(this).dialog("widget");
            $(".ui-dialog-titlebar-close span", widget).removeClass("ui-icon-closethick").addClass("ui-icon-myCloseButton");
            $(".ui-dialog-content").addClass("myList");
            },
        autoOpen: false,
        modal: true,
        resizable: true,
        buttons: [ 
            { text: "Close", click: function() { $( this ).dialog( "close" ); } }
            ],
        width: windowWidth/2,
        close: function () {
            $('.ui-dialog').hide();
        }
    });    

    var dialogMyListEmailError = $('#myListEmailError').dialog({
        create: function(event, ui) {
            var widget = $(this).dialog("widget");
            $(".ui-dialog-titlebar-close span", widget).removeClass("ui-icon-closethick").addClass("ui-icon-myCloseButton");
            $(".ui-dialog-content").addClass("myList");
            },
        autoOpen: false,
        modal: true,
        resizable: true,
        buttons: [ 
            { text: "Close", click: function() { $( this ).dialog( "close" ); } }
            ],
        width: windowWidth/2,
        close: function () {
            $('.ui-dialog').hide();
        }
    }); 

    $(".myListEmail").on("click", function (e) {
        e.preventDefault();
        $('.myListContents.dialog').css('max-height', windowHeight-(windowHeight/2.2));
        dialogMyListEmail.dialog("option", "title", "Email My List").dialog("open");
        });
    });
$(function () {
    var dialogMyListPrint = $('#myListPrint').dialog({
        create: function(event, ui) {
            var widget = $(this).dialog("widget");
            $(".ui-dialog-titlebar-close span", widget).removeClass("ui-icon-closethick").addClass("ui-icon-myCloseButton");
            $(".ui-dialog-content").addClass("myList");
            },
        autoOpen: false,
        modal: true,
        resizable: true,
        buttons: [ 
            { text: "Print", click: function() {
                if(content()) {
                    window.print();
                    $(this).dialog("close");
                    $('#myListPrint .contentError').hide();
                } else {
                    $('#myListPrint .contentError').show();
                    return false;
                }
            }
            },
            { text: "Cancel", click: function() { $( this ).dialog( "close" ); } }
            ],
        width: windowWidth/1.2,
        close: function () {
            $('.ui-dialog').hide();
        }
    });

    $(".myListPrint").on("click", function (e) {
        e.preventDefault();
        $('.myListContents.dialog').css('max-height', windowHeight-(windowHeight/3));
        dialogMyListPrint.dialog("option", "title", "Print My List").dialog("open");
        });
    });
$(function () {
    var listCount = $('#requestForm .row > .requestInputs > input[checked="checked"]').length - 1;
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
            { html: 'Request <span class="listCount">'+listCount+'</span> item(s)', click: function() {
                console.log('request materials');
                if(content()) { 
                    if($('#VisitScheduled').is(':checked')) {
                        if($('#myListRequest input[name="ScheduledDate"]').val()) {
                            $('input[name="UserReview"]').val("No");
                            $.ajax({
                                type: 'POST',
                                url: '/xtf/script/rac/myListLog.php',
                            data: {
                                email: 'harnold@rockarch.org',
                                subject: 'myList Request',
                                message: $('#requestForm').serialize()
                                }
                            });
                            $('#requestForm').submit();
                            $(this).dialog("close")
                            $('#myListRequest input[name="ScheduledDate"]').removeClass('error');
                            $('#myListRequest #dateError').hide();
                            dialogMyListRequestConfirm.dialog("open");
                        } else {
                            $('#myListRequest input[name="ScheduledDate"]').addClass('error');
                            $('#myListRequest #dateError').show();
                            return false;
                        }
                    } else if ($('#VisitReview').is(':checked')) {
                        $('input[name="UserReview"]').val("Yes");
                        $('#requestForm').submit();
                        $(this).dialog("close")
                        $('#myListRequest input[name="ScheduledDate"]').removeClass('error');
                        $('#myListRequest #dateError').hide();
                        dialogMyListRequestConfirm.dialog("open");
                    }
                } else {
                    $('#myListRequest .contentError').show();
                }
            } 
            },
            { text: "Cancel", click: function() { $( this ).dialog( "close" ); } }
            ],
        width: windowWidth/1.2,
        close: function () {
            $('.ui-dialog').hide();
        }
    });

    var dialogMyListRequestConfirm = $('#myListRequestConfirm').dialog({
        create: function(event, ui) {
            var widget = $(this).dialog("widget");
            $(".ui-dialog-titlebar-close span", widget).removeClass("ui-icon-closethick").addClass("ui-icon-myCloseButton");
            $(".ui-dialog-content").addClass("myList");
            },
        autoOpen: false,
        modal: true,
        resizable: true,
        buttons: [ 
            { text: "Close", click: function() { $( this ).dialog( "close" ); } }
            ],
        width: windowWidth/2,
        close: function () {
            $('.ui-dialog').hide();
        }
    });

    $(".myListRequest").on("click", function (e) {
        e.preventDefault();
        $('.myListContents.dialog').css('max-height', windowHeight-(windowHeight/2.2));
        dialogMyListRequest.dialog("option", "title", "Request in Reading Room").dialog("open");
        });
    });
$(function () {
    function validate(){
        if ($('#myListCopies select[name="Format"]').val()) {
            $('#myListCopies select[name="Format"]').removeClass('error');
            $('#myListCopies #formatError').hide();
            if($('#myListCopies input[name="ItemPages"]').val()) {
                return true;
            } else {
                $('#myListCopies input[name="ItemPages"]').addClass('error');
                $('#myListCopies #itemPagesError').show();
                return false;
            }
        } else {
            $('#myListCopies select[name="Format"]').addClass('error');
            $('#myListCopies #formatError').show();
            if($('#myListCopies input[name="ItemPages"]').val()) {
                $('#myListCopies input[name="ItemPages"]').removeClass('error');
                $('#myListCopies #itemPagesError').hide();
                return false;
            } else {
                $('#myListCopies input[name="ItemPages"]').addClass('error');
                $('#myListCopies #itemPagesError').show();
                return false;
            }
        }
        return true;
    }

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
            { text: "Request Copies", click: function() {
                console.log('request copies'); 
                if(content()) {
                    if(validate()){
                        $('#duplicationForm').submit();
                        $('#myListCopies input[name="ItemPages"]').removeClass('error');
                        $('#myListCopies #itemPagesError').hide();
                        $('#myListCopies select[name="Format"]').removeClass('error');
                        $('#myListCopies #formatError').hide();
                        $(this).dialog("close");
                        dialogMyListCopiesConfirm.dialog("open");
                    }
                } else {
                    $('#myListCopies .contentError').show();
                    return false;
                }
            }
            },
            { text: "Cancel", click: function() { $( this ).dialog( "close" ); } }
            ],
        width: windowWidth/1.2,
        close: function () {
            $('.ui-dialog').hide();
        }
    });

    var dialogMyListCopiesConfirm = $('#myListCopiesConfirm').dialog({
        create: function(event, ui) {
            var widget = $(this).dialog("widget");
            $(".ui-dialog-titlebar-close span", widget).removeClass("ui-icon-closethick").addClass("ui-icon-myCloseButton");
            $(".ui-dialog-content").addClass("myList");
            },
        autoOpen: false,
        modal: true,
        resizable: true,
        buttons: [ 
            { text: "Close", click: function() { $( this ).dialog( "close" ); } }
            ],
        width: windowWidth/2,
        close: function () {
            $('.ui-dialog').hide();
        }
    });

    $(".myListCopies").on("click", function (e) {
        e.preventDefault();
        $('.myListContents.dialog').css('max-height', windowHeight-(windowHeight/1.7));
        dialogMyListCopies.dialog("option", "title", "Request Copies").dialog("open");
        $(".ui-dialog-buttonpane button:contains('Request Copies')").button("disable");
        $("input#costagree").attr('checked', false);
        });
        
    $("input#costagree").on("click", function() {
        if($("input#costagree").is(':checked')) {
            $(".ui-dialog-buttonpane button:contains('Request Copies')").button("enable");
        } else {
            $(".ui-dialog-buttonpane button:contains('Request Copies')").button("disable");
        }
    });   
        
    });
    
});