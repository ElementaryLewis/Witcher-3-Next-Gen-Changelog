package red.game.witcher3.data
{
   public class SysMessageData
   {
       
      
      public var id:int;
      
      public var messageText:String;
      
      public var titleText:String;
      
      public var priority:uint;
      
      public var type:uint;
      
      public var userData:Object;
      
      public var buttonList:Array;
      
      public function SysMessageData()
      {
         super();
      }
      
      public function toString() : String
      {
         return "<SysMessageData> [id: " + this.id + "; priority: " + this.priority + "; messageText: " + this.messageText + " ]";
      }
   }
}
