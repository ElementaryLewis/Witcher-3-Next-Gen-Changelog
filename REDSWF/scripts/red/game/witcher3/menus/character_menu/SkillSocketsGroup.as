package red.game.witcher3.menus.character_menu
{
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.text.TextField;
   import red.game.witcher3.slots.SlotSkillMutagen;
   import red.game.witcher3.slots.SlotSkillSocket;
   
   public class SkillSocketsGroup extends EventDispatcher
   {
       
      
      public var mutagenSlot:SlotSkillMutagen;
      
      public var dnaBranch:MovieClip;
      
      public var connector:SkillSlotConnector;
      
      public var bonusText:TextField;
      
      protected var _skillSlotConnectorsList:Vector.<SkillSlotConnector>;
      
      protected var _skillSlotRefs:Vector.<SlotSkillSocket>;
      
      protected var _currentColor:String;
      
      protected var _mutagenData:Object;
      
      internal const COLOR_NONE:String = "SC_None";
      
      internal const COLOR_MIX:String = "SC_Mix";
      
      public function SkillSocketsGroup()
      {
         super();
         this._skillSlotConnectorsList = new Vector.<SkillSlotConnector>();
         this._skillSlotRefs = new Vector.<SlotSkillSocket>();
      }
      
      public function addSlotConnector(param1:SkillSlotConnector) : void
      {
         this._skillSlotConnectorsList.push(param1);
      }
      
      public function addSlotSkillRef(param1:SlotSkillSocket) : *
      {
         this._skillSlotRefs.push(param1);
      }
      
      public function get mutagenData() : Object
      {
         return this._mutagenData;
      }
      
      public function set mutagenData(param1:Object) : void
      {
         this._mutagenData = param1;
         this._mutagenData.gridSize = 1;
         this.mutagenSlot.cleanup();
         this.mutagenSlot.data = this._mutagenData;
         this.updateData();
      }
      
      public function updateData() : void
      {
         var _loc1_:Boolean = false;
         var _loc3_:int = 0;
         var _loc2_:int = int(this._skillSlotConnectorsList.length);
         var _loc4_:String = !!this.mutagenSlot.data ? String(this.mutagenSlot.data.color) : this.COLOR_NONE;
         _loc1_ = false;
         if(this._skillSlotRefs.length != this._skillSlotConnectorsList.length)
         {
            throw new Error("GFX [ERROR] " + this + " has invalid number of skills to connectors: " + this._skillSlotRefs.length + ", " + this._skillSlotConnectorsList.length);
         }
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(_loc4_ != this.COLOR_NONE && this._skillSlotRefs[_loc3_].data != null && _loc4_ == this._skillSlotRefs[_loc3_].data.color)
            {
               this._skillSlotConnectorsList[_loc3_].currentColor = _loc4_;
               _loc1_ = true;
            }
            else
            {
               this._skillSlotConnectorsList[_loc3_].currentColor = this.COLOR_NONE;
            }
            _loc3_++;
         }
         if(_loc1_)
         {
            this.connector.currentColor = _loc4_;
         }
         else
         {
            this.connector.currentColor = this.COLOR_NONE;
         }
      }
      
      protected function getGroupColor(param1:Array) : String
      {
         var _loc4_:int = 0;
         var _loc2_:String = this.COLOR_NONE;
         var _loc3_:int = int(param1.length);
         while(_loc4_ < _loc3_)
         {
            if(param1[_loc4_] != _loc2_ && param1[_loc4_] != this.COLOR_NONE)
            {
               if(_loc2_ != this.COLOR_NONE)
               {
                  return this.COLOR_NONE;
               }
               _loc2_ = String(param1[_loc4_]);
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      protected function getGroupBonus(param1:String) : String
      {
         return "";
      }
   }
}
