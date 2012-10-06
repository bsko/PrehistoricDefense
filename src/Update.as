package  
{
	/**
	 * ...
	 * @author ...
	 */
	public class Update
	{
		public static var tmpMoney:int;
		private var _available:Boolean = false;
		private var _nextUpsArray:Array;
		private var _roadToAvailable:int;
		private var _firstUpFlag:Boolean;
		private var _currentLevel:int;
		private var _isUpdated:Boolean;
		private var _description:String;
		
		private var _currUpdCost:int = 100;
		private var _roadCost:int = 70;
		private var _lvlUpCost:int = 75;
		
		private var _towerCostGold:int;
		private var _towerCostWheal:int;
		
		private var _maxLocalUpdate:int;
		private var _stepsToAvailable:int;
		private var _tower:Tower;
		
		private var _label:String;
		
		private var _preBuyLevel:int;
		private var _preBuyIsUpdated:Boolean;
		private var _preBuyRoadToAvailable:int;
		private var _preBuyAvailable:Boolean;
		
		public function Update() 
		{
			isUpdated = false;
			currentLevel = 1;
			nextUpsArray = [];
			_roadToAvailable = 0;
			_stepsToAvailable = 3;
			_maxLocalUpdate = 3;
		}
		
		public function SetTower(tower:Tower):void 
		{
			_tower = tower;
		}
		
		public function UpdateVars():void 
		{
			_currentLevel = _preBuyLevel;
			_isUpdated = _preBuyIsUpdated;
			_roadToAvailable = _preBuyRoadToAvailable;
			_available = _preBuyAvailable; 
			App.currentPlayer.money -= tmpMoney;
			tmpMoney = 0;
		}
		
		public function TakeToZero():void 
		{
			_preBuyLevel = _currentLevel;
			_preBuyIsUpdated = _isUpdated;
			_preBuyRoadToAvailable = _roadToAvailable;
			_preBuyAvailable = _available;
			tmpMoney = 0;
		}
		
		public static function AllUpsToZero():void 
		{
			var tmpUpdate:Update;
			for (var i:int = 0; i < App.UPDATES_NMBR; i++)
			{
				tmpUpdate = App.currentPlayer.updatesArray[i];
				tmpUpdate.TakeToZero();
			}
		}
		
		public function get firstUpFlag():Boolean { return _firstUpFlag; }
		
		public function set firstUpFlag(value:Boolean):void 
		{
			_firstUpFlag = value;
			if (_firstUpFlag)
			{
				isUpdated = _firstUpFlag;
			}
		}
		
		public function get currentLevel():int { return _currentLevel; }
		
		public function set currentLevel(value:int):void 
		{
			_currentLevel = value;
		}
		
		public function get available():Boolean { return _available; }
		
		public function set available(value:Boolean):void 
		{
			_available = value;
		}
		
		public function get nextUpsArray():Array { return _nextUpsArray; }
		
		public function set nextUpsArray(value:Array):void 
		{
			_nextUpsArray = value;
		}
		
		public function get roadToAvailable():int { return _roadToAvailable; }
		
		public function set roadToAvailable(value:int):void 
		{
			_roadToAvailable = value;
			if (_roadToAvailable == _stepsToAvailable)
			{
				available = true;
			}
			else if (_roadToAvailable > _stepsToAvailable)
			{
				throw(Error("Pipok mnogo!"));
			}
		}
		
		public function get stepsToAvailable():int { return _stepsToAvailable; }
		
		public function get maxLocalUpdate():int { return _maxLocalUpdate; }
		
		public function get isUpdated():Boolean { return _isUpdated; }
		
		public function set isUpdated(value:Boolean):void 
		{
			_isUpdated = value;
			if (value)
			{
				_preBuyAvailable = false;
				_available = false;
			}
		}
		
		public function get preBuyRoadToAvailable():int { return _preBuyRoadToAvailable; }
		
		public function set preBuyRoadToAvailable(value:int):void 
		{
			if (App.currentPlayer.money >= tmpMoney + ((value - _preBuyRoadToAvailable) * _roadCost))
			{
				tmpMoney += (value - _preBuyRoadToAvailable) * _roadCost;
				_preBuyRoadToAvailable = value;
				if (_preBuyRoadToAvailable == _stepsToAvailable)
				{
					_preBuyAvailable = true;
				}
				else if (_preBuyRoadToAvailable > _stepsToAvailable)
				{
					throw(Error("pipok bolshe chem est'!"));
				}
			}
		}
		
		public function get preBuyAvailable():Boolean { return _preBuyAvailable; }
		
		public function get preBuyIsUpdated():Boolean { return _preBuyIsUpdated; }
		
		public function set preBuyIsUpdated(value:Boolean):void 
		{
			if ((value) && App.currentPlayer.money >= tmpMoney + _currUpdCost)
			{
				tmpMoney += _currUpdCost;
				_preBuyAvailable = false;
				_preBuyIsUpdated = value;
			}
		}
		
		public function get preBuyLevel():int { return _preBuyLevel; }
		
		public function set preBuyLevel(value:int):void 
		{
			if (App.currentPlayer.money >= tmpMoney + (value - _preBuyLevel) * _lvlUpCost)
			{
				tmpMoney += (value - _preBuyLevel) * _lvlUpCost;
				_preBuyLevel = value;
			}
		}
		
		public function get roadCost():int { return _roadCost; }
		
		public function get currUpdCost():int { return _currUpdCost; }
		
		public function get label():String { return _label; }
		
		public function set label(value:String):void 
		{
			_label = value;
		}
		
		public function get towerCostWheal():int { return _towerCostWheal; }
		
		public function set towerCostWheal(value:int):void 
		{
			_towerCostWheal = value;
		}
		
		public function get towerCostGold():int { return _towerCostGold; }
		
		public function set towerCostGold(value:int):void 
		{
			_towerCostGold = value;
		}
		
		public function get description():String { return _description; }
		
		public function set description(value:String):void 
		{
			_description = value;
		}
		
		public function set preBuyAvailable(value:Boolean):void 
		{
			_preBuyAvailable = value;
		}
		
		public function get tower():Tower { return _tower; }
		
		public function set currUpdCost(value:int):void 
		{
			_currUpdCost = value;
		}
		
		public function get lvlUpCost():int { return _lvlUpCost; }
	}

}