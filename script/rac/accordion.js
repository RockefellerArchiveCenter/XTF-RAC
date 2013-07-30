            $(document).ready(function() {
                //$('.accordionButton').addClass($.cookie('on'));
             	$('.accordionButton').click(function() {
         		$('.accordionButton').removeClass('on');
		    	 	$('.accordionContent').slideUp('normal');

               if($(this).next().is(':hidden') == true) {
		          	$(this).addClass('on');
		          	$(this).next().slideDown('normal');
	             	 }
	             	 //$.cookie('on', 'on');
            	 });
            	 
            	$('.accordionButton').mouseover(function() {
         		$(this).addClass('over');
            	})
            	.mouseout(function() {
         	     	$(this).removeClass('over');										
            	});
            	$('.accordionContent').click(function(){
            	$('.accordionButton').removeClass('on');
            	});
                $('.accordionContent').hide();
               });