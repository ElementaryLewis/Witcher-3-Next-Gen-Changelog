package red.game.witcher3.menus.worldmap
{
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import red.game.witcher3.data.StaticMapPinData;
   import red.game.witcher3.utils.CommonUtils;
   
   public class PinPointersManager
   {
      
      private static var _instance:PinPointersManager;
       
      
      private const POINTER_SCALE:Number = 1;
      
      private const DETECT_PADDING:Number = -5;
      
      private const DRAW_PADDING:Number = 5;
      
      private const QUEST_POINTER_DEF_REF:String = "QuestPinPointer";
      
      private const USERPIN_POINTER_DEF_REF:String = "UserPinPointer";
      
      private const PLAYER_POINTER_DEF_REF:String = "PlayerPinPointer";
      
      private var _canvas:Sprite;
      
      private var _pointersMap:Dictionary;
      
      private var _a;
      
      private var _b;
      
      private var _c;
      
      private var _d;
      
      private var _centerPoint:Point;
      
      protected var _disabled:Boolean = false;
      
      public function PinPointersManager()
      {
         super();
      }
      
      public static function getInstance() : PinPointersManager
      {
         if(!_instance)
         {
            _instance = new PinPointersManager();
         }
         return _instance;
      }
      
      public function get disabled() : Boolean
      {
         return this._disabled;
      }
      
      public function set disabled(param1:Boolean) : void
      {
         this._disabled = param1;
         if(this._canvas)
         {
            if(this._disabled)
            {
               this._canvas.graphics.clear();
               this.cleanup();
            }
            this._canvas.visible = !this._disabled;
         }
      }
      
      public function cleanup() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this._pointersMap)
         {
            delete this._pointersMap[_loc1_];
         }
         while(this._canvas.numChildren > 0)
         {
            this._canvas.removeChild(this._canvas.getChildAt(0));
         }
      }
      
      public function init(param1:Sprite) : void
      {
         this._pointersMap = new Dictionary(true);
         this._canvas = param1;
         this._a = new Point(-this._canvas.width / 2 - this.DETECT_PADDING,-this._canvas.height / 2 - this.DETECT_PADDING);
         this._b = new Point(this._canvas.width / 2 + this.DETECT_PADDING,-this._canvas.height / 2 - this.DETECT_PADDING);
         this._c = new Point(this._canvas.width / 2 + this.DETECT_PADDING,this._canvas.height / 2 + this.DETECT_PADDING);
         this._d = new Point(-this._canvas.width / 2 - this.DETECT_PADDING,this._canvas.height / 2 + this.DETECT_PADDING);
         this._centerPoint = new Point(0,0);
      }
      
      public function updatePointersPosition() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:StaticMapPinDescribed = null;
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         var _loc6_:MovieClip = null;
         var _loc7_:Point = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         if(this._disabled)
         {
            return;
         }
         this._canvas.graphics.clear();
         for(_loc1_ in this._pointersMap)
         {
            _loc2_ = _loc1_ as StaticMapPinDescribed;
            if(Boolean(_loc2_) && Boolean(_loc2_.parent))
            {
               _loc3_ = new Point(_loc2_.x,_loc2_.y);
               _loc4_ = _loc2_.parent.localToGlobal(_loc3_);
               _loc5_ = this._canvas.globalToLocal(_loc4_);
               if(_loc6_ = this._pointersMap[_loc2_])
               {
                  if(!(_loc7_ = CommonUtils.getPointOfIntersection(this._a,this._b,this._centerPoint,_loc5_)))
                  {
                     _loc7_ = CommonUtils.getPointOfIntersection(this._b,this._c,this._centerPoint,_loc5_);
                  }
                  if(!_loc7_)
                  {
                     _loc7_ = CommonUtils.getPointOfIntersection(this._c,this._d,this._centerPoint,_loc5_);
                  }
                  if(!_loc7_)
                  {
                     _loc7_ = CommonUtils.getPointOfIntersection(this._d,this._a,this._centerPoint,_loc5_);
                  }
                  if(_loc7_)
                  {
                     if(_loc6_)
                     {
                        _loc8_ = this._centerPoint.x - _loc6_.x;
                        _loc9_ = this._centerPoint.y - _loc6_.y;
                        _loc11_ = -(_loc10_ = Math.atan2(_loc8_,_loc9_)) / Math.PI * 180;
                        _loc12_ = this.DRAW_PADDING * Math.cos(_loc10_);
                        _loc13_ = this.DRAW_PADDING * Math.sin(_loc10_);
                        _loc6_.rotation = _loc11_;
                        _loc6_.x = _loc7_.x - _loc12_;
                        _loc6_.y = _loc7_.y - _loc12_;
                        if(!_loc6_.alpha && _loc6_.visible)
                        {
                           _loc6_.alpha = 1;
                        }
                     }
                  }
                  else
                  {
                     this._canvas.graphics.clear();
                  }
               }
            }
            else if(_loc2_)
            {
               _loc2_.visible = false;
            }
         }
      }
      
      public function addPinPointer(param1:StaticMapPinDescribed) : void
      {
         var _loc3_:String = null;
         var _loc4_:MovieClip = null;
         var _loc2_:StaticMapPinData = param1.data as StaticMapPinData;
         if(_loc2_)
         {
            if(_loc2_.isQuest)
            {
               _loc3_ = this.QUEST_POINTER_DEF_REF;
            }
            else if(_loc2_.isPlayer)
            {
               _loc3_ = this.PLAYER_POINTER_DEF_REF;
            }
            else if(_loc2_.isUserPin)
            {
               _loc3_ = this.USERPIN_POINTER_DEF_REF;
            }
            if(!this._pointersMap[param1])
            {
               _loc4_ = this.createPointer(_loc3_,_loc2_.isUserPin ? _loc2_.type : "");
               this._pointersMap[param1] = _loc4_;
            }
         }
      }
      
      public function removePinPointer() : void
      {
      }
      
      public function showPinPointer(param1:StaticMapPinDescribed, param2:Boolean) : void
      {
         var _loc3_:MovieClip = this._pointersMap[param1];
         if(Boolean(_loc3_) && _loc3_.visible != param2)
         {
            _loc3_.alpha = 0;
            _loc3_.visible = param2;
         }
      }
      
      private function createPointer(param1:String, param2:String) : MovieClip
      {
         var pointerMovieClip:MovieClip = null;
         var ClassRef:Class = null;
         var cnv:Graphics = null;
         var classRefName:String = param1;
         var label:String = param2;
         try
         {
            ClassRef = getDefinitionByName(classRefName) as Class;
            pointerMovieClip = new ClassRef();
            pointerMovieClip.scaleX = pointerMovieClip.scaleY = this.POINTER_SCALE;
            pointerMovieClip.visible = false;
            if(label != "")
            {
               pointerMovieClip.gotoAndStop(label);
            }
         }
         catch(er:Error)
         {
            pointerMovieClip = new MovieClip();
            cnv = pointerMovieClip.graphics;
            cnv.beginFill(16711680);
            cnv.lineStyle(2,13369344);
            cnv.drawCircle(0,0,10);
            cnv.endFill();
         }
         this._canvas.addChild(pointerMovieClip);
         return pointerMovieClip;
      }
   }
}
