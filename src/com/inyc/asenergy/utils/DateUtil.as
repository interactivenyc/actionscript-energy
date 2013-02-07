package com.inyc.asenergy.utils {
	/**	 * @author stevewarren	 */	public class DateUtil {						public function DateUtil() {		}										/**		* Parses dates that conform to RFC822 into Date objects. This method also		* supports four-digit years (not supported in RFC822), but two-digit years		* (referring to the 20th century) are fine, too.		*		* This function is useful for parsing RSS .91, .92, and 2.0 dates.		*		* @param str		*		* @returns		*		* @langversion ActionScript 3.0		* @playerversion Flash 9.0		* @tiptext		*		* @see http://asg.web.cmu.edu/rfc/rfc822.html		*/				public static function parseFlashStringDate(str:String):Date		{			log("parseRFC822 str:"+str);			            var finalDate:Date;			try			{				var dateParts:Array = str.split(" ");				var day:String = null;								if (dateParts[0].search(/\d/) == -1)				{					day = dateParts.shift().replace(/\W/, "");				}																var datePart = dateParts.shift();				log("calling getShortMonthIndex:"+datePart);								var month:Number = Number(DateUtil.getShortMonthIndex(datePart));				log("month:"+month);								var date:Number = Number(dateParts.shift());								var timeParts:Array = dateParts.shift().split(":");				var hour:Number = int(timeParts.shift());				var minute:Number = int(timeParts.shift());				var second:Number = (timeParts.length > 0) ? int(timeParts.shift()): 0;								var year:Number = Number(dateParts.pop());									var milliseconds:Number = Date.UTC(year, month, date, hour, minute, second, 0);								log("hour:"+hour);				log("minute:"+minute);				log("second:"+second);				log("year:"+year);					var timezone:String = dateParts.shift().split("-")[0];								log("timezone:"+timezone);								var offset:Number = 0;				if (timezone.search(/\d/) == -1)				{					switch(timezone)					{						case "UT":							offset = 0;							break;						case "UTC":							offset = 0;							break;						case "GMT":							offset = (-4 * 3600000);							break;						case "EST":							offset = (-5 * 3600000);							break;						case "EDT":							offset = (-4 * 3600000);							break;						case "CST":							offset = (-6 * 3600000);							break;						case "CDT":							offset = (-5 * 3600000);							break;						case "MST":							offset = (-7 * 3600000);							break;						case "MDT":							offset = (-6 * 3600000);							break;						case "PST":							offset = (-8 * 3600000);							break;						case "PDT":							offset = (-7 * 3600000);							break;						case "Z":							offset = 0;							break;						case "A":							offset = (-1 * 3600000);							break;						case "M":							offset = (-12 * 3600000);							break;						case "N":							offset = (1 * 3600000);							break;						case "Y":							offset = (12 * 3600000);							break;						default:							offset = 0;					}					log("offset:"+offset);				}				else				{					var multiplier:Number = 1;					var oHours:Number = 0;					var oMinutes:Number = 0;					if (timezone.length != 4)					{						if (timezone.charAt(0) == "-")						{							multiplier = -1;						}						timezone = timezone.substr(1, 4);					}					oHours = Number(timezone.substr(0, 2));					oMinutes = Number(timezone.substr(2, 2));					offset = (((oHours * 3600000) + (oMinutes * 60000)) * multiplier);				}				finalDate = new Date(milliseconds - offset);				if (finalDate.toString() == "Invalid Date")				{					throw new Error("This date does not conform to RFC822.");				}			}			catch (e:Error)			{				log("ERROR");				//var eStr:String = "Unable to parse the string [" +str+ "] into a date. ";				//eStr += "The internal error was: " + e.toString();				//throw new Error(eStr);				finalDate = new Date();			}            return finalDate;		}								public static function getShortMonthIndex(value:String):Number{			log("getShortMonthIndex:"+value);						switch(value.toUpperCase()){				case "JAN":					return 0;					break;				case "FEB":					return 1;					break;				case "MAR":					return 2;					break;				case "APR":					return 3;					break;				case "MAY":					return 4;					break;				case "JUN":					return 5;					break;				case "JUL":					return 6;					break;				case "AUG":					return 7;					break;				case "SEP":					return 8;					break;				case "OCT":					return 9;					break;				case "NOV":					return 10;					break;				case "DEC":					return 11;					break;				default:					return 0;					break;							}								}
		
		
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
		}				public static function log(logItem:*,category:Array=null):void{			//if(category==null) category = ["DateUtil"];			//Logger.log(logItem, category, true);		}											}		}