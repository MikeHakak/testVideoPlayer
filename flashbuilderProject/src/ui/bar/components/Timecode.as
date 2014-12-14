package ui.bar.components
{
	import control.Globals;
	
	import data.PlayerStates;
	
	import events.PlayerEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import ui.bar.components.SeekBar;
	
	import video.Player;
	
	/** Used to display the time played and total time of the video.
	 */
	[Embed(source="../assets/controls.swf", symbol="Timecode")]
	public class Timecode extends MovieClip
	{
		//==============================================
		// Declarations
		//==============================================
		public var time_txt : TextField;
		
		private var _seekbar:SeekBar;
		private var _textFormat:TextFormat;
		private var _width:Number;
		private var _durationTxt:String;
		
		private var _player : Player;
		
		//==============================================
		// Public Methods
		//==============================================
		/**
		 * Constructor
		 * @return	void
		 */
		public function Timecode(sb:SeekBar)
		{
			_player = Globals.player;
			
			_player.addEventListener(PlayerEvent.PLAYPOS_CHANGED, _onPlayPosChanged);
			_player.addEventListener(PlayerEvent.MEDIA_LOADED, _onPlayerMediaLoaded);
			
			y = 11;
			
			_textFormat = new TextFormat();
			_textFormat.align = TextFormatAlign.LEFT;
			_textFormat.leftMargin = 7;
			_textFormat.rightMargin = 0;
			time_txt.defaultTextFormat = _textFormat;
			
			_setSeekBar(sb);
			
			_durationTxt = _formatTime(0);
			_setTime(0);
			_width = time_txt.width;
		}
		
		/** returns the width of the text field nested in this object to prevent other 
		 * future options from distorting the dsired width value.
		 * @return Number
		 */
		override public function get width():Number
		{
			return _width;
		}
		
		//==============================================
		// Private Methods
		//==============================================
		private function _formatTime(time:Number):String
		{
			var negative:String = (time < 0) ? "-" : "";
			var remainder:Number;
			time = Math.abs(time);
			var hours:Number = time / ( 60 * 60 );
			remainder = hours - (Math.floor ( hours ));
			hours = Math.floor(hours);
			var minutes : Number = remainder * 60;
			remainder = minutes - (Math.floor ( minutes ));
			minutes = Math.floor(minutes);
			var seconds : Number = remainder * 60;
			remainder = seconds - (Math.floor ( seconds ));
			seconds = Math.floor(seconds);
			var hString:String = hours < 10 ? "0" + hours:"" + hours;
			var mString:String = minutes < 10 ? "0" + minutes:"" + minutes;
			var sString:String = seconds < 10 ? "0" + seconds:"" + seconds;
			
			if (time < 0 || isNaN(time)) { return "00:00"; }
			
			if (hours > 0)
			{
				return negative + hString + ":" + mString + ":" + sString;
			}
			else
			{
				return negative + mString + ":" + sString;
			}
		}
		
		private function _onPlayerMediaLoaded(e:PlayerEvent):void
		{
			_durationTxt = _formatTime(_player.media.duration);
		}
		
		private function _onPlayPosChanged(e:Event):void
		{
			_setTime(_player.media.time);
		}
		
		private function _onScrubChanged(e:Event):void
		{
			_setTime(_player.media.duration * _seekbar.scrubberPercentage)
		}
		
		private function _onScrubStarted(e:Event):void
		{
			_player.removeEventListener(PlayerEvent.PLAYPOS_CHANGED, _onPlayPosChanged);
			_seekbar.addEventListener(SeekBar.SCRUB_CHANGE, _onScrubChanged, false, 0, true);
		}
		
		private function _onScrubStopped(e:Event):void
		{
			_seekbar.removeEventListener(SeekBar.SCRUB_CHANGE, _onScrubChanged);
			_player.addEventListener(PlayerEvent.PLAYPOS_CHANGED, _onPlayPosChanged);
		}
		
		private function _onSeekbarSeeked(e:Event):void
		{
			_setTime(_player.media.duration * _seekbar.scrubberPercentage)
		}
		
		private function _setSeekBar(sb:SeekBar):void
		{
			_seekbar = sb;
			_seekbar.addEventListener(SeekBar.SCRUB_START, _onScrubStarted, false, 0, true);
			_seekbar.addEventListener(SeekBar.SCRUB_STOP, _onScrubStopped, false, 0, true);
		}
		
		private function _setTime(time:int):void
		{	
			time_txt.text = _formatTime(time)+" / "+_durationTxt;
		}
		
	}// Class
}