package red.game.witcher3.hud
{
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.Dictionary;
   import red.core.CoreComponent;
   import red.core.CoreHud;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.HintButton;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.hud.modules.HudModuleAnchors;
   import red.game.witcher3.hud.modules.HudModuleBase;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.menus.common_menu.ModuleInputFeedback;
   import scaleform.clik.managers.InputDelegate;
   
   public class Hud extends CoreHud
   {
       
      
      public var moduleManager:HudModuleManager;
      
      public var hudModuleStateArray:Dictionary;
      
      public var loadError:int = 0;
      
      public var isDynamic:Boolean = true;
      
      private var mcTestModule:TestModule;
      
      internal const m_swfPath = "swf\\hud\\";
      
      public function Hud()
      {
         addFrameScript(0,this.frame1);
         super();
         this.moduleManager = new HudModuleManager();
         this.hudModuleStateArray = new Dictionary();
         this.hudModuleStateArray["JumpClimb"] = {"states":[{
            "state":"Hide",
            "modules":["RadialMenuModule","DialogModule","BoatHealthModule","HorseStaminaBarModule","HorsePanicBarModule"]
         },{
            "state":"Show",
            "modules":["QuestsModule","Minimap2Module","OnelinersModule","ControlsFeedbackModule","BuffsModule"]
         },{
            "state":"OnDemand",
            "modules":["InteractionsModule","SubtitlesModule","EnemyFocusModule","BossFocusModule","CrosshairModule","DamagedItemsModule","ConsoleModule","MessageModule","WatermarkModule","JournalUpdateModule","AreaInfoModule","CompanionModule","TimeLeftModule"]
         },{
            "state":"OnUpdate",
            "modules":["WolfHeadModule","OxygenBarModule","TimeLapseModule","ItemInfoModule"]
         }]};
         this.hudModuleStateArray["Exploration"] = {"states":[{
            "state":"Hide",
            "modules":["RadialMenuModule","DialogModule","BoatHealthModule","HorseStaminaBarModule","HorsePanicBarModule"]
         },{
            "state":"Show",
            "modules":["QuestsModule","Minimap2Module","OnelinersModule","ControlsFeedbackModule","BuffsModule"]
         },{
            "state":"OnDemand",
            "modules":["InteractionsModule","SubtitlesModule","EnemyFocusModule","BossFocusModule","CrosshairModule","DamagedItemsModule","ConsoleModule","MessageModule","WatermarkModule","JournalUpdateModule","AreaInfoModule","CompanionModule","TimeLeftModule"]
         },{
            "state":"OnUpdate",
            "modules":["WolfHeadModule","OxygenBarModule","TimeLapseModule","ItemInfoModule"]
         }]};
         this.hudModuleStateArray["Exploration_Replacer_Ciri"] = {"states":[{
            "state":"Hide",
            "modules":["RadialMenuModule","DialogModule","BoatHealthModule","HorseStaminaBarModule","HorsePanicBarModule"]
         },{
            "state":"Show",
            "modules":["QuestsModule","Minimap2Module","OnelinersModule","ControlsFeedbackModule","BuffsModule"]
         },{
            "state":"OnDemand",
            "modules":["InteractionsModule","SubtitlesModule","EnemyFocusModule","BossFocusModule","CrosshairModule","DamagedItemsModule","ConsoleModule","MessageModule","WatermarkModule","JournalUpdateModule","AreaInfoModule","CompanionModule","TimeLeftModule"]
         },{
            "state":"OnUpdate",
            "modules":["WolfHeadModule","OxygenBarModule","TimeLapseModule","ItemInfoModule"]
         }]};
         this.hudModuleStateArray["ScriptedAction"] = {"states":[{
            "state":"Hide",
            "modules":["RadialMenuModule","BuffsModule","DialogModule","BoatHealthModule","ControlsFeedbackModule","HorseStaminaBarModule","HorsePanicBarModule"]
         },{
            "state":"Show",
            "modules":["QuestsModule","Minimap2Module","OnelinersModule"]
         },{
            "state":"OnDemand",
            "modules":["InteractionsModule","SubtitlesModule","EnemyFocusModule","BossFocusModule","CrosshairModule","DamagedItemsModule","ConsoleModule","MessageModule","WatermarkModule","JournalUpdateModule","AreaInfoModule","CompanionModule","TimeLeftModule"]
         },{
            "state":"OnUpdate",
            "modules":["WolfHeadModule","OxygenBarModule","TimeLapseModule","ItemInfoModule"]
         }]};
         this.hudModuleStateArray["Combat"] = {"states":[{
            "state":"Hide",
            "modules":["RadialMenuModule","DialogModule","BoatHealthModule","AreaInfoModule"]
         },{
            "state":"Show",
            "modules":["Minimap2Module","ItemInfoModule","WolfHeadModule","OnelinersModule","QuestsModule","ControlsFeedbackModule","BuffsModule"]
         },{
            "state":"OnDemand",
            "modules":["InteractionsModule","SubtitlesModule","EnemyFocusModule","BossFocusModule","CrosshairModule","DamagedItemsModule","ConsoleModule","MessageModule","JournalUpdateModule","WatermarkModule","CompanionModule","TimeLeftModule"]
         },{
            "state":"OnUpdate",
            "modules":["OxygenBarModule","HorseStaminaBarModule","TimeLapseModule","HorsePanicBarModule"]
         }]};
         this.hudModuleStateArray["CombatFists"] = {"states":[{
            "state":"Hide",
            "modules":["RadialMenuModule","DialogModule","BoatHealthModule","AreaInfoModule"]
         },{
            "state":"Show",
            "modules":["Minimap2Module","ItemInfoModule","WolfHeadModule","OnelinersModule","QuestsModule","ControlsFeedbackModule","BuffsModule"]
         },{
            "state":"OnDemand",
            "modules":["InteractionsModule","SubtitlesModule","EnemyFocusModule","BossFocusModule","CrosshairModule","DamagedItemsModule","ConsoleModule","MessageModule","JournalUpdateModule","WatermarkModule","CompanionModule","TimeLeftModule"]
         },{
            "state":"OnUpdate",
            "modules":["OxygenBarModule","HorseStaminaBarModule","TimeLapseModule","HorsePanicBarModule"]
         }]};
         this.hudModuleStateArray["Combat_Replacer_Ciri"] = {"states":[{
            "state":"Hide",
            "modules":["RadialMenuModule","DialogModule","BoatHealthModule","AreaInfoModule"]
         },{
            "state":"Show",
            "modules":["Minimap2Module","ItemInfoModule","WolfHeadModule","OnelinersModule","QuestsModule","ControlsFeedbackModule","BuffsModule"]
         },{
            "state":"OnDemand",
            "modules":["InteractionsModule","SubtitlesModule","EnemyFocusModule","BossFocusModule","CrosshairModule","DamagedItemsModule","ConsoleModule","MessageModule","JournalUpdateModule","WatermarkModule","CompanionModule","TimeLeftModule"]
         },{
            "state":"OnUpdate",
            "modules":["OxygenBarModule","HorseStaminaBarModule","TimeLapseModule","HorsePanicBarModule"]
         }]};
         this.hudModuleStateArray["Scene"] = {"states":[{
            "state":"Hide",
            "modules":["QuestsModule","RadialMenuModule","BuffsModule","OxygenBarModule","BoatHealthModule","InteractionsModule","SubtitlesModule","CrosshairModule","EnemyFocusModule","BossFocusModule","ConsoleModule","MessageModule","AreaInfoModule","OnelinersModule","DamagedItemsModule","WatermarkModule","HorseStaminaBarModule","HorsePanicBarModule","Minimap2Module","ItemInfoModule","WolfHeadModule","CompanionModule","ControlsFeedbackModule","TimeLeftModule"]
         },{
            "state":"OnDemand",
            "modules":["JournalUpdateModule"]
         },{
            "state":"Show",
            "modules":["DialogModule"]
         },{
            "state":"OnUpdate",
            "modules":["TimeLapseModule"]
         }]};
         this.hudModuleStateArray["LootPopup"] = {"states":[{
            "state":"Hide",
            "modules":["InteractionsModule","RadialMenuModule","DebugFastMenuModule"]
         },{
            "state":"Show",
            "modules":["BuffsModule"]
         }]};
         this.hudModuleStateArray["RadialMenu"] = {"states":[{
            "state":"Hide",
            "modules":["QuestsModule","CrosshairModule","DamagedItemsModule","OxygenBarModule","BoatHealthModule","InteractionsModule","SubtitlesModule","OnelinersModule","EnemyFocusModule","BossFocusModule","ConsoleModule","MessageModule","TimeLapseModule","AreaInfoModule","CompanionModule","WatermarkModule","HorseStaminaBarModule","HorsePanicBarModule","Minimap2Module","WolfHeadModule","DialogModule","JournalUpdateModule","ControlsFeedbackModule","TimeLeftModule"]
         },{
            "state":"Show",
            "modules":["RadialMenuModule","BuffsModule","ItemInfoModule"]
         }]};
         this.hudModuleStateArray["Swimming"] = {"states":[{
            "state":"Hide",
            "modules":["RadialMenuModule","DialogModule","BoatHealthModule","OxygenBarModule","HorseStaminaBarModule","HorsePanicBarModule"]
         },{
            "state":"Show",
            "modules":["QuestsModule","Minimap2Module","OnelinersModule","ControlsFeedbackModule","BuffsModule"]
         },{
            "state":"OnDemand",
            "modules":["InteractionsModule","SubtitlesModule","EnemyFocusModule","BossFocusModule","AreaInfoModule","CompanionModule","DamagedItemsModule","ConsoleModule","MessageModule","WatermarkModule","CrosshairModule","JournalUpdateModule","TimeLeftModule"]
         },{
            "state":"OnUpdate",
            "modules":["WolfHeadModule","ItemInfoModule","OxygenBarModule","TimeLapseModule"]
         }]};
         this.hudModuleStateArray["Diving"] = {"states":[{
            "state":"Hide",
            "modules":["RadialMenuModule","DialogModule","BoatHealthModule","HorsePanicBarModule","OxygenBarModule","HorseStaminaBarModule"]
         },{
            "state":"Show",
            "modules":["QuestsModule","Minimap2Module","OnelinersModule","ControlsFeedbackModule","BuffsModule"]
         },{
            "state":"OnDemand",
            "modules":["InteractionsModule","SubtitlesModule","EnemyFocusModule","BossFocusModule","AreaInfoModule","CompanionModule","DamagedItemsModule","ConsoleModule","MessageModule","WatermarkModule","CrosshairModule","JournalUpdateModule","TimeLeftModule"]
         },{
            "state":"OnUpdate",
            "modules":["WolfHeadModule","ItemInfoModule","OxygenBarModule","TimeLapseModule"]
         }]};
         this.hudModuleStateArray["Horse"] = {"states":[{
            "state":"Hide",
            "modules":["RadialMenuModule","DialogModule","BoatHealthModule"]
         },{
            "state":"Show",
            "modules":["QuestsModule","Minimap2Module","OnelinersModule","ControlsFeedbackModule","BuffsModule"]
         },{
            "state":"OnDemand",
            "modules":["InteractionsModule","SubtitlesModule","EnemyFocusModule","BossFocusModule","AreaInfoModule","CompanionModule","DamagedItemsModule","ConsoleModule","MessageModule","WatermarkModule","CrosshairModule","JournalUpdateModule","TimeLeftModule"]
         },{
            "state":"OnUpdate",
            "modules":["WolfHeadModule","HorseStaminaBarModule","ItemInfoModule","TimeLapseModule","OxygenBarModule","HorsePanicBarModule"]
         }]};
         this.hudModuleStateArray["Horse_Replacer_Ciri"] = {"states":[{
            "state":"Hide",
            "modules":["RadialMenuModule","DialogModule","BoatHealthModule"]
         },{
            "state":"Show",
            "modules":["QuestsModule","Minimap2Module","OnelinersModule","ControlsFeedbackModule","BuffsModule"]
         },{
            "state":"OnDemand",
            "modules":["InteractionsModule","SubtitlesModule","EnemyFocusModule","BossFocusModule","AreaInfoModule","CompanionModule","DamagedItemsModule","ConsoleModule","MessageModule","WatermarkModule","CrosshairModule","JournalUpdateModule","TimeLeftModule"]
         },{
            "state":"OnUpdate",
            "modules":["WolfHeadModule","HorseStaminaBarModule","ItemInfoModule","TimeLapseModule","OxygenBarModule","HorsePanicBarModule"]
         }]};
         this.hudModuleStateArray["Boat"] = {"states":[{
            "state":"Hide",
            "modules":["RadialMenuModule","DialogModule","HorseStaminaBarModule","HorsePanicBarModule"]
         },{
            "state":"Show",
            "modules":["QuestsModule","Minimap2Module","BoatHealthModule","OnelinersModule","ControlsFeedbackModule","BuffsModule"]
         },{
            "state":"OnDemand",
            "modules":["InteractionsModule","SubtitlesModule","EnemyFocusModule","BossFocusModule","AreaInfoModule","CompanionModule","DamagedItemsModule","ConsoleModule","MessageModule","WatermarkModule","CrosshairModule","JournalUpdateModule","TimeLeftModule"]
         },{
            "state":"OnUpdate",
            "modules":["WolfHeadModule","ItemInfoModule","TimeLapseModule","OxygenBarModule"]
         }]};
         this.hudModuleStateArray["BoatPassenger"] = {"states":[{
            "state":"Hide",
            "modules":["RadialMenuModule","LootPopupModule","DialogModule","HorseStaminaBarModule","HorsePanicBarModule"]
         },{
            "state":"Show",
            "modules":["QuestsModule","Minimap2Module","BoatHealthModule","OnelinersModule","ControlsFeedbackModule","BuffsModule"]
         },{
            "state":"OnDemand",
            "modules":["InteractionsModule","SubtitlesModule","EnemyFocusModule","BossFocusModule","AreaInfoModule","CompanionModule","DamagedItemsModule","ConsoleModule","MessageModule","WatermarkModule","CrosshairModule","JournalUpdateModule","TimeLeftModule"]
         },{
            "state":"OnUpdate",
            "modules":["WolfHeadModule","ItemInfoModule","TimeLapseModule","OxygenBarModule"]
         }]};
         this.hudModuleStateArray["Death"] = {"states":[{
            "state":"Hide",
            "modules":["RadialMenuModule","BuffsModule","CrosshairModule","OnelinersModule","DamagedItemsModule","DialogModule","HorseStaminaBarModule","HorsePanicBarModule","QuestsModule","Minimap2Module","BoatHealthModule","JournalUpdateModule","InteractionsModule","SubtitlesModule","ItemInfoModule","EnemyFocusModule","BossFocusModule","AreaInfoModule","CompanionModule","ConsoleModule","MessageModule","TimeLapseModule","WatermarkModule","WolfHeadModule","OxygenBarModule","ControlsFeedbackModule","TimeLeftModule"]
         }]};
         this.moduleManager.AddEntry("AnchorsModule","hud_anchors.swf",0);
         this.moduleManager.AddEntry("HorseStaminaBarModule","hud_horsestaminabar.swf",4);
         this.moduleManager.AddEntry("HorsePanicBarModule","hud_horsepanicbar.swf",5);
         this.moduleManager.AddEntry("InteractionsModule","hud_interactions.swf",20);
         this.moduleManager.AddEntry("MessageModule","hud_message.swf",6);
         this.moduleManager.AddEntry("RadialMenuModule","hud_radialmenu.swf",24);
         this.moduleManager.AddEntry("QuestsModule","hud_quests.swf",7);
         this.moduleManager.AddEntry("SubtitlesModule","hud_subtitles.swf",21);
         this.moduleManager.AddEntry("ControlsFeedbackModule","hud_controlsfeedback.swf",28);
         this.moduleManager.AddEntry("BuffsModule","hud_buffs.swf",26);
         this.moduleManager.AddEntry("PickedItemsInfoModule","hud_pickeditemsinfo.swf",1);
         this.moduleManager.AddEntry("WolfHeadModule","hud_wolfstatbars.swf",12);
         this.moduleManager.AddEntry("ItemInfoModule","hud_iteminfo.swf",25);
         this.moduleManager.AddEntry("OxygenBarModule","hud_oxygenbar.swf",13);
         this.moduleManager.AddEntry("EnemyFocusModule","hud_enemyfocus.swf",19);
         this.moduleManager.AddEntry("BossFocusModule","hud_bossfocus.swf",15);
         this.moduleManager.AddEntry("DialogModule","hud_dialog.swf",22);
         this.moduleManager.AddEntry("BoatHealthModule","hud_boathealth.swf",8);
         this.moduleManager.AddEntry("ConsoleModule","hud_console.swf",9);
         this.moduleManager.AddEntry("TimeLapseModule","hud_timelapse.swf",27);
         this.moduleManager.AddEntry("JournalUpdateModule","hud_journalupdate.swf",16);
         this.moduleManager.AddEntry("CrosshairModule","hud_crosshair.swf",17);
         this.moduleManager.AddEntry("OnelinersModule","hud_oneliners.swf",3);
         this.moduleManager.AddEntry("Minimap2Module","hud_minimap2.swf",11);
         this.moduleManager.AddEntry("CompanionModule","hud_companion.swf",30);
         this.moduleManager.AddEntry("DamagedItemsModule","hud_damageditems.swf",8);
         this.moduleManager.AddEntry("TimeLeftModule","hud_timeleft.swf",26);
      }
      
      override public function get hudName() : String
      {
         return "defaultHud";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         _inputMgr = InputManager.getInstance();
         _inputMgr.enableHoldEmulation = false;
         _inputMgr.enableInputDeviceCheck = false;
         _inputMgr.addInputBlocker(true,"HUD_ROOT");
         var _loc1_:InputFeedbackButton = new InputFeedbackButton();
         var _loc2_:HintButton = new HintButton();
         var _loc3_:HudModuleBase = new HudModuleBase();
         var _loc4_:InputDelegate = InputDelegate.getInstance();
         var _loc5_:W3ScrollingList = new W3ScrollingList();
         var _loc6_:ModuleInputFeedback = new ModuleInputFeedback();
      }
      
      override protected function loadModule(param1:String, param2:int) : void
      {
         var _loc3_:Class = null;
         var _loc4_:Loader = null;
         var _loc5_:LoaderContext = null;
         var _loc6_:HudModuleManagerEntry;
         if(_loc6_ = this.moduleManager.FindModuleByName(param1))
         {
            _loc4_ = new Loader();
            _loc5_ = new LoaderContext(false,ApplicationDomain.currentDomain);
            _loc4_.load(new URLRequest(this.m_swfPath + _loc6_.m_filename),_loc5_);
            _loc4_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.handleMovieLoadComplete,false,0,true);
            _loc4_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.handleMovieLoadError,false,0,true);
         }
      }
      
      override protected function unloadModule(param1:String, param2:int) : void
      {
         var _loc3_:HudModuleManagerEntry = this.moduleManager.FindModuleByName(param1);
         if(_loc3_)
         {
            if(_loc3_.m_movieClip != null)
            {
               removeChild(_loc3_.m_movieClip);
               _loc3_.m_movieClip = null;
            }
         }
         else if(param1 == "TestModule" && this.mcTestModule != null)
         {
            removeChild(this.mcTestModule);
            this.mcTestModule = null;
         }
      }
      
      private function handleMovieLoadComplete(param1:Event) : void
      {
         var _loc2_:LoaderInfo = LoaderInfo(param1.target);
         var _loc3_:Loader = _loc2_.loader;
         var _loc4_:int = 0;
         _loc2_.removeEventListener(Event.COMPLETE,this.handleMovieLoadComplete,false);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.handleMovieLoadError,false);
         var _loc5_:String = _loc2_.url.slice(_loc2_.url.lastIndexOf("\\") + 1);
         var _loc6_:HudModuleManagerEntry;
         if(_loc6_ = this.moduleManager.FindModuleByFilename(_loc5_))
         {
            _loc6_.m_movieClip = _loc3_.content as HudModuleBase;
            _loc6_.m_movieClip.SetState(_loc6_.m_state);
            _loc4_ = _loc6_.m_depthIndex;
         }
         addChildAt(_loc3_.content,Math.min(_loc4_,Math.max(numChildren - 1,0)));
         this.CheckModulesDepth();
      }
      
      internal function CheckModulesDepth() : *
      {
         if(numChildren + this.loadError == this.moduleManager.entries.length)
         {
            this.moduleManager.SortEntries();
         }
      }
      
      private function handleMovieLoadError(param1:Event) : void
      {
         var _loc2_:LoaderInfo = LoaderInfo(param1.target);
         var _loc3_:Loader = _loc2_.loader;
         _loc2_.removeEventListener(Event.COMPLETE,this.handleMovieLoadComplete,false);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.handleMovieLoadError,false);
         ++this.loadError;
      }
      
      public function ShowModules(param1:Boolean) : *
      {
         this.moduleManager.ShowModules(param1);
      }
      
      public function PrintInfo() : *
      {
         this.moduleManager.PrintInfo();
         this.debugHudList();
      }
      
      public function SetDynamic(param1:Boolean) : *
      {
         this.isDynamic = param1;
      }
      
      public function SetInputContext(param1:String) : *
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:HudModuleBase = null;
         var _loc7_:int = 0;
         var _loc8_:HudModuleManagerEntry = null;
         var _loc9_:int = 0;
         var _loc10_:Object = null;
         var _loc11_:int = 0;
         if(this.hudModuleStateArray.hasOwnProperty(param1))
         {
            _loc2_ = int(this.hudModuleStateArray[param1].states.length);
            _loc5_ = new Array();
            while(_loc9_ < _loc2_)
            {
               _loc3_ = String((_loc10_ = this.hudModuleStateArray[param1].states[_loc9_]).state);
               _loc11_ = int((_loc5_ = _loc10_.modules).length);
               _loc7_ = 0;
               while(_loc7_ < _loc11_)
               {
                  _loc4_ = String(_loc5_[_loc7_]);
                  if(_loc8_ = this.moduleManager.FindModuleByNameDict(_loc4_))
                  {
                     if(_loc6_ = _loc8_.m_movieClip)
                     {
                        if(!_loc6_.isEnabled)
                        {
                           _loc6_.SetState("Hide");
                        }
                        if(!this.isDynamic && _loc3_ == "OnUpdate" && !_loc6_.isAlwaysDynamic)
                        {
                           if(_loc6_.getState() != "Show")
                           {
                              _loc6_.SetState("Show");
                           }
                        }
                        else if(_loc6_.getState() != _loc3_)
                        {
                           _loc6_.SetState(_loc3_);
                        }
                     }
                     else
                     {
                        _loc8_.m_state = _loc3_;
                     }
                  }
                  _loc7_++;
               }
               _loc9_++;
            }
         }
      }
      
      public function setGameLanguage(param1:String) : *
      {
         CoreComponent._gameLanguage = param1;
      }
      
      public function debugHudList() : void
      {
         var _loc2_:HudModuleManagerEntry = null;
         var _loc3_:HudModuleBase = null;
         var _loc1_:* = 0;
         while(_loc1_ < this.moduleManager.entries.length)
         {
            _loc2_ = this.moduleManager.entries[_loc1_];
            if(_loc2_)
            {
               _loc3_ = _loc2_.m_movieClip;
               if(!_loc3_)
               {
               }
            }
            _loc1_++;
         }
      }
      
      public function onCutsceneStartedOrEnded(param1:Boolean) : *
      {
         var _loc2_:HudModuleManagerEntry = null;
         var _loc3_:HudModuleAnchors = null;
         var _loc4_:* = undefined;
         _loc2_ = this.moduleManager.FindModuleByName("AnchorsModule");
         if(_loc2_)
         {
            _loc3_ = _loc2_.m_movieClip as HudModuleAnchors;
            if(_loc3_)
            {
               if(_loc3_.isAspectRatio21_9())
               {
                  _loc4_ = 0;
                  while(_loc4_ < this.moduleManager.entries.length)
                  {
                     if(this.moduleManager.entries[_loc4_].m_name == "TimeLapseModule" || this.moduleManager.entries[_loc4_].m_name == "JournalUpdateModule")
                     {
                        this.moduleManager.entries[_loc4_].m_movieClip.onCutsceneStartedOrEnded(param1);
                     }
                     _loc4_++;
                  }
               }
            }
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
