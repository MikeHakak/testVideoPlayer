package events
{
	import flash.events.Event;
	
	
	/** Utilized by the <code>video.PlayerStream</code> class to communicate stream events
	 */
	public class StreamEvent extends Event
	{
		//==============================================
		// Declarations
		//==============================================
		public static const READY:String = "READY";
		public static const METADATA_SET:String = "METADATA_SET";
		public static const START:String = "START";
		public static const PAUSED:String = "PAUSED";
		public static const RESUMED:String = "RESUMED";
		public static const COMPLETED:String = "COMPLETED";
		
		//==============================================
		// Public Methods
		//==============================================
		/**
		 * Constructor
		 * @return	void
		 */
		public function StreamEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		//==============================================
		// Private Methods
		//==============================================
	}
}