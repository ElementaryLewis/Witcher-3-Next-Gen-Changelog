package red.game.witcher3.menus.preparation_menu
{
   import flash.text.TextField;
   import red.core.events.GameEvent;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.controls.StatusIndicator;
   import scaleform.clik.core.UIComponent;
   
   public class ToxicityBar extends UIComponent
   {
       
      
      public var dataBindingKey:String = "preparation.toxicity.bar.";
      
      public var txtTitle:TextField;
      
      public var txtMinValue:TextField;
      
      public var txtMaxValue:TextField;
      
      public var txtValue:TextField;
      
      public var mcProgressBar:StatusIndicator;
      
      public function ToxicityBar()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         focusable = false;
         mouseChildren = mouseEnabled = false;
         dispatchEvent(new GameEvent(GameEvent.REGISTER,this.dataBindingKey + "max",[this.handleMaxValueSet]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,this.dataBindingKey + "value",[this.handleValueSet]));
         this.txtMinValue.text = "0";
         this.mcProgressBar.minimum = 0;
         this.txtTitle.htmlText = "[[panel_preparation_toxicitybar_description]]";
         this.txtTitle.htmlText = CommonUtils.toUpperCaseSafe(this.txtTitle.htmlText);
      }
      
      protected function handleMaxValueSet(value:Number) : void
      {
         this.txtMaxValue.htmlText = value.toString();
         this.mcProgressBar.maximum = value;
      }
      
      protected function handleValueSet(value:int) : void
      {
         this.txtValue.text = value + "%";
         this.mcProgressBar.value = value;
      }
   }
}
