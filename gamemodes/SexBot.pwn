//----------------------------------------------------------
//
//  GRAND LARCENY  1.0
//  A freeroam gamemode for SA-MP 0.3
//
//----------------------------------------------------------

#include <a_samp>
#include <a_npc>
#include <a_angles>
#include <core>
#include <float>
#include "../include/gl_common.inc"

#pragma tabsize 0

//----------------------------------------------------------

#define COLOR_WHITE 		0xFFFFFFFF
#define COLOR_NORMAL_PLAYER 0xFFBB7777

new total_vehicles_from_files=0;

new BJStart[MAX_PLAYERS];
new BJSStart[MAX_PLAYERS];
new firstchatbubbletimer[MAX_PLAYERS];
forward blowjobstart(playerid);
forward blowjobsstart(playerid);
forward chatbubbletimer(playerid);

//----------------------------------------------------------

main()
{
	print("\n---------------------------------------");
	print("Sex Bot script - Everybody (SAMP USER, NOT LITREALLY)\n");
	print("---------------------------------------\n");
}

//----------------------------------------------------------

public OnPlayerConnect(playerid)
{
  	SendClientMessage(playerid,COLOR_WHITE,"Welcome to a test of the Sex Bot script");
 	return 1;
}

//----------------------------------------------------------
public OnPlayerSpawn(playerid)
{
	if(IsPlayerNPC(playerid)) return 1;
	
	SetPlayerInterior(playerid,0);
	TogglePlayerClock(playerid,0);
 	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, 30000);
 	SetPlayerPos(playerid, 1759.0189,-1898.1260,13.5622);

	TogglePlayerClock(playerid, 0);

	return 1;
}

//----------------------------------------------------------

public OnPlayerDeath(playerid, killerid, reason)
{
    new playercash;
    
    // if they ever return to class selection make them city
	// select again first
    
	if(killerid == INVALID_PLAYER_ID) {
        ResetPlayerMoney(playerid);
	} else {
		playercash = GetPlayerMoney(playerid);
		if(playercash > 0)  {
			GivePlayerMoney(killerid, playercash);
			ResetPlayerMoney(playerid);
		}
	}
   	return 1;
}

//----------------------------------------------------------

