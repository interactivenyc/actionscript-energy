package com.inyc.asenergy.core {
	import com.inyc.asenergy.utils.debug.Logger;		import flash.events.EventDispatcher;		
	/**	 * @author stevewarren	 */	public class CoreEventDispatcher extends EventDispatcher {

		
		public function CoreEventDispatcher() {
			
		}
		
		protected function log(logItem:*, ...args):void{
			var category:Array = [this.toString().replace("[object ", "").replace("]", "")];
			Logger.log(logItem,category,true);
			
			if (args.length > 0) {
				Logger.log(args,[category[0]+"..."],true);
        	}
		}
	}}