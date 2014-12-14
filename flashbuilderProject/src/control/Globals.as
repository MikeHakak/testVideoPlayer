package control
{
	import video.Player;
	
	/** Global utility for referencing objects that would be nested throughout the application.
	 * So, rather than passing a reference of an object throughout areas of the ui, that object would
	 * be registered here. 
	 */
	public class Globals
	{
		//==============================================
		// Declarations
		//==============================================
		private static var _player:Player;
		
		//==============================================
		// Public Methods
		//==============================================
		/** initializes the internal property <code>_player</code>
		 * @param	player		a reference to the video player object
		 * @return	void
		 */
		public static function registerPlayer(player:Player):void
		{
			_player = player;
		}
		
		/** Enforeces that the <code>_player</code> behaves as a read-only property
		 * @return 	Player
		 */
		public static function get player():Player
		{
			return (_player);
		}
		
		
	}// Class
}