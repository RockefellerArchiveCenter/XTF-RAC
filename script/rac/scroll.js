          $(document).ready(function(){
          //var hrefList = []
            //$('.tocRow a').each(function(){
            //hrefList.push($(this).attr('href'));
            //});
                                                                                // Add div so we can load content into it
                                    
                        
            $('#content-wrapper').bind('scroll', function()
                              {
                                var load = true;                       
                                var currentComponent = '#' + $('.active').attr('id');
                                var currentComponentID = '#' + $('.active').attr('id').replace('Menu', '');
                                var currentComponentURL = $('.active a').attr('href');
                                if($('.active').nextAll('.tocRow').length) {
                                var nextComponent = '#' + $('.active').nextAll('.tocRow', '.more').first().attr('id');
                                var nextComponentID = $('.active').nextAll('.tocRow', '.more').first().attr('id').replace('Menu', '');
                                var nextComponentURL = currentComponentURL.replace((/ref[0-9]*/), nextComponentID).replace((/dscref[0-9]*/), 'dsc' + nextComponentID);

                                }
                                else
                                { var load = false;}

                                //var previousComponent = function() {if ($('.active').prev('.tocRow')) $(this).attr('id').replace('Menu', '');}
                                if (load == true) {
                                if($(this).scrollTop() + $(this).innerHeight()>= $(this)[0].scrollHeight - 100)
                                {   
                                
                                    var load = false;
                                    
                                    $('#content-wrapper').append($( "<div>Loading</div>" ).attr('id',nextComponentID));

                                    // load next component into div
                                    $('#' + nextComponentID).load(nextComponentURL + '#content-wrapper .c01',function(){ 
                                    // once the content has loaded, append to document
                                    $('#content-wrapper').append(this);
                                    // change active class for next component
                                    $(currentComponent).removeClass('active');
                                    $(nextComponent).addClass('active');
                                    
                                    });
                                }
                                }
                             });

        });