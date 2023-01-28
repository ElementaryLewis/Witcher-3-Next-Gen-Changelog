package red.game.witcher3.menus.journal
{
   import flash.events.Event;
   import red.game.witcher3.controls.W3DropdownMenuListItem;
   import red.game.witcher3.menus.common.DropdownListModuleBase;
   
   public class QuestListModule extends DropdownListModuleBase
   {
       
      
      public function QuestListModule()
      {
         super();
         _itemInputFeedbackLabel = "panel_button_journal_track";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         mcDropDownList.restoreSelectionByTag = true;
         mcDropDownList.updateSurgicallyOnDataSet = true;
         stage.addEventListener(QuestItemRenderer.UNTRACK,this.handleUntrackItem,false,0,true);
      }
      
      override protected function handleValidateItemItemFeedback(param1:Event) : void
      {
         super.handleValidateItemItemFeedback(param1);
      }
      
      internal function InitDebugData() : *
      {
         var _loc1_:Array = null;
         _loc1_ = new Array();
         _loc1_.push({
            "label2":"NOVIGRAD",
            "dropDownLabel":"Novigrad",
            "label":"Destroy the Alghul",
            "isStory":true,
            "isNew":false,
            "isActive":false,
            "selected":false
         });
         _loc1_.push({
            "label2":"PROLOGUE VILLAGE",
            "dropDownLabel":"Prologue Village",
            "label":"Cook a trap",
            "isStory":false,
            "isNew":false,
            "isActive":false,
            "selected":false
         });
         _loc1_.push({
            "label2":"NOVIGRAD",
            "dropDownLabel":"Novigrad",
            "label":"Harvest Bazyliszek scales",
            "isStory":false,
            "isNew":true,
            "isActive":false,
            "selected":false
         });
         _loc1_.push({
            "label2":"SKELLIGE",
            "dropDownLabel":"Skellige",
            "label":"Conquer the bies 2",
            "isStory":false,
            "isNew":true,
            "isActive":false,
            "selected":false
         });
         _loc1_.push({
            "label2":"NOVIGRAD",
            "dropDownLabel":"Novigrad",
            "label":"Conquer the bies",
            "isStory":false,
            "isNew":false,
            "isActive":true,
            "selected":false
         });
         _loc1_.push({
            "label2":"SKELLIGE",
            "dropDownLabel":"Skellige",
            "label":"Find The Lair",
            "isStory":false,
            "isNew":false,
            "isActive":false,
            "selected":false
         });
         _loc1_.push({
            "label2":"SKELLIGE",
            "dropDownLabel":"Skellige",
            "label":"Find The Lair2",
            "isStory":false,
            "isNew":false,
            "isActive":false,
            "selected":false
         });
         _loc1_.push({
            "label2":"KEAR MORHEN",
            "dropDownLabel":"Kear Morhen",
            "label":"Free the country",
            "isStory":false,
            "isNew":false,
            "isActive":false,
            "selected":false
         });
         _loc1_.push({
            "label2":"PROLOGUE VILLAGE",
            "dropDownLabel":"Prologue Village",
            "label":"The Devil Lair",
            "isStory":false,
            "isNew":false,
            "isActive":false,
            "selected":false
         });
         _loc1_.push({
            "label2":"PROLOGUE VILLAGE",
            "dropDownLabel":"Prologue Village",
            "label":"The Devil Lair1",
            "isStory":false,
            "isNew":false,
            "isActive":false,
            "selected":false
         });
         _loc1_.push({
            "label2":"PROLOGUE VILLAGE",
            "dropDownLabel":"Prologue Village",
            "label":"The Devil Lair2",
            "isStory":false,
            "isNew":false,
            "isActive":false,
            "selected":false
         });
         _loc1_.push({
            "label2":"PROLOGUE VILLAGE",
            "dropDownLabel":"Prologue Village",
            "label":"The Devil Lair3",
            "isStory":false,
            "isNew":false,
            "isActive":false,
            "selected":false
         });
         _loc1_.push({
            "label2":"PROLOGUE VILLAGE",
            "dropDownLabel":"Prologue Village",
            "label":"The Devil Lair5",
            "isStory":false,
            "isNew":false,
            "isActive":false,
            "selected":false
         });
         _loc1_.push({
            "label2":"PROLOGUE VILLAGE",
            "dropDownLabel":"Prologue Village",
            "label":"The Devil Lair6",
            "isStory":false,
            "isNew":false,
            "isActive":false,
            "selected":false
         });
         _loc1_.push({
            "label2":"NOVIGRAD",
            "dropDownLabel":"Novigrad",
            "label":"Destroy the Alghulf",
            "isStory":true,
            "isNew":false,
            "isActive":false,
            "selected":false
         });
         _loc1_.push({
            "label2":"PROLOGUE VILLAGE",
            "dropDownLabel":"Prologue Village",
            "label":"Cook a trapf",
            "isStory":false,
            "isNew":false,
            "isActive":false,
            "selected":false
         });
         _loc1_.push({
            "label2":"NOVIGRAD",
            "dropDownLabel":"Novigrad",
            "label":"Harvest Bazyliszekf scales",
            "isStory":false,
            "isNew":true,
            "isActive":false,
            "selected":false
         });
         _loc1_.push({
            "label2":"SKELLIGE",
            "dropDownLabel":"Skellige",
            "label":"Conquer tfhe bies 2",
            "isStory":false,
            "isNew":true,
            "isActive":false,
            "selected":false
         });
         _loc1_.push({
            "label2":"NOVIGRAD",
            "dropDownLabel":"Novigrad",
            "label":"Conquer thfe bies",
            "isStory":false,
            "isNew":false,
            "isActive":true,
            "selected":false
         });
         _loc1_.push({
            "label2":"SKELLIGE",
            "dropDownLabel":"Skellige",
            "label":"Find The fLair",
            "isStory":false,
            "isNew":false,
            "isActive":false,
            "selected":false
         });
         _loc1_.push({
            "label2":"SKELLIGE",
            "dropDownLabel":"Skellige",
            "label":"Find The Laifr2",
            "isStory":false,
            "isNew":false,
            "isActive":false,
            "selected":false
         });
         _loc1_.push({
            "label2":"KEAR MORHEN",
            "dropDownLabel":"Kear Morhen",
            "label":"Free thef country",
            "isStory":false,
            "isNew":false,
            "isActive":false,
            "selected":false
         });
         _loc1_.push({
            "label2":"PROLOGUE VILLAGE",
            "dropDownLabel":"Prologue Village",
            "label":"The Devifl Lair",
            "isStory":false,
            "isNew":false,
            "isActive":false,
            "selected":false
         });
         _loc1_.push({
            "label2":"PROLOGUE VILLAGE",
            "dropDownLabel":"Prologue Village",
            "label":"The Defvil Lair1",
            "isStory":false,
            "isNew":false,
            "isActive":false,
            "selected":false
         });
         _loc1_.push({
            "label2":"PROLOGUE VILLAGE",
            "dropDownLabel":"Prologue Village",
            "label":"The Devfl Lair2",
            "isStory":false,
            "isNew":false,
            "isActive":false,
            "selected":false
         });
         _loc1_.push({
            "label2":"PROLOGUE VILLAGE",
            "dropDownLabel":"Prologue Village",
            "label":"The Devfil Lair3",
            "isStory":false,
            "isNew":false,
            "isActive":false,
            "selected":false
         });
         _loc1_.push({
            "label2":"PROLOGUE VILLAGE",
            "dropDownLabel":"Prologue Village",
            "label":"The Devifl Lair5",
            "isStory":false,
            "isNew":false,
            "isActive":false,
            "selected":false
         });
         _loc1_.push({
            "label2":"PROLOGUE VILLAGE",
            "dropDownLabel":"Prologue Village",
            "label":"The Devifl Lair6",
            "isStory":false,
            "isNew":false,
            "isActive":false,
            "selected":false
         });
         handleListData(_loc1_,-1);
      }
      
      public function handleUntrackItem(param1:Event) : *
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         if(currentDataArrayRef != null)
         {
            _loc3_ = 0;
            while(_loc3_ < currentDataArrayRef.length)
            {
               _loc2_ = currentDataArrayRef[_loc3_];
               if(Boolean(_loc2_) && _loc2_.hasOwnProperty("tracked"))
               {
                  _loc2_.tracked = false;
               }
               _loc3_++;
            }
         }
      }
      
      override protected function canShowSubItemInputFeedback(param1:W3DropdownMenuListItem) : Boolean
      {
         var _loc2_:QuestItemRenderer = param1.GetSubSelectedRenderer(true) as QuestItemRenderer;
         if(_loc2_ && !_loc2_.data.tracked && _loc2_.data.status == 1)
         {
            return true;
         }
         return false;
      }
      
      override protected function sortData(param1:Array) : void
      {
      }
      
      protected function sortQuestData(param1:*, param2:*) : int
      {
         return 0;
      }
      
      override protected function filterList(param1:*, param2:*) : int
      {
         var _loc3_:RegExp = /\b\S+$/;
         var _loc4_:* = param1.dropDownLabel.match(_loc3_);
         var _loc5_:* = param2.dropDownLabel.match(_loc3_);
         if(param1.dropDownLabel != param2.dropDownLabel)
         {
            if(_loc4_ < _loc5_)
            {
               return -1;
            }
            if(_loc4_ > _loc5_)
            {
               return 1;
            }
            return 0;
         }
         if(param1.isStory == true && param2.isStory != true)
         {
            return -1;
         }
         if(param1.isStory == true && param2.isStory == true)
         {
            return 0;
         }
         return 1;
      }
   }
}
