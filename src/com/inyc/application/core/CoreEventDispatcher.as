package com.inyc.application.core {
	import com.inyc.utils.debug.Logger;


		
		public function CoreEventDispatcher() {
			
		}
		
		protected function log(logItem:*, ...args):void{
			var category:Array = [this.toString().replace("[object ", "").replace("]", "")];
			Logger.log(logItem,category,true);
			
			if (args.length > 0) {
				Logger.log(args,[category[0]+"..."],true);
        	}
		}
	}