package Events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author i am
	 */
	public class InGameEvent extends Event 
	{
		static public const INGAME_EVENT:String = "IngameEvent";
		static public const MENU_TO_UNIVERSE:String = "UniverseEvent";
		static public const SPELL_USING:String = "SpellUsing";
		
		//static public const BUILD_TWR:String = "";
		static public const QUIT:String = "quit";
		static public const RESTART:String = "restart";
		static public const WIN:String = "win";
		static public const LOOSE:String = "loose";
		
		private var _subtype:String;
		private var _spell:Spell;
		
		public function InGameEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, subtype:String = "", spell:Spell = null) 
		{ 
			super(type, bubbles, cancelable);
			_subtype = subtype;
			_spell = spell;
		} 
		
		public override function clone():Event 
		{ 
			return new InGameEvent(type, bubbles, cancelable, subtype);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("InGameEvent", "type", "bubbles", "cancelable", "eventPhase", "_subtype"); 
		}
		
		public function get subtype():String { return _subtype; }
		
		public function set subtype(value:String):void 
		{
			_subtype = value;
		}
		
		public function get spell():Spell { return _spell; }
		
		public function set spell(value:Spell):void 
		{
			_spell = value;
		}
		
	}
	
}