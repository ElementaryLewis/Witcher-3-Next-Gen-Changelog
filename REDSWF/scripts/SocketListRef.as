package
{
   import red.game.witcher3.controls.RenderersList;
   
   public dynamic class SocketListRef extends RenderersList
   {
       
      
      public function SocketListRef()
      {
         super();
         addFrameScript(9,this.frame10,19,this.frame20,29,this.frame30);
      }
      
      internal function frame10() : *
      {
         stop();
      }
      
      internal function frame20() : *
      {
         stop();
      }
      
      internal function frame30() : *
      {
         stop();
      }
   }
}
