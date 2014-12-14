package ui
{
	import flash.display.Sprite;
	
	import ui.bar.Bar;
	import ui.overlays.LoadingIndicator;
	
	/** This class acts as the base Sprite for all GUI elements that are presented for this application,
	 * other than the video itself.  All GUI elements are instantiated through this class. 
	 */
	public class VideoController extends Sprite
	{
		//==============================================
		// Declarations
		//==============================================
		private var _loadingIndicator:LoadingIndicator;
		private var _bar:Bar;
		//==============================================
		// Public Methods
		//==============================================
		/**
		 * Constructor
		 * @return	void
		 */
		public function VideoController()
		{
			_loadingIndicator = new LoadingIndicator();
			_bar = new Bar();
			
			addChild (_bar);
			addChild (_loadingIndicator);
		}
		
		//==============================================
		// Private Methods
		//==============================================
	}
}