/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/




import struct SAnimationSequencePartDefinition
{
	import var animation							: name;
	import var syncType								: EAnimationManualSyncType;
	import var syncEventName						: name;
	import var shouldSlide							: bool;
	import var shouldRotate							: bool;
	import var useRefBone							: name;
	import var rotationTypeUsingRefBone				: ESyncRotationUsingRefBoneType;
	import var finalPosition						: Vector;
	import var finalHeading							: float;
	import var blendTransitionTime					: float;
	import var blendInTime							: float;
	import var blendOutTime							: float;
	import var allowBreakAtStart					: float;
	import var allowBreakAtStartBeforeEventsEnd		: name;
	import var allowBreakBeforeEnd					: float;
	import var allowBreakBeforeAtAfterEventsStart	: name;
	import var sequenceIndex						: int;
	import var disableProxyCollisions				: bool;
}

import struct SAnimationSequenceDefinition
{
	import var entity				: CEntity;
	import var manualSlotName		: name;
	import var parts				: array<SAnimationSequencePartDefinition>;
	import var freezeAtEnd			: bool;
	import var startForceEvent		: name;
	import var raiseEventOnEnd		: name;
	import var raiseForceEventOnEnd	: name;
}

import class CAnimationManualSlotSyncInstance extends CObject
{
	import final function RegisterMaster( definition : SAnimationSequenceDefinition ) : int;
	import final function RegisterSlave( definition : SAnimationSequenceDefinition ) : int;
	
	import final function StopSequence( index : int );
	import final function IsSequenceFinished( index : int ) : bool;
	import final function HasEnded() : bool;
	import final function BreakIfPossible( entity : CEntity) : bool;
	
	import final function Update( deltaTime : float );
}

