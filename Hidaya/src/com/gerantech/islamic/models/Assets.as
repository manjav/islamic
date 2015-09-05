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
		
		
		/*[Embed(source="../assets/images/skin/bookmark_on.png")]
		public static const bookmark_on:Class;
		[Embed(source="../assets/images/skin/bookmark_off.png")]
		public static const bookmark_off:Class;
		[Embed(source="../assets/images/skin/download.png")]
		public static const download:Class;
		[Embed(source="../assets/images/skin/cancel_download.png")]
		public static const cancel_download:Class;
		[Embed(source="../assets/images/skin/check_off.png")]
		public static const check_off:Class;
		[Embed(source="../assets/images/skin/check_on.png")]
		public static const check_on:Class;
		[Embed(source="../assets/images/skin/setting.png")]
		public static const setting:Class;
		[Embed(source="../assets/images/skin/list_bulleted.png")]
		public static const list_bulleted:Class;
		[Embed(source="../assets/images/skin/translation.png")]
		public static const translation:Class;
		[Embed(source="../assets/images/skin/dots.png")]
		public static const dots:Class;
		[Embed(source="../assets/images/skin/chevron_g.png")]
		public static const chevron_g:Class;
		[Embed(source="../assets/images/skin/chevron_w.png")]
		public static const chevron_w:Class;
		[Embed(source="../assets/images/skin/recitation.png")]
		public static const recitation:Class;
		[Embed(source="../assets/images/skin/search.png")]
		public static const search:Class;
		[Embed(source="../assets/images/skin/menu.png")]
		public static const menu:Class;
		[Embed(source="../assets/images/skin/arrow_g_left.png")]
		public static const arrow_g_left:Class;
		[Embed(source="../assets/images/skin/arrow_g_right.png")]
		public static const arrow_g_right:Class;
		[Embed(source="../assets/images/skin/arrow_w_left.png")]
		public static const arrow_w_left:Class;
		[Embed(source="../assets/images/skin/arrow_w_right.png")]
		public static const arrow_w_right:Class;
		[Embed(source="../assets/images/skin/remove.png")]
		public static const remove:Class;
		[Embed(source="../assets/images/skin/drag.png")]
		public static const drag:Class;
		[Embed(source="../assets/images/skin/close_g.png")]
		public static const close_g:Class;
		[Embed(source="../assets/images/skin/close_w.png")]
		public static const close_w:Class;
		[Embed(source="../assets/images/skin/jump.png")]
		public static const jump:Class;
		[Embed(source="../assets/images/skin/star.png")]
		public static const star:Class;
		[Embed(source="../assets/images/skin/share_variant.png")]
		public static const share_variant:Class;
		[Embed(source="../assets/images/skin/email.png")]
		public static const email:Class;
		[Embed(source="../assets/images/skin/logout.png")]
		public static const logout:Class;
		[Embed(source="../assets/images/skin/info.png")]
		public static const info:Class;
		[Embed(source="../assets/images/skin/compass.png")]
		public static const compass:Class;
		[Embed(source="../assets/images/skin/repeat_grey.png")]
		public static const repeat_grey:Class;
		
		
		[Embed(source="../assets/images/skin/share_circle.png")]
		public static const share_circle:Class;
		[Embed(source="../assets/images/skin/bookmark_on_circle.png")]
		public static const bookmark_on_circle:Class;
		[Embed(source="../assets/images/skin/bookmark_off_circle.png")]
		public static const bookmark_off_circle:Class;
		
		[Embed(source="../assets/images/skin/action_plus.png")]
		public static const action_plus:Class;
		[Embed(source="../assets/images/skin/action_player.png")]
		public static const action_player:Class;
		[Embed(source="../assets/images/skin/action_play.png")]
		public static const action_play:Class;
		[Embed(source="../assets/images/skin/action_pause.png")]
		public static const action_pause:Class;
		[Embed(source="../assets/images/skin/action_timer.png")]
		public static const action_timer:Class;
		[Embed(source="../assets/images/skin/action_danger.png")]
		public static const action_danger:Class;
		[Embed(source="../assets/images/skin/action_item_0.png")]
		public static const action_item_0:Class;
		[Embed(source="../assets/images/skin/action_item_1.png")]
		public static const action_item_1:Class;
		[Embed(source="../assets/images/skin/action_item_2.png")]
		public static const action_item_2:Class;
		[Embed(source="../assets/images/skin/action_item_3.png")]
		public static const action_item_3:Class;
		
		
		[Embed(source="../assets/images/skin/dialog.png")]
		public static const dialog:Class;
		[Embed(source="../assets/images/skin/shadow.png")]
		public static const shadow:Class;
		[Embed(source="../assets/images/skin/shadow_left.png")]
		public static const shadow_left:Class;
		[Embed(source="../assets/images/skin/shadow_right.png")]
		public static const shadow_right:Class;
		[Embed(source="../assets/images/skin/shadow_paper_left.png")]
		public static const shadow_paper_left:Class;
		[Embed(source="../assets/images/skin/shadow_paper_right.png")]
		public static const shadow_paper_right:Class;
		[Embed(source="../assets/images/skin/item_roundrect_down.png")]
		public static const item_roundrect_down:Class;
		[Embed(source="../assets/images/skin/item_roundrect_normal.png")]
		public static const item_roundrect_normal:Class;
		[Embed(source="../assets/images/skin/item_roundrect_selected.png")]
		public static const item_roundrect_selected:Class;
		[Embed(source="../assets/images/skin/undo_sign.png")]
		public static const undo_sign:Class;
		[Embed(source="../assets/images/skin/round_alert.png")]
		public static const round_alert:Class;
		
		[Embed(source="../assets/images/skin/circle_mask.png")]
		public static const circle_mask:Class;
		[Embed(source="../assets/images/skin/circle.png")]
		public static const circle:Class;
		[Embed(source="../assets/images/skin/toolbar_button_bg.png")]
		public static const toolbar_button_bg:Class;

		[Embed(source="../assets/images/skin/hizb_0_4.png")]
		public static const hizb_0_4:Class;
		[Embed(source="../assets/images/skin/hizb_1_4.png")]
		public static const hizb_1_4:Class;
		[Embed(source="../assets/images/skin/hizb_2_4.png")]
		public static const hizb_2_4:Class;
		[Embed(source="../assets/images/skin/hizb_3_4.png")]
		public static const hizb_3_4:Class;
		
		[Embed(source="../assets/images/skin/meccan_icon.png")]
		public static const meccan_icon:Class;
		[Embed(source="../assets/images/skin/medinan_icon.png")]
		public static const medinan_icon:Class;

		[Embed(source="../assets/images/skin/bism_header.png")]
		public static const bism_header:Class;
		*/
		
		/*[Embed(source="../assets/images/atlases/suras_juzes.png")]
		public static const suras_juzes:Class;
		[Embed(source="../assets/images/atlases/suras_juzes.xml", mimeType="application/octet-stream")]
		public static const suras_juzesXML:Class;
		
		[Embed(source="../assets/images/atlases/skin.png")]
		public static const skin_atlas:Class;
		[Embed(source="../assets/images/atlases/skin.xml", mimeType="application/octet-stream")]
		public static const skin_atlasXML:Class;*/
		private static var sclaed9Names:Array;
		private static var sclaed9NamesComplete:Function;
		
		
		
		public static function getTexture(name:String):Texture
		{
			/*if (allTextures[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]();
				allTextures[name] = Texture.fromBitmap(bitmap);
			}
			return allTextures[name];*/
			return AppModel.instance.assetManager.getTexture(name);
		}
		
		/*private static var skinAtlas:TextureAtlas;
		public static function getSkinAtlas():TextureAtlas
		{
			if (skinAtlas == null)
			{
				var texture:Texture = getTexture("skin_atlas");
				var xml:XML = new XML(new skin_atlasXML());
				skinAtlas = new TextureAtlas(texture, xml);
			}
			return skinAtlas;
		}
		
		private static var suras_juzesAtlas:TextureAtlas;
		public static function getSurasJuzesAtlas():TextureAtlas
		{
			if (suras_juzesAtlas == null)
			{
				var texture:Texture = getTexture("suras_juzes");
				var xml:XML = new XML(new suras_juzesXML());
				suras_juzesAtlas = new TextureAtlas(texture, xml);
			}
			return suras_juzesAtlas;
		}*/
		
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
			/*if (allScaled9Textures[name] == undefined)
			{
				var scale:Number = DeviceCapabilities.dpi/640;
				var bitmap:Bitmap = new Assets[name]();
				var bitmapWidth:uint = Math.round(bitmap.width*scale*0.5)*2;
				var bitmapHeight:uint = Math.round(bitmap.height*scale*0.5)*2;
				var mat:Matrix = new Matrix();
				mat.scale(bitmapWidth/bitmap.width, bitmapHeight/bitmap.height);
				var bd:BitmapData = new BitmapData(bitmapWidth, bitmapHeight, true, 0);
				bd.draw(bitmap, mat);
				var texture:Texture = getTexture(name);//Texture.fromBitmapData(bd);//trace( DeviceCapabilities.dpi, scale, texture.width, texture.height)
					
				allScaled9Textures[name] = new Scale9Textures(texture, new Rectangle(texture.width/2-1,texture.height/2-1,2,2));
			}*/
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