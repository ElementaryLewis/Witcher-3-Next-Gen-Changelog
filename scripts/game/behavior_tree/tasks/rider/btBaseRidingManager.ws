/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/


abstract class CBTTaskRidingManagerVehicleMount extends IBehTreeTask
{
	protected var mountType : name;
	var riderData      		: CAIStorageRiderData;
	var attachSlot 			: name;
	
	function OnActivate() : EBTNodeStatus
	{
        var vehicleComponent: CVehicleComponent;
		vehicleComponent = GetVehicleComponent();
		
		if ( !vehicleComponent || vehicleComponent.IsMountingPossible() == false )
        {
			return BTNS_Failed;
        }		
        return BTNS_Active;
	}
	
	function GetVehicleComponent() : CVehicleComponent
	{
		return NULL;
	}
	
	latent function OnMountStarted( riderData : CAIStorageRiderData, behGraphName: name, vehicleComponent : CVehicleComponent ) 
	{
		var riderActor			: CActor = GetActor();
		var behaviorsToActivate : array< name >;
		var preloadResult		: bool = true;	

		
		vehicleComponent.OnMountStarted( riderActor, riderData.sharedParams.vehicleSlot );

		
		riderActor.SetUsedVehicle( (CGameplayEntity)vehicleComponent.GetEntity() );	
		behaviorsToActivate.PushBack( behGraphName );
		
		preloadResult = riderActor.PreloadBehaviorsToActivate( behaviorsToActivate );
		LogAssert( preloadResult, "CBTTaskRidingManagerVehicleMount::OnMountStarted - preloading behaviors failed" );	
		
		riderData.sharedParams.mountStatus = VMS_mountInProgress;
		
		
	}

	latent function OnMountFinishedSuccessfully( riderData : CAIStorageRiderData, behGraphName: name, vehicleComponent : CVehicleComponent )
	{	
		var riderActor			: CActor = GetActor();
		var behaviorsToActivate : array< name >;
		var graphResult 		: bool;
		var movementAdjustor	: CMovementAdjustor;
		
		
		riderData.sharedParams.mountStatus = VMS_mounted;
		
		riderActor.RemoveTimer( 'UpdateTraverser' );

		
		behaviorsToActivate.PushBack( behGraphName );
		graphResult = riderActor.ActivateBehaviors( behaviorsToActivate );
		
		riderActor.SetBehaviorVariable('MountType',GetMountTypeVariable());
		
		if ( riderData.ridingManagerInstantMount )
		{
			riderActor.RaiseForceEvent( 'InstantMount' );
		}
		
		
		LogAssert( graphResult, "CBTTaskRidingManagerHorseMount::OnMountFinishedSuccessfully - behaviors activation failed" );
		
		if ( riderData.sharedParams.vehicleSlot == EVS_passenger_slot )
		{
			if ( riderActor.SetBehaviorVariable('isPassenger', 1.0f) == false )
			{
				LogAssert( graphResult, "CBTTaskRidingManagerHorseMount::OnMountFinishedSuccessfully - behaviors variable init failed" );
			}
		}
		else
		{
			if ( riderActor.SetBehaviorVariable('isPassenger', 0.0f) == false )
			{
				LogAssert( graphResult, "CBTTaskRidingManagerHorseMount::OnMountFinishedSuccessfully - behaviors variable init failed" );
			}
		}
		
		
		riderActor.EnableCollisions( false );
		
		
		riderActor.CreateAttachment( vehicleComponent.GetEntity(), attachSlot );		
		
		movementAdjustor = riderActor.GetMovingAgentComponent().GetMovementAdjustor();
		if ( movementAdjustor )
		{
			movementAdjustor.CancelAll();
		}
		
		
		vehicleComponent.OnMountFinished( riderActor );
	}
	
	latent function OnMountFailed( riderData : CAIStorageRiderData, vehicleComponent : CVehicleComponent )
	{
		var riderActor			: CActor 	= GetActor();
		riderData.ridingManagerMountError 	= true;
		vehicleComponent.OnDismountStarted( riderActor );
		vehicleComponent.OnDismountFinished( riderActor, riderData.sharedParams.vehicleSlot );
		
		riderData.sharedParams.mountStatus 	= VMS_dismounted;
		
		riderActor.SetUsedVehicle( NULL );
	}	
	
