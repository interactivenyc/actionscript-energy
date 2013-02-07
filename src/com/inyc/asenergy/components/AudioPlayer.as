package com.inyc.asenergy.components {
	import com.greensock.TweenLite;		import flash.events.Event;	import flash.media.Sound;	import flash.media.SoundChannel;	import flash.media.SoundLoaderContext;	import flash.media.SoundMixer;	import flash.media.SoundTransform;	import flash.net.URLRequest;	import flash.utils.ByteArray;	import flash.utils.getDefinitionByName;		/**
	 * @author stevewarren
	 */
	public class AudioPlayer {
		private var _volume:Number = 1;
		private var _soundChannels:Array;
		private var _soundNames:Array;
		private var _sounds:Array;
		
		private var _tweenArray:Array;

		public function AudioPlayer(){
			log("CONSTRUCTOR");
			init();
		}
		
		private function init(){
			_soundChannels = new Array();
			_soundNames = new Array();
			_sounds = new Array();
			_tweenArray = new Array();
			
			//playInternalSound("music0",0,4);
		}
		
		
		/**
		 * 
		 * Public functions (API)
		 * 
		 */
		
		public function playInternalSound(soundfile:String, loops:uint = 0, fadeTime:Number = 0):Sound{
			//log("AudioPlayer playInternalSound() soundfile:"+soundfile + ", fadeTime:"+fadeTime);
			
			var musicfile:Class = getDefinitionByName(soundfile) as Class;
			var sound:Sound = new musicfile();
			var st:SoundTransform = new SoundTransform(_volume);
			
			playSound(sound, soundfile, loops, fadeTime);
			return sound;
		}
		
		public function playExternalSound(soundURL:String, loops:uint = 0, fadeTime:Number = 0, checkLoaderContext:Boolean = false):Sound{
			//log("AudioPlayer playExternalSound() soundURL:"+soundURL);
			
			var url:URLRequest = new URLRequest(soundURL);
			var slc:SoundLoaderContext = new SoundLoaderContext(1000, checkLoaderContext);
			var sound:Sound = new Sound(url, slc);
			
			playSound(sound, soundURL, loops, fadeTime);
			return sound;
		}
		
		public function playSound(sound:Sound, soundName:String, loops:uint = 0, fadeTime:Number = 0){
			//log("AudioPlayer playSound() soundfile:"+soundName + ", fadeTime:"+fadeTime);
			
			var st:SoundTransform = new SoundTransform(0);
			var sc:SoundChannel = sound.play(10,loops,st);
			
			var tween = TweenLite.to(st, fadeTime, {volume:_volume, onUpdate:fadeSound, onUpdateParams:[sc,st], onComplete:removeTween, onCompleteParams:[tween]});
			//var tween = TweenLite.to(st, fadeTime, {volume:_volume, onComplete:function(){log("tweenComplete")}});
			
			_soundChannels.push(sc);
			_soundNames.push(soundName);
			_sounds.push(sound);
			_tweenArray.push(tween);
			
			sc.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
		}
		
		
		public function stopSound(soundName:String, fadeTime:Number = 0){
			//log("stopSound sound:"+soundName+", fadeTime:"+fadeTime);
			var sc:SoundChannel = _soundChannels[_soundNames.lastIndexOf(soundName)];
			
			//log(sc);
			
			var st:SoundTransform = new SoundTransform(_volume);
			
			var tween = TweenLite.to(st, fadeTime, {volume:0, onUpdate:fadeSound, onUpdateParams:[sc,st], onComplete:stopSoundAfterTween, onCompleteParams:[soundName, tween]});
			//var tween = TweenLite.to(st, fadeTime, {volume:0, onComplete:stopSoundAfterTween(soundName)});
			
			_tweenArray.push(tween);
			
		}
		
//		public function stopAllSounds() {
//			var tempint:int = _soundNames.length;
//			for(var i:int = 0; i<tempint; ++i){
//				stopSound(_soundNames[i],5);
//			}
//			//SoundMixer.stopAll();
//			
//		}
		
		public function stopAllSounds(time:Number = 0){
			var tempint:int = _soundChannels.length;
			var sc:SoundChannel;// = _soundChannels[_soundNames.lastIndexOf(soundName)];
			
			//log(sc);
			
			var st:SoundTransform = new SoundTransform(_volume);
			
			
			for(var i:int = 0; i<tempint; i++){
				sc = _soundChannels[i];
				var tween  = TweenLite.to(st, time, {volume:0, onUpdate:fadeSound, onUpdateParams:[sc,st], onComplete:stopSoundAfterTween, onCompleteParams:[sc, tween]});
				_tweenArray.push(tween);
			};
			
			//var tween = TweenLite.to(st, fadeTime, {volume:0, onComplete:stopSoundAfterTween(soundName)});
			
			
			
		}

		private function fadeSound(sc:SoundChannel, st:SoundTransform){
			//log("fadeSound");
			if (!sc || !st) return;
			sc.soundTransform = st;
		}
		
		private function removeTween(t:TweenLite){
			//log("removeTween:"+t);
			
			if (t) t.complete();
			//log("_tweenArray:"+_tweenArray);
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
			//log(e.target);
			//log(_soundChannels.lastIndexOf(e.target));
			
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
		
		private function stopSoundAfterTween(sc:SoundChannel, tween:TweenLite){
			//log("stopSoundAfterTween() soundName:"+soundName);
			
			removeSoundByChannel(sc);
			removeTween(tween);
		}
		
		public function getSpectrum(e:Event = null):ByteArray{

				var ba:ByteArray = new ByteArray();
				SoundMixer.computeSpectrum(ba,true,0);
				return ba;
	
			
		} 
		
		
		private function log(msg){
			trace("[AudioPlayer] " + msg);
		}
		
		
	}
}
