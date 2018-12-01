package com.gerantech.islamic.managers
{
	import com.gerantech.islamic.models.vo.Tutorial;

	public class TutorialManager
	{
		private static var _instance:TutorialManager;
		
		public static function get instance():TutorialManager
		{
			if(_instance==null)
				_instance = new TutorialManager();
			return _instance;
		}
		
		public var quranTutorial:Tutorial;
		public var moreTutorial:Tutorial;
		public var recitationTutorial:Tutorial;
		public var translationTutorial:Tutorial;

		public function TutorialManager()
		{
			quranTutorial = new Tutorial();
			moreTutorial = new Tutorial();
			recitationTutorial = new Tutorial();
			translationTutorial = new Tutorial();
		}
		
		
		
		
		
		
		
	}
}