package red.game.witcher3.menus.meditation
{
   import flash.display.MovieClip;
   import red.core.CoreMenu;
   import red.core.events.GameEvent;
   import scaleform.clik.events.InputEvent;
   
   public class MeditationClockMenu extends CoreMenu
   {
       
      
      public var mcMeditationBonuses:MeditationBonusPanel;
      
      public var meditationClock:MeditationClock;
      
      public var mcGeraltImage:MovieClip;
      
      private var _navBlocked:Boolean;
      
      private var _bonusMeditationTime:int;
      
      public function MeditationClockMenu()
      {
         _disableShowAnimation = true;
         upToCloseEnabled = false;
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"meditation.clock.blocked",[this.blockClock]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"meditation.bonus",[this.setMeditationBonus]));
         this.meditationClock.timeChangeCallback = this.timeChangedCallback;
         focused = 1;
         this._navBlocked = false;
      }
      
      protected function blockClock(param1:Boolean) : void
      {
         this._navBlocked = param1;
      }
      
      public function setBonusMeditationTime(param1:int) : void
      {
         this._bonusMeditationTime = param1;
         var _loc2_:Number = Math.abs(this.meditationClock.selectedTime - this.meditationClock.currentTime);
         this.mcMeditationBonuses.active = _loc2_ >= this._bonusMeditationTime;
      }
      
      protected function setMeditationBonus(param1:Array) : void
      {
         this.mcMeditationBonuses.data = param1;
         this.meditationClock.setLabels("[[panel_name_sleep]]","[[panel_meditationclock_sleep_hours]]");
      }
      
      protected function timeChangedCallback(param1:uint) : void
      {
         var _loc2_:Number = Math.abs(this.meditationClock.selectedTime - this.meditationClock.currentTime);
         this.mcMeditationBonuses.active = _loc2_ >= this._bonusMeditationTime;
      }
      
      override protected function handleInputNavigate(param1:InputEvent) : void
      {
         if(!this._navBlocked && !this.meditationClock.isMeditating)
         {
            super.handleInputNavigate(param1);
         }
      }
      
      public function setGeraltBackgroundVisible(param1:Boolean) : void
      {
         if(!this.mcGeraltImage)
         {
         }
      }
      
      override protected function get menuName() : String
      {
         return "MeditationClockMenu";
      }
      
      public function SetBlockMeditation(param1:Boolean) : *
      {
         this.meditationClock.SetBlockMeditation(param1);
      }
      
      public function Set24HRFormat(param1:Boolean) : *
      {
         this.meditationClock.Set24HRFormat(param1);
      }
   }
}