	latent function MountActor( riderData : CAIStorageRiderData, behGraphName: name, vehicleComponent : CVehicleComponent )
	{
		var riderActor			: CActor = GetActor();
		var exploration 		: SExplorationQueryToken;
		var vehicleEntity		: CEntity = vehicleComponent.GetEntity();
		var queryContext		: SExplorationQueryContext;
		var success 			: bool = true;		
		
		
		if ( riderData.ridingManagerInstantMount == false )
		{
			queryContext.inputDirectionInWorldSpace = VecNormalize( vehicleEntity.GetWorldPosition() - riderActor.GetWorldPosition() );
			
			exploration = theGame.QueryExplorationFromObjectSync( riderActor, vehicleEntity );
			success 	= exploration.valid;
		}
		
		if ( success )
		{
			
			OnMountStarted( riderData, behGraphName, vehicleComponent );

			
			if ( riderData.ridingManagerInstantMount == false )
			{
				riderActor.AddTimer( 'UpdateTraverser', 0.f, true, false, TICK_PrePhysics );
				success = riderActor.ActionExploration( exploration, NULL, riderData.sharedParams.GetHorse() );
			}
		}
		
		if ( success )
		{		
			OnMountFinishedSuccessfully( riderData, behGraphName, vehicleComponent );
		}
		else
		{
			OnMountFailed( riderData, vehicleComponent );
		}
	}
	
	function GetMountTypeVariable() : float
	{
		switch ( mountType )
		{
			case 'horse_mount_B_01' 	: return 1.f;
			case 'horse_mount_L' 		: return 2.f;
			case 'horse_mount_LB' 		: return 3.f;
			case 'horse_mount_LF' 		: return 4.f;
			case 'horse_mount_R_01' 	: return 5.f;
			case 'horse_mount_RB_01' 	: return 6.f;
			case 'horse_mount_RF_01' 	: return 7.f;
			default 					: return 0.f;
		}
		return 0.f;
	}
	
    function Initialize()
    {
		riderData = (CAIStorageRiderData)RequestStorageItem( 'RiderData', 'CAIStorageRiderData' );
    }
}


abstract class CBTTaskRidingManagerVehicleMountDef extends IBehTreeTaskDefinition
{

}







class CBTTaskRidingManagerVehicleDismount extends IBehTreeTask
{
    var riderData     : CAIStorageRiderData;

    function OnDismountStarted( riderData : CAIStorageRiderData, vehicleComponent : CVehicleComponent )
    {
		var riderActor			: CActor 	= GetActor();
		var vehicleActor 		: CActor;
		
		if ( vehicleComponent )
		{
			vehicleComponent.OnDismountStarted( riderActor );
		}

		
		
		
		riderActor.ActionCancelAll(); 
		riderActor.RemoveTimer( 'UpdateTraverser' ); 
		riderData.sharedParams.mountStatus = VMS_dismountInProgress;
    }

    function OnDismountFinishedA( riderData : CAIStorageRiderData, vehicleComponent : CVehicleComponent )
    {
		var riderActor			: CActor 	= GetActor();
		
		riderData.sharedParams.mountStatus = VMS_dismounted;
		
		riderActor.EnableCharacterCollisions(true);
		riderActor.BreakAttachment();
		riderActor.SetUsedVehicle(NULL);
		
		
		if ( vehicleComponent )
		{
			
			vehicleComponent.OnDismountFinished( riderActor, riderData.sharedParams.vehicleSlot );
		}
    }

    

    
    
