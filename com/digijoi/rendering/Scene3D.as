﻿package com.digijoi.rendering {
  
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import com.digijoi.rendering.Light;
  import com.digijoi.rendering.Word3D;
  
  import flash.filters.BlurFilter;
  
  public class Scene3D extends Sprite {
    
    private var _vpx:Number = 0;
    private var _vpy:Number = 0;
    private var _cx:Number = 0;
    private var _cy:Number = 0;
    private var _cz:Number = 0;
    private var _dx:Number = 0;
    private var _dy:Number = 0;
    private var _dz:Number = 0;
    private var _ax:Number = 0;
    private var _ay:Number = 0;
    private var _az:Number = 0;
    private var _light:Light;
    private var _renderList:Array;
    private var _ready:Boolean;
    
    private var _vy:Number = -5;
    
    private var _blur:BlurFilter;
    
    public function Scene3D(pX:Number, pY:Number) {
      this.x = pX;
      this.y = pY;
      _light = new Light();
      _renderList = [];
      _ready = false;
      _blur = new BlurFilter(0, 0, 3);
      this.initializeRendering();
    }
    
    public function addToRenderList(... targets):void {
      for(var i:uint = 0; i < targets.length; i++) {
        targets[i].graphics = this.graphics;
        targets[i].light = _light;
        targets[i].setVp(_vpx, _vpy);
        targets[i].setCp(_cx, _cy, _cz);
        _renderList.push(targets[i]);
      }
    }
    
    public function setVp(vpx:Number, vpy:Number):void {
      _vpx = vpx;
      _vpy = vpy;
      for(var i:uint = 0; i < _renderList.length; i++) {
        _renderList[i].setVp(_vpx, _vpy);
      }
    }
    
    public function setCp(cx:Number, cy:Number, cz:Number):void {
      _cx = cx;
      _cy = cy;
      _cz = cz;
      for(var i:uint = 0; i < _renderList.length; i++) {
        _renderList[i].setCp(_cx, _cy, _cz);
      }
    }
    
    public function initializeRendering():void {
      this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }
    
    public function cancelRendering():void {
      this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }

    private function enterFrameHandler(event:Event):void {
      //_dy += _vy;
      //_vy += .1;
      var b:Number = Math.abs(_renderList[0].depth)/10;
      _blur.blurX = _blur.blurY = b;
      var fa:Array = [];
      fa.push(_blur);
      this.filters = fa;
      _ay = (mouseX)/4000;
      _ax = (mouseY)/4000;
      //_renderList[0].a = Math.sqrt(mouseX*mouseX + mouseY*mouseY)/100;
      this.update();
      this.render();
      
    }
    
    private function update():void {
      _renderList.sortOn("depth", Array.DESCENDING | Array.NUMERIC);
      for(var k:uint = 0; k < _renderList.length; k++) {
        _renderList[k].setVp(_vpx, _vpy);
        _renderList[k].setCp(_cx, _cy, _cz);
        _renderList[k].update({dx:_dx, dy:_dy, dz:_dz, ax:_ax, ay:_ay, az:_az});
      }
    }
    
    private function render():void {
      this.graphics.clear();
      for(var i:uint = 0; i < _renderList.length; i++) {
        _renderList[i].render();
      }
    }
    
    public function set vpx(value:Number):void {_vpx = value;}
    public function set vpy(value:Number):void {_vpy = value;}
    public function set cx(value:Number):void {_cx = value;}
    public function set cy(value:Number):void {_cy = value;}
    public function set cz(value:Number):void {_cz = value;}
    public function set dx(value:Number):void {_dx = value;}
    public function set dy(value:Number):void {_dy = value;}
    public function set dz(value:Number):void {_dz = value;}
    public function set ax(value:Number):void {_ax = value;}
    public function set ay(value:Number):void {_ay = value;}
    public function set az(value:Number):void {_az = value;}
    
    public function set ready(b:Boolean):void {
      _ready = b;
      for(var i:uint = 0; i < _renderList.length; i++) {
        _renderList[i].ready = _ready;
      }
    }
    
    public function get vpx():Number {return _vpx;}
    public function get vpy():Number {return _vpy;}
    public function get cx():Number {return _cx;}
    public function get cy():Number {return _cy;}
    public function get cz():Number {return _cz;}
    public function get dx():Number {return _dx;}
    public function get dy():Number {return _dy;}
    public function get dz():Number {return _dz;}
    public function get ax():Number {return _ax;}
    public function get ay():Number {return _ay;}
    public function get az():Number {return _az;}
    
    public function get ready():Boolean {return _ready;}
    
    public function reSize(w:Number, h:Number):void {
      for(var i:uint = 0; i < _renderList.length; i++) {
        _renderList[i].reSize(w, h);
      }
    }
  }
}
