package ui.bar
{
	import control.Globals;
	
	import data.PlayerStates;
	
	import events.PlayerEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	
	import ui.bar.components.PlayPause;
	import ui.bar.components.SeekBar;
	import ui.bar.components.Timecode;
	
	import video.Player;
	
	/** A sprite that contains the rectangle that appears and disappears at the bottom of the application display.
	 * Essentially, this is the video cotnrol bar, that nests other components like the seekbar and timecode.
	 */
	public class Bar extends Sprite
	{
		//==============================================
		// Declarations
		//==============================================
		private const BAR_HEIGHT:int = 39;
		
		private var _bg:Sprite;
		private var _componentHolder:Sprite;
		private var _sb:SeekBar;
		private var _pp:PlayPause;
		private var _mediaTItle:Object;
		private var _mouseTimer:Timer;
		private var _tc:Timecode;
		
		private var _player:Player;
		
		//==============================================
		// Public Methods
		//==============================================
		/**
		 * Constructor
		 * Instantiates main elements of the player controller bar.
		 * @return	void
		 */
		public function Bar()
		{			
			_player = Globals.player;
			
			// Draw Background
			_bg = new Sprite();
			_bg.graphics.beginFill(0x000000, .5);
			_bg.graphics.drawRect(0,0, BAR_HEIGHT, BAR_HEIGHT);
			_bg.graphics.endFill();
			
			_pp = new PlayPause();
			_sb = new SeekBar();
			_tc = new Timecode(_sb);
			
			_componentHolder = new Sprite();
			
			_player.addEventListener(PlayerEvent.MEDIA_LOADED, _onMediaLoaded);
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			addChild (_bg);
			addChild (_componentHolder);
		}
		
		//==============================================
		// Private Methods
		//==============================================
		private function _buildControls():void
		{
			while (_componentHolder.numChildren > 0)
			{
				_componentHolder.removeChildAt(0);
			}
			_componentHolder.addChild(_pp);
			if (_player.mediaLoaded)
			{
				_componentHolder.addChild(_tc);
				_componentHolder.addChild(_sb);
			}
			_reposition();
		}
		
		private function _genericMouseDown(e:MouseEvent):void
		{
			_mouseTimer.reset();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMovePlayer);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, _genericMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, _genericMouseUp);
		}
		
		private function _genericMouseUp(e:MouseEvent):void
		{
			_mouseTimer.reset();
			_mouseTimer.start();
			stage.addEventListener(MouseEvent.MOUSE_MOVE, _mouseMovePlayer);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, _genericMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, _genericMouseUp);
		}
		
		private function _mouseMovePlayer(e:MouseEvent):void
		{
			_mouseTimer.reset();
			_mouseTimer.start();
			_showControls();
			Mouse.show();
		}
		
		private function _mouseLeftStage(e:Event):void
		{
			_showControls(false);
			Mouse.show();
		}
		
		private function _mouseTimerUpdate(e:TimerEvent):void
		{
			_showControls(false);
			_mouseTimer.stop();
			
			// hide the mouse if in fullscreen
			if(stage.displayState == StageDisplayState.FULL_SCREEN)
				Mouse.hide();
		}
		
		private function _onMediaLoaded(e:PlayerEvent):void
		{
			_buildControls();
		}
		
		private function _onAddedToStage(e:Event):void
		{			
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			_mouseTimer = new Timer(2000);
			_mouseTimer.start();
			_mouseTimer.addEventListener(TimerEvent.TIMER, _mouseTimerUpdate);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, _mouseMovePlayer);
			stage.addEventListener(Event.MOUSE_LEAVE, _mouseLeftStage);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, _genericMouseDown);
			stage.addEventListener(Event.RESIZE, _reposition);
			_buildControls();
		}
		
		private function _reposition(e:Event=null):void
		{
			_bg.width = stage.stageWidth;
			_bg.y = _componentHolder.y = stage.stageHeight - _bg.height;

			_pp.x = 0;
			_sb.x = _pp.x + _pp.width + 10;
			_sb.width = stage.stageWidth - _pp.width - 20 - _tc.width;
			_tc.x = stage.stageWidth - _tc.width;
		}
		
		private function _showControls(display:Boolean = true):void
		{
			if(display)
			{
				_bg.y = _componentHolder.y = stage.stageHeight - _bg.height;
				visible = true;
			} 
			else 
			{
				visible = false;
			}
		}
		
		
	}// Class
}