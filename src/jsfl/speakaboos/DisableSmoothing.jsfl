var libItems = fl.getDocumentDOM().library.items;

for (i = 0; i < libItems.length; i++){
	if(libItems[i].itemType == "bitmap"){
		fl.trace(libItems[i].name);
		libItems[i].allowSmoothing = false;
		libItems[i].compressionType = "photo"; // or "lossless"
		libItems[i].quality = 80; // or any other quality
	}
}