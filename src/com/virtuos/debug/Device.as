package com.virtuos.debug
{
	public interface Device
	{
		function error(info:String):void;
		function warn (info:String):void;
		function log  (info:String):void;
	}
}