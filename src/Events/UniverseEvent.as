package Events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author i am
	 */
	public class UniverseEvent extends Event 
	{
		
		public static const TOWER_MENU:String = "towermenu";
		public static const ADD_KEY:String = "addkey";
		public static const CLOSE_MENU:String = "closemenu";
		
		public static const BUILDING_MENU:String = "buildingmenu";
		
		public var tower:Tower;
		
		public function UniverseEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, _tower:Tower = null) 
		{ 
			super(type, bubbles, cancelable);
			tower = _tower;
		} 
		
		public override function clone():Event 
		{ 
			return new UniverseEvent(type, bubbles, cancelable, tower);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("UniverseEvent", "type", "bubbles", "cancelable", "eventPhase", "tower"); 
		}
	}
	
}