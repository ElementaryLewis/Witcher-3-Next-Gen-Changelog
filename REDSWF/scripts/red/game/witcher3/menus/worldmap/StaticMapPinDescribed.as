package red.game.witcher3.menus.worldmap
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.text.TextField;
   import red.game.witcher3.data.StaticMapPinData;
   import scaleform.clik.controls.Label;
   import scaleform.clik.controls.ListItemRenderer;
   
   public class StaticMapPinDescribed extends ListItemRenderer
   {
      
      private static const HEIGHT_THRESHOLD:Number = 10;
      
      private static const UNSELECTED_PIN_SCALE:Number = 1.5;
      
      private static const UNSELECTED_PIN_ALPHA:Number = 1;
      
      private static const SELECTED_PIN_SCALE:Number = 1.5;
      
      private static const SELECTED_PIN_ALPHA:Number = 1;
       
      
      public var mcDescription:Label;
      
      public var mcIcon:MovieClip;
      
      public var tfLabel:TextField;
      
      public var isAvatar:Boolean = false;
      
      private var _isInVisibleArea:Boolean;
      
      private var _worldPosition:Point;
      
      private var _pinInitialized:Boolean = false;
      
      private var _hasPointer:Boolean = false;
      
      private var _isHidden:Boolean = false;
      
      public function StaticMapPinDescribed()
      {
         super();
         this._isInVisibleArea = false;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         preventAutosizing = true;
         this.mcIcon.scaleX = UNSELECTED_PIN_SCALE;
         this.mcIcon.scaleY = UNSELECTED_PIN_SCALE;
         this.mcIcon.alpha = UNSELECTED_PIN_ALPHA;
         this.mcDescription.visible = false;
         focused = 1;
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
         this.update();
         if(!this._pinInitialized)
         {
            this._pinInitialized = true;
            if(!this.isAvatar && (Boolean(param1.isUserPin) || Boolean(param1.isPlayer) || Boolean(param1.isQuest)))
            {
               PinPointersManager.getInstance().addPinPointer(this);
               this._hasPointer = true;
            }
         }
      }
      
      override protected function updateAfterStateChange() : void
      {
         super.updateAfterStateChange();
      }
      
      public function update() : void
      {
         if(!data)
         {
            return;
         }
         var _loc1_:StaticMapPinData = data as StaticMapPinData;
         var _loc2_:String = "";
         if(!_loc1_)
         {
            return;
         }
         this.mcIcon.mcPinIcon.visible = true;
         this.mcIcon.mcPinIcon.gotoAndStop(_loc1_.type);
         this.updateLabel();
         if(Boolean(_loc1_.radius) && _loc1_.radius > 0)
         {
            this.mcIcon.mcPinRadius.visible = true;
            this.mcIcon.mcPinRadius.mcRadialCircle.visible = true;
            this.mcIcon.mcPinRadius.mcRadialGlow.visible = false;
            if(_loc1_.isQuest)
            {
               if(_loc1_.type == "QuestBelgard")
               {
                  this.mcIcon.mcPinRadius.mcRadialCircle.gotoAndStop(3);
               }
               else if(_loc1_.type == "QuestCoronata")
               {
                  this.mcIcon.mcPinRadius.mcRadialCircle.gotoAndStop(4);
               }
               else if(_loc1_.type == "QuestVermentino")
               {
                  this.mcIcon.mcPinRadius.mcRadialCircle.gotoAndStop(5);
               }
               else
               {
                  this.mcIcon.mcPinRadius.mcRadialCircle.gotoAndStop(1);
               }
            }
            else
            {
               this.mcIcon.mcPinRadius.mcRadialCircle.gotoAndStop(2);
            }
         }
         else
         {
            this.mcIcon.mcPinRadius.visible = false;
         }
      }
      
      public function SetWorldPosition(param1:Number, param2:Number) : *
      {
         this._worldPosition = new Point(param1,param2);
      }
      
      public function SetWorldPositionEx(param1:Number, param2:Number) : *
      {
         var _loc3_:StaticMapPinData = data as StaticMapPinData;
         _loc3_.posX = param1;
         _loc3_.posY = param2;
      }
      
      public function GetWorldPosition() : Point
      {
         return this._worldPosition;
      }
      
      public function SetVisibleInArea(param1:Boolean) : *
      {
         this._isInVisibleArea = param1;
         if(this._hasPointer)
         {
            PinPointersManager.getInstance().showPinPointer(this,!this._isInVisibleArea && !this._isHidden);
         }
      }
      
      public function IsVisibleInArea() : Boolean
      {
         return this._isInVisibleArea;
      }
      
      public function isHidden() : Boolean
      {
         return this._isHidden;
      }
      
      public function setHidden(param1:Boolean) : void
      {
         this._isHidden = param1;
         visible = this._isHidden ? false : true;
      }
      
      public function Show(param1:Boolean) : *
      {
         this.mcIcon.visible = param1;
         if(this._hasPointer)
         {
            PinPointersManager.getInstance().showPinPointer(this,!this._isInVisibleArea && !this._isHidden);
         }
      }
      
      public function UpdateMapPosition2(param1:Number, param2:Number) : *
      {
         x = param1;
         y = param2;
      }
      
      public function UpdateMapPosition(param1:Point, param2:Number) : *
      {
         x = param1.x * param2;
         y = param1.y * param2;
      }
      
      public function UpdateScale(param1:Number, param2:int, param3:Boolean = false, param4:Boolean = false) : *
      {
      }
      
      public function InitPingAnimation() : *
      {
         var _loc1_:StaticMapPinData = data as StaticMapPinData;
         if(!_loc1_)
         {
            return;
         }
         if(_loc1_.isPlayer)
         {
            this.mcIcon.mcPingAnimation.gotoAndPlay("Animation");
         }
      }
      
      public function UpdateHighlighting() : *
      {
         var _loc1_:StaticMapPinData = data as StaticMapPinData;
         if(!_loc1_)
         {
            return;
         }
         if(this.mcIcon.mcPinGlow)
         {
            this.mcIcon.mcPinGlow.visible = _loc1_.highlighted;
         }
      }
      
      private function updateLabel() : void
      {
         var _loc1_:StaticMapPinData = data as StaticMapPinData;
         if(_loc1_)
         {
            if(_loc1_.isFastTravel)
            {
               this.tfLabel.htmlText = _loc1_.label;
               this.tfLabel.visible = true;
            }
            else
            {
               this.tfLabel.visible = false;
            }
         }
      }
   }
}
