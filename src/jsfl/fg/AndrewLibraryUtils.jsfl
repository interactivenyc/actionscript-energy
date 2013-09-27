itemList = fl.getDocumentDOM().library.items;
itemNameArray = new Array();
itemArray = new Array();

log("Running");

function createItemArrays(){
	var item;
	var itemString;
	var addArray = new Array();
	
	for (var i = 0; i < itemList.length; i++) {
		item = itemList[i];
		itemNameArray.push(item.name);
		itemArray.push(item);
		
	}

}



function printAllLibraryItems() {
	//Trace every item in order
	for (var i=0; i<itemNameArray.length; i++) {
		log(itemNameArray[i]);
	}
}

function checkForDuplicateSymbolNames(){
	var duplicateNames = new Array();
	var nonDuplicateNames = new Array();
	
	itemNameArray.sort();
	
	var currentItemName = "";
	
	for (i=0;i<itemNameArray.length;i++){
		itemNameArray[i] = sanitizeString(itemNameArray[i]);
		
		//make sure to check without case sensitivity
		if (currentItemName.toLowerCase() == itemNameArray[i].toLowerCase()){
			log("duplicate name: "+currentItemName);
			duplicateNames.push(itemNameArray[i]);
		}else{
			nonDuplicateNames.push(itemNameArray[i]);
		}
		currentItemName = itemNameArray[i]
		
		log(currentItemName);
	}
	
	log("itemNameArray.length:"+itemNameArray.length);
	log("duplicateNames.length:"+duplicateNames.length);
	log("nonDuplicateNames.length:"+nonDuplicateNames.length);
	
}

function fixDuplicateSymbolNames(){
	//did this by hand, as there were only 6
}

function sanitizeItemNames(){
	var originalName;
	var newName;
	var splitArray;
	for (var i = 0; i < itemList.length; i++) {
		item = itemList[i];
		splitArray = item.name.split("/");
		originalName = splitArray[splitArray.length - 1];
		newName = originalName;
		newName = sanitizeString(newName);
		
		item.name = newName;
		
		if (originalName.length != newName.length) {
			log("sanitize: " + originalName + " = " + newName);
		}
		
	}
}

function sanitizeString(inString){
	var legalChars = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","1","2","3","4","5","6","7","8","9","0"," ",".","-","_"];
	
	var checkChar;
	var returnString = "";
	for (var i=0;i<inString.length;i++){
		checkChar = inString.charAt(i);
		if (arrayContainsValue(legalChars, checkChar)) {
			returnString = returnString + checkChar;
		}
	}
	
	
	
	return returnString;
	
}

function arrayContainsValue(arr, value){
	return (arr.indexOf(value) != -1);
}

function log(msg){
	fl.trace(msg);
}


createItemArrays();

checkForDuplicateSymbolNames();


