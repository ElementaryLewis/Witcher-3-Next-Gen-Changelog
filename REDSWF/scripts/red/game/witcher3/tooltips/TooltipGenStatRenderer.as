package red.game.witcher3.tooltips
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.controls.BaseListItem;
   
   public class TooltipGenStatRenderer extends BaseListItem
   {
      
      protected static const TEXT_VALUE_PADDING:Number = 5;
       
      
      public var mcComparisonIcon:MovieClip;
      
      public var mcStatIcon:MovieClip;
      
      public var tfValue:TextField;
      
      public function TooltipGenStatRenderer()
      {
         super();
         if(this.mcComparisonIcon)
         {
            this.mcComparisonIcon.visible = false;
         }
         if(this.mcStatIcon)
         {
            this.mcStatIcon.visible = false;
         }
         if(this.tfValue)
         {
            this.tfValue.visible = false;
         }
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
         if(this.mcStatIcon)
         {
            if(param1.type)
            {
               this.mcStatIcon.gotoAndStop(param1.type);
               this.mcStatIcon.visible = true;
            }
            else
            {
               this.mcStatIcon.visible = false;
            }
         }
         if(this.tfValue)
         {
            if(param1.value)
            {
               this.tfValue.visible = true;
               this.tfValue.text = String(param1.value);
               this.tfValue.width = this.tfValue.textWidth + CommonConstants.SAFE_TEXT_PADDING;
            }
            else
            {
               this.tfValue.visible = false;
            }
         }
         if(this.mcComparisonIcon)
         {
            if(param1.icon)
            {
               this.mcComparisonIcon.gotoAndStop(param1.icon);
               this.mcComparisonIcon.visible = true;
               if(Boolean(this.tfValue) && this.tfValue.visible)
               {
                  this.mcComparisonIcon.x = this.tfValue.x + this.tfValue.textWidth + TEXT_VALUE_PADDING;
               }
               else
               {
                  this.mcComparisonIcon.x = this.tfValue.x + TEXT_VALUE_PADDING;
               }
            }
            else
            {
               this.mcComparisonIcon.visible = false;
            }
         }
      }
      
      override public function getRendererWidth() : Number
      {
         var _loc1_:Number = 0;
         if(this.mcStatIcon.visible)
         {
            _loc1_ += this.mcStatIcon.width;
         }
         if(Boolean(this.tfValue) && this.tfValue.visible)
         {
            _loc1_ += this.tfValue.textWidth;
         }
         if(this.mcComparisonIcon.visible)
         {
            _loc1_ += this.mcComparisonIcon.width + TEXT_VALUE_PADDING;
         }
         return _loc1_;
      }
   }
}
