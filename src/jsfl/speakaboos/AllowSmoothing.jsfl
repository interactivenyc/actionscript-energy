var libItems = fl.getDocumentDOM().library.items;

fl.trace("allowSmoothing START");

for (i = 0; i < libItems.length; i++){
	if(libItems[i].itemType == "bitmap"){
		if (libItems[i].allowSmoothing == false) {
			fl.trace("allowSmoothing applied to: "+libItems[i].name);
			libItems[i].allowSmoothing = true;
			libItems[i].compressionType = "photo"; // or "lossless"
			libItems[i].quality = 80; // or any other quality
		}
	}
}

fl.trace("allowSmoothing FINISHED");