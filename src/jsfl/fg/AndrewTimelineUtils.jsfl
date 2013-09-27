singleFrameInstances = new Array();
multiFrameInstances = new Array();

singleFrameInstancesWithClasses = new Array();
multiFrameInstancesWithClasses = new Array();

nonLibraryTimelineItems = new Array();
errorItems = new Array();

nonMovieClipItems = new Array();

masterLogLevel = 4; // 10 = all, 7 = processing + optional, 5 = optional, 4 and under = WARNING, ALERT OR ERROR

startTime = new Date();

log("Running");





function printLayerNames(theTimeline){
	for (var i=0; i<theTimeline.layers.length; i++) {
		log("\tlayer: "+theTimeline.layers[i].name+" type: "+theTimeline.layers[i].layerType);
	}
	
	log(FLfile);
	log(FLfile.exists("AndrewAnswers.fla"))
}

function processTimeline(theTimeline){
	var numLayers = theTimeline.layers.length;
	var numFrames;
	var numElements;
	var currentLayer;
	var currentFrame;
	var currentElement;
	var nextFrame;
	var libraryItem;
	
	/*
	 * Loop Through Each Layer
	 */
	
	for (var i=0; i<numLayers; i++) {
		
		log("", 7);
		log("------------------------------------------", 7);
		log("[ LAYER: "+theTimeline.layers[i].name+" type: "+theTimeline.layers[i].layerType+"]", 7);
		log("------------------------------------------", 7);
		log("", 7);
		
		if (theTimeline.layers[i].layerType == "guide") continue;
		if (theTimeline.layers[i].layerType == "guided") continue;
		if (theTimeline.layers[i].layerType == "mask") continue;
		if (theTimeline.layers[i].layerType == "masked") continue;
		if (theTimeline.layers[i].layerType == "folder") continue;
		
		
		
		currentFrame=null;
		numFrames = theTimeline.layers[i].frames.length;
		currentLayer = theTimeline.layers[i];
	
		
		/*
		 * Loop Through Each Frame
		 */
	
		//for(var ii=0; ii<1000; ii++){
		//if (numFrames>350) numFrames = 350;
		
		for(var ii=0; ii<numFrames; ii++){
		
			nextFrame = theTimeline.layers[i].frames[ii];
			
			try {
				//only trace KeyFrame
				if (nextFrame != currentFrame) {
					currentFrame = nextFrame;
					log("\t\t[ KEY FRAME :: " + ii + " ] " + currentFrame.name, 7);

					
					
					
					/*
		 			* Loop Through Each Item on a KeyFrame
		 			*/
					
					log("currentFrame"+currentFrame, 7);
					
					numElements = currentFrame.elements.length;
					
					log("numElements:"+numElements, 7);
					log("", 7);
					
					for (var iii = 0; iii < numElements; iii++) {
						log("element:"+iii, 7);
						
						currentElement = currentFrame.elements[iii];
						
						/*
						 * This line is the only one that actually changes anything in this function
						 * COMMENT IT OUT TO DO A DRY RUN
						 */
						processAllInstances(currentElement, currentLayer);
						
						log("currentElement.name:"+currentElement.name, 7);
						
												
						if (currentElement.libraryItem == undefined) {
							nonLibraryTimelineItems.push(libraryItem);
							
							log("", 7);
							log("------------libraryItem is not in the library------------", 7);
							
						} else {
							libraryItem = currentElement.libraryItem;
							
							if (libraryItem.itemType == "movie clip" && libraryItem.timeline.frameCount == 1) {
								
								if (libraryItem.linkageBaseClass == undefined){
									singleFrameInstances.push({element:currentElement,layer:currentLayer,frame:currentFrame});
									
									log("", 7);
									log("------------single--------------", 7);
									log("name:"+libraryItem.name, 7);
									log("linkageBaseClass:"+libraryItem.linkageBaseClass, 7);
									log("linkageExportInFirstFrame:"+libraryItem.linkageExportInFirstFrame, 7);
									
									
								}else{
									singleFrameInstancesWithClasses.push({element:currentElement,layer:currentLayer,frame:currentFrame});
									
									log("", 7);
									log("------------singleFrameInstancesWithClasses--------------", 7);
									log("name:"+libraryItem.name, 7);
									log("linkageBaseClass:"+libraryItem.linkageBaseClass, 7);
								}
								
							}else if(libraryItem.itemType == "movie clip" && libraryItem.timeline.frameCount > 1){
								
								if (!libraryItem.linkageBaseClass) {
									multiFrameInstances.push({element:currentElement,layer:currentLayer,frame:currentFrame});
								
									log("", 7);
									log("------------multi--------------", 7);
									log("name:"+libraryItem.name, 7);
									log("linkageBaseClass:"+libraryItem.linkageBaseClass, 7);
									log("frameCount:"+libraryItem.timeline.frameCount, 7);
								}else{
									multiFrameInstancesWithClasses.push({element:currentElement,layer:currentLayer,frame:currentFrame});
									
									log("", 7);
									log("------------multiFrameInstancesWithClasses--------------", 7);
									log("name:"+libraryItem.name, 7);
									log("linkageBaseClass:"+libraryItem.linkageBaseClass, 7);
								}
								
								
								
								
							
							}else{
								nonMovieClipItems.push({element:currentElement,layer:currentLayer,frame:currentFrame});
								
								log("", 7);
								log("------------libraryItem is not a movie clip------------", 7);
							}
						}
					}
				}
				
			}catch (e){
				errorItems.push({element:currentElement,layer:currentLayer,frame:currentFrame});
				log("COULD NOT LIST OBJECT PROPERTIES");
				log("libraryItem:"+libraryItem);
				for (var prop in currentElement){
					log("prop:"+prop);
				}
				//enable this if you want this to fail
				//log("libraryItem.itemType:"+libraryItem.itemType, 7);
				
			}
			
		}
	}
	
	
	log("------------------------------");
	log("------------------------------");
	
	log("singleFrameInstances.length:"+singleFrameInstances.length);
	log("multiFrameInstances.length:"+multiFrameInstances.length);
	
	log("singleFrameInstancesWithClasses.length:"+singleFrameInstancesWithClasses.length);
	log("multiFrameInstancesWithClasses.length:"+multiFrameInstancesWithClasses.length);
	
	log("nonLibraryTimelineItems.length:"+nonLibraryTimelineItems.length);
	log("nonMovieClipItems.length:"+nonMovieClipItems.length);
	log("errorItems.length:"+errorItems.length);
	
	
	
}






