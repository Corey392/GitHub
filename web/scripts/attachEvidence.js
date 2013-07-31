/**
 * Handles the "View File" button on the "Attach Evidence" page.
 * Usage: Run the 'register' method on page load and it will do the rest on its own.
 * Author: Todd Wiggins - http://www.toddwiggins.com.au/
 */
var attachEvidence = function() {
	var addOnClick = function() {
		$('#view').click(function() {
			if ($("input:radio[name='selected']:checked").val() !== undefined) {
				window.open('getFile?id='+$("input:radio[name='selected']:checked").val());
			} else {
				alert("Please select a file with the Radio Buttons.");
			}
		});
	};
	return {
		register : addOnClick
	};
}();
attachEvidence.register();