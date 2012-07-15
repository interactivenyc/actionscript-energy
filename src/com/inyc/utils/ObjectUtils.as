package com.inyc.utils {	import flash.utils.ByteArray;			/**	 * @author stevewarren	 */	public class ObjectUtils {				public static function copy(value:Object):Object		{			var buffer:ByteArray = new ByteArray();			buffer.writeObject(value);			buffer.position = 0;			var result:Object = buffer.readObject();			return result;		}				public static function arrayToObject(arr:Array):Object{			var obj:Object = new Object();			for (var prop in arr){				obj["prop_"+formatNumWithZeroes(prop,3)] = arr[prop];			}			return obj;		}				public static function formatNumWithZeroes(num:*,numPlaces:int):String{			var numString:String = String(num);			while (numString.length < numPlaces){				numString = "0"+numString;			}			return numString;					}				public static function getGenericObject(obj:Object):Object{			trace("getGenericObject");			var objectCopy:Object = copy(obj);						for(var prop in objectCopy){				trace("\t prop:"+prop);			}						return objectCopy;		}				public static function listProps(obj:Object){			trace("listProp value:"+obj);			var copy:Object = copy(obj);			var checkArray:Array = ["Number", "Boolean", "String", "Date", "int"];			for(var prop in copy){				//trace("typeof:"+typeof(copy[prop]));				if (ArrayUtils.arrayContainsValue(checkArray, typeof(copy[prop]))){					trace("\t prop:"+prop+", type:"+typeof(copy[prop])+", value:"+copy[prop]);				}else{					//recurse object					trace("----------------------------------------");					trace("recurse prop:"+prop+", type:"+typeof(copy[prop]));					listProps(obj[prop]);				}			}		}				public static function getObjectFromString(str:String):Object{			var data:Object  = new Object();			var dataArray:Array = str.split("|");			var dataProps:Array;			var propName:String;			var prop:String;			for (var i:int=0; i<dataArray.length; i++){				dataProps = dataArray[i].split(":");				propName = dataProps.shift();				prop = unescape(dataProps.join(":"));				data[propName] = prop;			}						return data;		}				public static function getStringFromObject(obj:Object):String{			var returnString:String="";			for (var prop in obj){				returnString += prop + ":" + obj[prop] + "|";			}						returnString.substr(0,returnString.length-2);						return returnString;					}				public static function compareObject(obj1:Object,obj2:Object):Boolean{		    var buffer1:ByteArray = new ByteArray();		    buffer1.writeObject(obj1);		    var buffer2:ByteArray = new ByteArray();		    buffer2.writeObject(obj2);		 		    // compare the lengths		    var size:uint = buffer1.length;		    if (buffer1.length == buffer2.length) {		        buffer1.position = 0;		        buffer2.position = 0;		 		        // then the bits		        while (buffer1.position < size) {		            var v1:int = buffer1.readByte();		            if (v1 != buffer2.readByte()) {		                return false;		            }		        }    		        return true;                        		    }		    return false;		}  		public static function compareObjectProps(obj1:Object,obj2:Object):Boolean{		    			    	if (typeof(obj1) != typeof(obj2)) return false;		    			    	switch (typeof(obj1)){		    		case "Number":		    		case "Boolean":		    		case "String":		    		case "Date":		    		case "int":		    			if (obj1 != obj2) return false;		    			break;		    		default: //"Object"		    			for (var prop in obj1){		    				return compareObjectProps(obj1[prop],obj2[prop]);		    			}		    	}		    			    return true;		    		}  					}}