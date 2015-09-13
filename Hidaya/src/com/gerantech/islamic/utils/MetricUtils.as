package com.gerantech.islamic.utils
{
	import flash.display.Stage;
	
	import feathers.system.DeviceCapabilities;

	public class MetricUtils
	{
		public function MetricUtils(dpi:Number, stage:Stage)
		{
			_dpi = dpi;
			_scale = _dpi/160;
			var isTablet:Boolean = DeviceCapabilities.isTablet(stage);
			
			trace("scale", _scale, "dpi", _dpi)
			_toolbar = Math.round(56*_scale);
			_subtitle = Math.round(48*_scale);
			_listItem = Math.round((isTablet?64:72)*_scale);
			_menuItem = Math.round((isTablet?48:48)*_scale);
			_orginalFontSize = Math.round(15*_scale);//uint(height/40+2);
			_border = Math.round(4*_scale);
			
			width = _orginalWidth = stage.stageWidth;
			_orginalHeightFull = heightFull = stage.stageHeight;
			_orginalHeight = height = heightFull-toolbar;
			
			_DP72 = Math.round(72*_scale);
			_DP32 = Math.round(32*_scale);
			_DP16 = Math.round(16*_scale);
			_DP8 = Math.round(8*_scale);
			_DP4 = Math.round(4*_scale);
		}
		
		public function getPixelByDP(dp:uint):uint
		{
			return Math.round(dp*_scale);
		}
		
		private var _dpi:Number;
		public function get dpi():Number{return _dpi;}

		private var _scale:Number;
		public function get scale():Number{return _scale;}
		
		private var _toolbar:uint = 66;
		public function get toolbar():uint{return _toolbar;}
		
		private var _subtitle:uint = 66;
		public function get subtitle():uint{return _subtitle;}
		
		private var _menuItem:Number;
		public function get menuItem():uint{return _menuItem;}

		private var _listItem:uint = 80;
		public function get listItem():uint{return _listItem;}
		
		private var _border:uint = 0;
		public function get border():uint{return _border;}
		
		private var _DP72:Number;
		public function get DP72():uint{return _DP72;}
		
		private var _DP32:Number;
		public function get DP32():uint{return _DP32;}
		
		private var _DP16:Number;
		public function get DP16():uint{return _DP16;}
		
		private var _DP8:Number;
		public function get DP8():uint{return _DP8;}
		
		private var _DP4:Number;
		public function get DP4():uint{return _DP4;}

		private var _orginalFontSize:uint;
		public function get orginalFontSize():uint{return _orginalFontSize;}
		
		private var _orginalWidth:Number;
		public function get orginalWidth():Number{return _orginalWidth;}
		
		private var _orginalHeight:Number;
		public function get orginalHeight():Number{return _orginalHeight;}
		
		private var _orginalHeightFull:Number;
		public function get orginalHeightFull():Number{return _orginalHeightFull;}
		
		
		public var width:Number;
		public var height:Number;
		public var heightFull:Number;

		
		public function resize(width:int, height:int):void
		{
			this.width = 			width;
			heightFull = 			height;
			height = 				height - toolbar;			
		}
	}
}