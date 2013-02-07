package com.inyc.asenergy.view.components
{
	import com.adobe.images.PNGEncoder;
	import com.inyc.asenergy.controller.AppController;
	import com.inyc.asenergy.events.AppEvents;
	import com.inyc.asenergy.events.GenericDataEvent;
	import com.inyc.asenergy.models.data.Story;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.ByteArray;

	public class ListingsItem extends CoreMovieClip
	{
		public var container:MovieClip;
		public var title:TextField;
		public var btn_delete:MCButton;
		
		protected var _listingsData:Story;
		protected var _loader:CacheLoader;
		protected var _thumbnail:Bitmap;
		protected var _thumbnailLoaded:Boolean = false;
		
		public static const LISTINGS_ITEM_DELETE_CLICKED:String = "LISTINGS_ITEM_DELETE_CLICKED";
		public static const LISTINGS_ITEM_PLAY_CLICKED:String = "LISTINGS_ITEM_PLAY_CLICKED";
		
		public function ListingsItem(){
			super();
			log("constructor");
		}
		
		
		public function set listingsData(listingsData:Object):void{
			_listingsData = listingsData as Story;
		}
		
		public function get listingsData():Object{
			return _listingsData;
		}
		
		override protected function onAddedToStage(e:Event):void{
			super.onAddedToStage(e);
			_eventDispatcher.addEventListener(AppEvents.BUTTON_CLICK, onButtonClick);
			init();
		}
		
		override protected function onRemovedFromStage(e:Event):void{
			super.onAddedToStage(e);	
			_eventDispatcher.removeEventListener(AppEvents.BUTTON_CLICK, onButtonClick);
		}
		
		private function init():void{
			log("init: "+_listingsData.name);
			display();
		}
		
		
		protected function display():void{
			title.text = _listingsData.title;
			_loader = new CacheLoader();
			_loader.setLocalDirectory("./data/images/category_screen_category_icon/");
			var urlRequest:URLRequest = new URLRequest(_listingsData.storyIcon);
			
			log("load Thumbnail: "+_listingsData.name)
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onThumbnailLoaded);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_loader.load(urlRequest);
		}
		
		protected function onThumbnailLoaded(e:Event):void{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onThumbnailLoaded);	
			
			log("onThumbnailLoaded: "+_listingsData.name);
			_thumbnailLoaded = true;
			
			_thumbnail = Bitmap(_loader.content);
			_thumbnail.smoothing = true;
			
			_loader.content.width = 120;
			_loader.content.scaleY = _loader.content.scaleX;
			container.addChild(_loader.content);
			
			dispatchEvent(new GenericDataEvent(AppEvents.THUMBNAIL_LOADED));
		}
		

		
		protected function onIOError(e:IOErrorEvent):void{
			log("onIOError");
			log(e.text);
		}
		
		protected function onSecurityError(event:SecurityError):void{
			log("onSecurityError");
		}
		
		
		protected function onButtonClick(e:GenericDataEvent):void{
			if (AppController.ANIMATING == true) return;
			if (e.data.button && e.data.button.parent != this) return;
			if (_thumbnailLoaded == false) return;
			_eventDispatcher.dispatchEvent(new GenericDataEvent(LISTINGS_ITEM_DELETE_CLICKED, {listingsItem:this}));
		}
		
		
	
		
	}
}