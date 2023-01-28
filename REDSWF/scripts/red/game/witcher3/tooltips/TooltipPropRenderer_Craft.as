package red.game.witcher3.tooltips
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.core.CoreComponent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.controls.BaseListItem;
   
   public class TooltipPropRenderer_Craft extends BaseListItem
   {
       
      
      private const ICON_PADDING:Number = 10;
      
      private const BLOCK_PADDING:Number = 5;
      
      private const MAX_TEXT_WIDTHS:Number = 320;
      
      private const ICON_SINGLE_Y:Number = 12;
      
      private const ICON_DOUBLE_Y:Number = 12;
      
      private const VALUE_DOUBLE_Y:Number = 0;
      
      private const RIGHT_ANCHOR:Number = 485;
      
      private const TEXT_PADDING:Number = 5;
      
      public var tfDiffValue:TextField;
      
      public var tfStatValue:TextField;
      
      public var mcComparisonIcon:MovieClip;
      
      public function TooltipPropRenderer_Craft()
      {
         super();
      }
      
      override public function getRendererHeight() : Number
      {
         return textField.textHeight;
      }
      
      override protected function updateText() : void
      {
         textField.width = this.MAX_TEXT_WIDTHS;
         textField.htmlText = this.addArabicWrapper(_data.name);
         textField.height = textField.textHeight + CommonConstants.SAFE_TEXT_PADDING;
         textField.width = textField.textWidth + CommonConstants.SAFE_TEXT_PADDING;
         this.tfDiffValue.htmlText = _data.diffValue;
         this.tfDiffValue.width = this.tfDiffValue.textWidth + this.TEXT_PADDING;
         this.tfStatValue.text = _data.value;
         this.tfStatValue.width = this.tfStatValue.textWidth + this.TEXT_PADDING;
         if(!CoreComponent.isArabicAligmentMode)
         {
            textField.x = this.tfStatValue.x + this.tfStatValue.width;
            if(this.mcComparisonIcon)
            {
               if(data.icon)
               {
                  this.mcComparisonIcon.visible = true;
                  this.mcComparisonIcon.gotoAndStop(data.icon);
                  this.mcComparisonIcon.x = textField.x + textField.width + this.ICON_PADDING;
               }
               else
               {
                  this.mcComparisonIcon.visible = false;
               }
               if(data.diffValue)
               {
                  this.tfDiffValue.htmlText = data.diffValue;
                  this.tfDiffValue.width = this.tfDiffValue.textWidth + CommonConstants.SAFE_TEXT_PADDING;
                  this.tfDiffValue.x = this.mcComparisonIcon.x + this.ICON_PADDING;
               }
               else
               {
                  this.tfDiffValue.visible = false;
               }
            }
         }
         else if(this.mcComparisonIcon)
         {
            if(data.diffValue)
            {
               this.tfDiffValue.htmlText = data.diffValue;
               this.tfDiffValue.width = this.tfDiffValue.textWidth + CommonConstants.SAFE_TEXT_PADDING;
               this.tfDiffValue.x = this.RIGHT_ANCHOR - this.tfDiffValue.width;
            }
            else
            {
               this.tfDiffValue.visible = false;
            }
            if(data.icon)
            {
               this.mcComparisonIcon.visible = true;
               this.mcComparisonIcon.gotoAndStop(data.icon);
               this.mcComparisonIcon.x = this.RIGHT_ANCHOR - this.tfDiffValue.textWidth - this.mcComparisonIcon.width;
               if(data.icon == "none")
               {
                  textField.x = this.RIGHT_ANCHOR - textField.width;
               }
               else
               {
                  textField.x = this.mcComparisonIcon.x - this.mcComparisonIcon.width - textField.width;
               }
            }
            else
            {
               this.mcComparisonIcon.visible = false;
            }
            this.tfStatValue.x = textField.x + textField.width - textField.textWidth - this.tfStatValue.width;
         }
         if(textField.numLines > 1)
         {
            this.tfDiffValue.y = this.VALUE_DOUBLE_Y;
            this.tfStatValue.y = this.VALUE_DOUBLE_Y;
            this.mcComparisonIcon.y = this.ICON_DOUBLE_Y;
         }
         else
         {
            this.tfDiffValue.y = 0;
            this.tfStatValue.y = 0;
            this.mcComparisonIcon.y = this.ICON_SINGLE_Y;
         }
      }
      
      private function addArabicWrapper(param1:String) : String
      {
         if(CoreComponent.isArabicAligmentMode)
         {
            return "<p align=\"right\">" + param1 + "</p>";
         }
         return param1;
      }
   }
}
