itemList = fl.getDocumentDOM().library.items;
selectedItems = fl.getDocumentDOM().library.getSelectedItems();
selectedItem = "";
itemNameArray = new Array();
itemArray = new Array();

findLibraryItemOnStage = function(){
	fl.trace("findLibraryItemOnStage");
	
	if(selectedItems.length == 1){
		selectedItem = selectedItems[0].name;
		fl.trace("selected item:"+ selectedItem);
		
		createItemArrays();
		printAllTimelines();
		
	}else{
		fl.trace("please select exactly one library item to search for");
	}
}

createItemArrays = function(){
	var item;
	var itemString;
	var addArray = new Array();
	
	for (var i=0; i<itemList.length; i++) {
		item = itemList[i];
		itemString = item.name+":\t"+item.itemType;
		itemNameArray.push(itemString);
		
		//sort by item type
		//itemArray.push([itemList[i], itemList[i]]);
		
		//sort by item name
		itemArray.push([itemString, itemList[i]]);
	}
	
	itemNameArray.sort();
	itemArray.sort();
}



printAllTimelines = function(){
	var item;
	
	fl.trace("-----------------[Main Timeline]----------------");
	printLayersInTimeline(fl.getDocumentDOM().getTimeline(), "Main Timeline");
	fl.trace("-----------------[/Main Timeline]----------------");
	
	//for (var x=0; x<itemArray.length; x++) {
	for (var x=0; x<25; x++) { // testing a shorter loop
		item = itemArray[x][1];
		
		//fl.trace("\n----------------------------");
		var MCName = "\n["+itemArray[x][1].itemType + "]\t" + itemArray[x][1].name;
			
			
		if(itemArray[x][1].itemType == "movie clip"){
			//fl.trace("\t[Layers] in item:" + itemArray[x][1].name);
			printLayersInTimeline(itemArray[x][1].timeline, MCName);
		}
	}
}



printLayersInTimeline = function(theTimeline, MCName){

	for (var i=0; i<theTimeline.layers.length; i++) {
		//fl.trace("\tlayer:"+theTimeline.layers[i].name);
		//fl.trace("\t\t" + theTimeline.layers[i].name + "\tFrames:"+theTimeline.layers[i].frames[0].length);
		
		var currentFrame=null;
		var nextFrame;
		var outputText;
		var outputBoolean;
		var curFrameObj, curElementObj;

		
		for(var ii=0; ii<theTimeline.layers[i].frames.length; ii++){
			outputText = "";
			outputBoolean = false;
			curFrameObj = theTimeline.layers[i].frames[ii];
			nextFrame = curFrameObj.startFrame;
			
			if (nextFrame != currentFrame) {
				outputText = "\t\tKeyFrame:" + curFrameObj.startFrame + " layer:" + theTimeline.layers[i].name  + "\n";
				currentFrame = nextFrame;
		

				for(var iii=0; iii<curFrameObj.elements.length; iii++){
					curElementObj = curFrameObj.elements[iii];
					if(curElementObj.libraryItem != undefined && curElementObj.libraryItem.name == selectedItem){
						outputBoolean = true;
						fl.trace("\n----------------------------");
						fl.trace("\n"+MCName);
						outputText += "\t\t\t[" + curElementObj.libraryItem.itemType + "]: "+curElementObj.libraryItem.name + "\n";
					}
					
					if(outputBoolean){
						fl.trace(outputText);
					}
				}
			}
		}
	}
}



findLibraryItemOnStage();








