package com.inyc.asenergy.utils {
	/**
		
		
		public static function getElapsedTime(start:Date, end:Date = null):String{
			if (end == null) end = new Date();
			return(convertSecondsToHMS(Math.floor(end.time - start.time)/1000));
		}
		
		public static function convertSecondsToHMS(totalSeconds:int):String{
			//This function should discard days (untested)
			//log("convertSecondsToHMS totalSeconds:"+totalSeconds);
			var tempprefix:String="";
			if (totalSeconds < 0){
				totalSeconds *= -1;
				tempprefix = "-";
			}
			
			var hours:int = Math.floor((totalSeconds/3600)%24);
			var hourString = hours < 10 ? "0" + hours : hours;
			var mins:int = Math.floor((totalSeconds/60)%60);
			var minString = mins < 10 ? "0" + mins : mins;
			var secs:int = Math.floor(totalSeconds%60);
			var secString = secs < 10 ? "0" + secs : secs;
			
			return tempprefix + hourString + ":" + minString + ":" + secString;
			
		}
		
		public static function convertHMStoMS(hms:String):int{
			var hmsArray:Array = hms.split(":");
			var h:int = int(hmsArray[0]) * 60 * 60 * 1000;
			var m:int = int(hmsArray[1]) * 60 * 1000;
			var s:int = int(hmsArray[2]) * 1000;
			
			var ms:int = h + m + s;
			
			//log("convertHMStoMS: "+hms+"="+ms);
			
			return ms;
		}
		
		public static function two(x) {return ((x>9)?"":"0")+x}
		public static function three(x) {return ((x>99)?"":"0")+((x>9)?"":"0")+x}
		
		public static function convertMSToHMS(ms):String {
			if (ms < 0) ms *= -1;
			
			var sec = Math.floor(ms/1000);
			ms = ms % 1000;
			//var t = three(ms); --Milliseconds
			
			var min = Math.floor(sec/60);
			sec = sec % 60;
			//t = two(sec) + ":" + t;
			var t = two(sec);
			
			var hr = Math.floor(min/60);
			min = min % 60;
			t = two(min) + ":" + t;
			
			var day = Math.floor(hr/60);
			hr = hr % 60;
			t = two(hr) + ":" + t;
			//t = day + ":" + t; --Days
			
			return t;
		}
		
		public static function getSimpleTimeDisplay(date:Date):String{
			return two(date.hours) + ":" + two(date.minutes) + ":" +two(date.seconds);
		}
		
		public static function getDateFromHMS(time:String):Date{
			//parses HH:MM:SS
			log("time from server: " + time)
			var theDate = new Date();
			var timeArray:Array = time.split(":");
			theDate.setHours(int(timeArray[0]), int(timeArray[1]), int(timeArray[2]), 00);
			return theDate;
		}