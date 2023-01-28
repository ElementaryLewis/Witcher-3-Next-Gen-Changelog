package red.game.witcher3.data
{
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   
   public class TooltipData
   {
       
      
      public var viewerClass:String;
      
      public var dataSource:String;
      
      public var anchor:DisplayObject;
      
      public var anchorRect:Rectangle;
      
      public var alignment:String = "Right";
      
      public var isMouseTooltip:Boolean;
      
      public var directData:Boolean;
      
      public var defaultAnchorName:String;
      
      public var description:String;
      
      public var label:String;
      
      public var isComparisonMode:Boolean;
      
      public function TooltipData(param1:String = "", param2:String = "")
      {
         super();
         this.viewerClass = param1;
         this.dataSource = param2;
      }
   }
}
