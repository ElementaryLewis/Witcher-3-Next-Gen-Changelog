package red.game.witcher3.menus.common
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.controls.InputFeedbackButton;
   import scaleform.clik.core.UIComponent;
   
   public class PaidAction extends UIComponent
   {
       
      
      protected const TEXT_PADDING:Number = 10;
      
      public var tfPriceLabel:TextField;
      
      public var tfPriceValue:TextField;
      
      public var mcCoinIcon:MovieClip;
      
      public var btnAction:InputFeedbackButton;
      
      protected var _price:Number;
      
      public function PaidAction()
      {
         super();
         if(this.tfPriceLabel)
         {
            this.tfPriceLabel.text = "[[panel_inventory_item_price]]";
            this.tfPriceLabel.width = this.tfPriceLabel.textWidth + CommonConstants.SAFE_TEXT_PADDING;
            this.tfPriceLabel.visible = false;
         }
         this.tfPriceValue.visible = false;
         this.mcCoinIcon.visible = false;
      }
      
      public function get price() : Number
      {
         return this._price;
      }
      
      public function set price(param1:Number) : void
      {
         this._price = param1;
         var _loc2_:* = this._price > 0;
         if(!_loc2_)
         {
            this.tfPriceValue.visible = false;
            this.mcCoinIcon.visible = false;
         }
         else
         {
            this.tfPriceValue.visible = true;
            this.mcCoinIcon.visible = true;
            this.tfPriceValue.text = String(this._price);
            this.mcCoinIcon.x = this.tfPriceValue.x + this.tfPriceValue.textWidth + this.TEXT_PADDING;
         }
         if(this.tfPriceLabel)
         {
            this.tfPriceLabel.visible = _loc2_;
         }
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         this.btnAction.enabled = param1;
      }
   }
}
