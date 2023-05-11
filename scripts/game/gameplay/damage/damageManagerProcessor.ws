/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/





class W3DamageManagerProcessor extends CObject 
{
	
	private var playerAttacker				: CR4Player;				
	private var playerVictim				: CR4Player;				
	private var action						: W3DamageAction;
	private var attackAction				: W3Action_Attack;			
	private var weaponId					: SItemUniqueId;			
	private var actorVictim 				: CActor;					
	private var actorAttacker				: CActor;					
	private var dm 							: CDefinitionsManagerAccessor;
	private var attackerMonsterCategory		: EMonsterCategory;
	private var victimMonsterCategory		: EMonsterCategory;
	private var victimCanBeHitByFists		: bool;
	
	
	public function ProcessAction(act : W3DamageAction)
	{
		var wasAlive, validDamage, isFrozen, autoFinishersEnabled : bool;
		var focusDrain : float;
		var npc : CNewNPC;
		var buffs : array<EEffectType>;
		var arrStr : array<string>;
		var aerondight	: W3Effect_Aerondight;
		var trailFxName : name;
		
		
		var swordEntity : CWitcherSword;
		var swordItem : SItemUniqueId;
		var bloodType : EBloodType;
		
			
		wasAlive = act.victim.IsAlive();		
		npc = (CNewNPC)act.victim;
		
		
 		InitializeActionVars(act);
 		
 		
		if( ((CNewNPC)actorAttacker).IsHorse() && actorVictim.HasAbility('mon_werewolf_base'))
		{
			action.SetHitReactionType(EHRT_Light);
		}
		
 		
 		
		
 		if(playerVictim && attackAction && attackAction.IsActionMelee() && !attackAction.CanBeParried() && attackAction.IsParried())
 		{
			action.GetEffectTypes(buffs);
			
			if(!buffs.Contains(EET_Knockdown) && !buffs.Contains(EET_HeavyKnockdown))
			{
				
				action.SetParryStagger();
				
				
				action.SetProcessBuffsIfNoDamage(true);
				
				
				action.AddEffectInfo(EET_LongStagger);
				
				
				action.SetHitAnimationPlayType(EAHA_ForceNo);
				action.SetCanPlayHitParticle(false);
				
				
				action.RemoveBuffsByType(EET_Bleeding);
				
				
				action.RemoveBuffsByType(EET_Bleeding1);
				action.RemoveBuffsByType(EET_Bleeding2);
				action.RemoveBuffsByType(EET_Bleeding3);
				
			}
 		}
 		
 		
 		if(actorAttacker && playerVictim && ((W3PlayerWitcher)playerVictim) && GetWitcherPlayer().IsAnyQuenActive())
			FactsAdd("player_had_quen");
		
		
		ProcessPreHitModifications();

		
		ProcessActionQuest(act);
		
		
		isFrozen = (actorVictim && actorVictim.HasBuff(EET_Frozen));
		
		
		validDamage = ProcessActionDamage();
		
		
		if(wasAlive && !action.victim.IsAlive())
		{
			arrStr.PushBack(action.victim.GetDisplayName());
			if(npc && npc.WillBeUnconscious())
			{
				theGame.witcherLog.AddCombatMessage(GetLocStringByKeyExtWithParams("hud_combat_log_unconscious", , , arrStr), NULL, action.victim);
			}
			else if(action.attacker && action.attacker.GetDisplayName() != "")
			{
				arrStr.PushBack(action.attacker.GetDisplayName());
				theGame.witcherLog.AddCombatMessage(GetLocStringByKeyExtWithParams("hud_combat_log_killed", , , arrStr), action.attacker, action.victim);
			}
			else
			{
				theGame.witcherLog.AddCombatMessage(GetLocStringByKeyExtWithParams("hud_combat_log_dies", , , arrStr), NULL, action.victim);
			}
		}
		
		if( wasAlive && action.DealsAnyDamage() )
		{
			((CActor) action.attacker).SignalGameplayEventParamFloat(  'CausesDamage', MaxF( action.processedDmg.vitalityDamage, action.processedDmg.essenceDamage ) );
		}
		
		
		ProcessActionReaction(isFrozen, wasAlive);
		
		
		if(action.DealsAnyDamage() || action.ProcessBuffsIfNoDamage())
			ProcessActionBuffs();
		
		
		if(theGame.CanLog() && !validDamage && action.GetEffectsCount() == 0)
		{
			LogAssert(false, "W3DamageManagerProcessor.ProcessAction: action deals no damage and gives no buffs - investigate!");
			if ( theGame.CanLog() )
			{
				LogDMHits("*** Action has no valid damage and no valid buffs - investigate!", action);
			}
		}
		
		
		if( actorAttacker && wasAlive )
			actorAttacker.OnProcessActionPost(action);

		
		if(actorVictim == GetWitcherPlayer() && action.DealsAnyDamage() && !action.IsDoTDamage())
		{
			if(actorAttacker && attackAction)
			{
				if(actorAttacker.IsHeavyAttack( attackAction.GetAttackName() ))
					focusDrain = CalculateAttributeValue(thePlayer.GetAttributeValue('heavy_attack_focus_drain'));
				else if(actorAttacker.IsSuperHeavyAttack( attackAction.GetAttackName() ))
					focusDrain = CalculateAttributeValue(thePlayer.GetAttributeValue('super_heavy_attack_focus_drain'));
				else 
					focusDrain = CalculateAttributeValue(thePlayer.GetAttributeValue('light_attack_focus_drain')); 
			}
			else
			{
				
				focusDrain = CalculateAttributeValue(thePlayer.GetAttributeValue('light_attack_focus_drain')); 
			}
			
			
			if ( GetWitcherPlayer().CanUseSkill(S_Sword_s16) )
				focusDrain *= 1 - (CalculateAttributeValue( thePlayer.GetSkillAttributeValue(S_Sword_s16, 'focus_drain_reduction', false, true) ) * thePlayer.GetSkillLevel(S_Sword_s16));
				
			thePlayer.DrainFocus(focusDrain);
		}
		
		
		if(actorAttacker == GetWitcherPlayer() && actorVictim && !actorVictim.IsAlive() && (action.IsActionMelee() || action.GetBuffSourceName() == "Kill"))
		{
			autoFinishersEnabled = theGame.GetInGameConfigWrapper().GetVarValue('Gameplay', 'AutomaticFinishersEnabled');
			
			
			
			
			if(!autoFinishersEnabled || !thePlayer.GetFinisherVictim())
			{
				if(thePlayer.HasAbility('Runeword 10 _Stats', true))
					GetWitcherPlayer().Runeword10Triggerred();
				if(thePlayer.HasAbility('Runeword 12 _Stats', true))
					GetWitcherPlayer().Runeword12Triggerred();
			}
		}
		
		
		if(action.EndsQuen() && actorVictim)
		{
			actorVictim.FinishQuen(false);			
		}

		
		if(actorVictim == thePlayer && attackAction && attackAction.IsActionMelee() && (ShouldProcessTutorial('TutorialDodge') || ShouldProcessTutorial('TutorialCounter') || ShouldProcessTutorial('TutorialParry')) )
		{
			if(attackAction.IsCountered())
			{
				theGame.GetTutorialSystem().IncreaseCounters();
			}
			else if(attackAction.IsParried())
			{
				theGame.GetTutorialSystem().IncreaseParries();
			}
			
			if(attackAction.CanBeDodged() && !attackAction.WasDodged())
			{
				GameplayFactsAdd("tut_failed_dodge", 1, 1);
				GameplayFactsAdd("tut_failed_roll", 1, 1);
			}
		}
		
		if( playerAttacker && npc && action.IsActionMelee() && action.DealtDamage() && IsRequiredAttitudeBetween( playerAttacker, npc, true ))
		{		
			if(!npc.HasTag( 'AerondightIgnore' ))	
			{
				if( playerAttacker.inv.ItemHasTag( attackAction.GetWeaponId(), 'Aerondight' ) )
				{
					
					aerondight = (W3Effect_Aerondight)playerAttacker.GetBuff( EET_Aerondight );
					aerondight.IncreaseAerondightCharges( attackAction.GetAttackName() );
					
					
					if( aerondight.GetCurrentCount() == aerondight.GetMaxCount() )
					{
						switch( npc.GetBloodType() )
						{
							case BT_Red : 
								trailFxName = 'aerondight_blood_red';
								break;
								
							case BT_Yellow :
								trailFxName = 'aerondight_blood_yellow';
								break;
							
							case BT_Black : 
								trailFxName = 'aerondight_blood_black';
								break;
							
							case BT_Green :
								trailFxName = 'aerondight_blood_green';
								break;
						}
						
						playerAttacker.inv.GetItemEntityUnsafe( attackAction.GetWeaponId() ).PlayEffect( trailFxName );
					}
				}
			}
			
			
			if(!action.WasDodged() && !attackAction.IsParried() && !attackAction.IsCountered())
			{
				swordItem = GetWitcherPlayer().GetHeldSword();
				if(swordItem != GetInvalidUniqueId())
				{
					swordEntity = (CWitcherSword)thePlayer.GetInventory().GetItemEntityUnsafe( swordItem );	
					if(swordEntity)
					{
						bloodType = npc.GetBloodType();
						if(bloodType == BT_Red || bloodType == BT_Yellow)
						{
							swordEntity.PlayEffectSingle('weapon_blood');
						}
						else if (bloodType == BT_Black || npc.HasAbility('mon_kikimora_warrior') || npc.HasAbility('mon_kikimora_worker') || npc.HasAbility('mon_black_spider_base') || npc.HasAbility('mon_black_spider_ep2_base') )
						{
							swordEntity.PlayEffectSingle('weapon_blood_black');
						}
						else if (bloodType == BT_Green)
						{
							swordEntity.PlayEffectSingle('weapon_blood_green');
						}
					}
				}
			}
			
		}
	}
	
	
	private final function InitializeActionVars(act : W3DamageAction)
	{
		var tmpName : name;
		var tmpBool	: bool;
	
		action 				= act;
		playerAttacker 		= (CR4Player)action.attacker;
		playerVictim		= (CR4Player)action.victim;
		attackAction 		= (W3Action_Attack)action;		
		actorVictim 		= (CActor)action.victim;
		actorAttacker		= (CActor)action.attacker;
		dm 					= theGame.GetDefinitionsManager();
		
		if(attackAction)
			weaponId 		= attackAction.GetWeaponId();
			
		theGame.GetMonsterParamsForActor(actorVictim, victimMonsterCategory, tmpName, tmpBool, tmpBool, victimCanBeHitByFists);
		
		if(actorAttacker)
			theGame.GetMonsterParamsForActor(actorAttacker, attackerMonsterCategory, tmpName, tmpBool, tmpBool, tmpBool);
	}
	
	
	
	
	
	
	private function ProcessActionQuest(act : W3DamageAction)
	{
		var victimTags, attackerTags : array<name>;
		
		victimTags = action.victim.GetTags();
		
		if(action.attacker)
			attackerTags = action.attacker.GetTags();
		
		AddHitFacts( victimTags, attackerTags, "_weapon_hit" );
		
		
		if ((CGameplayEntity) action.victim) action.victim.OnWeaponHit(act);
	}
	
	
	
	
	
