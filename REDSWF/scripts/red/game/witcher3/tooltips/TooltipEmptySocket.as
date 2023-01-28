package red.game.witcher3.tooltips
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.game.witcher3.constants.CommonConstants;
   
   public class TooltipEmptySocket extends TooltipBase
   {
       
      
      public var tfItemType:TextField;
      
      public var tfDescription:TextField;
      
      public var mcBackground:MovieClip;
      
      public var delTitle:MovieClip;
      
      public function TooltipEmptySocket()
      {
         super();
         visible = false;
      }
      
      override protected function populateData() : void
      {
         var BK_PADDING:* = new Namespace("");
         var MIN_WIDTH:* = new Namespace("");
         super.populateData();
         if(_data)
         {
            applyTextValue(this.tfItemType,_data.ItemType,false,true);
            applyTextValue(this.tfDescription,_data.Description,false,true);
            visible = true;
            BK_PADDING = 10;
            MIN_WIDTH = 175;
            this.tfItemType.width = this.tfItemType.textWidth + CommonConstants.SAFE_TEXT_PADDING;
            this.tfDescription.width = this.tfDescription.textWidth + CommonConstants.SAFE_TEXT_PADDING;
            this.mcBackground.width = Math.max(Math.max(this.tfDescription.textWidth,this.tfItemType.textWidth) + BK_PADDING * 2,MIN_WIDTH);
         }
      }
      
      override public function set backgroundVisibility(value:Boolean) : void
      {
         super.backgroundVisibility = value;
         if(this.mcBackground)
         {
            this.mcBackground.gotoAndStop(_backgroundVisibility ? "solid" : "transparent");
         }
         if(this.delTitle)
         {
            this.delTitle.visible = !value;
         }
      }
   }
}
