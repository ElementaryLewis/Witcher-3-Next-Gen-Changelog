package
{
   import flash.display.MovieClip;
   
   public dynamic class QuestDirectionCurrentMain extends MovieClip
   {
       
      
      public var mcUser:MovieClip;
      
      public var mcHighlightedQuest:MovieClip;
      
      public var mcRegularQuest:MovieClip;
      
      public function QuestDirectionCurrentMain()
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
