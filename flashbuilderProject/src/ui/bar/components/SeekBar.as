package ui.bar.components
{
	import control.Globals;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import events.PlayerEvent;
	import data.PlayerStates;
	
	import video.Player;
	
	/** The scrubber / Seekbar element of the application.  Dispathces events for the <code>Timecode</code> class
	 * to prevent miscommunication on play time and scrub time to the user*/
	[Embed(source="../assets/controls.swf", symbol="SeekBar")]
	public class SeekBar extends MovieClip
	{
		//==============================================
		// Declarations
		//==============================================
		public static var SCRUB_START:String = "SCRUB_START";
		public static var SCRUB_CHANGE:String = "SCRUB_CHANGE";
		public static var SCRUB_STOP:String = "SCRUB_STOP";
		
		public var scrubber : MovieClip;
		public var track : MovieClip;
		public var bar : MovieClip;
		
		public var scrubberPercentage:Number = 0;
		
		private var _buffer:Number = 30;	
		private var _usableWidth:Number;
		
		private var _player : Player;
		//==============================================
		// Public Methods
		//==============================================
		/**
		 * Constructor
		 * @return	void
		 */
		public function SeekBar() 
		{			
			_player = Globals.player;
			
			_player.addEventListener(PlayerEvent.PLAYPOS_CHANGED, _onPlayPosChanged);
						
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage);
		}
		
		/** returns the track width, essentially the object that should dictate the width of this object
		 * @return	Number
		 */
		override public function get width():Number
		{
			return track.width;
		}
		
		/** sets the track width essentailly.
		 * @param	w		Number
		 * @return	void
		 */
		override public function set width(w:Number):void
		{
			track.width = w;
			_usableWidth = track.width - (_buffer * 2);
			try 
			{
				_updateScrubberPosition(_player.media.time / _player.media.duration);
			} catch (e:Error)
			{
				_updateScrubberPosition(0);
			}
		}
		
		//==============================================
		// Private Methods
		//==============================================
		public function _getPositionBasedOnPercentage(percent:Number):Number { 
			if(!percent || percent < 0)
			{
				percent = 0;
			} else if (percent > 1)
			{
				percent = 1;
			}
			return (percent * _usableWidth) + _buffer; 
		}
		
		public function _getPercentageBasedOnPosition(xCoord:Number):Number
		{	
			if(xCoord <= _buffer)
			{
				return 0;
			} 
			else if(xCoord >= (track.width - _buffer))
			{
				return 1;
			} else {
				xCoord = (xCoord - _buffer) / _usableWidth;
				return xCoord;
			}
		}
		
		private function _onAddedToStage(e:Event):void
		{						
			track.buttonMode = true;
			scrubber.mouseEnabled = bar.mouseEnabled = false;
			_buffer = scrubber.width / 2;
			this.addEventListener(MouseEvent.MOUSE_DOWN, _onBarDown, false, 0, true);
			y = 13;
		}
		
		private function _onBarDown(e:MouseEvent):void
		{
			// prevent player updates from moving the scrubber
			_player.removeEventListener(PlayerEvent.PLAYPOS_CHANGED, _onPlayPosChanged);
			
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, _onBarMove);
			this.stage.addEventListener(Event.MOUSE_LEAVE, _onBarUp);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, _onBarUp);
			
			scrubberPercentage = _getPercentageBasedOnPosition(this.mouseX);
			_updateScrubberPosition(scrubberPercentage);
			dispatchEvent(new Event(SCRUB_START));
			dispatchEvent(new Event(SCRUB_CHANGE));		
		}
		
		private function _onBarMove(e:MouseEvent):void
		{
			scrubberPercentage = _getPercentageBasedOnPosition(this.mouseX);
			_updateScrubberPosition(scrubberPercentage);
			dispatchEvent(new Event(SCRUB_CHANGE));
		}
		
		private function _onBarUp(e:Event):void
		{
			// let player updates move the scrubber again
			_player.addEventListener(PlayerEvent.PLAYPOS_CHANGED, _onPlayPosChanged);
			
			this.stage.removeEventListener(Event.MOUSE_LEAVE, _onBarUp);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, _onBarUp);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onBarMove);
			
			dispatchEvent(new Event(SCRUB_STOP));
			
			if(_canSeek()){
				_player.seek(_player.media.duration * scrubberPercentage);
			}
		}
		
		private function _onPlayPosChanged(e:Event):void { 
			_updateScrubberPosition(_player.media.time / _player.media.duration); 
		}
		
		private function _onRemovedFromStage( event : Event) : void
		{			
			this.removeEventListener(MouseEvent.MOUSE_DOWN, _onBarDown);
		}
		
		
		private function _updateScrubberPosition(percent:Number):void { 
			if(!percent) percent = 0;
			bar.width = scrubber.x = _getPositionBasedOnPercentage(percent);
		}
		
		private function _canSeek() : Boolean
		{
			if (_player.mediaLoaded)
			{
				return (true);
			}
			return (false);
		}
		
		
	}// Class
}