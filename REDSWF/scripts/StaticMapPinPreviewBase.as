package
{
   import red.game.witcher3.menus.worldmap.StaticMapPinPreviewDescribed;
   
   public dynamic class StaticMapPinPreviewBase extends StaticMapPinPreviewDescribed
   {
       
      
      public function StaticMapPinPreviewBase()
      {
         super();
         addFrameScript(0,this.frame1,10,this.frame11,20,this.frame21,30,this.frame31,40,this.frame41,50,this.frame51);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame11() : *
      {
         stop();
      }
      
      internal function frame21() : *
      {
         stop();
      }
      
      internal function frame31() : *
      {
         stop();
      }
      
      internal function frame41() : *
      {
         stop();
      }
      
      internal function frame51() : *
      {
         stop();
      }
   }
}
