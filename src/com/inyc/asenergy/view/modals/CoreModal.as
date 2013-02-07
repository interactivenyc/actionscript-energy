package com.inyc.asenergy.view.modals
{
	import com.inyc.asenergy.controller.AppController;
	import com.inyc.asenergy.events.AppEvents;
	import com.inyc.asenergy.events.GenericDataEvent;
	import com.inyc.asenergy.utils.MovieClipUtils;
	import com.inyc.asenergy.view.components.CoreMovieClip;
	import com.inyc.asenergy.view.components.MCButton;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	
	public class CoreModal extends CoreMovieClip
		
	{
		private var _blocker:MovieClip;
		protected var _defaultButton:MCButton;
		
		private static var _modalCache:Object = {}; 
		
		
		public function CoreModal()
		{
			super();
		}
		
		
		override protected function onAddedToStage(e:Event):void{
			super.onAddedToStage(e);
			//log("onAddedToStage " + this.name);			
			showBlocker();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardEvent);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyboardEvent);
			_eventDispatcher.addEventListener(AppEvents.BUTTON_CLICK, onButtonClick);
		}
		override protected function onRemovedFromStage(e:Event):void{
			super.onRemovedFromStage(e);
			//log("onRemovedFromStage " + this.name);			
			hideBlocker();
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyboardEvent);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyboardEvent);
			_eventDispatcher.removeEventListener(AppEvents.BUTTON_CLICK, onButtonClick);
		}
		
		
		private function onKeyboardEvent(e:KeyboardEvent):void{
			//log("onKeyboardEvent: "+e.keyCode);
			
			if (_defaultButton == null) return;
			
			/**
			 * If a CoreModal declares a defaultButton,  
			 * it will respond to a KeyboardEvent.MOUSE_UP
			 **/
			
			if (e.type == KeyboardEvent.KEY_DOWN && e.keyCode == 13){
				_defaultButton.downState = true;
			}else if(e.keyCode == 13){ //return
				_defaultButton.downState = false;
				_defaultButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
		
		private function showBlocker():void{
			_blocker = MovieClipUtils.getFilledMC(1200, 900, 0x000000);
			_blocker.x = -x;
			_blocker.y = -y;
			_blocker.alpha = 0;
			_blocker.mouseEnabled = false;
			addChildAt(_blocker,0);
		}
		
		private function hideBlocker():void{
			removeChild(_blocker);
			_blocker = null;
		}
		
		protected function onButtonClick(e:GenericDataEvent):void{
			if (e.data.button && e.data.button.parent != this) return;
		}
		
		public static function getModal(className:String, controller:Object = null):CoreModal {
			var result:CoreModal;
			result = _modalCache[className];
			if (!result) { 
				var modalClass:Class = getDefinitionByName("com.inyc.asenergy.view.modals."+className) as Class;
				
				result = (controller) ? new modalClass(controller) : new modalClass();
				_modalCache[className] = result;
			}
			return result;
		}
		
		
		
//		protected function dispatchCloseEvent(message:String = ""):void{
//			log("dispatchCloseEvent");
//			_eventDispatcher.dispatchEvent(new GenericDataEvent(Events.CLOSE_MODAL, {modal:this}));
//		}
		
		public function destroy():void {
			//log("destroy");
		}
		
		
		
	}
}