package Events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class SpellCastingEvent extends Event 
	{
		public static const NEW_COOLDOWN:String = "newcooldown";
		
		private var _spell_type:Spell;
		
		public function SpellCastingEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, spell:Spell = null) 
		{ 
			super(type, bubbles, cancelable);
			_spell_type = spell;
		} 
		
		public override function clone():Event 
		{ 
			return new SpellCastingEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SpellCastingEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get spell_type():Spell { return _spell_type; }
		
		public function set spell_type(value:Spell):void 
		{
			_spell_type = value;
		}
		
	}
	
}