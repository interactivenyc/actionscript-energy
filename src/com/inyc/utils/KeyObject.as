package com.inyc.utils {
	import org.casalib.util.StageReference;	
	
	import com.inyc.events.Events;	
	import com.inyc.events.GenericDataEvent;		import com.inyc.utils.debug.Logger;
	
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;	

	/**
	 * The KeyObject class recreates functionality of
	 * Key.isDown of ActionScript 1 and 2
	 *
	 * Usage:
	 * var key:KeyObject = new KeyObject(stage);
	 * if (key.isDown(key.LEFT)) { ... }
	 */
	dynamic public class KeyObject extends Proxy {
		
		private static var stage:Stage;
		private static var keysDown:Object;
		
		public function KeyObject(stage:Stage) {
			log("KeyObject CONSTRUCTOR");
			construct(stage);
		}
		
		public function construct(stage:Stage):void {
			KeyObject.stage = stage;
			keysDown = new Object();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
		}
		
		flash_proxy override function getProperty(name:*):* {
			return (name in Keyboard) ? Keyboard[name] : -1;
		}
		
		public function isDown(keyCode:uint):Boolean {
			return Boolean(keyCode in keysDown);
		}
		
		public function deconstruct():void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyReleased);
			keysDown = new Object();
			KeyObject.stage = null;
		}
		
		private function keyPressed(evt:KeyboardEvent):void {
			log("keyPressed keyCode:"+evt.keyCode);
			keysDown[evt.keyCode] = true;
		}
		
		private function keyReleased(evt:KeyboardEvent):void {
			//log("keyReleased keyCode:"+evt.keyCode);
			delete keysDown[evt.keyCode];
		}
		
		public function get keysDownObject():Object{
			return keysDown;
		}
		
		private function log(logItem:*,category:Array=null):void{
			var e:GenericDataEvent = new GenericDataEvent(Events.LOG_MESSAGE, {logItem:logItem});
			StageReference.getStage().dispatchEvent(e);
			
			if(category==null) category = ["KeyObject"];
			Logger.log(logItem,category,true);
		}
	}
}