package com.virtuos.display
{
	import com.virtuos.debug.Debug;

	public class SWFInventory
	{
		private static var _instance:SWFInventory;
		
		private var _library:Array;
		
		public function SWFInventory()
		{
			_library = new Array();
		}
		
		public static function getInstance():SWFInventory
		{
			if (_instance == null)
				_instance = new SWFInventory();
			return _instance;
		}
		
		public function addSWF(name:String, swf:SWF):void
		{
			if (_library[name] == null)
				_library[name] = swf;
			else
				Debug.Error("SWFInventory::addSWF: a new swf try to overwrite a latter swf");
		}
		
		public function removeSWF(name:String):void
		{
			_library[name] = null;
		}
		
		public function getSWF(name:String):SWF
		{
			if (null == _library[name])
				Debug.WARN("SWFInventory::getSWF: ordered swf is null, so return null");
			return _library[name];
		}
		
	}
}