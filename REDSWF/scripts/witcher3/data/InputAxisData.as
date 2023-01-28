package witcher3.data
{
   import witcher3.utils.InputUtils;
   
   public class InputAxisData
   {
       
      
      public var xvalue:Number;
      
      public var yvalue:Number;
      
      public function InputAxisData(param1:Number, param2:Number)
      {
         super();
         this.xvalue = param1;
         this.yvalue = param2;
      }
      
      public function toString() : String
      {
         var _loc1_:Number = InputUtils.getMagnitude(this.xvalue,this.yvalue);
         var _loc2_:Number = InputUtils.getAngleRadians(this.xvalue,this.yvalue);
         var _loc3_:Number = InputUtils.radiansToDegrees(_loc2_);
         return "[W3 InputAxisData: xvalue = " + this.xvalue + ", yvalue = " + this.yvalue + "( magnitude = " + _loc1_ + ", angleRad = " + _loc2_ + ", angleDeg = " + _loc3_ + " )]";
      }
   }
}
