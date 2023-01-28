package
{
   import red.game.witcher3.menus.common.W3VideoObject;
   
   public dynamic class VideoObject extends W3VideoObject
   {
       
      
      public function VideoObject()
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
