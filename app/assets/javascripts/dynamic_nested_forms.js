(function($){
  var createNewId, elCounter;
  elCounter = 0;
  
  createNewId = function() {
    return new Date().getTime() + elCounter++;
  };
	
  $(document).on('click', '.remove-item', function(e) {
		e.preventDefault();
    $(this).prev('input[type=hidden]').val('1');
    $(this).closest('.nested-item').hide();
  });
	
  $(function() {
	  $('.autocomplete').each(function() {
			var $this 			= $(this),
			nestedContainer = $this.parents('.nested-container');
      
			$this.autocomplete({
				source: function(request, response) {
					var addedObj = [];
          
          // Insert added objects to array
					nestedContainer.find('.nested-item:visible .nested-value').each(function () {
						addedObj.push($(this).val());
					});
					
					$.ajax({
						url: $this.data('source'),
						dataType: 'json',
						data: {
							term: request.term,
							added_obj: addedObj
						},
						success: function(data) {
							response(data);
						}
					});
				},
		    minLength: parseInt($(this).data('min-length')) || 1,
		    focus: function(e, ui) {
					e.preventDefault();
		      $this.val(ui.item.label);
		    },
		    select: function(e, ui) {
		      var keepAfterSelect 	= (String($this.data('keep-after-select')).toLowerCase() == 'true'),
							newId 						= createNewId(),
							idRegexp 					= new RegExp($this.data('id'), 'g'),
							content						= $.parseHTML( $this.data('item').replace(idRegexp, newId) );

					e.preventDefault();
					
		     	if (!keepAfterSelect) {
						$this.val('');
					};
					
					$('.nested-content', content).text(ui.item.content);
					$('.nested-value', content).val(ui.item.value);
		      $('.nested-items').prepend(content);
		    }
		  });
		});
	});
})(jQuery);