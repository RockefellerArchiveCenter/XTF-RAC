                $(document).ready(function () {
                    $('#collections').hide();
                    $('#library').hide();
                    $('#dao').hide();
                    $('#type').change(function () {
                        if ($('#type option:selected').text().trim() == 'Archival Collections'){
                            $('#collections').show();
                            $('#dao').hide();
                            $('#library').hide();
                            $('input[type="text"].searchbox').attr('name','text');
                                }
                        else if ($('#type option:selected').text().trim() == "Library Materials"){
                            $('#library').show();
                            $('#dao').hide();
                            $('#collections').hide();
                            $('input[type="text"].searchbox').attr('name','text');
                                }
                        else if ($('#type option:selected').text().trim() == "Digital Materials"){
                            $('#dao').show();
                            $('#collections').hide();
                            $('#library').hide();
                            $('input[type="text"].searchbox').attr('name','text');
                                }
                        else {
                            $('#dao').hide();
                            $('#collections').hide();
                            $('#library').hide();
                            $('input[type="text"].searchbox').attr('name','keyword');
                                 }
                            });
                    $('.showAdvanced').click(function (event) {
                        event.preventDefault();
                        $('#advancedSearch').slideToggle(400, 'linear');
                    });
                    
                    if ($(window).width() > 480) {
                    $('input.searchbox').focus(function () {
                        $('#searchtipDate').hide();
                        $('#searchtip').fadeIn('slow');
                    });
                    $('input.searchbox').blur(function () {
                        $('#searchtip').fadeOut('slow');
                    });
                    $('input.date').focus(function () {
                        $('#searchtip').hide();
                        $('#searchtipDate').fadeIn('slow');
                    });
                    $('input.date').blur(function () {
                        $('#searchtipDate').fadeOut('slow');
                    });
                    }   
                });