package red.game.witcher3.menus.inventory_menu
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.core.events.GameEvent;
   import red.game.witcher3.slots.SlotPaperdoll;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class ModulePaperdoll extends ModulePaperdollBase
   {
       
      
      public var mcPaperDollSlot1:SlotPaperdoll;
      
      public var mcPaperDollSlot2:SlotPaperdoll;
      
      public var mcPaperDollSlot3:SlotPaperdoll;
      
      public var mcPaperDollSlot4:SlotPaperdoll;
      
      public var mcPaperDollSlot5:SlotPaperdoll;
      
      public var mcPaperDollSlot6:SlotPaperdoll;
      
      public var mcPaperDollSlot19:SlotPaperdoll;
      
      public var mcPaperDollSlot20:SlotPaperdoll;
      
      public var mcPaperDollSlot7:SlotPaperdoll;
      
      public var mcPaperDollSlot13:SlotPaperdoll;
      
      public var mcPaperDollSlot8:SlotPaperdoll;
      
      public var mcPaperDollSlot14:SlotPaperdoll;
      
      public var mcPaperDollSlot9:SlotPaperdoll;
      
      public var mcPaperDollSlot10:SlotPaperdoll;
      
      public var mcPaperDollSlot11:SlotPaperdoll;
      
      public var mcPaperDollSlot12:SlotPaperdoll;
      
      public var mcPaperDollSlot15:SlotPaperdoll;
      
      public var mcPaperDollSlot16:SlotPaperdoll;
      
      public var mcPaperDollSlot17:SlotPaperdoll;
      
      public var mcPaperDollSlot18:SlotPaperdoll;
      
      public var tfCurrentState:TextField;
      
      public var tfPotions:TextField;
      
      public var tfPockets:TextField;
      
      public var tfPetards:TextField;
      
      public var tfMasks:TextField;
      
      public var mcSegmentBorderWeapons:MovieClip;
      
      public var mcSegmentBorderArmor:MovieClip;
      
      public var mcSegmentBorderPotion:MovieClip;
      
      public var mcSegmentBorderBombs:MovieClip;
      
      public var mcSegmentBorderHorse:MovieClip;
      
      public var mcPreviewIcon:MovieClip;
      
      protected var _previewMode:Boolean;
      
      protected var _moduleDisplayName:String = "";
      
      protected var _sectionsData:Array;
      
      public function ModulePaperdoll()
      {
         this._sectionsData = [];
         super();
         dataBindingKey = "inventory.paperdoll";
         this.mcPreviewIcon.visible = false;
         this.createSection(1,-1,2,-1,3,this.mcSegmentBorderWeapons,[this.mcPaperDollSlot1,this.mcPaperDollSlot2,this.mcPaperDollSlot3,this.mcPaperDollSlot4]);
         this.createSection(2,1,-1,-1,4,this.mcSegmentBorderArmor,[this.mcPaperDollSlot9,this.mcPaperDollSlot10,this.mcPaperDollSlot11,this.mcPaperDollSlot12]);
         this.createSection(3,-1,4,1,5,this.mcSegmentBorderPotion,[this.mcPaperDollSlot5,this.mcPaperDollSlot6,this.mcPaperDollSlot19,this.mcPaperDollSlot20]);
         this.createSection(4,3,-1,2,5,this.mcSegmentBorderHorse,[this.mcPaperDollSlot15,this.mcPaperDollSlot16,this.mcPaperDollSlot17,this.mcPaperDollSlot18]);
         this.createSection(5,-1,4,3,-1,this.mcSegmentBorderBombs,[this.mcPaperDollSlot7,this.mcPaperDollSlot8,this.mcPaperDollSlot13,this.mcPaperDollSlot14]);
         this.mcPaperDollSlot13.selectable = false;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"inventory.grid.paperdoll",[handlePaperdollDataSet]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"inventory.grid.paperdoll.item.update",[handlePaperdollUpdateItem]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"inventory.grid.paperdoll.items.update",[handlePaperdollUpdateItems]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"inventory.grid.paperdoll.name",[this.handleModuleNameSet]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"inventory.grid.paperdoll.pockets",[this.handlePocketsSlotsNameSet]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"inventory.grid.paperdoll.potions",[this.handlePotionsSlotsNameSet]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"inventory.grid.paperdoll.petards",[this.handlePetardsSlotsNameSet]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"inventory.grid.paperdoll.masks",[this.handleMasksSlotsNameSet]));
         this.updateSectionBorders();
      }
      
      public function get previewMode() : Boolean
      {
         return this._previewMode;
      }
      
      public function set previewMode(param1:Boolean) : void
      {
         this._previewMode = param1;
         if(this.mcPreviewIcon)
         {
            this.mcPreviewIcon.visible = param1;
         }
      }
      
      private function createSection(param1:int, param2:int, param3:int, param4:int, param5:int, param6:MovieClip, param7:Array) : void
      {
         var _loc8_:Object;
         (_loc8_ = {}).id = param1;
         _loc8_.nLeft = param2;
         _loc8_.nRight = param3;
         _loc8_.nUp = param4;
         _loc8_.nDown = param5;
         _loc8_.list = param7;
         _loc8_.border = param6;
         var _loc9_:int = int(param7.length);
         var _loc10_:int = 0;
         while(_loc10_ < _loc9_)
         {
            (param7[_loc10_] as SlotPaperdoll).sectionId = param1;
            _loc10_++;
         }
         this._sectionsData.push(_loc8_);
      }
      
      private function getSectionData(param1:int) : Object
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         if(this._sectionsData)
         {
            _loc2_ = int(this._sectionsData.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if((_loc4_ = this._sectionsData[_loc3_]).id == param1)
               {
                  return _loc4_;
               }
               _loc3_++;
            }
         }
         return null;
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         super.handleInput(param1);
         var _loc2_:InputDetails = param1.details;
         if(param1.handled || _loc2_.value != InputValue.KEY_DOWN)
         {
            return;
         }
         var _loc3_:SlotPaperdoll = mcPaperdoll.getSelectedRenderer() as SlotPaperdoll;
         if(focused && _loc3_ && _loc3_.sectionId != -1)
         {
            _loc4_ = _loc3_.sectionId;
            if(!(_loc5_ = this.getSectionData(_loc3_.sectionId)))
            {
               throw new Error("Cant find section " + _loc3_.sectionId + " data for paperdol component!");
            }
            _loc6_ = -1;
            switch(_loc2_.navEquivalent)
            {
               case NavigationCode.RIGHT_STICK_LEFT:
                  _loc6_ = int(_loc5_.nLeft);
                  break;
               case NavigationCode.RIGHT_STICK_RIGHT:
                  _loc6_ = int(_loc5_.nRight);
                  break;
               case NavigationCode.RIGHT_STICK_UP:
                  _loc6_ = int(_loc5_.nUp);
                  break;
               case NavigationCode.RIGHT_STICK_DOWN:
                  _loc6_ = int(_loc5_.nDown);
            }
            if(_loc6_ != -1)
            {
               if(!((_loc7_ = this.getSectionData(_loc6_)) && _loc7_.list && (_loc7_.list as Array).length > 0))
               {
                  throw new Error("Cant find section " + _loc3_.sectionId + " data for paperdol component!");
               }
               mcPaperdoll.selectedIndex = (_loc7_.list[0] as SlotPaperdoll).index;
               param1.handled = true;
            }
         }
      }
      
      override public function startSelectModeWithValidSlots(param1:Array) : void
      {
         super.startSelectModeWithValidSlots(param1);
         var _loc2_:* = 0.1;
         this.mcSegmentBorderWeapons.alpha = this.mcPaperDollSlot1.selectable || this.mcPaperDollSlot2.selectable || this.mcPaperDollSlot3.selectable || this.mcPaperDollSlot4.selectable ? 1 : _loc2_;
         this.mcSegmentBorderPotion.alpha = this.tfPotions.alpha = this.mcPaperDollSlot5.selectable || this.mcPaperDollSlot6.selectable || this.mcPaperDollSlot19.selectable || this.mcPaperDollSlot20.selectable ? 1 : _loc2_;
         this.mcSegmentBorderBombs.alpha = this.tfPetards.alpha = this.mcPaperDollSlot7.selectable ? 1 : _loc2_;
         this.mcSegmentBorderArmor.alpha = this.mcPaperDollSlot9.selectable || this.mcPaperDollSlot10.selectable || this.mcPaperDollSlot11.selectable || this.mcPaperDollSlot12.selectable ? 1 : _loc2_;
         this.mcSegmentBorderHorse.alpha = this.mcPaperDollSlot15.selectable || this.mcPaperDollSlot16.selectable || this.mcPaperDollSlot17.selectable || this.mcPaperDollSlot18.selectable ? 1 : _loc2_;
         this.tfPockets.alpha = this.mcPaperDollSlot8.selectable || this.mcPaperDollSlot14.selectable ? 1 : _loc2_;
      }
      
      override public function endSelectionMode() : void
      {
         super.endSelectionMode();
         this.mcSegmentBorderWeapons.alpha = 1;
         this.mcSegmentBorderPotion.alpha = 1;
         this.mcSegmentBorderBombs.alpha = 1;
         this.mcSegmentBorderArmor.alpha = 1;
         this.mcSegmentBorderHorse.alpha = 1;
         this.tfPotions.alpha = 1;
         this.tfPetards.alpha = 1;
         this.tfPockets.alpha = 1;
         this.tfMasks.alpha = 1;
         this.mcPaperDollSlot8.selectable = true;
         this.mcPaperDollSlot14.selectable = true;
         this.mcPaperDollSlot7.selectable = true;
         this.mcPaperDollSlot13.selectable = false;
         this.updateSectionBorders();
      }
      
      override public function set focused(param1:Number) : void
      {
         super.focused = param1;
         this.updateSectionBorders();
      }
      
      override protected function updateActiveContext(param1:SlotPaperdoll) : void
      {
         super.updateActiveContext(param1);
         this.updateSectionBorders();
      }
      
      protected function updateSectionBorders() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc1_:SlotPaperdoll = mcPaperdoll.getSelectedRenderer() as SlotPaperdoll;
         if(this._sectionsData)
         {
            _loc2_ = int(this._sectionsData.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = this._sectionsData[_loc3_];
               _loc5_ = 1;
               if((_loc4_.list as Array).indexOf(_loc1_) > -1 && focused > 0)
               {
                  _loc5_ = 2;
               }
               else
               {
                  _loc5_ = 1;
               }
               _loc4_.border.gotoAndStop(_loc5_);
               _loc3_++;
            }
         }
      }
      
      protected function handleModuleNameSet(param1:String) : void
      {
         this._moduleDisplayName = param1;
         this.tfCurrentState.htmlText = param1;
      }
      
      protected function handlePocketsSlotsNameSet(param1:String) : void
      {
         if(this.tfPockets)
         {
            this.tfPockets.htmlText = param1;
         }
      }
      
      protected function handlePotionsSlotsNameSet(param1:String) : void
      {
         if(this.tfPotions)
         {
            this.tfPotions.htmlText = param1;
         }
      }
      
      protected function handlePetardsSlotsNameSet(param1:String) : void
      {
         if(this.tfPetards)
         {
            this.tfPetards.htmlText = param1;
         }
      }
      
      protected function handleMasksSlotsNameSet(param1:String) : void
      {
         if(this.tfMasks)
         {
            this.tfMasks.htmlText = param1;
         }
      }
      
      override public function toString() : String
      {
         return "[W3 ModulePaperdoll]";
      }
   }
}
