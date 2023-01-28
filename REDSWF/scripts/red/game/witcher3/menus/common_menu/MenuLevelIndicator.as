package red.game.witcher3.menus.common_menu
{
   import flash.text.TextField;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.controls.StatusIndicator;
   import scaleform.clik.core.UIComponent;
   
   public class MenuLevelIndicator extends UIComponent
   {
       
      
      public var tfValue:TextField;
      
      public var tfLabel:TextField;
      
      public var txtExp:TextField;
      
      public var levelProgress:StatusIndicator;
      
      public function MenuLevelIndicator()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.tfLabel.htmlText = "[[panel_inventory_level]]";
         this.tfLabel.htmlText = CommonUtils.toUpperCaseSafe(this.tfLabel.htmlText);
         if(this.txtExp)
         {
            this.txtExp.text = "";
         }
      }
      
      public function setLevel(param1:String) : void
      {
         this.tfValue.text = param1;
      }
      
      public function setLevelProgress(param1:Number, param2:Number) : void
      {
         this.levelProgress.maximum = param2;
         this.levelProgress.value = param1;
         if(this.txtExp)
         {
            this.txtExp.text = param1.toString() + "/" + param2.toString();
         }
      }
   }
}
