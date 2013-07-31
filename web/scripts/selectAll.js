/* 
 * Allows the selection of all checkboxes
 * @author David Gibbins
 * @author Daryl Fritz
 */

function checkAll(){
        var formNumber = 0;
	for (var i = 0; i < document.forms[formNumber].elements.length; i++)
	{
		var e = document.forms[formNumber].elements[i];
		if ((e.name != 'allbox') && (e.type == 'checkbox'))
		{
			e.checked = document.forms[formNumber].allbox.checked;
		}
	}
}



