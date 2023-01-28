package red.game.witcher3.menus.worldmap
{
   import com.gskinner.motion.GTween;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.utils.Timer;
   import red.core.constants.KeyCode;
   import red.core.data.InputAxisData;
   import red.core.events.GameEvent;
   import red.core.utils.InputUtils;
   import red.game.witcher3.events.MapContextEvent;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.controls.UILoader;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class UniverseMap extends BaseMap
   {
      
      private static const KEYBOARD_SCROLL_SPEED:int = 10;
       
      
      public var mcUniverseMapContainer:UniverseMapContainer;
      
      public var mcUniverseMapCrosshair:MovieClip;
      
      private var currentSelectedArea:UniverseArea;
      
      private var scrollTimer:Timer;
      
      private const SCROLL_COEF = 20;
      
      private var _keyboardScrollLeft:Boolean = false;
      
      private var _keyboardScrollRight:Boolean = false;
      
      private var _keyboardScrollUp:Boolean = false;
      
      private var _keyboardScrollDown:Boolean = false;
      
      private var playeLevel:int;
      
      private var _glowFilter:GlowFilter;
      
      private var GLOW_COLOR:Number = 11508592;
      
      private var GLOW_BLUR:Number = 0;
      
      private var GLOW_STRENGHT:Number = 1;
      
      private var GLOW_ALPHA:Number = 1;
      
      private var filterArray:Array;
      
      private var _bufScrollX:Number = 0;
      
      private var _bufScrollY:Number = 0;
      
      public function UniverseMap()
      {
         this.filterArray = [];
         super();
      }
      
      public function centerCurrentArea(param1:Boolean = true, param2:Number = 0.1) : void
      {
         if(this.currentSelectedArea)
         {
            this.mcUniverseMapContainer.centerArea(this.currentSelectedArea,param1,param2);
         }
         else
         {
            this.mcUniverseMapContainer.centerCurrentArea(param1,param2);
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"worldmap.global.universe.area",[this.setCurrentArea]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"worldmap.global.universe.questareas",[this.setQuestAreas]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"worldmap.global.universe.playerLevel",[this.setPlayerLevel]));
         this.scrollTimer = new Timer(24);
         this.scrollTimer.addEventListener(TimerEvent.TIMER,this.handleScrollTimer,false,0,true);
         this.scrollTimer.start();
         _defaultScale = UNIVERSE_MAP_ZOOM;
      }
      
      private function ResetKeyboardInput() : *
      {
         this._keyboardScrollUp = this._keyboardScrollDown = this._keyboardScrollLeft = this._keyboardScrollRight = false;
      }
      
      override public function CanProcessInput() : Boolean
      {
         if(_transitionTween)
         {
            return false;
         }
         return true;
      }
      
      private function setCurrentArea(param1:String) : void
      {
         this.mcUniverseMapContainer.setCurrentArea(param1);
      }
      
      private function setQuestAreas(param1:Object, param2:int) : *
      {
         if(param2 == -1)
         {
            this.mcUniverseMapContainer.setQuestAreas(param1);
         }
      }
      
      private function setPlayerLevel(param1:int) : void
      {
         this.playeLevel = param1;
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc5_:InputAxisData = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         if(param1.handled)
         {
            return;
         }
         if(!IsEnabled())
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         var _loc3_:Boolean = _loc2_.value == InputValue.KEY_DOWN || _loc2_.value == InputValue.KEY_HOLD;
         var _loc4_:* = _loc2_.value == InputValue.KEY_UP;
         if(!this.CanProcessInput())
         {
            return;
         }
         switch(_loc2_.code)
         {
            case KeyCode.W:
               if(_loc3_)
               {
                  this._keyboardScrollUp = true;
               }
               else if(_loc4_)
               {
                  this._keyboardScrollUp = false;
               }
               param1.handled = true;
               break;
            case KeyCode.S:
               if(_loc3_)
               {
                  this._keyboardScrollDown = true;
               }
               else if(_loc4_)
               {
                  this._keyboardScrollDown = false;
               }
               param1.handled = true;
               break;
            case KeyCode.A:
               if(_loc3_)
               {
                  this._keyboardScrollLeft = true;
               }
               else if(_loc4_)
               {
                  this._keyboardScrollLeft = false;
               }
               param1.handled = true;
               break;
            case KeyCode.D:
               if(_loc3_)
               {
                  this._keyboardScrollRight = true;
               }
               else if(_loc4_)
               {
                  this._keyboardScrollRight = false;
               }
               param1.handled = true;
               break;
            case KeyCode.PAD_LEFT_STICK_AXIS:
               _loc5_ = InputAxisData(_loc2_.value);
               _loc6_ = InputUtils.getMagnitude(_loc5_.xvalue,_loc5_.yvalue);
               _loc7_ = _loc6_ * _loc6_;
               _loc8_ = _loc6_ * _loc6_ * _loc6_;
               _loc9_ = Math.min(this.SCROLL_COEF,this.SCROLL_COEF * _loc7_);
               this._bufScrollX = -_loc9_ * _loc5_.xvalue;
               this._bufScrollY = _loc9_ * _loc5_.yvalue;
               param1.handled = true;
               break;
            default:
               return;
         }
         validateNow();
      }
      
      private function GetScale() : Number
      {
         return actualScaleX;
      }
      
      private function GetGlobalCrosshairPos() : Point
      {
         return localToGlobal(new Point(this.mcUniverseMapCrosshair.x,this.mcUniverseMapCrosshair.y));
      }
      
      private function handleScrollTimer(param1:TimerEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(Math.abs(this._bufScrollX) > 0 || Math.abs(this._bufScrollY) > 0)
         {
            this.ScrollMap(this._bufScrollX,this._bufScrollY);
            this._bufScrollX = 0;
            this._bufScrollY = 0;
         }
         if(this._keyboardScrollUp || this._keyboardScrollDown || this._keyboardScrollLeft || this._keyboardScrollRight)
         {
            _loc2_ = 0;
            _loc3_ = 0;
            if(this._keyboardScrollUp)
            {
               _loc2_ = KEYBOARD_SCROLL_SPEED;
            }
            else if(this._keyboardScrollDown)
            {
               _loc2_ = -KEYBOARD_SCROLL_SPEED;
            }
            if(this._keyboardScrollLeft)
            {
               _loc3_ = KEYBOARD_SCROLL_SPEED;
            }
            else if(this._keyboardScrollRight)
            {
               _loc3_ = -KEYBOARD_SCROLL_SPEED;
            }
            this.ScrollMap(_loc3_,_loc2_);
         }
      }
      
      public function ScrollMap(param1:Number, param2:Number) : *
      {
         var _loc3_:Number = this.GetScale();
         this.mcUniverseMapContainer.ScrollMap(param1 / _loc3_,param2 / _loc3_);
         this.updateAreaSelection();
      }
      
      public function updateAreaSelection(param1:Boolean = false) : void
      {
         var _loc3_:MapContextEvent = null;
         var _loc5_:UILoader = null;
         var _loc6_:UILoader = null;
         var _loc7_:String = null;
         var _loc8_:Object = null;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         var _loc2_:UniverseArea = null;
         var _loc4_:UniverseArea = this.mcUniverseMapContainer.GetOveredHub(this.GetGlobalCrosshairPos());
         if(this.currentSelectedArea != _loc4_)
         {
            if(this.currentSelectedArea)
            {
               this.currentSelectedArea.mcIcon.gotoAndStop("inactive");
               if(this.currentSelectedArea as Hub_Custom)
               {
                  if(_loc5_ = this.currentSelectedArea.mcIcon.getChildByName("customUILoader") as UILoader)
                  {
                     this._glowFilter = new GlowFilter(this.GLOW_COLOR,1,this.GLOW_BLUR,this.GLOW_BLUR,0,BitmapFilterQuality.HIGH);
                     this.filterArray = [];
                     this.filterArray.push(this._glowFilter);
                     _loc5_.filters = this.filterArray;
                  }
               }
            }
            if(_loc4_)
            {
               _loc4_.mcIcon.gotoAndStop("active");
               if(_loc4_ as Hub_Custom)
               {
                  if(_loc6_ = _loc4_.mcIcon.getChildByName("customUILoader") as UILoader)
                  {
                     this._glowFilter = new GlowFilter(this.GLOW_COLOR,this.GLOW_ALPHA,this.GLOW_BLUR,this.GLOW_BLUR,this.GLOW_STRENGHT,BitmapFilterQuality.HIGH);
                     this.filterArray = [];
                     this.filterArray.push(this._glowFilter);
                     _loc6_.filters = this.filterArray;
                  }
               }
            }
         }
         if(!param1)
         {
            _loc2_ = this.mcUniverseMapContainer.GetOveredHub(this.GetGlobalCrosshairPos());
         }
         if(Boolean(_loc2_) && _loc2_ != this.currentSelectedArea)
         {
            this.currentSelectedArea = _loc2_;
            this.mcUniverseMapCrosshair.gotoAndPlay("snap");
            _loc3_ = new MapContextEvent(MapContextEvent.CONTEXT_CHANGE);
            _loc3_.active = true;
            _loc8_ = {};
            if((_loc9_ = this.currentSelectedArea.recLevel - this.playeLevel) >= 15)
            {
               _loc10_ = "<font color=\'#d61010\'>";
            }
            else if(_loc9_ < 15 && _loc9_ >= 6)
            {
               _loc10_ = "<font color=\'#d68f29\'>";
            }
            else
            {
               _loc10_ = "<font color=\'#FFFFFF\'>";
            }
            _loc8_.title = "[[map_location_" + this.currentSelectedArea.GetWorldName() + "]]";
            _loc8_.description = CommonUtils.getLocalization("map_description_" + this.currentSelectedArea.GetWorldName());
            _loc8_.description += "<br>" + _loc10_ + CommonUtils.getLocalization("panel_item_required_level") + " " + this.currentSelectedArea.recLevel + "</font>";
            _loc8_.openRegion = true;
            _loc3_.tooltipData = _loc8_;
            dispatchEvent(_loc3_);
         }
         else if(!_loc2_ && Boolean(this.currentSelectedArea))
         {
            this.currentSelectedArea = null;
            this.mcUniverseMapCrosshair.gotoAndPlay("normal");
            this.mcUniverseMapContainer.removeHiglighting();
            _loc3_ = new MapContextEvent(MapContextEvent.CONTEXT_CHANGE);
            _loc3_.active = false;
            dispatchEvent(_loc3_);
         }
      }
      
      public function GoToHubMap(param1:UniverseArea) : Boolean
      {
         if(param1)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnSwitchToHubMap",[param1.GetWorldName(false)]));
            return true;
         }
         return false;
      }
      
      public function GoToSelectedHubMap() : Boolean
      {
         var _loc1_:UniverseArea = this.mcUniverseMapContainer.GetHubMapAtPoint(this.GetGlobalCrosshairPos());
         if(_loc1_)
         {
            return this.GoToHubMap(_loc1_);
         }
         return false;
      }
      
      override public function Enable(param1:Boolean, param2:Boolean = false) : *
      {
         if(_enabled == param1)
         {
            if(!param2)
            {
               return;
            }
         }
         _enabled = param1;
         if(_enabled)
         {
            this.ResetKeyboardInput();
            showMap(true);
         }
         else
         {
            hideMap(false);
         }
      }
      
      override public function OnControllerChanged(param1:Boolean) : *
      {
         super.OnControllerChanged(param1);
         this.mcUniverseMapCrosshair.visible = param1;
         if(param1)
         {
            this.mcUniverseMapCrosshair.x = 0;
            this.mcUniverseMapCrosshair.y = 0;
         }
         this.updateAreaSelection();
      }
      
      public function OnMouseMove(param1:Point) : *
      {
         var _loc2_:Point = globalToLocal(param1);
         this.mcUniverseMapCrosshair.x = _loc2_.x;
         this.mcUniverseMapCrosshair.y = _loc2_.y;
         if(this.CanProcessInput())
         {
            this.updateAreaSelection();
         }
      }
      
      override protected function handleShowAnim(param1:GTween = null) : void
      {
         super.handleShowAnim(param1);
         this.updateAreaSelection();
      }
   }
}