    latent function OnDismountFinishedB_Latent( riderData : CAIStorageRiderData, vehicleComponent : CVehicleComponent  )
    {	
    }

    
    function FindDismountDirection( riderData : CAIStorageRiderData, vehicleComponent : CVehicleComponent, out dismountDirection : float )
	{
		var riderActor						: CActor 	= GetActor();
		var vehicleEntity					: CEntity 	= vehicleComponent.GetEntity();
		var horseComponent					: W3HorseComponent;
		var LeftForwardDismountPosition 	: Vector;
		var LeftForwardDismountPositionTrot : Vector;
		var RightForwardDismountPosition 	: Vector;
		var LeftBackwardDismountPosition 	: Vector;
		var RightBackwardDismountPosition 	: Vector;
		var BackDismountPosition 			: Vector;
		var actorMovingAgentComponent 		: CMovingPhysicalAgentComponent;
		var vehiclePosition					: Vector 	= vehicleEntity.GetWorldPosition();
		var vehicleForward					: Vector 	= vehicleEntity.GetWorldForward();
		var vehicleRight					: Vector 	= vehicleEntity.GetWorldRight();
		var dismountCheckLength				: float		= 1.0;
		var possibleDirections				: array<float>;
		
		
		var lookatAngle : float;
		
		dismountDirection = 1.0;	
		actorMovingAgentComponent =( CMovingPhysicalAgentComponent ) riderActor.GetMovingAgentComponent();
		
		
		LeftForwardDismountPosition 	= vehiclePosition - vehicleRight * dismountCheckLength;
		LeftForwardDismountPositionTrot = vehiclePosition + (2 * vehicleForward - vehicleRight) * dismountCheckLength;
		RightForwardDismountPosition 	= vehiclePosition + vehicleRight * dismountCheckLength;
		LeftBackwardDismountPosition 	= vehiclePosition + (-vehicleForward - vehicleRight) * dismountCheckLength;
		RightBackwardDismountPosition 	= vehiclePosition + (-vehicleForward + vehicleRight) * dismountCheckLength;
		BackDismountPosition 			= vehiclePosition + (-vehicleForward ) * dismountCheckLength;
		
		
		lookatAngle = AngleDistance(thePlayer.GetHeading(), theCamera.GetCameraHeading());
		
		horseComponent = (W3HorseComponent)vehicleComponent;
		
		if ( horseComponent && riderActor == thePlayer  )
		{
			if ( horseComponent.GetCurrentPitch() >= 30.0 )
			{
				if( IsPositionValid( vehicleComponent, BackDismountPosition ) )
				{
					thePlayer.SetBehaviorVariable( 'dismountType',0.f );
					dismountDirection = 4.0;
					return;
				}
				else
				{
					riderData.ridingManagerDismountType = DT_instant;
					return;
				}
			}
			else if ( thePlayer.GetBehaviorVariable('dismountType') == 1.f )
			{
				if( IsPositionValid( vehicleComponent, LeftForwardDismountPositionTrot ) )
				{
					return;
				}
				else if( IsPositionValid( vehicleComponent, BackDismountPosition ) )
				{
					thePlayer.SetBehaviorVariable( 'dismountType',0.f );
					dismountDirection = 4.0;
					return;
				}
				else
				{
					thePlayer.SetBehaviorVariable('dismountType',0.f);
				}
			}
			
			
			if( IsPositionValid( vehicleComponent, LeftBackwardDismountPosition ) )
			{
				possibleDirections.PushBack( 2.0 );
			}
			if( IsPositionValid( vehicleComponent, RightBackwardDismountPosition ) )
			{
				possibleDirections.PushBack( 3.0 );
			}
			if( IsPositionValid( vehicleComponent, LeftForwardDismountPosition ) )
			{
				possibleDirections.PushBack( 0.0 );
			}
			if( IsPositionValid( vehicleComponent, RightForwardDismountPosition ) )
			{
				possibleDirections.PushBack( 1.0 );
			}
			
			if( !possibleDirections.Size() )
			{
				if( IsPositionValid( vehicleComponent, BackDismountPosition ) )
				{
					dismountDirection = 4.0;
					return;
				}
				else
				{
					riderData.ridingManagerDismountType = DT_instant;
					return;
				}
			}
			
			if( lookatAngle < -130.0f && possibleDirections.Contains( 2.0 ) )
			{
				dismountDirection = 2.0;
			}
			else if(lookatAngle > 130.0f  && possibleDirections.Contains( 3.0 ) )
			{
				dismountDirection = 3.0;
			}
			else if( lookatAngle > -130.0f && lookatAngle < 0.0f && possibleDirections.Contains( 0.0 ) )
			{
				dismountDirection = 0.0;
			}
			else if( lookatAngle < 130.0f && lookatAngle > 0.0f && possibleDirections.Contains( 1.0 ) )
			{
				dismountDirection = 1.0;
			}
			else
			{
				dismountDirection = possibleDirections[ RandRange( possibleDirections.Size() ) ];
			}			
			
		}
		else	
		{
			
			if( IsPositionValid( vehicleComponent, LeftForwardDismountPosition ) )
			{
				possibleDirections.PushBack( 0.0 );
			}
			if( IsPositionValid( vehicleComponent, RightForwardDismountPosition ) )
			{
				possibleDirections.PushBack( 1.0 );
			}
			if( possibleDirections.Size() <= 0 )
			{
				
				if( IsPositionValid( vehicleComponent, LeftBackwardDismountPosition ) )
				{
					possibleDirections.PushBack( 2.0 );
				}
				if( IsPositionValid( vehicleComponent, RightBackwardDismountPosition ) )
				{
					possibleDirections.PushBack( 3.0 );
				}
				
				if( !possibleDirections.Size() )
				{
					if( IsPositionValid( vehicleComponent, BackDismountPosition ) )
					{
						dismountDirection = 4.0;
						return;
					}
					else
					{
						riderData.ridingManagerDismountType = DT_instant;
						return;
					}
				}
				
				dismountDirection = possibleDirections[ RandRange( possibleDirections.Size() ) ];
				
			}
			else
			{
				dismountDirection = possibleDirections[ RandRange( possibleDirections.Size() ) ];
			}
		} 
	}
	
