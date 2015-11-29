package com.gerantech.islamic.managers
{
	import com.gerantech.extensions.AndroidExtension;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.models.vo.User;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	
	import mx.resources.ResourceManager;
	
	import gt.php.MySQL;
	import gt.php.PHPInterface;

	public class UserDataUpdater
	{
		private var db_host :String = 'localhost';//"manjav"
		private var db_name:String = 'gerantec_islamic';//"ddbb"
		private var db_user:String = 'gerantec_padmin';//"root"
		private var db_pass:String = 'P@1nt@dm1n';//""
		private var db_path:String = 'gerantech.com/islamic/php/users.php';//""
		private var sqlConnector:MySQL;

		public function UserDataUpdater()
		{
		}
		
		// Backup user data ----------------------------------
		public function backup(user:User):void
		{
			if(!user.profile.synced)
			{
				trace("user not synced for backup user data to server")
				return;
			}
			
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(user);
			bytes.position = 0;
			bytes.compress();

			var php:PHPInterface = new PHPInterface("gerantech.com/islamic/php/dataUpdater.php", "file", {name:user.profile.gid, file:bytes});
			php.addEventListener(Event.COMPLETE, php_completeHandler);
			php.addEventListener(IOErrorEvent.IO_ERROR, php_ioErrorHandler);
			php.load();
		}
		
		protected function php_ioErrorHandler(event:IOErrorEvent):void
		{
			trace(event.text);
		}
		
		protected function php_completeHandler(event:Event):void
		{
			trace(UserModel.instance.user.profile.gid+loc("user_backup_complete"))
			AndroidExtension.instance.showToast(loc("user_backup_complete"), 1);
		}		
		
		// Restore user data ----------------------------------
		public function restore(user:User):void
		{
			if(!user.profile.synced)
			{
				trace("user not synced for load data from server")
				return;
			}
			var urlSteram:URLStream = new URLStream();
			urlSteram.addEventListener(Event.COMPLETE, urlSteram_completeHandler);
			urlSteram.addEventListener(IOErrorEvent.IO_ERROR, php_ioErrorHandler);
			urlSteram.load(new URLRequest("http://gerantech.com/islamic/user_data/"+user.profile.gid));
		}
		
		protected function urlSteram_completeHandler(event:Event):void
		{
			var bytes:ByteArray = new ByteArray();
			URLStream(event.currentTarget).readBytes(bytes);
			bytes.uncompress();
			var u:Object = bytes.readObject()// as User;
			if(u.profile.numRun>UserModel.instance.user.profile.numRun)
			{
				UserModel.instance.loadByObject(u);
				trace(UserModel.instance.user.profile.gid+loc("user_restored"));
				AndroidExtension.instance.showToast(loc("user_restored"), 1);
			}
			else
			{
				trace(UserModel.instance.user.profile.gid+loc("user_restore_out_date"))
			}
		}		
		
		private function loc(key:String):String
		{
			return ResourceManager.getInstance().getString("loc", key);
		}
		
	}
}