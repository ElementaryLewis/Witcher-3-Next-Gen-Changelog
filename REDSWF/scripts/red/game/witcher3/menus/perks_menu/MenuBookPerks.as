package red.game.witcher3.menus.perks_menu
{
   import flash.display.DisplayObject;
   import red.core.CoreMenu;
   import red.core.events.GameEvent;
   import red.game.witcher3.managers.W3DragManager;
   import red.game.witcher3.menus.common.PlayerStatsModule;
   
   public class MenuBookPerks extends CoreMenu
   {
       
      
      public var moduleBooks:ModuleSkillList;
      
      public var moduleSkills:ModuleSkillList;
      
      public var moduleStatistics:PlayerStatsModule;
      
      public var tooltipAnchor:DisplayObject;
      
      public function MenuBookPerks()
      {
         super();
         this.moduleBooks.dataBindingKey = "character.books";
         this.moduleSkills.dataBindingKey = "character.perks";
      }
      
      override protected function get menuName() : String
      {
         return "CharacterPerksMenu";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         W3DragManager.init(stage);
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         _contextMgr.defaultAnchor = this.tooltipAnchor;
         _contextMgr.addGridEventsTooltipHolder(stage);
      }
   }
}
