package
{
   import red.game.witcher3.controls.KeyboardButtonMouseIcon;
   
   public dynamic class InputFeedbackButton_mouseIcon extends KeyboardButtonMouseIcon
   {
       
      
      public function InputFeedbackButton_mouseIcon()
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
