package Towers 
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author author
	 */
	public class ArcherTwr extends Tower
	{
		public static const NAME:String = "ArcherTwr";
		private var _meleeAttacks:Array = [];
		private var _rangeAttacks:Array = [];
		private var bulletType:int = Bullet.ARROW;
		
		public function ArcherTwr() 
		{
			//базовые характеристики
			_baseAttackRange = 200;
			_baseAttackSpeed = 2000;
			_baseDamageMin = 30;
			_baseDamageMax = 38;
			_baseGoldCost = TowerData.baseGoldCostsArray[8];
			_baseWheatCost = TowerData.baseWhealCostsArray[8];
			_baseHealth = 100;
			type = NAME;
			_damageType = DamageTypes.PIKE;
			isAirKiller = true;
			
			//множители к базовым характеристикам
			_koefLevelToAttackSpeed = 0.0;
			_koefLevelToDmgMax = 0.021;
			_koefLevelToDmgMin = 0.031;
			_koefLevelToRange = 0.005;
			_koefLevelToHealth = 0.1;
			
			criticalChance = 10;
			criticalPower = 2.8;
			accuracy = 73;
			updateReferences();
			
			towerMovie = new Archerman_movie_full();
			towerMovie.stop();
			towerMovie.scaleX = 0.85;
			towerMovie.scaleY = 0.85;
			
			towerMovie.stop();
			(towerMovie.getChildAt(0) as MovieClip).stop();
			
			_descriptionText = "Elite riflemen armed with a bow and iron point spears. They are not able to shoot in close combat, that’s why they use a dagger but this is compensated by serious damage in distance";
			_attackTimer.delay = _attackSpeed;
			
			_skillsArray = [];
			_skillsArray.push(new RealTowerSkill(0, App.skills.piercingShot));
			_skillsArray.push(new RealTowerSkill(0, App.skills.criticalStrike));
			_skillsArray.push(new RealTowerSkill(0, App.skills.accuracy));
			_skillsArray.push(new RealTowerSkill(0, App.skills.magicPower));
			_skillsArray.push(new RealTowerSkill(0, App.skills.longWeapons));
			_skillsArray.push(new RealTowerSkill(0, App.skills.huntersBow));
			_skillsArray.push(new RealTowerSkill(0, App.skills.bleedingStrike));
			_skillsArray.push(new RealTowerSkill(0, App.skills.steelArrows));
			calculateSkills();
			addChild(towerMovie);
		}
		
		override protected function searchForLabels():void
		{
			var tmpPosa:MovieClip = towerMovie.getChildAt(0) as MovieClip;
			var numLabels:int = tmpPosa.currentLabels.length;
			for (var i:int = 0; i < numLabels; i++)
			{
				var tmpLabel:String = tmpPosa.currentLabels[i].name;
				if (tmpLabel.charAt(0) == "m")
				{
					_meleeAttacks.push(tmpLabel);
				}
				else if (tmpLabel.charAt(0) == "s")
				{
					_rangeAttacks.push(tmpLabel);
				}
			}
		}
		
		override public function destroy():void 
		{
			super.destroy();
			_meleeAttacks.length = 0;
			_rangeAttacks.length = 0;
			App.pools.returnPoolObject(NAME, this);
		}
		
		override protected function shootTo():void
		{
			var angle:int = App.angleFinding(new Point(_currentCell.x, _currentCell.y), new Point(_curEnemyToAttack.x, _curEnemyToAttack.y)) % 360;
			var quarter:int = angle / 90;
			switch(quarter)
			{
				case 0:
				towerMovie.gotoAndStop("right_up");
				break;
				case 1:
				towerMovie.gotoAndStop("right_down");
				break;
				case 2:
				towerMovie.gotoAndStop("left_down");
				break;
				case 3:
				towerMovie.gotoAndStop("left_up");
				break;
			}
			var tmpPosa:MovieClip = towerMovie.getChildAt(0) as MovieClip;
			if (distance >= App.MIN_RNG)
			{
				var numLabels:int = _rangeAttacks.length;
				if (numLabels > 0)
				{
					var rndAttackType:int = App.randomInt(0, numLabels);
					tmpPosa.gotoAndPlay(_rangeAttacks[rndAttackType]);
					towerMovie.addEventListener("shoot", onShoot, false, 0, true);
					App.soundControl.playSound("arrow_shooting");
				}
			}
			else if (distance < App.MIN_RNG)
			{
				numLabels = _meleeAttacks.length;
				if (numLabels > 0)
				{
					rndAttackType = App.randomInt(0, numLabels);
					tmpPosa.gotoAndPlay(_meleeAttacks[rndAttackType]);
					_curEnemyToAttack.enemyTakingDamage(this, true);
				}
			}
		}
		
		override protected function onShoot(e:Event):void 
		{
			super.onShoot(e);
			if (_curEnemyToAttack != null)
			{
				var tmpBullet:Bullet = App.pools.getPoolObject(Bullet.NAME);
				tmpBullet.Init(bulletType, this, _curEnemyToAttack, false);
			}
		}
	}

}