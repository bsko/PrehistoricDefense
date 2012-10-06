package  
{
	import Magic.Aerolite;
	import Magic.Chest;
	import Magic.Fireball;
	import Magic.Firerain;
	import Magic.Frostrain;
	import Magic.Heavy_stone;
	import Magic.Money;
	import Magic.Money_bags;
	import Magic.Roots;
	import Magic.Snare;
	import Magic.Stakes;
	import Magic.Stone;
	import Towers.ArcherTwr;
	import Towers.ClubmanTwr;
	import Towers.EliteSpearmanTwr;
	import Towers.Heroes.*;
	import Towers.HummerManTwr;
	import Towers.HummerStoneTwr;
	import Towers.HunterTwr;
	import Towers.JavelinThrowerTwr;
	import Towers.RangerTwr;
	import Towers.RegularSpearmanTwr;
	import Towers.SlingManTwr;
	import Towers.SpearmanTwr;
	import Towers.StoneThrowerTwr;
	import Towers.SwordmanTwr;
	import Towers.WoodcutterTwr;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PlayerAccount 
	{
		// TODO fix when u'll need a non-cheat version
		
		public static const MoneyForLevel:Array = [75, 100, 150, 100, 100, 100, 100, 100, 100, 10, 100, 15, 13, 200, 500, 100, 80, 120, 99, 300];
		//public static const MoneyForLevel:Array = [50, 15000, 15000, 10000, 10000, 10000, 10000, 10000, 10000, 10000, 10000, 15000, 13000, 20000, 50000, 10000, 8000, 12000, 9900, 30000];
		public static const WheatForLevel:Array = [75, 100, 150, 100, 100, 100, 100, 100, 100, 10, 100, 15, 13, 200, 500, 100, 80, 120, 99, 300];
		//public static const WheatForLevel:Array = [50, 15000, 15000, 10000, 10000, 10000, 10000, 10000, 10000, 10000, 10000, 10050, 13000, 20000, 50000, 10000, 8000, 10020, 9900, 30000];
		
		private var _money:int = 0;
		
		private var _gold:int = 0;
		private var _wheat:int = 0;
		private var _score:int = 0;
		
		private var _name:String;
		private var _icon:String;
		private var _progress:String;
		private var _available:Boolean;
		private var _updatesArray:Array;
		private var _spellsArray:Array;
		private var _levelsArray:Array;
		private var _armyArray:Array;
		private var _heroesArray:Array;
		private var _recruitsArray:Array;
		private var _selectedSpells:Array;
		private var _unlockedHeroesCount:int;
		private var _lockedHeroesArray:Array;
		
		private var _heroesTMPArray:Array;
		private var _armyTMPArray:Array;
		
		public function Free():void 
		{
			_name = "";
			_icon = "";
			_progress = "";
			gold = 0;
			_available = false;
			updatesArray = []; 
			spellsArray = [];
			levelsArray = [];
			armyArray = [];
			heroesArray = [];
			lockedHeroesArray = [];
			selectedSpells = [];
			_heroesTMPArray = [];
			_armyTMPArray = [];
			unlockedHeroesCount = 0;
			InitUpdates();
			InitSpells();
			InitLevels();
			InitHeroes();
			TakingTMPVarsToZeroAfterLevel();
		}
		
		public function TakingTMPVarsToZeroAfterLevel():void 
		{
			_gold = 0;
			_score = 0;
			_wheat = 0;
		}
		
		private function InitSpells():void 
		{
			spellsArray[0] = new Fireball();
			spellsArray[1] = new Frostrain();
			spellsArray[2] = new Firerain();
			spellsArray[3] = new Snare();
			spellsArray[4] = new Stakes();
			spellsArray[5] = new Roots();
			spellsArray[6] = new Stone();
			spellsArray[7] = new Heavy_stone();
			spellsArray[8] = new Aerolite();
			spellsArray[9] = new Money();
			spellsArray[10] = new Money_bags();
			spellsArray[11] = new Chest();
			(spellsArray[0] as Spell).nextUp = (spellsArray[1] as Spell);
			(spellsArray[1] as Spell).nextUp = (spellsArray[2] as Spell);
			(spellsArray[3] as Spell).nextUp = (spellsArray[4] as Spell);
			(spellsArray[4] as Spell).nextUp = (spellsArray[5] as Spell);
			(spellsArray[6] as Spell).nextUp = (spellsArray[7] as Spell);
			(spellsArray[7] as Spell).nextUp = (spellsArray[8] as Spell);
			(spellsArray[9] as Spell).nextUp = (spellsArray[10] as Spell);
			(spellsArray[10] as Spell).nextUp = (spellsArray[11] as Spell);
			for (var i:int = 0; i < App.SPELLS_NMBR; i++)
			{
				spellsArray[i].description = MainMenuDescriptions.SPELLS_DESCRIPTION[i];
				spellsArray[i].currUpdCost = Spell.CrystalCosts[i];
			}
		}
		
		private function InitLevels():void 
		{
			for (var i:int = 0; i < App.LEVELS_NMBR; i++)
			{
				levelsArray.push("locked");
			}
			
			// TODO fix when u'll need a non-cheat version
			levelsArray[0] = "perfect";
			levelsArray[1] = "perfect";
			levelsArray[2] = "perfect";
			levelsArray[3] = "perfect";
			levelsArray[4] = "perfect";
			levelsArray[5] = "perfect";
			levelsArray[6] = "perfect";
			levelsArray[7] = "perfect";
			levelsArray[8] = "perfect";
			levelsArray[9] = "perfect";
			levelsArray[10] = "perfect";
			levelsArray[11] = "perfect";
			levelsArray[12] = "perfect";
			levelsArray[13] = "perfect";
			levelsArray[14] = "perfect";
			levelsArray[15] = "unlocked";
			levelsArray[16] = "normal";
			levelsArray[17] = "good";
			levelsArray[18] = "unlocked";
			levelsArray[19] = "normal";
			levelsArray[20] = "good";
		}
		
		private function InitUpdates():void 
		{
			var tmpUpdate:Update;
			for (var i:int = 0; i < App.UPDATES_NMBR; i++)
			{
				tmpUpdate = new Update();
				tmpUpdate.towerCostGold = TowerData.baseGoldCostsArray[i];
				tmpUpdate.towerCostWheal = TowerData.baseWhealCostsArray[i];
				tmpUpdate.description = MainMenuDescriptions.TOWERS_DESCR[i];
				tmpUpdate.currUpdCost = TowerData.baseCrystalCostsArray[i];
				updatesArray.push(tmpUpdate);
			}
			tmpUpdate = updatesArray[0];
			tmpUpdate.firstUpFlag = true;
			tmpUpdate.nextUpsArray.push(updatesArray[1]);
			tmpUpdate.label = "Spearman";
			tmpUpdate.SetTower(new SpearmanTwr() as Tower);
			tmpUpdate = updatesArray[1];
			tmpUpdate.nextUpsArray.push(updatesArray[2]);
			tmpUpdate.nextUpsArray.push(updatesArray[3]);
			tmpUpdate.label = "Hunter";
			tmpUpdate.SetTower(new HunterTwr() as Tower);
			tmpUpdate = updatesArray[2];
			tmpUpdate.label = "Javelin_thrower";
			tmpUpdate.SetTower(new JavelinThrowerTwr() as Tower);
			tmpUpdate = updatesArray[3];
			tmpUpdate.nextUpsArray.push(updatesArray[4]);
			tmpUpdate.label = "Regular_spearman";
			tmpUpdate.SetTower(new RegularSpearmanTwr() as Tower);
			tmpUpdate = updatesArray[4];
			tmpUpdate.label = "Elite_spearman";
			tmpUpdate.SetTower(new EliteSpearmanTwr() as Tower);
			tmpUpdate = updatesArray[5];
			tmpUpdate.firstUpFlag = true;
			tmpUpdate.nextUpsArray.push(updatesArray[6]);
			tmpUpdate.label = "Stone_thrower";
			tmpUpdate.SetTower(new StoneThrowerTwr() as Tower);
			tmpUpdate = updatesArray[6];
			tmpUpdate.nextUpsArray.push(updatesArray[7]);
			tmpUpdate.label = "Slingman";
			tmpUpdate.SetTower(new SlingManTwr() as Tower);
			tmpUpdate = updatesArray[7];
			tmpUpdate.nextUpsArray.push(updatesArray[8]);
			tmpUpdate.label = "Ranger";
			tmpUpdate.SetTower(new RangerTwr() as Tower);
			tmpUpdate = updatesArray[8];
			tmpUpdate.label = "Archer";
			tmpUpdate.SetTower(new ArcherTwr() as Tower);
			tmpUpdate = updatesArray[9];
			tmpUpdate.firstUpFlag = true;
			tmpUpdate.nextUpsArray.push(updatesArray[10]);
			tmpUpdate.label = "Maceman";
			tmpUpdate.SetTower(new ClubmanTwr() as Tower);
			tmpUpdate = updatesArray[10];
			tmpUpdate.nextUpsArray.push(updatesArray[11]);
			tmpUpdate.label = "Hummerman";
			tmpUpdate.SetTower(new HummerManTwr() as Tower);
			tmpUpdate = updatesArray[11];
			tmpUpdate.nextUpsArray.push(updatesArray[12]);
			tmpUpdate.nextUpsArray.push(updatesArray[13]);
			tmpUpdate.label = "Elite_hummerman";
			tmpUpdate.SetTower(new HummerStoneTwr() as Tower);
			tmpUpdate = updatesArray[12];
			tmpUpdate.label = "Woodcutter";
			tmpUpdate.SetTower(new WoodcutterTwr() as Tower);
			tmpUpdate = updatesArray[13];
			tmpUpdate.label = "Swordman";
			tmpUpdate.SetTower(new SwordmanTwr() as Tower);
		}
			
		public function InitHeroes():void 
		{
			if (_heroesArray.length > 0)
			{
				var length:int = _heroesArray.length;
				for (var i:int = 0; i < length; i++)
				{
					var tmpData:TowerData = _heroesArray[i];
					tmpData.destroy();
					tmpData.isHero = true;
				}
			}
			var tmpTowerData:TowerData = App.pools.getPoolObject(TowerData.NAME);
			tmpTowerData.name = WarriorTwr.NAME;
			tmpTowerData.level = 1;
			tmpTowerData.goldCost = HeroesAbout.ABOUT_WARRIOR.goldCost;
			tmpTowerData.whealCost = HeroesAbout.ABOUT_WARRIOR.wheatCost;
			tmpTowerData.description = HeroesAbout.ABOUT_WARRIOR.description;
			tmpTowerData.realTitle = HeroesAbout.ABOUT_WARRIOR.description;
			_heroesArray.push(tmpTowerData);
			
			var tmpTowerData2:TowerData = App.pools.getPoolObject(TowerData.NAME);
			tmpTowerData2.name = BerserkTwr.NAME;
			tmpTowerData2.level = 1;
			tmpTowerData2.goldCost = HeroesAbout.ABOUT_BERSERK.goldCost;
			tmpTowerData2.whealCost = HeroesAbout.ABOUT_BERSERK.wheatCost;
			tmpTowerData2.description = HeroesAbout.ABOUT_BERSERK.description;
			tmpTowerData2.realTitle = HeroesAbout.ABOUT_BERSERK.description;
			_heroesArray.push(tmpTowerData2);
			
			var tmpTowerData3:TowerData = App.pools.getPoolObject(TowerData.NAME);
			tmpTowerData3.name = RobinHoodTwr.NAME;
			tmpTowerData3.level = 1;
			tmpTowerData3.goldCost = HeroesAbout.ABOUT_ROBINHOOD.goldCost;
			tmpTowerData3.whealCost = HeroesAbout.ABOUT_ROBINHOOD.wheatCost;
			tmpTowerData3.description = HeroesAbout.ABOUT_ROBINHOOD.description;
			tmpTowerData3.realTitle = HeroesAbout.ABOUT_ROBINHOOD.description;
			_heroesArray.push(tmpTowerData3);
			
			var tmpTowerData4:TowerData = App.pools.getPoolObject(TowerData.NAME);
			tmpTowerData4.name = ShamanTwr.NAME;
			tmpTowerData4.level = 1;
			tmpTowerData4.goldCost = HeroesAbout.ABOUT_SHAMAN.goldCost;
			tmpTowerData4.whealCost = HeroesAbout.ABOUT_SHAMAN.wheatCost;
			tmpTowerData4.description = HeroesAbout.ABOUT_SHAMAN.description;
			tmpTowerData4.realTitle = HeroesAbout.ABOUT_SHAMAN.description;
			_heroesArray.push(tmpTowerData4);
			
			var tmpTowerData5:TowerData = App.pools.getPoolObject(TowerData.NAME);
			tmpTowerData5.name = GladiatorTwr.NAME;
			tmpTowerData5.level = 1;
			tmpTowerData5.goldCost = HeroesAbout.ABOUT_GLADIATOR.goldCost;
			tmpTowerData5.whealCost = HeroesAbout.ABOUT_GLADIATOR.wheatCost;
			tmpTowerData5.description = HeroesAbout.ABOUT_GLADIATOR.description;
			tmpTowerData5.realTitle = HeroesAbout.ABOUT_GLADIATOR.description;
			_heroesArray.push(tmpTowerData5);
			
			
			// TODO fix when u'll need a non-cheat version
			length = _heroesArray.length;
			for (i = 0; i < length; i++)
			{
				tmpData = _heroesArray[i];
				tmpData.isUnlocked = false;
				//tmpData.isUnlocked = true;
				tmpData.isHero = true;
				lockedHeroesArray.push(tmpData);
				for (var j:int = 0; j < App.SKILLS_NMBR; j++)
				{
					var tmpObject:Object = new Object();
					tmpObject.isAvailable = false;
					//tmpObject.isAvailable = true;
					//tmpObject.currentLevel = 2;
					tmpObject.currentLevel = 0;
					tmpData.skillsArray[j] = tmpObject;
				}
			}
		}
		
		public function get name():String { return _name; }
		
		public function set name(value:String):void 
		{
			_name = value;
		}
		
		public function get icon():String { return _icon; }
		
		public function set icon(value:String):void 
		{
			_icon = value;
		}
		
		public function get progress():String { return _progress; }
		
		public function set progress(value:String):void 
		{
			_progress = value;
		}
		
		public function get available():Boolean { return _available; }
		
		public function set available(value:Boolean):void 
		{
			_available = value;
		}
		
		public function get updatesArray():Array { return _updatesArray; }
		
		public function set updatesArray(value:Array):void 
		{
			_updatesArray = value;
		}
		
		public function get levelsArray():Array { return _levelsArray; }
		
		public function set levelsArray(value:Array):void 
		{
			_levelsArray = value;
		}
		
		public function get money():int { return _money; }
		
		public function set money(value:int):void 
		{
			_money = value;
		}
		
		public function get spellsArray():Array { return _spellsArray; }
		
		public function set spellsArray(value:Array):void 
		{
			_spellsArray = value;
		}
		
		public function get armyArray():Array { return _armyArray; }
		
		public function set armyArray(value:Array):void 
		{
			_armyArray = value;
		}
		
		public function get selectedSpells():Array { return _selectedSpells; }
		
		public function set selectedSpells(value:Array):void 
		{
			_selectedSpells = value;
		}
		
		public function get score():int { return _score; }
		
		public function set score(value:int):void 
		{
			_score = value;
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
		
		public function get heroesArray():Array { return _heroesArray; }
		
		public function set heroesArray(value:Array):void 
		{
			_heroesArray = value;
		}
		
		public function get unlockedHeroesCount():int { return _unlockedHeroesCount; }
		
		public function set unlockedHeroesCount(value:int):void 
		{
			_unlockedHeroesCount = value;
		}
		
		public function get lockedHeroesArray():Array { return _lockedHeroesArray; }
		
		public function set lockedHeroesArray(value:Array):void 
		{
			_lockedHeroesArray = value;
		}
		
		public function get armyTMPArray():Array { return _armyTMPArray; }
		
		public function set armyTMPArray(value:Array):void 
		{
			_armyTMPArray = value;
		}
		
		public function get heroesTMPArray():Array { return _heroesTMPArray; }
		
		public function set heroesTMPArray(value:Array):void 
		{
			_heroesTMPArray = value;
		}
	}

}