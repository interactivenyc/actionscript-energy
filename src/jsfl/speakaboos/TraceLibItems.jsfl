var libItems = fl.getDocumentDOM().library.items;

for (i = 0; i < libItems.length; i++){
	if(libItems[i].itemType == "bitmap"){
	
		
		fl.trace("**********************");
		fl.trace(libItems[i].name);
		fl.trace(libItems[i]).sourceFilePath;
		fl.trace("**********************");
		
		
		//for (var prop in libItems[i]){
			//fl.trace(prop + " : " + libItems[i][prop]);
		//}
		
	}
}