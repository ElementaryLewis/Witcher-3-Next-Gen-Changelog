package
{
   import red.game.witcher3.menus.common.JournalRewards;
   
   public dynamic class Rewards extends JournalRewards
   {
       
      
      public function Rewards()
      {
         super();
         addFrameScript(0,this.frame1);
         this.__setProp_mcRewardGrid_Rewards_mcRewardGrid_0();
      }
      
      internal function __setProp_mcRewardGrid_Rewards_mcRewardGrid_0() : *
      {
         try
         {
            mcRewardGrid["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcRewardGrid.columns = 4;
         mcRewardGrid.elementGridSquareOffset = 10;
         mcRewardGrid.enabled = true;
         mcRewardGrid.enableInitCallback = false;
         mcRewardGrid.gridSquareSize = 80;
         mcRewardGrid.rows = 1;
         mcRewardGrid.scrollBar = "";
         mcRewardGrid.slotRendererName = "RewardSlot";
         mcRewardGrid.visible = true;
         try
         {
            mcRewardGrid["componentInspectorSetting"] = false;
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
