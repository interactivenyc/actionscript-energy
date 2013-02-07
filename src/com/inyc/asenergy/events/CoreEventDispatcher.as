package com.inyc.asenergy.events {
	import com.inyc.asenergy.events.GenericDataEvent;
	import com.inyc.asenergy.utils.debug.Logger;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class CoreEventDispatcher extends EventDispatcher {
		private static var _instance:CoreEventDispatcher;
		
		public static function getInstance():CoreEventDispatcher {
			if( _instance == null ) {
				_instance = new CoreEventDispatcher( new SingletonEnforcer() );
			}
			return _instance;
		}
		
		public function CoreEventDispatcher( enforcer:SingletonEnforcer ):void {
			if( enforcer == null ) throw new Error( "CentralEventDispatcher is a singleton class and should only be instantiated via its static getInstance() method" );
		}
		
		//		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
		//			log("addEventListener: " + type);
		//			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		//		}
		
		override public function dispatchEvent(e:Event):Boolean{
			//log("dispatchEvent: " + e.type);
			//log((e as GenericDataEvent).data);
			if (!GenericDataEvent(e).data) GenericDataEvent(e).data = {};
			
			var bool:Boolean = super.dispatchEvent(e);
			return bool;
		}
		
		protected function log(logItem:*, ...args):void{
			var category:Array = [this.toString().replace("[object ", "").replace("]", "")];
			Logger.log(logItem,category,true);
			
			if (args.length > 0) {
				Logger.log(args,[category[0]+"..."],true);
			}
		}
		
	}
}

class SingletonEnforcer {
	public function SingletonEnforcer():void {}
}