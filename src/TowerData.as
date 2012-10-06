package  
{
	/**
	 * ...
	 * @author i am
	 */
	public class TowerData 
	{
		public static const NAME:String = "TowerData";
		public static const baseGoldCostsArray:Array = [/*1*/28, 42, 68, 62, 74,/*2*/ 16, 28, 34, 30,/*3*/ 22, 40, 48, 48, 60];
		public static const baseWhealCostsArray:Array = [/*1*/16, 30, 44, 32, 40,/*2*/ 22, 42, 56, 84,/*3*/ 22, 38, 45, 68, 58];
		public static const baseCrystalCostsArray:Array = [/*1*/100, 200, 650, 300, 500,/*2*/ 100, 250, 450, 550,/*3*/ 100, 200, 300, 500, 550];
		private var _whealCost:int;
		private var _goldCost:int;
		private var _level:int;
		private var _name:String;
		private var _realName:String;
		private var _towerToIconName:String;
		private var _title:String;
		private var _isHero:Boolean = false;
		private var _skillsArray:Array = [];
		private var _experience:int;
		private var _experienceToNextLevel:int;
		private var _skillPoints:int = 0;
		private var _description:String;
		private var _realTitle:String;
		private var _isUnlocked:Boolean = true;
		
		public function destroy():void 
		{
			_whealCost = 0;
			_goldCost = 0;
			_level = 0;
			_name = "";
			skillsArray.length = 0;
			_isHero = false;
			realName = "";
			App.pools.returnPoolObject(NAME, this)
		}
		
		public function ImportFromTower(tower:Tower):void 
		{
			realTitle = tower.title;
			experience = tower.experience;
			experienceToNextLevel = tower.experienceToNextLevel;
			level = tower.level;
			name = tower.type;
			goldCost = tower.goldCost;
			whealCost = tower.wheatCost;
			isHero = tower.isHero;
			realName = tower.realName;
			skillPoints = tower.skillPoints;
			description = tower.descriptionText;
			for (var count:int = 0; count < App.SKILLS_NMBR; count++)
			{
				if (_skillsArray[count] == null)
				{
					_skillsArray[count] = new Object();
				}	
				_skillsArray[count].currentLevel = tower.skillsArray[count].currentLevel;
				_skillsArray[count].isAvailable = tower.skillsArray[count].isAvailable;
			}
		}
		
		public function get whealCost():int { return _whealCost; }
		
		public function set whealCost(value:int):void 
		{
			_whealCost = value;
		}
		
		public function get goldCost():int { return _goldCost; }
		
		public function set goldCost(value:int):void 
		{
			_goldCost = value;
		}
		
		public function get level():int { return _level; }
		
		public function set level(value:int):void 
		{
			_level = value;
		}
		
		public function get name():String { return _name; }
		
		public function set name(value:String):void 
		{
		// TODO доделать свитч нэймов башен!
			title = value;
			switch(value)
			{
				case "Spearman":
				_name = "SpearmanTwr";
				break;
				case "Hunter":
				_name = "HunterTwr";
				break;
				case "Javelin_thrower":
				_name = "JavelinThrowerTwr";
				break;
				case "Regular_spearman":
				_name = "RegularSpearmanTwr";
				break;
				case "Elite_spearman":
				_name = "EliteSpearmanTwr";
				break;
				case "Stone_thrower":
				_name = "StoneThrowerTwr";
				break;
				case "Slingman":
				_name = "SlingManTwr";
				break;
				case "Ranger":
				_name = "RangerTwr";
				break;
				case "Archer":
				_name = "ArcherTwr";
				break;
				case "Maceman":
				_name = "ClubmanTwr";
				break;
				case "Hummerman":
				_name = "HummerManTwr";
				break;
				case "Elite_hummerman":
				_name = "HummerStoneTwr";
				break;
				case "Woodcutter":
				_name = "WoodcutterTwr";
				break;
				case "Swordman":
				_name = "SwordmanTwr";
				break;
				default:
				_name = value;
				switch(_name)
				{
					case "SpearmanTwr":
					_title = "Spearman";
					break;
					case "HunterTwr":
					_title = "Hunter";
					break;
					case "JavelinThrowerTwr":
					_title = "Javelin_thrower";
					break;
					case "RegularSpearmanTwr":
					_title = "Regular_spearman";
					break;
					case "EliteSpearmanTwr":
					_title = "Elite_spearman";
					break;
					case "StoneThrowerTwr":
					_title = "Stone_thrower";
					break;
					case "SlingManTwr":
					_title = "Slingman";
					break;
					case "RangerTwr":
					_title = "Ranger";
					break;
					case "ArcherTwr":
					_title = "Archer";
					break;
					case "ClubmanTwr":
					_title = "Maceman";
					break;
					case "HummerManTwr":
					_title = "Hummerman";
					break;
					case "HummerStoneTwr":
					_title = "Elite_hummerman";
					break;
					case "WoodcutterTwr":
					_title = "Woodcutter";
					break;
					case "SwordmanTwr":
					_title = "Swordman";
					break;
					case "BerserkTwr":
					_title = "Berserk";
					break;
					case "GladiatorTwr":
					_title = "Gladiator";
					break;
					case "RobinHoodTwr":
					_title = "Robin Hood";
					break;
					case "ShamanTwr":
					_title = "Shaman";
					break;
					case "WarriorTwr":
					_title = "Warrior";
					break;
				}
				break;
			}
		}
		
		public function get experience():int { return _experience; }
		
		public function get title():String { return _title; }
		
		public function set title(value:String):void 
		{
			_title = value;
		}
		
		public function set experience(value:int):void 
		{
			_experience = value;
		}
		
		public function get skillsArray():Array { return _skillsArray; }
		
		public function set skillsArray(value:Array):void 
		{
			_skillsArray = value;
		}
		
		public function get isHero():Boolean { return _isHero; }
		
		public function set isHero(value:Boolean):void 
		{
			_isHero = value;
		}
		
		public function get realName():String { return _realName; }
		
		public function set realName(value:String):void 
		{
			_realName = value;
		}
		
		public function get skillPoints():int { return _skillPoints; }
		
		public function set skillPoints(value:int):void 
		{
			_skillPoints = value;
		}
		
		public function get description():String { return _description; }
		
		public function set description(value:String):void 
		{
			_description = value;
		}
		
		public function get isUnlocked():Boolean { return _isUnlocked; }
		
		public function set isUnlocked(value:Boolean):void 
		{
			_isUnlocked = value;
		}
		
		public function get experienceToNextLevel():int { return _experienceToNextLevel; }
		
		public function set experienceToNextLevel(value:int):void 
		{
			_experienceToNextLevel = value;
		}
		
		public function get realTitle():String { return _realTitle; }
		
		public function set realTitle(value:String):void 
		{
			_realTitle = value;
		}
	}

}