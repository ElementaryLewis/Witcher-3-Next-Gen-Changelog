package red.game.witcher3.controls
{
   import scaleform.clik.core.UIComponent;
   
   public class KeyboardButtonClickArea extends UIComponent
   {
       
      
      protected var _state:String;
      
      public function KeyboardButtonClickArea()
      {
         super();
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      public function set state(param1:String) : void
      {
         var _loc2_:String = param1;
         if(!_labelHash[_loc2_])
         {
            _loc2_ = "up";
         }
         if(this._state != _loc2_)
         {
            this._state = _loc2_;
            gotoAndPlay(this._state);
         }
      }
   }
}