	private function ProcessActionDamage() : bool
	{
		var directDmgIndex, size, i : int;
		var dmgInfos : array< SRawDamage >;
		var immortalityMode : EActorImmortalityMode;
		var dmgValue : float;
		var anyDamageProcessed, fallingRaffard : bool;
		var victimHealthPercBeforeHit, frozenAdditionalDamage : float;		
		var powerMod : SAbilityAttributeValue;
		var witcher : W3PlayerWitcher;
		var canLog : bool;
		var immortalityChannels : array<EActorImmortalityChanel>;
		
		canLog = theGame.CanLog();
		
		
		action.SetAllProcessedDamageAs(0);
		size = action.GetDTs( dmgInfos );
		action.SetDealtFireDamage(false);		
		
		
		if(!actorVictim || (!actorVictim.UsesVitality() && !actorVictim.UsesEssence()) )
		{
			
			for(i=0; i<size; i+=1)
			{
				if(dmgInfos[i].dmgType == theGame.params.DAMAGE_NAME_FIRE && dmgInfos[i].dmgVal > 0)
				{
					action.victim.OnFireHit( (CGameplayEntity)action.causer );
					break;
				}
			}
			
			if ( !actorVictim.abilityManager )
				actorVictim.OnDeath(action);
			
			return false;
		}
		
		
		if(actorVictim.UsesVitality())
			victimHealthPercBeforeHit = actorVictim.GetStatPercents(BCS_Vitality);
		else
			victimHealthPercBeforeHit = actorVictim.GetStatPercents(BCS_Essence);
			
		
		if ( actorVictim && playerAttacker && victimMonsterCategory == MC_Specter && playerAttacker.HasBuff(EET_Mutagen28) && !actorVictim.HasAbility( 'ShadowFormActive' ) )
		{
			actorVictim.BlockAbility('ShadowForm', true);			
			actorVictim.BlockAbility('Flashstep', true);			
			actorVictim.BlockAbility('EssenceRegen', true);
			actorVictim.BlockAbility('Teleport', true);
			
			actorVictim.BlockAbility('Specter', true);			
		}
		

	
		
		ProcessDamageIncrease( dmgInfos );
					
		
		if ( canLog )
		{
			LogBeginning();
		}
			
		
		ProcessCriticalHitCheck();
		
		
		ProcessOnBeforeHitChecks();
		
		
		powerMod = GetAttackersPowerMod();

		
		anyDamageProcessed = false;
		directDmgIndex = -1;
		witcher = GetWitcherPlayer();
		size = dmgInfos.Size();			
		for( i = 0; i < size; i += 1 )
		{
			
			if(dmgInfos[i].dmgVal == 0)
				continue;
			
			if(dmgInfos[i].dmgType == theGame.params.DAMAGE_NAME_DIRECT)
			{
				directDmgIndex = i;
				continue;
			}
			
			
			if(dmgInfos[i].dmgType == theGame.params.DAMAGE_NAME_POISON && witcher == actorVictim && witcher.HasBuff(EET_GoldenOriole) && witcher.GetPotionBuffLevel(EET_GoldenOriole) == 3)
			{
				
				witcher.GainStat(BCS_Vitality, dmgInfos[i].dmgVal);
				
				
				if ( canLog )
				{
					LogDMHits("", action);
					LogDMHits("*** Player absorbs poison damage from level 3 Golden Oriole potion: " + dmgInfos[i].dmgVal, action);
				}
				
				
				dmgInfos[i].dmgVal = 0;
				
				continue;
			}
			
			
			if ( canLog )
			{
				LogDMHits("", action);
				LogDMHits("*** Incoming " + NoTrailZeros(dmgInfos[i].dmgVal) + " " + dmgInfos[i].dmgType + " damage", action);
				if(action.IsDoTDamage())
					LogDMHits("DoT's current dt = " + NoTrailZeros(action.GetDoTdt()) + ", estimated dps = " + NoTrailZeros(dmgInfos[i].dmgVal / action.GetDoTdt()), action);
			}
			
			
			anyDamageProcessed = true;
				
			
			dmgValue = MaxF(0, CalculateDamage(dmgInfos[i], powerMod));
		
			
			if( DamageHitsEssence(  dmgInfos[i].dmgType ) )		action.processedDmg.essenceDamage  += dmgValue;
			if( DamageHitsVitality( dmgInfos[i].dmgType ) )		action.processedDmg.vitalityDamage += dmgValue;
			if( DamageHitsMorale(   dmgInfos[i].dmgType ) )		action.processedDmg.moraleDamage   += dmgValue;
			if( DamageHitsStamina(  dmgInfos[i].dmgType ) )		action.processedDmg.staminaDamage  += dmgValue;
		}
		
		if(size == 0 && canLog)
		{
			LogDMHits("*** There is no incoming damage set (probably only buffs).", action);
		}
		
		if ( canLog )
		{
			LogDMHits("", action);
			LogDMHits("Processing block, parry, immortality, signs and other GLOBAL damage reductions...", action);		
		}
		
		
		if(actorVictim)
			actorVictim.ReduceDamage(action);
				
		
		if(directDmgIndex != -1)
		{
			anyDamageProcessed = true;
			
			
			immortalityChannels = actorVictim.GetImmortalityModeChannels(AIM_Invulnerable);
			fallingRaffard = immortalityChannels.Size() == 1 && immortalityChannels.Contains(AIC_WhiteRaffardsPotion) && action.GetBuffSourceName() == "FallingDamage";
			
			if(action.GetIgnoreImmortalityMode() || (!actorVictim.IsImmortal() && !actorVictim.IsInvulnerable() && !actorVictim.IsKnockedUnconscious()) || fallingRaffard)
			{
				action.processedDmg.vitalityDamage += dmgInfos[directDmgIndex].dmgVal;
				action.processedDmg.essenceDamage  += dmgInfos[directDmgIndex].dmgVal;
			}
			else if( actorVictim.IsInvulnerable() )
			{
				
			}
			else if( actorVictim.IsImmortal() )
			{
				
				action.processedDmg.vitalityDamage += MinF(dmgInfos[directDmgIndex].dmgVal, actorVictim.GetStat(BCS_Vitality)-1 );
				action.processedDmg.essenceDamage  += MinF(dmgInfos[directDmgIndex].dmgVal, actorVictim.GetStat(BCS_Essence)-1 );
			}
		}
		
		
		if( actorVictim.HasAbility( 'OneShotImmune' ) )
		{
			if( action.processedDmg.vitalityDamage >= actorVictim.GetStatMax( BCS_Vitality ) )
			{
				action.processedDmg.vitalityDamage = actorVictim.GetStatMax( BCS_Vitality ) - 1;
			}
			else if( action.processedDmg.essenceDamage >= actorVictim.GetStatMax( BCS_Essence ) )
			{
				action.processedDmg.essenceDamage = actorVictim.GetStatMax( BCS_Essence ) - 1;
			}
		}
		
		
		if(action.HasDealtFireDamage())
			action.victim.OnFireHit( (CGameplayEntity)action.causer );
			
		
		ProcessInstantKill();
			
		
		ProcessActionDamage_DealDamage();
		
		
		if(playerAttacker && witcher)
			witcher.SetRecentlyCountered(false);
		
		
		if( attackAction && !attackAction.IsCountered() && playerVictim && attackAction.IsActionMelee())
			theGame.GetGamerProfile().ResetStat(ES_CounterattackChain);
		
		
		ProcessActionDamage_ReduceDurability();
		
		
		if(playerAttacker && actorVictim)
		{
			
			if( playerAttacker.inv.ItemHasAnyActiveOilApplied(weaponId) ) 
			{			
				if( !playerAttacker.CanUseSkill(S_Alchemy_s06) || playerAttacker.GetSkillLevel(S_Alchemy_s06) < 3 )
				{
					playerAttacker.ReduceAllOilsAmmo( weaponId );
					
					if(ShouldProcessTutorial('TutorialOilAmmo'))
					{
						FactsAdd("tut_used_oil_in_combat");
					}
				}
				
				
				if( !playerAttacker.inv.ItemHasActiveOilApplied( weaponId, victimMonsterCategory ) )
				{
					thePlayer.ShouldAutoApplyOilImmediately( actorVictim );
				}
			}
			else
			{
				thePlayer.ShouldAutoApplyOilImmediately( actorVictim );
			}
			
			
			
			playerAttacker.inv.ReduceItemRepairObjectBonusCharge(weaponId);
		}
		
		
		if(actorVictim && actorAttacker && !action.GetCannotReturnDamage() )
			ProcessActionReturnedDamage();	
		
		return anyDamageProcessed;
	}
	
	
	private function ProcessInstantKill()
	{
		var instantKill, focus : float;

		if( !actorVictim || !actorAttacker || actorVictim.IsImmuneToInstantKill() )
		{
			return;
		}
		
		
		if( action.WasDodged() || ( attackAction && ( attackAction.IsParried() || attackAction.IsCountered() ) ) )
		{
			return;
		}
		
		if( actorAttacker.HasAbility( 'ForceInstantKill' ) && actorVictim != thePlayer )
		{
			action.SetInstantKill();
		}
		
		
		if( actorAttacker == thePlayer && !action.GetIgnoreInstantKillCooldown() )
		{
			if( !GameTimeDTAtLeastRealSecs( thePlayer.lastInstantKillTime, theGame.GetGameTime(), theGame.params.INSTANT_KILL_INTERNAL_PLAYER_COOLDOWN ) )
			{
				return;
			}
		}
	
		
		if( !action.GetInstantKill() )
		{
			
			instantKill = CalculateAttributeValue( actorAttacker.GetInventory().GetItemAttributeValue( weaponId, 'instant_kill_chance' ) );
			
			
			if( ( action.IsActionMelee() || action.IsActionRanged() ) && playerAttacker && action.DealsAnyDamage() && thePlayer.CanUseSkill( S_Sword_s03 ) && !playerAttacker.inv.IsItemFists( weaponId ) )
			{
				focus = thePlayer.GetStat( BCS_Focus );
				
				if( focus >= 1 )
				{
					instantKill += focus * CalculateAttributeValue( thePlayer.GetSkillAttributeValue( S_Sword_s03, 'instant_kill_chance', false, true ) ) * thePlayer.GetSkillLevel( S_Sword_s03 );
				}
			}
		}
		
		
		if( action.GetInstantKill() || ( RandF() < instantKill ) )
		{
			if( theGame.CanLog() )
			{
				if( action.GetInstantKill() )
				{
					instantKill = 1.f;
				}
				LogDMHits( "Instant kill!! (" + NoTrailZeros( instantKill * 100 ) + "% chance", action );
			}
		
			action.processedDmg.vitalityDamage += actorVictim.GetStat( BCS_Vitality );
			action.processedDmg.essenceDamage += actorVictim.GetStat( BCS_Essence );
			action.SetCriticalHit();	
			action.SetInstantKillFloater();			
			
			
			if( playerAttacker )
			{
				thePlayer.SetLastInstantKillTime( theGame.GetGameTime() );
				theSound.SoundEvent( 'cmb_play_deadly_hit' );
				theGame.SetTimeScale( 0.2, theGame.GetTimescaleSource( ETS_InstantKill ), theGame.GetTimescalePriority( ETS_InstantKill ), true, true );
				thePlayer.AddTimer( 'RemoveInstantKillSloMo', 0.2 );
			}			
		}
	}
	
	
	private function ProcessOnBeforeHitChecks()
	{
		var effectAbilityName, monsterBonusType : name;
		var effectType : EEffectType;
		var null, monsterBonusVal : SAbilityAttributeValue;
		var oilLevel, skillLevel, i : int;
		var baseChance, perOilLevelChance, chance : float;
		var buffs : array<name>;
	
		
		if( playerAttacker && actorVictim && attackAction && attackAction.IsActionMelee() && playerAttacker.CanUseSkill(S_Alchemy_s12) && playerAttacker.inv.ItemHasActiveOilApplied( weaponId, victimMonsterCategory ) )
		{
			
			monsterBonusType = MonsterCategoryToAttackPowerBonus(victimMonsterCategory);
			monsterBonusVal = playerAttacker.inv.GetItemAttributeValue(weaponId, monsterBonusType);
		
			if(monsterBonusVal != null)
			{
				
				oilLevel = (int)CalculateAttributeValue(playerAttacker.inv.GetItemAttributeValue(weaponId, 'level')) - 1;				
				skillLevel = playerAttacker.GetSkillLevel(S_Alchemy_s12);
				baseChance = CalculateAttributeValue(playerAttacker.GetSkillAttributeValue(S_Alchemy_s12, 'skill_chance', false, true));
				perOilLevelChance = CalculateAttributeValue(playerAttacker.GetSkillAttributeValue(S_Alchemy_s12, 'oil_level_chance', false, true));						
				chance = baseChance * skillLevel + perOilLevelChance * oilLevel;
				
				
				if(RandF() < chance)
				{
					
					dm.GetContainedAbilities(playerAttacker.GetSkillAbilityName(S_Alchemy_s12), buffs);
					for(i=0; i<buffs.Size(); i+=1)
					{
						EffectNameToType(buffs[i], effectType, effectAbilityName);
						action.AddEffectInfo(effectType, , , effectAbilityName);
					}
				}
			}
		}
	}
	
	
	private function ProcessCriticalHitCheck()
	{
		var critChance, critDamageBonus : float;
		var	canLog, meleeOrRanged, redWolfSet, isLightAttack, isHeavyAttack, mutation2 : bool;
		var arrStr : array<string>;
		var samum : CBaseGameplayEffect;
		var signPower, min, max : SAbilityAttributeValue;
		var aerondight : W3Effect_Aerondight;
		
		meleeOrRanged = playerAttacker && attackAction && ( attackAction.IsActionMelee() || attackAction.IsActionRanged() );
		redWolfSet = ( W3Petard )action.causer && ( W3PlayerWitcher )actorAttacker && GetWitcherPlayer().IsSetBonusActive( EISB_RedWolf_1 );
		mutation2 = ( W3PlayerWitcher )actorAttacker && GetWitcherPlayer().IsMutationActive(EPMT_Mutation2) && action.IsActionWitcherSign();
		
		if( meleeOrRanged || redWolfSet || mutation2 )
		{
			canLog = theGame.CanLog();
		
			
			if( mutation2 )
			{
				if( FactsQuerySum('debug_fact_critical_boy') > 0 )
				{
					critChance = 1.f;
				}
				else
				{
					signPower = action.GetPowerStatValue();
					theGame.GetDefinitionsManager().GetAbilityAttributeValue('Mutation2', 'crit_chance_factor', min, max);
					critChance = min.valueAdditive + signPower.valueMultiplicative * min.valueMultiplicative;
				}
			} 			
			else
			{
				if( attackAction )
				{
					
					if( SkillEnumToName(S_Sword_s02) == attackAction.GetAttackTypeName() )
					{				
						critChance += CalculateAttributeValue(playerAttacker.GetSkillAttributeValue(S_Sword_s02, theGame.params.CRITICAL_HIT_CHANCE, false, true)) * playerAttacker.GetSkillLevel(S_Sword_s02);
					}
					
					
					if(GetWitcherPlayer() && GetWitcherPlayer().HasRecentlyCountered() && playerAttacker.CanUseSkill(S_Sword_s11) && playerAttacker.GetSkillLevel(S_Sword_s11) > 2)
					{
						critChance += CalculateAttributeValue(playerAttacker.GetSkillAttributeValue(S_Sword_s11, theGame.params.CRITICAL_HIT_CHANCE, false, true));
					}
					
					
					isLightAttack = playerAttacker.IsLightAttack( attackAction.GetAttackName() );
					isHeavyAttack = playerAttacker.IsHeavyAttack( attackAction.GetAttackName() );
					critChance += playerAttacker.GetCriticalHitChance(isLightAttack, isHeavyAttack, actorVictim, victimMonsterCategory, (W3BoltProjectile)action.causer );
					
					
					if(action.GetIsHeadShot())
					{
						critChance += theGame.params.HEAD_SHOT_CRIT_CHANCE_BONUS;
						actorVictim.SignalGameplayEvent( 'Headshot' );
					}
					
					
					if ( actorVictim && actorVictim.IsAttackerAtBack(playerAttacker) )
					{
						critChance += theGame.params.BACK_ATTACK_CRIT_CHANCE_BONUS;
					}
						
					
					if( action.IsActionMelee() && playerAttacker.inv.ItemHasTag( attackAction.GetWeaponId(), 'Aerondight' ) )
					{
						aerondight = (W3Effect_Aerondight)playerAttacker.GetBuff( EET_Aerondight );
						
						if( aerondight && aerondight.IsFullyCharged() )
						{
							
							min = playerAttacker.GetAbilityAttributeValue( 'AerondightEffect', 'crit_chance_bonus' );
							critChance += min.valueAdditive;
						}
					}
				}
				else
				{
					
					critChance += playerAttacker.GetCriticalHitChance(false, false, actorVictim, victimMonsterCategory, (W3BoltProjectile)action.causer );
				}
				
				
				samum = actorVictim.GetBuff(EET_Blindness, 'petard');
				if(samum && samum.GetBuffLevel() == 3)
				{
					critChance += 1.0f;
				}
			}
			
			
			if ( canLog )
			{
				
				critDamageBonus = 1 + CalculateAttributeValue(actorAttacker.GetCriticalHitDamageBonus(weaponId, victimMonsterCategory, actorVictim.IsAttackerAtBack(playerAttacker)));
				critDamageBonus += CalculateAttributeValue(actorAttacker.GetAttributeValue('critical_hit_chance_fast_style'));
				critDamageBonus = 100 * critDamageBonus;
				
				
				LogDMHits("", action);				
				LogDMHits("Trying critical hit (" + NoTrailZeros(critChance*100) + "% chance, dealing " + NoTrailZeros(critDamageBonus) + "% damage)...", action);
			}
			
			
			if(RandF() < critChance)
			{
				
				action.SetCriticalHit();
								
				if ( canLog )
				{
					LogDMHits("********************", action);
					LogDMHits("*** CRITICAL HIT ***", action);
					LogDMHits("********************", action);				
				}
				
				arrStr.PushBack(action.attacker.GetDisplayName());
				theGame.witcherLog.AddCombatMessage(theGame.witcherLog.COLOR_GOLD_BEGIN + GetLocStringByKeyExtWithParams("hud_combat_log_critical_hit",,,arrStr) + theGame.witcherLog.COLOR_GOLD_END, action.attacker, NULL);
			}
			else if ( canLog )
			{
				LogDMHits("... nope", action);
			}
		}	
	}
	
	
	private function LogBeginning()
	{
		var logStr : string;
		
		if ( !theGame.CanLog() )
		{
			return;
		}
		
		LogDMHits("-----------------------------------------------------------------------------------", action);		
		logStr = "Beginning hit processing from <<" + action.attacker + ">> to <<" + action.victim + ">> via <<" + action.causer + ">>";
		if(attackAction)
		{
			logStr += " using AttackType <<" + attackAction.GetAttackTypeName() + ">>";		
		}
		logStr += ":";
		LogDMHits(logStr, action);
		LogDMHits("", action);
		LogDMHits("Target stats before damage dealt are:", action);
		if(actorVictim)
		{
			if( actorVictim.UsesVitality() )
				LogDMHits("Vitality = " + NoTrailZeros(actorVictim.GetStat(BCS_Vitality)), action);
			if( actorVictim.UsesEssence() )
				LogDMHits("Essence = " + NoTrailZeros(actorVictim.GetStat(BCS_Essence)), action);
			if( actorVictim.GetStatMax(BCS_Stamina) > 0)
				LogDMHits("Stamina = " + NoTrailZeros(actorVictim.GetStat(BCS_Stamina, true)), action);
			if( actorVictim.GetStatMax(BCS_Morale) > 0)
				LogDMHits("Morale = " + NoTrailZeros(actorVictim.GetStat(BCS_Morale)), action);
		}
		else
		{
			LogDMHits("Undefined - victim is not a CActor and therefore has no stats", action);
		}
	}
	
	
	private function ProcessDamageIncrease(out dmgInfos : array< SRawDamage >)
	{
		var difficultyDamageMultiplier, rendLoad, rendBonus, overheal, rendRatio, focusCost : float;
		var i, bonusCount : int;
		var frozenBuff : W3Effect_Frozen;
		var frozenDmgInfo : SRawDamage;
		var hadFrostDamage : bool;
		var mpac : CMovingPhysicalAgentComponent;
		var rendBonusPerPoint, staminaRendBonus, perk20Bonus : SAbilityAttributeValue;
		var witcherAttacker : W3PlayerWitcher;
		var damageVal, damageBonus, min, max			: SAbilityAttributeValue;		
		var npcVictim : CNewNPC;
		var sword : SItemUniqueId;
		var actionFreeze : W3DamageAction;
		var aerondight	: W3Effect_Aerondight;
		
		
		var aardDamage : SRawDamage;
		var yrdens : array<W3YrdenEntity>;
		var j, levelDiff : int;
		var aardDamageF : float;
		var spellPower, spellPowerAard, spellPowerYrden : float;
		var spNetflix : SAbilityAttributeValue;
		
		
		
		var entities : array<CGameplayEntity>;
		var skillPassiveMod : float;
		

		
		
		if(actorAttacker && !actorAttacker.IgnoresDifficultySettings() && !action.IsDoTDamage())
		{
			difficultyDamageMultiplier = CalculateAttributeValue(actorAttacker.GetAttributeValue(theGame.params.DIFFICULTY_DMG_MULTIPLIER));
			for(i=0; i<dmgInfos.Size(); i+=1)
			{
				dmgInfos[i].dmgVal = dmgInfos[i].dmgVal * difficultyDamageMultiplier;
			}
		}
			
		
		
		
		if(actorVictim && playerAttacker && !action.IsDoTDamage() && actorVictim.HasBuff(EET_Frozen) && ( (W3AardProjectile)action.causer || (W3AardEntity)action.causer || action.DealsPhysicalOrSilverDamage()) )
		{
			
			action.SetWasFrozen();
			
			
			if( !( ( W3WhiteFrost )action.causer ) )
			{				
				frozenBuff = (W3Effect_Frozen)actorVictim.GetBuff(EET_Frozen);			
				frozenDmgInfo.dmgVal = frozenBuff.GetAdditionalDamagePercents() * actorVictim.GetHealth();
			}
			
			
			actorVictim.RemoveAllBuffsOfType(EET_Frozen);
			action.AddEffectInfo(EET_KnockdownTypeApplicator);
			
			
			if( !( ( W3WhiteFrost )action.causer ) )
			{
				actionFreeze = new W3DamageAction in theGame;
				actionFreeze.Initialize( actorAttacker, actorVictim, action.causer, action.GetBuffSourceName(), EHRT_None, CPS_Undefined, action.IsActionMelee(), action.IsActionRanged(), action.IsActionWitcherSign(), action.IsActionEnvironment() );
				actionFreeze.SetCannotReturnDamage( true );
				actionFreeze.SetCanPlayHitParticle( false );
				actionFreeze.SetHitAnimationPlayType( EAHA_ForceNo );
				actionFreeze.SetWasFrozen();		
				actionFreeze.AddDamage( theGame.params.DAMAGE_NAME_FROST, frozenDmgInfo.dmgVal );
				theGame.damageMgr.ProcessAction( actionFreeze );
				delete actionFreeze;
			}
		}
		
		
		
		if(actorVictim && playerAttacker && GetWitcherPlayer().IsSetBonusActive( EISB_Netflix_2 ) && !action.IsDoTDamage() && ( (W3AardProjectile)action.causer || (W3AardEntity)action.causer)) 
		{	
			yrdens = GetWitcherPlayer().yrdenEntities;
			
			if(yrdens.Size() > 0)
			{
				spellPowerAard = CalculateAttributeValue(GetWitcherPlayer().GetAttributeValue('spell_power_aard'));
				spellPowerYrden = CalculateAttributeValue(GetWitcherPlayer().GetAttributeValue('spell_power_yrden'));				
				spellPower = ClampF(1 + spellPowerAard + spellPowerYrden + CalculateAttributeValue(GetWitcherPlayer().GetPowerStatValue(CPS_SpellPower)), 1, 3); 				
			
				for(i=0; i<yrdens.Size(); i+=1)
				{
					for(j=0; j<yrdens[i].validTargetsInArea.Size(); j+=1)
					{			
						if(yrdens[i].validTargetsInArea[j] == actorVictim )
						{
							levelDiff = playerAttacker.GetLevel() - actorVictim.GetLevel();
							aardDamage.dmgType = theGame.params.DAMAGE_NAME_DIRECT;	
							if( GetWitcherPlayer().CanUseSkill(S_Magic_s06) )
								aardDamageF = (RandRangeF(375.0, 325.0) + (playerAttacker.GetLevel() * 1.8f) + (GetWitcherPlayer().GetSkillLevel(S_Magic_s06) * 100) ) * spellPower;
							else
								aardDamageF = (RandRangeF(375.0, 325.0) + (playerAttacker.GetLevel() * 1.8f) ) * spellPower;
							
							if( actorVictim.GetCharacterStats().HasAbilityWithTag('Boss') || (W3MonsterHuntNPC)actorVictim || (levelDiff < 0 && Abs(levelDiff) > theGame.params.LEVEL_DIFF_HIGH))
							{
								aardDamage.dmgVal = aardDamageF * 0.75f;
							}					
							else
							{
								aardDamage.dmgVal = aardDamageF;
							}
							
							spNetflix = action.GetPowerStatValue();
							aardDamage.dmgVal += 3 * actorVictim.GetHealth() * ( 0.01 + 0.03 * LogF( spNetflix.valueMultiplicative ) );
							dmgInfos.PushBack(aardDamage);
						}
					}
				}
			}
		}
			
		
		if(actorVictim)
		{
			mpac = (CMovingPhysicalAgentComponent)actorVictim.GetMovingAgentComponent();
						
			if(mpac && mpac.IsDiving())
			{
				mpac = (CMovingPhysicalAgentComponent)actorAttacker.GetMovingAgentComponent();	
				
				if(mpac && mpac.IsDiving())
				{
					action.SetUnderwaterDisplayDamageHack();
				
					if(playerAttacker && attackAction && attackAction.IsActionRanged())
					{
						for(i=0; i<dmgInfos.Size(); i+=1)
						{
							if(FactsQuerySum("NewGamePlus"))
							{
								dmgInfos[i].dmgVal *= (1 + theGame.params.UNDERWATER_CROSSBOW_DAMAGE_BONUS_NGP);
							}
							else
							{
								dmgInfos[i].dmgVal *= (1 + theGame.params.UNDERWATER_CROSSBOW_DAMAGE_BONUS);
							}
						}
					}
				}
			}
		}
		
		
		if(playerAttacker && attackAction && SkillNameToEnum(attackAction.GetAttackTypeName()) == S_Sword_s02)
		{
			witcherAttacker = (W3PlayerWitcher)playerAttacker;
			
			
			rendRatio = witcherAttacker.GetSpecialAttackTimeRatio();
			
			
			rendLoad = MinF(rendRatio * playerAttacker.GetStatMax(BCS_Focus), playerAttacker.GetStat(BCS_Focus));
			
			
			if(rendLoad >= 1)
			{
				rendBonusPerPoint = witcherAttacker.GetSkillAttributeValue(S_Sword_s02, 'adrenaline_final_damage_bonus', false, true);
				rendBonus = FloorF(rendLoad) * rendBonusPerPoint.valueMultiplicative;
				
				for(i=0; i<dmgInfos.Size(); i+=1)
				{
					dmgInfos[i].dmgVal *= (1 + rendBonus);
				}
			}
			
			
			staminaRendBonus = witcherAttacker.GetSkillAttributeValue(S_Sword_s02, 'stamina_max_dmg_bonus', false, true);
			
			for(i=0; i<dmgInfos.Size(); i+=1)
			{
				dmgInfos[i].dmgVal *= (1 + rendRatio * staminaRendBonus.valueMultiplicative);
			}
			
			
			thePlayer.SetAttackActionName('');
		}	
 
		
		if ( actorAttacker != thePlayer && action.IsActionRanged() && (int)CalculateAttributeValue(actorAttacker.GetAttributeValue('level',,true)) > 31)
		{
			damageVal = actorAttacker.GetAttributeValue('light_attack_damage_vitality',,true);
			for(i=0; i<dmgInfos.Size(); i+=1)
			{
				dmgInfos[i].dmgVal = dmgInfos[i].dmgVal + CalculateAttributeValue(damageVal) / 2;
			}
		}
		
		
		if ( actorVictim && playerAttacker && attackAction && action.IsActionMelee() && thePlayer.HasAbility('Runeword 4 _Stats', true) && !attackAction.WasDodged() )
		{
			overheal = thePlayer.abilityManager.GetOverhealBonus() / thePlayer.GetStatMax(BCS_Vitality);
		
			if(overheal > 0.005f)
			{
				for(i=0; i<dmgInfos.Size(); i+=1)
				{
					dmgInfos[i].dmgVal *= 1.0f + overheal;
				}
			
				thePlayer.abilityManager.ResetOverhealBonus();
				
				
				actorVictim.CreateFXEntityAtPelvis( 'runeword_4', true );				
			}
		}
		
		
		if( playerAttacker && actorVictim && attackAction.IsActionMelee() && GetWitcherPlayer().IsSetBonusActive( EISB_Wolf_1 ) )
		{
			FindGameplayEntitiesInRange( entities, playerAttacker, 50, 1000, , FLAG_OnlyAliveActors );
			if( entities.Size() > 0 )
			{
				for( i=0; i<entities.Size(); i+=1 )
				{
					npcVictim = (CNewNPC) entities[i];
					if( npcVictim )
					{
						if( npcVictim.HasBuff( EET_Bleeding ) )  bonusCount += 1;
						if( npcVictim.HasBuff( EET_Bleeding1 ) ) bonusCount += 1;
						if( npcVictim.HasBuff( EET_Bleeding2 ) ) bonusCount += 1;
						if( npcVictim.HasBuff( EET_Bleeding3 ) ) bonusCount += 1;
					}
				}
				
				bonusCount *= ((W3PlayerWitcher)playerAttacker).GetSetPartsEquipped( EIST_Wolf );
				
				for( i=0; i<dmgInfos.Size() ; i+=1 )
				{
					dmgInfos[i].dmgVal *= 1 + bonusCount*0.01;
				}
			}
		}
		
		
		
		if( playerAttacker && playerAttacker.IsLightAttack( attackAction.GetAttackName() ) && playerAttacker.HasBuff( EET_LynxSetBonus ) && !attackAction.WasDodged() ) 
		{
			if( !attackAction.IsParried() && !attackAction.IsCountered() )
			{
				
				damageBonus = playerAttacker.GetAttributeValue( 'lynx_dmg_boost' );
				
				damageBonus.valueAdditive *= ((W3PlayerWitcher)playerAttacker).GetSetPartsEquipped( EIST_Lynx );
				
				for( i=0 ; i<dmgInfos.Size() ; i += 1 )
				{
					dmgInfos[i].dmgVal *= 1 + damageBonus.valueAdditive;
				}
			}
		}

		
		if( playerAttacker && attackAction.IsActionMelee() && actorVictim.IsAttackerAtBack( playerAttacker ) && !actorVictim.HasAbility( 'CannotBeAttackedFromBehind' ) && ((W3PlayerWitcher)playerAttacker).IsSetBonusActive( EISB_Lynx_2 ) && !attackAction.WasDodged() && ( playerAttacker.inv.IsItemSteelSwordUsableByPlayer( attackAction.GetWeaponId() ) || playerAttacker.inv.IsItemSilverSwordUsableByPlayer( attackAction.GetWeaponId() ) ) )
		{
			if( !attackAction.IsParried() && !attackAction.IsCountered() && playerAttacker.GetStat(BCS_Focus) >= 1.0f )
			{
				theGame.GetDefinitionsManager().GetAbilityAttributeValue( GetSetBonusAbility( EISB_Lynx_2 ), 'lynx_2_dmg_boost', min, max );
				for( i=0; i<dmgInfos.Size() ; i+=1 )
				{
					dmgInfos[i].dmgVal *= 1 + min.valueAdditive;
				}
				
				if ( !( thePlayer.IsInCombatAction() && ( thePlayer.GetCombatAction() == EBAT_SpecialAttack_Light || thePlayer.GetCombatAction() == EBAT_SpecialAttack_Heavy ) ) )
				{
					theGame.GetDefinitionsManager().GetAbilityAttributeValue( GetSetBonusAbility( EISB_Lynx_2 ), 'lynx_2_adrenaline_cost', min, max );
					focusCost = min.valueAdditive;
					if( GetWitcherPlayer().GetStat( BCS_Focus ) >= focusCost )
					{				
						theGame.GetDefinitionsManager().GetAbilityAttributeValue( GetSetBonusAbility( EISB_Lynx_2 ), 'lynx_2_stun_duration', min, max );
						attackAction.AddEffectInfo( EET_Confusion, min.valueAdditive );
						playerAttacker.SoundEvent( "ep2_setskill_lynx_activate" );
						playerAttacker.DrainFocus( focusCost );
					}
				}
			}
		}

		
		
		
		if ( playerAttacker && action.IsActionRanged() && ((W3Petard)action.causer) )
		{
			skillPassiveMod = CalculateAttributeValue(GetWitcherPlayer().GetAttributeValue('potion_duration'));
			for( i = 0 ; i < dmgInfos.Size() ; i+=1)
			{
				dmgInfos[i].dmgVal *= ( 1 + skillPassiveMod );
			}
			
			
			if ( GetWitcherPlayer().CanUseSkill(S_Perk_20) && !action.IsDoTDamage() )
			{
				perk20Bonus = GetWitcherPlayer().GetSkillAttributeValue( S_Perk_20, 'dmg_multiplier', false, false);
				for( i = 0 ; i < dmgInfos.Size() ; i+=1)
				{
					dmgInfos[i].dmgVal *= ( 1 + perk20Bonus.valueMultiplicative );
				}
			}
			
		}
		
		
		if( playerAttacker && action.IsActionWitcherSign() && GetWitcherPlayer().IsMutationActive( EPMT_Mutation1 ) )
		{
			sword = playerAttacker.inv.GetCurrentlyHeldSword();
			
			damageVal.valueBase = 0;
			damageVal.valueMultiplicative = 0;
			damageVal.valueAdditive = 0;
		
			if( playerAttacker.inv.GetItemCategory(sword) == 'steelsword' )
			{
				damageVal += playerAttacker.inv.GetItemAttributeValue(sword, theGame.params.DAMAGE_NAME_SLASHING);
			}
			else if( playerAttacker.inv.GetItemCategory(sword) == 'silversword' )
			{
				damageVal += playerAttacker.inv.GetItemAttributeValue(sword, theGame.params.DAMAGE_NAME_SILVER);
			}
			theGame.GetDefinitionsManager().GetAbilityAttributeValue('Mutation1', 'dmg_bonus_factor', min, max);				
			
			damageVal.valueBase *= CalculateAttributeValue(min);
			
			if( action.IsDoTDamage() )
			{
				damageVal.valueBase *= action.GetDoTdt();
			}
			
			for( i = 0 ; i < dmgInfos.Size() ; i+=1)
			{
				dmgInfos[i].dmgVal += damageVal.valueBase;
			}
		}
		
		
		npcVictim = (CNewNPC) actorVictim;
		if( playerAttacker && npcVictim && attackAction && action.IsActionMelee() && GetWitcherPlayer().IsMutationActive( EPMT_Mutation8 ) && ( victimMonsterCategory != MC_Human || npcVictim.IsImmuneToMutation8Finisher() ) && attackAction.GetWeaponId() == GetWitcherPlayer().GetHeldSword() )
		{
			dm.GetAbilityAttributeValue( 'Mutation8', 'dmg_bonus', min, max );
			
			for( i = 0 ; i < dmgInfos.Size() ; i+=1)
			{
				dmgInfos[i].dmgVal *= 1 + min.valueMultiplicative;
			}
		}
		
		
		if( playerAttacker && actorVictim && attackAction && action.IsActionMelee() && playerAttacker.inv.ItemHasTag( attackAction.GetWeaponId(), 'Aerondight' ) )
		{	
			aerondight = (W3Effect_Aerondight)playerAttacker.GetBuff( EET_Aerondight );	
			
			if( aerondight )
			{
				min = playerAttacker.GetAbilityAttributeValue( 'AerondightEffect', 'dmg_bonus' );
				bonusCount = aerondight.GetCurrentCount();
			
				if( bonusCount > 0 )
				{
					min.valueMultiplicative *= bonusCount;
					
					for( i = 0 ; i < dmgInfos.Size() ; i += 1 )
					{
						dmgInfos[i].dmgVal *= 1 + min.valueMultiplicative;
					}
				}				
			}
		}	
	}
	
	
	private function ProcessActionReturnedDamage()
	{
		var witcher 			: W3PlayerWitcher;
		var quen 				: W3QuenEntity;
		var params 				: SCustomEffectParams;
		var processFireShield, canBeParried, canBeDodged, wasParried, wasDodged, returned : bool;
		var g5Chance			: SAbilityAttributeValue;
		var dist, checkDist		: float;
		
		
		if((W3PlayerWitcher)playerVictim && !playerAttacker && actorAttacker && !action.IsDoTDamage() && action.IsActionMelee() && (attackerMonsterCategory == MC_Necrophage || attackerMonsterCategory == MC_Vampire) && actorVictim.HasBuff(EET_BlackBlood))
		{
			returned = ProcessActionBlackBloodReturnedDamage();		
		}
		
		
		if(action.IsActionMelee() && actorVictim.HasAbility( 'Thorns' ) )
		{
			returned = ProcessActionThornDamage() || returned;
		}
		
		if(actorVictim.HasAbility( 'Glyphword 5 _Stats', true))
		{			
			if( GetAttitudeBetween(actorAttacker, actorVictim) == AIA_Hostile)
			{
				if( !action.IsDoTDamage() )
				{
					g5Chance = actorVictim.GetAttributeValue('glyphword5_chance');
					
					if(RandF() < g5Chance.valueAdditive)
					{
						canBeParried = attackAction.CanBeParried();
						canBeDodged = attackAction.CanBeDodged();
						wasParried = attackAction.IsParried() || attackAction.IsCountered();
						wasDodged = attackAction.WasDodged();
				
						if(!action.IsActionMelee() || (!canBeParried && canBeDodged && !wasDodged) || (canBeParried && !wasParried && !canBeDodged) || (canBeParried && canBeDodged && !wasDodged && !wasParried))
						{
							returned = ProcessActionReflectDamage() || returned;
						}
					}	
				}
			}			
			
		}
		
		
		if(playerVictim && !playerAttacker && actorAttacker && attackAction && attackAction.IsActionMelee() && thePlayer.HasBuff(EET_Mutagen26))
		{
			returned = ProcessActionLeshenMutagenDamage() || returned;
		}
		
		
		if(action.IsActionMelee() && actorVictim.HasAbility( 'FireShield' ) )
		{
			witcher = GetWitcherPlayer();			
			processFireShield = true;			
			if(playerAttacker == witcher)
			{
				quen = (W3QuenEntity)witcher.GetSignEntity(ST_Quen);
				if(quen && quen.IsAnyQuenActive())
				{
					processFireShield = false;
				}
			}
			
			if(processFireShield)
			{
				params.effectType = EET_Burning;
				params.creator = actorVictim;
				params.sourceName = actorVictim.GetName();
				
				params.effectValue.valueMultiplicative = 0.01;
				actorAttacker.AddEffectCustom(params);
				returned = true;
			}
		}
		
		
		if(actorAttacker.UsesEssence())
		{
			returned = ProcessSilverStudsReturnedDamage() || returned;
		}
			
		
		if( (W3PlayerWitcher)playerVictim && !playerAttacker && actorAttacker && !playerAttacker.IsInFistFightMiniGame() && !action.IsDoTDamage() && action.IsActionMelee() && GetWitcherPlayer().IsMutationActive( EPMT_Mutation4 ) )
		{
			
			dist = VecDistance( actorAttacker.GetWorldPosition(), actorVictim.GetWorldPosition() );
			checkDist = 3.f;
			if( actorAttacker.IsHuge() )
			{
				checkDist += 3.f;
			}
 
			if( dist <= checkDist )
			{
				returned = GetWitcherPlayer().ProcessActionMutation4ReturnedDamage( action.processedDmg.vitalityDamage, actorAttacker, EAHA_ForceYes, action ) || returned;
			}
		}
		
		action.SetWasDamageReturnedToAttacker( returned );
	}
	
	
	private function ProcessActionLeshenMutagenDamage() : bool
	{
		var damageAction : W3DamageAction;
		var returnedDamage, pts, perc : float;
		var mutagen : W3Mutagen26_Effect;
		
		mutagen = (W3Mutagen26_Effect)playerVictim.GetBuff(EET_Mutagen26);
		mutagen.GetReturnedDamage(pts, perc);
		
		if(pts <= 0 && perc <= 0)
			return false;
			
		
		
		returnedDamage = pts + perc * action.processedDmg.vitalityDamage;
		
		
		
		damageAction = new W3DamageAction in this;		
		damageAction.Initialize( action.victim, action.attacker, NULL, "Mutagen26", EHRT_None, CPS_AttackPower, true, false, false, false );		
		damageAction.SetCannotReturnDamage( true );		
		damageAction.SetHitAnimationPlayType( EAHA_ForceNo );		
		
		
		
		damageAction.AddDamage(theGame.params.DAMAGE_NAME_DIRECT, returnedDamage);
		
		
		theGame.damageMgr.ProcessAction(damageAction);
		delete damageAction;
		
		return true;
	}
	
	
	private function ProcessSilverStudsReturnedDamage() : bool
	{
		var damageAction : W3DamageAction;
		var returnedDamage : float;
		
		returnedDamage = CalculateAttributeValue(actorVictim.GetAttributeValue('returned_silver_damage'));
		
		if(returnedDamage <= 0)
			return false;
		
		damageAction = new W3DamageAction in this;		
		damageAction.Initialize( action.victim, action.attacker, NULL, "SilverStuds", EHRT_None, CPS_AttackPower, true, false, false, false );		
		damageAction.SetCannotReturnDamage( true );		
		damageAction.SetHitAnimationPlayType( EAHA_ForceNo );		
		
		damageAction.AddDamage(theGame.params.DAMAGE_NAME_SILVER, returnedDamage);
		
		theGame.damageMgr.ProcessAction(damageAction);
		delete damageAction;
		
		return true;
	}
	
	
	private function ProcessActionBlackBloodReturnedDamage() : bool
	{
		var returnedAction : W3DamageAction;
		var returnVal : SAbilityAttributeValue;
		var bb : W3Potion_BlackBlood;
		var potionLevel : int;
		var returnedDamage : float;
	
		if(action.processedDmg.vitalityDamage <= 0)
			return false;
		
		bb = (W3Potion_BlackBlood)actorVictim.GetBuff(EET_BlackBlood);
		potionLevel = bb.GetBuffLevel();
		
		
		returnedAction = new W3DamageAction in this;		
		returnedAction.Initialize( action.victim, action.attacker, bb, "BlackBlood", EHRT_None, CPS_AttackPower, true, false, false, false );		
		returnedAction.SetCannotReturnDamage( true );		
		
		returnVal = bb.GetReturnDamageValue();
		
		if(potionLevel == 1)
		{
			returnedAction.SetHitAnimationPlayType(EAHA_ForceNo);
		}
		else
		{
			returnedAction.SetHitAnimationPlayType(EAHA_ForceYes);
			returnedAction.SetHitReactionType(EHRT_Reflect);
		}
		
		returnedDamage = (returnVal.valueBase + action.processedDmg.vitalityDamage) * returnVal.valueMultiplicative + returnVal.valueAdditive;
		returnedAction.AddDamage(theGame.params.DAMAGE_NAME_DIRECT, returnedDamage);
		
		theGame.damageMgr.ProcessAction(returnedAction);
		delete returnedAction;
		return true;
	}
	
	
	private function ProcessActionReflectDamage() : bool
	{
		var returnedAction : W3DamageAction;
		var returnVal, min, max : SAbilityAttributeValue;
		var potionLevel : int;
		var returnedDamage : float;
		var template : CEntityTemplate;
		var fxEnt : CEntity;
		var boneIndex: int;
		var b : bool;
		var component : CComponent;
		
		
		if(action.processedDmg.vitalityDamage <= 0)
			return false;
		
		returnedDamage = CalculateAttributeValue(actorVictim.GetTotalArmor());
		theGame.GetDefinitionsManager().GetAbilityAttributeValue('Glyphword 5 _Stats', 'damage_mult', min, max);
		
		
		
		
		returnedAction = new W3DamageAction in this;		
		returnedAction.Initialize( action.victim, action.attacker, NULL, "Glyphword5", EHRT_None, CPS_AttackPower, true, false, false, false );		
		returnedAction.SetCannotReturnDamage( true );		
		returnedAction.SetHitAnimationPlayType(EAHA_ForceYes);
		returnedAction.SetHitReactionType(EHRT_Heavy);
		
		returnedAction.AddDamage(theGame.params.DAMAGE_NAME_DIRECT, returnedDamage * min.valueMultiplicative);
		
		
		
		
		theGame.damageMgr.ProcessAction(returnedAction);
		delete returnedAction;
		
		template = (CEntityTemplate)LoadResource('glyphword_5');
		
		
		
		
		
		
		component = action.attacker.GetComponent('torso3effect');
		if(component)
			thePlayer.PlayEffect('reflection_damge', component);
		else
			thePlayer.PlayEffect('reflection_damge', action.attacker);
		action.attacker.PlayEffect('yrden_shock');
		
		return true;
	}
	
	
	private function ProcessActionThornDamage() : bool
	{
		var damageAction 		: W3DamageAction;
		var damageVal 			: SAbilityAttributeValue;
		var damage				: float;
		var inv					: CInventoryComponent;
		var damageNames			: array < CName >;
		
		damageAction	= new W3DamageAction in this;
		
		damageAction.Initialize( action.victim, action.attacker, NULL, "Thorns", EHRT_Light, CPS_AttackPower, true, false, false, false );
		
		damageAction.SetCannotReturnDamage( true );		
		
		damageVal 				=  actorVictim.GetAttributeValue( 'light_attack_damage_vitality' );
		
		
		
		
		
		inv = actorAttacker.GetInventory();		
		inv.GetWeaponDTNames(weaponId, damageNames );
		damageVal.valueBase  = actorAttacker.GetTotalWeaponDamage(weaponId, damageNames[0], GetInvalidUniqueId() );
		
		damageVal.valueBase *= 0.10f;
		
		if( damageVal.valueBase == 0 )
		{
			damageVal.valueBase = 10;
		}
				
		damage = (damageVal.valueBase + action.processedDmg.vitalityDamage) * damageVal.valueMultiplicative + damageVal.valueAdditive;
		damageAction.AddDamage(  theGame.params.DAMAGE_NAME_PIERCING, damage );
		
		damageAction.SetHitAnimationPlayType( EAHA_ForceYes );
		theGame.damageMgr.ProcessAction(damageAction);
		delete damageAction;
		
		return true;
	}
		
	
	private function GetAttackersPowerMod() : SAbilityAttributeValue
	{		
		var powerMod, criticalDamageBonus, min, max, critReduction, sp : SAbilityAttributeValue;
		var mutagen : CBaseGameplayEffect;
		var totalBonus : float;
		
		
		var inv	: CInventoryComponent; 
		var weaponName : name;
		
			
		
		powerMod = action.GetPowerStatValue();
		if ( powerMod.valueAdditive == 0 && powerMod.valueBase == 0 && powerMod.valueMultiplicative == 0 && theGame.CanLog() )
			LogDMHits("Attacker has power stat of 0!", action);
		
		
		if(playerAttacker && attackAction && playerAttacker.IsHeavyAttack(attackAction.GetAttackName()))
			powerMod.valueMultiplicative -= 0.433;
		
		
		if ( playerAttacker && (W3IgniProjectile)action.causer )
			powerMod.valueMultiplicative = 1 + (powerMod.valueMultiplicative - 1) * theGame.params.IGNI_SPELL_POWER_MILT;
		
		
		if ( playerAttacker && (W3AardProjectile)action.causer )
			powerMod.valueMultiplicative = 1;
		
		
		
		inv = actorAttacker.GetInventory();	
		weaponName = inv.GetItemName( weaponId );
		
		if( !playerAttacker && actorVictim && !thePlayer.IsInFistFightMiniGame() && GetAttitudeBetween( thePlayer, actorAttacker ) == AIA_Friendly && !actorAttacker.HasTag( 'keira' ) && !actorAttacker.HasTag( 'Yennefer' )
			&& ( actorAttacker.IsWeaponHeld( 'silversword' ) || actorAttacker.IsWeaponHeld( 'staff2h' ) || weaponName == 'fists_lightning' || weaponName == 'fists_fire' || actorAttacker.HasAbility( 'SkillWitcher' ) || actorAttacker.HasTag( 'regis' )  || actorAttacker.HasBuff(EET_AxiiGuardMe) ) )
		{
			if ( powerMod.valueMultiplicative <= 0.1 )
			{
				actorAttacker.AddAbility( 'FCR3HighDamageBoost' );
				actorAttacker.AddAbility( 'FCR3LowDamageBoost');
			}
			else if ( powerMod.valueMultiplicative <= 0.4 )
			{
				actorAttacker.AddAbility( 'FCR3MedDamageBoost' );
				actorAttacker.AddAbility( 'FCR3LowDamageBoost' );
			}
			else if ( powerMod.valueMultiplicative <= 0.9 )
			{
				actorAttacker.AddAbility( 'FCR3MedDamageBoost' );
			}
			else if ( powerMod.valueMultiplicative <= 1.1 )
			{
				actorAttacker.AddAbility( 'FCR3LowDamageBoost' );
			}
		}
		
		
		
		if(action.IsCriticalHit())
		{
			
			if( playerAttacker && action.IsActionWitcherSign() && GetWitcherPlayer().IsMutationActive(EPMT_Mutation2) )
			{
				sp = action.GetPowerStatValue();
				
				theGame.GetDefinitionsManager().GetAbilityAttributeValue('Mutation2', 'crit_damage_factor', min, max);				
				criticalDamageBonus.valueAdditive = sp.valueMultiplicative * min.valueMultiplicative;
			}
			else 
			{
				criticalDamageBonus = actorAttacker.GetCriticalHitDamageBonus(weaponId, victimMonsterCategory, actorVictim.IsAttackerAtBack(playerAttacker));
				
				criticalDamageBonus += actorAttacker.GetAttributeValue('critical_hit_chance_fast_style');
				
				if(attackAction && playerAttacker)
				{
					if(playerAttacker.IsHeavyAttack(attackAction.GetAttackName()) && playerAttacker.CanUseSkill(S_Sword_s08))
						criticalDamageBonus += playerAttacker.GetSkillAttributeValue(S_Sword_s08, theGame.params.CRITICAL_HIT_DAMAGE_BONUS, false, true) * playerAttacker.GetSkillLevel(S_Sword_s08);
					else if (!playerAttacker.IsHeavyAttack(attackAction.GetAttackName()) && playerAttacker.CanUseSkill(S_Sword_s17))
						criticalDamageBonus += playerAttacker.GetSkillAttributeValue(S_Sword_s17, theGame.params.CRITICAL_HIT_DAMAGE_BONUS, false, true) * playerAttacker.GetSkillLevel(S_Sword_s17);
				}
			}
			
			
			totalBonus = CalculateAttributeValue(criticalDamageBonus);
			critReduction = actorVictim.GetAttributeValue(theGame.params.CRITICAL_HIT_REDUCTION);
			totalBonus = totalBonus * ClampF(1 - critReduction.valueMultiplicative, 0.f, 1.f);
			
			
			powerMod.valueMultiplicative += totalBonus;
		}
		
		
		if (actorVictim && playerAttacker)
		{
			if ( playerAttacker.HasBuff(EET_Mutagen05) && (playerAttacker.GetStat(BCS_Vitality) == playerAttacker.GetStatMax(BCS_Vitality)) )
			{
				mutagen = playerAttacker.GetBuff(EET_Mutagen05);
				dm.GetAbilityAttributeValue(mutagen.GetAbilityName(), 'damageIncrease', min, max);
				powerMod += GetAttributeRandomizedValue(min, max);
			}
		}
			
		return powerMod;
	}
	
	
	private function GetDamageResists(dmgType : name, out resistPts : float, out resistPerc : float)
	{
		var armorReduction, armorReductionPerc, skillArmorReduction : SAbilityAttributeValue;
		var bonusReduct, bonusResist : float;
		var mutagenBuff : W3Mutagen28_Effect;
		var appliedOilName, vsMonsterResistReduction : name;
		var oils : array< W3Effect_Oil >;
		var i : int;
		
		
		if(attackAction && attackAction.IsActionMelee() && actorAttacker.GetInventory().IsItemFists(weaponId) && !actorVictim.UsesEssence())
			return;
			
		
		if(actorVictim)
		{
			
			actorVictim.GetResistValue( GetResistForDamage(dmgType, action.IsDoTDamage()), resistPts, resistPerc );
			
			
			if(playerVictim && actorAttacker && playerVictim.CanUseSkill(S_Alchemy_s05))
			{
				GetOilProtectionAgainstMonster(dmgType, bonusResist, bonusReduct);
				
				resistPerc += bonusResist * playerVictim.GetSkillLevel(S_Alchemy_s05);
			}
			
			
			if(playerVictim && actorAttacker && playerVictim.HasBuff(EET_Mutagen28))
			{
				mutagenBuff = (W3Mutagen28_Effect)playerVictim.GetBuff(EET_Mutagen28);
				mutagenBuff.GetProtection(attackerMonsterCategory, dmgType, action.IsDoTDamage(), bonusResist, bonusReduct);
				resistPts += bonusReduct;
				resistPerc += bonusResist;
			}
			
			
			if(actorAttacker)
			{
				
				armorReduction = actorAttacker.GetAttributeValue('armor_reduction');
				armorReductionPerc = actorAttacker.GetAttributeValue('armor_reduction_perc');
				
				
				if(playerAttacker)
				{
					vsMonsterResistReduction = MonsterCategoryToResistReduction(victimMonsterCategory);
					oils = playerAttacker.inv.GetOilsAppliedOnItem( weaponId );
					
					if( oils.Size() > 0 )
					{
						for( i=0; i<oils.Size(); i+=1 )
						{
							appliedOilName = oils[ i ].GetOilItemName();
							
							
							if( oils[ i ].GetAmmoCurrentCount() > 0 && dm.ItemHasAttribute( appliedOilName, true, vsMonsterResistReduction ) )
							{
								armorReductionPerc.valueMultiplicative += oils[ i ].GetAmmoPercentage();
							}
						}
					}
				}
				
				
				if(playerAttacker && action.IsActionMelee() && playerAttacker.IsHeavyAttack(attackAction.GetAttackName()) && playerAttacker.CanUseSkill(S_Sword_2))
					armorReduction += playerAttacker.GetSkillAttributeValue(S_Sword_2, 'armor_reduction', false, true);
				
				
				if ( playerAttacker && 
					 action.IsActionMelee() && playerAttacker.IsHeavyAttack(attackAction.GetAttackName()) && 
					 ( dmgType == theGame.params.DAMAGE_NAME_PHYSICAL || 
					   dmgType == theGame.params.DAMAGE_NAME_SLASHING || 
				       dmgType == theGame.params.DAMAGE_NAME_PIERCING || 
					   dmgType == theGame.params.DAMAGE_NAME_BLUDGEONING || 
					   dmgType == theGame.params.DAMAGE_NAME_RENDING || 
					   dmgType == theGame.params.DAMAGE_NAME_SILVER
					 ) && 
					 playerAttacker.CanUseSkill(S_Sword_s06)
				   ) 
				{
					
					skillArmorReduction = playerAttacker.GetSkillAttributeValue(S_Sword_s06, 'armor_reduction_perc', false, true);
					armorReductionPerc += skillArmorReduction * playerAttacker.GetSkillLevel(S_Sword_s06);				
				}
			}
		}
		
		
		if(!action.GetIgnoreArmor())
			resistPts += CalculateAttributeValue( actorVictim.GetTotalArmor() );
		
		
		resistPts = MaxF(0, resistPts - CalculateAttributeValue(armorReduction) );		
		resistPerc -= CalculateAttributeValue(armorReductionPerc);		
		
		
		
		resistPerc = MaxF(0, resistPerc);
	}
		
	
	private function CalculateDamage(dmgInfo : SRawDamage, powerMod : SAbilityAttributeValue) : float
	{
		var finalDamage, finalIncomingDamage : float;
		var resistPoints, resistPercents : float;
		var ptsString, percString : string;
		var mutagen : CBaseGameplayEffect;
		var min, max : SAbilityAttributeValue;
		var encumbranceBonus : float;
		var temp : bool;
		var fistfightDamageMult : float;
		var burning : W3Effect_Burning;
		
		
		var weaponName 		: name;
		var dmgBonus 		: float;
		var playerStlDmg 	: float;
		var playerSlvDmg 	: float;
		var playerFastSlvDmg: float;
		var playerSlvCritDmg: float;
		var multBonus 		: float;
		var dmgLevel		: int;
		var curStats		: SPlayerOffenseStats;
		var inv				: CInventoryComponent;
		
	
		
		GetDamageResists(dmgInfo.dmgType, resistPoints, resistPercents);
	
		
		if( thePlayer.IsFistFightMinigameEnabled() && actorAttacker == thePlayer )
		{
			finalDamage = MaxF(0, (dmgInfo.dmgVal));
		}
		else
		{
			
			burning = (W3Effect_Burning)action.causer;
			if( burning && burning.IsSignEffect() )
			{
				if ( powerMod.valueMultiplicative > 2.5f )
				{
					powerMod.valueMultiplicative = 2.5f + LogF( (powerMod.valueMultiplicative - 2.5f) + 1 );
				}
			}
			
			finalDamage = MaxF(0, (dmgInfo.dmgVal + powerMod.valueBase) * powerMod.valueMultiplicative + powerMod.valueAdditive);
			
			
			
			inv = actorAttacker.GetInventory();	
			weaponName = inv.GetItemName( weaponId );
			if( thePlayer.IsCiri() )
			{
				dmgLevel = ( actorVictim.GetLevel() -2 ) * 10;
			}
			else
			{
				dmgLevel = Min( actorVictim.GetLevel(), GetWitcherPlayer().GetLevel() ) * 40;
			}
			
			if( !playerAttacker && actorVictim && GetAttitudeBetween( thePlayer, actorAttacker ) == AIA_Friendly && !action.IsDoTDamage() && !actorAttacker.HasTag( 'Yennefer' ) && !actorAttacker.HasTag( 'keira' ) 
				&& !actorAttacker.HasTag( 'Philippa' ) && ( actorAttacker.IsWeaponHeld( 'silversword' ) || actorAttacker.IsWeaponHeld( 'staff2h' ) || weaponName == 'fists_lightning' || weaponName == 'fists_fire' 
				|| actorAttacker.HasAbility( 'SkillWitcher' ) || actorAttacker.HasTag( 'zoltan' ) || actorAttacker.HasTag( 'hjalmar' ) || actorAttacker.HasTag( 'regis' ) || actorAttacker.HasBuff(EET_AxiiGuardMe) ) && ( finalDamage < dmgLevel || thePlayer.IsCiri() ) )
			{
				dmgBonus += dmgLevel - finalDamage;
				finalDamage = MaxF(0, (dmgInfo.dmgVal + powerMod.valueBase + dmgBonus) * powerMod.valueMultiplicative + powerMod.valueAdditive);
			}
			
		}
			
		finalIncomingDamage = finalDamage;
			
		if(finalDamage > 0.f)
		{
			
			if(!action.IsPointResistIgnored() && !(dmgInfo.dmgType == theGame.params.DAMAGE_NAME_ELEMENTAL || dmgInfo.dmgType == theGame.params.DAMAGE_NAME_FIRE || dmgInfo.dmgType == theGame.params.DAMAGE_NAME_FROST ))
			{
				finalDamage = MaxF(0, finalDamage - resistPoints);
				
				if(finalDamage == 0.f)
					action.SetArmorReducedDamageToZero( true ); 
			}
		}
		
		if(finalDamage > 0.f)
		{
			
			if (playerVictim == GetWitcherPlayer() && playerVictim.HasBuff(EET_Mutagen02))
			{
				encumbranceBonus = 1 - (GetWitcherPlayer().GetEncumbrance() / GetWitcherPlayer().GetMaxRunEncumbrance(temp));
				if (encumbranceBonus < 0)
					encumbranceBonus = 0;
				mutagen = playerVictim.GetBuff(EET_Mutagen02);
				dm.GetAbilityAttributeValue(mutagen.GetAbilityName(), 'resistGainRate', min, max);
				encumbranceBonus *= CalculateAttributeValue(GetAttributeRandomizedValue(min, max));
				resistPercents += encumbranceBonus;
			}
			finalDamage *= 1 - resistPercents;
		}	



		
		
		if( !playerAttacker && actorVictim && !action.IsDoTDamage() && !thePlayer.IsFistFightMinigameEnabled() && finalDamage <= actorVictim.GetMaxHealth() * 0.01 && (GetAttitudeBetween( thePlayer, actorAttacker ) == AIA_Friendly || actorAttacker.HasBuff(EET_AxiiGuardMe)) )
		{
			dmgBonus += dmgLevel - finalDamage;
			if ( powerMod.valueMultiplicative < 1.0 )
			{
				multBonus = 1.0 - powerMod.valueMultiplicative;
			}
			finalDamage = MaxF(actorVictim.GetMaxHealth() * 0.01, (dmgInfo.dmgVal + powerMod.valueBase + dmgBonus) * ( powerMod.valueMultiplicative + multBonus ) + powerMod.valueAdditive);
			
			if(!action.IsPointResistIgnored() && !(dmgInfo.dmgType == theGame.params.DAMAGE_NAME_ELEMENTAL || dmgInfo.dmgType == theGame.params.DAMAGE_NAME_FIRE || dmgInfo.dmgType == theGame.params.DAMAGE_NAME_FROST ))
			{
				finalDamage = MaxF(actorVictim.GetMaxHealth() * 0.01, finalDamage - resistPoints);
				
				if(finalDamage == 0.f)
					action.SetArmorReducedDamageToZero( true );
				else
					action.SetArmorReducedDamageToZero( false );
			}
			
			finalDamage *= 1 - resistPercents;
		}
		
		
		curStats = GetWitcherPlayer().GetOffenseStatsList();
		playerStlDmg = MaxF(0, curStats.steelStrongDmg - resistPoints);
		playerStlDmg *= 1 - resistPercents;
		playerStlDmg /= 6;
		
		playerFastSlvDmg = MaxF(0, curStats.silverFastDmg - resistPoints);
		playerFastSlvDmg *= 1 - resistPercents;
		playerFastSlvDmg /= 6;

		playerSlvDmg = MaxF(0, curStats.silverStrongDmg - resistPoints);
		playerSlvDmg *= 1 - resistPercents;
		playerSlvDmg /= 6;
		
		playerSlvCritDmg = MaxF(0, curStats.silverStrongCritDmg - resistPoints);
		playerSlvCritDmg *= 1 - resistPercents;
		playerSlvCritDmg /= 6;
		
		if( !playerAttacker && actorVictim && !action.IsDoTDamage() && !thePlayer.IsFistFightMinigameEnabled() && (GetAttitudeBetween( thePlayer, actorAttacker ) == AIA_Friendly || actorAttacker.HasBuff(EET_AxiiGuardMe)) && !thePlayer.IsCiri()  )
		{
			if(finalDamage > playerStlDmg && !actorAttacker.HasAbility( 'ForceInstantKill' ))
			{
				if ( actorAttacker.HasTag( 'regis' ) )
				{
					if ( finalDamage > playerSlvCritDmg * 2 )
					{
						finalDamage = ClampF( finalDamage, 0, playerSlvCritDmg * 2 );
						finalDamage = MaxF(actorVictim.GetMaxHealth() * 0.01, finalDamage);
					}
					if ( finalDamage < playerSlvCritDmg )
					{
						finalDamage = ClampF( finalDamage, playerSlvCritDmg, finalDamage );
					}
				}
				else if ( actorAttacker.IsWeaponHeld( 'staff2h' ) || weaponName == 'fists_lightning' || weaponName == 'fists_fire' || action.GetPowerStatType() == CPS_SpellPower )
				{
					if ( finalDamage > playerSlvDmg * 2 )
					{
						finalDamage = ClampF( finalDamage, 0, playerSlvDmg );
						finalDamage = MaxF(actorVictim.GetMaxHealth() * 0.01, finalDamage);
					}
					
					if ( finalDamage < playerFastSlvDmg && attackAction )
					{
						finalDamage = ClampF( finalDamage, playerFastSlvDmg, finalDamage );
					}
				}
				else if ( actorAttacker.IsWeaponHeld( 'silversword' ) || actorAttacker.HasAbility( 'SkillWitcher' ) || actorAttacker.HasBuff(EET_AxiiGuardMe) )
				{
					if ( finalDamage > playerSlvCritDmg )
					{
						finalDamage = ClampF( finalDamage, 0, playerSlvCritDmg );
						finalDamage = MaxF(actorVictim.GetMaxHealth() * 0.01, finalDamage);
					}
					if ( action.IsActionMelee() )
					{
						
						if ( finalDamage < playerSlvDmg && actorVictim.UsesEssence() )
						{
							finalDamage = ClampF( finalDamage, playerSlvDmg, finalDamage );
						}
						else if ( finalDamage < playerStlDmg )
						{
							finalDamage = ClampF( finalDamage, playerStlDmg, finalDamage );
						}
					}
				}
				else
				{
					finalDamage = ClampF( finalDamage, 0, playerStlDmg );
					finalDamage = MaxF(actorVictim.GetMaxHealth() * 0.01, finalDamage);
				}
			}
		
			
			if(thePlayer.GetBossTag() != '' || (W3MonsterHuntNPC)actorVictim || actorVictim.GetCharacterStats().HasAbilityWithTag('Boss') || actorVictim.HasAbility( 'Boss' ) || actorVictim.HasAbility( 'SkillBoss') )
			{
				finalDamage = ClampF(finalDamage, 0, actorVictim.GetMaxHealth() * 0.005);
			}
		}
		if(actorAttacker.HasBuff(EET_AxiiGuardMe))
		{
			switch(GetWitcherPlayer().GetSkillLevel(S_Magic_s05))
			{
				case 3: 
					finalDamage *= 1.6;	
					break;
				case 2: 
					finalDamage *= 1.4;	
					break;
				case 1: 
					finalDamage *= 1.2;	
					break;
			}
		}
		
	
		
		if(dmgInfo.dmgType == theGame.params.DAMAGE_NAME_FIRE && finalDamage > 0)
			action.SetDealtFireDamage(true);
			
		if( playerAttacker && thePlayer.IsWeaponHeld('fist') && !thePlayer.IsInFistFightMiniGame() && action.IsActionMelee() )
		{
			if(FactsQuerySum("NewGamePlus") > 0)
			{fistfightDamageMult = thePlayer.GetLevel()* 0.1;}
			else
			{fistfightDamageMult = thePlayer.GetLevel()* 0.05;}
			
			finalDamage *= ( 1+fistfightDamageMult );
		}
		
		if(playerAttacker && attackAction && playerAttacker.IsHeavyAttack(attackAction.GetAttackName()))
			finalDamage *= 1.833;
			
		
		burning = (W3Effect_Burning)action.causer;
		if(actorVictim && (((W3IgniEntity)action.causer) || ((W3IgniProjectile)action.causer) || ( burning && burning.IsSignEffect())) )
		{
			min = actorVictim.GetAttributeValue('igni_damage_amplifier');
			finalDamage = finalDamage * (1 + min.valueMultiplicative) + min.valueAdditive;
		}
		
		
		
		
		if ( theGame.CanLog() )
		{
			LogDMHits("Single hit damage: initial damage = " + NoTrailZeros(dmgInfo.dmgVal), action);
			LogDMHits("Single hit damage: attack_power = base: " + NoTrailZeros(powerMod.valueBase) + ", mult: " + NoTrailZeros(powerMod.valueMultiplicative) + ", add: " + NoTrailZeros(powerMod.valueAdditive), action );
			if(action.IsPointResistIgnored())
				LogDMHits("Single hit damage: resistance pts and armor = IGNORED", action);
			else
				LogDMHits("Single hit damage: resistance pts and armor = " + NoTrailZeros(resistPoints), action);			
			LogDMHits("Single hit damage: resistance perc = " + NoTrailZeros(resistPercents * 100), action);
			LogDMHits("Single hit damage: final damage to sustain = " + NoTrailZeros(finalDamage), action);
		}
		
		
		if( playerVictim && actorAttacker && FactsQuerySum("NewGamePlus") > 0)
			finalDamage *= 1.1;
		
			
		return finalDamage;
	}
	
	
	private function ProcessActionDamage_DealDamage()
	{
		var logStr : string;
		var hpPerc : float;
		var npcVictim : CNewNPC;
	
		
		if ( theGame.CanLog() )
		{
			logStr = "";
			if(action.processedDmg.vitalityDamage > 0)			logStr += NoTrailZeros(action.processedDmg.vitalityDamage) + " vitality, ";
			if(action.processedDmg.essenceDamage > 0)			logStr += NoTrailZeros(action.processedDmg.essenceDamage) + " essence, ";
			if(action.processedDmg.staminaDamage > 0)			logStr += NoTrailZeros(action.processedDmg.staminaDamage) + " stamina, ";
			if(action.processedDmg.moraleDamage > 0)			logStr += NoTrailZeros(action.processedDmg.moraleDamage) + " morale";
				
			if(logStr == "")
				logStr = "NONE";
			LogDMHits("Final damage to sustain is: " + logStr, action);
		}
				
		
		if(actorVictim)
		{
			hpPerc = actorVictim.GetHealthPercents();
			
			
			if(actorVictim.IsAlive())
			{
				npcVictim = (CNewNPC)actorVictim;
				if(npcVictim && npcVictim.IsHorse())
				{
					npcVictim.GetHorseComponent().OnTakeDamage(action);
				}
				else
				{
					actorVictim.OnTakeDamage(action);
				}
			}
			
			if(!actorVictim.IsAlive() && hpPerc == 1)
				action.SetWasKilledBySingleHit();
		}
			
		if ( theGame.CanLog() )
		{
			LogDMHits("", action);
			LogDMHits("Target stats after damage dealt are:", action);
			if(actorVictim)
			{
				if( actorVictim.UsesVitality())						LogDMHits("Vitality = " + NoTrailZeros( actorVictim.GetStat(BCS_Vitality)), action);
				if( actorVictim.UsesEssence())						LogDMHits("Essence = "  + NoTrailZeros( actorVictim.GetStat(BCS_Essence)), action);
				if( actorVictim.GetStatMax(BCS_Stamina) > 0)		LogDMHits("Stamina = "  + NoTrailZeros( actorVictim.GetStat(BCS_Stamina, true)), action);
				if( actorVictim.GetStatMax(BCS_Morale) > 0)			LogDMHits("Morale = "   + NoTrailZeros( actorVictim.GetStat(BCS_Morale)), action);
			}
			else
			{
				LogDMHits("Undefined - victim is not a CActor and therefore has no stats", action);
			}
		}
	}
	
	
	private function ProcessActionDamage_ReduceDurability()
	{		
		var witcherPlayer : W3PlayerWitcher;
		var dbg_currDur, dbg_prevDur1, dbg_prevDur2, dbg_prevDur3, dbg_prevDur4, dbg_prevDur : float;
		var dbg_armor, dbg_pants, dbg_boots, dbg_gloves, reducedItemId, weapon : SItemUniqueId;
		var slot : EEquipmentSlots;
		var weapons : array<SItemUniqueId>;
		var armorStringName : string;
		var canLog, playerHasSword : bool;
		var i : int;
		
		canLog = theGame.CanLog();

		witcherPlayer = GetWitcherPlayer();
	
		
		if ( playerAttacker && playerAttacker.inv.IsIdValid( weaponId ) && playerAttacker.inv.HasItemDurability( weaponId ) )
		{		
			dbg_prevDur = playerAttacker.inv.GetItemDurability(weaponId);
						
			if ( playerAttacker.inv.ReduceItemDurability(weaponId) && canLog )
			{
				LogDMHits("", action);
				LogDMHits("Player's weapon durability changes from " + NoTrailZeros(dbg_prevDur) + " to " + NoTrailZeros(action.attacker.GetInventory().GetItemDurability(weaponId)), action );
			}
		}
		
		else if(playerVictim && attackAction && attackAction.IsActionMelee() && (attackAction.IsParried() || attackAction.IsCountered()) )
		{
			weapons = playerVictim.inv.GetHeldWeapons();
			playerHasSword = false;
			for(i=0; i<weapons.Size(); i+=1)
			{
				weapon = weapons[i];
				if(playerVictim.inv.IsIdValid(weapon) && (playerVictim.inv.IsItemSteelSwordUsableByPlayer(weapon) || playerVictim.inv.IsItemSilverSwordUsableByPlayer(weapon)) )
				{
					playerHasSword = true;
					break;
				}
			}
			
			if(playerHasSword)
			{
				playerVictim.inv.ReduceItemDurability(weapon);
			}
		}
		
		else if(action.victim == witcherPlayer && (action.IsActionMelee() || action.IsActionRanged()) && action.DealsAnyDamage())
		{
			
			if ( canLog )
			{
				if ( witcherPlayer.GetItemEquippedOnSlot(EES_Armor, dbg_armor) )
					dbg_prevDur1 = action.victim.GetInventory().GetItemDurability(dbg_armor);
				else
					dbg_prevDur1 = 0;
					
				if ( witcherPlayer.GetItemEquippedOnSlot(EES_Pants, dbg_pants) )
					dbg_prevDur2 = action.victim.GetInventory().GetItemDurability(dbg_pants);
				else
					dbg_prevDur2 = 0;
					
				if ( witcherPlayer.GetItemEquippedOnSlot(EES_Boots, dbg_boots) )
					dbg_prevDur3 = action.victim.GetInventory().GetItemDurability(dbg_boots);
				else
					dbg_prevDur3 = 0;
					
				if ( witcherPlayer.GetItemEquippedOnSlot(EES_Gloves, dbg_gloves) )
					dbg_prevDur4 = action.victim.GetInventory().GetItemDurability(dbg_gloves);
				else
					dbg_prevDur4 = 0;
			}
			
			slot = GetWitcherPlayer().ReduceArmorDurability();
			
			
			if( canLog )
			{
				LogDMHits("", action);
				if(slot != EES_InvalidSlot)
				{		
					switch(slot)
					{
						case EES_Armor : 
							armorStringName = "chest armor";
							reducedItemId = dbg_armor;
							dbg_prevDur = dbg_prevDur1;
							break;
						case EES_Pants : 
							armorStringName = "pants";
							reducedItemId = dbg_pants;
							dbg_prevDur = dbg_prevDur2;
							break;
						case EES_Boots :
							armorStringName = "boots";
							reducedItemId = dbg_boots;
							dbg_prevDur = dbg_prevDur3;
							break;
						case EES_Gloves :
							armorStringName = "gloves";
							reducedItemId = dbg_gloves;
							dbg_prevDur = dbg_prevDur4;
							break;
					}
					
					dbg_currDur = action.victim.GetInventory().GetItemDurability(reducedItemId);
					LogDMHits("", action);
					LogDMHits("Player's <<" + armorStringName + ">> durability changes from " + NoTrailZeros(dbg_prevDur) + " to " + NoTrailZeros(dbg_currDur), action );
				}
				else
				{
					LogDMHits("Tried to reduce player's armor durability but failed", action);
				}
			}
				
			
			if(slot != EES_InvalidSlot)
				thePlayer.inv.ReduceItemRepairObjectBonusCharge(reducedItemId);
		}
	}	
	
	
	
	
	
	
	private function ProcessActionReaction(wasFrozen : bool, wasAlive : bool)
	{
		var dismemberExplosion 			: bool;
		var damageName 					: name;
		var damage 						: array<SRawDamage>;
		var points, percents, hp, dmg 	: float;
		var counterAction 				: W3DamageAction;		
		var moveTargets					: array<CActor>;
		var i 							: int;
		var canPerformFinisher			: bool;
		var weaponName					: name;
		var npcVictim					: CNewNPC;
		var toxicCloud					: W3ToxicCloud;
		var playsNonAdditiveAnim		: bool;
		var bleedCustomEffect 			: SCustomEffectParams;
		
		
		var min, max 					: SAbilityAttributeValue;
		var minDmg 						: float;
		
		
		if(!actorVictim)
			return;
		
		npcVictim = (CNewNPC)actorVictim;
		
		canPerformFinisher = CanPerformFinisher(actorVictim);
		
		if( actorVictim.IsAlive() && !canPerformFinisher )
		{
			
			if(!action.IsDoTDamage() && action.DealtDamage())
			{
				if ( actorAttacker && npcVictim)
				{
					npcVictim.NoticeActorInGuardArea( actorAttacker );
				}

				
				if ( !playerVictim )
					actorVictim.RemoveAllBuffsOfType(EET_Confusion);
				
				
				if(playerAttacker && action.IsActionMelee() && !playerAttacker.GetInventory().IsItemFists(weaponId) && playerAttacker.IsLightAttack(attackAction.GetAttackName()) && playerAttacker.CanUseSkill(S_Sword_s05))
				{
					bleedCustomEffect.effectType = EET_Bleeding;
					bleedCustomEffect.creator = playerAttacker;
					bleedCustomEffect.sourceName = SkillEnumToName(S_Sword_s05);
					
					
					
					theGame.GetDefinitionsManager().GetAbilityAttributeValue( 'BleedingEffect', 'DirectDamage', min, max );
					bleedCustomEffect.effectValue = min;
					minDmg = CalculateAttributeValue(playerAttacker.GetSkillAttributeValue(S_Sword_s05, 'dmg_per_sec', false, true)) * playerAttacker.GetSkillLevel(S_Sword_s05);
					dmg = bleedCustomEffect.effectValue.valueAdditive + (bleedCustomEffect.effectValue.valueMultiplicative * actorVictim.GetMaxHealth());
					
					if ( dmg < minDmg )
					{
						bleedCustomEffect.effectValue.valueAdditive += minDmg - dmg;
					}
					
					
					
					actorVictim.AddEffectCustom(bleedCustomEffect);
				}
			}
			
			
			if(actorVictim && wasAlive)
			{
				playsNonAdditiveAnim = actorVictim.ReactToBeingHit( action );
			}				
		}
		else
		{
			
			if( !canPerformFinisher && CanDismember( wasFrozen, dismemberExplosion, weaponName ) )
			{
				ProcessDismemberment(wasFrozen, dismemberExplosion);
				toxicCloud = (W3ToxicCloud)action.causer;
				
				if(toxicCloud && toxicCloud.HasExplodingTargetDamages())
					ProcessToxicCloudDismemberExplosion(toxicCloud.GetExplodingTargetDamages());
					
				
				if(IsRequiredAttitudeBetween(thePlayer, action.victim, true))
				{
					moveTargets = thePlayer.GetMoveTargets();
					for ( i = 0; i < moveTargets.Size(); i += 1 )
					{
						if ( moveTargets[i].IsHuman() )
							moveTargets[i].DrainMorale(20.f);
					}
				}
			}
			
			else if ( canPerformFinisher )
			{
				if ( actorVictim.IsAlive() )
					actorVictim.Kill( 'Finisher', false, thePlayer );
					
				thePlayer.AddTimer( 'DelayedFinisherInputTimer', 0.1f );
				thePlayer.SetFinisherVictim( actorVictim );
				thePlayer.CleanCombatActionBuffer();
				thePlayer.OnBlockAllCombatTickets( true );
				
				if( actorVictim.WillBeUnconscious() )
				{
					actorVictim.SetBehaviorVariable( 'prepareForUnconsciousFinisher', 1.0f );
					actorVictim.ActionRotateToAsync( thePlayer.GetWorldPosition() );
				}
				
				moveTargets = thePlayer.GetMoveTargets();
				
				for ( i = 0; i < moveTargets.Size(); i += 1 )
				{
					if ( actorVictim != moveTargets[i] )
						moveTargets[i].SignalGameplayEvent( 'InterruptChargeAttack' );
				}	
				
				if 	( 	theGame.GetInGameConfigWrapper().GetVarValue('Gameplay', 'AutomaticFinishersEnabled' ) == "true" 
					|| ( (W3PlayerWitcher)playerAttacker && GetWitcherPlayer().IsMutationActive( EPMT_Mutation3 ) ) 
					||	actorVictim.WillBeUnconscious()
					)
				{
					actorVictim.AddAbility( 'ForceFinisher', false );
				}
				
				if ( actorVictim.HasTag( 'ForceFinisher' ) )
					actorVictim.AddAbility( 'ForceFinisher', false );
				
				actorVictim.SignalGameplayEvent( 'ForceFinisher' );
			} 
			else if ( weaponName == 'fists' && npcVictim )
			{
				npcVictim.DisableAgony();	
			}
			
			thePlayer.FindMoveTarget();
		}
		
		if( attackAction.IsActionMelee() )
		{
			actorAttacker.SignalGameplayEventParamObject( 'HitActionReaction', actorVictim );
			actorVictim.OnHitActionReaction( actorAttacker, weaponName );
		}
		
		
		actorVictim.ProcessHitSound(action, playsNonAdditiveAnim || !actorVictim.IsAlive());
		
		
		
		if(action.IsCriticalHit() && action.DealtDamage() && !actorVictim.IsAlive() && actorAttacker == thePlayer )
			GCameraShake( 0.5, true, actorAttacker.GetWorldPosition(), 10 );
		
		
		if( attackAction && npcVictim && npcVictim.IsShielded( actorAttacker ) && attackAction.IsParried() && attackAction.GetAttackName() == 'attack_heavy' &&  npcVictim.GetStaminaPercents() <= 0.1 )
		{
			npcVictim.ProcessShieldDestruction();
		}
		
		
		if( actorVictim && action.CanPlayHitParticle() && ( action.DealsAnyDamage() || (attackAction && attackAction.IsParried()) ) )
			actorVictim.PlayHitEffect(action);
			

		if( action.victim.HasAbility('mon_nekker_base') && !actorVictim.CanPlayHitAnim() && !((CBaseGameplayEffect) action.causer) ) 
		{
			
			actorVictim.PlayEffect(theGame.params.LIGHT_HIT_FX);
			actorVictim.SoundEvent("cmb_play_hit_light");
		}
			
		
		if(actorVictim && playerAttacker && action.IsActionMelee() && thePlayer.inv.IsItemFists(weaponId) )
		{
			actorVictim.SignalGameplayEvent( 'wasHitByFists' );	
				
			if(MonsterCategoryIsMonster(victimMonsterCategory))
			{
				if(!victimCanBeHitByFists)
				{
					playerAttacker.ReactToReflectedAttack(actorVictim);
				}
				else
				{			
					actorVictim.GetResistValue(CDS_PhysicalRes, points, percents);
				
					if(percents >= theGame.params.MONSTER_RESIST_THRESHOLD_TO_REFLECT_FISTS)
						playerAttacker.ReactToReflectedAttack(actorVictim);
				}
			}			
		}
		
		
		ProcessSparksFromNoDamage();
		
		
		if(attackAction && attackAction.IsActionMelee() && actorAttacker && playerVictim && attackAction.IsCountered() && playerVictim == GetWitcherPlayer())
		{
			GetWitcherPlayer().SetRecentlyCountered(true);
		}
		
		
		
		
		if(attackAction && !action.IsDoTDamage() && (playerAttacker || playerVictim) && (attackAction.IsParried() || attackAction.IsCountered()) )
		{
			theGame.VibrateControllerLight();
		}
	}
	
