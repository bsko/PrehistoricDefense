package Events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author i am
	 */
	public class WinOrLooseEvent extends Event 
	{
		
		public static const END_LEVEL:String = "endlevel";
		
		public static const WIN:String = "win";
		public static const LOOSE:String = "loose";
		
		private var _subtype:String;
		private var _enemiesDied:int;
		private var _enemiesTotal:int;
		private var _goldGained:int;
		private var _wheatGained:int;
		private var _wavesKilled:int
		private var _wavesTotal:int;
		private var _experienceEarned:int;
		private var _wasCampInBattle:Boolean;
		
		public function WinOrLooseEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, Subtype:String = "win", diedEnemies:int = 0, totalEnemies:int = 0, gold:int = 0, wheat:int = 0, killedWaves:int = 0, totalWaves:int = 0, experience:int = 0, campInBattle:Boolean = false) 
		{ 
			super(type, bubbles, cancelable);
			_subtype = Subtype;
			_enemiesDied = diedEnemies;
			_enemiesTotal = totalEnemies;
			_goldGained = gold;
			_wheatGained = wheat;
			_wavesKilled = killedWaves;
			_wavesTotal = totalWaves;
			_experienceEarned = experience;
			_wasCampInBattle = campInBattle;
		} 
		
		public override function clone():Event 
		{ 
			return new WinOrLooseEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("WinOrLooseEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get subtype():String { return _subtype; }
		
		public function set subtype(value:String):void 
		{
			_subtype = value;
		}
		
		public function get enemiesDied():int { return _enemiesDied; }
		
		public function set enemiesDied(value:int):void 
		{
			_enemiesDied = value;
		}
		
		public function get enemiesTotal():int { return _enemiesTotal; }
		
		public function set enemiesTotal(value:int):void 
		{
			_enemiesTotal = value;
		}
		
		public function get goldGained():int { return _goldGained; }
		
		public function set goldGained(value:int):void 
		{
			_goldGained = value;
		}
		
		public function get wheatGained():int { return _wheatGained; }
		
		public function set wheatGained(value:int):void 
		{
			_wheatGained = value;
		}
		
		public function get wavesKilled():int { return _wavesKilled; }
		
		public function set wavesKilled(value:int):void 
		{
			_wavesKilled = value;
		}
		
		public function get wavesTotal():int { return _wavesTotal; }
		
		public function set wavesTotal(value:int):void 
		{
			_wavesTotal = value;
		}
		
		public function get experienceEarned():int { return _experienceEarned; }
		
		public function set experienceEarned(value:int):void 
		{
			_experienceEarned = value;
		}
		
		public function get wasCampInBattle():Boolean { return _wasCampInBattle; }
	}
	
}