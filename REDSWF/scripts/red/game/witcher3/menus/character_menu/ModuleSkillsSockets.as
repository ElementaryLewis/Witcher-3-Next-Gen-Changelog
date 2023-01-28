package red.game.witcher3.menus.character_menu
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import red.core.CoreMenuModule;
   import red.core.constants.KeyCode;
   import red.game.witcher3.constants.InventorySlotType;
   import red.game.witcher3.constants.SkillColor;
   import red.game.witcher3.managers.InputFeedbackManager;
   import red.game.witcher3.slots.SlotBase;
   import red.game.witcher3.slots.SlotPaperdoll;
   import red.game.witcher3.slots.SlotSkillMutagen;
   import red.game.witcher3.slots.SlotSkillSocket;
   import red.game.witcher3.slots.SlotsListSkillSockets;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.controls.Button;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   
   public class ModuleSkillsSockets extends CoreMenuModule
   {
       
      
      public var gr1_socket1:SlotSkillSocket;
      
      public var gr1_socket2:SlotSkillSocket;
      
      public var gr1_socket3:SlotSkillSocket;
      
      public var gr1_mutagen:SlotSkillMutagen;
      
      public var gr2_socket1:SlotSkillSocket;
      
      public var gr2_socket2:SlotSkillSocket;
      
      public var gr2_socket3:SlotSkillSocket;
      
      public var gr2_mutagen:SlotSkillMutagen;
      
      public var gr3_socket1:SlotSkillSocket;
      
      public var gr3_socket2:SlotSkillSocket;
      
      public var gr3_socket3:SlotSkillSocket;
      
      public var gr3_mutagen:SlotSkillMutagen;
      
      public var gr4_socket1:SlotSkillSocket;
      
      public var gr4_socket2:SlotSkillSocket;
      
      public var gr4_socket3:SlotSkillSocket;
      
      public var gr4_mutagen:SlotSkillMutagen;
      
      public var bonusSocket1:SlotSkillSocket;
      
      public var bonusSocket2:SlotSkillSocket;
      
      public var bonusSocket3:SlotSkillSocket;
      
      public var bonusSocket4:SlotSkillSocket;
      
      public var groupConnector1:SkillSlotConnector;
      
      public var groupConnector2:SkillSlotConnector;
      
      public var groupConnector3:SkillSlotConnector;
      
      public var groupConnector4:SkillSlotConnector;
      
      public var connector_g1_s1:SkillSlotConnector;
      
      public var connector_g1_s2:SkillSlotConnector;
      
      public var connector_g1_s3:SkillSlotConnector;
      
      public var connector_g2_s1:SkillSlotConnector;
      
      public var connector_g2_s2:SkillSlotConnector;
      
      public var connector_g2_s3:SkillSlotConnector;
      
      public var connector_g3_s1:SkillSlotConnector;
      
      public var connector_g3_s2:SkillSlotConnector;
      
      public var connector_g3_s3:SkillSlotConnector;
      
      public var connector_g4_s1:SkillSlotConnector;
      
      public var connector_g4_s2:SkillSlotConnector;
      
      public var connector_g4_s3:SkillSlotConnector;
      
      public var dnaBranch1:MovieClip;
      
      public var dnaBranch2:MovieClip;
      
      public var dnaBranch3:MovieClip;
      
      public var dnaBranch4:MovieClip;
      
      public var txtBonus1:TextField;
      
      public var txtBonus2:TextField;
      
      public var txtBonus3:TextField;
      
      public var txtBonus4:TextField;
      
      protected var _group1:SkillSocketsGroup;
      
      protected var _group2:SkillSocketsGroup;
      
      protected var _group3:SkillSocketsGroup;
      
      protected var _group4:SkillSocketsGroup;
      
      public var groupBonusBkg1:MovieClip;
      
      public var groupBonusBkg2:MovieClip;
      
      public var groupBonusBkg3:MovieClip;
      
      public var groupBonusBkg4:MovieClip;
      
      public var socketsList:SlotsListSkillSockets;
      
      public var mcSlotChangeHighlight:MovieClip;
      
      private var _inputSymbolIDA:int = -1;
      
      private var _inputSymbolIDX:int = -1;
      
      private var _buySkillBtnRef:Button = null;
      
      private var _pointsCount:int = 0;
      
      protected var _hideInputFeedback:Boolean;
      
      private var _additionalSkillsMode:Boolean;
      
      private var _mutationMode:Boolean;
      
      public var mcSlotsMutation:MovieClip;
      
      public var mcSlotsNormal:MovieClip;
      
      private var _currentContainer:MovieClip;
      
      public function ModuleSkillsSockets()
      {
         super();
         this.mcSlotsMutation.visible = false;
         this.mcSlotsNormal.visible = true;
         this.updateActiveSockets();
      }
      
      public function set BuySkillBtnRef(param1:Button) : void
      {
         this._buySkillBtnRef = param1;
      }
      
      private function repositionMutagenBonuses(param1:Boolean) : void
      {
         if(param1)
         {
            this.groupBonusBkg1.y = 135.15;
            this.groupBonusBkg2.y = 135.15;
            this.groupBonusBkg3.y = 285.15;
            this.groupBonusBkg4.y = 285.15;
            this.txtBonus1.y = 155.55;
            this.txtBonus2.y = 155.55;
            this.txtBonus3.y = 305.1;
            this.txtBonus4.y = 305.1;
         }
         else
         {
            this.groupBonusBkg1.y = 91;
            this.groupBonusBkg2.y = 91;
            this.groupBonusBkg3.y = 349;
            this.groupBonusBkg4.y = 349;
            this.txtBonus1.y = 116;
            this.txtBonus2.y = 116;
            this.txtBonus3.y = 367;
            this.txtBonus4.y = 367;
         }
      }
      
      private function updateActiveSockets() : void
      {
         var _loc1_:MovieClip = this.mcSlotsNormal.visible ? this.mcSlotsNormal : this.mcSlotsMutation;
         this.repositionMutagenBonuses(this.mcSlotsNormal.visible);
         if(this._currentContainer != _loc1_)
         {
            this._currentContainer = _loc1_;
            this.bonusSocket1 = _loc1_.bonusSocket1;
            this.bonusSocket2 = _loc1_.bonusSocket2;
            this.bonusSocket3 = _loc1_.bonusSocket3;
            this.bonusSocket4 = _loc1_.bonusSocket4;
            this.gr1_socket1 = _loc1_.gr1_socket1;
            this.gr1_socket2 = _loc1_.gr1_socket2;
            this.gr1_socket3 = _loc1_.gr1_socket3;
            this.gr2_socket1 = _loc1_.gr2_socket1;
            this.gr2_socket2 = _loc1_.gr2_socket2;
            this.gr2_socket3 = _loc1_.gr2_socket3;
            this.gr3_socket1 = _loc1_.gr3_socket1;
            this.gr3_socket2 = _loc1_.gr3_socket2;
            this.gr3_socket3 = _loc1_.gr3_socket3;
            this.gr4_socket1 = _loc1_.gr4_socket1;
            this.gr4_socket2 = _loc1_.gr4_socket2;
            this.gr4_socket3 = _loc1_.gr4_socket3;
            this.gr1_mutagen = _loc1_.gr1_mutagen;
            this.gr2_mutagen = _loc1_.gr2_mutagen;
            this.gr3_mutagen = _loc1_.gr3_mutagen;
            this.gr4_mutagen = _loc1_.gr4_mutagen;
            this.connector_g1_s1 = _loc1_.connector_g1_s1;
            this.connector_g1_s2 = _loc1_.connector_g1_s2;
            this.connector_g1_s3 = _loc1_.connector_g1_s3;
            this.groupConnector1 = _loc1_.groupConnector1;
            this.connector_g2_s1 = _loc1_.connector_g2_s1;
            this.connector_g2_s2 = _loc1_.connector_g2_s2;
            this.connector_g2_s3 = _loc1_.connector_g2_s3;
            this.groupConnector2 = _loc1_.groupConnector2;
            this.connector_g3_s1 = _loc1_.connector_g3_s1;
            this.connector_g3_s2 = _loc1_.connector_g3_s2;
            this.connector_g3_s3 = _loc1_.connector_g3_s3;
            this.groupConnector3 = _loc1_.groupConnector3;
            this.connector_g4_s1 = _loc1_.connector_g4_s1;
            this.connector_g4_s2 = _loc1_.connector_g4_s2;
            this.connector_g4_s3 = _loc1_.connector_g4_s3;
            this.groupConnector4 = _loc1_.groupConnector4;
            this.initGroups();
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.socketsList.slotContainer = this.mcSlotsNormal;
         this.socketsList.addEventListener(ListEvent.INDEX_CHANGE,this.OnSkillTreeClicked,false,0,true);
         this.socketsList.focusable = false;
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         this.bonusSocket1.visible = this.bonusSocket1.selectable = false;
         this.bonusSocket2.visible = this.bonusSocket2.selectable = false;
         this.bonusSocket3.visible = this.bonusSocket3.selectable = false;
         this.bonusSocket4.visible = this.bonusSocket4.selectable = false;
      }
      
      protected function OnSkillTreeClicked(param1:ListEvent) : void
      {
         this.UpdateSelectedItemInputFeedback();
      }
      
      public function get pointsCount() : int
      {
         return this._pointsCount;
      }
      
      public function set pointsCount(param1:int) : void
      {
         this._pointsCount = param1;
      }
      
      public function updateSocket(param1:Object) : void
      {
         this.socketsList.updateSpecificData(param1);
         this.UpdateSelectedItemInputFeedback();
      }
      
      public function clearSkillSlot(param1:int) : void
      {
         this.socketsList.clearSkillSlot(param1);
         this.UpdateSelectedItemInputFeedback();
      }
      
      protected function UpdateSelectedItemInputFeedback() : void
      {
         var _loc2_:Boolean = false;
         var _loc5_:String = null;
         var _loc1_:SlotBase = this.socketsList.getSelectedRenderer() as SlotBase;
         var _loc3_:SlotSkillSocket = _loc1_ as SlotSkillSocket;
         var _loc4_:SlotSkillMutagen = _loc1_ as SlotSkillMutagen;
         if(_loc3_)
         {
            _loc2_ = _loc3_.isLocked;
         }
         else if(_loc4_)
         {
            _loc2_ = _loc4_.isLocked();
         }
         else
         {
            _loc2_ = false;
         }
         if(this._inputSymbolIDA != -1)
         {
            InputFeedbackManager.removeButton(this,this._inputSymbolIDA);
            this._inputSymbolIDA = -1;
         }
         if(this._inputSymbolIDX != -1)
         {
            InputFeedbackManager.removeButton(this,this._inputSymbolIDX);
            this._inputSymbolIDX = -1;
            if(this._buySkillBtnRef)
            {
               this._buySkillBtnRef.enabled = false;
            }
         }
         if(this._hideInputFeedback)
         {
            InputFeedbackManager.updateButtons(this);
            return;
         }
         if(Boolean(_focused) && Boolean(_loc1_))
         {
            if(_loc4_)
            {
               if(_loc4_.isMutEquiped())
               {
                  this._inputSymbolIDA = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_A,KeyCode.SPACE,"panel_character_slot_remove_skill");
               }
               else if(!_loc4_.isLocked())
               {
                  this._inputSymbolIDA = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_A,KeyCode.SPACE,"panel_button_common_select");
               }
            }
            else if(_loc1_.data != null && _loc1_.data.skillPath != SlotSkillSocket.NULL_SKILL)
            {
               this._inputSymbolIDA = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_A,KeyCode.SPACE,"panel_character_slot_remove_skill");
               if(!_loc1_.data.isMutagen && _loc1_.data.level < _loc1_.data.maxLevel)
               {
                  _loc5_ = _loc1_.data.level == 0 ? "panel_character_popup_title_buy_skill" : "panel_character_popup_title_upgrade_skill";
                  this._inputSymbolIDX = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_X,KeyCode.E,_loc5_);
                  if(this._buySkillBtnRef)
                  {
                     this._buySkillBtnRef.label = _loc5_;
                     this._buySkillBtnRef.enabled = true;
                  }
               }
            }
            else if(!_loc2_ && _loc1_.data != null)
            {
               this._inputSymbolIDA = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_A,KeyCode.SPACE,"panel_button_common_select");
            }
         }
         InputFeedbackManager.updateButtons(this);
      }
      
      override public function set focused(param1:Number) : void
      {
         super.focused = param1;
         this.UpdateSelectedItemInputFeedback();
         this.updateActiveSelectionEnabled();
      }
      
      public function get additionalSkillsMode() : Boolean
      {
         return this._additionalSkillsMode;
      }
      
      public function set additionalSkillsMode(param1:Boolean) : void
      {
         this._additionalSkillsMode = param1;
      }
      
      public function get mutationMode() : Boolean
      {
         return this._mutationMode;
      }
      
      public function set mutationMode(param1:Boolean) : void
      {
         this._mutationMode = param1;
         if(this._mutationMode)
         {
            this.socketsList.slotContainer = this.mcSlotsMutation;
            this.mcSlotsNormal.mouseChildren = this.mcSlotsNormal.mouseEnabled = this.mcSlotsNormal.visible = false;
            this.mcSlotsMutation.mouseChildren = this.mcSlotsMutation.mouseEnabled = this.mcSlotsMutation.visible = true;
         }
         else
         {
            this.socketsList.slotContainer = this.mcSlotsNormal;
            this.mcSlotsNormal.mouseChildren = this.mcSlotsNormal.mouseEnabled = this.mcSlotsNormal.visible = true;
            this.mcSlotsMutation.mouseChildren = this.mcSlotsMutation.mouseEnabled = this.mcSlotsMutation.visible = false;
         }
         this.bonusSocket1.visible = this.bonusSocket1.selectable = this._mutationMode;
         this.bonusSocket2.visible = this.bonusSocket2.selectable = this._mutationMode;
         this.bonusSocket3.visible = this.bonusSocket3.selectable = this._mutationMode;
         this.bonusSocket4.visible = this.bonusSocket4.selectable = this._mutationMode;
         this.updateActiveSockets();
      }
      
      public function get hideInputFeedback() : Boolean
      {
         return this._hideInputFeedback;
      }
      
      public function set hideInputFeedback(param1:Boolean) : void
      {
         this._hideInputFeedback = param1;
         this.UpdateSelectedItemInputFeedback();
      }
      
      public function setData(param1:Array) : void
      {
         this.socketsList.data = param1;
         this.socketsList.validateNow();
         this.updateActiveSelectionEnabled();
         removeEventListener(Event.ENTER_FRAME,this.validateSelection,false);
         addEventListener(Event.ENTER_FRAME,this.validateSelection,false,0,true);
      }
      
      private function validateSelection(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.validateSelection,false);
         this.socketsList.validateNow();
         this.socketsList.selectedIndex = this.mcSlotsNormal.visible ? 3 : 19;
      }
      
      protected function updateActiveSelectionEnabled() : void
      {
         var _loc1_:SlotBase = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.socketsList.getRenderersCount())
         {
            _loc1_ = this.socketsList.getRendererAt(_loc2_) as SlotBase;
            if(_loc1_)
            {
               _loc1_.activeSelectionEnabled = focused != 0;
            }
            _loc2_++;
         }
      }
      
      public function hasSkillSlotUnlocked() : Boolean
      {
         var _loc1_:SlotSkillSocket = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.socketsList.getRenderersCount())
         {
            _loc1_ = this.socketsList.getRendererAt(_loc2_) as SlotSkillSocket;
            if(Boolean(_loc1_) && !_loc1_.isLocked)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function hasMutagenSlotUnlocked() : Boolean
      {
         var _loc1_:SlotSkillMutagen = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.socketsList.getRenderersCount())
         {
            _loc1_ = this.socketsList.getRendererAt(_loc2_) as SlotSkillMutagen;
            if(Boolean(_loc1_) && !_loc1_.isLocked())
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function setBonusData(param1:Array) : void
      {
         this.txtBonus1.htmlText = param1[0].description;
         this.txtBonus2.htmlText = param1[1].description;
         this.txtBonus3.htmlText = param1[2].description;
         this.txtBonus4.htmlText = param1[3].description;
         this.groupBonusBkg1.gotoAndStop(SkillColor.enumToName(param1[0].color));
         this.groupBonusBkg2.gotoAndStop(SkillColor.enumToName(param1[1].color));
         this.groupBonusBkg3.gotoAndStop(SkillColor.enumToName(param1[2].color));
         this.groupBonusBkg4.gotoAndStop(SkillColor.enumToName(param1[3].color));
      }
      
      public function setMutagensData(param1:Array) : void
      {
         var _loc4_:Object = null;
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1[_loc3_];
            switch(_loc4_.slotId)
            {
               case InventorySlotType.SkillMutagen1:
                  this._group1.mutagenData = _loc4_;
                  break;
               case InventorySlotType.SkillMutagen2:
                  this._group2.mutagenData = _loc4_;
                  break;
               case InventorySlotType.SkillMutagen3:
                  this._group3.mutagenData = _loc4_;
                  break;
               case InventorySlotType.SkillMutagen4:
                  this._group4.mutagenData = _loc4_;
                  break;
            }
            _loc3_++;
         }
         this.UpdateSelectedItemInputFeedback();
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         if(!focused)
         {
            return;
         }
         if(!param1.handled)
         {
            this.socketsList.handleInputPreset(param1);
            this.socketsList.handleInput(param1);
         }
      }
      
      public function disableMutagens(param1:Boolean) : void
      {
         this.gr1_mutagen.enabled = !param1;
         this.gr2_mutagen.enabled = !param1;
         this.gr3_mutagen.enabled = !param1;
         this.gr4_mutagen.enabled = !param1;
      }
      
      public function SetUnselectableLockedAndMutagens(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:SlotBase = null;
         var _loc4_:SlotSkillSocket = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         _loc2_ = 0;
         while(_loc2_ < this.socketsList.getRenderersLength())
         {
            _loc3_ = this.socketsList.getRendererAt(_loc2_) as SlotBase;
            if(_loc3_)
            {
               if(_loc4_ = _loc3_ as SlotSkillSocket)
               {
                  if(_loc4_.isLocked)
                  {
                     _loc3_.selectable = false;
                  }
                  else if(param1 && _loc4_.data && Boolean(_loc4_.data.colorBorder))
                  {
                     _loc5_ = 3;
                     _loc6_ = _loc4_.data;
                     _loc7_ = param1.substr(_loc5_).toUpperCase();
                     if((_loc8_ = String(_loc4_.data.colorBorder.toUpperCase())).indexOf(_loc7_) < 0)
                     {
                        _loc3_.selectable = false;
                     }
                  }
               }
               else if(_loc3_ is SlotSkillMutagen)
               {
                  _loc3_.selectable = false;
               }
            }
            _loc2_++;
         }
      }
      
      public function disableNonMutagensAndLocked() : void
      {
         var _loc1_:int = 0;
         var _loc2_:SlotBase = null;
         _loc1_ = 0;
         while(_loc1_ < this.socketsList.getRenderersLength())
         {
            _loc2_ = this.socketsList.getRendererAt(_loc1_) as SlotBase;
            if(_loc2_)
            {
               if(_loc2_ is SlotSkillSocket)
               {
                  _loc2_.selectable = false;
               }
               else if(_loc2_ is SlotSkillMutagen && (_loc2_ as SlotSkillMutagen).isLocked())
               {
                  _loc2_.selectable = false;
               }
            }
            _loc1_++;
         }
      }
      
      public function SetAllSelectable() : void
      {
         var _loc1_:int = 0;
         var _loc2_:SlotBase = null;
         _loc1_ = 0;
         while(_loc1_ < this.socketsList.getRenderersLength())
         {
            _loc2_ = this.socketsList.getRendererAt(_loc1_) as SlotBase;
            if(_loc2_)
            {
               _loc2_.selectable = _loc2_.visible;
            }
            _loc1_++;
         }
      }
      
      public function setSelectionMode(param1:Boolean) : void
      {
         var _loc2_:SlotPaperdoll = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.socketsList.getRenderersLength())
         {
            _loc2_ = this.socketsList.getRendererAt(_loc3_) as SlotPaperdoll;
            if(_loc2_)
            {
               _loc2_.selectionMode = param1;
            }
            _loc3_++;
         }
      }
      
      protected function initGroups() : void
      {
         this._group1 = new SkillSocketsGroup();
         this._group1.dnaBranch = this.dnaBranch1;
         this._group1.connector = this.groupConnector1;
         this._group1.mutagenSlot = this.gr1_mutagen;
         this._group1.addSlotConnector(this.connector_g1_s1);
         this._group1.addSlotConnector(this.connector_g1_s2);
         this._group1.addSlotConnector(this.connector_g1_s3);
         this._group1.addSlotSkillRef(this.gr1_socket1);
         this._group1.addSlotSkillRef(this.gr1_socket2);
         this._group1.addSlotSkillRef(this.gr1_socket3);
         this.gr1_socket1.skillSocketGroupRef = this._group1;
         this.gr1_socket2.skillSocketGroupRef = this._group1;
         this.gr1_socket3.skillSocketGroupRef = this._group1;
         this._group2 = new SkillSocketsGroup();
         this._group2.dnaBranch = this.dnaBranch2;
         this._group2.connector = this.groupConnector2;
         this._group2.mutagenSlot = this.gr2_mutagen;
         this._group2.addSlotConnector(this.connector_g2_s1);
         this._group2.addSlotConnector(this.connector_g2_s2);
         this._group2.addSlotConnector(this.connector_g2_s3);
         this._group2.addSlotSkillRef(this.gr2_socket1);
         this._group2.addSlotSkillRef(this.gr2_socket2);
         this._group2.addSlotSkillRef(this.gr2_socket3);
         this.gr2_socket1.skillSocketGroupRef = this._group2;
         this.gr2_socket2.skillSocketGroupRef = this._group2;
         this.gr2_socket3.skillSocketGroupRef = this._group2;
         this._group3 = new SkillSocketsGroup();
         this._group3.dnaBranch = this.dnaBranch3;
         this._group3.connector = this.groupConnector3;
         this._group3.mutagenSlot = this.gr3_mutagen;
         this._group3.addSlotConnector(this.connector_g3_s1);
         this._group3.addSlotConnector(this.connector_g3_s2);
         this._group3.addSlotConnector(this.connector_g3_s3);
         this._group3.addSlotSkillRef(this.gr3_socket1);
         this._group3.addSlotSkillRef(this.gr3_socket2);
         this._group3.addSlotSkillRef(this.gr3_socket3);
         this.gr3_socket1.skillSocketGroupRef = this._group3;
         this.gr3_socket2.skillSocketGroupRef = this._group3;
         this.gr3_socket3.skillSocketGroupRef = this._group3;
         this._group4 = new SkillSocketsGroup();
         this._group4.dnaBranch = this.dnaBranch4;
         this._group4.connector = this.groupConnector4;
         this._group4.mutagenSlot = this.gr4_mutagen;
         this._group4.addSlotConnector(this.connector_g4_s1);
         this._group4.addSlotConnector(this.connector_g4_s2);
         this._group4.addSlotConnector(this.connector_g4_s3);
         this._group4.addSlotSkillRef(this.gr4_socket1);
         this._group4.addSlotSkillRef(this.gr4_socket2);
         this._group4.addSlotSkillRef(this.gr4_socket3);
         this.gr4_socket1.skillSocketGroupRef = this._group4;
         this.gr4_socket2.skillSocketGroupRef = this._group4;
         this.gr4_socket3.skillSocketGroupRef = this._group4;
         this.gr1_mutagen.cleanup();
         this.gr2_mutagen.cleanup();
         this.gr3_mutagen.cleanup();
         this.gr4_mutagen.cleanup();
      }
   }
}
