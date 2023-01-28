package red.game.witcher3.menus.inventory_menu
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.controls.StatusIndicator;
   import scaleform.clik.core.UIComponent;
   
   public class PlayerStatInfo extends UIComponent
   {
      
      public static const TYPE_VITALITY:String = "vitality";
      
      public static const TYPE_TOXICITY:String = "toxicity";
       
      
      public var tfLabel:TextField;
      
      public var tfValue:TextField;
      
      public var mcProgressBar:StatusIndicator;
      
      public var mcGlowNegative:MovieClip;
      
      public var mcGlowPositive:MovieClip;
      
      public var mcIcon:MovieClip;
      
      public var mcIconAnimation:MovieClip;
      
      protected var _min:Number;
      
      protected var _max:Number;
      
      protected var _value:Number;
      
      protected var _label:String;
      
      protected var _type:String;
      
      protected var _isPositive:Boolean;
      
      protected var _dangerLimit:Number = -1;
      
      protected var _isPercentage:Boolean;
      
      private var _dataSet:Boolean;
      
      public function PlayerStatInfo()
      {
         super();
         this.mcIcon = this.mcIconAnimation.getChildByName("mcIcon") as MovieClip;
         this.mcGlowNegative.visible = false;
         this.mcGlowPositive.visible = false;
         this._dataSet = false;
      }
      
      public function get label() : String
      {
         return this._label;
      }
      
      public function set label(param1:String) : void
      {
         this._label = param1;
         this.tfLabel.text = this._label;
         this.tfLabel.htmlText = CommonUtils.toUpperCaseSafe(this.tfLabel.text);
         this.tfLabel.width = this.tfLabel.textWidth + CommonConstants.SAFE_TEXT_PADDING;
         this.tfLabel.x = this.mcProgressBar.x + this.mcProgressBar.actualWidth / 2 - this.tfLabel.width / 2;
         if(this.tfLabel.numLines > 1)
         {
            this.tfLabel.y = -53;
         }
         else
         {
            this.tfLabel.y = -27.2;
         }
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function set type(param1:String) : void
      {
         this._type = param1;
         this.mcIcon.gotoAndStop(this._type);
      }
      
      public function get dangerLimit() : Number
      {
         return this._dangerLimit;
      }
      
      public function set dangerLimit(param1:Number) : void
      {
         this._dangerLimit = param1;
      }
      
      public function get isPositive() : Boolean
      {
         return this._isPositive;
      }
      
      public function set isPositive(param1:Boolean) : void
      {
         this._isPositive = param1;
      }
      
      public function get isPercentage() : Boolean
      {
         return this._isPositive;
      }
      
      public function set isPercentage(param1:Boolean) : void
      {
         this._isPercentage = param1;
      }
      
      public function setData(param1:Number, param2:Number = 0, param3:Number = 100) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc7_:Number = NaN;
         if(!isNaN(this._value) && this._dataSet)
         {
            if((_loc4_ = param1 - this._value) != 0)
            {
               (_loc5_ = Boolean(_loc4_) && this._isPositive ? this.mcGlowPositive : this.mcGlowNegative).gotoAndPlay("start");
            }
         }
         this._value = param1;
         this._min = param2;
         this._max = param3;
         this.mcProgressBar.minimum = param2;
         this.mcProgressBar.maximum = param3;
         this.mcProgressBar.value = param1;
         if(this._dangerLimit != -1)
         {
            _loc6_ = this.mcProgressBar.getChildByName("mcBar") as MovieClip;
            _loc7_ = param1 / param3;
            if(this._isPositive && _loc7_ < this._dangerLimit)
            {
               _loc6_.gotoAndStop("red");
               this.mcIconAnimation.gotoAndPlay("start");
            }
            else if(!this._isPositive && _loc7_ > this._dangerLimit)
            {
               _loc6_.gotoAndStop("red");
               this.mcIconAnimation.gotoAndPlay("start");
            }
            else
            {
               _loc6_.gotoAndStop("white");
               this.mcIconAnimation.gotoAndStop("stop");
            }
         }
         if(this._isPercentage)
         {
            this.tfValue.text = Math.round(param1 / param3 * 100) + " %";
         }
         else
         {
            this.tfValue.text = String(param1);
         }
         this.tfValue.x = this.mcProgressBar.x + this.mcProgressBar.actualWidth / 2 - this.tfValue.width / 2;
         this._dataSet = true;
      }
   }
}
