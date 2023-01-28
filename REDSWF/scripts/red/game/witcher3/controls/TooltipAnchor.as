package red.game.witcher3.controls
{
   import scaleform.clik.core.UIComponent;
   
   public class TooltipAnchor extends UIComponent
   {
       
      
      private var _alignment:String = "BottomRight";
      
      public function TooltipAnchor()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         mouseEnabled = mouseChildren = false;
         visible = false;
      }
      
      public function get alignment() : String
      {
         return this._alignment;
      }
      
      public function set alignment(param1:String) : void
      {
         this._alignment = param1;
      }
   }
}
