﻿package com.digijoi.rendering {
  
  public class Light {
    private var _x:Number;
    private var _y:Number;
    private var _z:Number;
    private var _brightness:Number;
    
    public function Light(pX:Number=0, pY:Number=-1000, pZ:Number=-1000, pB:Number=1) {
      _x = pX;
      _y = pY;
      _z = pZ;
      this.brightness = pB;
    }
    
    public function set brightness(b:Number):void {
      _brightness = Math.max(b, 0);
      _brightness = Math.min(_brightness, 1);
    }
    
    public function get brightness():Number {return _brightness}
    public function set x(v:Number):void {_x = v;}
    public function set y(v:Number):void {_y = v;}
    public function set z(v:Number):void {_z = v;}
    public function get x():Number {return _x;}
    public function get y():Number {return _y;}
    public function get z():Number {return _z;}
  }
}