	private function CanDismember( wasFrozen : bool, out dismemberExplosion : bool, out weaponName : name ) : bool
	{
		var dismember			: bool;
		var dismemberChance 	: int;
		var petard 				: W3Petard;
		var bolt 				: W3BoltProjectile;
		var arrow 				: W3ArrowProjectile;
		var inv					: CInventoryComponent;
		var toxicCloud			: W3ToxicCloud;
		var witcher				: W3PlayerWitcher;
		var i					: int;
		var secondaryWeapon		: bool;

		petard = (W3Petard)action.causer;
		bolt = (W3BoltProjectile)action.causer;
		arrow = (W3ArrowProjectile)action.causer;
		toxicCloud = (W3ToxicCloud)action.causer;
		
		dismemberExplosion = false;
		
		if(playerAttacker)
		{
			secondaryWeapon = playerAttacker.inv.ItemHasTag( weaponId, 'SecondaryWeapon' ) || playerAttacker.inv.ItemHasTag( weaponId, 'Wooden' );
		}
		
		if( actorVictim.HasAbility( 'DisableDismemberment' ) )
		{
			dismember = false;
		}
		else if( actorVictim.HasTag( 'DisableDismemberment' ) )
		{
			dismember = false;
		}
		else if (actorVictim.WillBeUnconscious())
		{
			dismember = false;		
		}
		else if (playerAttacker && secondaryWeapon )
		{
			dismember = false;
		}
		else if( arrow && !wasFrozen )
		{
			dismember = false;
		}		
		else if( actorAttacker.HasAbility( 'ForceDismemberment' ) )
		{
			dismember = true;
			dismemberExplosion = action.HasForceExplosionDismemberment();
		}
		else if(wasFrozen)
		{
			dismember = true;
			dismemberExplosion = action.HasForceExplosionDismemberment();
		}						
		else if( (petard && petard.DismembersOnKill()) || (bolt && bolt.DismembersOnKill()) )
		{
			dismember = true;
			dismemberExplosion = action.HasForceExplosionDismemberment();
		}
		else if( (W3Effect_YrdenHealthDrain)action.causer )
		{
			dismember = true;
			dismemberExplosion = true;
		}
		else if(toxicCloud && toxicCloud.HasExplodingTargetDamages())
		{
			dismember = true;
			dismemberExplosion = true;
		}
		else
		{
			inv = actorAttacker.GetInventory();
			weaponName = inv.GetItemName( weaponId );
			
			if( attackAction 
				&& !inv.IsItemSteelSwordUsableByPlayer(weaponId) 
				&& !inv.IsItemSilverSwordUsableByPlayer(weaponId) 
				&& weaponName != 'polearm'
				&& weaponName != 'fists_lightning' 
				&& weaponName != 'fists_fire' )
			{
				dismember = false;
			}			
			else if ( action.IsCriticalHit() )
			{
				dismember = true;
				dismemberExplosion = action.HasForceExplosionDismemberment();
			}
			else if ( action.HasForceExplosionDismemberment() )
			{
				dismember = true;
				dismemberExplosion = true;
			}
			
			else if ( weaponName == 'fists_lightning' || weaponName == 'fists_fire' )
			{
				if(RandRange(100) > 75)
					dismember = true;
			}
			
			else
			{
				
				dismemberChance = theGame.params.DISMEMBERMENT_ON_DEATH_CHANCE;
				
				
				if(playerAttacker && playerAttacker.forceDismember)
				{
					dismemberChance = thePlayer.forceDismemberChance;
					dismemberExplosion = thePlayer.forceDismemberExplosion;
				}
				
				
				if(attackAction)
				{
					dismemberChance += RoundMath(100 * CalculateAttributeValue(inv.GetItemAttributeValue(weaponId, 'dismember_chance')));
					dismemberExplosion = attackAction.HasForceExplosionDismemberment();
				}
					
				
				witcher = (W3PlayerWitcher)actorAttacker;
				if(witcher && witcher.CanUseSkill(S_Perk_03))
					dismemberChance += RoundMath(100 * CalculateAttributeValue(witcher.GetSkillAttributeValue(S_Perk_03, 'dismember_chance', false, true)));
				
				
				if( ( W3PlayerWitcher )playerAttacker && attackAction.IsActionMelee() && GetWitcherPlayer().IsMutationActive(EPMT_Mutation3) )	
				{
					if( thePlayer.inv.IsItemSteelSwordUsableByPlayer( weaponId ) || thePlayer.inv.IsItemSilverSwordUsableByPlayer( weaponId ) )
					{
						dismemberChance = 100;
					}
				}
				
				dismemberChance = Clamp(dismemberChance, 0, 100);
				
				if (RandRange(100) < dismemberChance)
					dismember = true;
				else
					dismember = false;
			}
		}		

		return dismember;
	}	
	
