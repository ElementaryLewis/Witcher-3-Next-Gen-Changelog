package red.game.witcher3.menus.overlay
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.gfx.Extensions;
   
   public class PriceConfirmationPopup extends BasePopup
   {
      
      private static const ICON_PADDING:Number = 2;
      
      private static const PRICETEXT_PADDING:Number = 14;
      
      private static const TITLE_PADDING:Number = 10;
      
      private static const BUTTONS_PADDING:Number = 30;
      
      private static const BOTTOM_PADDING:Number = 10;
       
      
      public var tfMessage:TextField;
      
      public var tfTitle:TextField;
      
      public var tfPriceValue:TextField;
      
      public var mcPriceIcon:Sprite;
      
      public var mcBackground:Sprite;
      
      public var textBorder:MovieClip;
      
      public function PriceConfirmationPopup()
      {
         super();
         this.cleanup();
         if(!Extensions.isScaleform)
         {
            this.startDebugMode();
         }
      }
      
      override protected function populateData() : void
      {
         super.populateData();
         this.cleanup();
         this.tfTitle.htmlText = CommonUtils.toUpperCaseSafe(_data.TextTitle);
         var _loc1_:Number = Number(_data.ItempPrice);
         if(!isNaN(_loc1_) && _loc1_ > 0)
         {
            this.tfPriceValue.text = _loc1_.toString();
            this.mcPriceIcon.visible = true;
         }
         this.tfMessage.htmlText = _data.TextContent;
         this.tfMessage.height = this.tfMessage.textHeight + CommonConstants.SAFE_TEXT_PADDING;
         this.tfMessage.y = this.textBorder.y + this.textBorder.height / 2 - this.tfMessage.textHeight / 2;
         if(_data.ButtonsList)
         {
            mcInpuFeedback.handleSetupButtons(_data.ButtonsList);
         }
      }
      
      private function cleanup() : void
      {
         this.tfMessage.text = "";
         this.tfTitle.text = "";
         this.tfPriceValue.text = "";
         this.mcPriceIcon.visible = false;
      }
      
      private function startDebugMode() : void
      {
         var _loc1_:Object = {};
         _loc1_.ItempPrice = 468;
         _loc1_.TextTitle = "Test title";
         _loc1_.TextContent = "Test message";
         data = _loc1_;
      }
   }
}
