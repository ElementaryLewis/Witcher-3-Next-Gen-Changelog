package red.game.witcher3.menus.common
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.core.CoreComponent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.utils.CommonUtils;
   
   public class FullStatsListItem extends W3StatisticsListItem
   {
      
      private static const TEXT_POSITION:Number = 145;
      
      private static const TEXT_PADDING:Number = 10;
       
      
      public var mcColorCoding:MovieClip;
      
      public var mcBackground:MovieClip;
      
      public var mcIcon:MovieClip;
      
      public var tfStatValueMax:TextField;
      
      public function FullStatsListItem()
      {
         super();
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc4_:String = null;
         var _loc2_:Number = 30;
         var _loc3_:Number = 24;
         super.setData(param1);
         if(param1)
         {
            this.mcIcon.gotoAndStop(param1.iconTag);
            if(CoreComponent.isArabicAligmentMode)
            {
               _statValue = "<font size = \'" + _loc3_ + "\'>" + param1.value + "</font>";
            }
            if(param1.maxValue)
            {
               this.tfStatValueMax.text = param1.maxValue;
               this.tfStatValueMax.width = this.tfStatValueMax.textWidth + CommonConstants.SAFE_TEXT_PADDING;
               this.tfStatValueMax.visible = true;
            }
            else
            {
               this.tfStatValueMax.visible = false;
            }
            _loc4_ = !!param1.itemColor ? String(param1.itemColor) : "Brown";
            this.mcColorCoding.gotoAndStop(_loc4_);
            this.mcBackground.gotoAndStop(_loc4_);
            validateNow();
         }
      }
      
      override protected function updateText() : void
      {
         super.updateText();
         var _loc1_:Number = 3;
         var _loc2_:Number = 350;
         var _loc3_:Number = 168;
         var _loc4_:Number = 5;
         textField.width = _loc2_;
         textField.htmlText = CommonUtils.toUpperCaseSafe(textField.htmlText);
         textField.width = textField.textWidth + CommonConstants.SAFE_TEXT_PADDING;
         textField.height = textField.textHeight + CommonConstants.SAFE_TEXT_PADDING;
         var _loc5_:* = -5;
         var _loc6_:Number = TEXT_POSITION;
         var _loc7_:Number;
         if((_loc7_ = this.mcIcon.x + this.mcIcon.width / 2 + _loc5_) > TEXT_POSITION - this.tfStatValueMax.textWidth)
         {
            this.tfStatValueMax.x = _loc7_ - _loc5_;
         }
         else
         {
            this.tfStatValueMax.x = TEXT_POSITION - this.tfStatValueMax.textWidth;
         }
         if(_loc7_ > TEXT_POSITION - tfStatValue.textWidth)
         {
            tfStatValue.x = _loc7_ - _loc5_;
         }
         else
         {
            tfStatValue.x = TEXT_POSITION - tfStatValue.textWidth;
         }
         if(tfStatValue.x + tfStatValue.textWidth > _loc3_ - _loc4_)
         {
            textField.x = tfStatValue.x + tfStatValue.textWidth + _loc4_;
         }
         else
         {
            textField.x = _loc3_;
         }
         textField.y = this.mcIcon.y - textField.height / 2;
         if(this.tfStatValueMax.visible)
         {
            tfStatValue.y = _loc1_;
         }
         else
         {
            tfStatValue.y = this.mcIcon.y - tfStatValue.height / 2;
         }
      }
   }
}
