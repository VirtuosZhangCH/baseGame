package MyEvent
{
	import starling.events.Event;
	
	public class EnemyEvents extends Event
	{
		//public static const ENEMY_DIE:String="enemydie";
		public static const REMOVE_ENEMY:String="removeenemy";
		public var _tempObj:*;
		public function EnemyEvents(type:String,_obj:*, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type,_obj);
			_tempObj=_obj;
		}
	}
}