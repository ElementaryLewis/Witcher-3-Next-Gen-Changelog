package red.game.witcher3.tooltips
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.controls.BaseListItem;
   
   public class TooltipStatRenderer_ar extends BaseListItem
   {
      
      public static var showComparison:Boolean = false;
      
      private static const COMPARE_PADDING:Number = 4;
       
      
      protected var STRAIGHTEN_COLUMN_PADDING:Number = 10;
      
      protected var TEXT_PADDING:Number = 1;
      
      protected var AR_TEXT_PADDING:Number = 8;
      
      protected var RIGHT_TEXT_ANCHOR:Number = 430;
      
      protected var TEXTFIELD_WIDTH_COMPARE:Number = 280;
      
      protected var TEXTFIELD_WIDTH_NO_COMPARE:Number = 380;
      
      public var tfStatValue:TextField;
      
      public var mcEnchanted:MovieClip;
      
      public var mcHitArea:MovieClip;
      
      public var mcCompareArrow:MovieClip;
      
      public var tfDiffValue:TextField;
      
      protected var _iconShift:Number = 0;
      
      protected var _columnPadding:Number = 0;
      
      public function TooltipStatRenderer_ar()
      {
         super();
      }
      
      public function get columnPadding() : *
      {
         return this._columnPadding;
      }
      
      public function set columnPaddingcolumnPadding(param1:Number) : void
      {
         this._columnPadding = param1;
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
            this.mcEnchanted.x = this.RIGHT_TEXT_ANCHOR - this.mcEnchanted.width / 2;
         }
         if(Boolean(this.tfStatValue) && Boolean(data.value))
         {
            this.tfStatValue.htmlText = data.value;
            if(this.mcEnchanted.visible)
            {
               this.tfStatValue.x = this.mcEnchanted.x - this.mcEnchanted.width - this.tfStatValue.textWidth;
            }
            else
            {
               this.tfStatValue.x = this.RIGHT_TEXT_ANCHOR - this.tfStatValue.textWidth;
            }
         }
         if(Boolean(textField) && Boolean(data.name))
         {
            textField.htmlText = data.name;
            textField.height = textField.textHeight + CommonConstants.SAFE_TEXT_PADDING;
            textField.x = this.tfStatValue.x - textField.textWidth - this.AR_TEXT_PADDING;
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
                  this.tfDiffValue.textColor = _loc4_;
                  this.tfDiffValue.visible = true;
                  this.tfDiffValue.x = textField.x - this.tfDiffValue.textWidth - this.AR_TEXT_PADDING;
                  textField.width = this.TEXTFIELD_WIDTH_COMPARE;
               }
               else
               {
                  this.tfDiffValue.visible = false;
                  textField.width = this.TEXTFIELD_WIDTH_NO_COMPARE;
               }
            }
            if(this.mcCompareArrow)
            {
               this.mcCompareArrow.gotoAndStop(_loc3_);
               this.mcCompareArrow.visible = true;
               this.mcCompareArrow.x = this.tfDiffValue.x - this.AR_TEXT_PADDING;
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
