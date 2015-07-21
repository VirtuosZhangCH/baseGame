package MyEvent
{
	import flash.events.Event;
	
	public class My2DEvents extends Event
	{
		public static const RESTART:String="restart";
		public function My2DEvents(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}