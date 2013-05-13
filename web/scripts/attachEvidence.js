var attachEvidence = function() {
	var getFile = function() {

	};
	var addOnClick = function() {
		$('#view').click(function() {
			window.open('http://localhost:8080/RPL2013/');
		});
	};
	return {
		view : getFile,
		register : addOnClick
	};
}();

attachEvidence.register();