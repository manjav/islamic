package com.gerantech.islamic.models
{
	import com.adobe.images.PNGEncoder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import feathers.system.DeviceCapabilities;
	
	import gt.utils.GTStreamer;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Assets
	{
		/**
		 * Fonts 
		 */		
		[Embed(source="../assets/fonts/me_quran.ttf", fontFamily="mequran", fontWeight="normal", mimeType="application/x-font", embedAsCFF="true")]
		protected static const ME_QURAN:Class;
		[Embed(source="../assets/fonts/scheherazade.ttf", fontFamily="scheherazade", fontWeight="normal", mimeType="application/x-font", embedAsCFF="true")]
		protected static const SCHEHERAZADE:Class;
		[Embed(source="../assets/fonts/nabi.ttf", fontFamily="nabi", fontWeight="normal", mimeType="application/x-font", embedAsCFF="true")]
		protected static const NABI:Class;
		
		
		/**
		 * Texture Atlas 
		 */
		[Embed(source="../assets/images/atlases/skin2.png")]
		public static const skinsAtlasTexture:Class;
		[Embed(source="../assets/images/atlases/skin2.xml", mimeType="application/octet-stream")]
		public static const skinsAtlasXml:Class;
		[Embed(source="../assets/images/atlases/surajuze.png")]
		public static const surajuzeAtlasTexture:Class;
		[Embed(source="../assets/images/atlases/surajuze.xml", mimeType="application/octet-stream")]
		public static const surajuzeAtlasXml:Class;
		
		/**
		 * Bitmaps for 9 slice textures
		 */
		[Embed(source="../assets/images/bitmaps/dialog.png")]
		public static const dialogBitmap:Class;
		[Embed(source="../assets/images/bitmaps/i_dialog.png")]
		public static const i_dialogBitmap:Class;
		[Embed(source="../assets/images/bitmaps/item_roundrect_down.png")]
		public static const item_roundrect_downBitmap:Class;
		[Embed(source="../assets/images/bitmaps/i_item_roundrect_down.png")]
		public static const i_item_roundrect_downBitmap:Class;
		[Embed(source="../assets/images/bitmaps/item_roundrect_normal.png")]
		public static const item_roundrect_normalBitmap:Class;
		[Embed(source="../assets/images/bitmaps/i_item_roundrect_normal.png")]
		public static const i_item_roundrect_normalBitmap:Class;
		[Embed(source="../assets/images/bitmaps/item_roundrect_selected.png")]
		public static const item_roundrect_selectedBitmap:Class;
		[Embed(source="../assets/images/bitmaps/i_item_roundrect_selected.png")]
		public static const i_item_roundrect_selectedBitmap:Class;

		private static var allTextures:Dictionary = new Dictionary();
		private static var allTextureAtlases:Dictionary = new Dictionary();
		/*private static var allScaled3Textures:Dictionary = new Dictionary();
		private static var allScaled9Textures:Dictionary = new Dictionary();
		private static var sclaed9Names:Array;
		private static var sclaed9NamesComplete:Function;*/

		/**
		 * Returns a texture from this class based on a string key.
		 * @param name A key that matches a static constant of Bitmap type.
		 * @return a starling texture.
		 */
		private static function getTextureByBitmap(name:String):Texture
		{
			if (allTextures[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]();
				allTextures[name] = Texture.fromBitmap(bitmap);
			}
			return allTextures[name];
		}
		
		/**
		 * Returns the Texture atlas instance.
		 * @return the TextureAtlas instance (there is only oneinstance per app)
		 */
		private static function getAtlas(name:String):TextureAtlas
		{
			if (allTextureAtlases[name] == undefined)
			{
				var texture:Texture = getTextureByBitmap(name+"AtlasTexture");
				var xml:XML = XML(new Assets[name+"AtlasXml"]);
				allTextureAtlases[name] = new TextureAtlas(texture, xml);
			}
			return allTextureAtlases[name];
		}
		
		/**
		 * Returns a texture from this class based on a string key.
		 * @param name A key that found a texture from atlas.
		 * @return the Texture instance (there is only oneinstance per app).
		 */
		public static function getTexture(texturName:String, atlasName:String ="skins" ):Texture
		{
			return getAtlas(atlasName).getTexture(texturName);
			//return AppModel.instance.assetManager.getTexture(name);
		} 
		
		public static function getItemTextures(state:String):Texture
		{
			return getSclaed9Textures((UserModel.instance.nightMode?"i_":"")+"item_roundrect_"+state);
		}
		
		/**
		 * Returns a scale9Textures from this class based on a string key.
		 * @param name A key that matches a static constant of Bitmap type.
		 * @return a starling scale9Textures.
		 */
		public static function getSclaed9Textures(name:String):Texture
		{
			if(allTextures[name] == undefined)
			{
				var bmp:Bitmap = new Assets[name+"Bitmap"]();
				
				var scale:Number = DeviceCapabilities.dpi/640;
				var bitmapWidth:uint = Math.round(bmp.width*scale*0.5)*2;
				var bitmapHeight:uint = Math.round(bmp.height*scale*0.5)*2;
				var mat:Matrix = new Matrix();
				mat.scale(bitmapWidth/bmp.width, bitmapHeight/bmp.height);
				var destBD:BitmapData = new BitmapData(bitmapWidth, bitmapHeight, true, 0);
				destBD.draw(bmp, mat);
				
				allTextures[name] = Texture.fromBitmapData(destBD);
				//allScaled9Textures[name] = new Scale9Textures(texture, new Rectangle(bitmapWidth/2-1,bitmapHeight/2-1,2,2));
			}
			return allTextures[name];
		}
		
		public static function save():void
		{
			var bmp:Bitmap = new Assets["metalworks_mobileAtlasTexture"]();
			var bmd:BitmapData = bmp.bitmapData;
			
			var atlas:TextureAtlas = getAtlas("metalworks_mobile");
			var names:Vector.<String> = atlas.getNames();
			var textureLen:uint = names.length;
			var textureIndex:uint = 0;
			var textureName:String;
			var bd:BitmapData;
			
			saveTexture();
			function saveTexture():void
			{
				textureName = names[textureIndex];
				bd = new BitmapData(atlas.getRegion(textureName).width, atlas.getRegion(textureName).height);
				bd.copyPixels(bmd, atlas.getRegion(textureName), new Point(0, 0));
				var gts:GTStreamer = new GTStreamer(File.desktopDirectory.resolvePath("as/"+textureName.substr(0, saveTexture.length-4)+".png"), savedTexture, null, null, false, false);
				gts.save(PNGEncoder.encode(bd));
				bd.dispose();
			}
			
			function savedTexture(gts:GTStreamer):void
			{
				textureIndex ++;
				if(textureIndex < names.length)
					saveTexture();
				else
					trace("all textures saved.");
			}
		}
		
	}
}