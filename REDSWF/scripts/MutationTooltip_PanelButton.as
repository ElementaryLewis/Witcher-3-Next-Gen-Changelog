package
{
   import red.game.witcher3.menus.character_menu.MutationTooltipButton;
   
   public dynamic class MutationTooltip_PanelButton extends MutationTooltipButton
   {
       
      
      public function MutationTooltip_PanelButton()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
