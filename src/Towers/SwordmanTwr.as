package Towers 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author author
	 */
	public class SwordmanTwr extends Tower
	{
		public static const NAME:String = "SwordmanTwr";
		public function SwordmanTwr() 
		{
			//базовые характеристики
			_baseAttackRange = 100;
			_baseAttackSpeed = 900;
			_baseDamageMin = 25;
			_baseDamageMax = 28;
			_baseGoldCost = TowerData.baseGoldCostsArray[13];
			_baseWheatCost = TowerData.baseWhealCostsArray[13];
			_baseHealth = 100;
			type = NAME;
			_damageType = DamageTypes.SWORD;
			
			//множители к базовым характеристикам
			_koefLevelToAttackSpeed = 0.0;
			_koefLevelToDmgMax = 0.035;
			_koefLevelToDmgMin = 0.037;
			_koefLevelToRange = 0.0;
			_koefLevelToHealth = 0.1;
			
			criticalChance = 7;
			criticalPower = 3.1;
			accuracy = 80;
			updateReferences();
			
			towerMovie = new Swordman_movie_full();
			towerMovie.stop();
			towerMovie.scaleX = 0.85;
			towerMovie.scaleY = 0.85;
			towerMovie.stop();
			(towerMovie.getChildAt(0) as MovieClip).stop();
			
			_descriptionText = "The very elite soldiers. Only the most powerful soldiers could boast an iron sword. Experienced warriors know a lot of different combat hooks causing stable damage and blooding injuries";
			_attackTimer.delay = _attackSpeed;
			
			_skillsArray = [];
			_skillsArray.push(new RealTowerSkill(0, App.skills.sharps));
			_skillsArray.push(new RealTowerSkill(0, App.skills.training));
			_skillsArray.push(new RealTowerSkill(0, App.skills.poisonedEdge));
			_skillsArray.push(new RealTowerSkill(0, App.skills.mortalBlow));
			_skillsArray.push(new RealTowerSkill(0, App.skills.bonebraker));
			_skillsArray.push(new RealTowerSkill(0, App.skills.perfectEye));
			_skillsArray.push(new RealTowerSkill(0, App.skills.bodybuilding));
			_skillsArray.push(new RealTowerSkill(0, App.skills.bladeMastery));
			calculateSkills();
			addChild(towerMovie);
		}
		
		override protected function onShoot(e:Event):void 
		{
			super.onShoot(e);
			if (_curEnemyToAttack != null)
			{
				_curEnemyToAttack.enemyTakingDamage(this);
				App.soundControl.playSound("hit_sword");
			}
		}
		
		override public function destroy():void 
		{
			super.destroy();
			App.pools.returnPoolObject(NAME, this);
		}
	}

}