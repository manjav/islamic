package com.gerantech.islamic.models
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import feathers.system.DeviceCapabilities;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import starling.textures.Texture;
	
	public class Assets
	{
		
		private static var allTextures:Dictionary = new Dictionary();
		private static var allScaled3Textures:Dictionary = new Dictionary();
		private static var allScaled9Textures:Dictionary = new Dictionary();
		

		[Embed(source="../assets/fonts/me_quran.ttf", fontFamily="mequrandev", fontWeight="normal", mimeType="application/x-font", embedAsCFF="false")]
		protected static const ME_QURAN_DEV:Class;
		
		[Embed(source="../assets/fonts/me_quran.ttf", fontFamily="mequran", fontWeight="normal", mimeType="application/x-font", embedAsCFF="true")]
		protected static const ME_QURAN:Class;
		
		private static var sclaed9Names:Array;
		private static var sclaed9NamesComplete:Function;
		
		
		
		public static function getTexture(name:String):Texture
		{
			return AppModel.instance.assetManager.getTexture(name);
		}
		
		public static function getScale3Textures(name:String, firstRegionSize:Number, secondRegionSize:Number, direction:String = "horizontal"):Scale3Textures
		{
			if (allScaled3Textures[name] == undefined)
				allScaled3Textures[name] = new Scale3Textures(Assets.getTexture(name), firstRegionSize, secondRegionSize);
			
			return allScaled3Textures[name];
		}
		
		public static function getItemTextures(state:String):Scale9Textures
		{
			return getSclaed9Textures((UserModel.instance.nightMode?"i_":"")+"item_roundrect_"+state);
		}
		
		public static function getSclaed9Textures(name:String):Scale9Textures
		{
			return allScaled9Textures[name];
		}
		
		public static function loadSclaed9Textures(names:Array, onComplete:Function):void
		{
			sclaed9Names = names
			sclaed9NamesComplete = onComplete;
			
			for each(var name:String in names)
			{
				var ba:ByteArray = AppModel.instance.assetManager.getByteArray(name);
				
				var loader:Loader = new Loader();
				loader.name = name
				loader.contentLoaderInfo.addEventListener( Event.COMPLETE, loader_completeHandler );
				loader.loadBytes( ba );
			}	
		}
		
		protected static function loader_completeHandler(event:Event):void
		{
			event.currentTarget.removeEventListener( Event.COMPLETE, loader_completeHandler );
			var loader:Loader = event.currentTarget.loader;
			var bmp:Bitmap = loader.content as Bitmap;
			
			var scale:Number = DeviceCapabilities.dpi/640;
			var bitmapWidth:uint = Math.round(bmp.width*scale*0.5)*2;
			var bitmapHeight:uint = Math.round(bmp.height*scale*0.5)*2;
			var mat:Matrix = new Matrix();
			mat.scale(bitmapWidth/bmp.width, bitmapHeight/bmp.height);
			var destBD:BitmapData = new BitmapData(bitmapWidth, bitmapHeight, true, 0);
			destBD.draw(bmp, mat);
			
			var texture:Texture = Texture.fromBitmapData(destBD);
			allScaled9Textures[loader.name] = new Scale9Textures(texture, new Rectangle(bitmapWidth/2-1,bitmapHeight/2-1,2,2));
			
			var n:int = 0;
			for (var key:* in allScaled9Textures)
				n++;
			
			if(n==sclaed9Names.length && sclaed9NamesComplete!=null)
				sclaed9NamesComplete();
		}
	}
}