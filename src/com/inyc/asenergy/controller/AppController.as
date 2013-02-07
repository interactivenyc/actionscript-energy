package com.inyc.asenergy.controller
{
	import com.inyc.asenergy.events.AppEvents;
	import com.inyc.asenergy.events.GenericDataEvent;
	import com.inyc.asenergy.utils.MovieClipUtils;
	import com.inyc.asenergy.view.components.CoreMovieClip;
	import com.inyc.asenergy.view.components.DialogButton;
	import com.inyc.asenergy.view.modals.CoreModal;
	import com.inyc.asenergy.view.modals.Loader;
	import com.inyc.asenergy.view.modals.LogDisplay;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class AppController extends CoreMovieClip
	{
		
		//Main Views
		protected var _viewContainer:CoreMovieClip;
		protected var _background:MovieClip;
		protected var _logButton:MovieClip;
		
		public static var topModal:CoreModal;
		protected var _openModals:Vector.<CoreModal>;
		
		//This sets the viewport size
		protected var _stageWidth:int = 1200; 
		protected var _stageHeight:int = 900; 
		
		public static var LOAD_FILES_FROM_CACHE:Boolean = true;
		public static var ANIMATING:Boolean = false;
		public static var LOADER_CONTEXT:LoaderContext;
		public static var LOG_OUTPUT:String = "";
			
		public function AppController(){
			
			LOADER_CONTEXT = new LoaderContext(false,ApplicationDomain.currentDomain,null); //avoids some security sandbox headaches that plague many users.
			_openModals = new Vector.<CoreModal>;
			_viewContainer = new CoreMovieClip();
			addChild(_viewContainer);
			
			_logButton = MovieClipUtils.getLibraryMC("logButton");
			_logButton.x = 25;
			_logButton.y = 25;
			_logButton.alpha = .5;
			_logButton.addEventListener(MouseEvent.CLICK, showLog);
			addChild(_logButton);
		}
		
		protected function showLog(e:Event = null):void{
			log("showLog");
			var buttons:Vector.<DialogButton> = new Vector.<DialogButton>;
			var button:DialogButton = new DialogButton("OK", closeTopModal);
			buttons.push(button);
			button = new DialogButton("RESET LOG");
			buttons.push(button);
			
			var messageDialog:LogDisplay = new LogDisplay("Log File", LOG_OUTPUT, buttons);
			_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.SHOW_MESSAGE_DIALOG, {messageDialog:messageDialog}));
		}
		
		protected function resetLog(e:Event = null):void{
			LOG_OUTPUT == "";
		}
		
		/*********************************************************************
		 * MODAL DISPLAY
		 *********************************************************************/
		
		
		protected function showLoaderMC():void{
			var modal:CoreModal;
			modal = new Loader();
			showModal(modal);
		}
		
		protected function showModal(modal:CoreModal):void{
			//log("showModal:"+modal);
			
			topModal = modal;
			
			_openModals.push(modal);
			centerDisplayObject(modal);
			_viewContainer.addChild(modal);
		}
		
		
		protected function centerDisplayObject(displayObject:DisplayObject):void{
			//log("centerDisplayObject");
			displayObject.x = (_stageWidth/2) - (displayObject.width/2);
			displayObject.y = (_stageHeight/2) - (displayObject.height/2);
			//log("width: "+displayObject.width+", height: "+displayObject.height);
			//log("x: "+displayObject.x+", y: "+displayObject.y);
		}
		
		
		public function closeTopModal():void{
			//log("closeTopModal");
			if (_openModals.length < 1) return;
			
			var modal:CoreModal = _openModals.pop();
			
			if (_openModals.length > 0) topModal = _openModals[_openModals.length -1];
			
			_viewContainer.removeChild(modal);
			modal.destroy();
			modal = null;
			
		}
		
		
		protected function closeAllModals():void{
			//log("closeAllModals:");
			for (var i:int=0; i<_openModals.length; i++){
				_viewContainer.removeChild(_openModals[i]);
				_openModals[i] = null;
			}
			_openModals = new Vector.<CoreModal>();
		}
		
		
		
		protected function numModalsOpen():int{
			var numModals:int = 0;
			for (var i:int=0;i<_viewContainer.numChildren;i++){
				if (_viewContainer.getChildAt(i) is CoreModal) numModals ++;
			}
			return numModals;
		}
		
		public function get openModals():Vector.<CoreModal>{
			return _openModals;
		}
		
		
		
		
	}
}