	private function CanPerformFinisher( actorVictim : CActor ) : bool
	{
		var finisherChance 			: int;
		var areEnemiesAttacking		: bool;
		var i						: int;
		var victimToPlayerVector, playerPos	: Vector;
		var item 					: SItemUniqueId;
		var moveTargets				: array<CActor>;
		var b						: bool;
		var size					: int;
		var npc						: CNewNPC;
		
		if ( (W3ReplacerCiri)thePlayer || playerVictim || thePlayer.isInFinisher )
			return false;
		
		if ( actorVictim.IsAlive() && !CanPerformFinisherOnAliveTarget(actorVictim) )
			return false;
		
		
		if ( actorVictim.WillBeUnconscious() && !theGame.GetDLCManager().IsEP2Available() )
			return false;
		
		moveTargets = thePlayer.GetMoveTargets();	
		size = moveTargets.Size();
		playerPos = thePlayer.GetWorldPosition();
	
		if ( size > 0 )
		{
			areEnemiesAttacking = false;			
			for(i=0; i<size; i+=1)
			{
				npc = (CNewNPC)moveTargets[i];
				if(npc && VecDistanceSquared(playerPos, moveTargets[i].GetWorldPosition()) < 7 && npc.IsAttacking() && npc != actorVictim )
				{
					areEnemiesAttacking = true;
					break;
				}
			}
		}
		
		victimToPlayerVector = actorVictim.GetWorldPosition() - playerPos;
		
		if ( actorVictim.IsHuman() )
		{
			npc = (CNewNPC)actorVictim;
			if ( ( size <= 1 && theGame.params.FINISHER_ON_DEATH_CHANCE > 0 ) || ( actorVictim.HasAbility('ForceFinisher') ) || ( GetWitcherPlayer().IsMutationActive(EPMT_Mutation3) ) )
			{
				finisherChance = 100;
			}
			else if ( ( actorVictim.HasBuff(EET_Confusion) || actorVictim.HasBuff(EET_AxiiGuardMe) ) )
			{
				finisherChance = 75 + ( - ( npc.currentLevel - thePlayer.GetLevel() ) );
			}
			else if ( npc.currentLevel - thePlayer.GetLevel() < -5 )
			{
				finisherChance = theGame.params.FINISHER_ON_DEATH_CHANCE + ( - ( npc.currentLevel - thePlayer.GetLevel() ) );
			}
			else
				finisherChance = theGame.params.FINISHER_ON_DEATH_CHANCE;
				
			finisherChance = Clamp(finisherChance, 0, 100);
		}
		else 
			finisherChance = 0;	
			
		if ( actorVictim.HasTag('ForceFinisher') )
		{
			finisherChance = 100;
			areEnemiesAttacking = false;
		}
			
		item = thePlayer.inv.GetItemFromSlot( 'l_weapon' );	
		
		if ( thePlayer.forceFinisher )
		{
			b = playerAttacker && attackAction && attackAction.IsActionMelee();
			b = b && ( actorVictim.IsHuman() && !actorVictim.IsWoman() );
			b =	b && !thePlayer.IsInAir();
			b =	b && ( thePlayer.IsWeaponHeld( 'steelsword') || thePlayer.IsWeaponHeld( 'silversword') );
			b = b && !thePlayer.IsSecondaryWeaponHeld();
			b =	b && !thePlayer.inv.IsIdValid( item );
			b =	b && !actorVictim.IsKnockedUnconscious();
			b =	b && !actorVictim.HasBuff( EET_Knockdown );
			b =	b && !actorVictim.HasBuff( EET_Ragdoll );
			b =	b && !actorVictim.HasBuff( EET_Frozen );
			b =	b && !actorVictim.HasAbility( 'DisableFinishers' );
			b =	b && !thePlayer.IsUsingVehicle();
			b =	b && thePlayer.IsAlive();
			b =	b && !thePlayer.IsCurrentSignChanneled();
		}
		else
		{
			b = playerAttacker && attackAction && attackAction.IsActionMelee();
			b = b && ( actorVictim.IsHuman() && !actorVictim.IsWoman() );
			b =	b && RandRange(100) < finisherChance;
			b =	b && !areEnemiesAttacking;
			b =	b && AbsF( victimToPlayerVector.Z ) < 0.4f;
			b =	b && !thePlayer.IsInAir();
			b =	b && ( thePlayer.IsWeaponHeld( 'steelsword') || thePlayer.IsWeaponHeld( 'silversword') );
			b = b && !thePlayer.IsSecondaryWeaponHeld();
			b =	b && !thePlayer.inv.IsIdValid( item );
			b =	b && !actorVictim.IsKnockedUnconscious();
			b =	b && !actorVictim.HasBuff( EET_Knockdown );
			b =	b && !actorVictim.HasBuff( EET_Ragdoll );
			b =	b && !actorVictim.HasBuff( EET_Frozen );
			b =	b && !actorVictim.HasAbility( 'DisableFinishers' );
			b =	b && actorVictim.GetAttitude( thePlayer ) == AIA_Hostile;
			b =	b && !thePlayer.IsUsingVehicle();
			b =	b && thePlayer.IsAlive();
			b =	b && !thePlayer.IsCurrentSignChanneled();
			b =	b && ( theGame.GetWorld().NavigationCircleTest( actorVictim.GetWorldPosition(), 2.f ) || actorVictim.HasTag('ForceFinisher') ) ;
			
		}

		if ( b  )
		{
			if ( !actorVictim.IsAlive() && !actorVictim.WillBeUnconscious() )
				actorVictim.AddAbility( 'DisableFinishers', false );
				
			return true;
		}
		
		return false;
	}
	
