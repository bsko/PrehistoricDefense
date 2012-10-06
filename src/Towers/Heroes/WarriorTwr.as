package Towers.Heroes 
{
	import Events.TowerBuilding;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author i am
	 */
	public class WarriorTwr extends Tower
	{
		public static const NAME:String = "WarriorTwr";
		public static const EXP_FOR_BUFF:int = 30;
		
		private var damagePercentBonus:int;
		private var criticalChanceBonus:int;
		private var criticalPowerBonus:int;
		private var rangeBonus:int;
		private var tmpArray:Array = [];
		private var buffTime:int = 12000;
		private var healingPower:int;
		
		private var buffingMovie:MovieClip = new buffing_spell();
		private var _auraTimer:Timer = new Timer(5000);
		
		public function WarriorTwr() 
		{
			//базовые характеристики
			_isHero = true;
			damagePercentBonus = 10;
			criticalChanceBonus = 0;
			criticalPowerBonus = 0;
			rangeBonus = 0;
			healingPower = 0;
			_baseAttackRange  = 300;
			_baseAttackSpeed = 5000;
			_baseDamageMin = 0;
			_baseDamageMax = 0;
			_baseHealth = 100;
			type = NAME;
			
			//множители к базовым характеристикам
			_koefLevelToAttackSpeed = 0;
			_koefLevelToDmgMax = 0;
			_koefLevelToDmgMin = 0;
			_koefLevelToRange = 0;
			_koefLevelToHealth = 0.1;
			
			criticalChance = 0;
			criticalPower = 0;
			accuracy = 0;
			updateReferences();
			
			towerMovie = new warriormovie_full();
			towerMovie.stop();
			towerMovie.scaleX = 0.85;
			towerMovie.scaleY = 0.85;
			//(towerMovie.getChildAt(0) as MovieClip).stop();
			
			_descriptionText = "His name is Ganzloe. He has spent all his life in the army command. Giving orders to your soldiers he will improve the tactics and combat characteristics of your army.  But he doesn’t take part in battles himself";
			_attackTimer.delay = _attackSpeed;
			
			_skillsArray = [];
			_skillsArray.push(new RealTowerSkill(0, App.skills.healing));
			_skillsArray.push(new RealTowerSkill(0, App.skills.fury));
			_skillsArray.push(new RealTowerSkill(0, App.skills.blessing));
			_skillsArray.push(new RealTowerSkill(0, App.skills.bloodRage));
			_skillsArray.push(new RealTowerSkill(0, App.skills.fastCasting));
			_skillsArray.push(new RealTowerSkill(0, App.skills.strongSpirit));
			_skillsArray.push(new RealTowerSkill(0, App.skills.magicPower));
			_skillsArray.push(new RealTowerSkill(0, App.skills.pureMind));
			calculateSkills();
			addChild(towerMovie);
		}
		
		override public function Init(cellOwner:Grid, SkillsArray:Array = null):void 
		{
			super.Init(cellOwner, SkillsArray);
			_auraTimer.start();
			_auraTimer.addEventListener(TimerEvent.TIMER, onFindTowersForAura, false, 0, true);
		}
		
		private function onFindTowersForAura(e:TimerEvent):void 
		{
			if (_skillsArray[7].currentLevel > 0)
			{
				var tmpArray:Array = App.universe.towersArray;
				var length:int = tmpArray.length;
				var tmpTower:Tower;
				for (var i:int = 0; i < length; i++)
				{
					tmpTower = tmpArray[i];
					if (tmpTower.BonusesObject.auraCritChance == 0)
					{
						tmpTower.BonusesObject.auraCritChance = _skillsInfluence.addedCriticalChanceAura;
						tmpTower.calculateAddedDamage();
					}
				}
			}
		}
		
		override protected function onFindTarget(e:Event):void 
		{
			if (!App.isPauseOn)
			{
				var length:int = Tower.towersArray.length;
				var tmpTower:Tower;
				var distance:int;
				tmpArray.length = 0;
				for (var i:int = 0; i < length; i++)
				{
					tmpTower = Tower.towersArray[i];
					if (tmpTower == this)
					{
						continue;
					}
					distance = Math.sqrt((tmpTower.currentCell.x - currentCell.x) * (tmpTower.currentCell.x - currentCell.x) 
													+ (tmpTower.currentCell.y - currentCell.y) * (tmpTower.y - currentCell.y) / (App.YScale * App.YScale));
					if (distance <= _attackRange)
					{
						if (!tmpTower.isBaffed)
						{
							tmpArray.push(tmpTower);
						}
					}	
				}
				if (tmpArray.length != 0)
				{
					App.soundControl.playSound("buff");
					buffTower(tmpArray[App.randomInt(0, tmpArray.length)]);
				}
			}
		}
		
		private function buffTower(tmpTower:Tower):void 
		{
			towerMovie.play();
			buffingMovie.x = 0;
			buffingMovie.y = - tmpTower.currentCell.gridHeight - App.HEIGHT_DELAY;
			buffingMovie.gotoAndPlay(1);
			tmpTower.currentCell.addChild(buffingMovie);
			var tmpInt:int = (tmpTower.damageMin + tmpTower.damageMax) / 2;
			tmpInt = tmpInt * (damagePercentBonus / 100);
			tmpTower.BonusesObject.buffDamage = tmpInt + _skillsInfluence.addedBuffDamage;
			tmpTower.BonusesObject.buffCritChance = _skillsInfluence.addedBuffCriticalChance;
			tmpTower.BonusesObject.buffCritPower = _skillsInfluence.addedBuffCriticalPower;
			tmpTower.BonusesObject.buffRange = rangeBonus;
			tmpTower.calculateAddedDamage();
			tmpTower.StartBuff(buffTime);
			experience += EXP_FOR_BUFF;
		}
		
		override public function destroy():void 
		{
			_auraTimer.reset();
			super.destroy();
			App.pools.returnPoolObject(NAME, this);
		}
	}

}