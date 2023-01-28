package
{
   import red.game.witcher3.hud.modules.iteminfo.HudPotionKeyboardInfo;
   
   public dynamic class PotionKeyboardInfo extends HudPotionKeyboardInfo
   {
       
      
      public function PotionKeyboardInfo()
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
