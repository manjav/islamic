package gt.utils
{ 

	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class GTStringUtils
	{
		//  CREATE TEXT   _________________________________________________________________________
		private static var textformat:TextFormat = new TextFormat('tahoma',14,0,true);
		public static function getTextField(_str:String='', _txtFrm:TextFormat=null, _x:Number = 0, _y:Number = 0, _autoSize:String = 'left', _fontEmbed:Boolean = false, _enebled:Boolean = false, _border:Boolean = false, _html:Boolean=false, _filter:Array=null):TextField
		{
			if (_txtFrm == null)
			{
				_txtFrm = textformat;
			}
			var myTextField:TextField = new TextField();
			myTextField.border = _border;
			myTextField.mouseEnabled = _enebled;
			myTextField.embedFonts = _fontEmbed;
			myTextField.antiAliasType = AntiAliasType.ADVANCED
			myTextField.autoSize = _autoSize;
			myTextField.defaultTextFormat = _txtFrm;
			myTextField.x = _x;
			myTextField.y = _y;
			_html ? myTextField.htmlText = _str:myTextField.text = _str;
			if (_filter != null)
			{
				myTextField.filters = _filter;
			}
			return myTextField;
		}

		//  UINT TO TIME _________________________________________________________________________
		public static function uintToTime(_time:uint, _mode:String='Second', separator:String=" : "):String
		{
			var ret:String;
			var mili:uint;
			if (_mode == 'Milisecond')
			{
				mili = _time % 1000;
				_time = Math.floor(_time / 1000);
				//trace(_time);
			}
			
			var sec:uint = _time % 60;
			var min:uint;
			var hrs:uint;
			var secStr:String = sec < 10 ? '0' + sec:'' + sec;
			var minStr:String;
			var hrsStr:String;
			if (_time < 3600)
			{
				min = Math.floor(_time / 60);
				minStr = min < 10 ? '0' + min:'' + min;
				ret = _mode == 'Second' ? minStr + separator + secStr   :   minStr + separator + secStr + separator + mili.toFixed(2);
			}
			else
			{
				min = Math.floor(uint(_time % 3600) / 60);
				hrs = Math.floor(_time / 3600);
				minStr = min < 10 ? '0' + min:'' + min;
				hrsStr = hrs < 10 ? '0' + hrs:'' + hrs;
				ret = _mode == 'Second' ? hrsStr + separator + minStr + separator + secStr:hrsStr + separator + minStr + separator + secStr + separator + mili;
			}
			return ret;
		}
		
		public static function getDateString(_date:Date, isTime:Boolean=false):String
		{
			var ret:String = _date.fullYear+'-'+uint(_date.month+1)+'-'+_date.date ;
			ret = isTime ? ret+'_'+getNumberString(_date.hours, 2)+"'"+getNumberString(_date.minutes, 2)+"'"+getNumberString(_date.seconds, 2) : ret;
			return ret;
		}
		public static function getNumberString(_num:Number, _len:uint):String
		{
			var ret:String;
			var num:String = _num.toString();
			for(var i:int=0; i<_len-num.length; i++)
			{
				num = '0'+num;
			}
			return(num);
		}
		public static function getCharByUint(_num:uint):String
		{
			const charList:Array = new Array('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z');
			return charList[_num].toString();
		}
		public static function getAlphabetByUint(_num:uint):String
		{
			const alphabetList:Array = new Array('I','II','III','IV','V','VI','VII','VIII','IX','X','XI','XII','XIII');
			return alphabetList[_num];
		}
		public static function getColorNumber(_str:String):uint
		{
			return uint('0x'+_str.substr(1));
		}		
		//  SUMMERY TEXT   _________________________________________________________________________
		public static function summaryText(str:String, len:uint):String
		{
			return ( str.length > len ? str.substr(0, len-2) + " ..." : str );
		}

		//   ENCRYPTION   _________________________________________________________________________
		public static function encrypt(str:String, encryptMode:Boolean=true, isEncrypt:Boolean=false):String
		{
			var firstStr:String = str;
			var secondStr:String='';
			if(isEncrypt)
			{
				var codeArray:Array = new Array;
				for (var i:uint =0; i<firstStr.length; i++) {
					var char:String = firstStr.substr(i, 1);
					var charCode:Number = firstStr.charCodeAt(i);
					codeArray.push(charCode);
				}
				for (var j:uint =0; j<codeArray.length; j++) {
					var num:Number = Number(codeArray[j]);
					num = convartString(num, encryptMode);
					secondStr += String.fromCharCode(num);
				}
			} else {
				secondStr = firstStr;
			}
			return secondStr;
		}
		private static function convartString(code:Number, isEncrytp:Boolean):Number
		{
			var newCode:Number=0
			if(isEncrytp)
			{
				newCode = Number(code + 20) * 3;
			} else {
				newCode = Number(code / 3) - 20
			}
			return newCode;
		}
		
		public static function getSplitsWithPatt(instring:String, pattern:String):Array
		{
            var item:String = null;
            var splitList:Array = instring.split(pattern);
			var ret:Array = new Array();
            for each (item in splitList)
            {
                ret.push(item + pattern);
            }
            return ret;
		}
		
		public static function emailChecker(email:String):Boolean
		{
			var mailReg:RegExp = /^[A-Z0-9._%+-]+@(?:[A-Z0-9-]{3,24}+\.)+[A-Z]{2,4}$/i;//[a-zA-Z0-9-]{1,}@([a-zA-Z\.])?[a-zA-Z]{1,}\.[a-zA-Z]{1,4}/gi;
			return email.match(mailReg)!=null;
		}
	}
}