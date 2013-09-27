var libItems = fl.getDocumentDOM().library.items;

for (i = 0; i < libItems.length; i++){
	if(libItems[i].itemType == "textfield"){
		
		fl.trace("**********************");
		fl.trace(libItems[i].name);
		fl.trace("**********************");
		
	}else{
		fl.trace("nothing");
	}
}