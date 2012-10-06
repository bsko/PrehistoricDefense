package Events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author I am
	 */
	public class InterfaceEvent extends Event 
	{
		static public const INTERFACE_EVENT:String = "interfaceevent";
		static public const START_GAME:String = "startgame";
		private var _subtype:String;
		private var _level:int;
		
		public function InterfaceEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, subtype:String = "startgame", level:int = 0 ) 
		{ 
			super(type, bubbles, cancelable);
			_subtype = subtype;
			_level = level;
		} 
		
		public override function clone():Event 
		{ 
			return new InterfaceEvent(type, bubbles, cancelable, _subtype, _level);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("InterfaceEvent", "type", "bubbles", "cancelable", "eventPhase", "_subtype", "_level"); 
		}
		
		public function get subtype():String { return _subtype; }
		
		public function get level():int { return _level; }
		
		public function set level(value:int):void 
		{
			_level = value;
		}
		
	}
	
}