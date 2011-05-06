package com.digijoi.events {
  
  import flash.events.Event;
  
  public class XMLEvent extends Event {
    
    public static const COMPLETE:String = "complete";
    
    private var _xml:XMLList;
    
    public function XMLEvent(pType:String, pXML:XMLList, pBubbles:Boolean=false, pCancelable:Boolean=false) {
      super(pType, pBubbles, pCancelable);
      _xml = pXML;
    }
    
    override public function clone():Event {
      return new XMLEvent(type, _xml, bubbles, cancelable);
    }
    
    public function get xml():XMLList {
      return _xml;
    }
  }
}
