package red.game.witcher3.menus.character_menu
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import red.game.witcher3.events.SlotConnectorEvent;
   import scaleform.clik.core.UIComponent;
   
   public class SkillSlotConnector extends UIComponent
   {
      
      protected static var LABEL_START:String = "start";
      
      protected static var LABEL_COMPLETE:String = "complete";
       
      
      public var lineAnim:MovieClip;
      
      public var lineStatic:MovieClip;
      
      protected var _currentColor:String;
      
      public function SkillSlotConnector()
      {
         super();
         this._currentColor = "SC_None";
      }
      
      public function get currentColor() : String
      {
         return this._currentColor;
      }
      
      public function set currentColor(param1:String) : void
      {
         if(param1 != this._currentColor)
         {
            trace("GFX ----------------------------------- Foing from color: " + this._currentColor + ", to color: " + param1);
            gotoAndPlay(LABEL_START);
            addEventListener(Event.ENTER_FRAME,this.handleEnterFrame,false,0,true);
            if(this._currentColor)
            {
               this.lineStatic.gotoAndStop(this._currentColor);
            }
            this._currentColor = param1;
            this.lineAnim.gotoAndStop(this._currentColor);
         }
      }
      
      protected function handleEnterFrame(param1:Event) : void
      {
         var _loc2_:SlotConnectorEvent = null;
         if(currentFrameLabel == LABEL_COMPLETE)
         {
            removeEventListener(Event.ENTER_FRAME,this.handleEnterFrame);
            _loc2_ = new SlotConnectorEvent(SlotConnectorEvent.EVENT_COMPLETE);
            _loc2_.connectorColor = this._currentColor;
            dispatchEvent(_loc2_);
         }
      }
   }
}
