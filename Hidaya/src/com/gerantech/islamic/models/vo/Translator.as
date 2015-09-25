package com.gerantech.islamic.models.vo
{
	import com.gerantech.islamic.managers.NotificationManager;
	import com.gerantech.islamic.models.AppModel;
	import com.gerantech.islamic.models.ConfigModel;
	import com.gerantech.islamic.models.ResourceModel;
	import com.gerantech.islamic.models.UserModel;
	import com.gerantech.islamic.utils.LoadAndSaver;
	import com.gerantech.islamic.utils.StrTools;
	
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLStatement;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.utils.setTimeout;

	public class Translator extends Person
	{
		private var dbFile:File;
		private var dbLoadSaver:LoadAndSaver;
		private var sqlConnection:SQLConnection;
		private var randomItem:Item;
		
		public var loadingState:int = -1;
		
		public static const L_NOT_LOADED:int = -1;
		public static const L_LOADING:int = 0;
		public static const L_LOADED:int = 1;
		public static const L_LOAD_ERROR:int = 2;
		
		public function Translator(person:Object=null, type:String="translator", flag:Local=null)
		{
			super(person, type, flag);
		}
		
		
		public function loadTransltaion():void
		{
			trace("loadTransltaion", loadingState)
			if(loadingState>-1)
				return;
			
			loadingState = L_LOADING;
			dbFile = new File(localPath);
			if(dbFile.exists)
			{
				loadDB();
				return
			}
			
			dbLoadSaver = new LoadAndSaver(localPath, url, null, false, size);
			dbLoadSaver.addEventListener("complete", dbLoadSaver_CompleteHandler);
			dbLoadSaver.addEventListener(IOErrorEvent.IO_ERROR, dbLoadSaver_ioErrorHandler);
			dbLoadSaver.addEventListener(ProgressEvent.PROGRESS, dbLoadSaver_progressHandler);
			state = PREPARING;
		}
		
		private function dbLoadSaver_progressHandler(event:ProgressEvent):void
		{
			state = LOADING;
			percent = event.bytesLoaded/size;//trace(event.bytesLoaded, size)
			dispatchEventWith(TRANSLATION_PROGRESS_CHANGED);
			//trace(percent, event.bytesLoaded/1200000);
		}
		
		private function dbLoadSaver_CompleteHandler(event:*):void
		{//trace(event)
			dbLoadSaver.removeEventListener("complete", dbLoadSaver_CompleteHandler);
			dbLoadSaver.removeEventListener(IOErrorEvent.IO_ERROR, dbLoadSaver_ioErrorHandler);
			dbLoadSaver.removeEventListener(ProgressEvent.PROGRESS, dbLoadSaver_progressHandler);
			
			loadDB();
		}		
		
		private function loadDB():void
		{//trace(dbFile.nativePath);
			sqlConnection = new SQLConnection();
			sqlConnection.addEventListener(SQLEvent.OPEN, sqlConnection_openHandler); 
			sqlConnection.addEventListener(SQLErrorEvent.ERROR, sqlConnection_errorHandler); 
			sqlConnection.openAsync(dbFile, SQLMode.READ, null, false, 1024, AppModel.instance.byteArraySec); 
		}
		
		protected function sqlConnection_errorHandler(event:SQLErrorEvent):void
		{trace(event)
			loadingState = L_LOAD_ERROR;
			state = NO_FILE;
			dispatchEventWith(TRANSLATION_ERROR);
		}
		
		protected function sqlConnection_openHandler(event:SQLEvent):void
		{//trace(event)
			loadingState = L_LOADED;
			state = SELECTED ;
			dispatchEventWith(TRANSLATION_LOADED);
			if(ConfigModel.instance.selectedTranslators[0]==this)
				remindeFirstTranslate();
		}
		
		
		
		private function dbLoadSaver_ioErrorHandler(event:IOErrorEvent):void
		{trace(event.text)
			state = NO_FILE;
			stopDownload();
			dispatchEventWith(TRANSLATION_ERROR);
		}
		
		public function stopDownload():void
		{
			//isTranslateDownloading = false;
			percent = 0;
			state = NO_FILE;                                                                                                                    
			dbLoadSaver.closeLoader();
			dbLoadSaver.removeEventListener("complete", dbLoadSaver_CompleteHandler);
			dbLoadSaver.removeEventListener(IOErrorEvent.IO_ERROR, dbLoadSaver_ioErrorHandler);
			dbLoadSaver.removeEventListener(ProgressEvent.PROGRESS, dbLoadSaver_progressHandler);
			//testFile(itemRenderer);//loadingState = "noFile";
		}
		
		
		public function getAyaText(aya:*, response:Function):void
		{
			var createStmt:SQLStatement = new SQLStatement(); 
			createStmt.sqlConnection = sqlConnection; 
			createStmt.text = "SELECT text FROM quran WHERE sura="+(aya.sura-1)+" AND aya="+(aya.aya-1);
			createStmt.addEventListener(SQLEvent.RESULT, createResult); 
			createStmt.addEventListener(SQLErrorEvent.ERROR, createError); 
			if(sqlConnection.connected)
				createStmt.execute(); 
			else
			{
				setTimeout(getAyaText, 100, aya, response);
				return;
			}
			
			var ret:String = "";
			function createError(event:SQLErrorEvent):void
			{
				response();
			}
			
			function createResult(event:SQLEvent):void
			{
				response(createStmt.getResult().data[0].text);
			}
		}
		
		public function getAyas(ayas:Array, response:Function):void
		{
			var query:String = "SELECT text FROM quran WHERE sura="+(ayas[0].sura-1)+" AND aya="+(ayas[0].aya-1);
			for (var i:uint=1; i<ayas.length; i++)
				query += " UNION SELECT text FROM quran WHERE sura="+(ayas[i].sura-1)+" AND aya="+(ayas[i].aya-1);
			//trace(query)
			var createStmt:SQLStatement = new SQLStatement(); 
			createStmt.sqlConnection = sqlConnection; 
			createStmt.text = query;
			createStmt.addEventListener(SQLEvent.RESULT, createResult); 
			createStmt.addEventListener(SQLErrorEvent.ERROR, createError); 
			createStmt.execute(); 
			
			var ret:String = "";
			function createError(event:SQLErrorEvent):void
			{
				response();
			}
			
			function createResult(event:SQLEvent):void
			{
				var ayas:Array = createStmt.getResult().data;
				var ret:Array = new Array();
				for each(var d:Object in ayas)
				ret.push(d.text);
				response(ret);
			}
		}
		
		/**
		 * Get Random Aya
		 */
		
		public function remindeFirstTranslate():void
		{
			if(UserModel.instance.remniderTime.value=="reminder_never")
				return;
			
			randomItem = getRandomTranslate();
			getAyaText(randomItem, randomTextReciever);
			//text = xml.sura[item.sura-1].aya[item.aya-1].@text;//\"alertAction\":\"Collect!\", \"soundName\":\"sound.caf\", \"badge\": 5, \"android_header\":\"header\", 
		}
		
		private function randomTextReciever(text:String):void
		{
			if(text.length>200)
				text = text.substr(0, 200) + " ...";
			text +="  " + loc("sura_l") + " "+ (flag.dir=="ltr"?randomItem.sura:StrTools.getArabicNumber(randomItem.sura.toString())) + "  " + loc("verse_l") + " "+ (flag.dir=="ltr"?randomItem.aya:StrTools.getArabicNumber(randomItem.aya.toString()));
			
			var time:uint = uint(UserModel.instance.remniderTime.value.substr(9))*24*3600;
			time = time;//24/60;trace(time)
			
			var msg:String = "{\"alertBody\": \""+text+"\" , \"custom\": {\"type\":\"goto\", \"sura\":\""+randomItem.sura+"\", \"aya\":\""+randomItem.aya+"\"}}"
			NotificationManager.instance.scheduleLocalNotification(time, msg, true);//'{"alertBody": "'+text+'", "custom": {"type":"goto"}"}', true);
		}
		
		private function getRandomTranslate():Item
		{
			var item:Item = Item.getRandom();
			var txt:String = ResourceModel.instance.quranXML.sura[item.sura-1].aya[item.aya-1].@text;
			if(txt.length<40)
				return getRandomTranslate();
			else
				return item;
		}
	}
}