statemachine class W3SyncAnimationManager
{
	default autoState = 'Idle';
	
	protected var syncInstances				: array< CAnimationManualSlotSyncInstance >;
	public var masterEntity					: CGameplayEntity;
	public var slaveEntity					: CGameplayEntity;
	public var syncActionName 				: name;
	
	public var dlcFinishersLeftSide			: array< CR4FinisherDLC >;
	public var dlcFinishersRightSide		: array< CR4FinisherDLC >;
	
	public function CreateNewSyncInstance( out index : int ) : CAnimationManualSlotSyncInstance
	{
		var newSyncInstance : CAnimationManualSlotSyncInstance;
		
		newSyncInstance = new CAnimationManualSlotSyncInstance in this;
		syncInstances.PushBack( newSyncInstance );
		
		index = syncInstances.Size() - 1;
		
		GotoState( 'Active', true );
		
		return newSyncInstance;
	}
	
	public function GetSyncInstance( index : int ) : CAnimationManualSlotSyncInstance
	{
		return syncInstances[index];
	}
	
	public function RemoveSyncInstance( instance : CAnimationManualSlotSyncInstance )
	{
		syncInstances.Remove( instance );
	}
	
	public function SetupSimpleSyncAnim( syncAction : name, master, slave : CEntity ) : bool
	{
		var masterDef, slaveDef						: SAnimationSequenceDefinition;
		var masterSequencePart, slaveSequencePart	: SAnimationSequencePartDefinition;
		var syncInstance							: CAnimationManualSlotSyncInstance;
		
		var instanceIndex							: int;
		var sequenceIndex							: int;
		
		var actorMaster, actorSlave 				: CActor;
		
		var temp 									: name; 
		var tempF 									: float;
		var rot 									: EulerAngles;
		
		var ticketS, ticketR 						: SMovementAdjustmentRequestTicket;
		var movementAdjustor						: CMovementAdjustor;
		
		var finisherAnim 							: bool;
		var pos 									: Vector;
		
		var syncAnimName							: name;
		
		var node, node1 							: CNode; 
		var rot0, rot1 								: EulerAngles;
		
		var collisionGroups 						: array<name>;
		var normal, zCorrectedPosition 				: Vector;
		
		syncInstance = CreateNewSyncInstance( instanceIndex );
		
		
		thePlayer.BlockAction(EIAB_Interactions, 'SyncManager' );
		thePlayer.BlockAction(EIAB_FastTravel, 'SyncManager' );
		
		switch( syncAction )
		{
			case 'AgonyCrawl':
			{
				
				masterSequencePart.animation		= 'man_ger_crawl_finish';
				masterSequencePart.syncType			= AMST_SyncMatchEvents;
				masterSequencePart.syncEventName	= 'SyncEvent';
				masterSequencePart.shouldSlide		= true;
				masterSequencePart.shouldRotate		= true;
				masterSequencePart.finalPosition	= 0.8 * VecNormalize( master.GetWorldPosition() - slave.GetWorldPosition() ) + ((CActor)slave).GetNearestPointInPersonalSpace( master.GetWorldPosition() );
				masterSequencePart.finalHeading		= VecHeading( slave.GetWorldPosition() - master.GetWorldPosition() );
				masterSequencePart.blendInTime		= 0.f;
				masterSequencePart.blendOutTime		= 0.f;
				masterSequencePart.sequenceIndex	= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity					= master;
				
				masterDef.manualSlotName			= 'FinisherSlot';
				masterDef.startForceEvent			= 'PerformFinisher';
				masterDef.raiseEventOnEnd			= 'DoneFinisher';
				masterDef.freezeAtEnd				= true;
				
				
				slaveSequencePart.animation			= 'man_npc_sword_1hand_wounded_crawl_killed';
				slaveSequencePart.syncType			= AMST_SyncMatchEvents;
				slaveSequencePart.syncEventName		= 'SyncEvent';
				slaveSequencePart.shouldSlide		= false;
				slaveSequencePart.blendInTime		= 0.f;
				slaveSequencePart.blendOutTime		= 0.0f;
				slaveSequencePart.sequenceIndex		= 0;
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity						= slave;
				slaveDef.manualSlotName				= 'GAMEPLAY_SLOT';
				slaveDef.freezeAtEnd				= true;
				
				break;				
			}
			case 'DeathFinisher':
			{
				
				if( ((CActor)slave).WillBeUnconscious() )
				{
					syncAnimName = GetFinisherSynAnimName( true );
					
				}
				else
				{
					syncAnimName = GetFinisherSynAnimName();
				}
				
				if ( thePlayer.forceFinisher && thePlayer.forceFinisherAnimName != '' )
				{
					thePlayer.SetCombatIdleStance( (float)(thePlayer.forcedStance) );
				}
				
				masterSequencePart.animation			= syncAnimName;
				masterSequencePart.syncType				= AMST_SyncBeginning;
				masterSequencePart.useRefBone			= 'Reference';
				masterSequencePart.rotationTypeUsingRefBone = SRT_TowardsOtherEntity;
				
				
					masterSequencePart.shouldSlide			= true;
					
				masterSequencePart.shouldRotate			= true;
				
				masterSequencePart.blendInTime			= 0.f;
				masterSequencePart.blendOutTime			= 0.f;
				masterSequencePart.sequenceIndex		= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity						= master;
				masterDef.manualSlotName				= 'FinisherSlot';
				masterDef.startForceEvent				= 'PerformFinisher';
				masterDef.raiseEventOnEnd				= 'DoneFinisher';
				masterDef.freezeAtEnd					= true;
				
				
				slave.SetKinematic( true );
				
				if( ((CActor)slave).WillBeUnconscious() )
				{
					slaveSequencePart.animation = GetSlaveAnimName( syncAnimName );
				}
				else
				{
					slaveSequencePart.animation	= syncAnimName;
				}
				
				slaveSequencePart.syncType				= AMST_SyncBeginning;
				slaveSequencePart.useRefBone			= 'Reference';	
				slaveSequencePart.rotationTypeUsingRefBone = SRT_TowardsOtherEntity;	
				slaveSequencePart.shouldRotate			= true;
				
					
					slaveSequencePart.shouldSlide			= false;
				
				slaveSequencePart.blendInTime			= 0.2f;
				slaveSequencePart.blendOutTime			= 0.2f;
				slaveSequencePart.sequenceIndex			= 0;
				slaveSequencePart.disableProxyCollisions = true;
				
				
		
				
				
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity							= slave;
		
				slaveDef.manualSlotName					= 'FinisherSlot';
				slaveDef.freezeAtEnd					= false;
				
				masterEntity = (CGameplayEntity)master;
				slaveEntity = (CGameplayEntity)slave;
				
				if( !((CActor)slave).WillBeUnconscious() )
				{
					cameraAnimName = ProcessFinisherCameraAnimName( syncAnimName );
				}
				
				finisherAnim 							= true;
				
				break;				
			}
			case 'EredinPhaseChangePartOne':
			{
				
				syncAnimName = 'eredinbossfight_phasechange_01';
				
				masterSequencePart.animation			= syncAnimName;
				masterSequencePart.syncType				= AMST_SyncBeginning;
				masterSequencePart.shouldSlide			= false;
				masterSequencePart.shouldRotate			= false;		
				masterSequencePart.blendInTime			= 0.f;
				masterSequencePart.blendOutTime			= 0.f;
				masterSequencePart.sequenceIndex		= 0;			
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity						= master;
				masterDef.manualSlotName				= 'FinisherSlot';
				masterDef.startForceEvent				= 'PerformFinisher';
				masterDef.raiseEventOnEnd				= 'DoneFinisher';
				masterDef.freezeAtEnd					= true;
				
				
				slave.SetKinematic( true );
				slaveSequencePart.animation				= syncAnimName;
				slaveSequencePart.syncType				= AMST_SyncBeginning;	
				slaveSequencePart.shouldRotate			= true;
				slaveSequencePart.shouldSlide			= true;
				slaveSequencePart.finalPosition			= master.GetWorldPosition() + master.GetHeadingVector() * 2.7085;
				slaveSequencePart.finalHeading			= VecHeading( master.GetWorldPosition() );
				slaveSequencePart.blendInTime			= 0.f;
				slaveSequencePart.blendOutTime			= 0.f;
				slaveSequencePart.sequenceIndex			= 0;
				slaveSequencePart.disableProxyCollisions = true;				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity							= slave;
				slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
				slaveDef.freezeAtEnd					= false;

				PlayPhaseChangeCameraAnimation( 'eredinbossfight_phasechange_01' );
				finisherAnim 							= false;

				break;				
			}
			case 'EredinPhaseChangePartTwo':
			{
				
				syncAnimName = 'eredinbossfight_phasechange_02';
				
				masterSequencePart.animation			= syncAnimName;
				masterSequencePart.syncType				= AMST_SyncBeginning;
				masterSequencePart.shouldSlide			= true;
				masterSequencePart.shouldRotate			= true;
				
				node = theGame.GetNodeByTag( 'eredin_area_2' );
				rot0 = node.GetWorldRotation();
				
				masterSequencePart.finalPosition		= node.GetWorldPosition();
				masterSequencePart.finalHeading			= rot0.Yaw;		
				masterSequencePart.blendInTime			= 0.f;
				masterSequencePart.blendOutTime			= 0.f;
				masterSequencePart.sequenceIndex		= 0;			
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity						= master;
				masterDef.manualSlotName				= 'FinisherSlot';
				masterDef.startForceEvent				= 'PerformFinisher';
				masterDef.raiseEventOnEnd				= 'DoneFinisher';
				masterDef.freezeAtEnd					= true;
				
				
				slave.SetKinematic( true );
				slaveSequencePart.animation				= syncAnimName;
				slaveSequencePart.syncType				= AMST_SyncBeginning;	
				slaveSequencePart.shouldRotate			= true;
				slaveSequencePart.shouldSlide			= true;
				
				node1 = theGame.GetNodeByTag( 'eredinPos' );
				rot1 = node1.GetWorldRotation();
				
				slaveSequencePart.finalPosition			= node1.GetWorldPosition();
				slaveSequencePart.finalHeading			= rot1.Yaw;
				slaveSequencePart.blendInTime			= 0.f;
				slaveSequencePart.blendOutTime			= 0.f;
				slaveSequencePart.sequenceIndex			= 0;
				slaveSequencePart.disableProxyCollisions = true;				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity							= slave;
				slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
				slaveDef.freezeAtEnd					= false;

				PlayPhaseChangeCameraAnimation( 'eredinbossfight_phasechange_02' );
				finisherAnim 							= false;

				break;				
			}
			case 'NPCDismountRight':
			{
				
				masterSequencePart.animation		= 'horse_dismount_RF_01';
				masterSequencePart.syncType			= AMST_SyncBeginning;
				masterSequencePart.syncEventName	= 'SyncEvent';
				masterSequencePart.shouldSlide		= false;
				masterSequencePart.blendInTime		= 0.2f;
				masterSequencePart.blendOutTime		= 0.f;
				masterSequencePart.sequenceIndex	= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity					= master;
				masterDef.manualSlotName			= 'MANUAL_DIALOG_SLOT';
				masterDef.freezeAtEnd				= false;
				
				
				slaveSequencePart.animation			= 'horse_dismount_RF_01';
				slaveSequencePart.syncType			= AMST_SyncBeginning;
				slaveSequencePart.syncEventName		= 'SyncEvent';
				slaveSequencePart.shouldSlide		= false;
				slaveSequencePart.blendInTime		= 0.2f;
				slaveSequencePart.blendOutTime		= 0.2f;
				slaveSequencePart.sequenceIndex		= 0;
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity						= slave;
				slaveDef.manualSlotName				= 'MANUAL_DIALOG_SLOT';
				slaveDef.freezeAtEnd				= false;
				
				break;
			}
			case 'NPCDismountLeft':
			{
				
				masterSequencePart.animation		= 'horse_dismount_LF_01';
				masterSequencePart.syncType			= AMST_SyncBeginning;
				masterSequencePart.syncEventName	= 'SyncEvent';
				masterSequencePart.shouldSlide		= false;
				masterSequencePart.blendInTime		= 0.2f;
				masterSequencePart.blendOutTime		= 0.f;
				masterSequencePart.sequenceIndex	= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity					= master;
				masterDef.manualSlotName			= 'MANUAL_DIALOG_SLOT';
				masterDef.freezeAtEnd				= false;
				
				
				slaveSequencePart.animation			= 'horse_dismount_LF_01';
				slaveSequencePart.syncType			= AMST_SyncBeginning;
				slaveSequencePart.syncEventName		= 'SyncEvent';
				slaveSequencePart.shouldSlide		= false;
				slaveSequencePart.blendInTime		= 0.2f;
				slaveSequencePart.blendOutTime		= 0.2f;
				slaveSequencePart.sequenceIndex		= 0;
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity						= slave;
				slaveDef.manualSlotName				= 'MANUAL_DIALOG_SLOT';
				slaveDef.freezeAtEnd				= false;
				
				break;
			}
			case 'HorseRearing':
			{
				
				masterSequencePart.animation		= 'horse_rearing01';
				masterSequencePart.syncType			= AMST_SyncBeginning;
				masterSequencePart.syncEventName	= 'SyncEvent';
				masterSequencePart.shouldSlide		= false;
				masterSequencePart.blendInTime		= 0.2f;
				masterSequencePart.blendOutTime		= 0.f;
				masterSequencePart.sequenceIndex	= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity					= master;
				masterDef.manualSlotName			= 'MANUAL_DIALOG_SLOT';
				masterDef.freezeAtEnd				= false;
				
				
				slaveSequencePart.animation			= 'horse_rearing01';
				slaveSequencePart.syncType			= AMST_SyncBeginning;
				slaveSequencePart.syncEventName		= 'SyncEvent';
				slaveSequencePart.shouldSlide		= false;
				slaveSequencePart.blendInTime		= 0.2f;
				slaveSequencePart.blendOutTime		= 0.2f;
				slaveSequencePart.sequenceIndex		= 0;
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity						= slave;
				slaveDef.manualSlotName				= 'MANUAL_DIALOG_SLOT';
				slaveDef.freezeAtEnd				= false;
				
				break;
			}
			case 'LeshyHeadGrab':
			{
				
				masterSequencePart.animation		= 'monster_lessun_attack_grab_neck_quicker';
				masterSequencePart.syncType			= AMST_SyncMatchEvents;
				masterSequencePart.syncEventName	= 'SyncEvent';
				masterSequencePart.finalPosition	= master.GetWorldPosition() + master.GetHeadingVector();
				masterSequencePart.finalHeading		= master.GetHeading() + 180;
				masterSequencePart.shouldSlide		= true;
				masterSequencePart.shouldRotate		= true;
				masterSequencePart.blendInTime		= 0.2f;
				masterSequencePart.blendOutTime		= 0.f;
				masterSequencePart.sequenceIndex	= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity					= master;
				masterDef.manualSlotName			= 'GAMEPLAY_SLOT';
				masterDef.freezeAtEnd				= false;
				
				
				slaveSequencePart.animation			= 'man_ger_sword_heavyhit_front_lp';
				slaveSequencePart.syncType			= AMST_SyncMatchEvents;
				slaveSequencePart.syncEventName		= 'SyncEvent';
				slaveSequencePart.shouldSlide		= false;
				slaveSequencePart.blendInTime		= 0.2f;
				slaveSequencePart.blendOutTime		= 0.2f;
				slaveSequencePart.sequenceIndex		= 0;
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity						= slave;
				slaveDef.manualSlotName				= 'GAMEPLAY_SLOT';
				slaveDef.freezeAtEnd				= false;
				
				break;
			}
			case 'PantherGrabLeft':
			{
				rot = master.GetWorldRotation();
				pos = ((CActor)slave).PredictWorldPosition( 0.1 );
				
				collisionGroups.PushBack('Terrain');
				collisionGroups.PushBack('Static');
				collisionGroups.PushBack('Destructible');
				
				
				masterSequencePart.animation		= 'mcat_attack_grab_left';
				masterSequencePart.syncType			= AMST_SyncBeginning;
				masterSequencePart.syncEventName	= 'SyncEvent';
				
				masterSequencePart.finalPosition	= pos + 0.25 * VecNormalize( VecFromHeading( VecHeading( pos - master.GetWorldPosition() ) + 90 ) );
				
				zCorrectedPosition = masterSequencePart.finalPosition;
				zCorrectedPosition += ( 2.4 * VecNormalize( VecFromHeading( VecHeading( pos - master.GetWorldPosition() ) + 90 ) ) );
				theGame.GetWorld().StaticTrace( zCorrectedPosition + Vector(0,0,2.0), zCorrectedPosition - Vector(0,0,5), zCorrectedPosition, normal, collisionGroups );
				masterSequencePart.finalPosition.Z 	= zCorrectedPosition.Z;
				masterSequencePart.finalHeading		= VecHeading( pos - master.GetWorldPosition() );
				
				masterSequencePart.shouldSlide		= true;
				masterSequencePart.shouldRotate		= true;
				masterSequencePart.blendInTime		= 0.1f;
				masterSequencePart.blendOutTime		= 0.2f;
				masterSequencePart.sequenceIndex	= 0;
				masterSequencePart.disableProxyCollisions = true;
				((CActor)master).GetVisualDebug().AddSphere( 'syncPos', 0.5, masterSequencePart.finalPosition, true, Color( 0,255,255 ), 5.0f );
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity					= master;
				masterDef.manualSlotName			= 'GAMEPLAY_SLOT';
				masterDef.freezeAtEnd				= false;
				
				
				slaveSequencePart.animation			= 'mcat_attack_grab_left';
				slaveSequencePart.syncType			= AMST_SyncBeginning;
				slaveSequencePart.syncEventName		= 'SyncEvent';
				slaveSequencePart.shouldSlide		= false;
				slaveSequencePart.shouldRotate		= false;
				slaveSequencePart.finalHeading		= VecHeading( pos - master.GetWorldPosition() ) + 180;
				slaveSequencePart.finalPosition		= pos;
				slaveSequencePart.blendInTime		= 0.2f;
				slaveSequencePart.blendOutTime		= 0.2f;
				slaveSequencePart.sequenceIndex		= 0;
				
				
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity						= slave;
				slaveDef.manualSlotName				= 'GAMEPLAY_SLOT';
				slaveDef.freezeAtEnd				= false;
				
				break;
			}
			case 'PantherGrabRight':
			{
				rot = master.GetWorldRotation();
				pos = ((CActor)slave).PredictWorldPosition( 0.1 );
				
				collisionGroups.PushBack('Terrain');
				collisionGroups.PushBack('Static');
				collisionGroups.PushBack('Destructible');
				
				
				masterSequencePart.animation		= 'mcat_attack_grab_right';
				masterSequencePart.syncType			= AMST_SyncBeginning;
				masterSequencePart.syncEventName	= 'SyncEvent';
				
				masterSequencePart.finalPosition	= pos + 0.25 * VecNormalize(VecFromHeading( VecHeading( pos - master.GetWorldPosition() ) + 90 ) );
				
				zCorrectedPosition = masterSequencePart.finalPosition;
				zCorrectedPosition += ( 2.4 * VecNormalize( VecFromHeading( VecHeading( pos - master.GetWorldPosition() ) + 90 ) ) );
				theGame.GetWorld().StaticTrace( zCorrectedPosition + Vector(0,0,2.0), zCorrectedPosition - Vector(0,0,5), zCorrectedPosition, normal, collisionGroups );
				masterSequencePart.finalPosition.Z 	= zCorrectedPosition.Z;
				masterSequencePart.finalHeading		= VecHeading( pos - master.GetWorldPosition() );
				
				masterSequencePart.shouldSlide		= true;
				masterSequencePart.shouldRotate		= true;
				masterSequencePart.blendInTime		= 0.1f;
				masterSequencePart.blendOutTime		= 0.2f;
				masterSequencePart.sequenceIndex	= 0;
				
				
				masterSequencePart.disableProxyCollisions = true;
				((CActor)master).GetVisualDebug().AddSphere( 'syncPos', 0.5, masterSequencePart.finalPosition, true, Color( 0,255,255 ), 5.0f );
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity					= master;
				masterDef.manualSlotName			= 'GAMEPLAY_SLOT';
				masterDef.freezeAtEnd				= false;
				
				
				slaveSequencePart.animation			= 'mcat_attack_grab_right';
				slaveSequencePart.syncType			= AMST_SyncBeginning;
				slaveSequencePart.syncEventName		= 'SyncEvent';
				slaveSequencePart.shouldSlide		= false;
				slaveSequencePart.shouldRotate		= false;
				slaveSequencePart.finalHeading		= VecHeading( pos - master.GetWorldPosition() ) + 180;
				slaveSequencePart.finalPosition		= pos;
				slaveSequencePart.blendInTime		= 0.2f;
				slaveSequencePart.blendOutTime		= 0.2f;
				slaveSequencePart.sequenceIndex		= 0;
				slaveSequencePart.disableProxyCollisions = true;
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity						= slave;
				slaveDef.manualSlotName				= 'GAMEPLAY_SLOT';
				slaveDef.freezeAtEnd				= false;
				
				break;
			}
			case 'SirenCrawlFinisher':
			{
				
				masterSequencePart.animation		= 'man_ger_crawl_finish';
				masterSequencePart.syncType			= AMST_SyncMatchEvents;
				masterSequencePart.syncEventName	= 'SyncEvent';
				masterSequencePart.shouldSlide		= true;
				masterSequencePart.shouldRotate		= true;
				masterSequencePart.finalPosition	= 0.8 * VecNormalize( master.GetWorldPosition() - slave.GetWorldPosition() ) + ((CActor)slave).GetNearestPointInPersonalSpace( master.GetWorldPosition() );
				masterSequencePart.finalHeading		= VecHeading( slave.GetWorldPosition() - master.GetWorldPosition() );
				masterSequencePart.blendInTime		= 0.f;
				masterSequencePart.blendOutTime		= 0.f;
				masterSequencePart.sequenceIndex	= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity					= master;
				
				masterDef.manualSlotName			= 'FinisherSlot';
				masterDef.startForceEvent			= 'PerformFinisher';
				masterDef.raiseEventOnEnd			= 'DoneFinisher';
				masterDef.freezeAtEnd				= true;				
				
				
				slaveSequencePart.animation			= 'monster_siren_crawl_death';
				slaveSequencePart.syncType			= AMST_SyncMatchEvents;
				slaveSequencePart.syncEventName		= 'SyncEvent';
				slaveSequencePart.shouldSlide		= false;
				slaveSequencePart.blendInTime		= 0.2f;
				slaveSequencePart.blendOutTime		= 0.0f;
				slaveSequencePart.sequenceIndex		= 0;
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity						= slave;
				slaveDef.manualSlotName				= 'GAMEPLAY_SLOT';
				slaveDef.freezeAtEnd				= true;
				
				finisherAnim 						= true;
				
				break;
			}
			case 'NekkerKnockDownFinisher':
			{
				
				masterSequencePart.animation		= 'man_ger_crawl_finish';
				masterSequencePart.syncType			= AMST_SyncMatchEvents;
				masterSequencePart.syncEventName	= 'SyncEvent';
				masterSequencePart.shouldSlide		= true;
				masterSequencePart.shouldRotate		= true;
				
				pos = GetActorPosition( slave );				
				masterSequencePart.finalPosition	= 1.15 * VecNormalize( master.GetWorldPosition() - pos ) + pos;
				masterSequencePart.finalHeading		= VecHeading( pos - master.GetWorldPosition() );
				
				masterSequencePart.blendInTime		= 0.f;
				masterSequencePart.blendOutTime		= 0.f;
				masterSequencePart.sequenceIndex	= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity					= master;
				
				masterDef.manualSlotName			= 'FinisherSlot';
				masterDef.startForceEvent			= 'PerformFinisher';
				masterDef.raiseEventOnEnd			= 'DoneFinisher';
				masterDef.freezeAtEnd				= true;
				
				
				slaveSequencePart.animation			= 'c_knockdown_death';
				slaveSequencePart.syncType			= AMST_SyncMatchEvents;
				slaveSequencePart.syncEventName		= 'SyncEvent';
				slaveSequencePart.shouldSlide		= false;
				slaveSequencePart.blendInTime		= 0.2f;
				slaveSequencePart.blendOutTime		= 0.0f;
				slaveSequencePart.sequenceIndex		= 0;
				slaveSequencePart.allowBreakBeforeAtAfterEventsStart	= 'SetRagdoll';
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity						= slave;
				slaveDef.manualSlotName				= 'GAMEPLAY_SLOT';
				slaveDef.freezeAtEnd				= true;
				
				finisherAnim						 = true;
				
				break;
			}
			case 'DrownerKnockDownFinisher':
			{
				
				masterSequencePart.animation		= 'man_ger_crawl_finish';
				masterSequencePart.syncType			= AMST_SyncMatchEvents;
				masterSequencePart.syncEventName	= 'SyncEvent';
				masterSequencePart.shouldSlide		= true;
				masterSequencePart.shouldRotate		= true;
				
				pos = GetActorPosition( slave );				
				masterSequencePart.finalPosition	= 1.15 * VecNormalize( master.GetWorldPosition() - pos ) + pos;
				masterSequencePart.finalHeading		= VecHeading( pos - master.GetWorldPosition() );
				
				masterSequencePart.blendInTime		= 0.f;
				masterSequencePart.blendOutTime		= 0.f;
				masterSequencePart.sequenceIndex	= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity					= master;
				
				masterDef.manualSlotName			= 'FinisherSlot';
				masterDef.startForceEvent			= 'PerformFinisher';
				masterDef.raiseEventOnEnd			= 'DoneFinisher';
				masterDef.freezeAtEnd				= true;
				
				
				slaveSequencePart.animation			= 'monster_drowner_knockdown_death';
				slaveSequencePart.syncType			= AMST_SyncMatchEvents;
				slaveSequencePart.syncEventName		= 'SyncEvent';
				slaveSequencePart.shouldSlide		= false;
				slaveSequencePart.blendInTime		= 0.2f;
				slaveSequencePart.blendOutTime		= 0.0f;
				slaveSequencePart.sequenceIndex		= 0;
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity						= slave;
				slaveDef.manualSlotName				= 'GAMEPLAY_SLOT';
				slaveDef.freezeAtEnd				= true;
				
				finisherAnim = true;
				break;
			}
			case 'GhoulKnockDownFinisher':
			{
				
				masterSequencePart.animation		= 'man_ger_crawl_finish';
				masterSequencePart.syncType			= AMST_SyncMatchEvents;
				masterSequencePart.syncEventName	= 'SyncEvent';
				masterSequencePart.shouldSlide		= true;
				masterSequencePart.shouldRotate		= true;
				
				pos = GetActorPosition( slave );				
				masterSequencePart.finalPosition	= 1.15 * VecNormalize( master.GetWorldPosition() - pos ) + pos;
				masterSequencePart.finalHeading		= VecHeading( pos - master.GetWorldPosition() );
				
				masterSequencePart.blendInTime		= 0.f;
				masterSequencePart.blendOutTime		= 0.f;
				masterSequencePart.sequenceIndex	= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity					= master;
				
				masterDef.manualSlotName			= 'FinisherSlot';
				masterDef.startForceEvent			= 'PerformFinisher';
				masterDef.raiseEventOnEnd			= 'DoneFinisher';
				masterDef.freezeAtEnd				= true;
				
				
				slaveSequencePart.animation			= 'effect_knockdown_death';
				slaveSequencePart.syncType			= AMST_SyncMatchEvents;
				slaveSequencePart.syncEventName		= 'SyncEvent';
				slaveSequencePart.shouldSlide		= false;
				slaveSequencePart.blendInTime		= 0.2f;
				slaveSequencePart.blendOutTime		= 0.0f;
				slaveSequencePart.sequenceIndex		= 0;
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity						= slave;
				slaveDef.manualSlotName				= 'GAMEPLAY_SLOT';
				slaveDef.freezeAtEnd				= true;
				
				finisherAnim = true;
				break;
			}
			case 'GravehagKnockDownFinisher':
			{
				
				masterSequencePart.animation		= 'man_ger_crawl_finish';
				masterSequencePart.syncType			= AMST_SyncMatchEvents;
				masterSequencePart.syncEventName	= 'SyncEvent';
				masterSequencePart.shouldSlide		= true;
				masterSequencePart.shouldRotate		= true;
				
				pos = GetActorPosition( slave );				
				masterSequencePart.finalPosition	= 1.15 * VecNormalize( master.GetWorldPosition() - pos ) + pos;
				masterSequencePart.finalHeading	= VecHeading( pos - master.GetWorldPosition() );
				
				masterSequencePart.blendInTime		= 0.f;
				masterSequencePart.blendOutTime		= 0.f;
				masterSequencePart.sequenceIndex	= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity					= master;
				
				masterDef.manualSlotName			= 'FinisherSlot';
				masterDef.startForceEvent			= 'PerformFinisher';
				masterDef.raiseEventOnEnd			= 'DoneFinisher';
				masterDef.freezeAtEnd				= true;
				
				
				slaveSequencePart.animation			= 'death_knockdown';
				slaveSequencePart.syncType			= AMST_SyncMatchEvents;
				slaveSequencePart.syncEventName		= 'SyncEvent';
				slaveSequencePart.shouldSlide		= false;
				slaveSequencePart.blendInTime		= 0.2f;
				slaveSequencePart.blendOutTime		= 0.0f;
				slaveSequencePart.sequenceIndex		= 0;
				slaveSequencePart.allowBreakBeforeAtAfterEventsStart	= 'SetRagdoll';
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity						= slave;
				slaveDef.manualSlotName				= 'GAMEPLAY_SLOT';
				slaveDef.freezeAtEnd				= true;
				
				finisherAnim 						= true;
				slave.RaiseForceEvent( 'FinisherDeath' );
				break;
			}
			case 'HarpyKnockDownFinisher':
			{
				
				masterSequencePart.animation		= 'man_ger_crawl_finish';
				masterSequencePart.syncType			= AMST_SyncMatchEvents;
				masterSequencePart.syncEventName	= 'SyncEvent';
				masterSequencePart.shouldSlide		= true;
				masterSequencePart.shouldRotate		= true;
				
				pos = GetActorPosition( slave );				
				masterSequencePart.finalPosition	= 1.15 * VecNormalize( master.GetWorldPosition() - pos ) + pos;
				masterSequencePart.finalHeading		= VecHeading( pos - master.GetWorldPosition() );
				
				masterSequencePart.blendInTime		= 0.f;
				masterSequencePart.blendOutTime		= 0.f;
				masterSequencePart.sequenceIndex	= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity					= master;
				
				masterDef.manualSlotName			= 'FinisherSlot';
				masterDef.startForceEvent			= 'PerformFinisher';
				masterDef.raiseEventOnEnd			= 'DoneFinisher';
				masterDef.freezeAtEnd				= true;
				
				
				slaveSequencePart.animation			= 'monster_harpy_effect_knockdown_death';
				slaveSequencePart.syncType			= AMST_SyncMatchEvents;
				slaveSequencePart.syncEventName		= 'SyncEvent';
				slaveSequencePart.shouldSlide		= false;
				slaveSequencePart.blendInTime		= 0.2f;
				slaveSequencePart.blendOutTime		= 0.0f;
				slaveSequencePart.sequenceIndex		= 0;
				slaveSequencePart.allowBreakAtStartBeforeEventsEnd	= 'SyncEvent';
				
				
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity						= slave;
				slaveDef.manualSlotName				= 'GAMEPLAY_SLOT';
				slaveDef.freezeAtEnd				= false;
				
				finisherAnim 						= true;
				
				break;
			}
			case 'WolfKnockDownFinisher':
			{
				
				masterSequencePart.animation		= 'man_ger_crawl_finish';
				masterSequencePart.syncType			= AMST_SyncMatchEvents;
				masterSequencePart.syncEventName	= 'SyncEvent';
				masterSequencePart.shouldSlide		= true;
				masterSequencePart.shouldRotate		= true;
				
				pos = GetActorPosition( slave );				
				masterSequencePart.finalPosition	= 1.15 * VecNormalize( master.GetWorldPosition() - pos ) + pos;
				masterSequencePart.finalHeading		= VecHeading( pos - master.GetWorldPosition() );
				
				masterSequencePart.blendInTime		= 0.f;
				masterSequencePart.blendOutTime		= 0.f;
				masterSequencePart.sequenceIndex	= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity					= master;
				
				masterDef.manualSlotName			= 'FinisherSlot';
				masterDef.startForceEvent			= 'PerformFinisher';
				masterDef.raiseEventOnEnd			= 'DoneFinisher';
				masterDef.freezeAtEnd				= true;
				
				
				slaveSequencePart.animation			= 'wolf_knockdown_death2';
				slaveSequencePart.syncType			= AMST_SyncMatchEvents;
				slaveSequencePart.syncEventName		= 'SyncEvent';
				slaveSequencePart.shouldSlide		= false;
				slaveSequencePart.blendInTime		= 0.2f;
				slaveSequencePart.blendOutTime		= 0.0f;
				slaveSequencePart.sequenceIndex		= 0;
				
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity						= slave;
				slaveDef.manualSlotName				= 'GAMEPLAY_SLOT';
				slaveDef.freezeAtEnd				= true;
				
				finisherAnim 						= true;
				
				break;
			}
			case 'BoarKnockDownFinisher':
			{
				
				masterSequencePart.animation		= 'man_ger_crawl_finish';
				masterSequencePart.syncType			= AMST_SyncMatchEvents;
				masterSequencePart.syncEventName	= 'SyncEvent';
				masterSequencePart.shouldSlide		= true;
				masterSequencePart.shouldRotate		= true;
				
				pos = GetActorPosition( slave );				
				masterSequencePart.finalPosition	= 1.15 * VecNormalize( master.GetWorldPosition() - pos ) + pos;
				masterSequencePart.finalHeading		= VecHeading( pos - master.GetWorldPosition() );
				
				masterSequencePart.blendInTime		= 0.f;
				masterSequencePart.blendOutTime		= 0.f;
				masterSequencePart.sequenceIndex	= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity					= master;
				
				masterDef.manualSlotName			= 'FinisherSlot';
				masterDef.startForceEvent			= 'PerformFinisher';
				masterDef.raiseEventOnEnd			= 'DoneFinisher';
				masterDef.freezeAtEnd				= true;
				
				
				if ( slave.GetBehaviorVariable('HitReactionSide') == (int)EHRS_Right )
				{
					slaveSequencePart.animation	 = 'boar_knockdown1_death3';
				}
				else if ( slave.GetBehaviorVariable('HitReactionSide') == (int)EHRS_Left)
				{
					slaveSequencePart.animation	 = 'boar_knockdown_death3';
				}
				else
				{
					slaveSequencePart.animation	 = 'boar_knockdown1_death3';
				}
				slaveSequencePart.syncType			= AMST_SyncMatchEvents;
				slaveSequencePart.syncEventName		= 'SyncEvent';
				slaveSequencePart.shouldSlide		= false;
				slaveSequencePart.blendInTime		= 0.2f;
				slaveSequencePart.blendOutTime		= 0.0f;
				slaveSequencePart.sequenceIndex		= 0;
				
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity						= slave;
				slaveDef.manualSlotName				= 'GAMEPLAY_SLOT';
				slaveDef.freezeAtEnd				= true;
				
				finisherAnim 						= true;
				
				break;
			}
			case 'WerewolfKnockDownFinisher':
			{
				
				masterSequencePart.animation		= 'man_ger_crawl_finish';
				masterSequencePart.syncType			= AMST_SyncMatchEvents;
				masterSequencePart.syncEventName	= 'SyncEvent';
				masterSequencePart.shouldSlide		= true;
				masterSequencePart.shouldRotate		= true;
				
				pos = GetActorPosition( slave );				
				masterSequencePart.finalPosition	= 1.15 * VecNormalize( master.GetWorldPosition() - pos ) + pos;
				masterSequencePart.finalHeading		= VecHeading( pos - master.GetWorldPosition() );
								
				
				
				masterSequencePart.blendInTime		= 0.f;
				masterSequencePart.blendOutTime		= 0.f;
				masterSequencePart.sequenceIndex	= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity					= master;
				
				masterDef.manualSlotName			= 'FinisherSlot';
				masterDef.startForceEvent			= 'PerformFinisher';
				masterDef.raiseEventOnEnd			= 'DoneFinisher';
				masterDef.freezeAtEnd				= true;
				
				
				slaveSequencePart.animation			= 'monstwer_werewolf_knockdown_die';
				slaveSequencePart.syncType			= AMST_SyncMatchEvents;
				slaveSequencePart.syncEventName		= 'SyncEvent';
				slaveSequencePart.shouldSlide		= false;
				slaveSequencePart.blendInTime		= 0.2f;
				slaveSequencePart.blendOutTime		= 0.0f;
				slaveSequencePart.sequenceIndex		= 0;
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity						= slave;
				slaveDef.manualSlotName				= 'GAMEPLAY_SLOT';
				slaveDef.freezeAtEnd				= true;
				
				finisherAnim 						= true;
				
				break;
			}
			case 'BruxaKnockDownFinisher':
			{
				
				masterSequencePart.animation		= 'man_ger_crawl_finish_vampire';
				masterSequencePart.syncType			= AMST_SyncMatchEvents;
				masterSequencePart.syncEventName	= 'SyncEvent';
				masterSequencePart.shouldSlide		= true;
				masterSequencePart.shouldRotate		= true;
				
				pos = GetActorPosition( slave );				
				masterSequencePart.finalPosition	= 1.15 * VecNormalize( master.GetWorldPosition() - pos ) + pos;
				masterSequencePart.finalHeading		= VecHeading( pos - master.GetWorldPosition() );
				
				masterSequencePart.blendInTime		= 0.f;
				masterSequencePart.blendOutTime		= 0.f;
				masterSequencePart.sequenceIndex	= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity					= master;
				masterDef.manualSlotName			= 'FinisherSlot';
				masterDef.startForceEvent			= 'PerformFinisher';
				masterDef.raiseEventOnEnd			= 'DoneFinisher';
				masterDef.freezeAtEnd				= true;
				
				
				if ( ( (CActor)slave ).HasAbility( 'EvadeFinisher' ) && !( (CActor)slave ).HasBuff( EET_Slowdown ) )
				{
					slaveSequencePart.animation		= 'bruxa_crawl_to_dodge_slide';
					
					slaveDef.startForceEvent 		= 'ForceIdle';
					slaveDef.raiseForceEventOnEnd 	= 'ForceIdle';
					
					( (CNewNPC)slave ).AddTimer( 'EvadeFinisherTimer', 0.5, false );
				}
				else
				{
					slaveSequencePart.animation		= 'bruxa_crawl_finisher';
					slaveDef.startForceEvent 		= 'FinisherDeath';
					slaveDef.freezeAtEnd			= true;
					finisherAnim = true;
				}
				slaveSequencePart.syncType			= AMST_SyncMatchEvents;
				slaveSequencePart.syncEventName		= 'SyncEvent';
				slaveSequencePart.shouldSlide		= false;
				slaveSequencePart.blendInTime		= 0.2f;
				slaveSequencePart.blendOutTime		= 0.2f;
				slaveSequencePart.sequenceIndex		= 0;
				slaveSequencePart.allowBreakAtStartBeforeEventsEnd	= 'SyncEvent';
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity						= slave;
				slaveDef.manualSlotName				= 'GAMEPLAY_SLOT';
				
				masterEntity 						= (CGameplayEntity)master;
				slaveEntity 						= (CGameplayEntity)slave;
				syncActionName 						= syncAction;
				
				((CNewNPC)slave).AddBuffImmunity( EET_Knockdown, 'SyncAnim', false );
				((CNewNPC)slave).AddBuffImmunity( EET_HeavyKnockdown, 'SyncAnim', false );
				((CNewNPC)slave).AddBuffImmunity( EET_KnockdownTypeApplicator, 'SyncAnim', false );
				((CNewNPC)slave).SetUnstoppable( true );
				
				break;
			}
			case 'HumanKnockDownFinisher':
			{
				
				masterSequencePart.animation		= 'man_ger_crawl_finish';
				masterSequencePart.syncType			= AMST_SyncMatchEvents;
				masterSequencePart.syncEventName	= 'SyncEvent';
				masterSequencePart.shouldSlide		= true;
				masterSequencePart.shouldRotate		= true;
				
				pos = GetActorPosition( slave );				
				masterSequencePart.finalPosition	= 1.15 * VecNormalize( master.GetWorldPosition() - pos ) + pos;
				masterSequencePart.finalHeading		= VecHeading( pos - master.GetWorldPosition() );
				
				masterSequencePart.blendInTime		= 0.f;
				masterSequencePart.blendOutTime		= 0.f;
				masterSequencePart.sequenceIndex	= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity					= master;
				
				masterDef.manualSlotName			= 'FinisherSlot';
				masterDef.startForceEvent			= 'PerformFinisher';
				masterDef.raiseEventOnEnd			= 'DoneFinisher';
				masterDef.freezeAtEnd				= true;
				
				
				
				if ( ( (CActor)slave ).GetLyingDownFacingDirection() >= 0 )
					slaveSequencePart.animation		= 'man_npc_sword_1hand_hit_knockdown_death';
				else
					slaveSequencePart.animation		= 'man_npc_sword_1hand_wounded_crawl_killed';
				slaveSequencePart.syncType			= AMST_SyncMatchEvents;
				slaveSequencePart.syncEventName		= 'SyncEvent';
				slaveSequencePart.shouldSlide		= false;
				slaveSequencePart.blendInTime		= 0.0f;
				slaveSequencePart.blendOutTime		= 0.0f;
				slaveSequencePart.sequenceIndex		= 0;
				
				slaveSequencePart.allowBreakAtStartBeforeEventsEnd	= 'SyncEvent';
				
				
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity						= slave;
				slaveDef.manualSlotName				= 'GAMEPLAY_SLOT';
				slaveDef.freezeAtEnd				= true;
				
				finisherAnim = true;
				
				break;
			}
			case 'HumanComboFinisher':
			{
				
				if ( thePlayer.GetCombatIdleStance() <= 0.f )
				{
					syncAnimName = 'man_finisher_02_lp';
				}
				else
				{
					syncAnimName = 'man_finisher_01_rp';
				}
				
				masterSequencePart.animation			= syncAnimName;
				masterSequencePart.syncType				= AMST_SyncBeginning;
				masterSequencePart.useRefBone			= 'Reference';
				masterSequencePart.rotationTypeUsingRefBone = SRT_TowardsOtherEntity;
				masterSequencePart.shouldSlide			= true;
				masterSequencePart.shouldRotate			= true;
				
				masterSequencePart.blendInTime			= 0.f;
				masterSequencePart.blendOutTime			= 0.f;
				masterSequencePart.sequenceIndex		= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity						= master;
				masterDef.manualSlotName				= 'FinisherSlot';
				masterDef.startForceEvent				= 'PerformFinisher';
				masterDef.raiseEventOnEnd				= 'DoneFinisher';
				masterDef.freezeAtEnd					= true;
				
				
				slave.SetKinematic( true );
				slaveSequencePart.animation				= syncAnimName;
				slaveSequencePart.syncType				= AMST_SyncBeginning;
				slaveSequencePart.useRefBone			= 'Reference';	
				slaveSequencePart.rotationTypeUsingRefBone = SRT_TowardsOtherEntity;
				slaveSequencePart.shouldRotate			= true;
				slaveSequencePart.shouldSlide			= false;
				
				slaveSequencePart.blendInTime			= 0.f;
				slaveSequencePart.blendOutTime			= 0.f;
				slaveSequencePart.sequenceIndex			= 0;
				slaveSequencePart.disableProxyCollisions = true;
				
				
		
				
				
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity							= slave;
		
				slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
				slaveDef.freezeAtEnd					= true;
				
				finisherAnim 							= true;
				
				break;
			}				
			case 'FistFightFinisher':
			{
				
				( (CR4Player)master ).GetFistFightFinisher( slaveSequencePart.animation, temp );
				masterSequencePart.syncType				= AMST_SyncBeginning;
				masterSequencePart.syncEventName		= 'SyncEvent';
				masterSequencePart.shouldSlide			= true;
				masterSequencePart.shouldRotate			= true;
				masterSequencePart.finalPosition		= 0.8 * VecNormalize( master.GetWorldPosition() - slave.GetWorldPosition() ) + ((CActor)slave).GetNearestPointInPersonalSpace( master.GetWorldPosition() );
				masterSequencePart.finalHeading			= VecHeading( slave.GetWorldPosition() - master.GetWorldPosition() );
				masterSequencePart.blendInTime			= 0.f;
				masterSequencePart.blendOutTime			= 0.f;
				masterSequencePart.sequenceIndex		= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity						= master;
				
				masterDef.manualSlotName				= 'FinisherSlot';
				masterDef.startForceEvent				= 'PerformFinisher';
				masterDef.raiseEventOnEnd				= 'DoneFinisher';
				masterDef.freezeAtEnd					= true;
				
				
				slaveSequencePart.animation				= temp;
				slaveSequencePart.syncType				= AMST_SyncBeginning;
				slaveSequencePart.syncEventName			= 'SyncEvent';
				slaveSequencePart.shouldSlide			= false;
				slaveSequencePart.blendInTime			= 0.2f;
				slaveSequencePart.blendOutTime			= 0.2f;
				slaveSequencePart.sequenceIndex			= 0;
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity							= slave;
				slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
				slaveDef.freezeAtEnd					= false;
				
				finisherAnim 							= true;
				
				break;
			}
			case 'SwitchLeverOn':
			{
				rot = slave.GetWorldRotation();
				pos = GetActorPosition( slave );
				
				
				masterSequencePart.animation			= 'lever_up_to_down_light';
				masterSequencePart.syncType				= AMST_SyncBeginning;
				masterSequencePart.syncEventName		= 'SyncEvent';
				masterSequencePart.shouldSlide			= true;
				masterSequencePart.shouldRotate			= true;
				masterSequencePart.finalPosition		= slave.GetWorldPosition() - 0.7341 * VecNormalize( VecFromHeading( rot.Yaw + 180 )) - 0.13 * VecNormalize( VecFromHeading( rot.Yaw + 90 ));
				masterSequencePart.finalHeading			= rot.Yaw + 180;
				masterSequencePart.blendInTime			= 0.2f;
				masterSequencePart.blendOutTime			= 0.2f;
				masterSequencePart.sequenceIndex		= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity						= master;
				masterDef.manualSlotName				= 'GAMEPLAY_SLOT';
				masterDef.freezeAtEnd					= false;
				masterDef.raiseForceEventOnEnd			= 'ForceIdle';
				
				
				slaveSequencePart.animation				= 'lever_up_to_down_light';
				slaveSequencePart.syncType				= AMST_SyncBeginning;
				slaveSequencePart.syncEventName			= 'SyncEvent';
				slaveSequencePart.shouldSlide			= false;
				slaveSequencePart.blendInTime			= 0.2f;
				slaveSequencePart.blendOutTime			= 0.0f;
				slaveSequencePart.sequenceIndex			= 0;
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity			= slave;
				slaveDef.manualSlotName	= 'GAMEPLAY_SLOT';
				slaveDef.freezeAtEnd	= false;
				
				((W3Switch)slave).ProcessPostTurnActions( false, false );
				masterEntity = (CGameplayEntity)master;
				slaveEntity = (CGameplayEntity)slave;
				
				break;
			}
			case 'SwitchLeverOff':
			{
				rot = slave.GetWorldRotation();
				pos = GetActorPosition( slave );
				
				
				masterSequencePart.animation			= 'lever_down_to_up_light';
				masterSequencePart.syncType				= AMST_SyncBeginning;
				masterSequencePart.syncEventName		= 'SyncEvent';
				masterSequencePart.shouldSlide			= true;
				masterSequencePart.shouldRotate			= true;
				masterSequencePart.finalPosition		= slave.GetWorldPosition() - 0.7341 * VecNormalize( VecFromHeading( rot.Yaw + 180 )) - 0.13 * VecNormalize( VecFromHeading( rot.Yaw + 90 ));
				masterSequencePart.finalHeading			= rot.Yaw + 180;
				masterSequencePart.blendInTime			= 0.2f;
				masterSequencePart.blendOutTime			= 0.2f;
				masterSequencePart.sequenceIndex		= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity						= master;
				masterDef.manualSlotName				= 'GAMEPLAY_SLOT';
				masterDef.freezeAtEnd					= false;
				masterDef.raiseForceEventOnEnd			= 'ForceIdle';
				
				
				slaveSequencePart.animation				= 'lever_down_to_up_light';
				slaveSequencePart.syncType				= AMST_SyncBeginning;
				slaveSequencePart.syncEventName			= 'SyncEvent';
				slaveSequencePart.shouldSlide			= false;
				slaveSequencePart.blendInTime			= 0.2f;
				slaveSequencePart.blendOutTime			= 0.0f;
				slaveSequencePart.sequenceIndex			= 0;
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity			= slave;
				slaveDef.manualSlotName	= 'GAMEPLAY_SLOT';
				slaveDef.freezeAtEnd	= false;
				
				((W3Switch)slave).ProcessPostTurnActions( false, false );
				masterEntity = (CGameplayEntity)master;
				slaveEntity = (CGameplayEntity)slave;
				
				break;
			}
			case 'SwitchButtonOn':
			{
				rot = slave.GetWorldRotation();
				
				
				masterSequencePart.animation		= 'push_button_01';
				
				masterSequencePart.syncType				= AMST_SyncBeginning;
				masterSequencePart.syncEventName		= 'SyncEvent';
				masterSequencePart.shouldSlide			= true;
				masterSequencePart.shouldRotate			= true;
				masterSequencePart.finalPosition		= slave.GetWorldPosition() - 0.65 * VecNormalize( VecFromHeading( rot.Yaw + 180 )) - 0.15 * VecNormalize( VecFromHeading( rot.Yaw + 90 ));
				masterSequencePart.finalHeading			= rot.Yaw + 180;
				masterSequencePart.blendInTime			= 0.2f;
				masterSequencePart.blendOutTime			= 0.2f;
				masterSequencePart.sequenceIndex		= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity						= master;
				masterDef.manualSlotName				= 'GAMEPLAY_SLOT';
				masterDef.freezeAtEnd					= false;
				
				
				
				slaveSequencePart.animation			= 'btn_up_to_down';
				
				
				slaveSequencePart.syncType				= AMST_SyncBeginning;
				slaveSequencePart.syncEventName			= 'SyncEvent';
				slaveSequencePart.shouldSlide			= false;
				slaveSequencePart.blendInTime			= 0.2f;
				slaveSequencePart.blendOutTime			= 0.0f;
				slaveSequencePart.sequenceIndex			= 0;
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity							= slave;
				slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
				slaveDef.freezeAtEnd					= false;
				
				((W3Switch)slave).ProcessPostTurnActions( false, false );
				
				break;
			}	
			case 'SwitchButtonOff':
			{
				rot = slave.GetWorldRotation();
				
				
				masterSequencePart.animation			= 'push_button_01';
				
				masterSequencePart.syncType				= AMST_SyncBeginning;
				masterSequencePart.syncEventName		= 'SyncEvent';
				masterSequencePart.shouldSlide			= true;
				masterSequencePart.shouldRotate			= true;
				masterSequencePart.finalPosition		= slave.GetWorldPosition() - 0.65 * VecNormalize( VecFromHeading( rot.Yaw + 180 )) - 0.15 * VecNormalize( VecFromHeading( rot.Yaw + 90 ));
				masterSequencePart.finalHeading			= rot.Yaw + 180;
				masterSequencePart.blendInTime			= 0.2f;
				masterSequencePart.blendOutTime			= 0.2f;
				masterSequencePart.sequenceIndex		= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity						= master;
				masterDef.manualSlotName				= 'GAMEPLAY_SLOT';
				masterDef.freezeAtEnd					= false;
				
				
				
				slaveSequencePart.animation				= 'btn_down_to_up';
				
				slaveSequencePart.syncType				= AMST_SyncBeginning;
				slaveSequencePart.syncEventName			= 'SyncEvent';
				slaveSequencePart.shouldSlide			= false;
				slaveSequencePart.blendInTime			= 0.2f;
				slaveSequencePart.blendOutTime			= 0.0f;
				slaveSequencePart.sequenceIndex			= 0;
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity							= slave;
				slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
				slaveDef.freezeAtEnd					= false;
				
				((W3Switch)slave).ProcessPostTurnActions( false, false );
				
				break;
			}			
			default : 
			{
				syncInstances.Remove( syncInstance );
				return false;
			}
			
		}
		
		sequenceIndex = syncInstance.RegisterMaster( masterDef );
		if( sequenceIndex == -1 )
		{
			syncInstances.Remove( syncInstance );
			return false;
		}
		
		
		actorMaster = (CActor)master;
		actorSlave = (CActor)slave;
		
		if(actorMaster)
		{
			actorMaster.SignalGameplayEventParamInt( 'SetupSyncInstance', instanceIndex );
			actorMaster.SignalGameplayEventParamInt( 'SetupSequenceIndex', sequenceIndex );
			if ( finisherAnim )
				actorMaster.SignalGameplayEvent( 'PlayFinisherSyncedAnim' );
			else
				actorMaster.SignalGameplayEvent( 'PlaySyncedAnim' );
			
		}
		
		sequenceIndex = syncInstance.RegisterSlave( slaveDef );
		if( sequenceIndex == -1 )
		{
			syncInstances.Remove( syncInstance );
			return false;
		}
		
		
		if(actorSlave)
		{
			if( syncAction == 'Throat' )
				actorSlave.SignalGameplayEventParamCName( 'SetupEndEvent', 'CriticalState' );
				
			actorSlave.SignalGameplayEventParamInt( 'SetupSyncInstance', instanceIndex );
			actorSlave.SignalGameplayEventParamInt( 'SetupSequenceIndex', sequenceIndex );
			if ( finisherAnim )
				actorSlave.SignalGameplayEvent( 'PlayFinisherSyncedAnim' );
			else
				actorSlave.SignalGameplayEvent( 'PlaySyncedAnim' );
		}
		
		
		
		return true;
	}
	
	
	public function SetupSimpleSyncAnim2( syncAction : name, master, slave : CEntity ) : bool
	{
		var masterDef, slaveDef						: SAnimationSequenceDefinition;
		var masterSequencePart, slaveSequencePart	: SAnimationSequencePartDefinition;
		var syncInstance							: CAnimationManualSlotSyncInstance;
		
		var instanceIndex	: int;
		var sequenceIndex	: int;
		
		var actorMaster, actorSlave : CActor;
		
		var temp : name; 
		var tempF : float;
		var rot : EulerAngles;
		
		var finisherAnim : bool;
		var pos : Vector;
		
		var syncAnimName	: name;
		
		var node, node1 : CNode; 
		var rot0, rot1 : EulerAngles;
		
		syncInstance = CreateNewSyncInstance( instanceIndex );
		
		
		thePlayer.BlockAction(EIAB_Interactions, 'SyncManager' );
		thePlayer.BlockAction(EIAB_FastTravel, 'SyncManager' );
		
		switch( syncAction )
		{
			case 'BruxaBite':
			{
				rot = slave.GetWorldRotation();
				pos = ((CActor)slave).PredictWorldPosition( 0.1 );
				tempF = NodeToNodeAngleDistance( master, slave );
				
				
				if ( slave == thePlayer && ((CR4Player)slave).GetCombatIdleStance() == 0 )
				{
					
					if ( tempF >= -90.0 && tempF < 90.0 )
					{
						masterSequencePart.animation = 'bruxa_attack_bite_front_lp';
						slaveSequencePart.animation = 'bruxa_attack_bite_front_lp';
						masterSequencePart.finalHeading	= rot.Yaw + 180;
					}
					
					else
					{
						masterSequencePart.animation = 'bruxa_attack_bite_back_lp';
						slaveSequencePart.animation = 'bruxa_attack_bite_back_lp';
						masterSequencePart.finalHeading	= rot.Yaw;
					}
				}
				
				else
				{
					
					if ( tempF >= -90.0 && tempF < 90.0 )
					{
						masterSequencePart.animation = 'bruxa_attack_bite_front_rp';
						slaveSequencePart.animation = 'bruxa_attack_bite_front_rp';
						masterSequencePart.finalHeading	= rot.Yaw + 180;
					}
					
					else
					{
						masterSequencePart.animation = 'bruxa_attack_bite_back_rp';
						slaveSequencePart.animation = 'bruxa_attack_bite_back_rp';
						masterSequencePart.finalHeading	= rot.Yaw;
					}
				}
				
				((CActor)slave).AddEffectDefault( EET_Bleeding, (CActor)master, "BruxaBiteAttack" );
				master.SetBehaviorVariable( 'bite', 1 );
				FactsAdd( "player_bitten_by_vampire", 1, 3 );
				
				
				
				masterSequencePart.syncType			= AMST_SyncBeginning;
				masterSequencePart.syncEventName	= 'SyncEvent';
				masterSequencePart.finalPosition	= pos; 
				
				masterSequencePart.shouldSlide		= true;
				masterSequencePart.shouldRotate		= true;
				masterSequencePart.blendInTime		= 0.2f;
				masterSequencePart.blendOutTime		= 0.2f;
				masterSequencePart.sequenceIndex	= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity					= master;
				masterDef.manualSlotName			= 'GAMEPLAY_SLOT';
				masterDef.freezeAtEnd				= false;
				masterDef.startForceEvent 			= 'ForceIdle';
				
				
				
				slaveSequencePart.syncType			= AMST_SyncBeginning;
				slaveSequencePart.syncEventName		= 'SyncEvent';
				slaveSequencePart.shouldSlide		= false;
				slaveSequencePart.shouldRotate		= false;
				slaveSequencePart.blendInTime		= 0.2f;
				slaveSequencePart.blendOutTime		= 0.2f;
				slaveSequencePart.sequenceIndex		= 0;
				slaveSequencePart.disableProxyCollisions = true;
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity						= slave;
				slaveDef.manualSlotName				= 'GAMEPLAY_SLOT';
				slaveDef.freezeAtEnd				= false;
				
				break;
			}
			case 'DettlaffWings':
			{
				rot = slave.GetWorldRotation();
				pos = slave.GetWorldPosition();
					
				
				
				masterSequencePart.animation			= 'man_finisher_dlc2_dettlaff_cut_wings_lp';
				masterSequencePart.syncType				= AMST_SyncBeginning;
				masterSequencePart.finalPosition		= pos; 
				masterSequencePart.finalHeading			= rot.Yaw+180;
				
				masterSequencePart.shouldSlide			= true;
				masterSequencePart.shouldRotate			= true;
				
				masterSequencePart.blendInTime			= 0.1f;
				masterSequencePart.blendOutTime			= 0.2f;
				masterSequencePart.sequenceIndex		= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity						= master;
				masterDef.freezeAtEnd					= false;
				masterDef.manualSlotName				= 'GAMEPLAY_SLOT';
					
				
					
				slaveSequencePart.animation				= 'man_finisher_dlc2_dettlaff_cut_wings_lp';
				slaveSequencePart.syncType				= AMST_SyncBeginning;
				slaveSequencePart.shouldRotate			= false;
				slaveSequencePart.shouldSlide			= false;
				slaveSequencePart.blendInTime			= 0.1f;
				slaveSequencePart.blendOutTime			= 0.2f;
				slaveSequencePart.sequenceIndex			= 0;
				slaveSequencePart.disableProxyCollisions = true;
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity							= slave;
				slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
				slaveDef.freezeAtEnd					= false;
				
				masterEntity = (CGameplayEntity)master;
				slaveEntity = (CGameplayEntity)slave;
				
				ProcessDettlaffFinisherCamera();
				
				
				break;	
			}
			case 'DettlaffBlood':
			{
				rot = slave.GetWorldRotation();
				pos = slave.GetWorldPosition();
					
				
				
				masterSequencePart.animation			= 'man_finisher_dlc2_dettlaff_blood_drinking';
				masterSequencePart.syncType				= AMST_SyncBeginning;
				masterSequencePart.finalPosition		= pos; 
				masterSequencePart.finalHeading			= rot.Yaw;
				
				masterSequencePart.shouldSlide			= true;
				masterSequencePart.shouldRotate			= true;
				
				masterSequencePart.blendInTime			= 0.0f;
				masterSequencePart.blendOutTime			= 0.2f;
				masterSequencePart.sequenceIndex		= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity						= master;
				masterDef.freezeAtEnd					= false;
				masterDef.manualSlotName				= 'GAMEPLAY_SLOT';
					
				
					
				slaveSequencePart.animation				= 'man_finisher_dlc2_dettlaff_blood_drinking';
				slaveSequencePart.syncType				= AMST_SyncBeginning;
				slaveSequencePart.shouldRotate			= false;
				slaveSequencePart.shouldSlide			= false;
				slaveSequencePart.blendInTime			= 0.0f;
				slaveSequencePart.blendOutTime			= 0.2f;
				slaveSequencePart.sequenceIndex			= 0;
				slaveSequencePart.disableProxyCollisions = true;
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity							= slave;
				slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
				slaveDef.freezeAtEnd					= false;
				
				masterEntity = (CGameplayEntity)master;
				slaveEntity = (CGameplayEntity)slave;
				
				
				
				break;	
			}
			case 'DettlaffTorso':
			{
				rot = slave.GetWorldRotation();
				pos = ((CActor)slave).PredictWorldPosition( 0.2f );
					
				
				
				masterSequencePart.animation			= 'man_finisher_dlc2_dettlaff_cut_torso_rp';
				masterSequencePart.syncType				= AMST_SyncMatchEvents;
				masterSequencePart.syncEventName 		= 'SyncEvent';
				masterSequencePart.finalPosition		= pos; 
				masterSequencePart.finalHeading			= rot.Yaw;
				
				masterSequencePart.shouldSlide			= true;
				masterSequencePart.shouldRotate			= true;
				
				masterSequencePart.blendInTime			= 0.0f;
				masterSequencePart.blendOutTime			= 0.2f;
				masterSequencePart.sequenceIndex		= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity						= master;
				masterDef.freezeAtEnd					= false;
				masterDef.manualSlotName				= 'GAMEPLAY_SLOT';

					
				
					
				slaveSequencePart.animation				= 'man_finisher_dlc2_dettlaff_cut_torso_rp';
				slaveSequencePart.syncType				= AMST_SyncMatchEvents;
				slaveSequencePart.syncEventName 		= 'SyncEvent';
				slaveSequencePart.shouldRotate			= false;
				slaveSequencePart.shouldSlide			= false;
				slaveSequencePart.blendInTime			= 0.0f;
				slaveSequencePart.blendOutTime			= 0.2f;
				slaveSequencePart.sequenceIndex			= 0;
				slaveSequencePart.disableProxyCollisions = true;
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity							= slave;
				
				slaveDef.manualSlotName					= 'FinisherSlot';
				slaveDef.startForceEvent				= 'PerformFinisher';
				slaveDef.raiseEventOnEnd				= 'DoneFinisher';
				slaveDef.freezeAtEnd					= false;
				finisherAnim 							= true;
				
				masterEntity = (CGameplayEntity)master;
				slaveEntity = (CGameplayEntity)slave;
				
				ProcessDettlaffFinisherCamera();
				
				break;	
			}
			case 'ArchesporEating_01':
			{
				
				masterSequencePart.animation			= 'utility_wander_eating_end';	
				masterSequencePart.syncType				= AMST_SyncBeginning;
				masterSequencePart.shouldSlide			= false;
				masterSequencePart.shouldRotate			= false;		
				masterSequencePart.blendInTime			= 0.f;
				masterSequencePart.blendOutTime			= 0.f;
				masterSequencePart.sequenceIndex		= 0;
				masterSequencePart.allowBreakBeforeEnd 	= 7.0;
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity						= master;
				masterDef.manualSlotName				= 'GAMEPLAY_SLOT';
				masterDef.raiseEventOnEnd				= 'ForceIdle';
				
				
				slaveSequencePart.animation				= 'utility_wander_eating_end';
				slaveSequencePart.syncType				= AMST_SyncBeginning;	
				slaveSequencePart.blendInTime			= 0.f;
				slaveSequencePart.blendOutTime			= 0.f;
				slaveSequencePart.sequenceIndex			= 0;	
				slaveSequencePart.allowBreakBeforeEnd 	= 7.0;
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity							= slave;
				slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
				
				masterEntity = (CGameplayEntity)master;
				slaveEntity = (CGameplayEntity)slave;
				
				break;	
			}
			
			case 'PetHorse':
			{
				rot = slave.GetWorldRotation();
				
				
				if( VecDistance(master.GetWorldPosition(), slave.GetWorldPosition() + VecConeRand(slave.GetHeading() - 90, 0, 1,1)) < VecDistance(master.GetWorldPosition(), slave.GetWorldPosition() + VecConeRand(slave.GetHeading() + 90, 0, 1,1))  )
				{
					
					masterSequencePart.animation			= 'high_standing_determined_gesture_preparing_horse1b';	
					masterSequencePart.finalPosition		= slave.GetWorldPosition() + VecConeRand(slave.GetHeading() - 90, 0, 0.82,0.82) + VecConeRand(slave.GetHeading(), 0, 0.5,0.5);				
					masterSequencePart.finalHeading			= rot.Yaw + 95;
				}
				else
				{
					
					masterSequencePart.animation			= 'high_standing_determined_gesture_preparing_horse2';	
					masterSequencePart.finalPosition		= slave.GetWorldPosition() + VecConeRand(slave.GetHeading() + 90, 0, 0.82,0.82) + VecConeRand(slave.GetHeading(), 0, 0.3,0.3);				
					masterSequencePart.finalHeading			= rot.Yaw - 90;
				}
				
				masterSequencePart.syncType				= AMST_SyncBeginning;
				masterSequencePart.syncEventName		= 'SyncEvent';
				masterSequencePart.shouldSlide			= true;
				masterSequencePart.shouldRotate			= true;
				masterSequencePart.blendInTime			= 0.5f;
				masterSequencePart.blendOutTime			= 1.2f;
				masterSequencePart.sequenceIndex		= 0;
				
				masterDef.parts.PushBack( masterSequencePart );
				masterDef.entity						= master;
				masterDef.manualSlotName				= 'GAMEPLAY_SLOT';
				masterDef.freezeAtEnd					= false;
				
				
				slaveSequencePart.animation				= 'horse_breathing_slow';			
				slaveSequencePart.syncType				= AMST_SyncBeginning;
				slaveSequencePart.syncEventName			= 'SyncEvent';
				slaveSequencePart.shouldSlide			= false;
				slaveSequencePart.blendInTime			= 0.5f;
				slaveSequencePart.blendOutTime			= 0.5f;
				slaveSequencePart.sequenceIndex			= 0;
				
				slaveDef.parts.PushBack( slaveSequencePart );
				slaveDef.entity							= slave;
				slaveDef.manualSlotName					= 'EXP_SLOT';
				slaveDef.freezeAtEnd					= false;
				
				break;
			}	
			
			default : 
			{
				syncInstances.Remove( syncInstance );
				return false;
			}
			
		}
		
		sequenceIndex = syncInstance.RegisterMaster( masterDef );
		if( sequenceIndex == -1 )
		{
			syncInstances.Remove( syncInstance );
			return false;
		}
		
		
		actorMaster = (CActor)master;
		actorSlave = (CActor)slave;
		
		if(actorMaster)
		{
			actorMaster.SignalGameplayEventParamInt( 'SetupSyncInstance', instanceIndex );
			actorMaster.SignalGameplayEventParamInt( 'SetupSequenceIndex', sequenceIndex );
			if ( finisherAnim )
				actorMaster.SignalGameplayEvent( 'PlayFinisherSyncedAnim' );
			else
				actorMaster.SignalGameplayEvent( 'PlaySyncedAnim' );
			
		}
		
		sequenceIndex = syncInstance.RegisterSlave( slaveDef );
		if( sequenceIndex == -1 )
		{
			syncInstances.Remove( syncInstance );
			return false;
		}
		
		
		if(actorSlave)
		{
			if( syncAction == 'Throat' )
				actorSlave.SignalGameplayEventParamCName( 'SetupEndEvent', 'CriticalState' );
				
			actorSlave.SignalGameplayEventParamInt( 'SetupSyncInstance', instanceIndex );
			actorSlave.SignalGameplayEventParamInt( 'SetupSequenceIndex', sequenceIndex );
			if ( finisherAnim )
				actorSlave.SignalGameplayEvent( 'PlayFinisherSyncedAnim' );
			else
				actorSlave.SignalGameplayEvent( 'PlaySyncedAnim' );
		}
		
		
		
		return true;
	}

	private function GetFinisherSynAnimName( optional nonLethalFinisher : bool ) : name
	{
		var syncAnimName 	: name;
		var syncAnimsNames	: array<name>;
		var size 			: int;
		var i 				: int;
		
		if( nonLethalFinisher )
		{
			if ( thePlayer.GetCombatIdleStance() <= 0.f )
			{
				if( thePlayer.GetTarget().HasAbility( 'ForceHiltFinisher' ) )
				{
					return 'man_finisher_hilt_01_lp';
				}
				else if( thePlayer.GetTarget().HasAbility( 'ForceHeadbuttFinisher' ) )
				{
					return 'man_finisher_head_01_lp';
				}
				else
				{
					syncAnimsNames.PushBack( 'man_finisher_hilt_01_lp' );
					syncAnimsNames.PushBack( 'man_finisher_head_01_lp' );
				}
			}
			else
			{
				if( thePlayer.GetTarget().HasAbility( 'ForceHiltFinisher' ) )
				{
					return 'man_finisher_hilt_01_rp';
				}
				else if( thePlayer.GetTarget().HasAbility( 'ForceHeadbuttFinisher' ) )
				{
					return 'man_finisher_head_01_rp';
				}
				else
				{
					syncAnimsNames.PushBack( 'man_finisher_hilt_01_rp' );
					syncAnimsNames.PushBack( 'man_finisher_head_01_rp' );
				}
			}
			
			return syncAnimsNames[ RandRange( syncAnimsNames.Size(),  0 ) ];
		}
		
		if ( thePlayer.forceFinisher && thePlayer.forceFinisherAnimName != '' )
			return thePlayer.forceFinisherAnimName;
		
		if ( thePlayer.GetCombatIdleStance() <= 0.f )
		{
			syncAnimsNames.PushBack( 'man_finisher_02_lp' );
			syncAnimsNames.PushBack( 'man_finisher_02_lp' );
			syncAnimsNames.PushBack( 'man_finisher_02_lp' );
			syncAnimsNames.PushBack( 'man_finisher_02_lp' );
			syncAnimsNames.PushBack( 'man_finisher_04_lp' );
			syncAnimsNames.PushBack( 'man_finisher_06_lp' );
			syncAnimsNames.PushBack( 'man_finisher_07_lp' );
			syncAnimsNames.PushBack( 'man_finisher_07_lp' );
			syncAnimsNames.PushBack( 'man_finisher_08_lp' );
			syncAnimsNames.PushBack( 'man_finisher_08_lp' );
			size = dlcFinishersLeftSide.Size();
			for( i = 0; i < size; i += 1 )
			{
				syncAnimsNames.PushBack( dlcFinishersLeftSide[i].finisherAnimName );
				if(dlcFinishersLeftSide[i].finisherAnimName == 'man_finisher_dlc_legs_lp')
				{
					syncAnimsNames.PushBack( dlcFinishersLeftSide[i].finisherAnimName );
					syncAnimsNames.PushBack( dlcFinishersLeftSide[i].finisherAnimName );
					syncAnimsNames.PushBack( dlcFinishersLeftSide[i].finisherAnimName );
				}
			}			
		}
		else
		{
			syncAnimsNames.PushBack( 'man_finisher_01_rp' );
			syncAnimsNames.PushBack( 'man_finisher_01_rp' );
			syncAnimsNames.PushBack( 'man_finisher_01_rp' );
			syncAnimsNames.PushBack( 'man_finisher_01_rp' );
			syncAnimsNames.PushBack( 'man_finisher_03_rp' );
			syncAnimsNames.PushBack( 'man_finisher_05_rp' );
			size = dlcFinishersRightSide.Size();
			for( i = 0; i < size; i += 1 )
			{
				syncAnimsNames.PushBack( dlcFinishersRightSide[i].finisherAnimName );
				if(dlcFinishersRightSide[i].finisherAnimName == 'man_finisher_dlc_legs_rp')
				{
					syncAnimsNames.PushBack( dlcFinishersRightSide[i].finisherAnimName );
					syncAnimsNames.PushBack( dlcFinishersRightSide[i].finisherAnimName );
					syncAnimsNames.PushBack( dlcFinishersRightSide[i].finisherAnimName );
				}
				else if(dlcFinishersRightSide[i].finisherAnimName == 'man_finisher_dlc_head_rp')
				{
					syncAnimsNames.PushBack( dlcFinishersRightSide[i].finisherAnimName );
					syncAnimsNames.PushBack( dlcFinishersRightSide[i].finisherAnimName );
				}
				else if(dlcFinishersRightSide[i].finisherAnimName == 'man_finisher_dlc_neck_rp')
				{
					syncAnimsNames.PushBack( dlcFinishersRightSide[i].finisherAnimName );
					syncAnimsNames.PushBack( dlcFinishersRightSide[i].finisherAnimName );
				}
			}
		}
		return syncAnimsNames[ RandRange( syncAnimsNames.Size(),  0 ) ];
	}
	
	private function GetSlaveAnimName( masterAnimName : name ) : name
	{
		if( masterAnimName == 'man_finisher_hilt_01_lp' || masterAnimName == 'man_finisher_hilt_01_rp' )
		{
			return 'man_finisher_hilt_01_reaction';
		}
		else
		{
			return 'man_finisher_head_01_reaction';
		}
	}
		
	private function PlayPhaseChangeCameraAnimation( animationName : name )
	{
		var camera 			: CCustomCamera = theGame.GetGameCamera();
		var moveTargets		: array<CActor>;
		var animation		: SCameraAnimationDefinition;
		var player			: CR4Player = thePlayer;
		
		camera.StopAnimation('camera_shake_hit_lvl3_1' );
		
		animation.animation = animationName;
		animation.priority = CAP_Highest;
		animation.blendIn = 0.5f;	
		animation.blendOut = 1.5f;	
		animation.weight = 1.f;
		animation.speed	= 1.0f;
		animation.reset = true;
		
		camera.PlayAnimation( animation );
		
		thePlayer.EnableManualCameraControl( false, 'Finisher' );
	}

	var cameraAnimName					: name;
	public function GetFinisherCameraAnimName() : name
	{
		return cameraAnimName;
	}
	
	private function SelectDLCFinisherCameraAnimName( finisher : CR4FinisherDLC, finisherAngle : int ) : name
	{
		if ( finisherAngle >= 3 )
		{
			return finisher.rightCameraAnimName;
		}
		else if  ( finisherAngle >= 2 )
		{
			return finisher.backCameraAnimName;
		}
		else if  ( finisherAngle >= 1 )
		{
			return finisher.leftCameraAnimName;
		}
		else
		{
			return finisher.frontCameraAnimName;
		}
	}
	
	private function GetDLCFinisherCameraAnimName( finisherAnimName : name, side : EFinisherSide, finisherAngle : int, out finisherCameraAnimName : name ) : bool
	{
		var size : int;
		var i    : int;
		var finisher : CR4FinisherDLC;

		if( side == FinisherLeft )
		{
			size = dlcFinishersLeftSide.Size();
			for( i = 0; i < size; i += 1 )
			{
				finisher = dlcFinishersLeftSide[i];
				if( finisher.finisherAnimName == finisherAnimName )
				{
					finisherCameraAnimName = SelectDLCFinisherCameraAnimName( finisher, finisherAngle );
					return true;
				}
			}
		}
		else if( side == FinisherRight )
		{
			size = dlcFinishersRightSide.Size();
			for( i = 0; i < size; i += 1 )
			{
				finisher = dlcFinishersRightSide[i];
				if( finisher.finisherAnimName == finisherAnimName )
				{
					finisherCameraAnimName = SelectDLCFinisherCameraAnimName( finisher, finisherAngle );
					return true;
				}
			}
		}
		return false;
	}
	
	private function ProcessFinisherCameraAnimName( finisherAnimName : name ) : name
	{
		var camera 	: CCustomCamera = theGame.GetGameCamera();
		var playerToCamHeading 				: float;
		var playerTocamAnimInitialHeading 	: float;
		var angleDiffs						: array<float>;
		var i 								: int;	
		var finisherCameraAnimName			: name;
		var checkDLCs						: bool = false;
		
		playerToCamHeading = VecHeading( camera.GetWorldPosition() - thePlayer.GetWorldPosition() ); 
		playerTocamAnimInitialHeading = thePlayer.GetHeading();
		
		for ( i = 0; i < 4; i += 1 )
		{
			angleDiffs.PushBack( AbsF( AngleDistance( playerToCamHeading, playerTocamAnimInitialHeading ) ) );
			playerTocamAnimInitialHeading += 90.f;
		}
		
		i = ArrayFindMinF( angleDiffs );	
		
		if ( thePlayer.GetCombatIdleStance() <= 0.f )
		{
			if ( i >= 3 )
			{
				switch ( finisherAnimName )
				{
					case 'man_finisher_02_lp':	finisherCameraAnimName = 'man_finisher_02_lp_camera_right'; break;
					case 'man_finisher_04_lp':	finisherCameraAnimName ='man_finisher_04_lp_camera_right'; break;
					case 'man_finisher_06_lp':	finisherCameraAnimName = 'man_finisher_06_lp_camera_right'; break;
					case 'man_finisher_07_lp':	finisherCameraAnimName = 'man_finisher_07_lp_camera_right'; break;
					case 'man_finisher_08_lp':	finisherCameraAnimName = 'man_finisher_08_lp_camera_right'; break;
					default : finisherCameraAnimName = 'man_finisher_02_lp_camera_right'; checkDLCs = true; break;
				}
			}
			else if  ( i >= 2 )
			{
				switch ( finisherAnimName )
				{
					case 'man_finisher_02_lp':	finisherCameraAnimName = 'man_finisher_02_lp_camera_back'; break;
					case 'man_finisher_04_lp':	finisherCameraAnimName = 'man_finisher_04_lp_camera_back'; break;
					case 'man_finisher_06_lp':	finisherCameraAnimName = 'man_finisher_06_lp_camera_back'; break;
					case 'man_finisher_07_lp':	finisherCameraAnimName = 'man_finisher_07_lp_camera_back'; break;
					case 'man_finisher_08_lp':	finisherCameraAnimName = 'man_finisher_08_lp_camera_back'; break;
					default : finisherCameraAnimName = 'man_finisher_02_lp_camera_back'; checkDLCs = true; break;
				}
			}
			else if  ( i >= 1 )
			{
				switch ( finisherAnimName )
				{
					case 'man_finisher_02_lp':	finisherCameraAnimName = 'man_finisher_02_lp_camera_left'; break;
					case 'man_finisher_04_lp':	finisherCameraAnimName = 'man_finisher_04_lp_camera_left'; break;
					case 'man_finisher_06_lp':	finisherCameraAnimName = 'man_finisher_06_lp_camera_left'; break;
					case 'man_finisher_07_lp':	finisherCameraAnimName = 'man_finisher_07_lp_camera_left'; break;
					case 'man_finisher_08_lp':	finisherCameraAnimName = 'man_finisher_08_lp_camera_left'; break;
					default : finisherCameraAnimName = 'man_finisher_02_lp_camera_left'; checkDLCs = true; break;
				}
			}
			else
			{
				switch ( finisherAnimName )
				{
					case 'man_finisher_02_lp':	finisherCameraAnimName = 'man_finisher_02_lp_camera_front'; break;
					case 'man_finisher_04_lp':	finisherCameraAnimName = 'man_finisher_04_lp_camera_front'; break;
					case 'man_finisher_06_lp':	finisherCameraAnimName = 'man_finisher_06_lp_camera_front'; break;
					case 'man_finisher_07_lp':	finisherCameraAnimName = 'man_finisher_07_lp_camera_front'; break;
					case 'man_finisher_08_lp':	finisherCameraAnimName = 'man_finisher_08_lp_camera_front'; break;
					default : finisherCameraAnimName = 'man_finisher_02_lp_camera_front'; checkDLCs = true; break;
				}
			}
			if( checkDLCs )
			{
				GetDLCFinisherCameraAnimName( finisherAnimName, FinisherLeft, i, finisherCameraAnimName ); 
			}
		}
		else
		{
			if ( i >= 3 )
			{
				switch ( finisherAnimName )
				{
					case 'man_finisher_01_rp':	finisherCameraAnimName = 'man_finisher_01_rp_camera_right'; break;
					case 'man_finisher_03_rp':	finisherCameraAnimName = 'man_finisher_03_rp_camera_right'; break;
					case 'man_finisher_05_rp':	finisherCameraAnimName = 'man_finisher_05_rp_camera_right'; break;
					default : finisherCameraAnimName = 'man_finisher_01_rp_camera_right'; checkDLCs = true; break;
				}
			}
			else if  ( i >= 2 )
			{
				switch ( finisherAnimName )
				{
					case 'man_finisher_01_rp':	finisherCameraAnimName = 'man_finisher_01_rp_camera_back'; break;
					case 'man_finisher_03_rp':	finisherCameraAnimName = 'man_finisher_03_rp_camera_back'; break;
					case 'man_finisher_05_rp':	finisherCameraAnimName = 'man_finisher_05_rp_camera_back'; break;
					default : finisherCameraAnimName = 'man_finisher_01_rp_camera_back'; checkDLCs = true; break;
				}
			}
			else if  ( i >= 1 )
			{
				switch ( finisherAnimName )
				{
					case 'man_finisher_01_rp':	finisherCameraAnimName = 'man_finisher_01_rp_camera_left'; break;
					case 'man_finisher_03_rp':	finisherCameraAnimName = 'man_finisher_03_rp_camera_left'; break;
					case 'man_finisher_05_rp':	finisherCameraAnimName = 'man_finisher_05_rp_camera_left'; break;
					default : finisherCameraAnimName = 'man_finisher_01_rp_camera_left'; checkDLCs = true; break;
				}
			}
			else
			{
				switch ( finisherAnimName )
				{
					case 'man_finisher_01_rp':	finisherCameraAnimName = 'man_finisher_01_rp_camera_front'; break;
					case 'man_finisher_03_rp':	finisherCameraAnimName = 'man_finisher_03_rp_camera_front'; break;
					case 'man_finisher_05_rp':	finisherCameraAnimName = 'man_finisher_05_rp_camera_front'; break;
					default : finisherCameraAnimName = 'man_finisher_01_rp_camera_front'; checkDLCs = true; break;
				}
			}
			
			if( checkDLCs )
			{
				GetDLCFinisherCameraAnimName( finisherAnimName, FinisherRight, i, finisherCameraAnimName ); 
			}
		}	
		
		return finisherCameraAnimName;
	}
	
	private function ProcessDettlaffFinisherCamera() 
	{
		var camera 	: CCustomCamera = theGame.GetGameCamera();
		var animation : SCameraAnimationDefinition;
		var playerToCamHeading 				: float;
		var playerTocamAnimInitialHeading 	: float;
		var angleDiffs						: array<float>;
		var i 								: int;	
		var finisherCameraAnimName			: name;
		var checkDLCs						: bool = false;
		
		playerToCamHeading = VecHeading( camera.GetWorldPosition() - thePlayer.GetWorldPosition() ); 
		playerTocamAnimInitialHeading = thePlayer.GetHeading();
		
		for ( i = 0; i < 4; i += 1 )
		{
			angleDiffs.PushBack( AbsF( AngleDistance( playerToCamHeading, playerTocamAnimInitialHeading ) ) );
			playerTocamAnimInitialHeading += 90.f;
		}
		
		i = ArrayFindMinF( angleDiffs );	
		
		if ( i >= 3 )
		{
			finisherCameraAnimName = 'man_finisher_dlc2_dettlaff_cut_torso_rp_camera_left';
		}
		else if( i >= 2 )
		{
			finisherCameraAnimName = 'man_finisher_dlc2_dettlaff_cut_torso_rp_camera_front';
		}
		else if( i >= 1 )
		{
			finisherCameraAnimName = 'man_finisher_dlc2_dettlaff_cut_torso_rp_camera_right';
		}
		else
		{
			finisherCameraAnimName = 'man_finisher_dlc2_dettlaff_cut_torso_rp_camera_back';
		}
			
		animation.animation = finisherCameraAnimName;
		animation.priority = CAP_Highest;
		animation.blendIn = 0.5f;
		animation.blendOut = 1.f;
		animation.weight = 1.0f;
		animation.speed	= 1.0f;
		animation.reset = false;
		
		camera.PlayAnimation( animation );
		
	}
	
	event OnRemoveFinisherCameraAnimation()
	{
		var camera 	: CCustomCamera = theGame.GetGameCamera();
		camera.StopAnimation( cameraAnimName );
		thePlayer.EnableManualCameraControl( true, 'Finisher' );
	}

	public function BreakSyncIfPossible( entity : CEntity) : bool
	{
		var size : int = syncInstances.Size();
		var i : int;
		var result : bool = false;
		
		for( i = 0; i < size; i += 1 )
		{
			if ( syncInstances[i].BreakIfPossible( entity ) )
			{
				result = true;
			}
		}
		
		return result;
	}
	
	private function GetActorPosition( ent : CEntity ) : Vector
	{
		var pos 			: Vector;
		var actor			: CActor;
		var torsoBoneIndex	: int;
	
		pos = ent.GetWorldPosition();
		actor = (CActor)ent;
		if ( actor )
		{
			torsoBoneIndex = actor.GetTorsoBoneIndex();
			if ( torsoBoneIndex != -1 )
			{
				pos = MatrixGetTranslation( actor.GetBoneWorldMatrixByIndex( torsoBoneIndex ) );
			}
			else
			{
				pos = actor.GetWorldPosition();
			}
		}
		
		return pos;	
	}
	
	public function AddDlcFinisherLeftSide( finisher: CR4FinisherDLC ): void
	{
		dlcFinishersLeftSide.PushBack( finisher );
	}
	
	public function RemoveDlcFinisherLeftSide( finisher: CR4FinisherDLC ): void
	{
		dlcFinishersLeftSide.Remove( finisher );
	}
	
	public function AddDlcFinisherRightSide( finisher: CR4FinisherDLC ): void
	{
		dlcFinishersRightSide.PushBack( finisher );
	}
	
	public function RemoveDlcFinisherRightSide( finisher: CR4FinisherDLC ): void
	{
		dlcFinishersRightSide.Remove( finisher );
	}
}

