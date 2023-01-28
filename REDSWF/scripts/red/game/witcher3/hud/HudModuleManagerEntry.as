package red.game.witcher3.hud
{
   import red.game.witcher3.hud.modules.HudModuleBase;
   
   public class HudModuleManagerEntry
   {
       
      
      public var m_name:String;
      
      public var m_filename:String;
      
      public var m_depthIndex:int;
      
      public var m_movieClip:HudModuleBase;
      
      public var m_state:String;
      
      public function HudModuleManagerEntry(param1:String, param2:String, param3:int)
      {
         super();
         this.m_name = param1;
         this.m_filename = param2;
         this.m_depthIndex = param3;
      }
      
      public function toString() : String
      {
         return "Name: " + this.m_name + ", Filename: " + this.m_filename + ", DepthIndex: " + this.m_depthIndex;
      }
   }
}