	function IsPositionValid( vehicleComponent : CVehicleComponent, _position : Vector ) : bool
	{
		var riderActor						: CActor 	= GetActor();
		var actorMovingAgentComponent 		: CMovingPhysicalAgentComponent;
		var vehicleEntity					: CEntity 	= vehicleComponent.GetEntity();
		var vehiclePosition					: Vector 	= vehicleEntity.GetWorldPosition();
		var pointA, pointB, outPosition, outNormal : Vector;
		var collisionGroupsNames 			: array<name>;
		
		
		actorMovingAgentComponent = ( CMovingPhysicalAgentComponent ) riderActor.GetMovingAgentComponent();
		
		collisionGroupsNames.PushBack('Static');
		collisionGroupsNames.PushBack('Terrain');
		collisionGroupsNames.PushBack('Destructible');
		collisionGroupsNames.PushBack('Foliage');
		
		pointA = vehiclePosition;
		pointB = _position;
		pointA.Z += 1.0;
		pointB.Z += 1.0;

		if ( theGame.GetWorld().SweepTest( pointA, pointB, 0.4, outPosition, outNormal, collisionGroupsNames ) )
		{
			
			return false;
		}

		
		return true;
	}
	
    latent function DismountActor_Latent( riderData : CAIStorageRiderData, vehicleComponent : CVehicleComponent, dismountDirection : float )
	{
		var riderActor				: CActor 	= GetActor();
		var riderActorTarget		: CActor;
		var angleDistance 			: float;
		var vehicleEntity			: CEntity 	= vehicleComponent.GetEntity();	
		var params					: SCustomEffectParams;
		var numSecWait				: float;
		var r4player				: CR4Player;

		if( (W3HorseComponent)vehicleComponent )
		{
			numSecWait = 2.0f;
		}
		else
		{
			
			numSecWait = 0.5f;
		}
		
		switch ( riderData.ridingManagerDismountType )
		{
			case DT_normal:
			{
				riderActor.SetBehaviorVariable('shakeOffRider', 0.f );
				riderActor.SetBehaviorVariable('dismountDirection', dismountDirection );
				
				r4player = (CR4Player)riderActor;
								
				if ( riderActor.RaiseForceEventWithoutTestCheck( 'dismount' ) )
				{
					
					riderActor.WaitForBehaviorNodeDeactivation( 'dismountEnd', numSecWait );
				}
				else
				{
					if ( riderActor.RaiseForceEvent( 'dismount' ) )
					{
						
						riderActor.WaitForBehaviorNodeDeactivation( 'dismountEnd', numSecWait );
					}
				}
				
				break;
			}
			
			case DT_shakeOff:
			{
				
				riderActor.SetBehaviorVariable('shakeOffRider', 1.f );
				vehicleEntity.SetBehaviorVariable('shakeOffRider', 1.f );				
				
				
				riderActor.SetBehaviorVariable('dismountDirection', dismountDirection );
				vehicleEntity.SetBehaviorVariable('dismountDirection', dismountDirection );				
				
				
				params.effectType = EET_Knockdown;
				params.creator = (CGameplayEntity)vehicleComponent.GetEntity();
				params.sourceName = "shakeOff_dismount";
				params.duration = 5;
				riderActor.AddEffectCustom(params);
				
				PlaySyncAnimWithRider( vehicleEntity, 'dismount', 'dismountEnd');
				
				break;
			}
			case DT_ragdoll:
			{
				riderActorTarget = riderActor.GetTarget();
				if ( riderActorTarget )
				{
					angleDistance = NodeToNodeAngleDistance(riderActorTarget,riderActor);
					if ( AbsF(angleDistance) < 50 )
						dismountDirection = 0.f;
					else if ( angleDistance <= -50 )
						dismountDirection = 1.f;
					else
						dismountDirection = 2.f;
				}
				else
				{
					dismountDirection = 0.f;
				}
				
				riderActor.SetBehaviorVariable('dismountDirection', dismountDirection );
				riderActor.RaiseForceEvent( 'dismountRagdoll' );
				riderActor.WaitForBehaviorNodeDeactivation('dismountRagdollEnd',0.5);
				riderActor.BreakAttachment();
				break;
			}
			case DT_instant:
			{
				break;
			}
		}
	}

