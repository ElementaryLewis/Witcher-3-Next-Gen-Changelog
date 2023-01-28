package red.game.witcher3.hud.modules.radialmenu
{
   import flash.text.TextField;
   import scaleform.clik.core.UIComponent;
   
   public class RadialMenuItemCounter extends UIComponent
   {
       
      
      public var tfValue:TextField;
      
      private var _maximum:int;
      
      private var _value:int;
      
      public function RadialMenuItemCounter()
      {
         super();
         visible = false;
      }
      
      public function get maximum() : int
      {
         return this._maximum;
      }
      
      public function set maximum(param1:int) : void
      {
         this._maximum = param1;
         this.updateVisuals();
      }
      
      public function get value() : int
      {
         return this._value;
      }
      
      public function set value(param1:int) : void
      {
         this._value = param1;
         this.updateVisuals();
      }
      
      protected function updateVisuals() : void
      {
         if(this._maximum < 2)
         {
            visible = false;
         }
         else
         {
            visible = true;
            this._value = Math.min(Math.max(1,this._value),this._maximum);
            this.tfValue.text = "< " + this._value + "/" + this._maximum + " >";
         }
      }
   }
}
