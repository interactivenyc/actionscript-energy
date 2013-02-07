package com.inyc.asenergy.utils {
	import fl.controls.listClasses.CellRenderer;
	
	import flash.text.TextFormat;	

	/* 
	/ The class extends the CellRenderer class and inherits all the 
	/ properties from this class.
	*/
	public class DropDownStyle extends CellRenderer
	{
		public function DropDownStyle():void
		{
			super();
			var textFormat:TextFormat = new TextFormat ();
			textFormat.align = "left";
			textFormat.font = "Arial";
			textFormat.size = 12;
			textFormat.color = 0x000000;
			setStyle("textFormat",textFormat);
		}
	}
	
}

