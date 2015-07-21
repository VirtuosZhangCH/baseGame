package MyEvent
{
	
	import starling.events.Event
	public class MyEvents extends Event
	{
		public static const MOVE:String="move";
		public static const MAP_MOVE:String="mapmove";
		/**
		 * player animation
		 * */
		public static const FEED:String="feed";
		public static const DIE:String="die";
		public static const RESTART_GAME:String="restartgame";
		public static const CONFIG_GAME:String="configGame";
		public static const CONFIG_CHARACTER:String="configcharacter";
		public static const SET_POSTION:String="setpostion";
		public static const CHANGE_POINT:String="changepoint";
		
		public var _tempObj:*;
		public function MyEvents(type:String,_obj:*, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type,_obj);
			_tempObj=_obj;
		}
	}
}