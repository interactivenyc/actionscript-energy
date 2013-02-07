package com.inyc.asenergy.modules.gesture{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	
	
	public class Mgesture extends MovieClip {
		
		
		private var mp1:Point = new Point(0,0);
		private var mp2:Point = new Point(0,0);
		private var mpx:Number = 0;
		private var mpy:Number = 0;
		private var dx:Number = mp2.x-mp1.x;
		private var dy:Number = mp2.y-mp1.y;
		private var amp:Number = 0;
		
		private var pntOrigin:Point = new Point(0,0);

		private var tilearray:Array = [0,0,0,0,0,0,0,0,0];
		private var tilestring:String;
		private var tiledelay:int = 12;
		public var gesture:String = "rest";
		public var motion:String = "rest";
		
		
		private var gestarray:Array=new Array();
		private var maxgest:int = 8;
		
		public function Mgesture(){
			//addEventListener(Event.ENTER_FRAME, update, false, 0, true);
			
		}

		
		public function update(){
			
			updatepoints(false);
			updategestures();
			//readgestures();
			
		}
		
		private function updatepoints(drawpoints:Boolean = false){
		
			
			mp1.x += (((mouseX - mp2.x) - mp1.x ) * .2);
			mp1.y += (((mouseY - mp2.y) - mp1.y ) * .2);
			mp2.x = mouseX;
			mp2.y = mouseY;
			
			amp = Point.distance(mp1, pntOrigin);
		
		
			var gestobj:Object = new Object();
			gestobj.mp = mp1;
			gestobj.amp = amp;
			
			gestarray.push(gestobj);
			if(gestarray.length > maxgest)gestarray.splice(0,1);
		}
		

		
		private function updategestures(){
			var gestint:int = gestarray.length
			//if(gestint > maxgest)gestarray.splice(0,1);
			var ampav:int = 0;
			var xav:int = 0;
			var yav:int = 0;
			var gestobj:Object
			for(var i:int = 0; i<gestint; i++){
				gestobj = gestarray[i];
				ampav +=  gestobj.amp;
				xav += gestobj.mp.x;
				yav += gestobj.mp.y;
			}
			ampav /=gestint;
			xav /=gestint;
			yav /=gestint;
			
			if(xav < 5 && xav > -5)xav = 0;
			if(yav < 5 && yav > -5)yav = 0;
			
			
			
			if( xav == 0 && yav == 0 ){
				tilearray[4]=tiledelay;
				gestarray = new Array();
				motion = "rest";
			}else if( xav < 0 && yav < 0 ){
				tilearray[0]=tiledelay;
				motion = "ul";
			}else if( xav == 0 && yav < 0 ){
				tilearray[1]=tiledelay;
				motion = "u";
			}else if( xav >0 && yav < 0 ){
				tilearray[2]=tiledelay;
				motion = "ur";
			}else if( yav == 0 && xav > 0 ){
				tilearray[5]=tiledelay;
				motion = "r";
			}else if( xav > 0 && yav > 0 ){
				tilearray[8]=tiledelay;
				motion = "dr";
			}else if( xav == 0 && yav > 0 ){
				tilearray[7]=tiledelay;
				motion = "d";
			}else if( xav < 0 && yav > 0 ){
				tilearray[6]=tiledelay;
				motion = "dl";
			}else if( yav == 0 && xav < 0 ){
				tilearray[3]=tiledelay;
				motion = "l";
			}
			
			tilestring="";
			var discotemp:int;
			for(i=0; i<9; i++){
				discotemp = tilearray[i];
				if(discotemp > 0){
					tilestring+=1;
					tilearray[i]--
				}else{
					tilestring+=0;
				}
				
				
			}
			//trace(tilestring);
			switch (tilestring){
				case "111101111":
				case "111001111":
				case "111100111":
				case "011101110":
				case "111101110":
				case "011101111":
				case "100010000":
				case "110010000":
				case "111010000":
				case "000010001":
				case "000010011":
				case "000010111":
				case "110101011":
					gesture = "circle";
					break;
					
				case "010010010":
				case "010000010":
					gesture = "vertical";
					break;
					
				case "000111000": 
				case "000101000": 
					gesture = "horizontal";
					break;
					
				case "100010001":
				case "110010011":
				case "100011001":
				case "100110001":
				case "110010001":
				case "100010011":
					gesture = "diagleft";
					break;
					
				case "001010100":
				case "001000100":
				case "011010110":
				case "001010110":
				case "011010100":
				case "011110100":
				case "001011110":
					gesture = "diagright";
					break;
					
				case "000010000":
					gesture = "rest";
					break;
			}
		
		}
		
		private function readgestures(){
			if(gesture!="rest")trace(gesture)
		}
		
	}
	
}
