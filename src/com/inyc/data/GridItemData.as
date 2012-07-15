package com.inyc.data {
	/**	 * @author stevewarren	 */	public class GridItemData {
		public var thumbURL:String; //required
		public var index:int; //required
		public var data:Object; //optional
		public var cellWidth:int; //optional
		public var cellHeight:int; //optional				public function GridItemData(pThumbURL:String, pData:Object = null, pIndex:int = -1, pWidth = -1, pHeight = -1) {
			thumbURL = pThumbURL;
			data = pData;
			index = pIndex;
			cellWidth = pWidth;
			cellHeight = pHeight;
		}	}}