package  
{
	/**
	 * ...
	 * @author iam
	 */
	public class MonsterNames 
	{
		
		public static const BLUEDINO:Array = ["Child Dino", "Weak Dino", "Angry Dino", "Dino Fighter", "Dino Monster"];
		public static const DINOZAVR_ORANGE:Array = ["Child Dino", "Weak Dino", "Angry Dino", "Dino Fighter", "Dino Monster"];
		public static const DOUBLELEGGED:Array = ["Child Dino", "Weak Dino", "Angry Dino", "Dino Fighter", "Dino Monster"];
		public static const FLYING:Array = ["Child Dino", "Weak Dino", "Angry Dino", "Dino Fighter", "Dino Monster"];
		public static const FROG:Array = ["Child Dino", "Weak Dino", "Angry Dino", "Dino Fighter", "Dino Monster"];
		public static const KABAN:Array = ["Child Dino", "Weak Dino", "Angry Dino", "Dino Fighter", "Dino Monster"];
		public static const RAT:Array = ["Child Dino", "Weak Dino", "Angry Dino", "Dino Fighter", "Dino Monster"];
		public static const SABERTOOTH:Array = ["Child Dino", "Weak Dino", "Angry Dino", "Dino Fighter", "Dino Monster"];
		public static const SPIDER:Array = ["Child Dino", "Weak Dino", "Angry Dino", "Dino Fighter", "Dino Monster"];
		public static const THORNER:Array = ["Child Dino", "Weak Dino", "Angry Dino", "Dino Fighter", "Dino Monster"];
		public static const TIGER:Array = ["Child Dino", "Weak Dino", "Angry Dino", "Dino Fighter", "Dino Monster"];
		public static const WHITETIGER:Array = ["Child Dino", "Weak Dino", "Angry Dino", "Dino Fighter", "Dino Monster"];
		public static const ZLOBNIYGLIST:Array = ["Child Dino", "Weak Dino", "Angry Dino", "Dino Fighter", "Dino Monster"];
		
		public static var BlueDino_Iterator:int = 0;
		public static var DinozavrOrange_Iterator:int = 0;
		public static var Doublelegged_Iterator:int = 0;
		public static var Flying_Iterator:int = 0;
		public static var Frog_Iterator:int = 0;
		public static var Kaban_Iterator:int = 0;
		public static var Rat_Iterator:int = 0;
		public static var SaberTooth_Iterator:int = 0;
		public static var Spider_Iterator:int = 0;
		public static var Thorner_Iterator:int = 0;
		public static var Tiger_Iterator:int = 0;
		public static var WhiteTiger_Iterator:int = 0;
		public static var ZlobniyGlist_Iterator:int = 0;
		
		public static function ReInit():void
		{
			BlueDino_Iterator = 0;
			DinozavrOrange_Iterator = 0;
			Doublelegged_Iterator = 0;
			Flying_Iterator = 0;
			Frog_Iterator = 0;
			Kaban_Iterator = 0;
			Rat_Iterator = 0;
			SaberTooth_Iterator = 0;
			Spider_Iterator = 0;
			Thorner_Iterator = 0;
			Tiger_Iterator = 0;
			WhiteTiger_Iterator = 0;
			ZlobniyGlist_Iterator = 0;
		}
		
		public static function SetStartIndex(index:int):void
		{
			BlueDino_Iterator = index;
			DinozavrOrange_Iterator = index;
			Flying_Iterator = index;
			Frog_Iterator = index;
			Kaban_Iterator = index;
			Rat_Iterator = index;
			SaberTooth_Iterator = index;
			Spider_Iterator = index;
			Thorner_Iterator = index;
			Tiger_Iterator = index;
			WhiteTiger_Iterator = index;
			ZlobniyGlist_Iterator = index;
		}
	}

}