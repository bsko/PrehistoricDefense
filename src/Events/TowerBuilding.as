package Events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author i am
	 */
	public class TowerBuilding extends Event 
	{
		public static const BUILDING_TOWER:String = "buildingtower";
		
		private var _tower:TowerData;
		private var _deleteData:Boolean = false;
		
		public function TowerBuilding(type:String, bubbles:Boolean = false, cancelable:Boolean = false, towerToBuild:TowerData = null, dataToDelete:Boolean = false) 
		{ 
			super(type, bubbles, cancelable);
			_tower = towerToBuild;
			_deleteData = dataToDelete;
		} 
		
		public override function clone():Event 
		{ 
			return new TowerBuilding(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("TowerBuilding", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get tower():TowerData { return _tower; }
		
		public function set tower(value:TowerData):void 
		{
			_tower = value;
		}
		
		public function get deleteData():Boolean { return _deleteData; }
		
		public function set deleteData(value:Boolean):void 
		{
			_deleteData = value;
		}
		
	}
	
}