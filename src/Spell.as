package  
{
	import Events.PauseEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import Magic.Snare;
	/**
	 * ...
	 * @author ...
	 */
	public class Spell extends Sprite
	{
		public static var tmpMoney:int;
		public static const CostsArray:Array = [10, 30, 30, 25, 35, 20, 20, 20, 30, 10, 10, 10];
		public static const AreaArray:Array = [100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100];
		public static const SpellDamageArray:Array = [500, 500, 500, 500, 500, 500, 500, 500, 500, 500, 500, 500];
		public static const CrystalCosts:Array = [100, 300, 500, 100, 300, 500, 100, 300, 500, 100, 300, 500];
		
		protected var _available:Boolean;
		protected var _nextUp:Spell;
		protected var _roadToAvailable:int;
		protected var _firstUpFlag:Boolean;
		protected var _currentLevel:int;
		protected var _isUpdated:Boolean;
		protected var _checkBoxState:String;
		protected var _area:int;
		protected var _dmg:int;
		private var _description:String;
		protected var _currUpdCost:int = 100;
		private var _lvlUpCost:int = 75;
		
		protected var _roadCost:int = 70;
		protected var _castCost:int;
		protected var _maxLocalUpdate:int;
		protected var _stepsToAvailable:int;
		protected var _label:String;
		protected var _title:String;
		protected var _index:int;
		protected var _preBuyLevel:int;
		protected var _preBuyIsUpdated:Boolean;
		protected var _preBuyRoadToAvailable:int;
		protected var _preBuyAvailable:Boolean;
		protected var _isBuffMagic:Boolean = false;
		protected var _cooldownTime:int = 150;
		protected var _cooldownTimer:int = 0;
		protected var _isTrap:Boolean = false;
		protected var _isInstantCastSpell:Boolean = false;
		private var _isCooldown:Boolean = false;
		public static var updatedSpells:Array = [];
		
		public function Spell():void
		{
			isUpdated = false;
			currentLevel = 1;
			nextUp = null;
			_roadToAvailable = 0;
			_stepsToAvailable = 2;
			_stepsToAvailable = 2;
			_maxLocalUpdate = 5;
			_checkBoxState = "off";
		}
		
		public function UseMagic(grid:Grid):void
		{
			App.ingameInterface.addEventListener(PauseEvent.PAUSE, onPauseEvent, false, 0, true);
			App.ingameInterface.addEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false, 0, true);
		}
		
		protected function onUnpauseEvent(e:PauseEvent):void 
		{
			// перегружена в наследованных от нее классах
		}
		
		protected function onPauseEvent(e:PauseEvent):void 
		{
			// перегружена в наследованных от нее классах
		}
		
		public function UpdateVars():void
		{
			_currentLevel = _preBuyLevel;
			if ((!_isUpdated) && (_preBuyIsUpdated))
			{
				checkBoxState = "change";
			}
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
		
		public function Destroy():void
		{
			App.ingameInterface.removeEventListener(PauseEvent.PAUSE, onPauseEvent, false);
			App.ingameInterface.removeEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false);
		}
		
		public static function AllSpellsToZero():void
		{
			var tmpSpell:Spell;
			for (var i:int = 0; i < App.SPELLS_NMBR; i++)
			{
				tmpSpell = App.currentPlayer.spellsArray[i];
				tmpSpell.TakeToZero();
			}
		}
		
		public function get firstUpFlag():Boolean { return _firstUpFlag; }
		
		public function set firstUpFlag(value:Boolean):void 
		{
			_firstUpFlag = value;
			if (_firstUpFlag)
			{
				available = _firstUpFlag;
			}
		}
		
		public function get currentLevel():int { return _currentLevel; }
		
		public function set currentLevel(value:int):void 
		{
			_currentLevel = value;
			if (this is Snare)
			{
				_cooldownTime = Snare.COOLDOWN_TIME - ((_currentLevel - 1) * 60);
			}
		}
		
		public function get available():Boolean { return _available; }
		
		public function set available(value:Boolean):void 
		{
			_available = value;
		}
		
		public function get nextUp():Spell { return _nextUp; }
		
		public function set nextUp(value:Spell):void 
		{
			_nextUp = value;
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
		}
		
		public function get preBuyRoadToAvailable():int { return _preBuyRoadToAvailable; }
		
		public function set preBuyRoadToAvailable(value:int):void 
		{
			if (App.currentPlayer.money >= tmpMoney + (value - _preBuyRoadToAvailable) * _roadCost)
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
			if ((value) && App.currentPlayer.money >= tmpMoney + _currUpdCost && !preBuyIsUpdated)
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
		
		public function get checkBoxState():String { return _checkBoxState; }
		
		public function set checkBoxState(value:String):void 
		{
			if (value == "change")
			{
				switch(_checkBoxState)
				{
					case "on":
						_checkBoxState = "off";
						for (var i:int = 0; i < App.SELECTED_SPELLS; i++)
						{
							if (App.currentPlayer.selectedSpells[i] == this)
							{
								App.currentPlayer.selectedSpells.splice(i, 1);
								return;
							}
						}
					case "off":
						if (App.currentPlayer.selectedSpells.length == 3)
						{
							if (App.currentPlayer.selectedSpells[0] != null)
							{
								App.currentPlayer.selectedSpells[0].checkBoxState = "off";
							}
							App.currentPlayer.selectedSpells.shift();
							_checkBoxState = "on";
							App.currentPlayer.selectedSpells.push(this);
						}
						else
						{
							_checkBoxState = "on";
							App.currentPlayer.selectedSpells.push(this);
						}
				}
			}
			else if ( value == "off")
			{
				_checkBoxState = "off";
			}
			else if ( value == "on")
			{
				_checkBoxState = "on";
			}
		}
		
		public function get index():int { return _index; }
		
		public function set index(value:int):void 
		{
			_index = value;
		}
		
		public function get castCost():int { return _castCost; }
		
		public function set castCost(value:int):void 
		{
			_castCost = value;
		}
		
		public function get area():int { return _area; }
		
		public function get dmg():int { return _dmg; }
		
		public function set dmg(value:int):void 
		{
			_dmg = value;
		}
		
		public function set area(value:int):void 
		{
			_area = value;
		}
		
		public function get isBuffMagic():Boolean { return _isBuffMagic; }
		
		public function get description():String { return _description; }
		
		public function set description(value:String):void 
		{
			_description = value;
		}
		
		public function get isTrap():Boolean { return _isTrap; }
		
		public function get isInstantCastSpell():Boolean { return _isInstantCastSpell; }
		
		public function get cooldownTime():int { return _cooldownTime; }
		
		public function get cooldownTimer():int { return _cooldownTimer; }
		
		public function set cooldownTimer(value:int):void 
		{
			_cooldownTimer = value;
		}
		
		public function get isCooldown():Boolean { return _isCooldown; }
		
		public function set isCooldown(value:Boolean):void 
		{
			_isCooldown = value;
		}
		
		public function get title():String { return _title; }
		
		public function set title(value:String):void 
		{
			_title = value;
		}
		
		public function set currUpdCost(value:int):void 
		{
			_currUpdCost = value;
		}
		
		public function get lvlUpCost():int { return _lvlUpCost; }
	}

}