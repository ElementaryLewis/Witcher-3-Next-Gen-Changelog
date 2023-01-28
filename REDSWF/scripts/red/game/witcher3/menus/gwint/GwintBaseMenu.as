package red.game.witcher3.menus.gwint
{
   import red.core.CoreMenu;
   import red.core.events.GameEvent;
   
   public class GwintBaseMenu extends CoreMenu
   {
       
      
      public var _cardManager:CardManager;
      
      public function GwintBaseMenu()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         _restrictDirectClosing = false;
         this._cardManager = CardManager.getInstance();
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"gwint.card.templates",[this.onGetCardTemplates]));
      }
      
      protected function onGetCardTemplates(gameData:Object, index:int) : void
      {
         this._cardManager.onGetCardTemplates(gameData,index);
      }
   }
}
