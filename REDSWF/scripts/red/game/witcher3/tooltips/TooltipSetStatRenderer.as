package red.game.witcher3.tooltips
{
   import red.core.CoreComponent;
   
   public class TooltipSetStatRenderer extends TooltipStatRenderer
   {
      
      private static const ACTIVE_TEXT_COLOR:Number = 40704;
      
      private static const RIGHT_ANCHOR:Number = 430;
       
      
      private var cachedPosition:Number = 0;
      
      public function TooltipSetStatRenderer()
      {
         super();
         TEXT_PADDING = 8;
         if(textField)
         {
            this.cachedPosition = textField.x;
         }
      }
      
      override protected function updateText() : void
      {
         var _loc1_:String = null;
         super.updateText();
         if(Boolean(_data) && Boolean(_data.active))
         {
            if(CoreComponent.isArabicAligmentMode)
            {
               textField.text = data.name;
               _loc1_ = textField.text;
               textField.htmlText = "<p align=\"right\">" + _loc1_ + "</p>";
            }
            textField.textColor = ACTIVE_TEXT_COLOR;
            tfStatValue.textColor = ACTIVE_TEXT_COLOR;
         }
         if(!CoreComponent.isArabicAligmentMode)
         {
            if(data.value == "")
            {
               textField.x = tfStatValue.x;
               tfStatValue.text = "";
            }
            else
            {
               textField.x = this.cachedPosition;
            }
         }
         else if(data.value == "")
         {
            textField.x = RIGHT_ANCHOR - textField.textWidth;
            tfStatValue.text = "";
         }
         else
         {
            tfStatValue.x = RIGHT_ANCHOR - tfStatValue.textWidth;
            textField.x = tfStatValue.x - textField.textWidth - 10;
         }
         tfStatValue.y = textField.y + (textField.textHeight - tfStatValue.textHeight) / 2;
      }
   }
}