	private function CanPerformFinisherOnAliveTarget( actorVictim : CActor ) : bool
	{
		return actorVictim.IsHuman() 
		&& ( actorVictim.HasBuff(EET_Confusion) || actorVictim.HasBuff(EET_AxiiGuardMe) )
		&& actorVictim.IsVulnerable()
		&& !actorVictim.HasAbility('DisableFinisher')
		&& !actorVictim.HasAbility('InstantKillImmune');
	}
	
	
	
	
	
	
	private function ProcessActionBuffs() : bool
	{
		var inv : CInventoryComponent;
		var ret : bool;
	
		
		if(!action.victim.IsAlive() || action.WasDodged() || (attackAction && attackAction.IsActionMelee() && !attackAction.ApplyBuffsIfParried() && attackAction.CanBeParried() && attackAction.IsParried()) )
			return true;
			
		
		ApplyQuenBuffChanges();
	
		
		if( actorAttacker == thePlayer && action.IsActionWitcherSign() && action.IsCriticalHit() && GetWitcherPlayer().IsMutationActive( EPMT_Mutation2 ) && action.HasBuff( EET_Burning ) )
		{
			action.SetBuffSourceName( 'Mutation2ExplosionValid' );
		}
	
		
		if(actorVictim && action.GetEffectsCount() > 0)
			ret = actorVictim.ApplyActionEffects(action);
		else
			ret = false;
			
		
		if(actorAttacker && actorVictim)
		{
			inv = actorAttacker.GetInventory();
			actorAttacker.ProcessOnHitEffects(actorVictim, inv.IsItemSilverSwordUsableByPlayer(weaponId), inv.IsItemSteelSwordUsableByPlayer(weaponId), action.IsActionWitcherSign() );
		}
		
		return ret;
	}
	
	
	private function ApplyQuenBuffChanges()
	{
		var npc : CNewNPC;
		var protection : bool;
		var witcher : W3PlayerWitcher;
		var quenEntity : W3QuenEntity;
		var i : int;
		var buffs : array<EEffectType>;
	
		if(!actorVictim || !actorVictim.HasAlternateQuen())
			return;
		
		npc = (CNewNPC)actorVictim;
		if(npc)
		{
			if(!action.DealsAnyDamage())
				protection = true;
		}
		else
		{
			witcher = (W3PlayerWitcher)actorVictim;
			if(witcher)
			{
				quenEntity = (W3QuenEntity)witcher.GetCurrentSignEntity();
				if(quenEntity.GetBlockedAllDamage())
				{
					protection = true;
				}
			}
		}
		
		if(!protection)
			return;
			
		action.GetEffectTypes(buffs);
		for(i=buffs.Size()-1; i>=0; i -=1)
		{
			if(buffs[i] == EET_KnockdownTypeApplicator || IsKnockdownEffectType(buffs[i]))
				continue;
				
			action.RemoveBuff(i);
		}
	}
	
	
	
	
	private function ProcessDismemberment(wasFrozen : bool, dismemberExplosion : bool )
	{
		var hitDirection		: Vector;
		var usedWound			: name;
		var npcVictim			: CNewNPC;
		var wounds				: array< name >;
		var i					: int;
		var petard 				: W3Petard;
		var bolt 				: W3BoltProjectile;		
		var forcedRagdoll		: bool;
		var isExplosion			: bool;
		var dismembermentComp 	: CDismembermentComponent;
		var specialWounds		: array< name >;
		var useHitDirection		: bool;
		var fxMask				: EDismembermentEffectTypeFlags;
		var template			: CEntityTemplate;
		var ent					: CEntity;
		var signType			: ESignType;
		
		if(!actorVictim)
			return;
			
		dismembermentComp = (CDismembermentComponent)(actorVictim.GetComponentByClassName( 'CDismembermentComponent' ));
		if(!dismembermentComp)
			return;
			
		if(wasFrozen)
		{
			ProcessFrostDismemberment();
			return;
		}
		
		forcedRagdoll = false;
		
		
		petard = (W3Petard)action.causer;
		bolt = (W3BoltProjectile)action.causer;
		
		if( dismemberExplosion || (attackAction && ( attackAction.GetAttackName() == 'attack_explosion' || attackAction.HasForceExplosionDismemberment() ))
			|| (petard && petard.DismembersOnKill()) || (bolt && bolt.DismembersOnKill()) )
		{
			isExplosion = true;
		}
		else
		{
			isExplosion = false;
		}
		
		
		if(playerAttacker && thePlayer.forceDismember && IsNameValid(thePlayer.forceDismemberName))
		{
			usedWound = thePlayer.forceDismemberName;
		}
		else
		{	
			
			if(isExplosion)
			{
				dismembermentComp.GetWoundsNames( wounds, WTF_Explosion );	

				
				if( action.IsMutation2PotentialKill() )
				{
					
					for( i=wounds.Size()-1; i>=0; i-=1 )
					{
						if( !StrContains( wounds[ i ], "_ep2" ) )
						{
							wounds.EraseFast( i );
						}
					}
					
					signType = action.GetSignType();
					if( signType == ST_Aard )
					{
						fxMask = DETF_Aaard;
					}
					else if( signType == ST_Igni )
					{
						fxMask = DETF_Igni;
					}
					else if( signType == ST_Yrden )
					{
						fxMask = DETF_Yrden;
					}
					else if( signType == ST_Quen )
					{
						fxMask = DETF_Quen;
					}
				}
				else
				{
					fxMask = 0;
				}
				
				if ( wounds.Size() > 0 )
					usedWound = wounds[ RandRange( wounds.Size() ) ];
					
				if ( usedWound )
					StopVO( actorVictim ); 
			}
			else if(attackAction || action.GetBuffSourceName() == "riderHit")
			{
				if  ( attackAction.GetAttackTypeName() == 'sword_s2' || thePlayer.isInFinisher )
					useHitDirection = true;
				
				if ( useHitDirection ) 
				{
					hitDirection = actorAttacker.GetSwordTipMovementFromAnimation( attackAction.GetAttackAnimName(), attackAction.GetHitTime(), 0.1, attackAction.GetWeaponEntity() );
					usedWound = actorVictim.GetNearestWoundForBone( attackAction.GetHitBoneIndex(), hitDirection, WTF_Cut );
				}
				else
				{			
					
					dismembermentComp.GetWoundsNames( wounds );
					
					
					if(wounds.Size() > 0)
					{
						dismembermentComp.GetWoundsNames( specialWounds, WTF_Explosion );
						for ( i = 0; i < specialWounds.Size(); i += 1 )
						{
							wounds.Remove( specialWounds[i] );
						}
						
						if(wounds.Size() > 0)
						{
							
							dismembermentComp.GetWoundsNames( specialWounds, WTF_Frost );
							for ( i = 0; i < specialWounds.Size(); i += 1 )
							{
								wounds.Remove( specialWounds[i] );
							}
							
							
							if ( wounds.Size() > 0 )
								usedWound = wounds[ RandRange( wounds.Size() ) ];
						}
					}
				}
			}
		}
		
		if ( usedWound )
		{
			npcVictim = (CNewNPC)action.victim;
			if(npcVictim)
				npcVictim.DisableAgony();			
			
			actorVictim.SetDismembermentInfo( usedWound, actorVictim.GetWorldPosition() - actorAttacker.GetWorldPosition(), forcedRagdoll, fxMask );
			actorVictim.AddTimer( 'DelayedDismemberTimer', 0.05f );
			actorVictim.SetBehaviorVariable( 'dismemberAnim', 1.0 );
			
			
			if ( usedWound == 'explode_02' || usedWound == 'explode2' || usedWound == 'explode_02_ep2' || usedWound == 'explode2_ep2')
			{
				ProcessDismembermentDeathAnim( usedWound, true, EFDT_LegLeft );
				actorVictim.SetKinematic( false );
				
			}
			else
			{
				ProcessDismembermentDeathAnim( usedWound, false );
			}
			
			
			if( usedWound == 'explode_01_ep2' || usedWound == 'explode1_ep2' || usedWound == 'explode_02_ep2' || usedWound == 'explode2_ep2' )
			{
				template = (CEntityTemplate) LoadResource( "explosion_dismember_force" );
				ent = theGame.CreateEntity( template, npcVictim.GetWorldPosition(), , , , true );
				ent.DestroyAfter( 5.f );
			}
			
			DropEquipmentFromDismember( usedWound, true, true );
			
			if( attackAction && actorAttacker == thePlayer )			
				GCameraShake( 0.5, true, actorAttacker.GetWorldPosition(), 10);
				
			if(playerAttacker)
				theGame.VibrateControllerHard();	
				
			
			if( dismemberExplosion && (W3AardProjectile)action.causer )
			{
				npcVictim.AddTimer( 'AardDismemberForce', 0.00001f );
			}
		}
		else
		{
			LogChannel( 'Dismemberment', "ERROR: No wound found to dismember on entity but entity supports dismemberment!!!" );
		}
	}
	
