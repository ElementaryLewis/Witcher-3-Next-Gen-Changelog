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
      
      public function set currentColor(value:String) : void
      {
         if(value != this._currentColor)
         {
            gotoAndPlay(LABEL_START);
            addEventListener(Event.ENTER_FRAME,this.handleEnterFrame,false,0,true);
            if(this._currentColor)
            {
               this.lineStatic.gotoAndStop(this._currentColor);
            }
            this._currentColor = value;
            this.lineAnim.gotoAndStop(this._currentColor);
         }
      }
      
      protected function handleEnterFrame(event:Event) : void
      {
         var completeEvent:SlotConnectorEvent = null;
         if(currentFrameLabel == LABEL_COMPLETE)
         {
            removeEventListener(Event.ENTER_FRAME,this.handleEnterFrame);
            completeEvent = new SlotConnectorEvent(SlotConnectorEvent.EVENT_COMPLETE);
            completeEvent.connectorColor = this._currentColor;
            dispatchEvent(completeEvent);
         }
      }
   }
}
