package com.gerantech.islamic.views.items
{
	
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Aya;
	import com.gerantech.islamic.models.vo.BaseQData;
	import com.gerantech.islamic.models.vo.Page;
	import com.gerantech.islamic.models.vo.Sura;
	import com.gerantech.islamic.models.vo.media.Breakpoint;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.buttons.SimpledButton;
	import com.gerantech.islamic.views.headers.SuraHeader;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.engine.FontLookup;
	
	import feathers.controls.LayoutGroup;
	import feathers.controls.ScrollContainer;
	import feathers.events.FeathersEventType;
	import feathers.layout.VerticalLayout;
	
	import fl.text.TLFTextField;
	
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.Direction;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.formats.VerticalAlign;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	import starling.textures.Texture;
	
	
	public class UthmaniPage extends ScrollContainer
	{
		
		private var page:Page;
		private var strList:Array;
		private var buttonList:Array;
		private var fontSized:int = 44;
		
		private var quran_txt:TLFTextField;
		private var formatLayout:TextLayoutFormat;
		private var myTextFlow:TextFlow;
		
		private var headerContainer:LayoutGroup;

		private var mainWidth:Number;
		private var mainHeight:Number;
		private var lineHeight:Number = 46;
		
		private var _selectedItem:Breakpoint;
		private var _selectedIndex:int = -1;
		private var scrollLayout:VerticalLayout;
		
		private var _padding:Number;
		private var appModel:AppModel;

		private var bitmapData:BitmapData;
		
		public function UthmaniPage(page:Page, width:Number, headerHeight:Number = 30, r:Number=0)
		{
			appModel = AppModel.instance;
			
			var accpectRatio:Number = appModel.upside ? (appModel.sizes.orginalHeight-headerHeight)/appModel.sizes.orginalWidth : (appModel.sizes.orginalWidth-headerHeight)/appModel.sizes.orginalHeight;
			r = r==0 ? Math.max(1.4, accpectRatio) : r;
			mainWidth = width;
			mainHeight = width*r;
			
			scrollLayout = new VerticalLayout();
			scrollLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			scrollLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			scrollLayout.paddingTop = headerHeight;
			scrollLayout.paddingBottom = ResourceModel.instance.selectedReciters.length>0?AppModel.instance.sizes.toolbar*1.6:0
			layout = scrollLayout;
			
			scrollBarDisplayMode = SCROLL_BAR_DISPLAY_MODE_NONE;
			elasticity = 0.1;
			decelerationRate = 0.98;
			//verticalScrollBarPosition = ScrollContainer.VERTICAL_SCROLL_BAR_POSITION_RIGHT;
			horizontalScrollPolicy = SCROLL_POLICY_OFF;

			if(page.text==null)
				page.create();
							
			this.page = page;
			this._padding = mainWidth*0.03;
			this.lineHeight = (mainHeight-_padding*2)/15;
			
			/*if(page.index<2)
			{
			//	page.text = "" + page.text;
				mainHeight /= 2;
			}*/
			
			quran_txt = new TLFTextField();
			//quran_txt.border = true
			quran_txt.width = mainWidth;
			quran_txt.height = mainHeight;
			quran_txt.paddingTop = quran_txt.paddingBottom = quran_txt.paddingRight = quran_txt.paddingLeft = _padding;
			//quran_txt.paddingTop = mainHeight/40;
			quran_txt.mouseEnabled = quran_txt.mouseChildren = false;
			quran_txt.antiAliasType = AntiAliasType.ADVANCED;
			quran_txt.embedFonts = true;
			quran_txt.multiline = quran_txt.wordWrap = true;
			quran_txt.text = page.text;//trace(page.text)
			
			formatLayout = new TextLayoutFormat();
			formatLayout.fontFamily = UserModel.instance.font.value;
			formatLayout.fontLookup = FontLookup.EMBEDDED_CFF;
			formatLayout.color = BaseMaterialTheme.PRIMARY_TEXT_COLOR;
			formatLayout.direction = Direction.RTL;
			formatLayout.verticalAlign = page.index>1 ? VerticalAlign.JUSTIFY : VerticalAlign.MIDDLE;
			formatLayout.textAlign = page.index>1 ? TextAlign.JUSTIFY : TextAlign.CENTER;
			formatLayout.textAlignLast = formatLayout.textAlign = page.index>1 ? TextAlign.JUSTIFY : TextAlign.CENTER;
			formatLayout.lineHeight = lineHeight;
			formatLayout.fontSize = fontSized = mainWidth/19;
			
			myTextFlow = quran_txt.textFlow;
			
			setSizeText();
			
			var _w:Number = mainWidth;
			var _h:Number = mainHeight;
			var rate:Number = 1;
			/*if(mainHeight>1024 && mainHeight<2048)
			{
				rate = 1024/mainHeight;
				_h = 1024;
				_w *= rate;
			}
			else */if(mainHeight>=2048)
			{
				rate = 2048/mainHeight;
				_h = 2048;
				_w *= rate;
			}//trace(_w, _h, mainWidth, mainHeight, rate)
			
			var mat:Matrix = new Matrix();
			mat.scale(rate, rate);
			if(bitmapData!=null)
				bitmapData.dispose();
			
			bitmapData = new BitmapData(_w, _h, true, 0)
			bitmapData.draw(quran_txt, mat);
			
			var image:Image = new Image(Texture.fromBitmapData(bitmapData));
			image.width = mainWidth;
			image.height = mainHeight//(page.index<3?2:1);
			addChild(image);
									
			addHeaders();
			createButtons();
			
			//bitmapData.dispose();
			//bitmapData = null;
			
			formatLayout = null;
			quran_txt = null;
			myTextFlow = null;
		}
		
		
		
		private function setSizeText():void
		{
			//if(page.surasList.length)
			//	trace(page.surasList[page.surasList.length-1], quran_txt.length	);
			do
			{
				formatLayout.fontSize = fontSized;
				myTextFlow.hostFormat = formatLayout;
				fontSized --;
			}
			while(quran_txt.numLines > 15)
			
			myTextFlow.flowComposer.updateAllControllers();			
			fontSized ++;
		}
		
		private function addHeaders():void
		{
			if(headerContainer==null)
				headerContainer = new LayoutGroup();
			
			headerContainer.y = scrollLayout.paddingTop;
			headerContainer.includeInLayout = false
			addChild(headerContainer);
			
			if(page.index<=1)
				return;
			
			var invert:ColorMatrixFilter = new ColorMatrixFilter();
			invert.invert();

			
			var suras:Vector.<Sura> = page.getSuras();
			for(var s:uint=0; s<suras.length; s++)
			{
				//lineHeight = mainHeight/15;
				var sh:SuraHeader = new SuraHeader(suras[s], mainWidth, lineHeight);
				
				if(page.surasList[s]<quran_txt.length)
					sh.y = quran_txt.getCharBoundaries(page.surasList[s]-s).y  + _padding/2//-uint(quran_txt.paddingTop)/2;
				else
					sh.y = quran_txt.height - sh.height;
				
				headerContainer.addChild(sh);
				
				if(UserModel.instance.nightMode)
					sh.filter = invert;
			}
			
			for(var b:uint=0; b<page.bismsList.length; b++)
			{
				var bism:Image = new Image(Assets.getTexture("bism_header"));
				bism.height = lineHeight*0.8;
				bism.scaleX = bism.scaleY;
				bism.x = (mainWidth-bism.width)/2;
			//	bism.y = quran_txt.getCharBoundaries(page.bismsList[b]).y//-uint(quran_txt.paddingTop)/3;
				bism.y = quran_txt.getCharBoundaries(page.bismsList[b]).y + _padding/2;
				//sh.y = Math.round(sh.y/lineHeight)*lineHeight + 
				headerContainer.addChild(bism);
				
				if(UserModel.instance.nightMode)
					bism.filter = invert;
			}
		}
		
		public function createButtons():void
		{
			removeButtons();
			buttonList = new Array();
			ResourceModel.instance.playerAyaList = new Array()
			for each(var a:Aya in page.ayas)
			{
				buttonList[a.order] = getButton(a);
				headerContainer.addChild(buttonList[a.order]);
				ResourceModel.instance.playerAyaList.push(a);
			}
		}
		
		private function getButton(aya:Aya, time:uint=0):Breakpoint
		{
			var rectH:Number = quran_txt.height/quran_txt.numLines;
			var rect1:Rectangle = quran_txt.getCharBoundaries(aya.start);// rect1.y=quran_txt.getLineIndexOfChar(aya.start)*lineHeight+_padding; rect1.height=lineHeight;
			var rect2:Rectangle = quran_txt.getCharBoundaries(aya.end); //rect2.y=quran_txt.getLineIndexOfChar(aya.end)*lineHeight+_padding; rect2.height=lineHeight;
			
			var myRc:Breakpoint = new Breakpoint;
			myRc.aya = aya;
			myRc.sura = aya.sura;
			myRc.page = page.page;
			myRc.juze = page.juze;

			myRc.time = time;
			myRc.y = rect1.y;
			//myRc.graphics.beginFill(color, _alpha);
			if(Math.round(rect1.y)/5 == Math.round(rect2.y)/5)
			{
				//myRc.graphics.drawRoundRect(rect2.x, 0, rect1.x-rect2.x+rect2.width, rect1.height, 16, 16);
				myRc.draw(rect2.x, 0, rect1.x-rect2.x+rect2.width, rect1.height);
			} 
			else
			{
				myRc.draw(0, 0, rect1.x+rect1.width, rect1.height);
				//myRc.graphics.drawRoundRectComplex(0, 0, rect1.x+rect1.width, rect1.height, 0, 8, 0, 8);
				var hi:Number = rect2.y-rect1.y-rect1.height;
				var wi:Number = mainWidth;
				if(wi>0 && hi>0)
				myRc.draw(0, rect1.height, mainWidth, rect2.y-rect1.y-rect1.height);
				//myRc.graphics.drawRect(0, rect1.height, _width, rect2.y-rect1.y-rect1.height);
				myRc.draw(rect2.x, rect2.y-rect1.y, mainWidth-rect2.x, rect2.height);
				//myRc.graphics.drawRoundRectComplex(rect2.x, rect2.y-rect1.y, _width-rect2.x, rect2.height, 8, 0, 8, 0);
			}
			
			myRc.addEventListener(Event.TRIGGERED, clickCaller);
			myRc.addEventListener(FeathersEventType.LONG_PRESS, clickCaller);
			return myRc;
		}
		
		private function clickCaller(event:Event):void
		{
			var breakPoint:Breakpoint = event.currentTarget as Breakpoint;
			selectedIndex = buttonList.indexOf(breakPoint);
			//trace(event.type, Breakpoint(event.currentTarget).toString())
		}
		
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		public function set selectedIndex(value:int):void
		{
			if(buttonList==null || _selectedIndex ==value)
				return;
			
			_selectedIndex = value;
			selectedItem = buttonList[_selectedIndex];
		}
		
		public function get selectedItem():Breakpoint
		{
			return _selectedItem;
		}
		public function set selectedItem(value:Breakpoint):void
		{
			if(buttonList==null || _selectedItem ==value)
				return;
			
			_selectedItem = value;
			for each(var b:Breakpoint in buttonList)
				b.currentState = (b==value) ? SimpledButton.STATE_SELECTED : SimpledButton.STATE_UP;
				
			dispatchEventWith(Event.CHANGE, false, _selectedItem);
		}

		public function selectByLastItem(lastItem:BaseQData):Breakpoint
		{
			for each(var b:Breakpoint in buttonList)
				if(b.sura==lastItem.sura && b.aya.aya==lastItem.aya)
					return(selectedItem = b);
			return null;
		}
		
		
		
		
		
		
		public function replaceButtons(_inputBreaks:Array):void
		{
			var i:uint;
			var j:uint;
			var mylist:Array;
			var spliceList:Array = new Array;
			
			for(var c:uint=0; c<buttonList.length; c++)
			{
				mylist = new Array;
				i = 0;
				for(var b:uint=0; b<_inputBreaks.length; b++)
				{
					if(_inputBreaks[b].start >= buttonList[c].start && _inputBreaks[b].end <= buttonList[c].end)
					{
						_inputBreaks[b].index = i;
						_inputBreaks[b].verse = buttonList[c].verse;
						_inputBreaks[b].sura = buttonList[c].sura;
						mylist[i] = _inputBreaks[b];
						i++;
						j++;
					}
				}
				spliceList[c] = mylist;
			}
			var kk:int=spliceList.length-1
			for(var s:int=kk; s>=0; s--)
			{
				if(spliceList[s].length)
				{
					buttonList.splice(s, 1)
					for(var n:int=spliceList[s].length-1; n>=0; n--)
					{
						buttonList.splice(s, 0, spliceList[s][n])
					}
				}
			}
			removeButtons();
			for(var d:uint=0; d<buttonList.length; d++)
			{
				buttonList[d] = getButton(buttonList[d].aya, buttonList[d].time);
				headerContainer.addChild(buttonList[d]);
			}
		}
		
		private function removeButtons():void
		{
			for each(var b:Breakpoint in buttonList)
			{
				if(b.parent == headerContainer)
				{
					headerContainer.removeChild(b);
				}
			}
		}
		
		public function updateButtons(_inputBreaks:Array):void
		{//trace(buttonList.length, _inputBreaks.length)
			for(var b:uint=0; b<_inputBreaks.length; b++)
			{
				buttonList[b].time = _inputBreaks[b].time;
				buttonList[b].length = _inputBreaks[b].length;
			}
		}
		
		
		public function scrollToSelectedItem():void
		{
			scrollToPosition(0, Math.min(selectedItem.y, mainHeight+scrollLayout.paddingBottom+scrollLayout.paddingTop-height), 0.5);//trace("scrollToSelectedItem", uthmaniPage.selectedItem.y)
			//trace(selectedItem.y , height+scrollLayout.paddingBottom+scrollLayout.paddingTop-height)
		}
	}
}
