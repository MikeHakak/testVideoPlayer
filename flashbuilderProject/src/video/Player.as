package video
{
	import control.Config;
	
	import data.Media;
	import data.PlayerStates;
	
	import events.PlayerEvent;
	import events.StreamEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.utils.Timer;
	
	
	/** In a way, the Core of this application.  This class nests a property  of <code>PlayerStream</code> and a <code>Video</code>
	 * property. It utilizes the PlayerStream class to open a netstream and display the steram contents on screen.  It also
	 * wraps a series of methods for manipulation of video playback.  */
	public class Player extends Sprite
	{
		//==============================================
		// Declarations
		//==============================================
		private var _state:String = PlayerStates.NOT_INTIALIZED;
		private var _media:Media;
		private var _mediaLoaded:Boolean;
		private var _video:Video;
		private var _playerStream:PlayerStream;
		private var _updateTimer:Timer;
		private var _prevTime:int;
		
		//==============================================
		// Public Methods
		//==============================================
		/**
		 * Constructor
		 * @return	void
		 */
		public function Player()
		{
			_prevTime = 0;
			_updateTimer = new Timer(250);
			_updateTimer.addEventListener(TimerEvent.TIMER, _onUpdate);
			_video = new Video();
			_playerStream = new PlayerStream();
			_playerStream.addEventListener(StreamEvent.READY, _onStreamReady);
			_playerStream.addEventListener(StreamEvent.METADATA_SET, _onStreamMetaReady);
			_playerStream.addEventListener(StreamEvent.START, _onStreamStart);
			_playerStream.addEventListener(StreamEvent.RESUMED, _onStreamResumed);
			_playerStream.addEventListener(StreamEvent.PAUSED, _onStreamPaused);
			_playerStream.addEventListener(StreamEvent.COMPLETED, _onStreamCompleted);
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			addChild(_video);
		}
		
		/** Attempts to pause the video
		 * @return void
		 * */
		public function pause():void
		{
			trace("pause called");
			_playerStream.pause();
		}
		
		/** Attempts to play the video if it has been stopped (completed) from the beginning, or resume the video
		 * it it has been paused
		 * @return void
		 */
		public function play():void
		{
			trace ("play called");
			if (state == PlayerStates.STOPPED){
				_playerStream.restart();
			}
			else if (state == PlayerStates.PAUSED)
			{
				_playerStream.resume();	
			}	
		}
		
		/** initializes the <code>_media</code> property with the data referenced in the xml loaded
		 * @param	document		xml document that conforms to the xml structrue required by this application
		 * @return	void
		 */
		public function registerMediaData(document:Object):void
		{
			_media = new Media();
			_media.parseDocument(document);
			trace("video loaded: "+_media.videoURL);
			_playerStream.connect(_media);
			_updateTimer.start();
		}
		
		/**  Attempts to change the current playhead time to the given parameter for the current active stream
		 * @param	position		the time to move the playhead to, in seconds
		 * @return	void
		 */
		public function seek(position:Number):void
		{
			_playerStream.seek(position);
		}
		
		/** Retureves the <code>_media</code> property of this object.  the <code>_media</code> property holds all
		 * relevant information regarding the current video being loaded and played.  Infomration like the current
		 * playhead time, duration of video, etc... @see data.Media
		 * @return	Media
		 */
		public function get media():Media
		{
			return (_media);
		}
		
		/** Flag to communicate when the video has been loaded and all relevant information regarding that video has been 
		 * inititalized into the <code>_media</code> proeprty
		 * @return 	Boolean		true indicates that the information has been initialized
		 */
		public function get mediaLoaded():Boolean
		{
			return (_mediaLoaded);
		}
		
		/** Essentially a flag, relaying the current state the player is in @see data.PlayerStates
		 * @return	String
		 */
		public function get state():String
		{
			return (_state);
		}
		
		/** Sets the flga for the video player, indicating a state change event, and updates the <code>_state</code>
		 * property
		 * @return	String		@see data.PlayerStates
		 */
		public function set state(value:String):void
		{
			_state = value;
			trace ("state set = "+_state);
			dispatchEvent(new PlayerEvent(PlayerEvent.STATE_CHANGED));
		}
		
		
		//==============================================
		// Private Methods
		//==============================================
		private function _onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			stage.addEventListener(Event.RESIZE, _positionVideo);
		}
		
		private function _onStreamCompleted(e:StreamEvent):void
		{
			state = PlayerStates.STOPPED;
			_media.time = _media.duration;
			dispatchEvent(new PlayerEvent(PlayerEvent.PLAYPOS_CHANGED));
			dispatchEvent(new PlayerEvent(PlayerEvent.PLAYBACK_DONE));
		}
		
		private function _onStreamMetaReady(e:StreamEvent):void
		{
			if (!Config.AUTO_PLAY){
				_playerStream.pause();
			}
			_mediaLoaded = true;
			_positionVideo();
			dispatchEvent(new PlayerEvent(PlayerEvent.MEDIA_LOADED));
		}
		
		private function _onStreamPaused(e:StreamEvent):void
		{
			state = PlayerStates.PAUSED;	
		}
		
		private function _onStreamReady(e:Event):void
		{
			state = PlayerStates.READY;
			_video.attachNetStream(_playerStream.stream);
			_playerStream.play(_media.videoURL);
		}
		
		private function _onStreamResumed(e:StreamEvent):void
		{
			state = PlayerStates.PLAYING;	
		}
		
		private function _onStreamStart(e:StreamEvent):void
		{
			state = PlayerStates.PLAYING;
		}
		
		private function _onUpdate(e:TimerEvent):void{
			_updateTimer.stop();
			_updateTimer.reset();
			_prevTime = _media.time;
			_media.time = Math.floor(_playerStream.time);
			if (_media.time != _prevTime){
				dispatchEvent(new PlayerEvent(PlayerEvent.PLAYPOS_CHANGED));
			}
			_updateTimer.start();
		}
		
		private function _positionVideo(e:Event=null):void
		{
			var _sWidth:Number = stage.stageWidth;
			var _sHeight:Number = stage.stageHeight;
			var _ratio:Number =_sWidth/_sHeight;
			if (_ratio > _media.ratio)
			{
				_video.height = _sHeight;
				_video.width = _sHeight*_media.ratio;
			}
			else
			{
				_video.width = _sWidth;
				_video.height =_sWidth / _media.ratio;
			}
			x = (_sWidth - _video.width)/2;
			y = (_sHeight - _video.height)/2;
		}
		
		
		
	}// Class
}