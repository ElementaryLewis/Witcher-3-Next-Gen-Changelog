package red.game.witcher3.tooltips
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import red.game.witcher3.interfaces.IAnchorable;
   import scaleform.gfx.Extensions;
   
   public class TooltipSimple extends TooltipBase implements IAnchorable
   {
       
      
      protected const SAFE_TEXT_PADDING:Number = 5;
      
      protected const BLOCK_PADDING:Number = 5;
      
      protected const BOTTOM_PADDING:Number = 5;
      
      public var tfName:TextField;
      
      public var tfDescription:TextField;
      
      public var delDescription:Sprite;
      
      public var delTitle:Sprite;
      
      public var mcBackground:Sprite;
      
      public function TooltipSimple()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         if(!Extensions.isScaleform)
         {
            this.applyDebugData();
         }
      }
      
      override protected function populateData() : void
      {
         super.populateData();
         if(!_data)
         {
            return;
         }
         this.populateTooltipData();
         trace("HUD Tooltip Simple populateData ");
      }
      
      protected function populateTooltipData() : *
      {
         var currentHeightLeft:Number = NaN;
         var currentHeightRight:Number = NaN;
         var currentHeight:Number = this.delTitle.y + this.BLOCK_PADDING;
         trace("HUD Tooltip Simple populateTooltipData ");
         applyTextValue(this.tfName,_data.label,true,true);
         this.showDescription(currentHeight);
         if(this.tfDescription.htmlText.length > 0)
         {
            this.delDescription.visible = true;
            this.delDescription.y = this.tfDescription.y + this.tfDescription.height + this.BLOCK_PADDING;
            currentHeight = this.delDescription.y + this.delDescription.height;
         }
         else
         {
            this.delDescription.visible = false;
         }
         currentHeight += this.BLOCK_PADDING;
         this.mcBackground.height = Math.max(currentHeightLeft = currentHeight,currentHeightLeft);
      }
      
      protected function showDescription(vertOffset:Number) : void
      {
         var descriptionText:String = "";
         var commonDescription:String = String(_data.description);
         var uniqDescription:String = String(_data.UniqueDescription);
         if(commonDescription)
         {
            descriptionText = commonDescription;
         }
         if(uniqDescription)
         {
            if(descriptionText.length > 0)
            {
               descriptionText += "<br>" + uniqDescription;
            }
            else
            {
               descriptionText += uniqDescription;
            }
         }
         trace("Tooltip Simple showDescription " + descriptionText + " .");
         this.tfDescription.y = vertOffset;
         this.tfDescription.htmlText = descriptionText;
         this.tfDescription.height = this.tfDescription.textHeight + this.SAFE_TEXT_PADDING;
      }
      
      protected function applyDebugData() : void
      {
      }
   }
}
