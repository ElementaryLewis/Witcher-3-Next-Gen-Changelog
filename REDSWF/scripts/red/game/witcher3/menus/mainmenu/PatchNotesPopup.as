package red.game.witcher3.menus.mainmenu
{
   import scaleform.clik.core.UIComponent;
   
   public class PatchNotesPopup extends UIComponent
   {
       
      
      public var mcInfoModule1:PatchNotesInfoBlock;
      
      public var mcInfoModule2:PatchNotesInfoBlock;
      
      public var mcInfoModule3:PatchNotesInfoBlock;
      
      public var mcInfoModule4:PatchNotesInfoBlock;
      
      public var mcInfoModule5:PatchNotesInfoBlock;
      
      public var mcInfoModule6:PatchNotesInfoBlock;
      
      public function PatchNotesPopup()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      public function SetupData() : *
      {
         if(this.mcInfoModule1)
         {
            this.mcInfoModule1.setData("graphical_modes_xss");
         }
         this.mcInfoModule2.setData("new_content");
         this.mcInfoModule3.setData("photo_mode");
         this.mcInfoModule4.setData("cross_progression");
         this.mcInfoModule5.setData("mods");
         this.mcInfoModule6.setData("controls");
      }
   }
}
