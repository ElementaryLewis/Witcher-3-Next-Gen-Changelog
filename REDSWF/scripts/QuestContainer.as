package
{
   import red.game.witcher3.hud.modules.quests.HudQuestContainer;
   
   public dynamic class QuestContainer extends HudQuestContainer
   {
       
      
      public function QuestContainer()
      {
         super();
         addFrameScript(0,this.frame1);
         this.__setProp_mcQuestObjectiveList_QuestContainer_mcQuestObjectiveList_0();
      }
      
      internal function __setProp_mcQuestObjectiveList_QuestContainer_mcQuestObjectiveList_0() : *
      {
         try
         {
            mcQuestObjectiveList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcQuestObjectiveList.enabled = true;
         mcQuestObjectiveList.enableInitCallback = false;
         mcQuestObjectiveList.focusable = false;
         mcQuestObjectiveList.itemRendererName = "";
         mcQuestObjectiveList.itemRendererInstanceName = "mcQuestObjectiveListItem";
         mcQuestObjectiveList.margin = 0;
         mcQuestObjectiveList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         mcQuestObjectiveList.rowHeight = 0;
         mcQuestObjectiveList.scrollBar = "";
         mcQuestObjectiveList.visible = true;
         mcQuestObjectiveList.wrapping = "normal";
         try
         {
            mcQuestObjectiveList["componentInspectorSetting"] = false;
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