	function ApplyForce()
	{
		var size, i : int;
		var victim : CNewNPC;
		var fromPos, toPos : Vector;
		var comps : array<CComponent>;
		var impulse : Vector;
		
		victim = (CNewNPC)action.victim;
		toPos = victim.GetWorldPosition();
		toPos.Z += 1.0f;
		fromPos = toPos;
		fromPos.Z -= 2.0f;
		impulse = VecNormalize( toPos - fromPos.Z ) * 10;
		
		comps = victim.GetComponentsByClassName('CComponent');
		victim.GetVisualDebug().AddArrow( 'applyForce', fromPos, toPos, 1, 0.2f, 0.2f, true, Color( 0,0,255 ), true, 5.0f );
		size = comps.Size();
		for( i = 0; i < size; i += 1 )
		{
			comps[i].ApplyLocalImpulseToPhysicalObject( impulse );
		}
	}
	
	private function ProcessFrostDismemberment()
	{
		var dismembermentComp 	: CDismembermentComponent;
		var wounds				: array< name >;
		var wound				: name;
		var i, fxMask			: int;
		var npcVictim			: CNewNPC;
		
		dismembermentComp = (CDismembermentComponent)(actorVictim.GetComponentByClassName( 'CDismembermentComponent' ));
		if(!dismembermentComp)
			return;
		
		dismembermentComp.GetWoundsNames( wounds, WTF_Frost );
		
		
		
		if( theGame.GetDLCManager().IsEP2Enabled() )
		{
			fxMask = DETF_Mutation6;
			
			
			for( i=wounds.Size()-1; i>=0; i-=1 )
			{
				if( !StrContains( wounds[ i ], "_ep2" ) )
				{
					wounds.EraseFast( i );
				}
			}
		}
		else
		{
			fxMask = 0;
		}
		
		if ( wounds.Size() > 0 )
		{
			wound = wounds[ RandRange( wounds.Size() ) ];
		}
		else
		{
			return;
		}
		
		npcVictim = (CNewNPC)action.victim;
		if(npcVictim)
		{
			npcVictim.DisableAgony();
			StopVO( npcVictim );
		}
		
		actorVictim.SetDismembermentInfo( wound, actorVictim.GetWorldPosition() - actorAttacker.GetWorldPosition(), true, fxMask );
		actorVictim.AddTimer( 'DelayedDismemberTimer', 0.05f );
		if( wound == 'explode_02' || wound == 'explode2' || wound == 'explode_02_ep2' || wound == 'explode2_ep2' )
		{
			ProcessDismembermentDeathAnim( wound, true, EFDT_LegLeft );
			npcVictim.SetKinematic(false);
		}
		else
		{
			ProcessDismembermentDeathAnim( wound, false );
		}
		DropEquipmentFromDismember( wound, true, true );
		
		if( attackAction )			
			GCameraShake( 0.5, true, actorAttacker.GetWorldPosition(), 10);
			
		if(playerAttacker)
			theGame.VibrateControllerHard();	
	}
	
	
	private function ProcessDismembermentDeathAnim( nearestWound : name, forceDeathType : bool, optional deathType : EFinisherDeathType )
	{
		var dropCurveName : name;
		
		if ( forceDeathType )
		{
			if ( deathType == EFDT_Head )
				StopVO( actorVictim );
				
			actorVictim.SetBehaviorVariable( 'FinisherDeathType', (int)deathType );
			
			return;
		}
		
		dropCurveName = ( (CDismembermentComponent)(actorVictim.GetComponentByClassName( 'CDismembermentComponent' )) ).GetMainCurveName( nearestWound );
		
		if ( dropCurveName == 'head' )
		{
			actorVictim.SetBehaviorVariable( 'FinisherDeathType', (int)EFDT_Head );
			StopVO( actorVictim );
		}
		else if ( dropCurveName == 'torso_left' || dropCurveName == 'torso_right' || dropCurveName == 'torso' )
			actorVictim.SetBehaviorVariable( 'FinisherDeathType', (int)EFDT_Torso );
		else if ( dropCurveName == 'arm_right' )
			actorVictim.SetBehaviorVariable( 'FinisherDeathType', (int)EFDT_ArmRight );
		else if ( dropCurveName == 'arm_left' )
			actorVictim.SetBehaviorVariable( 'FinisherDeathType', (int)EFDT_ArmLeft );
		else if ( dropCurveName == 'leg_left' )
			actorVictim.SetBehaviorVariable( 'FinisherDeathType', (int)EFDT_LegLeft );
		else if ( dropCurveName == 'leg_right' )
			actorVictim.SetBehaviorVariable( 'FinisherDeathType', (int)EFDT_LegRight );
		else 
			actorVictim.SetBehaviorVariable( 'FinisherDeathType', (int)EFDT_None );
	}
	
