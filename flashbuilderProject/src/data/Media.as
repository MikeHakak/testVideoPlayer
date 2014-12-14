package data
{
	import flash.media.Video;
	/** Structure that represents the core media data.  A basic object that holds the 
	 * primary data associated with the video to load and play.
	 */ 
	public class Media
	{
		//==============================================
		// Declarations
		//==============================================
		public  var duration:Number;
		public  var time:Number;
		public var width:Number;
		public var height:Number;
		public var ratio:Number;
		public var loaded:Boolean;
		
		private var _title:String;
		private var _videoURL:String;
		//==============================================
		// Public Methods
		//==============================================
		/**
		 * Constructor
		 * @return	void
		 */
		public function Media()
		{
			duration = 0;
			time = 0;		
		}
		
		/** Used to populate this object.  Parses an xml based object that conforms to the structure defineed 
		 * for this application, and populates the properties of this object with the relevant data.
		 * @param	document		an XML that conforms to the structure defined for this application
		 * @return	void
		 */
		public function parseDocument(document:Object):void
		{
			var _xml:XML = XML(document);
			if (_xml)
			{
				if (_xml.vid_name)
				{
					_title = String(_xml.vid_name);
				}
				if (_xml.vid_url)
				{
					_videoURL = String(_xml.vid_url);
				}
			}
		}
		
		
		/** function utilised by <code>PlayerStream</code> class, once the video meta data is loaded.
		 * Populates some of the properties of this object. 
		 * @param	duration	the number of seconds the total length of the video time.
		 * @param	width			the width of the video naturally in pixels
		 * @param	 height		the height of the video naturally in pixels
		 * @return	void 
		 */
		public function setMetaInfo(duration:Number, width:Number, height:Number):void
		{
			this.duration = duration;
			this.width = width;
			this.height = height;
			if (height == 0)
			{
				ratio = 0;
			}
			else
			{
				ratio = width/height;
			}
		}
		
		/** Read-Only, the title of the video.  Attained through the xml loaded
		 * @return 	String
		 */
		public function get title():String
		{
			return (_title);
		}
		
		/** Read-Only, the video url.  Attained through the xml loaded
		 * @return 	String
		 */
		public function get videoURL():String
		{
			return (_videoURL);
		}
		
		
	}// Class
}