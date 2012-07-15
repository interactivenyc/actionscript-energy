package com.inyc.utils {
	import flash.text.Font;
	import flash.text.TextField;	

	public class TextUtil {
		
		private static var _embed:Boolean = true;
		private static var _fallback:String = "_sans";
		
		public static function get embed():Boolean{
			return _embed;
		}
		public static function set embed(value:Boolean):void{
			_embed = value;
		}
		public static function set fallback(fontName:String):void {
			_fallback = fontName;
		}
		public static function get fallback():String{
			return _fallback;
		}
		//regex that finds and replaces tokens in a string
		public static function replaceTokens(str:String,paramObj:Object) : String{
			//token structure ${tokenName}
			var myRegEx:RegExp = /\$\{([a-zA-Z0-9]+)\}/g;
			return str.replace(myRegEx,function():String{
												return (paramObj[arguments[1]]) ? paramObj[arguments[1]] : "";
												});
		}
		
		public static function formatNumWithZeroes(num:*,numPlaces:int):String{
			var numString:String = String(num);
			while (numString.length < numPlaces){
				numString = "0"+numString;
			}
			return numString;
			
		}
		
		public static function formatToNumLines(tf : TextField, displayNum : int, suffix:String = "...") : void
		{

			var copy:String = tf.text;
			var i:int;
			var showDots:Boolean = (tf.numLines > displayNum) ? true : false;
			var end:String;
			var begin:String;
		
			if(showDots)
			{
				copy = "";
				while(i<displayNum)
				{
					copy += tf.getLineText(i);
					i++;
				}
				end = copy.slice(copy.length-3,copy.length);
				begin = copy.slice(0,copy.length-3);
				
				if(end.indexOf(" ") != -1)
				{
					end = end.slice(0,end.indexOf(" "));	
				}
				copy = begin+end+suffix;
			}
			tf.text = copy;
			
		}

		public static function getAvailableDeviceFont(font_str:String):String{
			var fonts:Array = font_str.split(",");
			var device_fonts:Array = Font.enumerateFonts(true);
			for(var j:uint = 0; j<fonts.length; j++){
				for(var i:uint = 0; i<device_fonts.length; i++){
					if(device_fonts[i].fontName == fonts[j]){
						//match found on user's machine
						//break out of loop and return font name
						return fonts[j];
					}
				}
			}
			//fallback to _sans if no matches are found on user's machine
			return _fallback;
		}
		
		public static function getFontSettings(label:String, fontName:String, embedFont:Boolean = true) : Object{
			var fonts:Array;
			var font:Font;
			var useFont:String;
			var isEmbed:Boolean;
			var whiteSpaceExp : RegExp = /\s/gi;
			var trimmedLabel:String = label.replace(whiteSpaceExp,'');
			fonts = (embedFont) ? Font.enumerateFonts(false) : Font.enumerateFonts(true);
			for(var i:uint = 0; i<fonts.length; i++){
				if(fonts[i].fontName == fontName){
					font = fonts[i];
					break;
				}
			}
			
			//we found a matching font in previous loop
			if(font){
				//we are trying to embed in textfields
				if(embedFont){
					//can the font display the value we want to show?
					//font.hasGlyphs only applies to embedded fonts
					if(font.hasGlyphs(trimmedLabel)){
						//we have successfully found a font that can display our value correctly
						useFont = fontName;
						isEmbed = (embedFont) ? true : false;
					}else{
						//we have a font but it is not capable of displaying our value correctly
						//need to fallback to a system font
						useFont = fallback;
						isEmbed = false;
					}
				//we are not trying to embed in textfields;
				}else{
					useFont = font.fontName;
					isEmbed = false;
				}
			//we could not find a matching font in loop
			}else{
				isEmbed = false;
				useFont = fallback;
			}
			return {embed:isEmbed,font:useFont};
		}
		
		
		
		/*
			Removes all of the white space from both ends of a string
		*/
		public static function trim(str:String):String {
			return ltrim( rtrim(str) );
		}
		
		/*
			Removes all of the white space from the right end of a string
		*/
		public static function rtrim(str:String):String {
			
			var returnStr:String = str;
			while (returnStr.charAt(returnStr.length-1) == " ") {
				returnStr = returnStr.slice(0,returnStr.length-1);
			}
			return returnStr;
		}
		
		
		/*
			Removes all of the white space from the left end of a string
		*/
		public static function ltrim(str:String):String {
			
			var returnStr:String = str;
	
			while (returnStr.charAt(0) == " ") {
				returnStr = returnStr.slice(1,returnStr.length);
			}
			return returnStr;
		}
		
		
		public static function replaceChars(origStr:String, replace:String, withStr:String):String {
			while(origStr.indexOf(replace) > -1){
				origStr = origStr.replace(replace, withStr);
			}
			
			return origStr;
			
		}
	}
}