state Idle in W3SyncAnimationManager
{
}

state Active in W3SyncAnimationManager
{
	event OnEnterState( prevStateName : name )
	{
		super.OnEnterState( prevStateName );
		
		Run();
	}
	
	event OnLeaveState( prevStateName : name )
	{
		super.OnLeaveState( prevStateName );
		
		parent.masterEntity.OnSyncAnimEnd();
		parent.slaveEntity.OnSyncAnimEnd();
		
		
		thePlayer.UnblockAction(EIAB_Interactions, 'SyncManager' );
		thePlayer.UnblockAction(EIAB_FastTravel, 'SyncManager' );
		thePlayer.BlockAllActions( 'BTTaskPlaySyncAnim', false );
		thePlayer.SetImmortalityMode( AIM_None, AIC_SyncedAnim );
		
		if ( parent.syncActionName == 'BruxaKnockDownFinisher' )
		{
			((CNewNPC)parent.slaveEntity).CriticalEffectAnimationInterrupted( 'SyncAnim' );
			((CNewNPC)parent.slaveEntity).RemoveBuffImmunity( EET_Knockdown, 'SyncAnim' );
			((CNewNPC)parent.slaveEntity).RemoveBuffImmunity( EET_HeavyKnockdown, 'SyncAnim' );
			((CNewNPC)parent.slaveEntity).RemoveBuffImmunity( EET_KnockdownTypeApplicator, 'SyncAnim' );
			((CNewNPC)parent.slaveEntity).SetUnstoppable( false );
		}
	}
	
	entry function Run()
	{
		var size : int = parent.syncInstances.Size();
		var i : int;
		
		while( size > 0 )
		{
			for( i = size - 1; i >= 0; i -= 1 )
			{
				parent.syncInstances[i].Update( theTimer.timeDelta );
				
				if( parent.syncInstances[i].HasEnded() )
				{
					parent.syncInstances.Erase( i );
				}
			}
			
			SleepOneFrame();
			size = parent.syncInstances.Size();
		}
		
		parent.PopState( true );
	}
}
function PlayCustomCamAnim( val : name, blendIn : float, blendOut : float, weight : float, speed : float, reset : bool, optional priority : ECameraAnimPriority )
{
	var camera 	: CCustomCamera = theGame.GetGameCamera();
	var animation : SCameraAnimationDefinition;
	
	

	animation.animation = val;
	
	animation.blendIn = blendIn;
	animation.blendOut = blendOut;
	animation.weight = weight;
	animation.speed	= speed;
	animation.reset = reset;
	animation.priority = priority;
	camera.PlayAnimation( animation );
}



exec function PlayCamAnim( optional i : int )
{
	var camera 	: CCustomCamera = theGame.GetGameCamera();
	var cameraAnimName : name;
	var animation : SCameraAnimationDefinition;
	
	
	if ( i >= 3 )
		cameraAnimName = 'man_finisher_01_rp_camera_right';	
	else if  ( i >= 2 )
		cameraAnimName = 'man_finisher_01_rp_camera_back';
	else if  ( i >= 1 )
		cameraAnimName = 'man_finisher_01_rp_camera_left';	
	else
		cameraAnimName = 'man_finisher_01_rp_camera_front';
		
	animation.animation = cameraAnimName;
	animation.priority = CAP_Highest;
	animation.blendIn = 0.5f;
	animation.blendOut = 3.f;
	animation.weight = 1.f;
	animation.speed	= 1.0f;
	animation.reset = true;
	
	camera.PlayAnimation( animation );
}
