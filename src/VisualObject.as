package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author author
	 */
	public class VisualObject extends Sprite
	{
		public static const NAME:String = "VisualObject";
		private var _type:int;
		private var _objectSkin:MovieClip = new objectsIngameMovie();
		
		public function VisualObject()
		{
			_objectSkin.gotoAndStop(10);
			mouseEnabled = false;
			_objectSkin.mouseEnabled = false;
		}
		
		public function Init(type:int, grid:Grid):void
		{
			_objectSkin.gotoAndStop(type);
			
			addChild(_objectSkin);
			_type = type;
			if (_objectSkin.currentLabel == "chest")
			{
				(this.parent as Grid).isChestOwner = true;
				destroy();
				var tmpChest:ChestControl = App.pools.getPoolObject(ChestControl.NAME);
				tmpChest.Init(this.parent as Grid);
				return;
			}
			else if (_objectSkin.currentLabel == "wheat")
			{
				var tmpWheat:WheatControl = App.pools.getPoolObject(WheatControl.NAME);
				tmpWheat.Init(this.parent as Grid);
				destroy();
				return;
			}
			grid.objectsArray.push(this);
		}
		
		public function destroy():void
		{
			removeChild(_objectSkin);
			_type = 0;
			App.pools.returnPoolObject(NAME, this);
		}
		
		public function get type():int { return _type; }	
		
		public function get objectSkin():MovieClip { return _objectSkin; }
		
		public function set objectSkin(value:MovieClip):void 
		{
			_objectSkin = value;
		}
	}

}