	private function StopVO( actor : CActor )
	{
		actor.SoundEvent( "grunt_vo_death_stop", 'head' );
	}

	private function DropEquipmentFromDismember( nearestWound : name, optional dropLeft, dropRight : bool )
	{
		var dropCurveName : name;
		
		if( actorVictim.HasAbility( 'DontDropWeaponsOnDismemberment' ) )
		{
			return;
		}
		
		dropCurveName = ( (CDismembermentComponent)(actorVictim.GetComponentByClassName( 'CDismembermentComponent' )) ).GetMainCurveName( nearestWound );
		
		if ( ChangeHeldItemAppearance() )
		{
			actorVictim.SignalGameplayEvent('DropWeaponsInDeathTask');
			return;
		}
		
		if ( dropLeft || dropRight )
		{
			
			if ( dropLeft )
				actorVictim.DropItemFromSlot( 'l_weapon', true );
			
			if ( dropRight )
				actorVictim.DropItemFromSlot( 'r_weapon', true );			
			
			return;
		}
		
		if ( dropCurveName == 'arm_right' )
			actorVictim.DropItemFromSlot( 'r_weapon', true );
		else if ( dropCurveName == 'arm_left' )
			actorVictim.DropItemFromSlot( 'l_weapon', true );
		else if ( dropCurveName == 'torso_left' || dropCurveName == 'torso_right' || dropCurveName == 'torso' )
		{
			actorVictim.DropItemFromSlot( 'l_weapon', true );
			actorVictim.DropItemFromSlot( 'r_weapon', true );
		}			
		else if ( dropCurveName == 'head' || dropCurveName == 'leg_left' || dropCurveName == 'leg_right' )
		{
			if(  RandRange(100) < 50 )
				actorVictim.DropItemFromSlot( 'l_weapon', true );
			
			if(  RandRange(100) < 50 )
				actorVictim.DropItemFromSlot( 'r_weapon', true );
		} 
	}
	