//----------------------------------------------------------
public OnPlayerCommandText(playerid, cmdtext[])
{
	new npcid = GetPlayerID("Woman");
	if(strcmp("/sexbot", cmdtext, true) == 0)
	{
		//SetPlayerPos(playerid, 1204.2395,17.0382,1000.9219);
		SetPlayerPos(playerid, 1204.2391,17.0382,1000.9219);
		SetPlayerPos(npcid, 1203.6425,16.2906,1000.9219);
		SetPlayerInterior(playerid, 2);
		//TogglePlayerControllable(playerid, 0);
		SetPlayerSkin(npcid, 152);
		SetPlayerFacingPlayer(playerid, npcid);
		SetPlayerFacingPlayer(npcid, playerid);
		//ApplyAnimation(npcid,"BLOWJOBZ","BJ_COUCH_START_W",4,0,0,0,1,0, 1);
		//ApplyAnimation(playerid,"PED","SEAT_IDLE",4,0,0,0, 1,0,1);
		firstchatbubbletimer[playerid] = SetTimerEx("chatbubbletimer", 1500, false, "d", playerid);
		return 1;
	}
	if(strcmp("/play", cmdtext, true) == 0)
	{
		ApplyAnimation(npcid,"BLOWJOBZ","BJ_COUCH_START_W",4,0,0,0,1,0, 1);
	}
	return 0;
}
public OnPlayerText(playerid, text[])
{
	new npcid = GetPlayerID("Woman");
	new Float:x,Float:y,Float:z;
	GetPlayerPos(npcid,x,y,z);
	if (strfind(text, "Couch suck") != -1)
    {
		if(IsPlayerInRangeOfPoint(playerid,10,x,y,z))
		{
			if(IsPlayerFacingPlayer(playerid,npcid,10) == 1)
			{
				SetPlayerFacingPlayer(npcid,playerid);
				ApplyAnimation(npcid,"BLOWJOBZ","BJ_COUCH_START_W",4,1,0,0,1,0, 1);
				ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_START_P",4,0,0,0,1,0, 1);
				BJStart[playerid] = SetTimerEx("blowjobstart", 3000, false, "d", playerid);
				SetPlayerChatBubble(npcid,"Sure, no problem.\nNow sit back and relax!",0xFF00FFFF,50,3000);
			}
		}
    } 
	if (strfind(text, "Suck my cock") != -1)
    {
		if(IsPlayerInRangeOfPoint(playerid,10,x,y,z))
		{
			if(IsPlayerConnected(npcid))
			{
				SetPlayerFacingPlayer(npcid,playerid);
				ApplyAnimation(npcid,"BLOWJOBZ","BJ_STAND_START_W",4,0,0,0,1,0, 1);
				ApplyAnimation(playerid,"BLOWJOBZ","BJ_STAND_START_P",4,0,0,0,1,0, 1);
				BJSStart[playerid] = SetTimerEx("blowjobsstart", 2500, false, "d", playerid);
				SetPlayerChatBubble(npcid,"Sure, no problem.\nNow unzip your pants and enjoy.",0xFF00FFFF,50,3000);
			}
		}
    } 
	if (strfind(text, "Stop") != -1)
    {
		SetPlayerChatBubble(npcid,"Sure. (ROUGH END)",0xFF00FFFF,50,3000);
		SetPlayerPos(npcid, 1203.6425,16.2906,1000.9219);
		ClearAnimations(playerid, 0);
	}
	new name[24], string[128];
	GetPlayerName(playerid, name, sizeof(name));
	format(string, sizeof(string), "%s: %s.", name, text);
	SendClientMessageToAll(0xFFFFFFAA, string);
}
public OnPlayerRequestClass(playerid, classid)
{
	if(IsPlayerNPC(playerid)) return 1;    
	return 1;
}

//----------------------------------------------------------

