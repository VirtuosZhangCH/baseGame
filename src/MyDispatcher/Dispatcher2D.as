package MyDispatcher
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class Dispatcher2D extends EventDispatcher
	{
		
		public function Dispatcher2D(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}