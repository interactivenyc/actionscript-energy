﻿package com.inyc.draw{	import com.inyc.asenergy.controller.AppController;	import com.inyc.asenergy.events.AppEvents;	import com.inyc.asenergy.events.GenericDataEvent;	import com.inyc.asenergy.utils.MovieClipUtils;	import com.inyc.asenergy.view.components.DialogButton;	import com.inyc.asenergy.view.modals.CoreModal;	import com.inyc.asenergy.view.modals.LogDisplay;	import com.inyc.asenergy.view.modals.MessageDialog;		import flash.display.MovieClip;	import flash.events.Event;	import flash.events.MouseEvent;
	public class DrawController extends AppController	{		private var _canvas:MovieClip;				public function DrawController(){			log("constructor");		}				override protected function onAddedToStage(e:Event):void {			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);			init();		}				override protected function onRemovedFromStage(e:Event):void {			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);		}				protected function init():void{			log("init");						addEventListeners();			drawCanvas();			showLoaderMC();			initServices();		}				private function addEventListeners():void{						_eventDispatcher.addEventListener(AppEvents.SHOW_LOADER, receiveEvent);			_eventDispatcher.addEventListener(AppEvents.HIDE_LOADER, receiveEvent);			_eventDispatcher.addEventListener(AppEvents.SHOW_MODAL, receiveEvent);			_eventDispatcher.addEventListener(AppEvents.CLOSE_MODAL, receiveEvent);			_eventDispatcher.addEventListener(AppEvents.SHOW_MESSAGE_DIALOG, receiveEvent);			_eventDispatcher.addEventListener(AppEvents.DIALOG_BUTTON_CLICK, receiveEvent);		}				private function removeEventListeners():void{		}				private function drawCanvas():void{			log("drawCanvas");			_canvas = new MovieClip();			_viewContainer.addChild(_canvas);						var bg:MovieClip = MovieClipUtils.getFilledMC(1200,900,0xF6EEEE);			_canvas.addChild(bg);								}								private function initServices():void{			log("initServices");			var messageDialog:MessageDialog = new MessageDialog("message","hello world");			_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.SHOW_MESSAGE_DIALOG, {messageDialog:messageDialog}));		}																						/*********************************************************************		 * EVENT HANDLING		 *********************************************************************/								private function receiveEvent(e:GenericDataEvent):void{			log("receiveEvent type:"+e.type);			//log(e.data);						var messageDialog:MessageDialog			var modal:CoreModal;			var i:int;						switch(e.type){								//APPLICATION EVENTS				case AppEvents.SHOW_LOADER:					showLoaderMC();					break;								case AppEvents.HIDE_LOADER:					closeTopModal();					break;								case AppEvents.SHOW_MODAL:					showModal(e.data.modal);					break;								case AppEvents.CLOSE_MODAL:					closeTopModal();					break;								case AppEvents.SHOW_MESSAGE_DIALOG:					//closeMessageModals();					modal = e.data.messageDialog as MessageDialog;					showModal(modal);					break;								case AppEvents.DIALOG_BUTTON_CLICK:					var dialogButton:DialogButton = e.data.dialogButton as DialogButton;										if (dialogButton.callback != null) {						dialogButton.callback();					}else{						closeTopModal();					}										break;							}		}					}}