package red.game.witcher3.menus.testmap
{
   import flash.geom.Vector3D;
   import flash.text.TextField;
   import red.core.CoreMenu;
   import red.core.constants.KeyCode;
   import red.core.data.InputAxisData;
   import red.core.events.GameEvent;
   import red.game.witcher3.data.StaticMapPinData;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class TestMenu extends CoreMenu
   {
       
      
      internal var lookAtPos:Vector3D;
      
      internal var camYaw:Number = 0;
      
      internal var camPitch:Number = 0;
      
      internal var camDistance:Number = 2;
      
      internal var sunYaw:Number = 0;
      
      internal var sunPitch:Number = 0;
      
      internal var entityTemplate:String;
      
      internal var environmentDefinition:String;
      
      public var tfCamera:TextField;
      
      public function TestMenu()
      {
         this.lookAtPos = new Vector3D();
         super();
         this.lookAtPos.x = 0;
         this.lookAtPos.y = 0;
         this.lookAtPos.z = 1;
         this.camYaw = 180;
         this.camPitch = 0;
         this.camDistance = 1;
         this.sunYaw = 0;
         this.sunPitch = 0;
      }
      
      override protected function get menuName() : String
      {
         return "TestMenu";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"test.entityTemplate",[this.handleSetEntityTemplate]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"test.environmentDefinition",[this.handleSetEnvironmentDefinition]));
         registerRenderTarget("test_nopack",1024,1024);
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         this.SendCameraUpdate();
         this.SendSunUpdate();
         this.UpdateTextField();
      }
      
      protected function handleSetEntityTemplate(param1:String) : *
      {
         trace("Minimap handleSetEntityTemplate [" + param1 + "]");
         this.entityTemplate = param1;
      }
      
      protected function handleSetEnvironmentDefinition(param1:String) : *
      {
         trace("Minimap handleSetEnvironmentDefinition [" + param1 + "]");
         this.environmentDefinition = param1;
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:InputAxisData = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = 0.1;
         var _loc5_:Number = 4;
         if(param1.handled)
         {
            return;
         }
         var _loc6_:InputDetails;
         var _loc7_:* = (_loc6_ = param1.details).value == InputValue.KEY_DOWN;
         var _loc8_:Boolean = _loc6_.value == InputValue.KEY_DOWN || _loc6_.value == InputValue.KEY_HOLD;
         switch(_loc6_.code)
         {
            case KeyCode.PAD_A_CROSS:
               if(_loc7_)
               {
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnNextEntityTemplate"));
               }
               break;
            case KeyCode.PAD_B_CIRCLE:
               if(_loc7_)
               {
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnNextAppearance"));
               }
               break;
            case KeyCode.PAD_X_SQUARE:
               if(_loc7_)
               {
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnNextEnvironmentDefinition"));
               }
               break;
            case KeyCode.PAD_Y_TRIANGLE:
               break;
            case KeyCode.PAD_LEFT_STICK_AXIS:
               _loc2_ = InputAxisData(_loc6_.value);
               this.camYaw += _loc2_.xvalue * _loc5_;
               this.camPitch += -_loc2_.yvalue * _loc5_;
               this.camYaw = this.NormalizeAngle(this.camYaw);
               this.camPitch = this.NormalizeAngle(this.camPitch);
               this.SendCameraUpdate();
               break;
            case KeyCode.PAD_RIGHT_STICK_AXIS:
               _loc2_ = InputAxisData(_loc6_.value);
               this.camDistance += -_loc2_.yvalue * _loc4_;
               this.camDistance = this.ClampDistance(this.camDistance);
               this.SendCameraUpdate();
               break;
            case KeyCode.PAD_LEFT_SHOULDER:
               if(_loc8_)
               {
                  this.lookAtPos.z -= 0.1;
                  this.SendCameraUpdate();
               }
               break;
            case KeyCode.PAD_RIGHT_SHOULDER:
               if(_loc8_)
               {
                  this.lookAtPos.z += 0.1;
                  this.SendCameraUpdate();
               }
               break;
            case KeyCode.PAD_DIGIT_LEFT:
               if(_loc8_)
               {
                  this.sunYaw = this.NormalizeAngle(this.sunYaw - 10);
                  this.SendSunUpdate();
               }
               break;
            case KeyCode.PAD_DIGIT_RIGHT:
               if(_loc8_)
               {
                  this.sunYaw = this.NormalizeAngle(this.sunYaw + 10);
                  this.SendSunUpdate();
               }
               break;
            case KeyCode.PAD_DIGIT_UP:
               if(_loc8_)
               {
                  this.sunPitch = this.NormalizeAngle(this.sunPitch - 10);
                  this.SendSunUpdate();
               }
               break;
            case KeyCode.PAD_DIGIT_DOWN:
               if(_loc8_)
               {
                  this.sunPitch = this.NormalizeAngle(this.sunPitch + 10);
                  this.SendSunUpdate();
               }
               break;
            case KeyCode.PAD_LEFT_TRIGGER:
               if(_loc8_)
               {
               }
               break;
            case KeyCode.PAD_RIGHT_TRIGGER:
               if(_loc8_)
               {
               }
               break;
            case KeyCode.PAD_LEFT_STICK_DOWN:
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnCloseMenuTemp"));
               return;
         }
         this.UpdateTextField();
      }
      
      protected function NormalizeAngle(param1:Number) : Number
      {
         while(param1 < 0)
         {
            param1 += 360;
         }
         while(param1 >= 360)
         {
            param1 -= 360;
         }
         return param1;
      }
      
      protected function ClampDistance(param1:Number) : Number
      {
         if(param1 < 0.2)
         {
            param1 = 0.2;
         }
         else if(param1 > 10)
         {
            param1 = 10;
         }
         return param1;
      }
      
      protected function deg2rad(param1:Number) : Number
      {
         return param1 * Math.PI / 180;
      }
      
      protected function rad2deg(param1:Number) : Number
      {
         return param1 * 180 / Math.PI;
      }
      
      protected function SendCameraUpdate() : *
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnCameraUpdate",[this.lookAtPos.x,this.lookAtPos.y,this.lookAtPos.z,this.camYaw,this.camPitch,this.camDistance]));
      }
      
      protected function SendSunUpdate() : *
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnSunUpdate",[this.sunYaw,this.sunPitch]));
      }
      
      protected function UpdateTextField() : *
      {
         if(this.tfCamera)
         {
            this.tfCamera.text = "LookAt    " + this.lookAtPos.x.toFixed(2) + "  " + this.lookAtPos.y.toFixed(2) + "  " + this.lookAtPos.z.toFixed(2) + "\n" + "CamYaw    " + this.camYaw.toFixed(2) + "\n" + "CamPitch  " + this.camPitch.toFixed(2) + "\n" + "CamDist   " + this.camDistance.toFixed(2) + "\n" + "SunYaw    " + this.sunYaw.toFixed(2) + "\n" + "SunPitch  " + this.sunPitch.toFixed(2) + "\n" + "Template  " + this.entityTemplate + "\n" + "Enviro    " + this.environmentDefinition + "\n";
            this.entityTemplate;
            this.environmentDefinition;
         }
      }
      
      protected function handleWhatever2(param1:String) : *
      {
         trace("Minimap handleWhatever2 " + param1);
      }
      
      private function handleArray(param1:Object, param2:int) : void
      {
         var _loc3_:StaticMapPinData = null;
         trace("Minimap handleArray " + (param1 as Array).length);
         var _loc4_:Array = param1 as Array;
         if(param2 <= -1)
         {
            if(param1)
            {
               for each(_loc3_ in _loc4_)
               {
                  param2++;
               }
            }
         }
      }
   }
}
