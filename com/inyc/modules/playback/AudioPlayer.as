package com.inyc.modules.playback {
	import flash.display.MovieClip;	
	import flash.events.EventDispatcher;	
	
	import gs.TweenLite;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;		
	/**
	 * @author stevewarren
	 */
	public class AudioPlayer extends MovieClip {
		private var _volume:Number = 1;
		private var _soundChannels:Array;
		private var _soundNames:Array;
		private var _sounds:Array;
		
		private var _tweenArray:Array;
		
		public static var EVENT_SOUND_STARTED:String = "EVENT_SOUND_STARTED";
		public static var EVENT_SOUND_FINISHED:String = "EVENT_SOUND_FINISHED";

		public function AudioPlayer(){
			//log("CONSTRUCTOR");
			init();
		}
		
		private function init(){
			_soundChannels = new Array();
			_soundNames = new Array();
			_sounds = new Array();
			_tweenArray = new Array();
		}
		
		
		/**
		 * 
		 * Public functions (API)
		 * 
		 */
		
		public function playInternalSound(soundfile:String, loops:uint = 0, fadeTime:Number = 0, startTime:Number = 0):Sound{
			//log("AudioPlayer playInternalSound() soundfile:"+soundfile + ", fadeTime:"+fadeTime);
			
			var musicfile:Class = getDefinitionByName(soundfile) as Class;
			var sound:Sound = new musicfile();
			//var st:SoundTransform = new SoundTransform(_volume);
			
			addEventListener(Event.ENTER_FRAME, checkSoundStart);
			
			playSound(sound, soundfile, startTime, loops, fadeTime);
			return sound;
		}
		
		public function playExternalSound(soundURL:String, loops:uint = 0, fadeTime:Number = 0, startTime:Number = 10):Sound{
			//log("AudioPlayer playExternalSound() soundURL:"+soundURL);
			
			var url:URLRequest = new URLRequest(soundURL);
			var slc:SoundLoaderContext = new SoundLoaderContext(1000);
			var sound:Sound = new Sound(url, slc);
			
			playSound(sound, soundURL, startTime, loops, fadeTime);
			
			//used for checking to see when a streaming sound actually starts, after it's been buffered
			addEventListener(Event.ENTER_FRAME, checkSoundStart);
			
			return sound;
		}
		
		public function playSound(sound:Sound, soundName:String, startTime:Number, loops:uint = 0, fadeTime:Number = 0){
			//log("AudioPlayer playSound() soundfile:"+soundName + ", fadeTime:"+fadeTime);
			
			var st:SoundTransform = new SoundTransform(0);
			var sc:SoundChannel = sound.play(startTime,loops,st);
			
			var tween = TweenLite.to(st, fadeTime, {volume:_volume, onUpdate:fadeSound, onUpdateParams:[sc,st], onComplete:removeTween, onCompleteParams:[tween]});
			//var tween = TweenLite.to(st, fadeTime, {volume:_volume, onComplete:function(){log("tweenComplete")}});
			
			_soundChannels.push(sc);
			_soundNames.push(soundName);
			_sounds.push(sound);
			_tweenArray.push(tween);
			
			sc.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			
		}
		
		private function checkSoundStart(e:Event){
			//log("checkSoundStart");
			if (_soundChannels[_soundChannels.length-1].position > 0){
				removeEventListener(Event.ENTER_FRAME, checkSoundStart);
				//log("SOUND HAS STARTED");
				dispatchEvent(new Event(EVENT_SOUND_STARTED));
			}
		}
		

		
		public function stopSound(soundName:String, fadeTime:Number = 0){
			//log("stopSound sound:"+soundName+", fadeTime:"+fadeTime);
			
			if (_soundNames.lastIndexOf(soundName) < 0) return;
			
			var sc:SoundChannel = _soundChannels[_soundNames.lastIndexOf(soundName)];
			var st:SoundTransform = new SoundTransform(_volume);
			
			var tween = TweenLite.to(st, fadeTime, {volume:0, onUpdate:fadeSound, onUpdateParams:[sc,st], onComplete:stopSoundAfterTween, onCompleteParams:[soundName, tween]});
			
			_tweenArray.push(tween);
		}
		
		public function stopAllSounds() {
			SoundMixer.stopAll();
			killTweens();
		}

		private function fadeSound(sc:SoundChannel, st:SoundTransform){
			//log("fadeSound");
			if (!sc || !st) return;
			sc.soundTransform = st;
		}
		
		private function removeTween(t:TweenLite){
			if (t) t.complete();
		}
		
		public function killTweens(){
			while (_tweenArray.length > 0){
				var tween:TweenLite = _tweenArray.shift();
				tween.complete();
				tween = null;
			}
		}
		
		public function getSoundChannelByName(name:String):SoundChannel{
			var sc:SoundChannel = _soundChannels[_soundNames.lastIndexOf(name)];
			return sc;
		}
		
		public function getSoundByName(name:String):Sound{
			var sound:Sound = _sounds[_soundNames.lastIndexOf(name)];
			return sound;
		}
		
		
		
		public function removeSoundByName(name:String){
			//log("removeSoundByName() name:"+name);
			var index:int = _soundNames.lastIndexOf(name);
			if (index > -1){
				(_soundChannels[index] as SoundChannel).stop();
				_soundChannels.splice(index,1);
				_soundNames.splice(index,1);
				_sounds.splice(index,1);
			}
		}
		
		
		public function get volume():Number{
			return _volume;
		}
		
		
		public function set volume(pVolume:Number){
			_volume = pVolume;
			for (var i=0;i<_soundChannels.length;i++){
				(_soundChannels[i] as SoundChannel).soundTransform = new SoundTransform(_volume);
			}
		}
		
		
		/**
		 * 
		 * Private functions
		 * 
		 */
		 
		
		
		private function onSoundComplete(e:Event){
			//log("onSoundComplete()");
			removeSoundByChannel(e.target as SoundChannel);
		}
		
		
		private function removeSoundByChannel(sc:SoundChannel){
			var index:int = _soundChannels.lastIndexOf(sc);
			if (index > -1){
				sc.stop();
				_soundChannels.splice(index,1);
				_soundNames.splice(index,1);
			}
		}
		
		private function stopSoundAfterTween(soundName:String, tween:TweenLite){
			//log("stopSoundAfterTween() soundName:"+soundName);
			
			removeSoundByName(soundName);
			removeTween(tween);
		}
		
		
		private function log(msg){
			//trace("[AudioPlayer] " + msg);
		}
		
		
	}
}
