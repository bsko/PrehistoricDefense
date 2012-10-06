package  
{
	/**
	 * ...
	 * @author i am
	 */
	public class TowerSkill 
	{
		private var _skills:Object = new Object();
		private var _name:String;
		private var _description:String;
		private var _iconType:String;
		private var _goldCost:int;
		private var _wheatCost:int;
		private var _ptsCost:int;
		
		
		public function TowerSkill(name:String, description:String, iconType:String, skills:Object, goldCost:int = 10, wheatCost:int = 40)
		{
			_name = name;
			_description = description;
			_iconType = iconType;
			_skills = skills;
			_wheatCost = wheatCost;
			_goldCost = goldCost;
		}
		
		public function get skills():Object { return _skills; }
		
		public function get name():String { return _name; }
		
		public function get description():String { return _description; }
		
		public function get iconType():String { return _iconType; }
		
		public function get wheatCost():int { return _wheatCost; }
		
		public function set wheatCost(value:int):void 
		{
			_wheatCost = value;
		}
		
		public function get goldCost():int { return _goldCost; }
		
		public function set goldCost(value:int):void 
		{
			_goldCost = value;
		}
		
	}

}