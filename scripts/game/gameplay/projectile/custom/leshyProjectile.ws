/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/
class W3LeshyRootProjectile extends CProjectileTrajectory
	
	private var action 				: W3Action_Attack;
	
		var victim 			: CGameplayEntity;
		
				theGame.GetWorld().StaticTrace( projPos + Vector(0,0,3), projPos - Vector(0,0,3), projPos, normal );
				GCameraShake(1.0, true, fxEntity.GetWorldPosition(), 30.0f);
	{
		var attributeName 	: name;
		var victims 		: array<CGameplayEntity>;
		var rootDmg 		: float;
		var i 				: int;
		
		attributeName = GetBasicAttackDamageAttributeName(theGame.params.ATTACK_NAME_HEAVY, theGame.params.DAMAGE_NAME_PHYSICAL);
		rootDmg = CalculateAttributeValue(((CActor)caster).GetAttributeValue(attributeName));
		
		
		action = new W3Action_Attack in theGame.damageMgr;
		
		
		FindGameplayEntitiesInRange( victims, fxEntity, 2, 99, , FLAG_OnlyAliveActors );
		
		if ( victims.Size() > 0 )
		{
			for ( i = 0 ; i < victims.Size() ; i += 1 )
			{
				if ( !((CActor)victims[i]).IsCurrentlyDodging() )
				{
					
					action.Init( (CGameplayEntity)caster, victims[i], NULL, ((CGameplayEntity)caster).GetInventory().GetItemFromSlot( 'r_weapon' ), 'attack_heavy', ((CGameplayEntity)caster).GetName(), EHRT_Heavy, false, true, 'attack_heavy', AST_Jab, ASD_DownUp, false, false, false, true );
					theGame.damageMgr.ProcessAction( action );
					
					
					victims[i].OnRootHit();
				}
			}
		}
		
		delete action;
	}
		var normal : Vector;
		
			theGame.GetWorld().StaticTrace( projPos + Vector(0,0,3), projPos - Vector(0,0,3), projPos, normal );
			DelayDamage( 0.3 );
		var attributeName : name;
			attributeName = GetBasicAttackDamageAttributeName(theGame.params.ATTACK_NAME_LIGHT, theGame.params.DAMAGE_NAME_PHYSICAL);