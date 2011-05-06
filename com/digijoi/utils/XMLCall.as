package com.digijoi.utils {
   
  public class XMLCall {
    
    private var _xml:String;

    public function XMLCall(pobj:Object) {
             
      var xmlString:String = '<?xml version="1.0"?>';
      xmlString += '<message library="' + pobj.library + '">';
      xmlString += '<call ';

      // Create Attributes on this Node
      for(var prop in pobj) {
        if (prop != 'library') {
          xmlString += prop + '="' + pobj[prop] + '" ';
        }
      }
      xmlString += '>';
      xmlString += '</call>';
      xmlString += '</message>';

      _xml = xmlString;
    }
    
    public function get xml():String {
      return _xml;
    }
  }
}
