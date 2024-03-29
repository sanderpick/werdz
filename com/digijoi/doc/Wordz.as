﻿package com.digijoi.doc {
  
  //IMPORTS//
  import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.display.StageDisplayState;
  import flash.events.Event;
  import com.digijoi.events.XMLEvent;
  import flash.system.Capabilities;
  import flash.system.Security;
  import com.digijoi.rendering.Word3D;
  import com.digijoi.rendering.Scene3D;
  import com.digijoi.utils.WordPress;
  
  import gs.TweenLite;
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––//
  //CLASS DECLARATION//
  public class Wordz extends Sprite {
    
    private var _scene:Scene3D;
    private var _words:Array;
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––//
    //CONSTRUCTOR//
    public function Wordz() {
      Security.loadPolicyFile("http://www.bigupproductions.com/crossdomain.xml");
      this.addEventListener(Event.ADDED_TO_STAGE, addedToDisplayList);
    }
    
    private function addedToDisplayList(event:Event):void {
      stage.align = StageAlign.TOP_LEFT;
      stage.scaleMode = StageScaleMode.NO_SCALE;
      
      this.initData();
    }
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––//
    //INIT 3D//
    private function init3D():void {      
      _scene = new Scene3D(stage.stageWidth/2, stage.stageHeight/2);
      this.addChildAt(_scene, 0);
    }
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––//
    //INIT Data//
    private function initData():void {      
      WordPress.addEventListener(XMLEvent.COMPLETE, gotData);
      WordPress.getAllComments('*', '1');
    }
    
    private function gotData(e:XMLEvent):void {
      var chunk:String = '';
      for(var i:uint = 0; i < e.xml.children().length(); i++) {
        chunk = chunk.concat(e.xml.children()[i].content + ' ');
      }
      _words = chunk.split(' ');
      for(var j:uint = 0; j < _words.length; j++) {
        if(_words[j]!='') {
          var s:Scene3D = new Scene3D((stage.stageWidth/2)+(Math.random()-.5)*1000, (stage.stageHeight/2)+(Math.random()-.5)*800);
          this.addChild(s);
          var w:Word3D = new Word3D(_words[j], Math.random()*20, combineRGB(Math.random()*255, Math.random()*255, Math.random()*255), {dx:1000*(Math.random()-.5), dy:1000*(Math.random()-.5), dz:1000*(Math.random()-.5), ax:(Math.random()-.5)*Math.PI, ay:(Math.random()-.5)*Math.PI, az:(Math.random()-.5)*Math.PI});
          s.addToRenderList(w);
          s.ready = true;
        }
      }
    }
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––//
    //UTIL//
    private function combineRGB(red:Number, green:Number, blue:Number):Number {
      var RGB:Number;

      if(red>255){red=255;}
      if(green>255){green=255;}
      if(blue>255){blue=255;}
      if(red<0){red=0;}
      if(green<0){green=0;}
      if(blue<0){blue=0;}
      RGB=(red<<16) | (green<<8) | blue;
      
      return RGB;
    }
  }
}
