package Events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author i am
	 */
	public class AddNewWave extends Event 
	{
		
		public static const ADD_NEW_WAVE:String = "newwave";
		public static const READY_FOR_NEXT_WAVE:String = "readyfornextwave";
		public static const NOT_READY:String = "notready";
		
		public function AddNewWave(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new AddNewWave(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("AddNewWave", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}