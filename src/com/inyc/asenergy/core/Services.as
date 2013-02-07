package com.inyc.asenergy.core {
	import com.inyc.asenergy.events.AppEvents;	import com.inyc.asenergy.events.GenericDataEvent;	import com.inyc.asenergy.utils.debug.Logger;		import flash.events.Event;	import flash.events.EventDispatcher;	import flash.external.ExternalInterface;		/**
	 * @author stevewarren
	 */
	public class Services extends EventDispatcher {

		public function Services() {
			log("CONSTRUCTOR");
			dispatchEvent(new GenericDataEvent(AppEvents.SHOW_LOADER));
			
			//HERE IS THE TEMPLATE FOR ADDING JAVASCRIPT LISTENERS
			log("ExternalInterface.addCallback");
			ExternalInterface.addCallback ("callLoginChange", loginChange);
			
			
		}
		
		public function init():void{
			servicesReady();
		}
		
		
		/***************************************************
		 * Services Initialization
		 ***************************************************/
		
		
		
		protected function servicesReady(e:Event=null):void{
			log("**************************************");
			log("servicesReady");
			log("**************************************");
			
			dispatchEvent(new GenericDataEvent(AppEvents.HIDE_LOADER));
			dispatchEvent(new GenericDataEvent(AppEvents.SERVICES_READY));
		}

		
		
		/***************************************************
		 * User Management
		 ***************************************************/
		 
		public function callLogin():void{
			log("callLogin");
		}
		
		
		private function loginChange(type:String,success:String,username:String):void{
			log("loginChange type:"+type+", success:"+success+", username:"+username);
		}
		
		protected function log(logItem:*, ...args):void{
			var category:Array = [this.toString().replace("[object ", "").replace("]", "")];
			Logger.log(logItem,category,true);
			
			if (args.length > 0){
				Logger.log(args,[category[0]+"..."],true);
        	}
		}

	}
}
