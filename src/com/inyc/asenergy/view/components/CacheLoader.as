package com.inyc.asenergy.view.components
{	
	import com.adobe.images.PNGEncoder;
	import com.inyc.asenergy.controller.AppController;
	import com.inyc.asenergy.utils.debug.Logger;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	/**
	 * This class will cache loaded DisplayObjects to the IOS Application Storage Directory
	 * If a request is made for a cached item it will return it, rather than loading
	 * it again.
	 * 
	 * This class will need rules for when to purge the cached items.
	 **/
	
	public class CacheLoader extends Loader
	{
		public var LOCAL_DIRECTORY:String = "";
		private static var localDirectoryListing:Array;
		public var smoothBitmap:Bitmap;
		private var _saved:Boolean = false;
		
		private var requestURLFilename:String;
		private var requestURLFiletype:String;
		
		private var localFile:File;
		private var localFilename:String;
		private var localFiletype:String;
		
		private var match:Boolean;
		
		
		public function CacheLoader()
		{
			super();
			
		}
		
		public function setLocalDirectory(path:String):void{
			if (path != LOCAL_DIRECTORY){
				LOCAL_DIRECTORY = path;
				var localDirectory:File = File.applicationDirectory.resolvePath( LOCAL_DIRECTORY );
				localDirectoryListing = localDirectory.getDirectoryListing();
			}
		}
		
		
		override public function load(request:URLRequest, context:LoaderContext=null):void{
			
			if (AppController.LOAD_FILES_FROM_CACHE == true){
				
				requestURLFilename = request.url.substr(request.url.lastIndexOf("/") + 1);
				requestURLFiletype = request.url.substr(request.url.lastIndexOf("."));
				
				for (var i:int = 0; i < localDirectoryListing.length; i++) 
				{
					match=false;
					localFile = localDirectoryListing[i];
					localFilename = localFile.url.substr(localFile.url.lastIndexOf("/") + 1).split(".")[0];
					localFiletype = localFile.url.substr(localFile.url.lastIndexOf("."));
					
					if (requestURLFilename.indexOf(localFilename) > -1) match = true;
					
					if(match==true && requestURLFiletype == localFiletype && localFilename.length > 2){
						request.url = LOCAL_DIRECTORY + localFilename + localFiletype;
						log("*** cached: "+requestURLFilename);
						
//						log("match: " + match);
//						log("request.url: " + request.url);
//						log("requestURLFiletype: " + requestURLFiletype + " :: localFiletype: " + localFiletype);
//						log("requestURLFilename: " + requestURLFilename);
						
						_saved = true;
						
					}
				}
			}

			log("load _saved: "+_saved+", url: "+ request.url);
			
			contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
			addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			
			super.load(request, context);
			
			
			
		}
		
		protected function onLoaded(e:Event):void{
			//save graphic to LOCAL_DIRECTORY
			
			if (contentLoaderInfo.contentType.indexOf("image") > -1){
				smoothBitmap = Bitmap(content);
				smoothBitmap.smoothing = true;
			}
			
			//TODO: KEEP WORKING ON THIS. BITMAPS ARE being stored at wrong size - too large.
			//if (_saved == false) saveToCache();
		}
		
		private function saveToCache():void{
			var path:String = LOCAL_DIRECTORY + requestURLFilename;
			
			log("**************************");
			log("saveToCache: contentType: "+contentLoaderInfo.contentType);
			log(path);
			log("**************************");
			
			var storedFile:File;
			var fs:FileStream;
			var bytes:ByteArray;
			
			if (contentLoaderInfo.contentType.indexOf("image") > -1){
								
				storedFile = File.applicationStorageDirectory.resolvePath( path );
				fs = new FileStream();
				fs.open(storedFile, FileMode.WRITE);
				
				var bitmapData:BitmapData = new BitmapData(content.width, content.height, true, 0xffffff);
				bitmapData.draw(content);
				bytes = PNGEncoder.encode(bitmapData);
				
				fs.writeBytes(bytes);
				fs.close();
				
			}else if (contentLoaderInfo.contentType.indexOf("flash") > -1){
				
				storedFile = File.applicationStorageDirectory.resolvePath( path );
				fs = new FileStream();
				fs.open(storedFile, FileMode.WRITE);
				
				bytes = contentLoaderInfo.bytes;
				
				fs.writeBytes(bytes);
				fs.close();
			}
			
			
			
		}
		
		protected function onIOError(e:IOErrorEvent):void{
			trace(this + "onIOError");
			trace(this + e.text);
		}
		
		protected function onSecurityError(event:SecurityError):void{
			trace(this + "onSecurityError");
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


