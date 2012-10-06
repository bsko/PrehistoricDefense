package Events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author i am
	 */
	public class ChangeCursor extends Event 
	{
		
		public static const CHANGE_CURSOR:String = "changecursor";
		
		public static const CURSOR_MAGIC:String = "magic";
		public static const CURSOR_DEFAULT:String = "default";
		
		private var _subtype:String;
		private var _cursorType:String;
		
		public function ChangeCursor(type:String, subType:String, bubbles:Boolean=false, cancelable:Boolean=false, CursorType:String = "") 
		{ 
			super(type, bubbles, cancelable);
			_subtype = subType;
			_cursorType = CursorType;
		} 
		
		public override function clone():Event 
		{ 
			return new ChangeCursor(type, _subtype, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ChangeCursor", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get subtype():String { return _subtype; }
		
		public function set subtype(value:String):void 
		{
			_subtype = value;
		}
		
		public function get cursorType():String { return _cursorType; }
		
	}
	
}