package com.gerantech.islamic.views.controls
{
	import com.gerantech.islamic.managers.AppController;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.Assets;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Person;
	import com.gerantech.islamic.models.vo.Profile;
	import com.gerantech.islamic.utils.LoadAndSaver;
	import com.gerantech.islamic.views.buttons.FlatButton;
	
	import flash.display.Bitmap;
	import flash.filesystem.File;
	import flash.utils.setTimeout;
	
	import mx.resources.ResourceManager;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;
	
	import starling.display.Quad;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class ProfileView extends LayoutGroup
	{

		private var imageViewer:LayoutGroup;
		private var profileData:Profile;
		private var image:ImageLoader;
		private var vGroup:LayoutGroup;
		private var padding:uint;
		private var imageMask:ImageLoader;
		private var signButton:FlatButton;

		private var imageLoadder:LoadAndSaver;
		
		override protected function initialize():void
		{
			super.initialize();
			backgroundSkin = new Quad(1, 1, 0x304040);
			layout = new AnchorLayout();
			height = AppModel.instance.sizes.listItem*2;
			padding = AppModel.instance.sizes.DP16;
						
			reload();
		}
		
		public function reload():void
		{
			removeChildren();
			
			var vlayout:VerticalLayout = new VerticalLayout();
			vlayout.horizontalAlign = AppModel.instance.align;
			vGroup = new LayoutGroup();
			vGroup.layout = vlayout;
			vGroup.layoutData = new AnchorLayoutData(padding,padding,padding/4,padding);
			addChild(vGroup);
			
			profileData = UserModel.instance.user.profile;
						
			imageViewer = new LayoutGroup();
			imageViewer.height = AppModel.instance.sizes.DP72;
			//imageViewer.layoutData = new VerticalLayoutData(NaN, 100);
			imageViewer.layout = new AnchorLayout();
			vGroup.addChild(imageViewer);
			
			vGroup.addChild(new Spacer());
			
			var nameLabel:RTLLabel = new RTLLabel(profileData.registered?profileData.name:ResourceManager.getInstance().getString("loc", "profile_label"), 0xFFFFFF);
			nameLabel.truncateToFit = true;
			nameLabel.layoutData = new VerticalLayoutData(100);
			vGroup.addChild(nameLabel);
			
			var emailLabal:RTLLabel = new RTLLabel(profileData.registered?profileData.email:ResourceManager.getInstance().getString("loc", "profile_message"), 0xAAAAAA, null, null, false, null, UserModel.instance.fontSize*0.8);
			emailLabal.truncateToFit = true;
			emailLabal.layoutData = new VerticalLayoutData(100);
			vGroup.addChild(emailLabal);
			
			image = new ImageLoader();
			image.delayTextureCreation = true;
			image.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, NaN, 0);
			
			var imageSize:uint = AppModel.instance.sizes.DP72;
			if(profileData.registered)
			{
				imageLoadder = new LoadAndSaver(File.applicationStorageDirectory.resolvePath(profileData.gid+".jpg").nativePath, (profileData.photoURL + "?sz=" + imageSize), null, true);
				imageLoadder.addEventListener("complete", imageLoader_completeHandler);
			}
			else
			{
				setTimeout(addImage, 300, Person.getDefaultImage());
			}
			imageMask = new ImageLoader();
			imageMask.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, NaN, 0);
			imageMask.source = Assets.getTexture("circle_mask");
			
			if(!profileData.registered)
			{
				var ovrerlayButton:FlatButton = new FlatButton(null, null, true);
				ovrerlayButton.layoutData = new AnchorLayoutData(0,0,0,0);
				ovrerlayButton.addEventListener(Event.TRIGGERED, overlay_triggeredHandler);
				addChild(ovrerlayButton)
			}

			signButton = new FlatButton(profileData.registered?"logout":"info", null, true);
			signButton.width = signButton.height = AppModel.instance.sizes.toolbar;
			signButton.iconScale = 0.4;
			//signButton.icon.scaleX  = AppModel.instance.ltr ? 1 : -1
			signButton.layoutData = new AnchorLayoutData(NaN, !AppModel.instance.ltr?NaN:0, 0, AppModel.instance.ltr?NaN:0);
			signButton.addEventListener(Event.TRIGGERED, signButton_triggeredHandler);
			addChild(signButton);
		}		
		
		protected function imageLoader_completeHandler(event:Object):void
		{
			addImage(Texture.fromBitmap(imageLoadder.fileLoader.content as Bitmap));
		}
		
		private function addImage(texture:Texture):void
		{
			var _h:Number = imageViewer.height;
			imageMask.width = imageMask.height = image.width = image.height = imageViewer.width = _h;
			
			image.source = texture;
			
			imageViewer.addChild(image);
			imageViewer.addChild(imageMask);			
		}
		
		private function overlay_triggeredHandler():void
		{
			UserModel.instance.profileManager.check();
		}
		
		private function signButton_triggeredHandler():void
		{
			if(profileData.registered)
			{
				profileData.clear();
				UserModel.instance.profileManager.logout();
			}
			else
			{
				AppController.instance.alert("attention_title", "profile_info_message");
			}
		}
	}
}