function fixSingleFrameMCs(){
	log("---------------fixSingleFrameMCs---------------");
	
	for (var i = 0; i < singleFrameInstances.length; i++) {
		libraryItem = singleFrameInstances[i].element.libraryItem;
		
		log("------------single frame MC needs linkage--------------");
		log(libraryItem.name);
		log(libraryItem.linkageBaseClass);
		log(libraryItem.linkageExportInFirstFrame);
		
		try {
			libraryItem.linkageExportForAS = true;
			libraryItem.linkageExportInFirstFrame = true;
			libraryItem.linkageBaseClass = "com.fg.ruckus.CacheMatrixItem";
			libraryItem.linkageExportInFirstFrame = true;
			
			log("------------single frame MC fixed--------------");
		}catch(e){
			log("------------ERROR OCCURRED TRYING TO ADD CLASS TO SYMBOL--------------");
		}
		
		
		
	}
	
}

function fixSingleFrameMCsWithClasses(){
	log("---------------fixSingleFrameMCsWithClasses---------------");
	
	for (var i = 0; i < singleFrameInstancesWithClasses.length; i++) {
		libraryItem = singleFrameInstancesWithClasses[i].element.libraryItem;
		
		if (libraryItem.linkageBaseClass == "com.fg.ruckus.CacheMatrixItem" || libraryItem.linkageBaseClass == "com.fg.ruckus.TypeDialog") {
			log("------------single class already set--------------", 5);
			//log(libraryItem.name);
			//log(libraryItem.linkageBaseClass);
			
		}else{
			log("------------TO INSPECT: single with class--------------");
			log(libraryItem.name);
			log(libraryItem.linkageBaseClass);
			log(libraryItem.linkageExportInFirstFrame);
			
			if (libraryItem.linkageBaseClass == "com.fg.ruckus.CacheItem"){
				log("fixing old CacheItem linkage")
				libraryItem.linkageBaseClass == "com.fg.ruckus.CacheMatrixItem"
			}
			
			//change CacheItem to CacheMatrixItem, and inspect anything else here
		
		}
	}
}




