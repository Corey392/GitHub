/**
 * Handles the "Get Guide File" link on the "Add Evidence" page.
 * Usage: javascript:addEvidence.getGuide(courseID);
 * Author: Todd Wiggins - http://www.toddwiggins.com.au/
 */
var addEvidence = function() {
	var getGuide = function(courseID) {
		window.open('getFile?courseID='+courseID);
	};
	return {
		getGuide : getGuide
	};
}();