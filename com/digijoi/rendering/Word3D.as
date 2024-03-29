﻿package com.digijoi.rendering {
  
  import flash.display.Graphics;
  //import com.digijoi.rendering.ChaletNewYorkNineteenEighty;
  import com.digijoi.rendering.ZagBold;
  import com.digijoi.rendering.Point3D;
  
  public class Word3D {
    
    //ChaletNewYorkNineteenEighty.initialize();
    ZagBold.initialize();
    
    private var _f:Object = ZagBold.__motifs;
    private var _d:Object = ZagBold.__widths;
    private var _t:String;
    private var _g:Graphics;
    private var _vpx:Number;
    private var _vpy:Number;
    private var _cx:Number;
    private var _cy:Number;
    private var _cz:Number;
    private var _s:Number;
    private var _c:uint;
    private var _i:Array;
    private var _p:Array;
    private var _local:Object;
    private var _flip:Boolean;
    private var _pa:Point3D;
    private var _pb:Point3D;
    private var _pc:Point3D;
    private var _light:Light;
    
    private var _a:Number = 1;
    private var _w:Number;
    
    public function Word3D(pText:String, pSize:Number=10, pColor:uint=0xffffff, pLocal:Object=null, pFlip:Boolean=true) {
      _t = pText;
      _s = pSize/10;
      _c = pColor;
      _local = pLocal;
      _flip = pFlip;
      this.buildWord();
    }
    
    public function update(v:Object):void {
      //this.curveMe(_w);
      for(var i:uint = 0; i < _p.length; i++) {
        for(var j:uint = 0; j < _p[i].length; j++) {
          _p[i][j].rotateX(v.ax);
          _p[i][j].rotateY(v.ay);
          _p[i][j].rotateZ(v.az);
          _p[i][j].x += v.dx;
          _p[i][j].y += v.dy;
          _p[i][j].z += v.dz;
        }
      }
    }
    
    public function render():void {
      //if(isBackFace()) return; 
      _g.beginFill(getAdjustedColor());
      //_g.beginFill(_c);
      for(var i:uint = 0; i < _i.length; i++) {
        switch(_i[i]) {
          case 'M' :
            _g.moveTo(_p[i][0].screenX, _p[i][0].screenY);
            break;
          case 'L' :
            _g.lineTo(_p[i][0].screenX, _p[i][0].screenY);
            break;
          case 'C' :
            _g.curveTo(_p[i][0].screenX, _p[i][0].screenY, _p[i][1].screenX, _p[i][1].screenY);
            break;
        }
      }
      _g.endFill();
    }
    
    public function set graphics(g:Graphics):void {_g = g;}
    public function set color(c:uint):void {_c = c;}
    public function set a(v:Number):void {_a = v;}
    
    public function set light(l:Light):void {
      _light = l;
    }
    
    public function setVp(vpx:Number, vpy:Number):void {
      _vpx = vpx;
      _vpy = vpy;
      for(var i:uint = 0; i < _p.length; i++) {
        for(var j:uint = 0; j < _p[i].length; j++) {
          _p[i][j].setVanishingPoint(_vpx, _vpy);
        }
      }
    }
    
    public function setCp(cx:Number, cy:Number, cz:Number):void {
      _cx = cx;
      _cy = cy;
      _cz = cz;
      for(var i:uint = 0; i < _p.length; i++) {
        for(var j:uint = 0; j < _p[i].length; j++) {
          _p[i][j].setCenter(_cx, _cy, _cz);
        }
      }
    }
    
    public function get depth():Number {
      //return (isBackFace()) ? 1 : -1;
      var zpos:Number = Math.min(_pa.z, _pb.z);
      zpos = Math.min(zpos, _pc.z);
      return zpos;
    }
    
    private function isBackFace():Boolean {
      var cax:Number = _pc.screenX - _pa.screenX;
      var cay:Number = _pc.screenY - _pa.screenY;
      var bcx:Number = _pb.screenX - _pc.screenX;
      var bcy:Number = _pb.screenY - _pc.screenY;
      return cax * bcy > cay * bcx;
    }
    
    private function buildWord():void {
      _i = [];
      _p = [];
      _w = 0;
      for(var i:uint = 0; i < _t.length; i++) {
        var ch:Array = (_f[_t.charAt(i)]!=null) ? _f[_t.charAt(i)] : _f['*'];
        for(var j:uint = 0; j < ch.length; j++) {
          _i.push(ch[j][0]);
          var l:Array = [];
          for(var k:uint = 0; k < ch[j][1].length; k+=2) {
            var p:Point3D = new Point3D((ch[j][1][k]+_w)*_s, ch[j][1][k+1]*_s, 0);
            l.push(p);
          }
          _p.push(l);
        }
        _w += _d[_t.charAt(i)];
      }
      
      //this.curveMe(_w);
      
      var oa:Array = [];
      for(var n:uint = 0; n < _i.length; n++) {
        if(_i[n]!='C') oa.push(_p[n][0].y);
      }
      var max:Number = Math.max.apply(null, oa);
      var ox:Number = -_w*_s/2;
      var oy:Number = -max/2;
      this.update({dx:ox, dy:oy, dz:0, ax:0, ay:0, az:0})
      
      if(_local) this.update(_local);
      //trace(_p.length, '*'+_t+'*');
      if(_flip) {
        _pa = _p[_p.length-1][0];
        _pb = _p[Math.floor(_p.length/2)][0];
        _pc = _p[0][0];
      } else {
        _pa = _p[0][0];
        _pb = _p[Math.floor(_p.length/2)][0];
        _pc = _p[_p.length-1][0];
      }
      
      //
      //this.curveMe(_w);
      //
      
    }
    
    private function curveMe(w):void {
      var r:Number = w/(2*Math.PI);
      for(var i:uint = 0; i < _p.length; i++) {
        for(var j:uint = 0; j < _p[i].length; j++) {
          var d:Number = _p[i][j].x;
          _p[i][j].x = _a*r*Math.sin(d/r);
          _p[i][j].z = _a*r*Math.cos(d/r);
        }
      }
    }
    
    private function getAdjustedColor():uint {
      var red:Number = _c >> 16;
      var green:Number = _c >> 8 & 0xff;
      var blue:Number = _c & 0xff;
      
      var lightFactor:Number = getLightFactor();
      lightFactor = Math.pow(lightFactor, 3);
      lightFactor = 1-lightFactor;
      red *= lightFactor;
      green *= lightFactor;
      blue *= lightFactor;
      
      return red << 16 | green << 8 | blue;
    }
    
    private function getLightFactor():Number {
      var ab:Object = new Object();
      ab.x = _pa.x - _pb.x;
      ab.y = _pa.y - _pb.y;
      ab.z = _pa.z - _pb.z;
      
      var bc:Object = new Object();
      bc.x = _pb.x - _pc.x;
      bc.y = _pb.y - _pc.y;
      bc.z = _pb.z - _pc.z;
      
      var norm:Object = new Object();
      norm.x = (ab.y * bc.z) - (ab.z * bc.y);
      norm.y = -((ab.x * bc.z) - (ab.z * bc.x));
      norm.z = (ab.x * bc.y) - (ab.y * bc.x);
      
      var dotProd:Number = norm.x * _light.x + 
                 norm.y * _light.y + 
                 norm.z * _light.z;
      
      var normMag:Number = Math.sqrt(norm.x * norm.x + 
                       norm.y * norm.y +
                       norm.z * norm.z);
      
      var lightMag:Number = Math.sqrt(_light.x * _light.x +
                      _light.y * _light.y +
                      _light.z * _light.z);
      
      return (Math.acos(dotProd / (normMag * lightMag)) / Math.PI) * _light.brightness;
    }
    
    public function set ready(b:Boolean):void {}
    
    public function reSize(w:Number, h:Number):void {
      //
    }
  }
}
