                (function ($) {
                    
                    $.randomImage = {
                        defaults: {
                            
                            path: '/xtf/icons/default/featured/',
                            
                            myImages:[ 'dimes.jpg', 'RAC-logo.png', 'xtfMan.gif'],
                            myCaptions:[ 'John D. Rockefeller distributing dimes', 'Our awesome logo', 'The XTF man']
                        }
                    }
                    
                    $.fn.extend({
                        randomImage: function (config) {
                            
                            var config = $.extend({
                            },
                            $.randomImage.defaults, config);
                            
                            return this.each(function () {
                                
                                var imageNames = config.myImages;
                                
                                var imageCaptions = config.myCaptions;
                                
                                var imageNamesSize = imageNames.length;
                                
                                var randomNumber = Math.floor(Math.random() * imageNamesSize);
                                
                                var displayImage = imageNames[randomNumber];
                                
                                var displayCaption = imageCaptions[randomNumber];
                                
                                var fullPath = config.path + displayImage;
                                
                                $(this).attr({
                                    src: fullPath, alt: displayImage
                                });
                                $("#caption").html(displayCaption);
                            });
                        }
                    });
                })(jQuery);