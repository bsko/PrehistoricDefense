package Events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class RemoveAnimIconListeners extends Event 
	{
		
		public static const REMOVE_LISTENERS:String = "RemoveAnimIconListeners";
		
		public function RemoveAnimIconListeners(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new RemoveAnimIconListeners(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("RemoveAnimIconListeners", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}