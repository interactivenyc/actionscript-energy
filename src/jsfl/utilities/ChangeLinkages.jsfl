itemList = fl.getDocumentDOM().library.items;
itemNameArray = new Array();
itemArray = new Array();

log("Running");

function changeLinkages(){
	var item;
	var itemString;
	var addArray = new Array();
	var newLinkageName;
	var oldString = "videoAchievements";
	var newString = "cnplayer";
	
	for (var i=0; i<itemList.length; i++) {
		item = itemList[i];
		itemString = item.name+":\t"+item.itemType;
		itemNameArray.push(itemString);
		
		
		if (String(item.linkageClassName).indexOf(oldString) > -1){
			log(item.name);
			log("\t"+item.linkageClassName);
			newLinkageName = String(item.linkageClassName).replace(oldString, newString);
			log("\t"+newLinkageName);
			item.linkageClassName = newLinkageName;
		}
		
		if (String(item.linkageBaseClass).indexOf(oldString) > -1){
			log(item.name);
			log("\t"+item.linkageBaseClass);
			newLinkageName = String(item.linkageBaseClass).replace(oldString, newString);
			log("\t"+newLinkageName);
			item.linkageClassName = newLinkageName;
		}
		
	}
}






function log(msg){
	fl.trace(msg);
}


changeLinkages();
log("finished");



