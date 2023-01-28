package red.game.witcher3.menus.infopopup
{
   import red.core.CoreMenu;
   import red.core.events.GameEvent;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class InformationPopupMenu extends CoreMenu
   {
       
      
      public var mcInfoPopupModule:InformationPopup;
      
      public function InformationPopupMenu()
      {
         super();
         _inputHandlers = new Vector.<UIComponent>();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         _inputHandlers.push(this.mcInfoPopupModule);
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      override protected function get menuName() : String
      {
         return "InformationPopupMenu";
      }
      
      override public function toString() : String
      {
         return "[W3 InfoPopupMenu: ]";
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = param1.details;
         var _loc3_:Boolean = _loc2_.value == InputValue.KEY_DOWN || _loc2_.value == InputValue.KEY_HOLD;
         if(_loc3_)
         {
            switch(_loc2_.navEquivalent)
            {
               case this.mcInfoPopupModule.btnFirst.navigationCode:
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnFirstButtonPress"));
                  break;
               case this.mcInfoPopupModule.btnSecond.navigationCode:
                  if(this.mcInfoPopupModule.bTwoButtons)
                  {
                     dispatchEvent(new GameEvent(GameEvent.CALL,"OnSecondButtonPress"));
                  }
            }
         }
      }
   }
}
