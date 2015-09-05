package com.gerantech.islamic.views.screens
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import com.gerantech.islamic.models.vo.Item;
	import com.gerantech.islamic.themes.BaseMaterialTheme;
	import com.gerantech.islamic.views.buttons.SimpleLayoutButton;
	import com.gerantech.islamic.views.controls.RTLLabel;
	
	import flash.utils.setTimeout;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.ScrollContainer;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.display.Quad;
	import starling.events.Event;

	public class OmenScreen extends BaseScreen
	{
		private var hint:RTLLabel;
		private var button:SimpleLayoutButton;

		private var waitingIcon:ImageLoader;

		public function OmenScreen()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			var padding:Number = appModel.border*4;
			layout = new AnchorLayout()
			
			var scroller:ScrollContainer = new ScrollContainer();
			scroller.layoutData = new AnchorLayoutData(padding,padding,padding,padding);
			scroller.layout = new AnchorLayout();
			addChild(scroller);
			
			var arabic:String = "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ\n";
			if(userModel.locale.value=="fa_IR")
				arabic += "اللَّهُمَّ إِنِيِّ أَسْتَخِيرُكَ بِعِلْمِكَ، فَصَلِّ عَلَى مُحَمَّدٍ وَ آلِهِ، وَ اقْضِ لِي بِالْخِيَرَةِ وَ أَلْهِمْنَا مَعْرِفَةَ الِاخْتِيَارِ، وَ اجْعَلْ ذَلِكَ ذَرِيعَةً إِلَى الرِّضَا بِمَا قَضَيْتَ لَنَا وَ التَّسْلِيمِ لِمَا حَكَمْتَ فَأَزِحْ عَنَّا رَيْبَ الِارْتِيَابِ، وَ أَيِّدْنَا بِيَقِينِ الْمُخْلِصِينَ. وَ لَا تَسُمْنَا عَجْزَ الْمَعْرِفَةِ عَمَّا تَخَيَّرْتَ فَنَغْمِطَ قَدْرَكَ، وَ نَكْرَهَ مَوْضِعَ رِضَاكَ، وَ نَجْنَحَ إِلَى الَّتِي هِيَ أَبْعَدُ مِنْ حُسْنِ الْعَاقِبَةِ، وَ أَقْرَبُ إِلَى ضِدِّ الْعَافِيَةِ حَبِّبْ إِلَيْنَا مَا نَكْرَهُ مِنْ قَضَائِكَ، وَ سَهِّلْ عَلَيْنَا مَا نَسْتَصْعِبُ مِنْ حُكْمِكَ وَ أَلْهِمْنَا الِانْقِيَادَ لِمَا أَوْرَدْتَ عَلَيْنَا مِنْ مَشِيَّتِكَ حَتَّى لَا نُحِبَّ تَأْخِيرَ مَا عَجَّلْتَ، وَ لَا تَعْجِيلَ مَا أَخَّرْتَ، وَ لَا نَكْرَهَ مَا أَحْبَبْتَ، وَ لَا نَتَخَيَّرَ مَا كَرِهْتَ. وَ اخْتِمْ لَنَا بِالَّتِي هِيَ أَحْمَدُ عَاقِبَةً، وَ أَكْرَمُ مَصِيراً، إِنَّكَ تُفِيدُ الْكَرِيمَةَ، وَ تُعْطِي الْجَسِيمَةَ، وَ تَفْعَلُ مَا تُرِيدُ، وَ أَنْتَ عَلَى كُلِّ شَيْ‏ءٍ قَدِير.";
			else
				arabic += "اللَّهُمَّ إِنِّي أَسْتَخِيرُكَ بِعِلْمِكَ وَأَسْتَقْدِرُكَ بِقُدْرَتِكَ وَأَسْأَلُكَ مِنْ فَضْلِكَ الْعَظِيمِ فَإِنَّكَ تَقْدِرُ وَلَا أَقْدِرُ وَتَعْلَمُ وَلَا أَعْلَمُ وَأَنْتَ عَلَّامُ الْغُيُوبِ اللَّهُمَّ إِنْ كُنْتَ تَعْلَمُ أَنَّ هَذَا الْأَمْرَ خَيْرٌ لِي فِي دِينِي وَمَعَاشِي وَعَاقِبَةِ أَمْرِي (عَاجِلِ أَمْرِي وَآجِلِهِ) فَاقْدُرْهُ لِي وَيَسِّرْهُ لِي ثُمَّ بَارِكْ لِي فِيهِ وَإِنْ كُنْتَ تَعْلَمُ أَنَّ هَذَا الْأَمْرَ شَرٌّ لِي فِي دِينِي وَمَعَاشِي وَعَاقِبَةِ أَمْرِي (عَاجِلِ أَمْرِي وَآجِلِهِ) فَاصْرِفْهُ عَنِّي وَاصْرِفْنِي عَنْهُ وَاقْدُرْ لِيَ الْخَيْرَ حَيْثُ كَانَ ثُمَّ أَرْضِنِي";

			hint = new RTLLabel(arabic, BaseMaterialTheme.PRIMARY_TEXT_COLOR, "justify", "rtl", true, "center", 0, "mequran");
			hint.layoutData = new AnchorLayoutData(0,0,NaN,0);
			scroller.addChild(hint);
			
			button = new SimpleLayoutButton();
			button.backgroundSkin = new Quad(1,1,BaseMaterialTheme.PRIMARY_BACKGROUND_COLOR);
			button.layout = new AnchorLayout();
			button.alpha = 0;
			button.addEventListener(Event.TRIGGERED, button_triggredHandler);
			button.layoutData = new AnchorLayoutData(0,0,0,0);
			addChild(button)
			
			waitingIcon = new ImageLoader();
			waitingIcon.source = "app:/com/gerantech/islamic/assets/images/icon/icon-192.png";
			waitingIcon.width = waitingIcon.height = Math.min(appModel.width, appModel.height)/3;
			waitingIcon.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);
			button.addChild(waitingIcon);
		}
		
		private function button_triggredHandler():void
		{
			TweenLite.to(button, 0.5, {alpha:1});
			TweenLite.to(waitingIcon, 0.8, {alpha:0, delay:0.5});
			setTimeout(startOmen, 1200);
		}		
		
		private function startOmen():void
		{
			var item:Item = getRandom();
			userModel.setLastItem(item.sura, item.aya);
			appModel.navigator.popScreen(); 
		}
		
		private function getRandom():Item
		{
			var item:Item = Item.getRandom();
			if(item.sura>90)
				item = getRandom();
			return item;
		}
		
	}
}