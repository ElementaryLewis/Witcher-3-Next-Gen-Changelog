package red.game.witcher3.menus.worldmap
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.data.StaticMapPinData;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.menus.worldmap.data.CategoryData;
   import red.game.witcher3.menus.worldmap.data.CategoryPinData;
   import red.game.witcher3.menus.worldmap.data.CategoryPinInstanceData;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.interfaces.IListItemRenderer;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.MouseEventEx;
   
   public class HubMapPinPanel extends UIComponent
   {
      
      public static const ALL_PINS_CATEGORY:String = "All";
      
      public static const ROADSIGN_PIN_TRANSLATION:String = "[[map_location_roadsign]]";
      
      public static const HARBOR_PIN_TRANSLATION:String = "[[map_location_harbor]]";
      
      public static const QUEST_PIN_TYPE:String = "StoryQuest";
      
      public static const QUEST_PIN_TRANSLATION:String = "[[map_location_quest]]";
      
      public static const USER_PIN_TYPE:String = "User1";
      
      public static const USER_PIN_TRANSLATION:String = "[[map_location_user]]";
       
      
      public var mcHubMapPinCategoryButton:MovieClip;
      
      public var mcHubMapPinCategoryList:W3ScrollingList;
      
      public var mcHubMapPinArrowUp:MovieClip;
      
      public var mcHubMapPinArrowDown:MovieClip;
      
      public var funcCenterOnWorldPosition:Function;
      
      public var funcShowPinsFromCategory:Function;
      
      public var funcIsAnimationRunning:Function;
      
      private var _renderersListShort:Vector.<IListItemRenderer>;
      
      private var _renderersListLong:Vector.<IListItemRenderer>;
      
      private var _expandedList:Boolean = false;
      
      private var _categories:Array;
      
      private var _currentCategoryIndex:int;
      
      private var _disabledPins:Dictionary;
      
      private var _allowShowingCategoryButtonSelection:Boolean = false;
      
      private const SHORT_LIST_COUNT:int = 6;
      
      private const LONG_LIST_COUNT:int = 18;
      
      private const USER_PIN_PRIORITY:int = 1;
      
      private var _categoryDefinitions:Object;
      
      private var _pinTypeDefinitions:Object;
      
      public function HubMapPinPanel()
      {
         this._renderersListShort = new Vector.<IListItemRenderer>();
         this._renderersListLong = new Vector.<IListItemRenderer>();
         this._categories = new Array();
         this._disabledPins = new Dictionary();
         this._categoryDefinitions = {
            "All":new CategoryDefinition(1,true,true,true),
            "Default":new CategoryDefinition(2,true,true,true),
            "General":new CategoryDefinition(3,true,true,false),
            "Quests":new CategoryDefinition(4,true,true,true),
            "Exploration":new CategoryDefinition(5,true,true,false),
            "NPCs":new CategoryDefinition(6,true,true,false),
            "Buffs":new CategoryDefinition(7,true,true,false)
         };
         this._pinTypeDefinitions = {
            "RoadSign":new PinTypeDefinition("General",101),
            "Harbor":new PinTypeDefinition("General",102),
            "NoticeBoardFull":new PinTypeDefinition("General",103),
            "NoticeBoard":new PinTypeDefinition("General",104),
            "PlayerStash":new PinTypeDefinition("General",105),
            "PlayerStashDiscoverable":new PinTypeDefinition("General",106),
            "Horse":new PinTypeDefinition("General",107),
            "StoryQuest":new PinTypeDefinition("Quests",201),
            "ChapterQuest":new PinTypeDefinition("Quests",202),
            "SideQuest":new PinTypeDefinition("Quests",203),
            "MonsterQuest":new PinTypeDefinition("Quests",204),
            "TreasureQuest":new PinTypeDefinition("Quests",205),
            "QuestReturn":new PinTypeDefinition("Quests",206),
            "HorseRace":new PinTypeDefinition("Quests",207),
            "NonQuestHorseRace":new PinTypeDefinition("Quests",208),
            "BoatRace":new PinTypeDefinition("Quests",209),
            "QuestBelgard":new PinTypeDefinition("Quests",210),
            "QuestCoronata":new PinTypeDefinition("Quests",212),
            "QuestVermentino":new PinTypeDefinition("Quests",212),
            "QuestAvailable":new PinTypeDefinition("Quests",213),
            "QuestAvailableHoS":new PinTypeDefinition("Quests",214),
            "QuestAvailableBaW":new PinTypeDefinition("Quests",215),
            "Entrance":new PinTypeDefinition("Exploration",301),
            "NotDiscoveredPOI":new PinTypeDefinition("Exploration",302),
            "NotDiscoveredPOI_1":new PinTypeDefinition("Exploration",303),
            "NotDiscoveredPOI_2":new PinTypeDefinition("Exploration",304),
            "NotDiscoveredPOI_3":new PinTypeDefinition("Exploration",305),
            "MonsterNest":new PinTypeDefinition("Exploration",306),
            "MonsterNest_1":new PinTypeDefinition("Exploration",307),
            "MonsterNest_2":new PinTypeDefinition("Exploration",308),
            "MonsterNest_3":new PinTypeDefinition("Exploration",309),
            "MonsterNestDisabled":new PinTypeDefinition("Exploration",310),
            "TreasureHuntMappin":new PinTypeDefinition("Exploration",316),
            "TreasureHuntMappin_1":new PinTypeDefinition("Exploration",317),
            "TreasureHuntMappin_2":new PinTypeDefinition("Exploration",318),
            "TreasureHuntMappin_3":new PinTypeDefinition("Exploration",319),
            "TreasureHuntMappinDisabled":new PinTypeDefinition("Exploration",320),
            "SpoilsOfWar":new PinTypeDefinition("Exploration",321),
            "SpoilsOfWar_1":new PinTypeDefinition("Exploration",322),
            "SpoilsOfWar_2":new PinTypeDefinition("Exploration",323),
            "SpoilsOfWar_3":new PinTypeDefinition("Exploration",324),
            "SpoilsOfWarDisabled":new PinTypeDefinition("Exploration",325),
            "BanditCamp":new PinTypeDefinition("Exploration",326),
            "BanditCamp_1":new PinTypeDefinition("Exploration",327),
            "BanditCamp_2":new PinTypeDefinition("Exploration",328),
            "BanditCamp_3":new PinTypeDefinition("Exploration",329),
            "BanditCampDisabled":new PinTypeDefinition("Exploration",330),
            "BanditCampfire":new PinTypeDefinition("Exploration",331),
            "BanditCampfire_1":new PinTypeDefinition("Exploration",332),
            "BanditCampfire_2":new PinTypeDefinition("Exploration",333),
            "BanditCampfire_3":new PinTypeDefinition("Exploration",334),
            "BanditCampfireDisabled":new PinTypeDefinition("Exploration",335),
            "BossAndTreasure":new PinTypeDefinition("Exploration",336),
            "BossAndTreasure_1":new PinTypeDefinition("Exploration",337),
            "BossAndTreasure_2":new PinTypeDefinition("Exploration",338),
            "BossAndTreasure_3":new PinTypeDefinition("Exploration",339),
            "BossAndTreasureDisabled":new PinTypeDefinition("Exploration",340),
            "Contraband":new PinTypeDefinition("Exploration",341),
            "Contraband_1":new PinTypeDefinition("Exploration",342),
            "Contraband_2":new PinTypeDefinition("Exploration",343),
            "Contraband_3":new PinTypeDefinition("Exploration",344),
            "ContrabandDisabled":new PinTypeDefinition("Exploration",345),
            "ContrabandShip":new PinTypeDefinition("Exploration",346),
            "ContrabandShip_1":new PinTypeDefinition("Exploration",347),
            "ContrabandShip_2":new PinTypeDefinition("Exploration",348),
            "ContrabandShip_3":new PinTypeDefinition("Exploration",349),
            "ContrabandShipDisabled":new PinTypeDefinition("Exploration",350),
            "RescuingTown":new PinTypeDefinition("Exploration",351),
            "RescuingTown_1":new PinTypeDefinition("Exploration",352),
            "RescuingTown_2":new PinTypeDefinition("Exploration",353),
            "RescuingTown_3":new PinTypeDefinition("Exploration",354),
            "RescuingTownDisabled":new PinTypeDefinition("Exploration",355),
            "DungeonCrawl":new PinTypeDefinition("Exploration",356),
            "DungeonCrawl_1":new PinTypeDefinition("Exploration",357),
            "DungeonCrawl_2":new PinTypeDefinition("Exploration",358),
            "DungeonCrawl_3":new PinTypeDefinition("Exploration",359),
            "DungeonCrawlDisabled":new PinTypeDefinition("Exploration",360),
            "Hideout":new PinTypeDefinition("Exploration",361),
            "HideoutDisabled":new PinTypeDefinition("Exploration",362),
            "InfestedVineyard":new PinTypeDefinition("Exploration",363),
            "InfestedVineyard_1":new PinTypeDefinition("Exploration",364),
            "InfestedVineyard_2":new PinTypeDefinition("Exploration",365),
            "InfestedVineyard_3":new PinTypeDefinition("Exploration",366),
            "InfestedVineyardDisabled":new PinTypeDefinition("Exploration",367),
            "Plegmund":new PinTypeDefinition("Exploration",368),
            "WineContract":new PinTypeDefinition("Exploration",369),
            "KnightErrant":new PinTypeDefinition("Exploration",370),
            "SignalingStake":new PinTypeDefinition("Exploration",371),
            "Boat":new PinTypeDefinition("Exploration",372),
            "Shopkeeper":new PinTypeDefinition("NPCs",501),
            "Archmaster":new PinTypeDefinition("NPCs",502),
            "Blacksmith":new PinTypeDefinition("NPCs",503),
            "Armorer":new PinTypeDefinition("NPCs",504),
            "Hairdresser":new PinTypeDefinition("NPCs",505),
            "Alchemic":new PinTypeDefinition("NPCs",506),
            "Herbalist":new PinTypeDefinition("NPCs",507),
            "Innkeeper":new PinTypeDefinition("NPCs",508),
            "Enchanter":new PinTypeDefinition("NPCs",509),
            "Prostitute":new PinTypeDefinition("NPCs",510),
            "Hairdresser":new PinTypeDefinition("NPCs",511),
            "Torch":new PinTypeDefinition("NPCs",512),
            "WineMerchant":new PinTypeDefinition("NPCs",513),
            "DyeMerchant":new PinTypeDefinition("NPCs",514),
            "Cammerlengo":new PinTypeDefinition("NPCs",515),
            "PlaceOfPower":new PinTypeDefinition("Buffs",601),
            "PlaceOfPower_1":new PinTypeDefinition("Buffs",602),
            "PlaceOfPower_2":new PinTypeDefinition("Buffs",603),
            "PlaceOfPower_3":new PinTypeDefinition("Buffs",604),
            "PlaceOfPowerDisabled":new PinTypeDefinition("Buffs",605),
            "Whetstone":new PinTypeDefinition("Buffs",606),
            "GrindStone":new PinTypeDefinition("Buffs",607),
            "ArmorRepairTable":new PinTypeDefinition("Buffs",608),
            "AlchemyTable":new PinTypeDefinition("Buffs",609),
            "MutagenDismantle":new PinTypeDefinition("Buffs",610),
            "Bookshelf":new PinTypeDefinition("Buffs",611)
         };
         super();
      }
      
      private function __DEBUG_cleanAllCategories() : *
      {
         this._categories.length = 0;
      }
      
      private function __DEBUG_addCategory(param1:String) : CategoryData
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this._categories.length)
         {
            if(param1 == this._categories[_loc2_]._name)
            {
               return this._categories[_loc2_];
            }
            _loc2_++;
         }
         var _loc3_:int = 9999;
         var _loc4_:Boolean = true;
         var _loc5_:Boolean = true;
         var _loc6_:Boolean = true;
         var _loc7_:CategoryDefinition;
         if(_loc7_ = this._categoryDefinitions[param1])
         {
            _loc3_ = _loc7_._priority;
            _loc4_ = _loc7_._showUserPins;
            _loc5_ = _loc7_._showFastTravelPins;
            _loc6_ = _loc7_._showQuestPins;
         }
         this._categories[this._categories.length] = new CategoryData(param1,_loc3_,_loc4_,_loc5_,_loc6_);
         return this._categories[this._categories.length - 1];
      }
      
      private function __DEBUG_addPin(param1:CategoryData, param2:String, param3:String, param4:int) : CategoryPinData
      {
         var _loc5_:int = 0;
         _loc5_ = 0;
         while(_loc5_ < param1._pins.length)
         {
            if(param2 == param1._pins[_loc5_]._name)
            {
               return param1._pins[_loc5_];
            }
            _loc5_++;
         }
         param1._pins[param1._pins.length] = new CategoryPinData(param2,param3,param4);
         return param1._pins[param1._pins.length - 1];
      }
      
      private function __DEBUG_addInstance(param1:CategoryPinData, param2:uint, param3:Point, param4:Number = 0) : CategoryPinInstanceData
      {
         param1._instances[param1._instances.length] = new CategoryPinInstanceData(param2,param3,param4);
         return param1._instances[param1._instances.length - 1];
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"worldmap.global.set.index",[this.updateCurrentCategoryIndex]));
         this.initializeRenderers();
         this.updateRenderersVisibility();
         this.mcHubMapPinCategoryList.bSkipFocusCheck = true;
         this.initializeCategoryPanel(true);
         this.updateCategoryButtonSelection();
         addEventListener(MouseEvent.MOUSE_WHEEL,this.OnMouseWheel,false,0,true);
         this.mcHubMapPinCategoryList.addEventListener(MouseEvent.MOUSE_OVER,this.OnMouseOver,false,0,true);
         this.mcHubMapPinCategoryList.addEventListener(ListEvent.ITEM_ROLL_OVER,this.OnRollOver,false,0,true);
         this.mcHubMapPinCategoryList.addEventListener(ListEvent.INDEX_CHANGE,this.handleIndexChanged,false,0,true);
         this.mcHubMapPinCategoryButton.mcArrowLeft.addEventListener(MouseEvent.MOUSE_DOWN,this.handleCaterogyArrowLeft,false,0,true);
         this.mcHubMapPinCategoryButton.mcArrowRight.addEventListener(MouseEvent.MOUSE_DOWN,this.handleCaterogyArrowRight,false,0,true);
         this.mcHubMapPinArrowUp.addEventListener(MouseEvent.MOUSE_DOWN,this.handleArrowUp,false,0,true);
         this.mcHubMapPinArrowDown.addEventListener(MouseEvent.MOUSE_DOWN,this.handleArrowDown,false,0,true);
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"worldmap.global.pins.disabled",[this.setDisabledPins]));
      }
      
      public function updateCurrentCategoryIndex(param1:int) : *
      {
         this._currentCategoryIndex = param1;
         this.selectSpecificCategoryPanel(param1);
      }
      
      public function selectSpecificCategoryPanel(param1:int) : *
      {
         var _loc2_:CategoryData = null;
         this._expandedList = false;
         this.addMandatoryContents();
         this.sortContents();
         if(this._categories.length > 0)
         {
            _loc2_ = this._categories[param1];
            this.mcHubMapPinCategoryList.dataProvider = new DataProvider(_loc2_._pins);
            this.mcHubMapPinCategoryList.validateNow();
            this.updatePinsFromCategory(_loc2_,false);
         }
         else
         {
            this._currentCategoryIndex = -1;
         }
         this.updateCategoryButton();
         this.updateArrowButtons();
         this.resizeHitArea();
         this.updateCategoryButton();
         this.updateArrowButtons();
      }
      
      public function OnMouseWheel(param1:MouseEvent) : *
      {
         this.mcHubMapPinCategoryList.invalidateData();
         this.mcHubMapPinCategoryList.validateNow();
         this.updateArrowButtons();
         this.resizeHitArea();
      }
      
      public function enableMouse(param1:Boolean) : *
      {
         mouseEnabled = param1;
         mouseChildren = param1;
      }
      
      public function OnMouseOver(param1:MouseEvent) : *
      {
         if(mouseEnabled)
         {
            if(this.expandList(true))
            {
               this.resizeHitArea();
            }
         }
      }
      
      public function OnRollOver(param1:ListEvent) : *
      {
         if(mouseEnabled)
         {
            if(this.expandList(true))
            {
               this.resizeHitArea();
            }
         }
      }
      
      public function OnMouseMoveFromParent(param1:Point) : *
      {
         if(mouseEnabled)
         {
            if(this.expandList(this.isGlobalPointInsideBounds(param1)))
            {
               this.resizeHitArea();
            }
         }
      }
      
      private function setDisabledPins(param1:Object, param2:int) : *
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         if(param2 > -1)
         {
            return;
         }
         _loc3_ = param1 as Array;
         if(_loc3_)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if(_loc5_ = _loc3_[_loc4_])
               {
                  if((Boolean(_loc6_ = String(_loc5_.pinType))) && _loc6_.length > 0)
                  {
                     this._disabledPins[_loc6_] = _loc6_;
                  }
               }
               _loc4_++;
            }
         }
      }
      
      private function isGlobalPointInsideBounds(param1:Point) : Boolean
      {
         var _loc2_:Rectangle = this.mcHubMapPinCategoryList.getBounds(stage);
         return param1.x > _loc2_.left && param1.x < _loc2_.right && param1.y > _loc2_.top && param1.y < _loc2_.bottom;
      }
      
      protected function handleIndexChanged(param1:ListEvent) : void
      {
         this.updateCategoryButtonSelection();
         this.resizeHitArea();
         if(param1.index != -1)
         {
            if(!InputManager.getInstance().isGamepad())
            {
               this.centerOnPin();
            }
         }
      }
      
      public function handleCaterogyArrowLeft(param1:MouseEventEx) : *
      {
         if(!this.funcIsAnimationRunning())
         {
            if(param1.buttonIdx == MouseEventEx.LEFT_BUTTON)
            {
               this.selectPrevNextCategory(-1);
               this.mcHubMapPinCategoryList.selectedIndex = -1;
            }
         }
      }
      
      public function handleCaterogyArrowRight(param1:MouseEventEx) : *
      {
         if(!this.funcIsAnimationRunning())
         {
            if(param1.buttonIdx == MouseEventEx.LEFT_BUTTON)
            {
               this.selectPrevNextCategory(1);
               this.mcHubMapPinCategoryList.selectedIndex = -1;
            }
         }
      }
      
      public function handleArrowUp(param1:MouseEventEx) : *
      {
         if(param1.buttonIdx == MouseEventEx.LEFT_BUTTON)
         {
            ++this.mcHubMapPinCategoryList.scrollPosition;
            this.mcHubMapPinCategoryList.validateNow();
            this.updateArrowButtons();
            this.resizeHitArea();
         }
      }
      
      public function handleArrowDown(param1:MouseEventEx) : *
      {
         if(param1.buttonIdx == MouseEventEx.LEFT_BUTTON)
         {
            --this.mcHubMapPinCategoryList.scrollPosition;
            this.mcHubMapPinCategoryList.validateNow();
            this.updateArrowButtons();
            this.resizeHitArea();
         }
      }
      
      private function initializeRenderers() : *
      {
         var _loc1_:int = 0;
         var _loc2_:HubMapPinCategoryItemRenderer = null;
         _loc1_ = 1;
         while(_loc1_ <= this.LONG_LIST_COUNT)
         {
            _loc2_ = getChildByName("mcHubMapPinCategoryItem" + _loc1_) as HubMapPinCategoryItemRenderer;
            if(_loc2_)
            {
               _loc2_.funcChangePinIndex = this.changePinIndex;
               _loc2_.funcTogglePin = this.togglePin;
               _loc2_.funcIsPinDisabled = this.isPinDisabled;
               if(_loc1_ <= this.SHORT_LIST_COUNT)
               {
                  this._renderersListShort.push(_loc2_);
               }
               else
               {
                  _loc2_.visible = false;
               }
               this._renderersListLong.push(_loc2_);
            }
            _loc1_++;
         }
         this.mcHubMapPinCategoryList.itemRendererList = this._renderersListShort;
      }
      
      public function clearCategoryPanel() : *
      {
         this.__DEBUG_cleanAllCategories();
      }
      
      public function initializeCategoryPanel(param1:Boolean = false) : *
      {
         var _loc2_:CategoryData = null;
         this._expandedList = false;
         if(this._categories.length > 0)
         {
         }
         this.addMandatoryContents();
         this.sortContents();
         if(this._categories.length > 0)
         {
            this._currentCategoryIndex = (this._currentCategoryIndex + this._categories.length) % this._categories.length;
            _loc2_ = this._categories[this._currentCategoryIndex];
            this.mcHubMapPinCategoryList.dataProvider = new DataProvider(_loc2_._pins);
            this.mcHubMapPinCategoryList.validateNow();
            this.updatePinsFromCategory(_loc2_,param1);
         }
         else
         {
            this._currentCategoryIndex = -1;
         }
         this.updateCategoryButton();
         this.updateArrowButtons();
         this.resizeHitArea();
         this.updateCategoryButton();
         this.updateArrowButtons();
      }
      
      public function updateCategoryPanel() : *
      {
         var _loc1_:CategoryData = null;
         var _loc2_:Vector.<IListItemRenderer> = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:CategoryPinData = null;
         var _loc6_:HubMapPinCategoryItemRenderer = null;
         if(this._currentCategoryIndex > -1)
         {
            _loc1_ = this._categories[this._currentCategoryIndex];
            _loc2_ = this.mcHubMapPinCategoryList.getRenderers();
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               if((_loc4_ = _loc3_ + this.mcHubMapPinCategoryList.scrollPosition) < _loc1_._pins.length)
               {
                  _loc5_ = _loc1_._pins[_loc4_];
                  if(_loc6_ = _loc2_[_loc3_] as HubMapPinCategoryItemRenderer)
                  {
                     _loc6_.setCounter(_loc5_._index,_loc5_._instances.length);
                  }
               }
               _loc3_++;
            }
         }
         this.mcHubMapPinCategoryList.selectedIndex = -1;
      }
      
      private function addMandatoryContents() : *
      {
         var _loc1_:CategoryData = null;
         var _loc2_:int = 0;
         if(this._categories.length == 0)
         {
            this.__DEBUG_addCategory(ALL_PINS_CATEGORY);
         }
         _loc2_ = 0;
         while(_loc2_ < this._categories.length)
         {
            _loc1_ = this._categories[_loc2_] as CategoryData;
            this.__DEBUG_addPin(_loc1_,USER_PIN_TYPE,USER_PIN_TRANSLATION,this.USER_PIN_PRIORITY);
            _loc2_++;
         }
      }
      
      private function sortContents() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:CategoryData = null;
         var _loc4_:CategoryPinData = null;
         this._categories.sortOn("_priority",Array.NUMERIC);
         _loc1_ = 0;
         while(_loc1_ < this._categories.length)
         {
            _loc3_ = this._categories[_loc1_] as CategoryData;
            _loc3_._pins.sortOn("_priority",Array.NUMERIC);
            _loc2_ = 0;
            while(_loc2_ < _loc3_._pins.length)
            {
               (_loc4_ = _loc3_._pins[_loc2_] as CategoryPinData)._instances.sortOn("_distance",Array.NUMERIC);
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      public function selectPrevNextCategory(param1:int, param2:Boolean = false) : *
      {
         var _loc3_:CategoryData = null;
         if(this._categories.length > 0)
         {
            this._currentCategoryIndex = (this._currentCategoryIndex + param1 + this._categories.length) % this._categories.length;
            _loc3_ = this._categories[this._currentCategoryIndex];
            this.mcHubMapPinCategoryList.dataProvider = new DataProvider(_loc3_._pins);
            this.mcHubMapPinCategoryList.validateNow();
            this.updatePinsFromCategory(_loc3_,param2);
         }
         else
         {
            this._currentCategoryIndex = -1;
         }
         this.updateCategoryButton();
         this.updateArrowButtons();
         this.resizeHitArea();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnFiltersChanged",[this._currentCategoryIndex]));
      }
      
      private function updatePinsFromCategory(param1:CategoryData, param2:Boolean) : *
      {
         if(this.funcShowPinsFromCategory != null)
         {
            if(this._currentCategoryIndex == 0)
            {
               this.funcShowPinsFromCategory(null,true,true,true,this._disabledPins,param2);
            }
            else
            {
               this.funcShowPinsFromCategory(param1._pins,param1._showUserPins,param1._showFastTravelPins,param1._showQuestPins,this._disabledPins,param2);
            }
         }
      }
      
      public function updateCategoryButtonSelection() : *
      {
         this.mcHubMapPinCategoryButton.mcSelection.visible = this._allowShowingCategoryButtonSelection && this.mcHubMapPinCategoryList.selectedIndex == -1;
      }
      
      public function updateCategoryButton() : *
      {
         if(this._currentCategoryIndex == -1)
         {
            this.mcHubMapPinCategoryButton.tfCategoryName.text = "";
            this.mcHubMapPinCategoryButton.tfCategoryName.text = CommonUtils.toUpperCaseSafe(this.mcHubMapPinCategoryButton.tfCategoryName.text);
         }
         else
         {
            this.mcHubMapPinCategoryButton.tfCategoryName.text = "[[map_category_" + this._categories[this._currentCategoryIndex]._name + "]]";
            this.mcHubMapPinCategoryButton.tfCategoryName.text = CommonUtils.toUpperCaseSafe(this.mcHubMapPinCategoryButton.tfCategoryName.text);
         }
      }
      
      public function updateArrowButtons() : *
      {
         var _loc1_:int = 0;
         if(this._currentCategoryIndex > -1)
         {
            _loc1_ = int(this._categories[this._currentCategoryIndex]._pins.length);
         }
         this.mcHubMapPinArrowUp.visible = this.mcHubMapPinCategoryList.TotalRenderers + this.mcHubMapPinCategoryList.scrollPosition < _loc1_;
         this.mcHubMapPinArrowDown.visible = this.mcHubMapPinCategoryList.scrollPosition > 0;
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = param1.details;
         var _loc3_:* = _loc2_.value == InputValue.KEY_DOWN;
         var _loc4_:Boolean = _loc2_.value == InputValue.KEY_DOWN || _loc2_.value == InputValue.KEY_HOLD;
         var _loc5_:* = _loc2_.value == InputValue.KEY_UP;
         if(_loc2_.code == KeyCode.W || _loc2_.code == KeyCode.S || _loc2_.code == KeyCode.A || _loc2_.code == KeyCode.D)
         {
            return;
         }
         if(_loc2_.code == 1000)
         {
            this.expandList(false);
            this.resizeHitArea();
            this.resetSelection();
         }
         else if(_loc2_.code >= KeyCode.PAD_DIGIT_UP && _loc2_.code <= KeyCode.PAD_DIGIT_RIGHT)
         {
            this.expandList(true);
            this.resizeHitArea();
         }
         if(!_loc4_ && _loc2_.code != KeyCode.PAD_LEFT_TRIGGER)
         {
            return;
         }
         if(_loc2_.code == KeyCode.UP || _loc2_.code == KeyCode.DOWN)
         {
            return;
         }
         var _loc6_:int = 0;
         if(this._currentCategoryIndex > -1)
         {
            _loc6_ = int(this._categories[this._currentCategoryIndex]._pins.length);
         }
         if(!(_loc2_.code == KeyCode.PAD_DIGIT_DOWN && this.mcHubMapPinCategoryList.selectedIndex == -1))
         {
            this.mcHubMapPinCategoryList.handleInput(param1);
         }
         if(param1.handled)
         {
            this.updateArrowButtons();
            return;
         }
         switch(_loc2_.code)
         {
            case KeyCode.PAD_DIGIT_UP:
               if(this.mcHubMapPinCategoryList.selectedIndex > -1)
               {
                  this.resetSelection();
               }
               break;
            case KeyCode.PAD_DIGIT_DOWN:
               if(this.mcHubMapPinCategoryList.selectedIndex == 0)
               {
                  this.mcHubMapPinCategoryList.selectedIndex = -1;
               }
               else
               {
                  if(_loc6_ > this.mcHubMapPinCategoryList.TotalRenderers)
                  {
                     this.mcHubMapPinCategoryList.scrollPosition = _loc6_ - this.mcHubMapPinCategoryList.TotalRenderers;
                  }
                  this.mcHubMapPinCategoryList.selectedIndex = _loc6_ - 1;
               }
               this.updateArrowButtons();
               break;
            case KeyCode.PAD_DIGIT_LEFT:
               if(_loc3_)
               {
                  if(!this.funcIsAnimationRunning())
                  {
                     if(this.mcHubMapPinCategoryList.selectedIndex == -1)
                     {
                        this.selectPrevNextCategory(-1);
                     }
                     else
                     {
                        this.changePinIndexForSelectedItem(-1);
                     }
                  }
               }
               break;
            case KeyCode.PAD_DIGIT_RIGHT:
               if(_loc3_)
               {
                  if(!this.funcIsAnimationRunning())
                  {
                     if(this.mcHubMapPinCategoryList.selectedIndex == -1)
                     {
                        this.selectPrevNextCategory(1);
                     }
                     else
                     {
                        this.changePinIndexForSelectedItem(1);
                     }
                  }
               }
         }
         super.handleInput(param1);
      }
      
      private function expandList(param1:Boolean) : *
      {
         if(this._expandedList == param1)
         {
            return false;
         }
         this._expandedList = param1;
         if(this._expandedList)
         {
            this.mcHubMapPinCategoryList.itemRendererList = this._renderersListLong;
            this.mcHubMapPinCategoryList.invalidateData();
            this.mcHubMapPinCategoryList.validateNow();
         }
         else
         {
            this.mcHubMapPinCategoryList.itemRendererList = this._renderersListShort;
         }
         this.updateArrowButtons();
         this.updateRenderersVisibility();
         return true;
      }
      
      private function resizeHitArea() : *
      {
         var _loc5_:Rectangle = null;
         var _loc6_:CategoryData = null;
         var _loc7_:Vector.<IListItemRenderer> = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:HubMapPinCategoryItemRenderer = null;
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this.mcHubMapPinArrowUp.visible)
         {
            _loc5_ = this.mcHubMapPinArrowUp.getBounds(this);
            if(isNaN(_loc3_) || _loc3_ > _loc5_.top)
            {
               _loc3_ = _loc5_.top;
            }
         }
         if(this.mcHubMapPinArrowDown.visible)
         {
            _loc5_ = this.mcHubMapPinArrowDown.getBounds(this);
            if(isNaN(_loc4_) || _loc4_ < _loc5_.bottom)
            {
               _loc4_ = _loc5_.bottom;
            }
         }
         if(this._currentCategoryIndex > -1 && this._categories.length > 0)
         {
            _loc6_ = this._categories[this._currentCategoryIndex];
            _loc7_ = this.mcHubMapPinCategoryList.getRenderers();
            _loc8_ = 0;
            while(_loc8_ < _loc7_.length)
            {
               if((_loc9_ = _loc8_ + this.mcHubMapPinCategoryList.scrollPosition) < _loc6_._pins.length)
               {
                  if(_loc10_ = _loc7_[_loc8_] as HubMapPinCategoryItemRenderer)
                  {
                     _loc5_ = _loc10_.getBounds(this);
                     if(isNaN(_loc1_) || _loc1_ > _loc5_.left)
                     {
                        _loc1_ = _loc5_.left;
                     }
                     if(isNaN(_loc2_) || _loc2_ < _loc5_.right)
                     {
                        _loc2_ = _loc5_.right;
                     }
                     if(isNaN(_loc3_) || _loc3_ > _loc5_.top)
                     {
                        _loc3_ = _loc5_.top;
                     }
                     if(isNaN(_loc4_) || _loc4_ < _loc5_.bottom)
                     {
                        _loc4_ = _loc5_.bottom;
                     }
                  }
               }
               _loc8_++;
            }
         }
         this.mcHubMapPinCategoryList.x = _loc1_;
         this.mcHubMapPinCategoryList.y = _loc3_;
         this.mcHubMapPinCategoryList.scaleX = (_loc2_ - _loc1_) / 100;
         this.mcHubMapPinCategoryList.scaleY = (_loc4_ - _loc3_) / 100;
      }
      
      private function resetSelection() : *
      {
         this.mcHubMapPinCategoryList.scrollPosition = 0;
         this.mcHubMapPinCategoryList.selectedIndex = -1;
         this.updateArrowButtons();
      }
      
      private function updateRenderersVisibility() : *
      {
         var _loc1_:int = 0;
         var _loc2_:HubMapPinCategoryItemRenderer = null;
         _loc1_ = this.SHORT_LIST_COUNT + 1;
         while(_loc1_ <= this.LONG_LIST_COUNT)
         {
            if(this._expandedList)
            {
               if(this._currentCategoryIndex > -1)
               {
                  if(_loc1_ - 1 >= this._categories[this._currentCategoryIndex]._pins.length)
                  {
                     break;
                  }
               }
            }
            _loc2_ = getChildByName("mcHubMapPinCategoryItem" + _loc1_) as HubMapPinCategoryItemRenderer;
            if(_loc2_)
            {
               _loc2_.visible = this._expandedList;
            }
            _loc1_++;
         }
         if(this._expandedList)
         {
            _loc2_ = getChildByName("mcHubMapPinCategoryItem" + this.LONG_LIST_COUNT) as HubMapPinCategoryItemRenderer;
         }
         else
         {
            _loc2_ = getChildByName("mcHubMapPinCategoryItem" + this.SHORT_LIST_COUNT) as HubMapPinCategoryItemRenderer;
         }
         if(_loc2_)
         {
            this.mcHubMapPinArrowUp.y = _loc2_.y;
         }
      }
      
      private function changePinIndexForSelectedItem(param1:int) : *
      {
         var _loc2_:HubMapPinCategoryItemRenderer = null;
         _loc2_ = this.mcHubMapPinCategoryList.getRendererAt(this.mcHubMapPinCategoryList.selectedIndex,this.mcHubMapPinCategoryList.scrollPosition) as HubMapPinCategoryItemRenderer;
         if(_loc2_)
         {
            this.changePinIndex(_loc2_,param1);
         }
      }
      
      private function changePinIndex(param1:HubMapPinCategoryItemRenderer, param2:int) : *
      {
         var _loc3_:CategoryData = null;
         var _loc4_:CategoryPinData = null;
         var _loc5_:HubMapPinCategoryItemRenderer = null;
         if(this.funcIsAnimationRunning())
         {
            return;
         }
         _loc5_ = this.mcHubMapPinCategoryList.getRendererAt(this.mcHubMapPinCategoryList.selectedIndex,this.mcHubMapPinCategoryList.scrollPosition) as HubMapPinCategoryItemRenderer;
         if(param1 != _loc5_)
         {
            return;
         }
         if(!param1)
         {
            return;
         }
         _loc3_ = this._categories[this._currentCategoryIndex];
         if(_loc3_)
         {
            if(_loc4_ = _loc3_._pins[this.mcHubMapPinCategoryList.selectedIndex])
            {
               _loc4_._index = (_loc4_._index + param2 + _loc4_._instances.length) % _loc4_._instances.length;
               param1.setCounter(_loc4_._index,_loc4_._instances.length);
               this.centerOnPin();
            }
         }
      }
      
      private function togglePin(param1:String) : *
      {
         if(this.isPinDisabled(param1))
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnDisablePin",[param1,false]));
            delete this._disabledPins[param1];
         }
         else
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnDisablePin",[param1,true]));
            this._disabledPins[param1] = param1;
         }
         if(this._currentCategoryIndex > -1)
         {
            this.updatePinsFromCategory(this._categories[this._currentCategoryIndex],false);
         }
      }
      
      private function isPinDisabled(param1:String) : Boolean
      {
         return this._disabledPins.hasOwnProperty(param1);
      }
      
      private function __printDisabledPins() : *
      {
         var _loc1_:String = null;
         for each(_loc1_ in this._disabledPins)
         {
         }
      }
      
      private function centerOnPin() : *
      {
         var _loc1_:CategoryData = null;
         var _loc2_:CategoryPinData = null;
         var _loc3_:CategoryPinInstanceData = null;
         _loc1_ = this._categories[this._currentCategoryIndex];
         if(_loc1_)
         {
            _loc2_ = _loc1_._pins[this.mcHubMapPinCategoryList.selectedIndex];
            if(_loc2_)
            {
               _loc3_ = _loc2_._instances[_loc2_._index];
               if(_loc3_)
               {
                  if(this.funcCenterOnWorldPosition != null)
                  {
                     this.funcCenterOnWorldPosition(_loc3_._worldPosition,true);
                  }
               }
            }
         }
      }
      
      public function addPinInstance(param1:StaticMapPinData) : *
      {
         var _loc2_:CategoryData = null;
         var _loc3_:CategoryPinData = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:PinTypeDefinition = null;
         if(param1.isPlayer || param1.type == "Herb")
         {
            return;
         }
         if(param1.isUserPin)
         {
            _loc4_ = 0;
            while(_loc4_ < this._categories.length)
            {
               _loc2_ = this._categories[_loc4_] as CategoryData;
               _loc3_ = this.__DEBUG_addPin(_loc2_,USER_PIN_TYPE,USER_PIN_TRANSLATION,this.USER_PIN_PRIORITY);
               this.__DEBUG_addInstance(_loc3_,param1.id,new Point(param1.posX,param1.posY),param1.distance);
               _loc4_++;
            }
         }
         else
         {
            _loc5_ = param1.filteredType;
            _loc6_ = param1.label;
            _loc8_ = 999999;
            if(_loc9_ = this._pinTypeDefinitions[_loc5_])
            {
               _loc7_ = _loc9_._category;
               _loc8_ = _loc9_._priority;
            }
            if(param1.isFastTravel)
            {
               if(_loc5_ == "RoadSign")
               {
                  _loc6_ = ROADSIGN_PIN_TRANSLATION;
               }
               else if(_loc5_ == "Harbor")
               {
                  _loc6_ = HARBOR_PIN_TRANSLATION;
               }
            }
            if(param1.isQuest)
            {
               _loc5_ = QUEST_PIN_TYPE;
               _loc6_ = QUEST_PIN_TRANSLATION;
            }
            _loc2_ = this.__DEBUG_addCategory(ALL_PINS_CATEGORY);
            _loc3_ = this.__DEBUG_addPin(_loc2_,_loc5_,_loc6_,_loc8_);
            this.__DEBUG_addInstance(_loc3_,param1.id,new Point(param1.posX,param1.posY),param1.distance);
            if(_loc7_)
            {
               _loc2_ = this.__DEBUG_addCategory(_loc7_);
               _loc3_ = this.__DEBUG_addPin(_loc2_,_loc5_,_loc6_,_loc8_);
               this.__DEBUG_addInstance(_loc3_,param1.id,new Point(param1.posX,param1.posY),param1.distance);
               if(_loc7_ == "General" || _loc7_ == "Quests" || _loc7_ == "NPCs" || _loc7_ == "Buffs" || _loc5_ == "Entrance")
               {
                  _loc2_ = this.__DEBUG_addCategory("Default");
                  _loc3_ = this.__DEBUG_addPin(_loc2_,_loc5_,_loc6_,_loc8_);
                  this.__DEBUG_addInstance(_loc3_,param1.id,new Point(param1.posX,param1.posY),param1.distance);
               }
            }
         }
      }
      
      public function removePinInstance(param1:uint) : *
      {
         var _loc2_:CategoryData = null;
         var _loc3_:CategoryPinData = null;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < this._categories.length)
         {
            _loc2_ = this._categories[_loc4_] as CategoryData;
            _loc5_ = 0;
            while(_loc5_ < _loc2_._pins.length)
            {
               _loc3_ = _loc2_._pins[_loc5_] as CategoryPinData;
               _loc6_ = 0;
               while(_loc6_ < _loc3_._instances.length)
               {
                  if(_loc3_._instances[_loc6_]._id == param1)
                  {
                     _loc3_._instances.splice(_loc6_,1);
                     _loc3_._index = 0;
                     break;
                  }
                  _loc6_++;
               }
               _loc5_++;
            }
            _loc4_++;
         }
      }
      
      public function OnControllerChanged(param1:*) : *
      {
         this._allowShowingCategoryButtonSelection = param1;
         this.updateCategoryButtonSelection();
         this.resizeHitArea();
      }
   }
}

class CategoryDefinition
{
    
   
   public var _priority:int;
   
   public var _showUserPins:Boolean;
   
   public var _showFastTravelPins:Boolean;
   
   public var _showQuestPins:Boolean;
   
   public function CategoryDefinition(param1:int, param2:Boolean, param3:Boolean, param4:Boolean)
   {
      super();
      this._priority = param1;
      this._showUserPins = param2;
      this._showFastTravelPins = param3;
      this._showQuestPins = param4;
   }
}

class PinTypeDefinition
{
    
   
   public var _category:String;
   
   public var _priority:int;
   
   public function PinTypeDefinition(param1:String, param2:int)
   {
      super();
      this._category = param1;
      this._priority = param2;
   }
   
   public function toString() : String
   {
      return "[C] " + this._category + " [P] " + this._priority;
   }
}
