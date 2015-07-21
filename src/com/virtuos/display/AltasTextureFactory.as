package com.virtuos.display
{	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.system.System;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class AltasTextureFactory extends EventDispatcher
	{
		private var _loader:Loader;
		private var _k:int=0;
		private var _texturesAll:Object=new Object();
		private var _textrues:Array=new Array();
		//
		private var textrueAtlasArr:Object=new Object();
		private var textureArr:Vector.<Texture>=new Vector.<Texture>();
		
		private var textureAtlas:TextureAtlas
		private var texture:Texture
		private var _bitmap:Bitmap
		
		public function digestXML(textrues:Object):void
		{
			for (var key:String in textrues)
			{
				_textrues.push({path:key, data:textrues[key]});
			}

			loadTexture();
		}
		
		private function loadTexture():void
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, textureLoaded);
			_loader.load(new URLRequest(_textrues[_k]["data"].attribute("imagePath")));
		}
		
		private function textureLoaded(event:Event):void
		{
			trace("Current Memory1: ", System.privateMemory * 0.000000954);
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, textureLoaded);
			_bitmap = _loader.content as Bitmap;
			_loader.unloadAndStop();
			System.gc();
			texture = Texture.fromBitmap(_bitmap, false);
			
			trace("Current Memory2: ", System.privateMemory * 0.000000954);
			_bitmap.bitmapData.dispose();
			_bitmap=null;
			System.gc();
			trace("Current Memory3: ", System.privateMemory * 0.000000954);
			textureAtlas=null;
			textureAtlas = new TextureAtlas(texture, _textrues[_k]["data"]);
			textrueAtlasArr[_textrues[_k]["data"].attribute("imagePath")]=textureAtlas;
			textureArr.push(texture);
			trace("Current Memory4: ", System.privateMemory * 0.000000954);
			for (var i:uint = 0; i < _textrues[_k]["data"].children().length(); i++)
			{
				var item:XML = _textrues[_k]["data"].children()[i];
				var name:String = item.attribute("name");
				_texturesAll[name]=textureAtlas.getTexture(name);
			}
			_k++;
			texture=null;
			_loader=null;
			if(_k<_textrues.length)
				loadTexture();
			else
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
			System.gc();
		}
		
		public function getTexture(name:String):Texture
		{
			return _texturesAll[name];
		}

		public function destroy(_complete:Boolean=false):void
		{
			for(var key:String in textrueAtlasArr)
			{
				(textrueAtlasArr[key] as TextureAtlas).dispose();
			}
			for(var i:int=0;i<textureArr.length;++i)
			{
				textureArr[i].dispose();
			}
			textureArr=null;
			_textrues=null;
			textrueAtlasArr=null;
			_texturesAll=null;
		}
		
	}
}