package com.gerantech.islamic.models.vo
{
	public class Profile
	{
				
		public var gid:String = ""//"114692294856499106270";
		public var name:String = ""//"Mansour Djawadi";
		public var email:String = ""//"mansurjavadi@gmail.com";
		public var gender:String = ""//"0";
		public var photoURL:String = ""//"https://lh6.googleusercontent.com/-hg5BkkuBJD0/AAAAAAAAAAI/AAAAAAAAAhs/dUntvz-6VnM/photo.jpg";
		
		public var birthDate:Date;
		public var numRun:uint;
		public var preventLogin:Boolean;
		
		//public var location:String = '';
		public var lastMonth:uint;
		public var osVersion:String = '';
		public var manufacturer:String = '';
		public var model:String = '';
		
		public  var uid:String = '';
		public var synced:Boolean;
		
		public function Profile()
		{
			birthDate = new Date(1990,1,1);
		}
		
		public function get registered():Boolean
		{
			return email!=null && email.length>7;
		}

		public function setGPlusParams(id:String, name:String, email:String, photoURL:String, gender:String, birthdate:String):void
		{
			this.gid =	id;
			this.name =	name;
			this.email = email;
			this.photoURL = photoURL.split("?")[0];
			this.gender = gender;
			this.birthDateString = birthdate;
		}
		
		
		public function set birthDateString(value:String):void
		{
			if(value==null)
				return;
			
			var ds:Array = value.indexOf(",") ? value.split(", ") : value.split("/");
			birthDate = new Date(uint(ds[2]), uint(ds[0])-1, uint(ds[1]));
		}
		public function get birthDateString():String
		{
			return ((birthDate.month+1) + '/' + birthDate.date + '/' + birthDate.fullYear);
		}

		public function clear():void
		{
			setGPlusParams("", "", "", "", "", "");
		}
	}
}