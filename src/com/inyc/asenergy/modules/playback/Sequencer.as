package com.inyc.asenergy.modules.playback {	import com.allthingsmedia.schneiderelectric.KioskController;		import com.inyc.asenergy.core.Config;		import com.inyc.asenergy.utils.DateUtil;		import com.inyc.asenergy.events.Events;			import flash.events.TimerEvent;		import flash.utils.Timer;			import com.inyc.asenergy.data.SequencerData;		import com.inyc.asenergy.events.GenericDataEvent;		import com.inyc.asenergy.utils.debug.Logger;		import flash.display.MovieClip;		import flash.events.Event;			/**	 * @author stevewarren	 */	public class Sequencer extends MovieClip {		private var _data:SequencerData;		private var _dataIndex:int = 0;		private var _startTime:Date;				private var timeleft:int;		private var elapsedTime:int;		private var timeStampString:String;		private var dataEvent:GenericDataEvent;		private var lastTime:int;				private var timer:Timer;		public function Sequencer(){					}						public function setData(pData:SequencerData):void{			log("setData");			_data = pData;					}								public function start(startTime:Date=null):void{			log("start sequence");						if (startTime==null) {				_startTime = now;			}else{				_startTime = startTime;			}						log("_startTime:"+_startTime);						elapsedTime = now.time - _startTime.time;						//IF PROGRAM HAS ALREADY STARTED, SKIP TO THE CORRECT PART OF THE TIMELINE			for (var i=0;i<_data.array.length;i++){				_dataIndex = i;				if ((elapsedTime < _data.array[i].time)) break;							}						log("start sequence AT dataIndex:"+_dataIndex);						//addEventListener(Event.ENTER_FRAME, checkSequence);			timer = new Timer(1000);			timer.addEventListener(TimerEvent.TIMER, checkSequence);			timer.start();					}								public function stopSequence():void{			log("stopSequence");			//removeEventListener(Event.ENTER_FRAME, checkSequence);						timer.stop();			timer.removeEventListener(TimerEvent.TIMER, checkSequence);			timer = null;						var dataEvent:GenericDataEvent = new GenericDataEvent(Events.SEQUENCER_FINISHED);			dispatchEvent(dataEvent);			dispatchTimeStampEvent("SHOW'S OVER");		}				public function getTimeLeft():int{			//log("time left: " + timeleft)			return timeleft;		}				public function getTimePassed():int{			log("getTimePassed now:"+now + ", _startTime:"+_startTime);			elapsedTime = now.time - _startTime.time;			var timepassed:int = elapsedTime - lastTime;			log("timepassed: " + timepassed)			return timepassed;		}						private function checkSequence(e:Event):void{			//if(_data.array[_dataIndex]==null)return;			//log("checkSequence: " + _dataIndex);			var rightNow:Date = now;			elapsedTime = rightNow.time - _startTime.time;			if (_data.array[_dataIndex] == null) {				dispatchTimeStampEvent("SHOW'S OVER");				return;			}												var timeStamp:Object = new Object();			timeStamp.time = String(DateUtil.getSimpleTimeDisplay(rightNow));			timeStamp.elapsed = DateUtil.getElapsedTime(_startTime, rightNow);			timeStamp.nextEvent = DateUtil.convertMSToHMS(timeleft);									//timeStampString = String(DateUtil.getSimpleTimeDisplay(rightNow) + "  --  " + DateUtil.getElapsedTime(_startTime, rightNow) + " -- " + DateUtil.convertMSToHMS(timeleft));			dispatchTimeStampEvent(timeStamp);						if(elapsedTime > 0 && elapsedTime >= _data.array[_dataIndex].time){				//DATA POINT ARRIVED								log("DATA POINT elapsedTime:" + Math.floor(elapsedTime/1000) + " time:"+int(_data.array[_dataIndex].time)/1000);				log(_data.array[_dataIndex]);								dataEvent = new GenericDataEvent(Events.SEQUENCER_EVENT);				dataEvent.data = _data.array[_dataIndex];				dispatchEvent(dataEvent);				lastTime = _data.array[_dataIndex].time;				_dataIndex ++;				if (_dataIndex == _data.array.length) stopSequence(); 				rightNow = now;				elapsedTime = rightNow.time - _startTime.time;				//timeleft = _data.array[_dataIndex].time - elapsedTime;			}			if (timer) timeleft = _data.array[_dataIndex].time - elapsedTime;			//log("timeleft: " + timeleft);					}				public function ff(fftime:int = 5000){			_startTime.time-=fftime;		}				public function getFutureEvent(steps:int){			trace("future events: " + _dataIndex)			var index:int = _dataIndex;			return _data.array.slice(index,(index + steps));		}				public function getCurrentEvent(){			var index:int = _dataIndex;			return _data.array[_dataIndex-1];		}				public function get now():Date{			return KioskController.getInstance().getUpdatedServerTime();		}				public function get elapsed():int{			return elapsedTime;		}				private function dispatchTimeStampEvent(timeStamp:Object){			dispatchEvent(new GenericDataEvent(Events.SEQUENCER_TIME_STAMP, {timeStamp:timeStamp}));		}		protected function log(logItem:*,category:Array=null):void{			if(category==null) category = [this.toString().replace("[object ", "").replace("]", "")];			Logger.log(logItem,category,true);		}	}}