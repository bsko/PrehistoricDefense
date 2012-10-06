package Events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author i am
	 */
	public class UniverseDestroying extends Event 
	{
		
		public static const DESTROYING:String = "destroying";
		
		public function UniverseDestroying(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new UniverseDestroying(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("UniverseDestroying", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}