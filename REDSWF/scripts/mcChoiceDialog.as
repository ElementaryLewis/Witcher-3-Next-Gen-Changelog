package
{
   import red.game.witcher3.controls.W3ChoiceDialog;
   
   public dynamic class mcChoiceDialog extends W3ChoiceDialog
   {
       
      
      public function mcChoiceDialog()
      {
         super();
         this.__setProp_cardsCarousel_mcChoiceDialog_Carousel_0();
      }
      
      internal function __setProp_cardsCarousel_mcChoiceDialog_Carousel_0() : *
      {
         try
         {
            cardsCarousel["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         cardsCarousel.displayItemsCount = 5;
         cardsCarousel.enabled = true;
         cardsCarousel.enableInitCallback = false;
         cardsCarousel.slotRendererName = "CardSlotRef";
         cardsCarousel.visible = true;
         try
         {
            cardsCarousel["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
