package com.virtuos.display
{
	import flash.events.Event;
	
	public class DisplayObjectEvent extends Event
	{
		private var _data:Object;
		 
		public static const SWF_LOAD_PROGRESS:String = "swfloadprogress";
		public static const SWF_LOAD_COMPLETE:String = "swfloadcomplete";
		
		public function DisplayObjectEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_data = data;
			super(type, bubbles, cancelable);
		}

		public function get data():Object
		{
			return _data;
		}

	}
	
}