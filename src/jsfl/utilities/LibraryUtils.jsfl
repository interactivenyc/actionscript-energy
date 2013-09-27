itemList = fl.getDocumentDOM().library.items;
itemNameArray = new Array();
itemArray = new Array();
skinnableIndex = 0;
log("Running");

createItemArrays = function(){
	
	//PROCESSES ALL ITEMS IN THE LIBRARY
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




processAllTimelines = function(){
	var item;
	
	//PRINT THE MAIN TIMELINE
	findElementsInTimeline(fl.getDocumentDOM().getTimeline());
	
	//PRINT ALL TIMELINES OF MOVIECLIPS IN THE LIBRARY
	for (var x=0; x<itemArray.length; x++) {
		item = itemArray[x][1];
			
		if(itemArray[x][1].itemType == "movie clip"){
			findElementsInTimeline(itemArray[x][1].timeline);
		}
	}
}



findElementsInTimeline = function(theTimeline){
	var n = theTimeline.layers.length;
	
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
				
				if(curFrameObj.actionScript.length > 3){
					//THIS IS ACTIONSCRIPT FOUND IN A FRAME
					//curFrameObj.actionScript
				}
				
				var nnn = curFrameObj.elements.length;
				for(var iii=0; iii<nnn; iii++){
					curElementObj = curFrameObj.elements[iii];
					if(curElementObj.libraryItem == undefined){
						//THESE ARE NON-LIBRARY ITEMS, SUCH AS SHAPES AND TEXTFIELDS
						//curElementObj.elementType
						//curElementObj.name
						if(curElementObj.elementType == "text"){
							//THIS IS A TEXT FIELD
							//curElementObj.getTextAttr("face");
						}
					} else {
						//EVERYTHING IN THIS SECTION IS A MOVIE CLIP THAT HAS BEEN PLACED ON THE STAGE IN SOME TIMELINE
						//NOTE: ITEMS THAT APPEAR IN MULTIPLE INSTANCES WILL APPEAR HERE MULTIPLE TIMES
						var libName = curElementObj.name;
						var className = curElementObj.libraryItem.linkageBaseClass;
						if (libName.indexOf("_primary") > -1 || libName.indexOf("_secondary") > -1 || libName.indexOf("_hilite") > -1){
							log("**********");
							
							log("[" + curElementObj.libraryItem.itemType + "]: ");
							log("name:"+curElementObj.name);
							log("libName:" +curElementObj.libraryItem.name);
							log("linkageBaseClass:" +curElementObj.libraryItem.linkageBaseClass + "\n");
							
							//**** TO CHANGE THE LINKAGE BASE CLASS, ENABLE THESE LINES
							//curElementObj.name = "skin_"+skinnableIndex+"_"+curElementObj.name;
							//skinnableIndex ++;
							//curElementObj.libraryItem.linkageExportForAS = true;
							//curElementObj.libraryItem.linkageExportInFirstFrame = true;
							//curElementObj.libraryItem.linkageBaseClass = "com.pbs.charbuilder.SkinnableMovieClip";
							//curElementObj.libraryItem.linkageExportInFirstFrame = true;
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


fl.trace("----- Begin Function");
createItemArrays();
processAllTimelines();

