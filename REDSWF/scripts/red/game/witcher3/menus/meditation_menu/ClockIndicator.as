package red.game.witcher3.menus.meditation_menu
{
   import flash.display.Sprite;
   import scaleform.clik.core.UIComponent;
   
   public class ClockIndicator extends UIComponent
   {
       
      
      public var indicatorImage:Sprite;
      
      protected var _progress:Number;
      
      public function ClockIndicator()
      {
         super();
      }
      
      public function get progress() : Number
      {
         return this._progress;
      }
      
      public function set progress(param1:Number) : void
      {
         if(this._progress == param1)
         {
            return;
         }
         this._progress = param1;
         this.gotoAndStop(this._progress);
      }
   }
}
