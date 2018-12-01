package com.gerantech.islamic.managers
{
	import com.gerantech.extensions.NativeAbilities;
	import com.gerantech.islamic.events.UserEvent;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.Message;
	import com.pushwoosh.nativeExtensions.PushNotification;
	import com.pushwoosh.nativeExtensions.PushNotificationEvent;
		
	public class NotificationManager
	{
		private var pushwoosh:PushNotification;
		
		private static var _instance:NotificationManager;
		private var lastMessage:Message;
		public static function get instance():NotificationManager
		{
			if(_instance == null)
				_instance = new NotificationManager();
			return (_instance);
		}

		public function NotificationManager()
		{
			pushwoosh = PushNotification.getInstance();
			pushwoosh.addEventListener(PushNotificationEvent.PERMISSION_GIVEN_WITH_TOKEN_EVENT, pushwoosh_givenTokenHandler);
			pushwoosh.addEventListener(PushNotificationEvent.PERMISSION_REFUSED_EVENT, pushwoosh_ErrorHandler);
			pushwoosh.addEventListener(PushNotificationEvent.PUSH_NOTIFICATION_RECEIVED_EVENT, pushwoosh_pushRecievedHandler);
			pushwoosh.onDeviceReady();
			
			//register for push
			pushwoosh.registerForPushNotification();
			var pushToken:String = pushwoosh.getPushToken();
		/*	if(pushToken == null)
				AndroidExtension.instance.showToast("Push TOKEN: not registered", 1);
			else
				AndroidExtension.instance.showToast("Registered for pushes: " + pushwoosh.getPushToken(), 1);*/
			
			//tt.text += "\n Pushwoosh HWID: " + pushwoosh.getPushwooshHWID() + " ";
			
			//pushwoosh.scheduleLocalNotification(12, "{\"alertBody\": \""++"\", \"alertAction\":\"Collect!\", \"soundName\":\"sound.caf\", \"badge\": 5, \"custom\": {\"a\":\"json\"}}");
		}
		
		public function scheduleLocalNotification(seconds:uint, message:String, clearPreviouses:Boolean=true, repeatCount:uint=1):void
		{
			if(!AppModel.instance.isAndroid)
				return;
		
			if(clearPreviouses)
				pushwoosh.clearLocalNotifications();
			
			for (var n:uint=1; n<=repeatCount; n++)
				pushwoosh.scheduleLocalNotification(n*seconds, message);
		}		
		
		private function pushwoosh_givenTokenHandler(e:PushNotificationEvent):void
		{
			//AndroidExtension.instance.showToast("onToken "+e.token, 1);
		}
		
		private function pushwoosh_ErrorHandler(e:PushNotificationEvent):void
		{
			NativeAbilities.instance.showToast("onError "+e.errorMessage, 1);
		}
		
		private function pushwoosh_pushRecievedHandler(e:PushNotificationEvent):void
		{
			//NativeAbilities.instance.showToast(JSON.stringify(e.parameters), 1);
			var user:UserModel = UserModel.instance;
			var data:Object = e.parameters.userdata;
			var pushed:Boolean;
			
			switch(data.type.toString())
			{//{"type":"goto", "sura":"100", "aya":"5"}
				case "goto":
					if(user.loaded)
						gotoReminderAya();
					else
						user.addEventListener(UserEvent.LOAD_DATA_COMPLETE, gotoReminderAya);
					pushed = true;
					break;
				case "update":
					break;
				default:
					//setTimeout(AppController.instance.alert, 8000, e.parameters.header, e.parameters.title);
					break;
			}
			
			function gotoReminderAya():void
			{
				//NativeAbilities.instance.showToast(data.type+data.sura+data.aya, 1);
				UserModel.instance.removeEventListener(UserEvent.LOAD_DATA_COMPLETE, gotoReminderAya);
				UserModel.instance.setLastItem(data.sura, data.aya);
				UserModel.instance.dispatchEventWith(UserEvent.SET_ITEM);
			}
			
			if(pushed)
				return;
			
			if(user.loaded)
			{
				lastMessage = new Message(e.parameters.header, e.parameters.title)
				AppController.instance.alert(lastMessage.title, lastMessage.message);
			}
			else
				user.addEventListener(UserEvent.LOAD_DATA_COMPLETE, showNotify);

		}
		
		private function showNotify():void
		{
			//NativeAbilities.instance.showToast(JSON.stringify(lastMessage), 1);
			UserModel.instance.removeEventListener(UserEvent.LOAD_DATA_COMPLETE, showNotify);
			UserModel.instance.inbox.push(lastMessage);
			AppController.instance.alert(lastMessage.title, lastMessage.message);
		}
			
	}
}