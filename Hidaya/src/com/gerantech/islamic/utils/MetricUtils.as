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
			
			//trace("scale", _scale, "dpi", _dpi)
			_toolbar = getPixelByDP(56);
			_subtitle = getPixelByDP(48);
			_singleLineItem = getPixelByDP(isTablet?48:56);
			_twoLineItem = getPixelByDP(isTablet?64:72);
			_threeLineItem = getPixelByDP(88);
			_menuItem = getPixelByDP(isTablet?48:48);
			_orginalFontSize = getPixelByDP(14);//uint(height/40+2);
			_border = getPixelByDP(4);
			
			width = _orginalWidth = stage.stageWidth;
			_orginalHeightFull = heightFull = stage.stageHeight;
			_orginalHeight = height = heightFull-toolbar;
			
			_DP72 = getPixelByDP(72);
			_DP64 = getPixelByDP(64);
			_DP48 = getPixelByDP(48);
			_DP40 = getPixelByDP(40);
			_DP36 = getPixelByDP(36);
			_DP32 = getPixelByDP(32);
			_DP24 = getPixelByDP(24);
			_DP16 = getPixelByDP(16);
			_DP8 = getPixelByDP(8);
			_DP4 = getPixelByDP(4);
		}
		
		public function getPixelByDP(dp:uint):uint
		{
			return Math.round(dp*_scale);
		}
		
		private var _dpi:Number;
		public function get dpi():Number{return _dpi;}

		private var _scale:Number;
		public function get scale():Number{return _scale;}
		
		private var _toolbar:uint = 56;
		public function get toolbar():uint{return _toolbar;}
		
		private var _subtitle:uint = 48;
		public function get subtitle():uint{return _subtitle;}
		
		private var _menuItem:Number;
		public function get menuItem():uint{return _menuItem;}

		private var _singleLineItem:uint = 56;
		public function get singleLineItem():uint{return _singleLineItem;}
		
		private var _twoLineItem:uint = 72;
		public function get twoLineItem():uint{return _twoLineItem;}
		
		private var _threeLineItem:uint = 88;
		public function get threeLineItem():uint{return _threeLineItem;}
		
		private var _border:uint = 0;
		public function get border():uint{return _border;}
		
		private var _DP72:Number;
		public function get DP72():uint{return _DP72;}
		
		private var _DP64:Number;
		public function get DP64():uint{return _DP64;}
		
		private var _DP48:Number;
		public function get DP48():uint{return _DP48;}
		
		private var _DP40:Number;
		public function get DP40():uint{return _DP40;}
		
		private var _DP36:Number;
		public function get DP36():uint{return _DP36;}
		
		private var _DP32:Number;
		public function get DP32():uint{return _DP32;}
		
		private var _DP24:Number;
		public function get DP24():uint{return _DP24;}
		
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