package red.game.witcher3.tooltips
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.controls.BaseListItem;
   
   public class TooltipPropRenderer extends BaseListItem
   {
      
      protected static const TEXT_PADDING:Number = 4;
       
      
      public var mcIcon:MovieClip;
      
      public var tfStatValue:TextField;
      
      public function TooltipPropRenderer()
      {
         super();
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
         if(!param1)
         {
            visible = false;
            return;
         }
         visible = true;
         var _loc2_:Number = 0;
         if(this.tfStatValue)
         {
            if(param1.value)
            {
               this.tfStatValue.x = 0;
               this.tfStatValue.htmlText = param1.value;
               this.tfStatValue.width = this.tfStatValue.textWidth + CommonConstants.SAFE_TEXT_PADDING;
               _loc2_ += this.tfStatValue.width + TEXT_PADDING;
               this.tfStatValue.visible = true;
            }
            else
            {
               this.tfStatValue.x = 0;
               this.tfStatValue.width = 1;
               this.tfStatValue.text = " ";
               this.tfStatValue.visible = false;
               _loc2_ = TEXT_PADDING;
            }
         }
         if(Boolean(this.mcIcon) && Boolean(param1.type))
         {
            this.mcIcon.x = _loc2_;
            this.mcIcon.gotoAndStop(param1.type);
         }
      }
      
      override public function getRendererWidth() : Number
      {
         var _loc1_:Number = 0;
         if(Boolean(this.mcIcon) && this.mcIcon.visible)
         {
            _loc1_ += this.mcIcon.width;
         }
         if(Boolean(this.tfStatValue) && this.tfStatValue.visible)
         {
            _loc1_ += this.tfStatValue.width + TEXT_PADDING;
         }
         return _loc1_;
      }
   }
}
