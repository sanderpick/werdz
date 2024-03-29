﻿package com.digijoi.utils {
  
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  import flash.net.URLRequestMethod;
  import flash.net.URLVariables;
  import flash.net.URLLoaderDataFormat;
  import flash.events.Event;
    import flash.events.EventDispatcher;
  import com.digijoi.connectivity.Settings;
  import com.digijoi.utils.XMLCall;
  import com.digijoi.events.XMLEvent;
  
  public class WordPress {
    
    private static const _url:String = Settings.SERVER_PATH;
    private static var _dispatcher:EventDispatcher = new EventDispatcher();
    
    public static function getAllComments(startPos:String, number:String):void {
      var callObj:Object = new Object();
      callObj.callFunction = 'getAllComments';
      callObj.startPos = startPos;
      callObj.number = number;
      callObj.library = 'pressConnect';
      makeCall(callObj, completeHandler);
    }
//–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    private static function makeCall(callObj:Object, handler:Function) {
      var caller:XMLCall = new XMLCall(callObj);  
      var variables:URLVariables = new URLVariables();
      var request:URLRequest = new URLRequest();
      var loader:URLLoader = new URLLoader();
      variables.myXML = caller.xml;
      request.url = _url;
      request.method = URLRequestMethod.POST;
      request.data = variables;
      loader.dataFormat = URLLoaderDataFormat.TEXT;
      loader.addEventListener(Event.COMPLETE, handler);
      loader.load(request);
    }
//–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––    
    
    private static function completeHandler(event:Event):void {
      event.target.removeEventListener(Event.COMPLETE, completeHandler);
      _dispatcher.dispatchEvent(new XMLEvent(XMLEvent.COMPLETE, new XMLList(XML(unescape(event.target.data).replace(/\+/g, " ")))));
    }
//–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––  
    
    public static function addEventListener(type:String, listener:Function):void {
            _dispatcher.addEventListener(type, listener, false, 0, false);
        }    
    
    public static function removeEventListener(type:String, listener:Function):void {
            _dispatcher.removeEventListener(type, listener, false);
        }  
  }
}
