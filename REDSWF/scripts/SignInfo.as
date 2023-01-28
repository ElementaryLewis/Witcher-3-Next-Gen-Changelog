package
{
   import red.game.witcher3.hud.modules.signinfo.HudItemInfo;
   
   public dynamic class SignInfo extends HudItemInfo
   {
       
      
      public function SignInfo()
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
