package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	
	import starling.display.Canvas;
	import starling.geom.Polygon;
	
	
	/**
	 * Progress bar with radial mask.
	 * @author Jakub Wagner, J4W
	 */
	public class CicularProgressBar2 extends LayoutGroup 
	{
		private var background:ImageLoader;
		private var canvas:Canvas;
		private var polygon:Polygon;
		
		private var sides:Number = 32;
		private var _value:Number = 0;
		private var radius:Number;
		
		
		
		override protected function initialize():void 
		{
			super.initialize();
			
			layout = new AnchorLayout();
			
			/*
			background = new ImageLoader();
			background.source = Assets.getTexture("action");
			background.layoutData = new AnchorLayoutData(0,0,0,0);
			addChild(background);*/
			
			addEventListener(FeathersEventType.CREATION_COMPLETE, creationCompleteHandler);
		}
		
		private function creationCompleteHandler():void
		{
			radius = height / 2;
			canvas = new Canvas();
			addChild(canvas);			
			//background.mask = canvas;
		}
		
		/*override protected function draw():void 
		{
			super.draw();
			
			var radius:Number = progress.width / 2;
			
			polygon = new Polygon();
			updatePolygon(value, radius, radius, radius, Math.PI / 2);
			
			canvas.clear();
			canvas.beginFill(0xFF0000);
			canvas.drawPolygon(polygon);
			canvas.endFill();
		}*/
		
		public function get value():Number
		{
			return _value;
		}
		
		public function set value(value:Number):void
		{
			if (_value == value)
				return;
			
			invalidate(INVALIDATION_FLAG_DATA);
			_value = value;
			
			if(canvas == null)
				return;
			
			polygon = new Polygon();
			updatePolygon(_value, radius, radius, radius, Math.PI / 2);
			
			canvas.clear();
			canvas.beginFill(BaseMaterialTheme.CHROME_COLOR);
			canvas.drawPolygon(polygon);
			canvas.endFill();

		}
		
		[Inline]
		private function lineToRadians(rads:Number, radius:Number, x:Number, y:Number):void
		{
			polygon.addVertices(Math.cos(rads) * radius + x, Math.sin(rads) * radius + y);
		}
		
		private function updatePolygon(percentage:Number, radius:Number = 50, x:Number = 0, y:Number = 0, rotation:Number = 0):void 
		{
			polygon.addVertices(x, y);
			if (sides < 3)
				sides = 3; // 3 sides minimum
			
			radius /= Math.cos(1 / sides * Math.PI);
			
			var sidesToDraw:int = Math.floor(percentage * sides);
			for (var i:int = 0; i <= sidesToDraw; i++)
				lineToRadians((i / sides) * (Math.PI * 2) + rotation, radius, x, y);
			
			if (percentage * sides != sidesToDraw)
				lineToRadians(percentage * (Math.PI * 2) + rotation, radius, x, y);
		}
	}
	
}