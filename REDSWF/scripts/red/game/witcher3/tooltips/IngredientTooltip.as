package red.game.witcher3.tooltips
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.core.constants.KeyCode;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.NavigationCode;
   
   public class IngredientTooltip extends TooltipBase
   {
       
      
      private const ICON_PADDING:Number = 8;
      
      private const BK_PADDING:Number = 20;
      
      public var btnBuy:InputFeedbackButton;
      
      public var mcCoinIcon:MovieClip;
      
      public var mcBackground:MovieClip;
      
      public var tfItemName:TextField;
      
      public var tfItemType:TextField;
      
      public function IngredientTooltip()
      {
         super();
         visible = false;
         this.mcCoinIcon.visible = false;
         this.btnBuy.visible = false;
      }
      
      override protected function populateData() : void
      {
         var bkWidth:Number = NaN;
         var btnWidth:Number = NaN;
         var btnHeight:Number = NaN;
         var vendorInfoWidth:Number = NaN;
         super.populateData();
         if(!_data)
         {
            return;
         }
         visible = true;
         this.tfItemName.text = CommonUtils.toUpperCaseSafe(_data.ItemName);
         this.tfItemName.width = this.tfItemName.textWidth + CommonConstants.SAFE_TEXT_PADDING;
         this.tfItemType.htmlText = CommonUtils.toUpperCaseSafe(_data.ItemType);
         this.tfItemType.width = this.tfItemType.textWidth + CommonConstants.SAFE_TEXT_PADDING;
         var bkHeight:Number = this.tfItemType.y + this.tfItemType.height + this.BK_PADDING;
         if(_data.vendorPrice)
         {
            this.btnBuy.clickable = false;
            this.btnBuy.label = _data.vendorInfoText;
            this.btnBuy.setDataFromStage(NavigationCode.GAMEPAD_Y,KeyCode.RIGHT_MOUSE);
            this.btnBuy.validateNow();
            this.btnBuy.visible = true;
            btnWidth = this.btnBuy.getViewWidth();
            btnHeight = 40;
            vendorInfoWidth = btnWidth + this.mcCoinIcon.width + this.ICON_PADDING;
            this.mcCoinIcon.x = this.btnBuy.x + btnWidth + this.ICON_PADDING;
            this.mcCoinIcon.visible = true;
            bkHeight = this.btnBuy.y + btnHeight;
            bkWidth = Math.max(vendorInfoWidth,Math.max(this.tfItemName.width,this.tfItemType.width));
         }
         else
         {
            this.btnBuy.visible = false;
            this.mcCoinIcon.visible = false;
            bkWidth = Math.max(this.tfItemName.width,this.tfItemType.width);
         }
         this.mcBackground.width = bkWidth + this.BK_PADDING;
         this.mcBackground.height = bkHeight;
      }
   }
}
