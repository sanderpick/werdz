﻿package com.digijoi.rendering {
  
  public class Point3D {
    
    private var _fl:Number = 1000;
    private var _vpx:Number = 0;
    private var _vpy:Number = 0;
    private var _cx:Number = 0;
    private var _cy:Number = 0;
    private var _cz:Number = 0;
    private var _x:Number = 0;
    private var _y:Number = 0;
    private var _z:Number = 0;
    
    public function Point3D(pX:Number=0, pY:Number=0, pZ:Number=0) {
      _x = pX;
      _y = pY;
      _z = pZ;
    }
    
    public function setVanishingPoint(vpx:Number, vpy:Number):void {
      _vpx = vpx;
      _vpy = vpy;
    }
    
    public function setCenter(cx:Number, cy:Number, cz:Number=0):void {
      _cx = cx;
      _cy  = cy;
      _cz = cz;
    }
    
    public function get screenX():Number {
      var scale:Number = _fl / (_fl + _z + _cz);
      return (_vpx + (_cx + _x) * scale);//+2*Math.cos(_x);
    }
    
    public function get screenY():Number {
      var scale:Number = _fl / (_fl + _z + _cz);
      return (_vpy + (_cy + _y) * scale);//+2*Math.sin(_y);
    }
    
    public function rotateX(angleX:Number):void {
      var cosX:Number = Math.cos(angleX);
      var sinX:Number = Math.sin(angleX);
      
      var y1:Number = _y * cosX - _z * sinX;
      var z1:Number = _z * cosX + _y * sinX;
      
      _y = y1;
      _z = z1;
    }
    
    public function rotateY(angleY:Number):void {
      var cosY:Number = Math.cos(angleY);
      var sinY:Number = Math.sin(angleY);
      
      var x1:Number = _x * cosY - _z * sinY;
      var z1:Number = _z * cosY + _x * sinY;
      
      _x = x1;
      _z = z1;
    }
    
    public function rotateZ(angleZ:Number):void {
      var cosZ:Number = Math.cos(angleZ);
      var sinZ:Number = Math.sin(angleZ);
      
      var x1:Number = _x * cosZ - _y * sinZ;
      var y1:Number = _y * cosZ + _x * sinZ;
      
      _x = x1;
      _y = y1;
    }
    
    public function set fl(v:Number):void {_fl = v;}
    public function set x(v:Number):void {_x = v;}
    public function set y(v:Number):void {_y = v;}
    public function set z(v:Number):void {_z = v;}
    public function get x():Number {return _x;}
    public function get y():Number {return _y;}
    public function get z():Number {return _z;}
  }
}
