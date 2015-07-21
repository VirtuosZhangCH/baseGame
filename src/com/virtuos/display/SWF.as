package com.virtuos.display
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	public class SWF extends EventDispatcher
	{
		private var _swfXML:XML;
		private var _xml:XML;
		private var _configs:Object;
		private var _objs:Array = new Array();
		private var _textures:Object = new Object();
		private var k:int=0;
		
		private var _loader:URLLoader = new URLLoader();
		
		private var _romeCity:Array = new Array();
		
		private var _textureFactory:AltasTextureFactory = new AltasTextureFactory();
		
		private var _beginTime:Number;
		
		private var _hitArea:Boolean;
				
		public function SWF(address:String, hitArea:Boolean = false)
		{
			_hitArea = hitArea;
			_configs={};
			_loader=new URLLoader(new URLRequest(address));
			_loader.addEventListener(Event.COMPLETE,onMainLoaded);
		}
		
		public function get textureFactory():AltasTextureFactory
		{
			return _textureFactory
		}
		
		public function get romeCity():Array
		{
			return _romeCity;
		}

		private function onMainLoaded(event:Event):void
		{
			_loader.removeEventListener(Event.COMPLETE,onMainLoaded);
			_xml=new XML(_loader.data);
			_configs["movieclip"]=_xml;
			loadConfig();
		}
		
		private function loadConfig():void
		{
			_loader=new URLLoader(new URLRequest(_configs["movieclip"].attribute("path")));
			_loader.addEventListener(Event.COMPLETE,onBitmapLoaded);
		}
		
		private function onBitmapLoaded(event:Event):void
		{
			
			_loader.removeEventListener(Event.COMPLETE,onBitmapLoaded);
			_xml=new XML(_loader.data);
			var item:XML;
			var name:String;
			for(var i:int = 0; i < _xml.children().length(); i++)
			{
				item = _xml.children()[i];
				name = item.attribute("texturePath");
				_objs.push(name);
			}
			
			loadTexture();
		}
		
		private function loadTexture():void
		{
			
			_loader=new URLLoader(new URLRequest(_objs[k]));
			_loader.addEventListener(Event.COMPLETE,onTextureLoaded);
		}
		
		private function onTextureLoaded(event:Event):void
		{
			
			_loader.removeEventListener(Event.COMPLETE,onTextureLoaded);
			_xml=new XML(_loader.data);
			_textures[_objs[k]] = _xml;			//TODO: We may need a new table for texture which include texture id and texture path mapping. Currently we use texture path as the id 
			k++
			if(k<_objs.length)
			{
				dispatchEvent(new DisplayObjectEvent(DisplayObjectEvent.SWF_LOAD_PROGRESS, k / _objs.length));
				loadTexture();
			}
			else
			{
				dispatchEvent(new DisplayObjectEvent(DisplayObjectEvent.SWF_LOAD_PROGRESS, k / _objs.length));
				_xml=null;
				_objs=null;
				_swfXML=_configs["movieclip"];
				init();
			}
		}
		
		private function init():void
		{
			_beginTime = getTimer();
			initXML();
			initLibrary();
		}
		
		private function initXML():void
		{
			_textureFactory.digestXML(_textures);
			_configs=null;
			_textures=null;
			_textureFactory.addEventListener(Event.COMPLETE, _textureFactoryComplete);
		}
		
		private function initLibrary():void
		{
//			var tt=getTimer()
			for (var i:int = 0; i < _swfXML.children().length(); ++i)
			{
				_romeCity[_swfXML.children()[i].attribute("name").toString()] = _swfXML.children()[i];
			}
//			trace("initLibrary: ", getTimer() - tt,":",tt);
		}
		
		public function getMCPrototype(name:String):XML
		{
			return _romeCity[name];
		}
		
		private function _textureFactoryComplete(event:Event):void
		{
			_textureFactory.removeEventListener(Event.COMPLETE, _textureFactoryComplete);
			dispatchEvent(new Event(Event.COMPLETE));
			trace("init Time: ", getTimer() - _beginTime);
		}
		
		// If don't have instance return null
		public function getMCInstance(name:String):*
		{
			var mcXML:XML = _romeCity[name];
			var movieClip:MovieClip = new MovieClip();
			movieClip.setData(this, mcXML, _textureFactory);
			return movieClip;
		}
	}
}