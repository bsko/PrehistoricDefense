package  
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author i am
	 */
	public class RealTowerSkill
	{
		private var _currentLevel:int;
		private var _skill:TowerSkill;
		private var _isAvailable:Boolean = false;
		private var _wheat:int;
		private var _gold:int;
		
		public function RealTowerSkill(currentLevel:int, skill:TowerSkill) 
		{
			_currentLevel = currentLevel;
			_skill = skill;
			wheat = skill.wheatCost;
			gold = skill.goldCost;
		}
		
		public function get skill():TowerSkill { return _skill; }
		
		public function get currentLevel():int { return _currentLevel; }
		
		public function set currentLevel(value:int):void 
		{
			_currentLevel = value;
			if (value > 3)
			{
				_currentLevel = 3;
			}
		}
		
		public function get isAvailable():Boolean { return _isAvailable; }
		
		public function set isAvailable(value:Boolean):void 
		{
			_isAvailable = value;
		}
		
		public function get wheat():int { return _wheat; }
		
		public function set wheat(value:int):void 
		{
			_wheat = value;
		}
		
		public function get gold():int { return _gold; }
		
		public function set gold(value:int):void 
		{
			_gold = value;
		}
	}

}