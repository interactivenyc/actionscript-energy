package com.inyc.asenergy.view.modals
{
	import com.inyc.asenergy.view.components.DialogButton;
	
	import flash.events.MouseEvent;
	
	public class LogDisplay extends MessageDialog
	{
		private var btn_datasource:DialogButton;
		
		public function LogDisplay(headerText:String, bodyText:String, textButtons:Vector.<DialogButton>=null)
		{
			super(headerText, bodyText, textButtons);
		}
		
		
		override protected function displayText():void{
			if (_headerText != "") header.text = _headerText;
			if (_bodyText != "") body.text = _bodyText;
			body.scrollV = body.maxScrollV;
		
		}
		
		
		override protected function createButtons():void{
			//log("createButtons");
			
			var dialogButton:DialogButton;
			
			for (var i:int=0;i<_dialogButtons.length;i++){
				dialogButton = _dialogButtons[i];
				dialogButton.y = 800;
				
				addChild(dialogButton);
			}
			
			if (_dialogButtons.length == 1){
				_dialogButtons[0].x = 20;
				_dialogButtons[0].setButtonSize(DialogButton.BTN_SIZE_LARGE);
			}else if (_dialogButtons.length == 2){
				_dialogButtons[0].x = 375;
				_dialogButtons[1].x = _dialogButtons[0].x + _dialogButtons[0].width + 20;
				_dialogButtons[1].addEventListener(MouseEvent.CLICK, reset);
			}
			
			btn_datasource = new DialogButton("HOME", goHome);
			btn_datasource.x = _dialogButtons[1].x + _dialogButtons[1].width + 20;
			btn_datasource.y = 800;
			addChild(btn_datasource);
		}
		
		private function goHome():void{
//			_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.SHOW_HOME_SCREEN));
//			_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.CLOSE_MODAL));
		}
		
		
		
		private function reset(e:MouseEvent):void{
			body.text = "";
			//AppController.LOG_OUTPUT = "";
		}
		
		
	}
}