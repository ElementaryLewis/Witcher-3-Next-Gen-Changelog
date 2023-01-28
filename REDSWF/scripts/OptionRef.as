package
{
   import red.game.witcher3.hud.modules.dialog.Option;
   
   public dynamic class OptionRef extends Option
   {
       
      
      public function OptionRef()
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
