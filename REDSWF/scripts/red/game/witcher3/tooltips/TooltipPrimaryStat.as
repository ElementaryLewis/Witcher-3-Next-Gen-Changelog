package red.game.witcher3.tooltips
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.core.UIComponent;
   
   public class TooltipPrimaryStat extends UIComponent
   {
      
      protected static const SMALL_PADDING:Number = 8;
      
      protected static const SMALL_PADDING_TEXT:Number = 20;
      
      protected static const STAT_NAME_PADDING:Number = 3;
      
      protected static const BIG_PADDING:Number = 25;
      
      protected static const ICON_PADDING:Number = 10;
      
      protected static const DIFF_PADDING:Number = 10;
       
      
      public var tfValue:TextField;
      
      public var tfLabel:TextField;
      
      public var tfDiffValue:TextField;
      
      public var txtDurabilityPrefix:TextField;
      
      public var mcComparisonIcon:MovieClip;
      
      public var mcDurabilityIcon:Sprite;
      
      public var thisWidth:Number;
      
      private var diffPosition:Number;
      
      public function TooltipPrimaryStat()
      {
         super();
      }
      
      public function setValue(param1:Number, param2:String, param3:String = "none", param4:Number = 0, param5:String = "", param6:Number = 0) : void
      {
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc7_:Number = 0;
         this.thisWidth = 0;
         if(param4 > 0)
         {
            _loc8_ = param1 * param4;
            _loc9_ = Math.round(param1 - _loc8_);
            _loc10_ = Math.round(param1 + _loc8_);
            if(_loc9_ != _loc10_)
            {
               this.tfValue.htmlText = _loc9_ + "-" + _loc10_;
            }
            else
            {
               this.tfValue.htmlText = String(_loc10_);
            }
         }
         else
         {
            this.tfValue.htmlText = String(Math.round(param1));
         }
         this.tfValue.width = this.tfValue.textWidth + CommonConstants.SAFE_TEXT_PADDING;
         this.thisWidth = this.tfValue.width;
         _loc7_ = this.tfValue.x + this.tfValue.textWidth + SMALL_PADDING;
         if(param2)
         {
            this.tfLabel.htmlText = param2;
            this.tfLabel.htmlText = CommonUtils.toUpperCaseSafe(this.tfLabel.htmlText);
         }
         this.tfLabel.width = this.tfLabel.textWidth + CommonConstants.SAFE_TEXT_PADDING;
         this.thisWidth += this.tfLabel.width;
         this.tfLabel.x = _loc7_;
         _loc7_ = this.tfLabel.x + this.tfLabel.width + STAT_NAME_PADDING;
         if(Boolean(this.txtDurabilityPrefix) && Boolean(this.mcDurabilityIcon))
         {
            if(param6 > 0)
            {
               this.txtDurabilityPrefix.visible = true;
               this.txtDurabilityPrefix.text = "-" + param6;
               this.txtDurabilityPrefix.width = this.txtDurabilityPrefix.textWidth + CommonConstants.SAFE_TEXT_PADDING;
               this.txtDurabilityPrefix.x = _loc7_;
               _loc7_ += this.txtDurabilityPrefix.textWidth + SMALL_PADDING;
               this.mcDurabilityIcon.visible = true;
               this.mcDurabilityIcon.x = _loc7_;
               _loc7_ += this.mcDurabilityIcon.width + BIG_PADDING;
               this.thisWidth += this.txtDurabilityPrefix.width + SMALL_PADDING_TEXT;
               this.thisWidth += this.mcDurabilityIcon.width;
            }
            else
            {
               this.txtDurabilityPrefix.visible = false;
               this.mcDurabilityIcon.visible = false;
               _loc7_ += STAT_NAME_PADDING;
            }
         }
         else
         {
            _loc7_ += STAT_NAME_PADDING;
         }
         if(this.mcComparisonIcon)
         {
            if(Boolean(param3) && param3 != "none")
            {
               this.mcComparisonIcon.visible = true;
               this.mcComparisonIcon.gotoAndStop(param3);
               this.mcComparisonIcon.x = _loc7_;
               _loc7_ += ICON_PADDING;
               this.thisWidth += this.mcComparisonIcon.width;
            }
            else
            {
               this.mcComparisonIcon.visible = false;
               this.mcComparisonIcon.x = this.mcComparisonIcon.width / 2;
            }
         }
         if(this.tfDiffValue)
         {
            if(param5)
            {
               this.tfDiffValue.htmlText = param5;
               this.tfDiffValue.width = this.tfDiffValue.textWidth + CommonConstants.SAFE_TEXT_PADDING;
               this.tfDiffValue.x = _loc7_;
               this.tfDiffValue.visible = true;
               _loc7_ += this.tfDiffValue.textWidth + DIFF_PADDING;
               this.thisWidth += this.tfDiffValue.width;
            }
            else
            {
               this.tfDiffValue.x = 0;
               this.tfDiffValue.width = 0;
               this.tfDiffValue.visible = false;
            }
         }
      }
   }
}
