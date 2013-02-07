package com.inyc.asenergy.modules.slideshow.loader {	import com.inyc.asenergy.utils.NavUtils;	import com.inyc.asenergy.utils.debug.Logger;		import flash.display.MovieClip;	import flash.events.Event;	import flash.external.ExternalInterface;	import flash.net.URLLoader;	import flash.net.URLRequest;			/**	 * @author stevewarren	 */	public class RootLoader extends MovieClip {		protected var pageparams:Object=loaderInfo.parameters;		protected var rawXML:XML;		protected var _queryVars:Object;				/*************************************		 * Utilities		 *************************************/		 		 protected function initQueryVars():void{			log("initQueryVars()");			var baseURL:String;			baseURL = ExternalInterface.call("parent.window.location.href.toString");			log("baseURL:"+baseURL);			if (baseURL){				_queryVars = NavUtils.getQueryVars(baseURL);			}			log(_queryVars);		}				protected function loadXML(xml_url:String){			//allow override xml_url 			if(_queryVars && _queryVars.xml_url){				xml_url=_queryVars.xml_url;			}else if (pageparams.xml_url!=null) {				xml_url=pageparams.xml_url;			}			var xmlRequest:URLRequest = new URLRequest(xml_url);			var xmlLoader:URLLoader = new URLLoader();			xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);			xmlLoader.load(xmlRequest);		}				protected function xmlLoaded(e:Event):void{			log("xmlLoaded");			var xml:XML = new XML(e.target.data);			rawXML=xml;					}				public function get timeline():MovieClip{			return this;		}		 				protected function log(logItem:*,category:Array=null):void{			if(category==null) category = ["RootLoader"];			Logger.log(logItem,category,true);		}	}}