package utils
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	/** Utility class to load external documents [ text based documents only ].  
	 * Use:  instantiate, add listeners for complete and error, call the loadDocument method.
	 * Once the file is loaded, you can access the file via <code>document</code> property.
	 * It is your responsibility to check for null on the <code>document</code> property, as it is
	 * possibile that a complete event is dispatched via a null reference to the file. 
	 * @example	the following is a basic example of how to utilize this class:
	 * <listing version="3.0">
	 * var _docLoader:DocumentLoader = new DocumentLoader();
	 * _docLoader.addEventListener(Event.COMPLETE, onDocumentLoaded);
	 * _docLoader.addEventListener(ErrorEvent.Error, onDocumentLoadError);
	 * _docLoader.load("http://some_domain.com/some_directory/somefile.xml");
	 * </listing>
	 * */
	public class DocumentLoader extends EventDispatcher
	{
		//==============================================
		// Declarations
		//==============================================
		private var _document:Object;
		private var _loader:URLLoader;
		private var _isLoading:Boolean;
		
		
		//==============================================
		// Public Methods
		//==============================================
		/**
		 * Constructor
		 * Aggregates an instance of the EventDispatcher class.
		 * instantiates and initializes private attributes
		 * @return	void
		 * @param	target	
		 */
		public function DocumentLoader(target:IEventDispatcher=null)
		{
			super(target);
			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.TEXT;
			_loader.addEventListener(Event.COMPLETE, _onDocumentLoadSuccess);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, _onDocumentLoadError);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onDocumentLoadError);
		}
		
		/** Stops any loads current in progress by this instance, then attempts to load the file
		 * specified by the <code>path</code> parameter .  If <code>path</code> is null, an Event.COMPLETE is
		 * dispatched.
		 * @param	path	url of the document to load
		 * @return	void
		 */
		public function loadDocument(path:String):void
		{
			if (_isLoading)
			{
				try
				{
					_loader.close();
				}
				catch(e:Error){}
			}
			if (path != "")
			{
				_isLoading = true;
				_loader.load(new URLRequest(path));
			}
			else
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function get document():Object
		{
			return (_document);
		}
		
		//==============================================
		// Private Methods
		//==============================================
		private function _onDocumentLoadSuccess(e:Event):void
		{
			_document = _loader.data;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
		private function _onDocumentLoadError(e:Event):void{
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
		}
		
		
	}// class
}