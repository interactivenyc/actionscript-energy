package com.inyc.asenergy.view.modals {
	
	
	import com.inyc.asenergy.events.AppEvents;
	import com.inyc.asenergy.events.GenericDataEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import com.inyc.asenergy.view.components.DialogButton;
	
	/**
	 * @author stevewarren
	 */
	
	
	/**
	 *  [USAGE] Present user with a message dialog with multiple choices
	 * 
	 *  var buttons:Vector.<DialogButton> = new Vector.<DialogButton>
	 *	var button:DialogButton = new DialogButton("Subscribe", showSubscribe);
	 *	buttons.push(button);
	 *	button = new DialogButton("Continue", doNotSubscribe);
	 *	buttons.push(button);
	 * 
	 *  messageDialog = new MessageDialog("New User", "Would you like to subscribe to our service, or continue your free trial?", buttons);
	 *	_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.SHOW_MESSAGE_DIALOG, {messageDialog:messageDialog}));
	 **/
	
	
	public class MessageDialog extends CoreModal {
		
		public var header:TextField;
		public var body:TextField;
		public var dialogButton:DialogButton;
		public var bg:MovieClip;
		
		protected var _headerText:String;
		protected var _bodyText:String;
		
		protected var _dialogButtons:Vector.<DialogButton>;
		
		protected var _action:String;
		
		public function MessageDialog(headerText:String, bodyText:String, textButtons:Vector.<DialogButton> = null) {			
			//log("CONSTRUCTOR");
			_headerText = headerText;
			_bodyText = bodyText;
			_dialogButtons = textButtons;
			if (_dialogButtons == null){
				
				_dialogButtons = new Vector.<DialogButton>();
				
				/**
				 * Registers button with CoreModal to respond to RETURN KeyboardEvent
				 **/
				_defaultButton = new DialogButton("OK");
				_dialogButtons.push(_defaultButton);
				
			}
		}
		
		override protected function onAddedToStage(e:Event):void{
			super.onAddedToStage(e);
			
			displayText();
			createButtons();
		}
		
		override protected function onRemovedFromStage(e:Event):void{
			super.onRemovedFromStage(e);
		}
		
		public function set defaultButton(btn:DialogButton):void{
			_defaultButton = btn;
		}
		
		
		protected function displayText():void{
			if (_headerText != "") header.text = _headerText;
			if (_bodyText != "") body.text = _bodyText;
			
			if (body.textHeight > 100){
				var increase:int = body.textHeight - 50;
				if (increase > 300) increase = 300;
				bg.height += increase;
				
				body.height += increase + 20;
				
				this.y = 15;
			}
		}
		
		protected function createButtons():void{
			//log("createButtons");
			
			var dialogButton:DialogButton;
			
			for (var i:int=0;i<_dialogButtons.length;i++){
				dialogButton = _dialogButtons[i];
				dialogButton.y = bg.height - 100;
				
				addChild(dialogButton);
			}
			
			if (_dialogButtons.length == 1){
				_dialogButtons[0].x = 20;
				_dialogButtons[0].setButtonSize(DialogButton.BTN_SIZE_LARGE);
			}else if (_dialogButtons.length == 2){
				_dialogButtons[0].x = 20;
				_dialogButtons[1].x = 182;
			}
		}
		
		
		
		override protected function onButtonClick(e:GenericDataEvent):void{
			if (e.data.button && e.data.button.parent != this) return;
			_eventDispatcher.removeEventListener(AppEvents.BUTTON_CLICK, onButtonClick);
			_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.DIALOG_BUTTON_CLICK, {dialogButton:e.data.button}));
			
		}
		
		
		
		
		override public function destroy():void {
			
		}
		
	}
}


