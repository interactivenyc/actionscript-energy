package com.inyc.draw
{
	import com.inyc.asenergy.core.CoreMovieClip;
	
	import flash.display.MovieClip;
	import flash.events.Event;

	public class DrawController extends CoreMovieClip
	{
		private var _canvas:MovieClip;
		
		public function DrawController(){
			log("constructor");
		}
		
		override protected function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
		}
		
		override protected function onRemovedFromStage(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		override protected function init():void{
			_canvas = new MovieClip();
			addChild(_canvas);
		}
	}
}