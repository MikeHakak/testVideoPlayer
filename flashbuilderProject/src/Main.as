package
{
	import control.Config;
	import control.Globals;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import ui.VideoController;
	
	import utils.DocumentLoader;
	
	import video.Player;
	
	
	/**
	 * This project is not ment for commercial use.  It is developed under
	 * ths strict purpose of meeting the taks of displaying basic player
	 * development competency and coding discipline.
	 * Native dimensions for this application is set at 912 x 385, however, 
	 * it can be embedded to match all acceptabe flash dimenstions.
	 * This application has primary properties as follows:
	 * <ul>
	 * <li>dimensions: 921 x 385 px </li>
	 * <li>backgroundColor: #000000 </li>
	 * <li>frameRate: 30 fps </li>
	 * </ul>
	 */
	[SWF(width="912", height="385", backgroundColor='#FFFFFF', frameRate='30')]
	public class Main extends Sprite
	{
		//==============================================
		// Declarations
		//==============================================
		private var _videoController:VideoController;
		private var _player:Player;
		private var _docLoader:DocumentLoader;
		private var _bg:Sprite;
		
		
		//==============================================
		// Public Methods
		//==============================================
		/**
		 * Constructor
		 * Runs this application (initial thread).
		 * @return	void
		 */
		public function Main()
		{
			_bg = new Sprite();
			_bg.graphics.beginFill(0x000000, 1);
			_bg.graphics.drawRect(0,0, 1, 1);
			_bg.graphics.endFill();
			
			_registerContextMenu();
			
			_player = new Player();
			Globals.registerPlayer(_player);
			
			_videoController = new VideoController();
			_docLoader = new DocumentLoader();
			_docLoader.addEventListener(Event.COMPLETE, _onDocumentLoaded);
			_docLoader.addEventListener(ErrorEvent.ERROR, _onDocumentLoadError);
			
			addChild(_bg);
			addChild(_player);
			addChild(_videoController);
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}
		
		//==============================================
		// Private Methods
		//==============================================
		private function _onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			stage.addEventListener(Event.RESIZE, _onResize);
			_onResize();
			_docLoader.loadDocument(Config.XML_PATH);
		}
		
		private function _onDocumentLoaded(e:Event):void
		{
			_player.registerMediaData(_docLoader.document);
		}
		
		private function _onDocumentLoadError(e:ErrorEvent):void
		{
			trace ("Document load error");
		}
		
		private function _onResize(e:Event=null):void{
			_bg.width = stage.stageWidth;
			_bg.height = stage.stageHeight;
		}
		
		private function _registerContextMenu():void
		{
			var _menu:ContextMenu = new ContextMenu();
			_menu.hideBuiltInItems();
			_menu.customItems.push(new ContextMenuItem("Shaw Test Player "+Config.VERSION));
			contextMenu = _menu;
		}
		
	}//class
}