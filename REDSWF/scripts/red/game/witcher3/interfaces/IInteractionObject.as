package red.game.witcher3.interfaces
{
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.interfaces.IUIComponent;
   
   public interface IInteractionObject extends IUIComponent
   {
       
      
      function executeAction(param1:Number, param2:InputEvent) : Boolean;
   }
}
