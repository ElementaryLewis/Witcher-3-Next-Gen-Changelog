package red.game.witcher3.hud.modules.minimap2
{
   import flash.display.MovieClip;
   import flash.geom.Vector3D;
   import red.game.witcher3.hud.modules.HudModuleMinimap2;
   
   public class MapPath extends MovieClip
   {
       
      
      private var _globalX:Number;
      
      private var _globalY:Number;
      
      private var _color:int;
      
      private var _lineWidth:Number;
      
      private var _controlPoints:Vector.<Vector3D>;
      
      private var _splinePoints:Vector.<Vector3D>;
      
      private const _defaultLineWidth:Number = 0.25;
      
      public function MapPath()
      {
         super();
      }
      
      public function AddControlPoint(param1:Number, param2:Number) : *
      {
         if(!this._controlPoints)
         {
            this._controlPoints = new Vector.<Vector3D>();
         }
         this._controlPoints[this._controlPoints.length] = new Vector3D(param1,param2,0,0);
      }
      
      public function AddSplinePoint(param1:Number, param2:Number) : *
      {
         if(!this._splinePoints)
         {
            this._splinePoints = new Vector.<Vector3D>();
         }
         this._splinePoints[this._splinePoints.length] = new Vector3D(param1,param2,0,0);
      }
      
      public function SetupCurve(param1:Number, param2:Number, param3:int, param4:Number) : *
      {
         this._globalX = param1;
         this._globalY = param2;
         this._color = param3;
         this._lineWidth = param4;
         this.DrawCurve();
      }
      
      public function DrawCurve() : *
      {
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         _loc2_ = ((this._color & 4278190080) >> 24) / 255;
         graphics.clear();
         if(Boolean(this._controlPoints) && this._controlPoints.length > 0)
         {
            graphics.lineStyle(this._lineWidth * this._defaultLineWidth,this._color,_loc2_);
            graphics.moveTo(this._controlPoints[0].x,-this._controlPoints[0].y);
            _loc1_ = 1;
            while(_loc1_ < this._controlPoints.length)
            {
               graphics.lineTo(this._controlPoints[_loc1_].x,-this._controlPoints[_loc1_].y);
               _loc1_++;
            }
         }
         if(Boolean(this._splinePoints) && this._splinePoints.length > 0)
         {
            graphics.lineStyle(this._lineWidth * this._defaultLineWidth,this._color,_loc2_);
            graphics.moveTo(HudModuleMinimap2.WorldToMapX(this._globalX + this._splinePoints[0].x),HudModuleMinimap2.WorldToMapY(this._globalY + this._splinePoints[0].y));
            _loc1_ = 1;
            while(_loc1_ < this._splinePoints.length)
            {
               graphics.lineTo(HudModuleMinimap2.WorldToMapX(this._globalX + this._splinePoints[_loc1_].x),HudModuleMinimap2.WorldToMapY(this._globalY + this._splinePoints[_loc1_].y));
               _loc1_++;
            }
         }
      }
   }
}
