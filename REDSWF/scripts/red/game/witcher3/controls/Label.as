package red.game.witcher3.controls
{
   import scaleform.clik.controls.Label;
   
   public class Label extends scaleform.clik.controls.Label
   {
       
      
      public function Label()
      {
         super();
      }
      
      override public function get focused() : Number
      {
         return super.focused;
      }
      
      override public function set focused(param1:Number) : void
      {
         if(param1 == super.focused || !super.focusable)
         {
            return;
         }
         super.focused = param1;
         setState(defaultState);
      }
      
      override public function set text(param1:String) : void
      {
         if(param1 == null)
         {
            param1 == "";
         }
         isHtml = false;
         _text = param1;
         invalidateData();
      }
   }
}
