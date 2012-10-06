package Events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author i am
	 */
	public class EndLevelEvent extends Event 
	{
		
		public static const END_LEVEL:String = "EndLevel";
		
		public static const WIN:String = "Win";
		public static const LOOSE:String = "Loose";
		
		private var _winFlag:Boolean;
		
		public function EndLevelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, isWin:Boolean = false) 
		{ 
			super(type, bubbles, cancelable);
			_winFlag = isWin;
		} 
		
		public override function clone():Event 
		{ 
			return new EndLevelEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("EndLevelEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get winFlag():Boolean { return _winFlag; }
		
		public function set winFlag(value:Boolean):void 
		{
			_winFlag = value;
		}
		
	}
	
}