itemList = fl.getDocumentDOM().library.items;
itemNameArray = new Array();
itemArray = new Array();
libItemStatus = {};

fl.trace("Running");

createItemArrays = function(){
	var item;
	var itemString;
	var addArray = new Array();
	
	for (var i=0; i<itemList.length; i++) {
		item = itemList[i];
		itemString = item.name+":\t"+item.itemType;
		itemNameArray.push(itemString);
		
		//sort by item type
		itemArray.push([itemList[i], itemList[i]]);
		
		//sort by item name
		//itemArray.push([itemString, itemList[i]]);
	}
	
	itemNameArray.sort();
	itemArray.sort();
}

function searchForItemEverywhere(theItem){
	
	fl.trace("-------------------------------------------------------");
	fl.trace("-----------------[Main Timeline]----------------");
	fl.trace("-------------------------------------------------------");
	searchTimeline(fl.getDocumentDOM().getTimeline(), theItem);
	fl.trace("-------------------------------------------------------");
	fl.trace("-----------------[/Main Timeline]----------------");
	fl.trace("-------------------------------------------------------");
	
	for (var x=0; x<itemArray.length; x++) {
	//for (var x=0; x<25; x++) { // testing a shorter loop
		
		//fl.trace("----------------------------");
		//fl.trace("["+itemArray[x][1].itemType + "]\t" + itemArray[x][1].name);
			
			
		if(itemArray[x][1].itemType == "movie clip"){
			//fl.trace("\t[Layers] in item:" + itemArray[x][1].name);
			searchTimeline(itemArray[x][1].timeline, theItem);
		}
	}
}


function searchTimeline(theTimeline, theItem){
	var n = theTimeline.layers.length;
	for (var i = 0; i < n; i++) {
		//fl.trace("\t layer:" + theTimeline.layers[i].name);
		//fl.trace("\t\t" + theTimeline.layers[i].name + "\tFrames:"+theTimeline.layers[i].frames[0].length);
		
		var currentFrame = null;
		var nextFrame;
		var curFrameObj, curElementObj;
		var nn = theTimeline.layers[i].frames.length;
		
		for (var ii = 0; ii < nn; ii++) {
			curFrameObj = theTimeline.layers[i].frames[ii];
			nextFrame = curFrameObj.startFrame;
			
			if (nextFrame != currentFrame) {
				currentFrame = nextFrame;
				
				var nnn = curFrameObj.elements.length;
				for (var iii = 0; iii < nnn; iii++) {
					curElementObj = curFrameObj.elements[iii];
					if (curElementObj.elementType =="instance"  && curElementObj.libraryItem.name == theItem.name) {
						fl.trace("-----------");
						fl.trace("\t\t owner:" + theTimeline.name);
						fl.trace("\t\t currentFrame:" + currentFrame);
					}
					
					
				}
			}
		}
	}
}



function printSelectedItems(){
	fl.trace("printSelectedItem");
	var items = fl.getDocumentDOM().library.getSelectedItems();
	var theItem;
	var theProp;
	for (var i in items){
		theItem = items[i];
		fl.trace("theItem.name:"+theItem.name);
		//printItemProps(theItem);
		searchForItemEverywhere(theItem);
	}
}

function printItemProps(theItem){
	for (var i in theItem){
			theProp = theItem[i];
			fl.trace("\t theProp: "+i+" : "+theItem[i]);
		}
}


createItemArrays();
//printAllTimelines()

printSelectedItems()
