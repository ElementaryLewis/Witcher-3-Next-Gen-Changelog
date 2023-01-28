package red.game.witcher3.menus.overlay
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.utils.CommonUtils;
   
   public class ConfirmationPopup extends BasePopup
   {
      
      private static const HEIGHT_PADDING:Number = 10;
      
      private static const INPUT_PADDING:Number = 10;
      
      private static const FINAL_HEIGHT_PADDING:Number = 40;
       
      
      public var txtMessage:TextField;
      
      public var txtTitle:TextField;
      
      public var textBorder:MovieClip;
      
      private var curHeight:Number;
      
      public var mcHeader:MovieClip;
      
      public var mcInputBackground:MovieClip;
      
      public var mcBackground:MovieClip;
      
      public function ConfirmationPopup()
      {
         super();
      }
      
      override protected function populateData() : void
      {
         super.populateData();
         this.txtMessage.htmlText = _data.TextContent;
         this.txtMessage.height = this.txtMessage.textHeight + CommonConstants.SAFE_TEXT_PADDING;
         this.txtTitle.htmlText = CommonUtils.toUpperCaseSafe(_data.TextTitle);
         if(this.txtTitle.text == "")
         {
            this.txtMessage.y = 16.85;
            this.mcHeader.visible = false;
         }
         this.curHeight = this.txtMessage.y + this.txtMessage.textHeight + HEIGHT_PADDING;
         this.mcBackground.height = this.curHeight + FINAL_HEIGHT_PADDING;
         this.mcInputBackground.y = this.mcBackground.height - this.mcInputBackground.height / 2;
         mcInpuFeedback.y = this.mcInputBackground.y + this.mcInputBackground.height / 2;
         mcInpuFeedback.handleSetupButtons(_data.ButtonsList);
         this.mcInputBackground.x = this.mcBackground.width / 2;
         this.mcInputBackground.width = mcInpuFeedback.buttonsContainer.width + INPUT_PADDING;
      }
   }
}
