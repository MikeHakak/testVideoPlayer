package ui.overlays
{
	import control.Globals;
	
	import events.PlayerEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import data.PlayerStates;
	
	import video.Player;
	
	/** This class is essentially a graphic element.  It manipulates the <code>visible</code> property
	 * to indicate to the user buffering states and loading states for the player.  It's imperative that this class
	 * be instantiated only after the <code>Globals</code> player is registered.
	 */
	[Embed(source="../assets/controls.swf", symbol="LoadingIndicator")]
	public class LoadingIndicator extends MovieClip
	{
		//==============================================
		// Declarations
		//==============================================
		public var background: MovieClip;
		public var spinner:MovieClip;
		public var text: MovieClip;
		
		private var _player:Player;
				
		//==============================================
		// Public Methods
		//==============================================
		/**
		 * Constructor
		 * Assumes on instantiating that it should be visible.
		 * @return	void
		 */
		public function LoadingIndicator()
		{
			spinner.gotoAndStop(1);
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			_player = Globals.player;
			_player.addEventListener(PlayerEvent.STATE_CHANGED, _onPlayerStateChanged);
			_show();
		}
		
		//==============================================
		// Private Methods
		//==============================================
		private function _onAddedToStage(e:Event):void
		{
			stage.addEventListener(Event.RESIZE, _reposition);
			stage.addEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage);
			_reposition();
		}
		
		private function _onPlayerStateChanged(e:PlayerEvent):void
		{
			if(Globals.player.state == PlayerStates.LOADING || _player.state == PlayerStates.NOT_INTIALIZED || _player.state == PlayerStates.BUFFERING)
			{
				_show();
			} else {
				_hide();
			}
		}
		
		private function _onRemovedFromStage(e:Event):void
		{
			stage.removeEventListener(Event.RESIZE, _reposition);
			stage.removeEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage);
		}
		
		private function _reposition(e:Event=null):void
		{
			if (stage)
			{
				if(stage.stageWidth > 400)
				{
					background.width = background.height = 100;
					text.visible = true;
					spinner.y = -10;
					y = stage.stageHeight / 2;
				} 
				else 
				{
					background.width = background.height = 45;
					text.visible = false;
					spinner.y = 0;
					y = stage.stageHeight / 2.25;
				}
				x = stage.stageWidth / 2;
			}
		}
		
		private function _hide(e:Event = null):void
		{
			visible = false;
			spinner.gotoAndStop(1);
		}
		
		private function _show():void
		{
			visible = true;
			spinner.play();	
		}
		
	}// Class
}