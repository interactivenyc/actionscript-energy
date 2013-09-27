package com.inyc.asenergy.view.modals
{
	import com.inyc.asenergy.events.AppEvents;
	import com.inyc.asenergy.events.GenericDataEvent;
	import com.inyc.asenergy.view.components.DialogButton;
	import com.inyc.asenergy.view.components.MCButton;
	
	import flash.events.Event;

	public class Loader extends CoreModal
	{
		public var btn_cancel:MCButton;
		
		public function Loader()
		{
			super();
		}
		
		
		
		override protected function onAddedToStage(e:Event):void{
			super.onAddedToStage(e);
			_eventDispatcher.addEventListener(AppEvents.BUTTON_CLICK, onButtonClick);
			
			//Registers button with CoreModal to respond to RETURN KeyboardEvent
			_defaultButton = btn_cancel;
		}
		
		override protected function onRemovedFromStage(e:Event):void{
			_eventDispatcher.removeEventListener(AppEvents.BUTTON_CLICK, onButtonClick);
		}
		
		override protected function onButtonClick(e:GenericDataEvent):void{
			if (e.data.button && e.data.button.parent != this) return;
			
			super.onButtonClick(e);
			
			log("onButtonClick: " + e.data.button.name);
			
			switch(e.data.button){
				case btn_cancel:
					
					_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.DIALOG_BUTTON_CLICK, {dialogButton:new DialogButton()}));
					break;
				
			}
		}
		
	}
}