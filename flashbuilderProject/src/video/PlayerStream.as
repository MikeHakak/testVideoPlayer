package video
{
	import data.Media;
	
	import events.StreamEvent;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	/** A wrapper class to <code>NetStream</code>.  It aslo handles the netconnection  required for the netstream
	 */
	public class PlayerStream extends EventDispatcher
	{
		//==============================================
		// Declarations
		//==============================================
		private var _nc:NetConnection;
		private var _ns:NetStream;
		private var _vid_path:String;
		private var _media:Media;
		
		//==============================================
		// Public Methods
		//==============================================
		/**
		 * Constructor
		 * @return	void
		 */
		public function PlayerStream()
		{
			super();
			_nc = new NetConnection();
			_nc.addEventListener(NetStatusEvent.NET_STATUS, _onNetStatus);
			_nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSecurityError);
		}
		
		/** Attempt s to make a net connection
		 * @return	void
		 */
		public function connect(media:Media):void
		{
			_media = media;
			_nc.connect(null);
		}
		
		/** attempts to call the play method on <code>_ns</code>, with the given video path.
		 * @param	path	video stream path  @example	http://somedomain.com/somediretory/somevideo.flv
		 * @return	void
		 */
		public function play(path:String):void
		{
			if (_ns)
			{
				_ns.play(path);
			}
		}
		
		/** attempts to call the pause method on the <code>_ns</code> property
		 * @return void
		 */
		public function pause():void
		{
			if (_ns)
			{
				_ns.pause();
			}
		}
		
		/** attempts to call the seek method on the <code>_ns</code> property
		 * @param time	Number, in secodes
		 * @return void
		 */
		public function seek(time:Number):void
		{
			if (_ns)
			{
				_ns.seek(time);
			}
		}
		
		/** Attempts to restart a stream that is completed, from the begining.
		 * @return void
		 */
		public function restart():void
		{
			if (_ns)
			{
				_ns.seek(0);
				_ns.play();
			}
		}
		
		
		/** attempts to call the resume method on the <code>_ns</code> proprty.
		 * @return void
		 * */
		public function resume():void
		{
			if (_ns)
			{
				_ns.resume();
			}
		}
		
		/** This method should not be invoked manually.  This method is essentially private, but has been labeled as public 
		 * so that the <code>_ns</code> property can trigger the call
		 *@param	infoObject		Object of relevant video properties like the duration of the video
		 * @return 	void
		 * */
		public function onMetaData(infoObject:Object):void
		{
			_media.setMetaInfo(Number (infoObject["duration"]),Number(infoObject["width"]), Number(infoObject["height"]));  
			dispatchEvent(new StreamEvent(StreamEvent.METADATA_SET));
		}
		
		
		/** This method should not be invoked manually.  This method is essentially private, but has been labeled as public
		 * so that the <code>_ns</code> property can trigger the call
		 * @param 	infoObject		Object of relvent video state properties, mainly used to indicate when the video is complete
		 * */
		public function onPlayStatus(infoObject:Object):void
		{
			trace("onPlayStatus : ");
			for (var i:String in infoObject)
			{
				trace(i+" = "+infoObject[i]);
			}
			switch(infoObject.code)
			{
				case ("NetStream.Play.Complete"):
					dispatchEvent(new StreamEvent(StreamEvent.COMPLETED));
					break;
			}
		}
		
		/** gets the <code>_ns</code> property.  The NetStream assoucated with this applications <code>NetConnection</code>
		 * @return	NetStream
		 */
		public function get stream():NetStream
		{
			return (_ns);
		}
		
		/** The current playhead time
		 * @return Number	in seconds, the current playhead time
		 */
		public function get time():Number
		{
			if (_ns)
				return (_ns.time);
			return (0);
		}
		//==============================================
		// Private Methods
		//==============================================
		private function _connectNetStream():void
		{
			_ns = new NetStream(_nc);
			_ns.client = this;
			_ns.addEventListener(NetStatusEvent.NET_STATUS, _onNetStatus);
			_ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, _onAsyncError);
			dispatchEvent(new StreamEvent(StreamEvent.READY));
		}
		
		private function _onAsyncError(e:AsyncErrorEvent):void{
			trace("ERROR:  "+e.toString());
		}
		
		private function _onNetStatus(e:NetStatusEvent):void
		{
			trace(e.info.code);
			switch (e.info.code) {
				case "NetConnection.Connect.Success":
					_connectNetStream();
					break;
				case "NetStream.Play.Start":
					dispatchEvent(new StreamEvent(StreamEvent.START));
					break;
				case "NetStream.Pause.Notify":
					dispatchEvent(new StreamEvent(StreamEvent.PAUSED));
					break;
				case "NetStream.Unpause.Notify":
					dispatchEvent(new StreamEvent(StreamEvent.RESUMED));
					break;
			}
		}
		
		private function _onSecurityError(e:SecurityErrorEvent):void
		{
			trace("ERROR:  "+e.toString());
		}
		
	}// Class
}