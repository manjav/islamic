package com.gerantech.islamic.views.popups
{
	import com.gerantech.islamic.views.controls.FeaturesView;
	import com.gerantech.islamic.views.items.TutorialItemRenderer;
	
	import feathers.controls.List;
	import feathers.controls.ScrollContainer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;

	public class TutorialPopUp extends BasePopUp
	{
		private var list:List;
		private var selectedTute:int;

		private var tutes:Array;
		private var features:FeaturesView;
		
		public function TutorialPopUp()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			
			backgroundSkin = new Quad(1,1);
			backgroundSkin.alpha = 0.85;
			
			features = new FeaturesView();
			features.layoutData = new AnchorLayoutData(0,0,0,0);
			features.addEventListener(Event.COMPLETE, features_completeHandler);
			addChild(features);
		}
		
		private function features_completeHandler():void
		{
			removeChildren();
			
			tutes = ["swipe", "zoom"];
			if(!appModel.ltr)
				tutes.reverse();
			
			selectedTute = appModel.ltr ? 0 : tutes.length-1;
			
			list = new List();
			list.layout = new HorizontalLayout();
			list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			list.itemRendererFactory = function():IListItemRenderer
			{
				return new TutorialItemRenderer();
			};
			list.dataProvider = new ListCollection(tutes);
			list.snapToPages = true;
			list.autoHideBackground = true;
			list.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			//list.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			//list.addEventListener("addAya", list_ayaChangedHandler);
			list.addEventListener("next", list_nextHandler);
			list.scrollToPageIndex(selectedTute, 0, 0);
			addChild(list);
		}
		
		private function list_nextHandler():void
		{
			if(appModel.ltr)
				selectedTute++;
			else
				selectedTute--;
				
			if(selectedTute==-1||selectedTute==tutes.length)
				Starling.juggler.tween(this, 0.4, {alpha:0, onComplete:close});
				//TweenLite.to(this, 0.4, {alpha:0, onComplete:close});
				
			list.scrollToPageIndex(selectedTute, 0, 0.5);
		}		
	}
}