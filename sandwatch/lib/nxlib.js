//-----------------------------------------------
function isArray(o){
	return Object.prototype.toString.call(o) === "[object Array]"; 
}

//-----------------------------------------------
function checkboxIsChecked(checkbox){
	if(!isArray(checkbox)){
		if(checkbox.checked){
			return true;
		}
		else{
			return false;
		}
	}

	for(var i = 0; i < checkbox.length; i++){
		if(checkbox[i].checked){
			return true;
		}
	}
	return false;
}

//-----------------------------------------------
function checkboxCheckAll(checkbox){
	if(!isArray(checkbox)){
		checkbox.checked = true;
	}

	for(var i = 0; i < checkbox.length; i++){
		checkbox[i].checked = true;
	}
}

//-----------------------------------------------
function checkboxUncheckAll(checkbox){
	if(!isArray(checkbox)){
		checkbox.checked = false;
	}

	for(var i = 0; i < checkbox.length; i++){
		checkbox[i].checked = false;
	}
}

//-----------------------------------------------
function checkboxToggleAll(checkbox){
	if(checkboxIsChecked(checkbox)){
		checkboxUncheckAll(checkbox);
		return;
	}
	checkboxCheckAll(checkbox);
}

//-----------------------------------------------
function radioIsChecked(radio){
	for(var i = 0; i < radio.length; i++){
		if(radio[i].checked){
			return true;
		}
	}
	return false;
}

//-----------------------------------------------
function radioGetValue(radio){
	for(var i = 0; i < radio.length; i++){
		if(radio[i].checked){
			return radio[i].value;
		}
	}
}

//-----------------------------------------------
function radioUncheckAll(radio){
	for(var i = 0; i < radio.length; i++){
		radio[i].checked = false;
	}
}

//-----------------------------------------------
function checkboxToggleAll2(source, tgtName){
	arr = document.getElementsByName(tgtName);
	for(var i = 0; i < arr.length; i++){
		arr[i].checked = source.checked;
	}
}

//-----------------------------------------------
function checkboxToggleAll3(tgtName){
	checkbox = document.getElementsByName(tgtName);
	if(checkboxIsChecked(checkbox)){
		checkboxUncheckAll(checkbox);
		return;
	}
	checkboxCheckAll(checkbox);
}

//-----------------------------------------------
function windowOpen(url){
	window.open(url);
}

//-----------------------------------------------
function enterSubmit(e, form){
	var key = e.keyCode || e.which;
	if(key == 13){
		form.submit();
	}
}
