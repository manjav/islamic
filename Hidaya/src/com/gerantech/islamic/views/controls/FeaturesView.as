package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	
	import flash.utils.setTimeout;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import spine.Event;
	import spine.SkeletonData;
	import spine.SkeletonJson;
	import spine.animation.AnimationStateData;
	import spine.atlas.Atlas;
	import spine.attachments.AtlasAttachmentLoader;
	import spine.starling.SkeletonAnimation;
	import spine.starling.StarlingTextureLoader;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	
	public class FeaturesView extends LayoutGroup
	{
		public function FeaturesView()
		{
			layout = new AnchorLayout();
		}
		
		[Embed(source = "../../assets/images/tutorial/tutorials.atlas", mimeType = "application/octet-stream")]
		static public const SpineboyAtlasFile:Class;
		
		[Embed(source = "../../assets/images/tutorial/tutorials.png")]
		static public const SpineboyAtlasTexture:Class;
		
		[Embed(source = "../../assets/images/tutorial/tutorials.json", mimeType = "application/octet-stream")]
		static public const SpineboyJson:Class;
		
		private var skeleton:SkeletonAnimation;
		private var startButton:Button;
		private var titleDisplay:RTLLabel;
		
		override protected function initialize ():void
		{
			super.initialize();
			autoSizeMode = AUTO_SIZE_MODE_STAGE;
			
			var atlas:Atlas = new Atlas(new SpineboyAtlasFile(), new StarlingTextureLoader(new SpineboyAtlasTexture()));
			var json:SkeletonJson = new SkeletonJson(new AtlasAttachmentLoader(atlas));
			var skeletonData:SkeletonData = json.readSkeletonData(new SpineboyJson());
			
			var stateData:AnimationStateData = new AnimationStateData(skeletonData);
			
			skeleton = new SkeletonAnimation(skeletonData, stateData);
			skeleton.x = Starling.current.nativeStage.stageWidth/2;
			skeleton.y = Starling.current.nativeStage.stageHeight/2;
			skeleton.scaleX = skeleton.scaleY = Math.min(Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight)/520;
			
			setTimeout(startSplash, 1000);
			skeleton.state.onComplete.add(animationCompleted);
			skeleton.state.onEvent.add(animationEventHandler);
		}
		
		private function animationEventHandler(trackIndex:int, event:spine.Event):void
		{
			setTitle("tute_"+event.data.name);
		}
		
		private function animationCompleted (trackIndex:int, count:int):void 
		{
			var state:String;
			switch(skeleton.state.getCurrent(trackIndex).animation.name)
			{
				case "appear":
					state = ("listen");
					showButton();
					break;
				
				case "listen":
					state = ("read");
					break;
				
				case "read":
					state = ("search");
					break;
				
				case "search":
					state = ("listen");
					break;
			}
			skeleton.state.setAnimationByName(0, state, false);
		}

		
		private function startSplash():void
		{
			skeleton.state.setAnimationByName(0, "appear", false);
			Starling.juggler.add(skeleton);		
			addChild(skeleton);
			
			titleDisplay = new RTLLabel("", BaseMaterialTheme.CHROME_COLOR, "center", null, true, null, 0, null, "bold");
		//	titleDisplay.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0);
			titleDisplay.x = (width)/2
			titleDisplay.y = AppModel.instance.itemHeight;
			titleDisplay.width = width-AppModel.instance.itemHeight*2;
			titleDisplay.pivotX = titleDisplay.width/2;
			addChild(titleDisplay);
			
			setTimeout(setTitle, 1500, "app_title");
		}
		
		private function setTitle(str:String):void
		{
			titleDisplay.text = ResourceManager.getInstance().getString("loc", str);
			titleDisplay.pivotY = titleDisplay.height/2;
			titleDisplay.alpha = 0;
			titleDisplay.scaleX = titleDisplay.scaleY = 0.5;
			
			var tw:Tween = new Tween(titleDisplay, 0.4, Transitions.EASE_OUT_BACK);
			tw.fadeTo(1);
			tw.scaleTo(1);
			Starling.juggler.add(tw);
		}
		
		private function showButton():void
		{
			startButton = new Button();
			startButton.label = "  شـــروع  ";
			startButton.layoutData = new AnchorLayoutData(NaN, NaN, AppModel.instance.itemHeight/2, NaN, 0);
			startButton.addEventListener("triggered", startButton_triggeredHandler);
			addChild(startButton);
			
			startButton.alpha = 0;
			var tw:Tween = new Tween(startButton, 0.5);
			tw.fadeTo(1);
			Starling.juggler.add(tw);
		}
		
		private function startButton_triggeredHandler():void
		{
			dispatchEventWith("complete");
			
		}
		
	}
}