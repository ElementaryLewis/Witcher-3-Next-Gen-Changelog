package red.game.witcher3.menus.common_menu
{
   import flash.text.TextField;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.core.UIComponent;
   
   public class TextInfoItem extends UIComponent
   {
       
      
      public var tfTop:TextField;
      
      public var tfBottom:TextField;
      
      private var _gap:Number;
      
      public function TextInfoItem()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         this._gap = 10;
         super.configUI();
      }
      
      public function SetEntryTopText(param1:String) : void
      {
         this.tfTop.htmlText = param1;
         this.tfTop.htmlText = CommonUtils.toUpperCaseSafe(this.tfTop.htmlText);
         this.tfBottom.y = this.tfTop.y + this.tfTop.textHeight + this._gap;
      }
      
      public function SetEntryBottomText(param1:String) : void
      {
         this.tfBottom.htmlText = param1;
         this.tfBottom.htmlText = CommonUtils.toUpperCaseSafe(this.tfBottom.htmlText);
      }
   }
}