	function ChangeHeldItemAppearance() : bool
	{
		var inv : CInventoryComponent;
		var weapon : SItemUniqueId;
		
		inv = actorVictim.GetInventory();
		
		weapon = inv.GetItemFromSlot('l_weapon');
		
		if ( inv.IsIdValid( weapon ) )
		{
			if ( inv.ItemHasTag(weapon,'bow') || inv.ItemHasTag(weapon,'crossbow') )
				inv.GetItemEntityUnsafe(weapon).ApplyAppearance("rigid");
			return true;
		}
		
		weapon = inv.GetItemFromSlot('r_weapon');
		
		if ( inv.IsIdValid( weapon ) )
		{
			if ( inv.ItemHasTag(weapon,'bow') || inv.ItemHasTag(weapon,'crossbow') )
				inv.GetItemEntityUnsafe(weapon).ApplyAppearance("rigid");
			return true;
		}
	
		return false;
	}
	
	
	private function GetOilProtectionAgainstMonster(dmgType : name, out resist : float, out reduct : float)
	{
		var i : int;
		var heldWeapons : array< SItemUniqueId >;
		var weapon : SItemUniqueId;
		
		resist = 0;
		reduct = 0;
		
		
		heldWeapons = thePlayer.inv.GetHeldWeapons();
		
		
		for( i=0; i<heldWeapons.Size(); i+=1 )
		{
			if( !thePlayer.inv.IsItemFists( heldWeapons[ i ] ) )
			{
				weapon = heldWeapons[ i ];
				break;
			}
		}
		
		
		if( !thePlayer.inv.IsIdValid( weapon ) )
		{
			return;
		}
	
		
		if( !thePlayer.inv.ItemHasActiveOilApplied( weapon, attackerMonsterCategory ) )
		{
			return;
		}
		
		resist = CalculateAttributeValue( thePlayer.GetSkillAttributeValue( S_Alchemy_s05, 'defence_bonus', false, true ) );		
	}
	
	
	private function ProcessToxicCloudDismemberExplosion(damages : array<SRawDamage>)
	{
		var act : W3DamageAction;
		var i, j : int;
		var ents : array<CGameplayEntity>;
		
		
		if(damages.Size() == 0)
		{
			LogAssert(false, "W3DamageManagerProcessor.ProcessToxicCloudDismemberExplosion: trying to process but no damages are passed! Aborting!");
			return;
		}		
		
		
		FindGameplayEntitiesInSphere(ents, action.victim.GetWorldPosition(), 3, 1000, , FLAG_OnlyAliveActors);
		
		
		for(i=0; i<ents.Size(); i+=1)
		{
			act = new W3DamageAction in this;
			act.Initialize(action.attacker, ents[i], action.causer, 'Dragons_Dream_3', EHRT_Heavy, CPS_Undefined, false, false, false, true);
			
			for(j=0; j<damages.Size(); j+=1)
			{
				act.AddDamage(damages[j].dmgType, damages[j].dmgVal);
			}
			
			theGame.damageMgr.ProcessAction(act);
			delete act;
		}
	}
	
	
	private final function ProcessSparksFromNoDamage()
	{
		var sparksEntity, weaponEntity : CEntity;
		var weaponTipPosition : Vector;
		var weaponSlotMatrix : Matrix;
		
		
		if(!playerAttacker || !attackAction || !attackAction.IsActionMelee() || attackAction.DealsAnyDamage())
			return;
		
		
		if( ( !attackAction.DidArmorReduceDamageToZero() && !actorVictim.IsVampire() && ( attackAction.IsParried() || attackAction.IsCountered() ) ) 
			|| ( ( attackAction.IsParried() || attackAction.IsCountered() ) && !actorVictim.IsHuman() && !actorVictim.IsVampire() )
			|| actorVictim.IsCurrentlyDodging() )
			return;
		
		
		if(actorVictim.HasTag('NoSparksOnArmorDmgReduced'))
			return;
		
		
		if (!actorVictim.GetGameplayVisibility())
			return;
		
		
		weaponEntity = playerAttacker.inv.GetItemEntityUnsafe(weaponId);
		weaponEntity.CalcEntitySlotMatrix( 'blood_fx_point', weaponSlotMatrix );
		weaponTipPosition = MatrixGetTranslation( weaponSlotMatrix );
		
		
		sparksEntity = theGame.CreateEntity( (CEntityTemplate)LoadResource( 'sword_colision_fx' ), weaponTipPosition );
		sparksEntity.PlayEffect('sparks');
	}
	
	private function ProcessPreHitModifications()
	{
		var fireDamage, totalDmg, maxHealth, currHealth : float;
		var attribute, min, max : SAbilityAttributeValue;
		var infusion : ESignType;
		var hack : array< SIgniEffects >;
		var dmgValTemp : float;
		var igni : W3IgniEntity;
		var quen : W3QuenEntity;

		if( actorVictim.HasAbility( 'HitWindowOpened' ) && !action.IsDoTDamage() )
		{
			if( actorVictim.HasTag( 'fairytale_witch' ) )
			{
				
				
				
				
				
				
					((CNewNPC)actorVictim).SetBehaviorVariable( 'shouldBreakFlightLoop', 1.0 );
				
			}
			else
			{
				quen = (W3QuenEntity)action.causer; 
			
				if( !quen )
				{
					if( actorVictim.HasTag( 'dettlaff_vampire' ) )
					{
						actorVictim.StopEffect( 'shadowdash' );
					}
					
					action.ClearDamage();
					if( action.IsActionMelee() )
					{
						actorVictim.PlayEffect( 'special_attack_break' );
					}
					actorVictim.SetBehaviorVariable( 'repelType', 0 );
					
					actorVictim.AddEffectDefault( EET_CounterStrikeHit, thePlayer ); 
					action.RemoveBuffsByType( EET_KnockdownTypeApplicator );
				}
			}
			
			((CNewNPC)actorVictim).SetHitWindowOpened( false );
		}
		
		
		
		if(playerAttacker && attackAction && attackAction.IsActionMelee() && (W3PlayerWitcher)thePlayer && thePlayer.HasAbility('Runeword 1 _Stats', true))
		{
			infusion = GetWitcherPlayer().GetRunewordInfusionType();
			
			switch(infusion)
			{
				case ST_Aard:
					action.AddEffectInfo(EET_KnockdownTypeApplicator);
					action.SetProcessBuffsIfNoDamage(true);
					attackAction.SetApplyBuffsIfParried(true);
					actorVictim.CreateFXEntityAtPelvis( 'runeword_1_aard', false );
					break;
				case ST_Axii:
					action.AddEffectInfo(EET_Confusion);
					action.SetProcessBuffsIfNoDamage(true);
					attackAction.SetApplyBuffsIfParried(true);
					break;
				case ST_Igni:
					
					totalDmg = action.GetDamageValueTotal();
					attribute = thePlayer.GetAttributeValue('runeword1_fire_dmg');
					fireDamage = totalDmg * attribute.valueMultiplicative;
					action.AddDamage(theGame.params.DAMAGE_NAME_FIRE, fireDamage);
					
					
					action.SetCanPlayHitParticle(false);					
					action.victim.AddTimer('Runeword1DisableFireFX', 1.f);
					action.SetHitReactionType(EHRT_Heavy);	
					action.victim.PlayEffect('critical_burning');
					break;
				case ST_Yrden:
					attribute = thePlayer.GetAttributeValue('runeword1_yrden_duration');
					action.AddEffectInfo(EET_Slowdown, attribute.valueAdditive);
					action.SetProcessBuffsIfNoDamage(true);
					attackAction.SetApplyBuffsIfParried(true);
					break;
				default:		
					break;
			}
		}
		
		
		if( playerAttacker && actorVictim && (W3PlayerWitcher)playerAttacker && GetWitcherPlayer().IsMutationActive( EPMT_Mutation9 ) && (W3BoltProjectile)action.causer )
		{
			maxHealth = actorVictim.GetMaxHealth();
			currHealth = actorVictim.GetHealth();
			
			
			if( AbsF( maxHealth - currHealth ) < 1.f )
			{
				theGame.GetDefinitionsManager().GetAbilityAttributeValue('Mutation9', 'health_reduction', min, max);
				actorVictim.ForceSetStat( actorVictim.GetUsedHealthType(), maxHealth * ( 1 - min.valueMultiplicative ) );
			}
			
			
			action.AddEffectInfo( EET_KnockdownTypeApplicator, 0.1f, , , , 1.f );
		}
	}
}

exec function ForceDismember( b: bool, optional chance : int, optional n : name, optional e : bool )
{
	var temp : CR4Player;
	
	temp = thePlayer;
	temp.forceDismember = b;
	temp.forceDismemberName = n;
	temp.forceDismemberChance = chance;
	temp.forceDismemberExplosion = e;
} 

exec function ForceFinisher( b: bool, optional n : name, optional rightStance : bool )
{
	var temp : CR4Player;
	
	temp = thePlayer;
	temp.forcedStance = rightStance;
	temp.forceFinisher = b;
	temp.forceFinisherAnimName = n;
} 
