package red.game.witcher3.tooltips
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.controls.RenderersList;
   
   public class TooltipDescription extends TooltipBase
   {
       
      
      public var tfItemName:TextField;
      
      public var tfItemType:TextField;
      
      public var tfDescription:TextField;
      
      public var propsList:RenderersList;
      
      public var listStats:RenderersList;
      
      public var delTitle:Sprite;
      
      public function TooltipDescription()
      {
         super();
         visible = false;
      }
      
      override protected function populateData() : void
      {
         var commonDescription:String = null;
         super.populateData();
         if(!_data)
         {
            return;
         }
         var descriptionText:String = "";
         commonDescription = String(_data.description);
         var uniqDescription:String = String(_data.UniqueDescription);
         visible = true;
         applyTextValue(this.tfItemType,_data.ItemType,false,true);
         applyTextValue(this.tfItemName,_data.ItemName,true,true);
         var ONE_LINE_NAME_Y:* = 6;
         var TWO_LINES_NAME_Y:* = -16;
         var ONE_LINE_HEIGHT:* = 30;
         this.tfItemName.height = this.tfItemName.textHeight + CommonConstants.SAFE_TEXT_PADDING;
         if(this.tfItemName.textHeight > ONE_LINE_HEIGHT)
         {
            this.tfItemName.y = TWO_LINES_NAME_Y;
         }
         else
         {
            this.tfItemName.y = ONE_LINE_NAME_Y;
         }
         this.propsList.dataList = _data.PropertiesList as Array;
         if(Boolean(commonDescription) && commonDescription.charAt(0) != "#")
         {
            descriptionText = commonDescription;
         }
         if(Boolean(uniqDescription) && uniqDescription.charAt(0) != "#")
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
         applyTextValue(this.tfDescription,descriptionText,false,true);
         this.tfDescription.height = this.tfDescription.textHeight + CommonConstants.SAFE_TEXT_PADDING;
         if(Boolean(this.listStats) && Boolean(_data.StatsList))
         {
            this.listStats.visible = true;
            this.delTitle.visible = true;
            this.listStats.dataList = _data.StatsList;
            this.listStats.y = this.tfDescription.y + this.tfDescription.textHeight + 15;
         }
         else
         {
            this.listStats.visible = false;
            this.delTitle.visible = false;
         }
      }
   }
}
