package events
{
	import flash.events.Event;
	
	/** Used by the <code>Player</code> class to communicate with ui elements. */
	public class PlayerEvent extends Event
	{
		//==============================================
		// Declarations
		//==============================================
		public static const STATE_CHANGED:String = "STATE_CHANGED";
		public static const PLAYBACK_DONE:String = "PLAYBACK_DONE";
		public static const PLAYPOS_CHANGED:String = "PLAYPOS_CHANGED";
		public static const PLAYER_STATE_CHANGED:String = "PLAYER_STATE_CHANGED";
		public static const MEDIA_LOADED:String = "MEDIA_LOADED";
		
		
		private var _data:Object;
		
		//==============================================
		// Public Methods
		//==============================================
		/**
		 * Constructor
		 * @return	void
		 */
		public function PlayerEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}
				
		/** 
		 * @copy flash.events.Event#clone()
		 */
		override public function clone():Event
		{
			return (new PlayerEvent(type, _data, bubbles, cancelable));
		}
		
		/**
		 * @return	Object	an object passed by the dispatcher.  Can be null
		 */
		public function get data():Object
		{
			return (_data);
		}

	}// Class
}