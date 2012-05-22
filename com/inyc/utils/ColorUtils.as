package com.inyc.utils {
	/**	 * @author stevewarren	 */	public class ColorUtils {								public function ColorUtils() {
		}
		
		
		
		private function RGBToHex(r:uint, g:uint, b:uint):uint{
		    var hex:uint = (r << 16 | g << 8 | b);
		    return hex;
		}
		
		private function HexToRGB(hex:uint):Array{
		    var rgb:Array = [];
		
		    var r:uint = hex >> 16 & 0xFF;
		    var g:uint = hex >> 8 & 0xFF;
		    var b:uint = hex & 0xFF;
		
		    rgb.push(r, g, b);
		    return rgb;
		}
		
		private function RGBtoHSV(r:uint, g:uint, b:uint):Array{
		    var max:uint = Math.max(r, g, b);
		    var min:uint = Math.min(r, g, b);
		
		    var hue:Number = 0;
		    var saturation:Number = 0;
		    var value:Number = 0;
		
		    var hsv:Array = [];
		
		    //get Hue
		if(max == min){
		    hue = 0;
		}else if(max == r){
		    hue = (60 * (g-b) / (max-min) + 360) % 360;
		}else if(max == g){
		    hue = (60 * (b-r) / (max-min) + 120);
		}else if(max == b){
		    hue = (60 * (r-g) / (max-min) + 240);
		}
		
		//get Value
		value = max;
		
		//get Saturation
		if(max == 0){
		    saturation = 0;
		}else{
		    saturation = (max - min) / max;
		}
		
		hsv = [Math.round(hue), Math.round(saturation * 100), Math.round(value / 255 * 100)];
		return hsv;
		
		}
		
		private function HSVtoRGB(h:Number, s:Number, v:Number):Array{
		    var r:Number = 0;
		    var g:Number = 0;
		    var b:Number = 0;
		    var rgb:Array = [];
		
		    var tempS:Number = s / 100;
		    var tempV:Number = v / 100;
		
		    var hi:int = Math.floor(h/60) % 6;
		    var f:Number = h/60 - Math.floor(h/60);
		    var p:Number = (tempV * (1 - tempS));
		    var q:Number = (tempV * (1 - f * tempS));
		    var t:Number = (tempV * (1 - (1 - f) * tempS));
		
		    switch(hi){
		        case 0: r = tempV; g = t; b = p; break;
		        case 1: r = q; g = tempV; b = p; break;
		        case 2: r = p; g = tempV; b = t; break;
		        case 3: r = p; g = q; b = tempV; break;
		        case 4: r = t; g = p; b = tempV; break;
		        case 5: r = tempV; g = p; b = q; break;
		    }
		
		    rgb = [Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)];
		    return rgb;
		}
				
		public static function RGB2HSB(red:Number,green:Number,blue:Number):Object
		{
			var min=Math.min(Math.min(red,green),blue)
			var brightness=Math.max(Math.max(red,green),blue)
			var delta=brightness-min
			var saturation=(brightness == 0) ? 0 : delta/brightness
			var hue
			if(saturation == 0)
			{
				hue=0
			}
			else
			{
				if(red == brightness)
				{
					hue=(60*(green-blue))/delta
				}
				else if(green == brightness)
				{
					hue=120+(60*(blue-red))/delta
				}
				else
				{
					hue=240+(60*(red-green))/delta
				}
				if(hue<0) hue+=360
			}
			saturation*=100
			brightness=(brightness/255)*100
			return {hue:hue,saturation:saturation,brightness:brightness}
		}
			
		
		
		
//		function getObjectByID(id) {
//		  // Cross-browser function to return the object with the specific id
//		  if (document.all) { // IE
//		    return document.all[id];
//		  } else { // Mozilla and others
//		    return document.getElementById(id);
//		  }
//		}
//		
//		function HSVobject (hue, saturation, value) {
//			// Object definition.
//			this.h = hue; 
//			this.s = saturation; 
//			this.v = value;
//			this.validate = function () {
//				if (this.h <= 0) {this.h = 0;}
//				if (this.s <= 0) {this.s = 0;}
//				if (this.v <= 0) {this.v = 0;}
//				if (this.h > 360) {this.h = 360;}
//				if (this.s > 100) {this.s = 100;}
//				if (this.v > 100) {this.v = 100;}
//			};
//		}
//		
//		
//		
//		function RGBobject (red, green, blue) {
//			// Object definition.
//			this.r = red; this.g = green; this.b = blue;
//			this.validate = function () {
//				if (this.r <= 0) {this.r = 0;}
//				if (this.g <= 0) {this.g = 0;}
//				if (this.b <= 0) {this.b = 0;}
//				if (this.r > 255) {this.r = 255;}
//				if (this.g > 255) {this.g = 255;}
//				if (this.b > 255) {this.b = 255;}
//			};
//		}
//		
//		function validate() {
//				if (this.h <= 0) {this.h = 0;}
//				if (this.s <= 0) {this.s = 0;}
//				if (this.v <= 0) {this.v = 0;}
//				if (this.h > 360) {this.h = 360;}
//				if (this.s > 100) {this.s = 100;}
//				if (this.v > 100) {this.v = 100;}
//			};
		
//		function hexify(number) {
//			var digits = '0123456789ABCDEF';
//			var lsd = number % 16;
//			var msd = (number - lsd) / 16;
//			var hexified = digits.charAt(msd) + digits.charAt(lsd);
//			return hexified;
//		}
//		
//		function decimalize(hexNumber) {
//			var digits = '0123456789ABCDEF';
//			return ((digits.indexOf(hexNumber.charAt(0).toUpperCase()) * 16) + digits.indexOf(hexNumber.charAt(1).toUpperCase()));
//		}
//		
//		function hex2RGB (colorString, RGB) {
//			RGB.r = decimalize(colorString.substring(1,3));
//			RGB.g = decimalize(colorString.substring(3,5));
//			RGB.b = decimalize(colorString.substring(5,7));
//		}
//		
//		function RGB2hex (RGB) {
//			return "#" + hexify(RGB.r) + hexify(RGB.g) + hexify(RGB.b);
//		}
//		
//		function rgbChange () {
//			var RGB = new RGBobject(getObjectByID("rChannel").value, getObjectByID("gChannel").value, getObjectByID("bChannel").value);
//			var HSV = new HSVobject(getObjectByID("hChannel").value, getObjectByID("sChannel").value, getObjectByID("vChannel").value);
//			RGB.validate();
//			RGB2HSV (RGB, HSV);
//			getObjectByID("hexColor").value = RGB2hex(RGB);
//			updateSwatch();
//			getObjectByID("rChannel").value = Math.round(RGB.r);
//			getObjectByID("gChannel").value = Math.round(RGB.g);
//			getObjectByID("bChannel").value = Math.round(RGB.b);
//			getObjectByID("hChannel").value = Math.round(HSV.h);
//			getObjectByID("sChannel").value = Math.round(HSV.s);
//			getObjectByID("vChannel").value = Math.round(HSV.v);
//		}
//		
//		function hsvChange () {
//			var RGB = new RGBobject(getObjectByID("rChannel").value, getObjectByID("gChannel").value, getObjectByID("bChannel").value);
//			var HSV = new HSVobject(getObjectByID("hChannel").value, getObjectByID("sChannel").value, getObjectByID("vChannel").value);
//			HSV.validate();
//			HSV2RGB (HSV, RGB);
//			getObjectByID("hexColor").value = RGB2hex(RGB);
//			updateSwatch();
//			getObjectByID("rChannel").value = Math.round(RGB.r);
//			getObjectByID("gChannel").value = Math.round(RGB.g);
//			getObjectByID("bChannel").value = Math.round(RGB.b);
//			getObjectByID("hChannel").value = Math.round(HSV.h);
//			getObjectByID("sChannel").value = Math.round(HSV.s);
//			getObjectByID("vChannel").value = Math.round(HSV.v);
//		}
//		
//		function hexChange () {
//			var colorString = getObjectByID("hexColor").value;
//			var RGB = new RGBobject(0,0,0);
//			var HSV = new HSVobject(0,0,0);
//			hex2RGB(colorString, RGB);
//			RGB2HSV (RGB, HSV);
//			getObjectByID("rChannel").value = Math.round(RGB.r);
//			getObjectByID("gChannel").value = Math.round(RGB.g);
//			getObjectByID("bChannel").value = Math.round(RGB.b);
//			getObjectByID("hChannel").value = Math.round(HSV.h);
//			getObjectByID("sChannel").value = Math.round(HSV.s);
//			getObjectByID("vChannel").value = Math.round(HSV.v);
//		}
//		
//		function updateSwatch () {
//			getObjectByID("swatch").style.backgroundColor = getObjectByID("hexColor").value;
//		}
//		
//		function RGB2HSV (RGB, HSV) {
//			var r = RGB.r / 255;
//			var g = RGB.g / 255;
//			var b = RGB.b / 255; // Scale to unity.
//		
//			var minVal = Math.min(r, g, b);
//			var maxVal = Math.max(r, g, b);
//			var delta = maxVal - minVal;
//		
//			HSV.v = maxVal;
//		
//			if (delta == 0) {
//				HSV.h = 0;
//				HSV.s = 0;
//			} else {
//				HSV.s = delta / maxVal;
//				var del_R = (((maxVal - r) / 6) + (delta / 2)) / delta;
//				var del_G = (((maxVal - g) / 6) + (delta / 2)) / delta;
//				var del_B = (((maxVal - b) / 6) + (delta / 2)) / delta;
//		
//				if (r == maxVal) {HSV.h = del_B - del_G;}
//				else if (g == maxVal) {HSV.h = (1 / 3) + del_R - del_B;}
//				else if (b == maxVal) {HSV.h = (2 / 3) + del_G - del_R;}
//				
//				if (HSV.h < 0) {HSV.h += 1;}
//				if (HSV.h > 1) {HSV.h -= 1;}
//			}
//			HSV.h *= 360;
//			HSV.s *= 100;
//			HSV.v *= 100;
//		}
//		
//		function HSV2RGB (HSV, RGB) {
//			var h = HSV.h / 360; 
//			var s = HSV.s / 100; 
//			var v = HSV.v / 100;
//			
//			if (s == 0) {
//				RGB.r = v * 255;
//				RGB.g = v * 255;
//				RGB.v = v * 255;
//			} else {
//				var var_h = h * 6;
//				var var_i = Math.floor(var_h);
//				var var_1 = v * (1 - s);
//				var var_2 = v * (1 - s * (var_h - var_i));
//				var var_3 = v * (1 - s * (1 - (var_h - var_i)));
//				
//				var var_r;
//				var var_g;
//				var var_b;
//				
//				if (var_i == 0) {var_r = v; var_g = var_3; var_b = var_1}
//				else if (var_i == 1) {var_r = var_2; var_g = v; var_b = var_1}
//				else if (var_i == 2) {var_r = var_1; var_g = v; var_b = var_3}
//				else if (var_i == 3) {var_r = var_1; var_g = var_2; var_b = v}
//				else if (var_i == 4) {var_r = var_3; var_g = var_1; var_b = v}
//				else {var_r = v; var_g = var_1; var_b = var_2};
//				
//				RGB.r = var_r * 255;
//				RGB.g = var_g * 255;
//				RGB.b = var_b * 255;
//			}
//		}
//				
		
		
		
		
		
		
		
		
		
//hue: 0-360
	//saturation: 0-100
	//brightness: 0-100
	public static function hsbtorgb(hue:Number,saturation:Number,brightness:Number):Object
	{
		var red, green, blue
		hue%=360;
		if(brightness==0)
		{
			return {red:0, green:0, blue:0}
		}
		saturation/=100;
		brightness/=100;
		hue/=60;
		var i = Math.floor(hue);
		var f = hue-i;
		var p = brightness*(1-saturation);
		var q = brightness*(1-(saturation*f));
		var t = brightness*(1-(saturation*(1-f)));
		switch(i)
		{
			case 0:
			
				red=brightness; green=t; blue=p;
				break;
			
			case 1:
			
				red=q; green=brightness; blue=p;
				break;
				
			case 2:
			
				red=p; green=brightness; blue=t;
				break;
				
			case 3:
			
				red=p; green=q; blue=brightness;
				break;
				
			case 4:
			
				red=t; green=p; blue=brightness;
				break;
				
			case 5:
			
				red=brightness; green=p; blue=q;
				break;
		}
		red=Math.round(red*255)
		green=Math.round(green*255)
		blue=Math.round(blue*255)
		return {red:red, green:green, blue:blue}
	}

	
	//red: 0-255
	//green: 0-255
	//blue: 0-255
	
	public static function rgbtohsb(red:Number,green:Number,blue:Number):Object
	{
		var min=Math.min(Math.min(red,green),blue)
		var brightness=Math.max(Math.max(red,green),blue)
		var delta=brightness-min
		var saturation=(brightness == 0) ? 0 : delta/brightness
		var hue
		if(saturation == 0)
		{
			hue=0
		}
		else
		{
			if(red == brightness)
			{
				hue=(60*(green-blue))/delta
			}
			else if(green == brightness)
			{
				hue=120+(60*(blue-red))/delta
			}
			else
			{
				hue=240+(60*(red-green))/delta
			}
			if(hue<0) hue+=360
		}
		saturation*=100
		brightness=(brightness/255)*100
		return {hue:hue,saturation:saturation,brightness:brightness}
	}

	//red: 0-255
	//green: 0-255
	//blue: 0-255
	
	public static function rgbtohex24(red:Number,green:Number,blue:Number):Number
	{
		return (red<<16 | green<<8 | blue)
	}
	
	//color: 24 bit base 10 number
	
	public static function hex24torgb(color:Number):Object
	{
		var r=color >> 16 & 0xff
		var g=color >> 8 & 0xFF
		var b=color & 0xFF
		return {red:r,green:g,blue:b}
	}
	
	//alpha: 0-255
	//red: 0-255
	//green: 0-255
	//blue: 0-255
	
	public static function argbtohex32(red:Number,green:Number,blue:Number,alpha:Number):Number
	{
		return (alpha<<24 | red<<16 | green<<8 | blue)
	}
	
	//color: 32 bit base 10 number
	
	public static function hex32toargb(color:Number):Object
	{
		var a=color >> 24 & 0xFF
		var r=color >> 16 & 0xff
		var g=color >> 8 & 0xFF
		var b=color & 0xFF
		return {alpha:a,red:r,green:g,blue:b}
	}
	
	public static function hex24tohsb(color:Number):Object
	{
		var rgb=ColorUtils.hex24torgb(color)
		return ColorUtils.rgbtohsb(rgb.red,rgb.green,rgb.blue)
	}
	
	public static function hsbtohex24(hue:Number,saturation:Number,brightness:Number):Number
	{
		var rgb=ColorUtils.hsbtorgb(hue,saturation,brightness)
		return ColorUtils.rgbtohex24(rgb.red,rgb.green,rgb.blue)
	}
	
	public static function toHexadecimalString(val:Number):String
	{
		return "0x"+val.toString(16).toUpperCase()
	}

			}}