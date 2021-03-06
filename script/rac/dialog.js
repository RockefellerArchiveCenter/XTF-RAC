$(document).ready(function() {
var windowWidth = $(window).width();
var windowHeight = $(window).height();

$('#myListEmail #emailError').hide();
$('#myListRequest #dateError').hide();
$('#myListCopies #formatError').hide();
$('#myListCopies #itemPagesError').hide();
$('.contentError').hide();

$('#copyLink .success').hide();

function content() {
    if($('.myListContents .empty').length) {
        return false;
    } else {
        return true;
    }
}

// Select contents of link copy text input on load
$('#copyLink input[type="text"]').focus().select();

$('#copyLink button').on('click', function(e) {
    e.preventDefault();
    $('#copyLink .success').fadeIn();
});

$(function () {
    var copyLink = $('#copyLink').dialog({
        create: function(event, ui) {
            var widget = $(this).dialog("widget");
            $(".ui-dialog-titlebar-close span", widget).removeClass("ui-icon-closethick").addClass("ui-icon-myCloseButton");
            },
        autoOpen: false,
        modal: true,
        resizable: true,
        width: '57em',
        height: '100',
        close: function () {
            $('.ui-dialog').hide();
        }
    });

    $("#bookmarkMenu .link").on("click", function (e) {
        e.preventDefault();
        copyLink.dialog("open");
    });
});

$(function () {
    var dialogView = $('#daoView').dialog({
        create: function(event, ui) {
            var widget = $(this).dialog("widget");
            $(".ui-dialog-titlebar-close span", widget).removeClass("ui-icon-closethick").addClass("ui-icon-myCloseButton");
            },
        autoOpen: false,
        modal: true,
        resizable: true,
        width: windowWidth/1.2,
        height: windowHeight/1.1,
        close: function () {
            $('.ui-dialog').hide();
        }
    });

    $(".digital-thumbnail .view").on("click", function (e) {
        e.preventDefault();
        dialogView.dialog("open");
    });
});

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
            width: function () {
              if(windowWidth > 768){
                return windowWidth/3
              } else {
                return windowWidth/1.5
              }
            },
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
                    var title;
                    if ($(this).children('.date').text().trim().length) {
                        title = $(this).children('.title').children('p').html() + ', ' + $(this).children('.date').html();
                    } else {
                        title = $(this).children('.title').children('p').html();
                    }
                    var item =
                    '<p><strong>' + title + '</strong><br />' +
                    $(this).children('.collectionTitle').children('p').text() + '<br/>' +
                    $(this).children('.containers').text() + '<br/>' +
                    $(this).find('.requestInputs input[name*="ItemSubtitle"]').attr('value')  + '</p>'

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
        var recaptcha = $('#g-recaptcha-response').val();

            // Submit the form using AJAX.
            $.ajax({
                type: $('#myListMail').attr('method'),
                url: $('#myListMail').attr('action'),
                data: {
                    "email": address,
                    "subject": subject,
                    "message": message,
                    "g-recaptcha-response": recaptcha
                }
            })
            .done(function(response) {
                console.log(response)
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
    var listCount = $('#requestForm .row:not(.header-row) > .requestInputs > input[type=checkbox]:checked').length;
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
                    if($('#myListRequest input[name="ScheduledDate"]').val()) {
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
    var listCount = $('#requestForm .row:not(.header-row) > .requestInputs > input[type=checkbox]:checked').length;
    var dialogMyListRequest = $('#myListSave').dialog({
        create: function(event, ui) {
            var widget = $(this).dialog("widget");
            $(".ui-dialog-titlebar-close span", widget).removeClass("ui-icon-closethick").addClass("ui-icon-myCloseButton");
            $(".ui-dialog-content").addClass("myList");
            },
        autoOpen: false,
        modal: true,
        resizable: true,
        buttons: [
            { html: 'Save <span class="listCount">'+listCount+'</span> item(s)', click: function() {
                console.log('request materials');
                if(content()) {
                    $('#saveForm').submit();
                    $(this).dialog("close")
                    $('#myListRequest input[name="ScheduledDate"]').removeClass('error');
                    $('#myListRequest #dateError').hide();
                    dialogMyListRequestConfirm.dialog("open");
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

    var dialogMyListRequestConfirm = $('#myListSaveConfirm').dialog({
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

    $(".myListSave").on("click", function (e) {
        e.preventDefault();
        $('.myListContents.dialog').css('max-height', windowHeight-(windowHeight/2.2));
        dialogMyListRequest.dialog("option", "title", "Save in RACcess").dialog("open");
        });
    });


$(function () {
    function validate(){
        if ($('#myListCopies select[name="Format"]').val()) {
            $('#myListCopies select[name="Format"]').removeClass('error');
            $('#myListCopies #formatError').hide();
            if($('#myListCopies input[name="ItemInfo4"]').val()) {
                return true;
            } else {
                $('#myListCopies input[name="ItemInfo4"]').addClass('error');
                $('#myListCopies #itemPagesError').show();
                return false;
            }
        } else {
            $('#myListCopies select[name="Format"]').addClass('error');
            $('#myListCopies #formatError').show();
            if($('#myListCopies input[name="ItemInfo4"]').val()) {
                $('#myListCopies input[name="ItemInfo4"]').removeClass('error');
                $('#myListCopies #itemPagesError').hide();
                return false;
            } else {
                $('#myListCopies input[name="ItemInfo4"]').addClass('error');
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
                        $('#myListCopies input[name="ItemInfo4"]').removeClass('error');
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
