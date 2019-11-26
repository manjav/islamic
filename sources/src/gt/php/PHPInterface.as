package gt.php
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import org.lzyy.util.UploadPostHelper;

	
	[Event(name="ioError",	type="flash.events.IOErrorEvent")]
	[Event(name="complete",	type="flash.events.Event")]
	
	public class PHPInterface extends EventDispatcher
	{

		
		private var urlRequest:URLRequest;
		private var urlLoader:URLLoader;
		public var data:Object;
		
		public function PHPInterface(path:String, dataFormat:String='utf', variables:Object=null)
		{
			urlRequest = new URLRequest('http://'+path);
			urlRequest.method = URLRequestMethod.POST;
			urlLoader = new URLLoader();
			var urlVars:URLVariables = new URLVariables();
			if (dataFormat=='utf')
			{
				for (var v:String in variables)
				{
					//trace(v, variables[v]);
					urlVars[v.toString()] = variables[v];
				}
				urlRequest.data = urlVars;
				urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			}
			else if (dataFormat=='file')
			{
				urlRequest.contentType = 'multipart/form-data; boundary=' + UploadPostHelper.getBoundary();
				urlRequest.requestHeaders.push(new URLRequestHeader('Cache-Control', 'no-cache'));
				urlRequest.data = UploadPostHelper.getPostData(variables.name, variables.file, variables.param);

				urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			}
			urlLoader.addEventListener(Event.COMPLETE, completeHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		//urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		}
		public function load():void
		{
			urlLoader.load(urlRequest);//trace(urlRequest.url, urlRequest.data)
		}
		private function completeHandler(event:Event):void
		{
			if(hasEventListener(Event.COMPLETE))
			{
				data = event.target.data;
				dispatchEvent(event.clone());
			}
		}
		private function errorHandler(event:IOErrorEvent):void
		{
			if(hasEventListener(IOErrorEvent.IO_ERROR))
				dispatchEvent(event.clone());
		}
		/*private function progressHandler(e:ProgressEvent):void
		{
			trace(e.bytesLoaded / 1000 + "KB loaded out of " + e.bytesTotal / 1000 + "KB     "+ uint(100 * e.bytesLoaded / e.bytesTotal)+"%");
		}*/
	}
}