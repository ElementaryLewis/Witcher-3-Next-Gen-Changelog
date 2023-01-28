package red.game.witcher3.menus.blacksmith
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ItemAddSocketInfo extends BlacksmithItemPanel
   {
       
      
      public var txtSockets:TextField;
      
      public var txtSocketsTitle:TextField;
      
      public var priceFrame:MovieClip;
      
      public function ItemAddSocketInfo()
      {
         super();
         this.txtSocketsTitle.text = "[[panel_socket_number_sockets]]";
      }
      
      override public function playErrorAnimation() : void
      {
      }
      
      override protected function updateData() : void
      {
         super.updateData();
         if(_data)
         {
            this.txtSockets.text = _data.socketsCount + " / " + _data.socketsMaxCount;
            this.txtSockets.textColor = !!_data.disableAction ? 6710886 : 14737631;
            this.txtSocketsTitle.textColor = !!_data.disableAction ? 6710886 : 14737631;
            btnExecute.visible = !_data.disableAction;
            txtPriceLabel.visible = !_data.disableAction;
            txtPriceValue.visible = !_data.disableAction;
            mcCoinIcon.visible = !_data.disableAction;
            this.priceFrame.visible = !_data.disableAction;
         }
         updateSlots(_data.socketsCount,imageHolder);
      }
      
      override protected function cleanupView() : void
      {
         super.cleanupView();
         this.txtSockets.text = "";
      }
   }
}
