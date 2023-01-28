package red.game.witcher3.utils
{
   import flash.geom.Point;
   
   public class Math2
   {
      
      public static var numeralArray:Array = new Array();
       
      
      public function Math2()
      {
         super();
      }
      
      public static function degreesToRadians(param1:Number) : Number
      {
         return Math.PI * 2 * (param1 / 360);
      }
      
      public static function radiansToDegrees(param1:Number) : Number
      {
         return param1 * 180 / Math.PI;
      }
      
      public static function between(param1:Number, param2:Number, param3:Number) : Number
      {
         param1 = param1 > param3 ? param3 : param1;
         return param1 < param2 ? param2 : param1;
      }
      
      public static function round(param1:Number, param2:uint) : Number
      {
         var _loc3_:Number = Math.pow(10,param2);
         var _loc4_:Number;
         return (_loc4_ = Math.round(param1 * _loc3_)) / _loc3_;
      }
      
      public static function getValueFromPercent(param1:Number, param2:Number, param3:Number) : Number
      {
         return param3 * (param2 - param1) / 100 + param1;
      }
      
      public static function getPercentFromValue(param1:Number, param2:Number, param3:Number) : Number
      {
         if(param2 == param1)
         {
            return 100;
         }
         return (param3 - param1) * 100 / (param2 - param1);
      }
      
      public static function getPolymonialSolution(param1:Number, param2:Number, param3:Number) : Array
      {
         var _loc4_:Number = param2 * param2 - 4 * param1 * param3;
         var _loc5_:Number = (-param2 + Math.pow(_loc4_,0.5)) / (2 * param1);
         var _loc6_:Number = (-param2 - Math.pow(_loc4_,0.5)) / (2 * param1);
         return new Array(_loc5_,_loc6_);
      }
      
      public static function getXInCircle(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         var _loc5_:Number = 1;
         var _loc6_:Number = -2 * param3;
         var _loc7_:Number = (param1 - param4) * (param1 - param4) - param2 * param2 + param3 * param3;
         var _loc8_:Array;
         return (_loc8_ = getPolymonialSolution(_loc5_,_loc6_,_loc7_))[0];
      }
      
      public static function getXFromCircleByAngle(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = param1;
         var _loc4_:Number = 1 + Math.tan(Math2.degreesToRadians(param2));
         var _loc5_:Number = _loc3_ / _loc4_;
         return Math.pow(Math.abs(_loc5_),0.5);
      }
      
      public static function toCommaNumber(param1:Number) : String
      {
         var _loc2_:String = param1.toString();
         var _loc3_:Array = _loc2_.split(".");
         if(_loc3_.length > 0)
         {
            _loc2_ = _loc3_[0] + "," + _loc3_[1];
         }
         return _loc2_;
      }
      
      public static function toDotNumber(param1:String) : Number
      {
         var _loc2_:Number = NaN;
         var _loc3_:Array = param1.split(",");
         if(_loc3_.length > 0)
         {
            _loc2_ = Number(_loc3_[0] + "." + _loc3_[1]);
         }
         else
         {
            _loc2_ = Number(param1);
         }
         return _loc2_;
      }
      
      public static function getSegmentLength(param1:Point, param2:Point) : Number
      {
         return Math.sqrt(Math.pow(param2.x - param1.x,2) + Math.pow(param2.y - param1.y,2));
      }
      
      public static function getSquaredSegmentLength(param1:Point, param2:Point) : Number
      {
         return Math.pow(param2.x - param1.x,2) + Math.pow(param2.y - param1.y,2);
      }
      
      public static function getAngleBetweenPoints(param1:Point, param2:Point) : Number
      {
         var _loc3_:Number = param1.x - param2.x;
         var _loc4_:Number = param1.y - param2.y;
         return radiansToDegrees(Math.atan2(-_loc4_,-_loc3_)) + 90;
      }
      
      public static function setNumeralName(param1:String, param2:String, param3:String, param4:String, param5:String = "default") : void
      {
         if(!numeralArray[param5])
         {
            numeralArray[param5] = new Array();
         }
         var _loc6_:Array;
         (_loc6_ = numeralArray[param5])[0] = param1;
         _loc6_[1] = param2;
         _loc6_[2] = param3;
         _loc6_[3] = param4;
      }
      
      public static function getNumeralName(param1:int, param2:String = "default") : String
      {
         if(numeralArray[param2])
         {
            switch(param1)
            {
               case 0:
                  return numeralArray[param2][0];
               case 1:
                  return numeralArray[param2][1];
               case 2:
               case 3:
               case 4:
                  return numeralArray[param2][2];
               default:
                  return numeralArray[param2][3];
            }
         }
         else
         {
            return "";
         }
      }
      
      public static function randomInt(param1:int, param2:int) : int
      {
         return int(Math.floor(Math.random() * (param2 - param1 + 1)) + param1);
      }
      
      public static function sinDegrees(param1:Number) : Number
      {
         return Math.sin(degreesToRadians(param1));
      }
      
      public static function cosDegrees(param1:Number) : Number
      {
         return Math.cos(degreesToRadians(param1));
      }
      
      public static function addLeadingZeros(param1:Number, param2:uint = 2) : String
      {
         param1 = Math.floor(param1);
         var _loc3_:* = "";
         var _loc4_:int = int(param2 - 1);
         while(_loc4_ >= 0)
         {
            if(param1 >= Math.pow(10,_loc4_))
            {
               _loc3_ += param1.toString();
               break;
            }
            _loc3_ += "0";
            _loc4_--;
         }
         return _loc3_;
      }
      
      public static function separateThousands(param1:int, param2:String = " ") : String
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:String = "";
         var _loc4_:String = param1.toString();
         if(param1 < 1000)
         {
            return _loc4_;
         }
         _loc5_ = 0;
         _loc6_ = _loc4_.length - 1;
         while(_loc6_ >= 0)
         {
            _loc3_ = _loc4_.substr(_loc6_,1) + _loc3_;
            _loc5_++;
            if(_loc5_ % 3 == 0)
            {
               _loc3_ = " " + _loc3_;
            }
            _loc6_--;
         }
         return _loc3_;
      }
   }
}
