package com.virtuos.debug
{
	public class Console implements Device
	{
		public function error(info:String):void
		{
			trace("ERROR:", info);
		}

		public function warn(info:String):void
		{
			trace("WARN:", info);
		}

		public function log(info:String):void
		{
			trace("LOG:", info);
		}
		
	}
}