package com.virtuos.debug
{
	public class Debug
	{
		private static var _device:Device = new Console();
		
		public static function WARN(info:String):void
		{
			_device.warn(info);
		}
		
		public static function Error(info:String):void
		{
			_device.error(info);
		}
		
		public static function Log(info:String):void
		{
			_device.log(info);
		}
		
	}
}