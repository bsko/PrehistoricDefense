package  
{
	import Events.UniverseDestroying;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author 
	 */
	public class ChestControl extends Sprite
	{
		public static const NAME:String = "ChestControl";	
		
		public static const BONUS_MONEY:int = 101;
		public static const BONUS_DIAMNDS:int = 102;
		public static const BONUS_NOTHING:int = 103;
		
		private var _chest_movie:MovieClip = new BonusChest();
		private var _hit_area:MovieClip = new chestHitArea();
		private var _cellOwner:Grid;
		private var _bonus:int;
		private var _isOpening:Boolean = false;
		
		public function ChestControl()
		{
			_chest_movie.gotoAndStop(1);
		}
		
		public function Init(grid:Grid):void 
		{
			addChild(chest_movie);
			_hit_area.alpha = 0;
			addChild(_hit_area);
			_isOpening = false;
			_hit_area.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverChest, false, 0, true);
			_hit_area.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutChest, false, 0, true);
			_hit_area.addEventListener(MouseEvent.CLICK, onMouseClickedChest, false, 0, true);
			_cellOwner = grid;
			this.x = 0;
			this.y = - _cellOwner.gridHeight - App.HEIGHT_DELAY;
			grid.addChild(this);
			App.universe.addEventListener(UniverseDestroying.DESTROYING, onDestroyChest, false, 0, true);
		}
		
		private function onMouseClickedChest(e:MouseEvent):void 
		{
			OpenChest();
		}
		
		private function onMouseOutChest(e:MouseEvent):void 
		{
			if (!_isOpening)
			{
				_chest_movie.gotoAndStop(1);
			}
		}
		
		private function onMouseOverChest(e:MouseEvent):void 
		{
			if (!_isOpening)
			{
				_chest_movie.gotoAndStop("jumping");
			}
		}
		
		private function OpenChest():void 
		{
			if (App.universe.keysCount > 0)
			{
				_isOpening = true;
				var randomVar:int = App.randomInt(2, 5);
				chest_movie.gotoAndStop(randomVar);
				switch(randomVar)
				{
					case 2:
					_bonus = BONUS_MONEY;
					App.soundControl.playSound("open_chest_money");
					break;
					case 3:
					_bonus = BONUS_DIAMNDS;
					App.soundControl.playSound("open_chest_crystal");
					break;
					default:
					_bonus = BONUS_NOTHING;
					App.soundControl.playSound("open_chest_nothing");
					break;
				}
				chest_movie.box.gotoAndPlay(1);
				App.universe.keysCount--;
				chest_movie.box.addEventListener("chest_opened", onRewardGiving, false, 0, true);
			}
		}
		
		private function onDestroyChest(e:UniverseDestroying):void 
		{
			if (_isOpening)
			{
				chest_movie.box.removeEventListener("chest_opened", onRewardGiving, false);
			}
			Destroy();
		}
		
		private function onRewardGiving(e:Event):void 
		{
			switch(_bonus)
			{
				case BONUS_MONEY:
				App.currentPlayer.gold += 150;
				break;
				case BONUS_DIAMNDS:
				App.currentPlayer.money += 50;
				break;
				case BONUS_NOTHING:
				break;
			}
			
			Destroy();
		}
		
		public function Destroy():void 
		{
			App.universe.removeEventListener(UniverseDestroying.DESTROYING, onDestroyChest, false);
			_isOpening = false;
			_hit_area.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOverChest, false);
			_hit_area.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutChest, false);
			_hit_area.removeEventListener(MouseEvent.CLICK, onMouseClickedChest, false);
			removeChild(chest_movie);
			_cellOwner.removeChild(this);
			App.pools.returnPoolObject(NAME, this);
		}
		
		public function get chest_movie():MovieClip { return _chest_movie; }
		
		public function set chest_movie(value:MovieClip):void 
		{
			_chest_movie = value;
		}
	}
}