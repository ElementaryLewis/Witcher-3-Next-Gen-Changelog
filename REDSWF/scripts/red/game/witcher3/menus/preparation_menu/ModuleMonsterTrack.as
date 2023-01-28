package red.game.witcher3.menus.preparation_menu
{
   import red.core.CoreMenuModule;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.menus.common.JournalRewards;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class ModuleMonsterTrack extends CoreMenuModule
   {
       
      
      public var mcHeader:TrackedMonsterHeader;
      
      public var mcMonsterInfo:TrackedMonsterInfo;
      
      public var mcMonsterRecommend:TrackedMonsterRecommend;
      
      public var mcRewards:JournalRewards;
      
      protected var trackedMonsterData:Object;
      
      public function ModuleMonsterTrack()
      {
         super();
         if(this.mcRewards)
         {
            this.mcRewards.titleString = "[[panel_glossary_recommended]]";
            this.mcRewards.dataBindingKeyReward = "tracked.monster.recommended.items";
            this.mcRewards.mcRewardGrid.focusable = false;
            this.mcRewards.activeSelectionVisible = false;
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"preparation.tracked.monster.info",[this.setTrackedMonsterInfo]));
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         if(this.mcRewards)
         {
            this.mcRewards.visible = false;
         }
      }
      
      override public function hasSelectableItems() : Boolean
      {
         return this.mcMonsterInfo.mcScrollbar.visible;
      }
      
      protected function setTrackedMonsterInfo(monsterData:Object) : void
      {
         this.trackedMonsterData = monsterData;
         this.mcHeader.setupMonsterInfo(this.trackedMonsterData);
         this.mcMonsterInfo.setupMonsterInfo(this.trackedMonsterData);
         this.mcMonsterRecommend.setupMonsterInfo(this.trackedMonsterData);
      }
      
      override public function set focused(value:Number) : void
      {
         super.focused = value;
         if(this.mcRewards)
         {
            this.mcRewards.activeSelectionVisible = value != 0;
         }
      }
      
      override public function handleInput(event:InputEvent) : void
      {
         if(!focused || event.handled)
         {
            return;
         }
         var details:InputDetails = event.details;
         if(details.code == KeyCode.PAD_RIGHT_STICK_AXIS)
         {
            this.mcMonsterInfo.txtDescription.handleInput(event);
         }
         if(this.mcRewards)
         {
            this.mcRewards.handleInput(event);
         }
      }
   }
}
