package
{
   import red.game.witcher3.controls.W3MessageQueue;
   
   public dynamic class mcStateMessage extends W3MessageQueue
   {
       
      
      public function mcStateMessage()
      {
         super();
         addFrameScript(4,this.frame5,72,this.frame73);
      }
      
      internal function frame5() : *
      {
         stop();
      }
      
      internal function frame73() : *
      {
         gotoAndPlay("Idle");
         OnShowMessageEnded();
      }
   }
}
