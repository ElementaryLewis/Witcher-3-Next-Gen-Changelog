package red.game.witcher3.hud
{
   import flash.utils.Dictionary;
   
   public class HudModuleManager
   {
       
      
      public var entries:Vector.<HudModuleManagerEntry>;
      
      private var entriesDic:Dictionary;
      
      public function HudModuleManager()
      {
         super();
         this.entries = new Vector.<HudModuleManagerEntry>();
         this.entriesDic = new Dictionary();
      }
      
      public function AddEntry(param1:String, param2:String, param3:int) : *
      {
         var _loc4_:HudModuleManagerEntry = new HudModuleManagerEntry(param1,param2,param3);
         this.entries.push(_loc4_);
         this.entriesDic[param1] = _loc4_;
      }
      
      public function FindModuleByNameDict(param1:String) : HudModuleManagerEntry
      {
         return this.entriesDic[param1];
      }
      
      public function FindModuleByName(param1:String) : HudModuleManagerEntry
      {
         var _loc2_:int = 0;
         var _loc3_:int = int(this.entries.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.entries[_loc2_].m_name == param1)
            {
               return this.entries[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function FindModuleByFilename(param1:String) : HudModuleManagerEntry
      {
         var _loc2_:int = 0;
         var _loc3_:int = int(this.entries.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.entries[_loc2_].m_filename == param1)
            {
               return this.entries[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function SortEntries() : *
      {
         this.PrintInfo();
         this.entries.sort(this.sortModulesByDepth);
         this.PrintInfo();
      }
      
      protected function sortModulesByDepth(param1:*, param2:*) : int
      {
         if(param1.m_depthIndex < param2.m_depthIndex)
         {
            return -1;
         }
         if(param1.m_depthIndex > param2.m_depthIndex)
         {
            return 1;
         }
         return 0;
      }
      
      public function ShowModules(param1:Boolean) : *
      {
      }
      
      public function PrintInfo() : *
      {
      }
   }
}
