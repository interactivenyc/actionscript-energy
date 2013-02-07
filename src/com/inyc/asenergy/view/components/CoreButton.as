package com.inyc.asenergy.view.components
{
	import com.inyc.asenergy.events.AppEvents;
	import com.inyc.asenergy.events.GenericDataEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class CoreButton extends CoreMovieClip
	{
		public var bg:MovieClip;
		
		public function CoreButton(){
			//super();
		}
		
		override protected function onAddedToStage(e:Event):void{
			//log("onAddedToStage core button "+this.name);
			super.onAddedToStage(e);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
			addEventListener(MouseEvent.CLICK, onMouseEvent);
		}
		
		override protected function onRemovedFromStage(e:Event):void{
			//log("onRemovedFromStage core button "+this.name);
			super.onRemovedFromStage(e);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
			removeEventListener(MouseEvent.CLICK, onMouseEvent);
		}
		
		protected function onMouseEvent(e:MouseEvent):void{
			switch(e.type){
				case MouseEvent.CLICK:
					_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.BUTTON_CLICK, {button:this}));
					break;
			}
		}
		
				
	}
}
