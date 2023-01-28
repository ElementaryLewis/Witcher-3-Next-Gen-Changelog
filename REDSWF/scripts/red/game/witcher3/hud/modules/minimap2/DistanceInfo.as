package red.game.witcher3.hud.modules.minimap2
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.core.UIComponent;
   
   public class DistanceInfo extends UIComponent
   {
       
      
      public var mcBackground:MovieClip;
      
      public var mcLevelIndicator:MovieClip;
      
      public var mcFootsteps:MovieClip;
      
      public var mcIcon:MovieClip;
      
      public var tfDistance:TextField;
      
      private var _initialBackgroundX:Number;
      
      private var _initialIconX:Number;
      
      private var _initialLevelIndicatorX:Number;
      
      private var _minimalSize:Number = 0;
      
      private var _currDistance:int = -1;
      
      private var _currText:String;
      
      private var _currLevelIndicator:int = -1;
      
      private const LEVEL_BELOW = 1;
      
      private const LEVEL_THE_SAME = 2;
      
      private const LEVEL_ABOVE = 3;
      
      public function DistanceInfo()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this._initialBackgroundX = this.mcBackground.x;
         this._initialIconX = this.mcIcon.x;
         this._initialLevelIndicatorX = this.mcLevelIndicator.x;
      }
      
      public function Update(param1:Number, param2:Number, param3:Number, param4:Number) : *
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         if(this._currDistance != int(param1))
         {
            this._currDistance = int(param1);
            if(this._currDistance >= 0)
            {
               visible = true;
               _loc5_ = this.UpdateLevelIndicator(param2,param3,param4);
               _loc6_ = this.UpdateText();
               if(_loc5_ || _loc6_)
               {
                  this.UpdateLayout();
               }
            }
            else
            {
               visible = false;
            }
         }
         else if(this._currDistance >= 0)
         {
            if(this.UpdateLevelIndicator(param2,param3,param4))
            {
               this.UpdateLayout();
            }
         }
      }
      
      private function UpdateLevelIndicator(param1:Number, param2:Number, param3:Number) : Boolean
      {
         var _loc4_:int = 0;
         if(this.mcLevelIndicator)
         {
            if(param2 > param1 + param3)
            {
               _loc4_ = this.LEVEL_BELOW;
            }
            else if(param2 < param1 - param3)
            {
               _loc4_ = this.LEVEL_ABOVE;
            }
            else
            {
               _loc4_ = this.LEVEL_THE_SAME;
            }
            if(this._currLevelIndicator != _loc4_)
            {
               this._currLevelIndicator = _loc4_;
               this.mcLevelIndicator.gotoAndStop(this._currLevelIndicator);
               return true;
            }
            return false;
         }
         return false;
      }
      
      private function UpdateText() : Boolean
      {
         if(this._currDistance < 10)
         {
            if(this._currLevelIndicator == this.LEVEL_BELOW)
            {
               return this.SetText("[[panel_hud_below]]");
            }
            if(this._currLevelIndicator == this.LEVEL_ABOVE)
            {
               return this.SetText("[[panel_hud_above]]");
            }
            return this.SetText("[[panel_hud_nearby]]");
         }
         return this.SetText(this._currDistance.toString(),true,false);
      }
      
      private function SetText(param1:String, param2:Boolean = false, param3:Boolean = true) : Boolean
      {
         if(this.tfDistance)
         {
            if(this._currText == param1)
            {
               return false;
            }
            this._currText = param1;
            this.tfDistance.htmlText = param1;
            if(param3)
            {
               this.tfDistance.htmlText = CommonUtils.toUpperCaseSafe(this.tfDistance.htmlText);
            }
            if(param2 && !this.mcFootsteps.visible)
            {
               this.mcFootsteps.visible = true;
            }
            else if(!param2 && this.mcFootsteps.visible)
            {
               this.mcFootsteps.visible = false;
            }
            return true;
         }
         return false;
      }
      
      private function UpdateLayout() : *
      {
         var _loc1_:Number = NaN;
         if(this.tfDistance)
         {
            _loc1_ = this.tfDistance.textWidth;
            this.mcLevelIndicator.x = this._initialLevelIndicatorX - _loc1_;
            this.mcIcon.x = this._initialIconX - _loc1_;
            this.mcBackground.x = this._initialBackgroundX - _loc1_;
            if(this._currLevelIndicator != this.LEVEL_THE_SAME)
            {
               this.mcIcon.x -= this.mcLevelIndicator.width;
               this.mcBackground.x -= this.mcLevelIndicator.width;
            }
         }
      }
      
      public function get minimalSize() : Number
      {
         return this._minimalSize;
      }
      
      public function set minimalSize(param1:Number) : void
      {
         this._minimalSize = param1;
      }
   }
}
