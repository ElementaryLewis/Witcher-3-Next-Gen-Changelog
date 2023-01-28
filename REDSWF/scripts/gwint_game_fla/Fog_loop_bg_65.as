package gwint_game_fla
{
   import adobe.utils.*;
   import fl.motion.AnimatorFactory3D;
   import fl.motion.MotionBase;
   import fl.motion.motion_internal;
   import flash.accessibility.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.globalization.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.sensors.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.engine.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   
   public dynamic class Fog_loop_bg_65 extends MovieClip
   {
       
      
      public var __id0_:MovieClip;
      
      public var __animFactory___id0_af1:AnimatorFactory3D;
      
      public var __animArray___id0_af1:Array;
      
      public var ____motion___id0_af1_mat3DVec__:Vector.<Number>;
      
      public var ____motion___id0_af1_matArray__:Array;
      
      public var __motion___id0_af1:MotionBase;
      
      public function Fog_loop_bg_65()
      {
         super();
         if(this.__animFactory___id0_af1 == null)
         {
            this.__animArray___id0_af1 = new Array();
            this.__motion___id0_af1 = new MotionBase();
            this.__motion___id0_af1.duration = 1;
            this.__motion___id0_af1.overrideTargetTransform();
            this.__motion___id0_af1.addPropertyArray("visible",[true]);
            this.__motion___id0_af1.addPropertyArray("cacheAsBitmap",[false]);
            this.__motion___id0_af1.addPropertyArray("blendMode",["normal"]);
            this.__motion___id0_af1.addPropertyArray("alphaMultiplier",[0]);
            this.__motion___id0_af1.addPropertyArray("opaqueBackground",[null]);
            this.__motion___id0_af1.is3D = true;
            this.__motion___id0_af1.motion_internal::spanStart = 0;
            this.____motion___id0_af1_matArray__ = new Array();
            this.____motion___id0_af1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion___id0_af1_mat3DVec__[0] = 0.656063;
            this.____motion___id0_af1_mat3DVec__[1] = 0.754717;
            this.____motion___id0_af1_mat3DVec__[2] = 0;
            this.____motion___id0_af1_mat3DVec__[3] = 0;
            this.____motion___id0_af1_mat3DVec__[4] = -0.754717;
            this.____motion___id0_af1_mat3DVec__[5] = 0.656063;
            this.____motion___id0_af1_mat3DVec__[6] = 0;
            this.____motion___id0_af1_mat3DVec__[7] = 0;
            this.____motion___id0_af1_mat3DVec__[8] = 0;
            this.____motion___id0_af1_mat3DVec__[9] = 0;
            this.____motion___id0_af1_mat3DVec__[10] = 1;
            this.____motion___id0_af1_mat3DVec__[11] = 0;
            this.____motion___id0_af1_mat3DVec__[12] = 342.759705;
            this.____motion___id0_af1_mat3DVec__[13] = 47.99427;
            this.____motion___id0_af1_mat3DVec__[14] = 0;
            this.____motion___id0_af1_mat3DVec__[15] = 1;
            this.____motion___id0_af1_matArray__.push(new Matrix3D(this.____motion___id0_af1_mat3DVec__));
            this.__motion___id0_af1.addPropertyArray("matrix3D",this.____motion___id0_af1_matArray__);
            this.__animArray___id0_af1.push(this.__motion___id0_af1);
            this.__animFactory___id0_af1 = new AnimatorFactory3D(null,this.__animArray___id0_af1);
            this.__animFactory___id0_af1.addTargetInfo(this,"__id0_",0,true,0,true,null,-1);
         }
      }
   }
}
