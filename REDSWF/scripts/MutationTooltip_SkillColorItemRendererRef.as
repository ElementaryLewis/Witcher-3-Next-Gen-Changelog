package
{
   import red.game.witcher3.menus.character_menu.SkillColorRenderer;
   
   public dynamic class MutationTooltip_SkillColorItemRendererRef extends SkillColorRenderer
   {
       
      
      public function MutationTooltip_SkillColorItemRendererRef()
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
