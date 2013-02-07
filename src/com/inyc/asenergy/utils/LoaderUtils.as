package com.inyc.asenergy.utils {
	import com.inyc.asenergy.view.components.IGridItem;	import com.inyc.asenergy.models.GridItemData;	import com.inyc.asenergy.events.LoaderUtilsEvent;	import com.inyc.asenergy.utils.debug.Logger;		import flash.display.Loader;	import flash.display.LoaderInfo;	import flash.display.MovieClip;	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.events.IOErrorEvent;	import flash.events.SecurityErrorEvent;	import flash.net.URLLoader;	import flash.net.URLRequest;	import flash.net.URLRequestMethod;	import flash.net.URLVariables;	import flash.system.ApplicationDomain;	import flash.system.LoaderContext;	import flash.system.SecurityDomain;		/**
	 * @author stevewarren
	 * THIS NEW CLASS IS A WORK IN PROGRESS!!!
	 */
	public class LoaderUtils extends EventDispatcher {
		var loaders:Array = new Array();
		var ldrContext:LoaderContext;
		var serviceLoader:URLLoader;
		
		public static var LOADER_EVENT:String = "LOADER_EVENT";

		
		public function LoaderUtils() {
			ldrContext = new LoaderContext(false, ApplicationDomain.currentDomain, SecurityDomain.currentDomain);
		}
		
		public function load(url:String, useLoaderContext:Boolean=true):Loader{
			log("load url:"+url);
			var loader:Loader = new Loader();
			var urlRequest:URLRequest = new URLRequest(url);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			if (useLoaderContext){
				loader.load(urlRequest, ldrContext);
			}else{
				loader.load(urlRequest);
			}
			
			loaders.push(loader);
			return loader;
		}
		
		private function destroyLoader(loader:Loader):void{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			//loader.unload();
			loader = null;
		}
		
		protected function onLoadComplete(e:Event):void{
			//log("onLoadComplete:"+e.target.url);
			dispatchEvent(e);
			dispatchEvent(new LoaderUtilsEvent(LoaderUtilsEvent.COMPLETE));
			var loader:Loader = (e.target as LoaderInfo).loader;
			destroyLoader(loader);
			removeValueFromArray(loaders, loader);
			if (loaders.length == 0) {
				dispatchEvent(new LoaderUtilsEvent(LoaderUtilsEvent.ALL_COMPLETE));
			}
		}
		
		private function onIOError(e:IOErrorEvent):void{
			log("onIOError:"+e.text);
			if (e.target is LoaderInfo){
				var loader:Loader = (e.target as LoaderInfo).loader;
				destroyLoader(loader);
				removeValueFromArray(loaders, loader);
			}
			dispatchEvent(new LoaderUtilsEvent(LoaderUtilsEvent.IO_ERROR));
			dispatchEvent(new LoaderUtilsEvent(LoaderUtilsEvent.SERVICE_RESULT, {error:e.text}));
			
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void{
			log("onSecurityError:"+e.text);
			var loader:Loader = (e.target as LoaderInfo).loader;
			destroyLoader(loader);
			removeValueFromArray(loaders, loader);
			dispatchEvent(new LoaderUtilsEvent(LoaderUtilsEvent.SECURITY_ERROR));
		}
		
		
		
		public static function removeValueFromArray(arr:Array, value:Object):void
		{
			var len:uint = arr.length;
			
			for(var i:Number = len; i > -1; i--)
			{
				if(arr[i] === value)
				{
					arr.splice(i, 1);
				}
			}					
		}
		
		
		public function callService(serviceURL:String,params:Object = null, method:String = "get"):void{
			log("callService serviceURL:"+serviceURL);
			
			var saveRequest:URLRequest = new URLRequest(serviceURL);
			var variables:URLVariables = new URLVariables();
			
			if (method == "get"){
				saveRequest.method = URLRequestMethod.GET;
			}else{
				saveRequest.method = URLRequestMethod.POST;
			}
			
			
			if (params){
				for (var prop in params){
					variables[prop] = params[prop];
				}
				saveRequest.data = variables;
			}
			
			serviceLoader = new URLLoader();
			serviceLoader.addEventListener(Event.COMPLETE, onServiceCalled);
			serviceLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			serviceLoader.load(saveRequest);
			
		}
		
		protected function onServiceCalled(e:Event):void{
			log("onServiceCalled:");
			dispatchEvent(new LoaderUtilsEvent(LoaderUtilsEvent.SERVICE_RESULT, serviceLoader.data));
			serviceLoader.removeEventListener(Event.COMPLETE, onServiceCalled);
			serviceLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			serviceLoader = null;
			
		}
		
		
		
		/***************************************************************
		 * Grid Loaders
		 ***************************************************************/
		
		
		public function loadMCGrid(itemURLs:Array, cellWidth:int, cellHeight:int, gap:int, cols:int):MovieClip{
			var url:String;
			var loader:Loader;
			var urlRequest:URLRequest;
			var loaderItems:Array = new Array();
			for (var i:int=0;i<itemURLs.length;i++){
				url = itemURLs[i];
				loader = new Loader();
				loader.name = "loader_"+i;
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoadComplete);
				urlRequest = new URLRequest(url);
				
				var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
				
				loader.load(urlRequest, loaderContext);
				loaderItems.push(loader);
			}
				
			return getMCGrid(loaderItems, cellWidth, cellHeight, gap, cols);
		}
		
		public function loadGridItems(dataArray:Array, iGridItem:Class, cellWidth:int, cellHeight:int, gap:int, cols:int):MovieClip {
			log("loadGridItems");
			log(dataArray.length);
			
			var url:String;
			var loader:Loader;
			
			var urlRequest:URLRequest;
			var gridItem:IGridItem;
			var gridItems:Array = new Array();
			var gridItemData:GridItemData;
			for (var i:int=0;i<dataArray.length;i++){
				//log(dataArray[i].thumbURL);
				
				gridItemData = dataArray[i] as GridItemData;
				
				//log(gridItemData.data);
				
				url = gridItemData.thumbURL;
				
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoadComplete);
				loaders.push(loader);
				loader.name = "loader_"+i;
				urlRequest = new URLRequest(url);
				var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
				
				gridItem = new iGridItem();
				gridItem.setLoader(loader, urlRequest, loaderContext);
				gridItem.gridItemData = gridItemData;
				
				gridItems.push(gridItem);
			}
				
			return getMCGrid(gridItems, cellWidth, cellHeight, gap, cols);
		}
		
		public function getMCGrid(containerItems:Array, cellWidth:int, cellHeight:int, gap:int, cols:int):MovieClip{
			var mc:MovieClip = new MovieClip();
			
			//log("getMCGrid gap:"+gap);
			
			for (var i:int=0;i<containerItems.length;i++){
				containerItems[i].x = int(i%cols*(cellWidth+gap));
				containerItems[i].y = int(int(i/cols)*(cellHeight+gap));
				mc.addChild(containerItems[i]);
			}
			
			return mc;
			
		}
		
		public function handleIOError(e:IOErrorEvent):void {
			log("handleIOError:"+e.text);
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, handleLoadComplete);
			dispatchEvent(e);
		}
		
		public function handleLoadComplete(e:Event):void {
			//log("onLoadComplete:"+e.target.url);
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, handleLoadComplete);
			dispatchEvent(e);
		}
		
		
		public function destroy():void{
			
		}
		
		
		protected function log(logItem:*,category:Array=null):void{
			if(category==null) category = [this.toString().replace("[object ", "").replace("]", "")];
			Logger.log(logItem,category,true);
		}
		
		
	}
}
