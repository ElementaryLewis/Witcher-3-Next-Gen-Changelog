package red.game.witcher3.hud.modules
{
   import red.core.events.GameEvent;
   import red.game.witcher3.hud.modules.quests.HudQuestContainer;
   import scaleform.gfx.InteractiveObjectEx;
   
   public class HudModuleQuests extends HudModuleBase
   {
       
      
      public var mcSystemQuestContainer:HudQuestContainer;
      
      public function HudModuleQuests()
      {
         addFrameScript(0,this.frame1);
         super();
         visible = false;
         InteractiveObjectEx.setHitTestDisable(this,true);
         mouseEnabled = tabEnabled = mouseChildren = tabChildren = false;
         this.__setProp_mcSystemQuestContainer_Scene1_mcSystemQuestContainer_0();
      }
      
      override public function get moduleName() : String
      {
         return "QuestsModule";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.alpha = 1;
         registerDataBinding("hud.quest.system.name",this.onSystemQuestNameSet);
         registerDataBinding("hud.quest.system.name.color",this.onSystemQuestNameColorSet);
         registerDataBinding("hud.quest.system.objectives",this.onSystemObjectiveDataSet);
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      public function ShowTrackedQuest(param1:Boolean) : *
      {
         if(param1)
         {
            this.mcSystemQuestContainer.alpha = 1;
            dispatchEvent(new GameEvent(GameEvent.UPDATE,this.moduleName));
         }
         else
         {
            this.mcSystemQuestContainer.alpha = 0;
         }
      }
      
      public function UpdateObjectiveCounter(param1:int, param2:String) : void
      {
         this.mcSystemQuestContainer.UpdateObjectiveCounter(param1,param2);
         dispatchEvent(new GameEvent(GameEvent.UPDATE,this.moduleName));
      }
      
      public function UpdateObjectiveHighlight(param1:int, param2:Boolean) : void
      {
         this.mcSystemQuestContainer.HighlightObjective(param1,param2);
         dispatchEvent(new GameEvent(GameEvent.UPDATE,this.moduleName));
      }
      
      public function UpdateObjectiveUnhighlightAll() : void
      {
         this.mcSystemQuestContainer.UnhighlightAllObjectives();
      }
      
      private function onSystemQuestNameSet(param1:String) : void
      {
         this.mcSystemQuestContainer.onQuestNameSet(param1);
         dispatchEvent(new GameEvent(GameEvent.UPDATE,this.moduleName));
      }
      
      private function onSystemQuestNameColorSet(param1:int) : void
      {
         this.mcSystemQuestContainer.onQuestNameColorSet(param1);
      }
      
      public function SetSystemQuestInfo(param1:String, param2:int, param3:Boolean) : void
      {
         this.mcSystemQuestContainer.onQuestNameSet(param1);
         dispatchEvent(new GameEvent(GameEvent.UPDATE,this.moduleName));
         this.mcSystemQuestContainer.onQuestNameColorSet(param2);
         this.mcSystemQuestContainer.onDifficultyUpdate(param3);
      }
      
      private function onSystemObjectiveDataSet(param1:Object, param2:int) : void
      {
         this.mcSystemQuestContainer.onObjectiveDataSet(param1,param2);
         dispatchEvent(new GameEvent(GameEvent.UPDATE,this.moduleName));
      }
      
      override public function ShowTutorialHighlight(param1:Boolean, param2:String) : *
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(param1)
         {
            if(mcTutorialHighlight)
            {
               _loc5_ = this.mcSystemQuestContainer.mcQuestObjectiveList.tfQuestName.textWidth + 10;
               if(this.mcSystemQuestContainer.mcQuestObjectiveListItem1.tfObjective.textWidth > _loc5_)
               {
                  _loc5_ = this.mcSystemQuestContainer.mcQuestObjectiveListItem1.tfObjective.textWidth + 10;
               }
               _loc6_ = this.mcSystemQuestContainer.mcQuestObjectiveList.tfQuestName.textHeight + this.mcSystemQuestContainer.mcQuestObjectiveListItem1.tfObjective.textHeight + 40;
               mcTutorialHighlight.x = this.mcSystemQuestContainer.x + this.mcSystemQuestContainer.mcQuestObjectiveList.x - 5;
               mcTutorialHighlight.y = this.mcSystemQuestContainer.y;
            }
         }
         super.ShowTutorialHighlight(param1,param2);
      }
      
      internal function __setProp_mcSystemQuestContainer_Scene1_mcSystemQuestContainer_0() : *
      {
         try
         {
            this.mcSystemQuestContainer["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcSystemQuestContainer.enabled = true;
         this.mcSystemQuestContainer.enableInitCallback = false;
         this.mcSystemQuestContainer.QuestType = "system";
         this.mcSystemQuestContainer.visible = true;
         try
         {
            this.mcSystemQuestContainer["componentInspectorSetting"] = false;
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
