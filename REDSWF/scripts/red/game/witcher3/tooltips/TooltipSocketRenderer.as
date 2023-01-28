package red.game.witcher3.tooltips
{
   import flash.display.MovieClip;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import red.core.CoreComponent;
   
   public class TooltipSocketRenderer extends TooltipStatRenderer
   {
       
      
      protected var SOCKET_ICON_PADDING:Number = 8;
      
      protected var SOCKET_SMALL_PADDING:Number = 10;
      
      protected var TEXT_ICON_PADDING:Number = 15;
      
      protected var RIGHT_ANCHOR:Number = 415;
      
      protected var TEXTFIELD_LENGTH:Number = 320;
      
      public var mcIcon:MovieClip;
      
      private var tempValue:String;
      
      public function TooltipSocketRenderer()
      {
         super();
         if(this.mcIcon)
         {
            _iconShift = this.mcIcon.width + this.SOCKET_ICON_PADDING;
         }
      }
      
      override protected function updateText() : void
      {
         var format:TextFormat = null;
         if(Boolean(this.mcIcon) && Boolean(data.type))
         {
            if(!CoreComponent.isArabicAligmentMode)
            {
               this.mcIcon.x = 0;
            }
            else
            {
               this.mcIcon.x = this.RIGHT_ANCHOR;
            }
            this.mcIcon.gotoAndStop(data.type);
         }
         super.updateText();
         if(!CoreComponent.isArabicAligmentMode)
         {
            tfStatValue.x = this.mcIcon.x + this.mcIcon.width + this.SOCKET_ICON_PADDING;
         }
         else
         {
            format = new TextFormat();
            format.align = TextFormatAlign.RIGHT;
            tfStatValue.x = this.mcIcon.x - this.mcIcon.width / 3 - tfStatValue.textWidth;
            textField.setTextFormat(format);
         }
      }
      
      override protected function updateTextFieldSize() : void
      {
         super.updateTextFieldSize();
         if(data.type == "empty")
         {
            if(!CoreComponent.isArabicAligmentMode)
            {
               tfStatValue.x = this.mcIcon.x + this.mcIcon.width + this.SOCKET_ICON_PADDING;
            }
            else
            {
               tfStatValue.x = this.mcIcon.x - tfStatValue.textWidth - this.SOCKET_SMALL_PADDING;
            }
         }
         else if(tfStatValue)
         {
            if(data.value)
            {
               tfStatValue.visible = true;
               if(CoreComponent.isArabicAligmentMode)
               {
                  textField.x = tfStatValue.x - (textField.width * 2 - textField.textWidth);
               }
            }
            else
            {
               tfStatValue.visible = false;
               if(CoreComponent.isArabicAligmentMode)
               {
                  textField.x = this.mcIcon.x - this.mcIcon.width - this.SOCKET_ICON_PADDING;
               }
               else
               {
                  textField.x = this.mcIcon.x + this.mcIcon.width + this.SOCKET_ICON_PADDING;
               }
            }
         }
      }
   }
}
