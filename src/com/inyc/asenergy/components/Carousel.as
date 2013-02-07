package com.inyc.asenergy.components {
	import com.inyc.asenergy.core.CoreMovieClip;	import com.inyc.asenergy.events.Events;	import com.inyc.asenergy.events.GenericDataEvent;	import com.inyc.asenergy.utils.MovieClipUtils;		import flash.display.MovieClip;	import flash.display.SimpleButton;	import flash.events.Event;		
	/**	 * @author stevewarren	 */	public class Carousel extends CoreMovieClip {
		private var _data:XMLList;
		private var _itemArray:Array = new Array();
		private var _libraryMCName:String;
		
		public var btn_prev:SimpleButton;
		public var btn_next:SimpleButton;
		public var maskMC:MovieClip;
		public var container:MovieClip;
		
		private var _hpadding:int = 5;
		
		public function Carousel() {
			//log("constructor");
		}
		
		public function setLibraryMCName(libraryMCName:String){
			log("setLibraryMCName:"+libraryMCName);
			_libraryMCName = libraryMCName;
		}
		
		public function setData(data:XMLList, hpadding:int = 0){
			log("setData");
			_data = null;
			_data = data;
			if (hpadding > 0) _hpadding = hpadding;
			
		}
		
		public function update(){
			while (_itemArray.length > 0){
				var item:CarouselItem = _itemArray.shift() as CarouselItem;
				container.removeChild(item);
				item.destroy();
			}
			setupItems();
		}
		
		override protected function init():void{
			setupItems();
			//stage.dispatchEvent(new GenericDataEvent(Events.CAROUSEL_ITEM_CLICKED, {carousel:this, carouselItem:_itemArray[0]}));
		}

		
		protected function setupItems():void{
			//log("setupItems");
			if (_data == null) return;
			
			var carouselItem:CarouselItem;
			
			for (var i:int=0; i<_data.length(); i++) {
				log(_data[i].@name);
				
				carouselItem = MovieClipUtils.getLibraryMC(_libraryMCName) as CarouselItem;
				
				carouselItem.setData(_data[i] as XML);
				carouselItem.addEventListener(BasicButton.EVENT_CLICK, onItemClicked);
				
				_itemArray.push(carouselItem);
				
				if (i>0){
					_itemArray[i].x = _itemArray[i-1].x +  _itemArray[i-1].width + _hpadding;
				}
				
				container.addChild(carouselItem);
			}
			
		}
		
		protected function onItemClicked(e:Event):void{
			log("onItemClicked:"+e.target);
			
			var carouselItem:CarouselItem = e.target as CarouselItem;
			stage.dispatchEvent(new GenericDataEvent(Events.CAROUSEL_ITEM_CLICKED, {carousel:this, carouselItem:carouselItem}));
		}
		
		public function selectItem(carouselItem:CarouselItem){
			for (var i:int=0; i<_itemArray.length; i++) {
				_itemArray[i].selected = false;
			}
			
			carouselItem.selected = true;
			
		}
		
		public function get itemArray():Array{
			return _itemArray;
		}
	}}