public OnGameModeInit()
{
	SetGameModeText("Shuff' Test v1");
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);
	ShowNameTags(1);
	SetNameTagDrawDistance(40.0);
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	SetWeather(2);
	SetWorldTime(11);
	ConnectNPC("Woman","sexybot");

	UsePlayerPedAnims();
	//ManualVehicleEngineAndLights();
	//LimitGlobalChatRadius(300.0);

	// Player Class
	AddPlayerClass(281,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(282,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(283,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(284,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(285,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(286,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(287,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(288,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(289,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(265,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(266,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(267,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(268,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(269,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(270,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(1,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(2,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(3,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(4,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(5,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(6,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(8,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(42,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(65,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	//AddPlayerClass(74,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(86,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(119,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
 	AddPlayerClass(149,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(208,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(273,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(289,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	
	AddPlayerClass(47,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(48,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(49,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(50,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(51,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(52,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(53,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(54,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(55,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(56,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(57,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(58,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
   	AddPlayerClass(68,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(69,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(70,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(71,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(72,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(73,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(75,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(76,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(78,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(79,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(80,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(81,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(82,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(83,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(84,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(85,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(87,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(88,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(89,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(91,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(92,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(93,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(95,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(96,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(97,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(98,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);
	AddPlayerClass(99,1759.0189,-1898.1260,13.5622,266.4503,-1,-1,-1,-1,-1,-1);

	// SPECIAL
	total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/trains.txt");
	total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/pilots.txt");

   	// LAS VENTURAS
     total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/lv_law.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/lv_airport.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/lv_gen.txt");
    
    // SAN FIERRO
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/sf_law.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/sf_airport.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/sf_gen.txt");
    
    // LOS SANTOS
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_law.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_airport.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_gen_inner.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_gen_outer.txt");
    
    // OTHER AREAS
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/whetstone.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/bone.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/flint.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/tierra.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/red_county.txt");

    printf("Total vehicles from files: %d",total_vehicles_from_files);

	return 1;
}

//----------------------------------------------------------

public OnPlayerUpdate(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(IsPlayerNPC(playerid)) return 1;
	
	// No weapons in interiors
	if(GetPlayerInterior(playerid) != 0 && GetPlayerWeapon(playerid) != 0) {
	    SetPlayerArmedWeapon(playerid,0); // fists
	    return 0; // no syncing until they change their weapon
	}
	
	// Don't allow minigun
	if(GetPlayerWeapon(playerid) == WEAPON_MINIGUN) {
	    Kick(playerid);
	    return 0;
	}

	return 1;
}
stock GetPlayerID(const playername[], partofname=0)
{
	new i;
	new playername1[64];
	for (i=0;i<MAX_PLAYERS;i++)
	{
		if (IsPlayerConnected(i))
		{
			GetPlayerName(i,playername1,sizeof(playername1));
			if (strcmp(playername1,playername,true)==0)
			{
				return i;
			}
		}
	}
	new correctsigns_userid=-1;
	new tmpuname[128];
	new hasmultiple=-1;
	if(partofname)
	{
		for (i=0;i<MAX_PLAYERS;i++)
		{
			if (IsPlayerConnected(i))
			{
				GetPlayerName(i,tmpuname,sizeof(tmpuname));

				if(!strfind(tmpuname,playername1[partofname],true, 0))
				{
					hasmultiple++;
					correctsigns_userid=i;
				}
				if (hasmultiple>0)
				{
					return -2;
				}
			}
		}
	}
	return correctsigns_userid;
}
public blowjobstart(playerid)
{
	new npcid = GetPlayerID("Woman");
	SetPlayerChatBubble(npcid,"What a nice cock!\nLets begin..",0xFF00FFFF,50,2000);
	ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_LOOP_P",4,1,0,0,1,0, 1);
	ApplyAnimation(npcid,"BLOWJOBZ","BJ_COUCH_LOOP_W",4,1,0,0,1,0, 1);
}
public chatbubbletimer(playerid)
{
	new npcid = GetPlayerID("Woman");
	SetPlayerChatBubble(npcid,"Hey there honey! Want to have some fun?",0xFF00FFFF,50,2000);
}
public blowjobsstart(playerid)
{
	new npcid = GetPlayerID("Woman");
	SetPlayerChatBubble(npcid,"What a nice cock!\nLets begin..",0xFF00FFFF,50,2000);
	ApplyAnimation(playerid,"BLOWJOBZ","BJ_STAND_LOOP_P",4,1,0,0,1,0, 1);
	ApplyAnimation(npcid,"BLOWJOBZ","BJ_STAND_LOOP_W",4,1,0,0,1,0, 1);
}
stock ApplyAnimationEx(playerid,alib[32],aname[32],Float:param1,o1,o2,o3,o4,o5)
{
	ApplyAnimation(playerid,alib,aname,param1,o1,o2,o3,o4,o5);
	return 1;
}
stock SetPlayerFacingPlayer(playerid, facingid)
{
	new Float:Px, Float:Py, Float: Pa;
	new Float:x,Float:y,Float:z;
	GetPlayerPos(facingid,x,y,z);
	#pragma unused z
	GetPlayerPos(playerid, Px, Py, Pa);
	Pa = floatabs(atan((y-Py)/(x-Px)));
	if (x <= Px && y >= Py) Pa = floatsub(180, Pa);
	else if (x < Px && y < Py) Pa = floatadd(Pa, 180);
	else if (x >= Px && y <= Py) Pa = floatsub(360.0, Pa);
	Pa = floatsub(Pa, 90.0);
	if (Pa >= 360.0) Pa = floatsub(Pa, 360.0);
	return SetPlayerFacingAngle(playerid, Pa);
}
//----------------------------------------------------------