	latent function DismountActor( riderData : CAIStorageRiderData, vehicleComponent : CVehicleComponent )
	{
		var dismountDirection : float = 1.0f;
		OnDismountStarted( riderData, vehicleComponent );
		
		FindDismountDirection( riderData, vehicleComponent, dismountDirection );
		DismountActor_Latent( riderData, vehicleComponent, dismountDirection );
		OnDismountFinishedA( riderData, vehicleComponent );
		OnDismountFinishedB_Latent( riderData, vehicleComponent );
	}

	function DismountActor_NonLatent( riderData : CAIStorageRiderData, vehicleComponent : CVehicleComponent )
	{
		OnDismountStarted( riderData, vehicleComponent );
		OnDismountFinishedA( riderData, vehicleComponent );
	}
	
	latent function PlaySyncAnimWithRider( vehicleEntity: CEntity, eventName : CName, deactivationEvent : CName )
	{
		var riderActor						: CActor 	= GetActor();
		
		vehicleEntity.RaiseForceEventWithoutTestCheck('ForceIdle');
		Sleep(0.1);
		if( riderActor != thePlayer )
		{
			vehicleEntity.RaiseForceEventWithoutTestCheck( eventName );
			riderActor.RaiseForceEventWithoutTestCheck( eventName );
			riderActor.BreakAttachment();
			Sleep(1.f);
			riderActor.RaiseEvent('SwitchToRagdoll');
		}
		else
		{	
			vehicleEntity.RaiseEventWithoutTestCheck( eventName );
			riderActor.RaiseEventWithoutTestCheck( eventName );
			riderActor.BreakAttachment();
			vehicleEntity.WaitForBehaviorNodeDeactivation(deactivationEvent, 10.0f );
		}
		
	}
    function Initialize()
    {
		riderData = (CAIStorageRiderData)RequestStorageItem( 'RiderData', 'CAIStorageRiderData' );
    }
}


abstract class CBTTaskRidingManagerVehicleDismountDef extends IBehTreeTaskDefinition
{
	default instanceClass = 'CBTTaskRidingManagerVehicleDismount';
}
