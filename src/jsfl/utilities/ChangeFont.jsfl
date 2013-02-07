itemList = fl.getDocumentDOM().library.items;
itemNameArray = new Array();
itemArray = new Array();
libItemStatus = {};

fl.trace("Running");

function createItemArrays(){
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




function processAllTimelines(){
	var item;
	
	processTimeline(fl.getDocumentDOM().getTimeline());
	
	for (var x=0; x<itemArray.length; x++) {
		item = itemArray[x][1];
			
		if (itemArray[x][1].itemType == "movie clip"){
			processTimeline(itemArray[x][1].timeline);
		}
	}
}



function processTimeline(theTimeline){
	var n = theTimeline.layers.length;
	
	var oldString = "Burbank Small Bold*";
	var newString = "Dr Soos Bold*";
	
	for (var i=0; i<n; i++) {
		
		var currentFrame=null;
		var nextFrame;
		var curFrameObj, curElementObj;
		var nn = theTimeline.layers[i].frames.length;
		
		for(var ii=0; ii<nn; ii++){
			curFrameObj = theTimeline.layers[i].frames[ii];
			nextFrame = curFrameObj.startFrame;
			
			if (nextFrame != currentFrame) {
				currentFrame = nextFrame;
				
				var nnn = curFrameObj.elements.length;
				for(var iii=0; iii<nnn; iii++){
					curElementObj = curFrameObj.elements[iii];
					
					if(curElementObj.libraryItem == undefined){
						//NON LIBRARY ITEMS
						//log("NON LIBRARY ITEM curElementObj.elementType:"+curElementObj.elementType);
						if (curElementObj.elementType == "text") {
							if (String(curElementObj.getTextAttr("face")).indexOf(oldString) > -1) {
								log("\n-----<change font>-----\n");
								log("[face]:" + curElementObj.getTextAttr("face") + "\n");
								curElementObj.setTextAttr("face", newString);
								log("[face]:" + curElementObj.getTextAttr("face") + "\n");
							}
						}
					}
				}
			}
		}
	}
}

function log(msg){
	fl.trace(msg);
}


createItemArrays();
processAllTimelines();

