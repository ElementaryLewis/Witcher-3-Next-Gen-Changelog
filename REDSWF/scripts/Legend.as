package
{
   import red.game.witcher3.menus.common.JournalLegend;
   
   public dynamic class Legend extends JournalLegend
   {
       
      
      public function Legend()
      {
         super();
         addFrameScript(0,this.frame1);
         this.__setProp_mcFeedbackList_Legend_tfLegend_0();
         this.__setProp_mcFeedbackQuestList_Legend_tfLegend_0();
      }
      
      internal function __setProp_mcFeedbackList_Legend_tfLegend_0() : *
      {
         try
         {
            mcFeedbackList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcFeedbackList.DownAction = 0;
         mcFeedbackList.enabled = true;
         mcFeedbackList.enableInitCallback = false;
         mcFeedbackList.focusable = true;
         mcFeedbackList.itemRendererName = "";
         mcFeedbackList.itemRendererInstanceName = "mcFeedbackListItem";
         mcFeedbackList.margin = 0;
         mcFeedbackList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         mcFeedbackList.rowHeight = 0;
         mcFeedbackList.scrollBar = "";
         mcFeedbackList.UpAction = 0;
         mcFeedbackList.visible = true;
         mcFeedbackList.wrapping = "normal";
         try
         {
            mcFeedbackList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcFeedbackQuestList_Legend_tfLegend_0() : *
      {
         try
         {
            mcFeedbackQuestList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcFeedbackQuestList.DownAction = 0;
         mcFeedbackQuestList.enabled = true;
         mcFeedbackQuestList.enableInitCallback = false;
         mcFeedbackQuestList.focusable = true;
         mcFeedbackQuestList.itemRendererName = "";
         mcFeedbackQuestList.itemRendererInstanceName = "mcFeedbackQuestListItem";
         mcFeedbackQuestList.margin = 0;
         mcFeedbackQuestList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         mcFeedbackQuestList.rowHeight = 0;
         mcFeedbackQuestList.scrollBar = "";
         mcFeedbackQuestList.UpAction = 0;
         mcFeedbackQuestList.visible = true;
         mcFeedbackQuestList.wrapping = "normal";
         try
         {
            mcFeedbackQuestList["componentInspectorSetting"] = false;
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
