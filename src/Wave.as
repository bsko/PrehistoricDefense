package  
{
	/**
	 * ...
	 * @author author
	 */
	public class Wave 
	{
		public static const NAME:String = "Wave";
		
		private var _type:String;
		private var _numberOfType:int;
		private var _enemiesDelay:int;
		private var _enemyHP:int;
		private var _enemyArmor:int;
		private var _cost:int;
		private var _resistToBlunt:int;
		private var _resistToSword:int;
		private var _resistToPike:int;
		private var _resistToMagic:int;
		private var _isKeyWave:Boolean;
		private var _keyOwnerIndex:int;
		private var _isBossWave:int;
		private var _name:String;
		public var _destroyed:Boolean = true;
		
		public function findAKeyMonster():void
		{
			if (_isKeyWave)
			{
				_keyOwnerIndex = App.randomInt(0, _numberOfType);
			}
			else
			{
				_keyOwnerIndex = 9999;
			}
		}
		
		public function Init(type:String, numberOfType:int, enemiesDelay:int, enemyHP:int, enemyArmor:int, cost:int, resistBlunt:int, resistSword:int, resistPike:int, resistMagic:int, isThereAKey:Boolean = false, bossWave:int = 0):void
		{
			_destroyed = false;
			_type = type;
			InitName(type);
			_numberOfType = numberOfType;
			_enemiesDelay = enemiesDelay;
			_enemyHP = enemyHP;
			_enemyArmor = enemyArmor;
			_cost = cost;
			_resistToBlunt = resistBlunt;
			_resistToSword = resistSword;
			_resistToPike = resistPike;
			_resistToMagic = resistMagic;
			_isKeyWave = isThereAKey;
			_isBossWave = bossWave;
		}
		
		private function InitName(type:String):void 
		{
			switch(type)
			{
				case "BlueDino":
				_name = MonsterNames.BLUEDINO[MonsterNames.BlueDino_Iterator];
				MonsterNames.BlueDino_Iterator++;
				break;
				case "DinozavrOrange":
				_name = MonsterNames.DINOZAVR_ORANGE[MonsterNames.DinozavrOrange_Iterator];
				MonsterNames.DinozavrOrange_Iterator++;
				break;
				case "Doublelegged":
				_name = MonsterNames.DOUBLELEGGED[MonsterNames.Doublelegged_Iterator];
				MonsterNames.Doublelegged_Iterator++;
				break;
				case "BigGreenBird":
				case "Pterodaktel":
				case "SmallBlackBird":
				_name = MonsterNames.FLYING[MonsterNames.Flying_Iterator];
				MonsterNames.Flying_Iterator++;
				break;
				case "Frog":
				_name = MonsterNames.FROG[MonsterNames.Frog_Iterator];
				MonsterNames.Frog_Iterator++;
				break;
				case "Kaban":
				_name = MonsterNames.KABAN[MonsterNames.Kaban_Iterator];
				MonsterNames.Kaban_Iterator++;
				break;
				case "Rat":
				_name = MonsterNames.RAT[MonsterNames.Rat_Iterator];
				MonsterNames.Rat_Iterator++;
				break;
				case "SaberTooth":
				_name = MonsterNames.SABERTOOTH[MonsterNames.SaberTooth_Iterator];
				MonsterNames.SaberTooth_Iterator++;
				break;
				case "Spider":
				_name = MonsterNames.SPIDER[MonsterNames.Spider_Iterator];
				MonsterNames.Spider_Iterator++;
				break;
				case "Thorner":
				_name = MonsterNames.THORNER[MonsterNames.Thorner_Iterator];
				MonsterNames.Thorner_Iterator++;
				break;
				case "Tiger":
				_name = MonsterNames.TIGER[MonsterNames.Tiger_Iterator];
				MonsterNames.Tiger_Iterator++;
				break;
				case "WhiteTiger":
				_name = MonsterNames.WHITETIGER[MonsterNames.WhiteTiger_Iterator];
				MonsterNames.WhiteTiger_Iterator++;
				break;
				case "ZlobniyGlist":
				_name = MonsterNames.ZLOBNIYGLIST[MonsterNames.ZlobniyGlist_Iterator];
				MonsterNames.ZlobniyGlist_Iterator++;
				break;
				default:
				_name = "default";
				break;
			}
		}
		
		public function destroy():void
		{
			_destroyed = true;
			_type = "";
			_numberOfType = 0;
			_enemiesDelay = 0;
			_enemyHP = 0;
			_enemyArmor = 0;
			_cost = 0;
			_resistToBlunt = 0;
			_resistToSword = 0;
			_resistToPike = 0;
			_resistToMagic = 0;
			_isKeyWave = false;
			App.pools.returnPoolObject(NAME, this);
		}
		
		public function get enemiesDelay():int { return _enemiesDelay; }
		
		public function get type():String { return _type; }
		
		public function get numberOfType():int { return _numberOfType; }
		
		public function get enemyHP():int { return _enemyHP; }
		
		public function get enemyArmor():int { return _enemyArmor; }
		
		public function get cost():int { return _cost; }
		
		public function get resistToBlunt():int { return _resistToBlunt; }
		
		public function get resistToSword():int { return _resistToSword; }
		
		public function get resistToPike():int { return _resistToPike; }
		
		public function get resistToMagic():int { return _resistToMagic; }
		
		public function set numberOfType(value:int):void 
		{
			_numberOfType = value;
		}
		
		public function get isKeyWave():Boolean { return _isKeyWave; }
		
		public function set isKeyWave(value:Boolean):void 
		{
			_isKeyWave = value;
		}
		
		public function get keyOwnerIndex():int { return _keyOwnerIndex; }
		
		public function set keyOwnerIndex(value:int):void 
		{
			_keyOwnerIndex = value;
		}
		
		public function get isBossWave():int { return _isBossWave; }
		
		public function get name():String { return _name; }
	}

}