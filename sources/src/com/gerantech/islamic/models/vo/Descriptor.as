package com.gerantech.islamic.models.vo
{
	public class Descriptor
	{
		public var id:String;
		public var platform:String;
		public var copyright:String;
		public var description:String;
		public var versionLabel:String;
		public var versionNumber:String;
		public var market:String;
		public var server:String;
		public var analyticskey:String;
		public var analyticssec:String;
		
		public function Descriptor(xml:XML)
		{
			id = getNodesByName(xml, "id");
			copyright = getNodesByName(xml, "copyright");
			description = getNodesByName(xml, "description");
			versionLabel = getNodesByName(xml, "versionLabel");
			versionNumber = getNodesByName(xml, "versionNumber");
			
			var descriptJson:Object = JSON.parse(description);
			for(var n:String in descriptJson)
				this[n] = descriptJson[n];
		}
		
		private function getNodesByName(xml:XML, nodeName:String) : String 
		{
			var list:XMLList = xml.children();
			
			for each(var node:XML in  list)
			{
				
				var name:String = node.localName().toString();
				if (name == nodeName)
					return node.valueOf();
			}
			return null;
		}
	}
}
