
function disableEditing(args){
    var inputs = document.getElementsByTagName('input');
    var disable = true;
    for(var i = 0; i < inputs.length; i++) {
        for(var j = 0; j < args.length; j++) {
            if (args[j] === inputs[i].id) {
                disable = false;
            }
        }
        if (disable) {
            inputs[i].setAttribute('disabled', 'true');
        }
        disable = true;
    }
}

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
