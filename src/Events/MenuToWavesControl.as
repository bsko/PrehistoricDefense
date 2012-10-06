package Events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author i am
	 */
	public class MenuToWavesControl extends Event 
	{
		public static const PAUSE:String = "pause";
		public static const RESUME:String = "resume";
		
		
		public function MenuToWavesControl(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new MenuToWavesControl(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("MenuToWavesControl", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}