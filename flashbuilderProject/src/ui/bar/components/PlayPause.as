package ui.bar.components
{
	import control.Globals;
	
	import events.PlayerEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import data.PlayerStates;
	import ui.bar.components.Highlighter;
	
	import video.Player;
	
	/**The Play / Pause / Restart Button.    It is also possible to convert this to a play/stop/restart  button
	 */
	[Embed(source="../assets/controls.swf", symbol="PlayPause")]
	public class PlayPause extends Highlighter
	{
		//==============================================
		// Declarations
		//==============================================
		public var pause_icon : MovieClip;
		public var play_icon : MovieClip;
		public var restart_icon : MovieClip;
		public var stop_icon : MovieClip;
		
		private var _player:Player;
		//==============================================
		// Public Methods
		//==============================================
		/**
		 * Constructor
		 * @return	void
		 */
		public function PlayPause()
		{
			play_icon.visible = !(pause_icon.visible = restart_icon.visible = stop_icon.visible = false); 
			_player = Globals.player;
			_player.addEventListener(PlayerEvent.STATE_CHANGED, _onPlayerStateChange);
			_player.addEventListener(PlayerEvent.PLAYBACK_DONE, _onPlaybackDone);
			addEventListener(MouseEvent.CLICK, _onTogglePause);
		}
		
		//==============================================
		// Private Methods
		//==============================================
		private function _onPlaybackDone(e:PlayerEvent):void
		{
			pause_icon.visible = play_icon.visible = false;
			restart_icon.visible = true;
		}
		
		public function _onPlayerStateChange(e:PlayerEvent):void
		{
			trace ("caught change status: "+_player.state);
			pause_icon.visible = (_player.state == PlayerStates.PLAYING);
			play_icon.visible = !pause_icon.visible;
			stop_icon.visible = false; // always assume this should be hidden
			restart_icon.visible = false;	// always assume this should be hidden
		}
		
		public function _onTogglePause(e:MouseEvent):void
		{
			if(_player.state == PlayerStates.PLAYING)
			{
				_player.pause();				
			} 
			else if (_player.state == PlayerStates.PAUSED || _player.state == PlayerStates.STOPPED) 
			{
				_player.play();
			}
		}
		
		
	}// Class
}