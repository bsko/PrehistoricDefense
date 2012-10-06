package Events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class ShiftTrap extends Event 
	{
		public static var SHIFT_ME:String = "shift_me";
		
		public function ShiftTrap(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new ShiftTrap(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ShiftTrap", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}