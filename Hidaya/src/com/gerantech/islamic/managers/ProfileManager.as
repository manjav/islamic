package com.gerantech.islamic.managers
{
	import com.gerantech.extensions.NativeAbilities;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	
	import flash.events.IEventDispatcher;
	
	import mx.resources.ResourceManager;

	CONFIG::Android 
	{
		import com.gerantech.extensions.gplus.GPlusExtension;
		import com.gerantech.extensions.gplus.events.GPlusEvent;
		import com.gerantech.extensions.gplus.models.Person;
		import com.gerantech.extensions.gplus.models.Result;
	}
	
	
	public class ProfileManager extends ServiceConnector
	{
		
		CONFIG::Android
		{
			private var gpConnector:GPlusExtension;
		}
		
		
		public function ProfileManager(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function check():void
		{
			profile = UserModel.instance.user.profile;
			if(!profile.registered && !profile.preventLogin)
			{
				CONFIG::Android
				{
					gpConnector = GPlusExtension.instance;
					gpConnector.addEventListener(GPlusEvent.GPLUS_RESULT, gpConnector_eventsHandler);
					gpConnector.login();
				}
			}
		}
		public function logout():void
		{
			profile = UserModel.instance.user.profile;
			CONFIG::Android
			{
				gpConnector = GPlusExtension.instance;
				gpConnector.addEventListener(GPlusEvent.GPLUS_RESULT, gpConnector_eventsHandler);
				gpConnector.revokeAccess();
			}
		}
		
		
		CONFIG::Android 
		{
		protected function gpConnector_eventsHandler(event:GPlusEvent):void
		{
			switch(event.result.response)
			{
				case Result.CONNECTION_FAILED:
				case Result.LOGIN_CANCELED:
				case Result.LOGIN_FAILED:
				case Result.NETWORK_ERROR:
				case Result.REVOKE_ACCESS:
					NativeAbilities.instance.showToast(event.result.message, 2);
					break;
				case Result.PERSON_NULL:
					NativeAbilities.instance.showToast(ResourceManager.getInstance().getString("loc", "person_null"), 1);
					break;
				case Result.PERSON_INFORMATION:
					var p:Person = event.result.person;
					profile.setGPlusParams(p.id, p.name, p.email, p.photoUrl, p.gender, p.birtdate);
					NativeAbilities.instance.showToast(p.name+ p.email, 1);
					insertUser();
					break;
			}
			/*if(event.result.response==Result.REVOKE_ACCESS||event.result.response==Result.PERSON_INFORMATION)
				AppModel.instance.myDrawer.resetContent();*/
		}					
		}

	}
}