function digIntoMultiFrameInstances(instanceArray, TITLE){
	log("---------------"+TITLE+"---------------");
	
	var libraryItem;
	var numLayers;
	var checkLayer;
	var keyFrames;
	var keyFrame;
	var numElements;
	var element;
	var nestedLibraryItem;
	
	
	try {
	
		for (var i = 0; i < instanceArray.length; i++) {
			libraryItem = instanceArray[i].element.libraryItem;
			
			log("------------multi--------------");
			log("libraryItem.name:"+libraryItem.name, 5);
			if (libraryItem.linkageBaseClass) log("linkageBaseClass:"+libraryItem.linkageBaseClass, 5);
			log("libraryItem.timeline.frameCount:" + libraryItem.timeline.frameCount, 5);
			
			numLayers = libraryItem.timeline.layers.length;
			
			if (numLayers > 1) 
				log("<-- TO INSPECT: Movie Clip with Multiple Layers:" + numLayers + " -->");
				log("libraryItem.name:"+libraryItem.name)
			
				checkLayer = libraryItem.timeline.layers[0];
				keyFrames = getkeyFramesForLayer(checkLayer);
				
				if (keyFrames.length > 1) log("numKeyFrames:" + keyFrames.length);
				log("");
			
			for (var ii = 0; ii < keyFrames.length; ii++) {
				keyFrame = keyFrames[ii];
				numElements = keyFrame.elements.length;
				
				
				log("\t keyframe: " + keyFrame.startFrame + " numElements:" + numElements, 5);
				
				
				
				try {
					for (var iii = 0; iii < numElements; iii++) {
						element = keyFrame.elements[iii];
						nestedLibraryItem = element.libraryItem;
						
						log("\t\t ------------nestedLibraryItem--------------", 5);
						
						
						if (nestedLibraryItem.itemType == "movie clip" && nestedLibraryItem.timeline.frameCount == 1) {
						
							if (!nestedLibraryItem.linkageBaseClass) {
								//set the base class to CacheMatrixItem
								
								log("\t\t ------------nestedLibraryItem needs CacheMatrixItem--------------");
								
								log("\t\t  element nestedLibraryItem.name:" + nestedLibraryItem.name);
								log("\t\t  element nestedLibraryItem.itemType:" + nestedLibraryItem.itemType);
								nestedLibraryItem.linkageExportForAS = true;
								nestedLibraryItem.linkageExportInFirstFrame = true;
								nestedLibraryItem.linkageBaseClass = "com.fg.ruckus.CacheMatrixItem";
								nestedLibraryItem.linkageExportInFirstFrame = true;
								log("\t\t ------------nestedLibraryItem fixed--------------");
								
								
								
								
							}
							else {
								log("\t\t ------------nestedLibraryItem has linkage--------------", 5);
								log("\t\t linkageBaseClass:"+nestedLibraryItem.linkageBaseClass, 5);
								
								if (nestedLibraryItem.linkageBaseClass != "com.fg.ruckus.CacheMatrixItem") {
									log("\t\t ------------nestedLibraryItem has linkage not CacheMatrixItem--------------");
								}
								else {
									log("\t\t ------------nestedLibraryItem has CacheMatrixItem--------------", 5);
								}
							}
							
						}
						else {
							log("\t\t FOUND EMBEDDED MULTIFRAME MOVIE CLIP THAT NEEDS SPECIAL HANDLING");
							log("\t\t element nestedLibraryItem.name:" + nestedLibraryItem.name);
							log("\t\t element nestedLibraryItem.itemType:" + nestedLibraryItem.itemType);
						}
						
					}
				}catch(e){
					log("\t\t ERROR PROCESSING ELEMENT - usually shapes that don't have libraryItems", 5);
					log("\t\t nestedElement:"+element, 5);
					log("\t\t nestedLibraryItem:"+nestedLibraryItem, 5)
				}
			}
		}
		
	}catch(e){
		log("ERROR PROCESSING MOVIE CLIP");
	}
	
}













function getkeyFramesForLayer(layer){
	var numFrames = layer.frames.length;
	var currentFrame = 0;
	var keyFrames = new Array();
	
	for (var i=0;i<numFrames;i++){
		if (layer.frames[i] != currentFrame){
			keyFrames.push(layer.frames[i]);
			currentFrame = layer.frames[i];
			if (i>0) log("keypoint found:"+currentFrame + " " + currentFrame.startFrame, 5);
		}
	}
	
	return keyFrames;
	
}




