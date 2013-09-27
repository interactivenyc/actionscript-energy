package com.inyc.asenergy.view.components
{
	import com.greensock.TweenLite;
	import com.inyc.asenergy.events.GenericDataEvent;
	import com.inyc.asenergy.events.VideoEvents;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.events.StageVideoEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.StageVideo;
	import flash.media.StageVideoAvailability;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.text.TextField;
	
	public class VideoPlayer extends CoreMovieClip
	{
		private var stageVideoAvail:Boolean;
		private var sv:StageVideo;
		private var video:Video;
		
		private var nc : NetConnection;
		private var ns : NetStream;
		
		private var videoFile:String
		private var videoPaused : Boolean = false;
		
		private var pauseScreen:Shape;
		
		private var _videoWidth:int;
		private var _videoHeight:int;
		
		public function VideoPlayer(file:String, videoWidth:int, videoHeight:int)
		{
			super();
			videoFile = file;
			_videoWidth = videoWidth;
			_videoHeight = videoHeight;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event):void
		{
			log("init");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			nc = new NetConnection();
			nc.connect(null);
			
			ns = new NetStream(nc);
			ns.client = this;
			ns.addEventListener(NetStatusEvent.NET_STATUS, onVideoStatusHandler, false, 0, true);
			
			stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onAvail, false, 0, true);		
			
			//this.addEventListener(MouseEvent.CLICK, onVideoClick);
		}
		
		private function onAvail(event:StageVideoAvailabilityEvent):void
		{
			stage.removeEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onAvail);	
			stageVideoAvail = (event.availability == StageVideoAvailability.AVAILABLE);
			initVideo();
			
			this.mouseEnabled = true;
			this.addEventListener(MouseEvent.CLICK, onVideoClick, false, 0, true);			
			
			/*
			var _tf:TextField = new TextField ( );
			_tf.height = stage.stageHeight ;
			_tf.width = stage.stageWidth ;
			_tf.mouseWheelEnabled = true ; 
			_tf.multiline = true ; 
			_tf.wordWrap = true ; 
			addChild(_tf);
			_tf.text = "STAGEVIDEO AVAILABLE = " + String(stageVideoAvail);
			*/
		}
		
		private function initVideo():void
		{
			log("initVideo");
			if (stageVideoAvail) 
			{
				sv = stage.stageVideos[0];
				sv.addEventListener(StageVideoEvent.RENDER_STATE, onRenderStageVideo, false, 0, true);
				sv.attachNetStream(ns);
				
				var bg:Shape = new Shape();
				bg.graphics.beginFill(0x000000, 0);
				bg.graphics.drawRect(0, 0, _videoWidth, _videoWidth);
				bg.graphics.endFill();
				addChild(bg);
				//trace("stageVideoAvail");
			}
			else
			{
				video = new Video(_videoWidth, _videoHeight);
				addChild(video);
				video.attachNetStream(ns);
				//trace("video object");
			}
			
			pauseScreen = new Shape();
			pauseScreen.graphics.beginFill(0x000000, .5);
			pauseScreen.graphics.drawRect(0,0,_videoWidth, _videoHeight);
			pauseScreen.graphics.endFill();
			
			log("ns.play(videoFile)");
			ns.play(videoFile);
			
			//THIS CAN BE REMOVED
			//muteVideo();
		}
		
		public function muteVideo() : void
		{
			var audioTransform : SoundTransform = new SoundTransform();
			audioTransform.volume = 0;
			ns.soundTransform = audioTransform;
		}
		
		public function replayVideo() : void
		{
			ns.seek(0);
		}
		
		public function rewindAndPause() : void
		{
			ns.seek(0);
			ns.pause();
		}
		
		public function pauseVideo() : void
		{
			if ( !videoPaused )
			{
				pauseScreen.alpha = 0;
				addChild(pauseScreen);
				TweenLite.to(pauseScreen, .5, {alpha:1});
				ns.pause();
			}
			else
			{
				TweenLite.to(pauseScreen, .5, {alpha:0, onComplete:function():void{removeChild(pauseScreen)}});
				ns.resume();
			}
			
			videoPaused = !videoPaused;
		}
		
		public function killVideo() : void
		{
			
			this.removeChildren();
			pauseScreen = null;
			this.removeEventListener(MouseEvent.CLICK, onVideoClick);
			
			if ( ns != null || nc != null)
			{
				ns.close();
				ns.dispose();
				ns.removeEventListener(NetStatusEvent.NET_STATUS, onVideoStatusHandler);
				ns = null;
				
				nc.close();
				nc = null;
			}
			
			if (!stageVideoAvail)
			{
				video = null;
			}else{
				sv.removeEventListener(StageVideoEvent.RENDER_STATE, onRenderStageVideo);
				sv = null;
			}
		}
		
		private function onRenderStageVideo(event:StageVideoEvent):void
		{
			sv.viewPort = new Rectangle(0, 0, _videoWidth, _videoHeight);	
		}
		
		//--------------------------------------
		//  NetStream Event Handlers
		//--------------------------------------
		private function onVideoStatusHandler(e : NetStatusEvent) : void
		{
			log("status : " + e.info.code);
			
			switch(e.info.code)
			{
				case "NetStream.Buffer.Full":
					//endVideoDispatched = false;
					break;
				case "NetStream.Play.Stop":
					//_eventDispatcher.dispatchEvent(new GenericDataEvent(VideoEvents.VIDEO_DONE_PLAYING, true));
					break;
				case "NetStream.Play.Complete":
				case "NetStream.Buffer.Empty":
					_eventDispatcher.dispatchEvent(new GenericDataEvent(VideoEvents.VIDEO_DONE_PLAYING, true));
					break;
				
			}
		}
		
		private function onVideoClick(event:MouseEvent):void
		{
			pauseVideo();
		}
		
		public function onMetaData( info:Object ) : void 
		{ 
			//log("metaHandler : " + info.duration);
		}
		public function onXMPData(event:Object):void
		{ 
			//log("onXMPData"); 
		}
		public function onPlayStatus(event:Object):void
		{ 
			//log("onPlayStatus"); 
		}
		public function onCuePoint( info:Object ) : void 
		{ 
			//log("onCuePoint");
		}
		
		
	}
}