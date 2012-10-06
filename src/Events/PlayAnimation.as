package Events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author i am
	 */
	public class PlayAnimation extends Event 
	{
		
		public static const PLAY_ANIMATION:String = "playanimation";
		private var _isWin:Boolean = false;
		
		public function PlayAnimation(type:String, bubbles:Boolean=false, cancelable:Boolean=false, win:Boolean = false) 
		{ 
			super(type, bubbles, cancelable);
			_isWin = win;
		} 
		
		public override function clone():Event 
		{ 
			return new PlayAnimation(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PlayAnimation", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get isWin():Boolean { return _isWin; }
		
		public function set isWin(value:Boolean):void 
		{
			_isWin = value;
		}
		
	}
	
}