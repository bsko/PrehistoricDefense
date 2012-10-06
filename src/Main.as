package 
{
	import Events.InGameEvent;
	import Events.InterfaceEvent;
	import Events.WinOrLooseEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import menus.InGameMenu;
	import menus.MainInterface;
	
	/**
	 * ...
	 * @author author
	 */
	[Frame(factoryClass="Preloader")]
	public class Main extends Sprite 
	{
		public static var interfaceLayer:Sprite = new Sprite();
		//public static var testSprite:Sprite = new Sprite();
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			App.InitSkills();
			App.initPools();
			App.InitPlayerArray();
			App.InitDescriptions();
			App.rootMC = this;
			App.sndManager.initSounds();
			App.soundControl.Init();
			
			App.stage = stage;
			App.universe = new Universe();
			App.mainInterface = new MainInterface();
			App.ingameInterface = new InGameMenu();
			App.cursorControl = new CursorControl();
			App.cursorControl.Init();
			
			addChild(App.mainInterface);
			addChild(App.cursorControl);
			addChild(App.appearingWindow);
			App.sndManager.setMusic("MenuTheme");
			App.mainInterface.addEventListener(InterfaceEvent.INTERFACE_EVENT, onInterfaceHandler, false, 0, true);
		}
		
		private function onInterfaceHandler(e:InterfaceEvent):void 
		{
			if (e.subtype == InterfaceEvent.START_GAME)
			{
				startGame(e.level);
			}
		}
		
		private function onQuitEvent(e:InGameEvent):void 
		{
			if (e.subtype == InGameEvent.QUIT)
			{
				App.sndManager.setMusic("MenuTheme");
				removeChild(App.ingameInterface);
				removeChild(App.universe);
				addChild(App.mainInterface);
				addChild(App.cursorControl);
				addChild(App.appearingWindow);
				App.ingameInterface.removeEventListener(InGameEvent.INGAME_EVENT, onQuitEvent, false);
				App.universe.removeEventListener(WinOrLooseEvent.END_LEVEL, onCompleteLevel , false);
				App.mainInterface.QuitFromGame();
			}
			else if (e.subtype == InGameEvent.RESTART)
			{
				removeChild(App.ingameInterface);
				removeChild(App.universe);
				addChild(App.mainInterface);
				addChild(App.cursorControl);
				startGame(App.currentLevel, true);
			}
		}
		
		private function startGame(level:int, isRestart:Boolean = false):void 
		{
			App.soundControl.playSound("level_begin");
			if (!isRestart)
			{
				App.sndManager.setMusic("GameTheme");
			}
			removeChild(App.mainInterface);
			App.universe.init(App.lvlSignatures[level]);
			addChild(App.universe);
			App.ingameInterface.Init(level);
			addChild(App.ingameInterface);
			addChild(App.cursorControl);
			addChild(App.appearingWindow);
			App.ingameInterface.addEventListener(InGameEvent.INGAME_EVENT, onQuitEvent, false, 0, true);
			App.universe.addEventListener(WinOrLooseEvent.END_LEVEL, onCompleteLevel , false, 0, true);
		}
		
		private function onCompleteLevel(e:WinOrLooseEvent):void 
		{
			App.sndManager.setMusic("MenuTheme");
			removeChild(App.ingameInterface);
			removeChild(App.universe);
			addChild(App.mainInterface);
			addChild(App.cursorControl);
			addChild(App.appearingWindow);
			App.ingameInterface.removeEventListener(InGameEvent.INGAME_EVENT, onQuitEvent, false);
			App.universe.removeEventListener(WinOrLooseEvent.END_LEVEL, onCompleteLevel , false);
			switch(e.subtype)
			{
				case WinOrLooseEvent.WIN:
				App.mainInterface.WonMenuPage(e.enemiesDied, e.enemiesTotal, e.wavesKilled, e.wavesTotal, e.goldGained, e.wheatGained, e.experienceEarned, e.wasCampInBattle);
				break;
				case WinOrLooseEvent.LOOSE:
				App.mainInterface.LooseMenuPage(e.enemiesDied, e.enemiesTotal, e.wavesKilled, e.wavesTotal, e.goldGained, e.wheatGained, e.experienceEarned);
				break;
			}
		}
	}
	
}