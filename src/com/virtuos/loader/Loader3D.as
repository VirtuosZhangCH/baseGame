package com.virtuos.loader
{
	import com.virtuos.display.DisplayObjectEvent;
	import com.virtuos.display.SWF;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getTimer;

	public class Loader3D extends EventDispatcher
	{
		private static const MAIN_FILE:String = "Assets/main3D.xml";
		private static const IGNORE_PROTOTYPE_NAME:Array = ["0", ""];
		
		private static var _instance:Loader3D;
		
		private var _loader:URLLoader;
		private var _loadCount:int = 0;
		private var _progress:Number = 0;
		private var _mainXML:XML;
		private var _resourceLibrary:Array = new Array();
		private var _loadIndex:int = 0;
		private var _configs:Object = {};
		
		private var _resourceLoaded:Boolean = false;

		public function Loader3D()
		{
			_loader = new URLLoader();
			_instance=this;
		}
		
		public function get loadCount():int
		{
			return _loadCount;
		}

		public static function getInstance():Loader3D
		{
			if (!_instance)
				_instance = new Loader3D();
			return _instance;
		}
				
		public function load():void
		{
			_loader.addEventListener(Event.COMPLETE, mainLoadComplete);
			_loader.load(new URLRequest(MAIN_FILE));
		}
		
		private function mainLoadComplete(e:Event):void
		{
			_loader.removeEventListener(Event.COMPLETE, mainLoadComplete);
			_mainXML = new XML(_loader.data);
			_loadCount = _mainXML.children().length();
			_loader.close();
			_loader = null;
			loadResources();
		}
		
		public function loadResources():void
		{
			if (_loadIndex >= _loadCount)
			{
				_resourceLoaded = true;
				dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			
			var node:XML = _mainXML.children()[_loadIndex];
			var name:String = node.attribute("name");
			var path:String = node.attribute("path");
			
			var beginTime:int = getTimer();
			var swf:SWF = new SWF(path);
			swf.addEventListener(DisplayObjectEvent.SWF_LOAD_PROGRESS, swfLoadProgress);
			swf.addEventListener(Event.COMPLETE, swfLoadComplete);
			
			function swfLoadComplete(e:Event):void
			{
				trace("Loading time: ", getTimer() - beginTime);
				_resourceLibrary[name] = swf;
				swf.removeEventListener(DisplayObjectEvent.SWF_LOAD_PROGRESS, swfLoadProgress);
				swf.removeEventListener(Event.COMPLETE, swfLoadComplete);
				dispatchEvent(new Event("progress"));
				_progress = (_loadIndex + 1) / _loadCount;
				_loadIndex++;
				loadResources();
			}
		}
		
		private function swfLoadProgress(e:DisplayObjectEvent):void
		{
			_progress = ((_loadIndex + 1) / _loadCount) * (e.data as Number);
			dispatchEvent(new DisplayObjectEvent(DisplayObjectEvent.SWF_LOAD_PROGRESS, _progress));
		}
		
		public function get progress():Number
		{
			return _progress;
		}
		
		public function getConfig(name:String):Object
		{
			return _configs[name];
		}
		
		public function get resourceLibrary():Array
		{
			if (!_resourceLoaded)
				trace("SERIOUS ERROR: 3D Resources has not been loaded!");
			return _resourceLibrary;
		}

	}
}