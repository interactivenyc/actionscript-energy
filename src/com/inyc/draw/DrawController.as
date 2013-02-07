package com.inyc.draw
{
	import com.inyc.asenergy.utils.MovieClipUtils;
	import com.inyc.asenergy.view.components.CoreMovieClip;
	
	import flash.display.MovieClip;
	import flash.events.Event;

	public class DrawController extends CoreMovieClip
	{
		private var _displayContainer:MovieClip;
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
			
			
			addEventListeners();
			drawCanvas();
			showLoaderMC();
			initServices();
		}
		
		private function addEventListeners():void{
			
		}
		
		private function removeEventListeners():void{
			
		}
		
		private function drawCanvas():void{
			_displayContainer = new MovieClip();
			addChild(_displayContainer);
			_canvas = new MovieClip();
			_displayContainer.addChild(_canvas);
			
			var bg:MovieClip = MovieClipUtils.getFilledMC(1200,900,0xff6600);
			_canvas.addChild(bg);
		}
		
		private function showLoaderMC():void{
			
		}
		
		private function initServices():void{
			
		}
		
		
	}
}