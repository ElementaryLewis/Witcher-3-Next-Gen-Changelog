package red.game.witcher3.menus.mainmenu
{
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.BaseListItem;
   import scaleform.clik.events.ListEvent;
   
   public class MainDbgStartQuestSubMenu extends MainSubMenu
   {
       
      
      public function MainDbgStartQuestSubMenu()
      {
         addFrameScript(0,this.frame1);
         super();
         dataBindingKey = "mainmenu.quests.entries";
         this.__setProp_mcMenuList_Scene1_mcMenuList_0();
      }
      
      override protected function get menuName() : String
      {
         return "MainDbgStartQuestMenu";
      }
      
      override protected function closeMenu() : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnBack"));
      }
      
      private function onItemClicked(param1:ListEvent) : void
      {
         var _loc2_:BaseListItem = mcMenuList.getRendererAt(param1.index,mcMenuList.scrollPosition) as BaseListItem;
         if(_loc2_)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnStartQuest",[_loc2_.data.tag]));
         }
      }
      
      internal function __setProp_mcMenuList_Scene1_mcMenuList_0() : *
      {
         try
         {
            mcMenuList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcMenuList.DownAction = 40;
         mcMenuList.enabled = true;
         mcMenuList.enableInitCallback = false;
         mcMenuList.focusable = true;
         mcMenuList.itemRendererName = "";
         mcMenuList.itemRendererInstanceName = "mcMenuListItem";
         mcMenuList.margin = 0;
         mcMenuList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         mcMenuList.rowHeight = 40;
         mcMenuList.scrollBar = "mcScrollbar";
         mcMenuList.UpAction = 38;
         mcMenuList.visible = true;
         mcMenuList.wrapping = "wrap";
         try
         {
            mcMenuList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