function processAllInstances(instance, layer){
	//CACHE AS BITMAP = FALSE
	
	var logReport = "";
	
	if (instance.cacheAsBitmap = true) {
		logReport += "\n\t*** cacheAsBitmap = false";
		instance.cacheAsBitmap = false;
	}
	
	//FORCE ITEMS TO SINGLE PIXEL LOCS
						
	if (instance.libraryItem.linkageBaseClass == "com.fg.ruckus.TypeDialog" || instance.libraryItem.linkageBaseClass == "com.fg.ruckus.SimpleDelayButton"){
		var checkNum;
		
		checkNum = instance.x - Math.floor(instance.x);
		if (checkNum > 0){
			logReport += "\n\t*** Move-X:"+checkNum;
			instance.x = Math.round(instance.x);
		}
		
		checkNum = instance.y - Math.floor(instance.y);
		if (checkNum > 0){
			logReport += "\n\t*** Move-Y:"+checkNum;
			instance.y = Math.round(instance.y);
		}
		
		if (logReport != ""){
			log("---------------processAllInstances---------------");
			log("*** CHANGED");
			log("*** name:"+instance.libraryItem.name);
			log("*** layer.name:"+layer.name);
			log("*** instance.cacheAsBitmap:"+instance.cacheAsBitmap);
			log(logReport);
			log("");
			listInstanceProps(instance);
		}
	
	}

}




function listInstanceProps(obj){
	
	log(" [*** <listInstanceProps> ***] ", 5);

	try {
		log("\t libraryItem.name: "+obj.libraryItem.name, 5);
		if (obj.instanceType != "symbol") log("\t instanceType: "+obj.instanceType), 5;
		if (obj.symbolType != "movie clip") log("\t symbolType: "+obj.symbolType, 5);
		if (obj.elementType != "instance") log("\t elementType: "+obj.elementType, 5);
		if (obj.effectSymbol != false) log("\t effectSymbol: "+obj.effectSymbol, 5);
		//log("\t libraryItem: "+obj.libraryItem, 5);
		if (obj.filters != undefined) log("\t filters: "+obj.filters, 5);
		if (obj.blendMode != "normal") log("\t blendMode: "+obj.blendMode, 5);
		log("\t cacheAsBitmap: "+obj.cacheAsBitmap, 5);
		if (obj.loop != undefined) log("\t loop: "+obj.loop, 5);
		if (obj.actionScript != "") log("\t actionScript: "+obj.actionScript, 5);
		if (obj.name != "") log("\t name: "+obj.name, 5);
		log("\t matrix: "+obj.matrix, 5);
		
		if (obj.matrix){
			log("\t\t\t matrix a: "+obj.matrix.a, 5);
			log("\t\t\t matrix b: "+obj.matrix.b, 5);
			log("\t\t\t matrix c: "+obj.matrix.c, 5);
			log("\t\t\t matrix d: "+obj.matrix.d, 5);
			log("\t\t\t matrix tx: "+obj.matrix.tx, 5);
			log("\t\t\t matrix ty: "+obj.matrix.ty, 5);
		}
		
		log("\t x: "+obj.x, 5);
		log("\t y: "+obj.y, 5);
		
		log("\t width: "+obj.width, 5);
		log("\t height: "+obj.height, 5);
		//log("\t depth: "+obj.depth, 5);
		
		log("\t transformX: "+obj.transformX, 5);
		log("\t transformY: "+obj.transformY, 5);
		if (obj.scaleX != 1) log("\t scaleX: "+obj.scaleX, 5);
		if (obj.scaleY != 1) log("\t scaleY: "+obj.scaleY, 5);
		
		if (obj.rotation != 0) log("\t rotation: "+obj.rotation, 5);
		if (obj.duration != 0) log("\t duration: "+obj.duration, 5);
		
	} catch(e){
		log("COULD NOT LIST OBJECT PROPERTIES", 5);
	}
	
	log(" [*** </listInstanceProps> ***] ", 5);
	
}

function log(msg, logLevel){
	//appendToLog(msg);
	
	if (logLevel == undefined) 
		logLevel = 0;
	if (logLevel <= masterLogLevel) {
		timeElapsed = Math.round((new Date() - startTime)/1000);
		fl.trace(timeElapsed + " : " + msg);
		
	}
}





function appendToLog(p_str) {
	logAppend += "\n"+p_str;
	FLfile.write("/Users/stevewarren/Library/Preferences/Macromedia/Flash\ Player/Logs/flashlog.txt","\n"+p_str,"append");
}





//TODO: TRY TO FIND A WAY TO SAVE THE PROCESSED TIMELINE IN A FORMAT THAT CAN BE READ BACK IN WITHOUT RE-RIPPING EVERY TIME
printLayerNames(fl.getDocumentDOM().getTimeline());


processTimeline(fl.getDocumentDOM().getTimeline());


fixSingleFrameMCs();
fixSingleFrameMCsWithClasses();
digIntoMultiFrameInstances(multiFrameInstances, "multiFrameInstances");
digIntoMultiFrameInstances(multiFrameInstancesWithClasses, "multiFrameInstancesWithClasses");



log("TOTAL RUNNING TIME: " + Math.round((new Date() - startTime)/1000));
