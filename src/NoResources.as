package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author 
	 */
	public class NoResources extends Sprite
	{
		private var _movie:MovieClip = new NotEnoughResources();
		public static const START_VISIBLING:int = 20;
		public static const ANIMATION_LENGTH:int = 30;
		private var _counter:int = 0;
		private var _isOnScreen:Boolean = false;
		
		public function NoResources() 
		{
			addChild(_movie);
			_movie.mouseEnabled = false;
			mouseEnabled = false;
		}
		
		public function ShowMessaage(xx:int, yy:int):void
		{
			if (_isOnScreen) {
				_counter = 0;
				alpha = 1;
				removeEventListener(Event.ENTER_FRAME, onUpdateAlpha, false);
			}
			
			_isOnScreen = true;
			x = xx;
			y = yy;
			visible = true;
			addEventListener(Event.ENTER_FRAME, onUpdateAlpha, false, 0, true);
		}
		
		private function onUpdateAlpha(e:Event):void 
		{
			_counter++;
			if (_counter > START_VISIBLING)	{
				alpha -= 1 / (ANIMATION_LENGTH - START_VISIBLING);
			}
			if (_counter >= ANIMATION_LENGTH) {
				HideMessage();
			}
		}
		
		public function HideMessage():void
		{
			x = -200;
			y = -200;
			alpha = 1;
			visible = false;
			_counter = 0;
			_isOnScreen = false;
			removeEventListener(Event.ENTER_FRAME, onUpdateAlpha, false);
		}
	}

}