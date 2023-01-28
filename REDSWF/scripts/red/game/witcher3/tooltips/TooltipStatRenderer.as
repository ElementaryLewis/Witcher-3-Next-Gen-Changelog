package red.game.witcher3.tooltips
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.core.CoreComponent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.controls.BaseListItem;
   
   public class TooltipStatRenderer extends BaseListItem
   {
      
      public static var showComparison:Boolean = false;
      
      private static const COMPARE_PADDING:Number = 4;
       
      
      protected var STRAIGHTEN_COLUMN_PADDING:Number = 10;
      
      protected var TEXT_PADDING:Number = 1;
      
      public var tfStatValue:TextField;
      
      public var mcEnchanted:MovieClip;
      
      public var mcHitArea:MovieClip;
      
      public var mcCompareArrow:MovieClip;
      
      public var tfDiffValue:TextField;
      
      protected var _iconShift:Number = 0;
      
      protected var _columnPadding:Number = 0;
      
      public function TooltipStatRenderer()
      {
         super();
      }
      
      public function get columnPadding() : *
      {
         return this._columnPadding;
      }
      
      public function set columnPadding(param1:Number) : void
      {
         this._columnPadding = param1;
         if(this.tfStatValue)
         {
            this.tfStatValue.x = this._columnPadding - this.tfStatValue.width;
         }
         this.updateTextFieldSize();
      }
      
      protected function updateTextFieldSize() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(textField)
         {
            _loc1_ = !!this.mcHitArea ? this.mcHitArea.width : this.width;
            _loc2_ = 0;
            if(Boolean(this.mcCompareArrow) && this.mcCompareArrow.visible)
            {
               _loc1_ -= this.mcCompareArrow.width + COMPARE_PADDING;
            }
            if(Boolean(this.tfDiffValue) && Boolean(this.tfDiffValue.text))
            {
               _loc1_ -= this.tfDiffValue.textWidth + COMPARE_PADDING;
            }
            textField.x = this._columnPadding + this.STRAIGHTEN_COLUMN_PADDING;
            if(!CoreComponent.isArabicAligmentMode)
            {
               textField.width = _loc1_ - textField.x;
            }
            textField.height = textField.textHeight + CommonConstants.SAFE_TEXT_PADDING;
            _loc2_ = textField.x + textField.width + COMPARE_PADDING;
            if(this.mcCompareArrow)
            {
               this.mcCompareArrow.x = _loc2_ + this.mcCompareArrow.width / 2;
               _loc2_ += this.mcCompareArrow.width + COMPARE_PADDING;
            }
            if(this.tfDiffValue)
            {
               this.tfDiffValue.x = _loc2_;
               _loc2_ += this.tfDiffValue.textWidth + COMPARE_PADDING;
            }
         }
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
         this.updateText();
      }
      
      override protected function updateText() : void
      {
         var _loc3_:String = null;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc6_:Boolean = false;
         var _loc7_:* = null;
         if(!data)
         {
            visible = false;
            return;
         }
         visible = true;
         var _loc1_:Number = CommonConstants.SAFE_TEXT_PADDING;
         var _loc2_:Number = this._iconShift;
         if(this.mcEnchanted)
         {
            this.mcEnchanted.visible = data.enchanted;
            if(this.mcEnchanted.x > 0 && Boolean(data.enchanted))
            {
               _loc2_ += this.mcEnchanted.width + this.TEXT_PADDING * 2;
            }
         }
         if(!isNaN(data.diff) && showComparison)
         {
            _loc6_ = false;
            if(data.diff > 0)
            {
               _loc3_ = "better";
               _loc4_ = 4897280;
               _loc5_ = "+";
            }
            else if(data.diff < 0)
            {
               _loc3_ = "worse";
               _loc4_ = 12189696;
               _loc5_ = "";
            }
            else
            {
               _loc4_ = 5460819;
               _loc3_ = "equal";
               _loc5_ = "";
               data.diff = 0;
               data.isPercentageValue = true;
               _loc6_ = true;
            }
            if(this.mcCompareArrow)
            {
               this.mcCompareArrow.gotoAndStop(_loc3_);
               this.mcCompareArrow.visible = true;
            }
            if(this.tfDiffValue)
            {
               if(Boolean(data.diff) || _loc6_)
               {
                  _loc7_ = "";
                  if(data.isPercentageValue)
                  {
                     _loc7_ = Math.round(data.diff * 100) + " %";
                  }
                  else
                  {
                     _loc7_ = String(Math.round(data.diff));
                  }
                  this.tfDiffValue.htmlText = _loc5_ + _loc7_;
                  this.tfDiffValue.width = this.tfDiffValue.textWidth + CommonConstants.SAFE_TEXT_PADDING;
                  this.tfDiffValue.textColor = _loc4_;
                  this.tfDiffValue.visible = true;
               }
               else
               {
                  this.tfDiffValue.visible = false;
               }
            }
         }
         else
         {
            if(this.mcCompareArrow)
            {
               this.mcCompareArrow.visible = false;
            }
            if(this.tfDiffValue)
            {
               this.tfDiffValue.visible = false;
               this.tfDiffValue.text = "";
            }
         }
         if(Boolean(this.tfStatValue) && Boolean(data.value))
         {
            this.tfStatValue.x = _loc2_;
            this.tfStatValue.htmlText = data.value;
            this.tfStatValue.width = this.tfStatValue.textWidth + _loc1_;
            _loc2_ += this.tfStatValue.width + this.TEXT_PADDING;
         }
         if(Boolean(textField) && Boolean(data.name))
         {
            textField.htmlText = data.name;
            if(isNaN(this._columnPadding) || this._columnPadding <= 0)
            {
               textField.width = textField.textWidth + _loc1_;
               textField.height = textField.textHeight + CommonConstants.SAFE_TEXT_PADDING;
               textField.x = _loc2_;
               _loc2_ += textField.textWidth + COMPARE_PADDING;
            }
            else
            {
               this.updateTextFieldSize();
            }
         }
      }
      
      override public function get height() : Number
      {
         if(Boolean(textField) && Boolean(textField.text))
         {
            return textField.height;
         }
         return super.height;
      }
   }
}
