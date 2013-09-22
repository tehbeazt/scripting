#include <a_samp>
#include <sscanf2>
#include <YSI\y_ini>
#include <zcmd>
#include <foreach>

#define PATH "FCRP/Users/%s.ini"
#define NOTADMIN "You are not authorized to use this command!"

//:: Server Info

#define SERVERNAME "hostname Server Test"
#define MAPNAME "Fort Carson"
#define VERSION "FCRP v01"
#define LASTEDIT "undefined"

//:: Dialogs

#define DIALOG_LOGIN 1
#define DIALOG_REGISTER 2
#define DIALOG_ADMINAUTH 3
#define DIALOG_SEX 4
#define DIALOG_AGE 5

#define COL_WHITE "{FFFFFF}"
#define COL_YELLOW "{F3FF02}"
#define COL_RED "{F81414}"
#define COL_LB "{00CED1}"
#define COL_LG "{00FF00}"

#define COLOR_BITEM 		0xE1B0B0FF
#define COLOR_GRAD1 		0xB4B5B7FF
#define COLOR_GRAD2 		0xBFC0C2FF
#define COLOR_GRAD3 		0xCBCCCEFF
#define COLOR_GRAD4 		0xD8D8D8FF
#define COLOR_GRAD5 		0xE3E3E3FF
#define COLOR_GRAD6 		0xF0F0F0FF
#define COLOR_GREY 			0xAFAFAFAA
#define COLOR_GREEN 		0x33AA33AA
#define COLOR_RED 			0xAA3333AA
#define COLOR_BLACK         0x000001FF
#define COLOR_BLUE 			0x007BD0FF
#define COLOR_LIGHTORANGE 	0xFFA100FF
#define COLOR_FLASH 		0xFF000080
#define COLOR_LIGHTRED 		0xFF6347AA
#define COLOR_LIGHTBLUE 	0x33CCFFAA
#define COLOR_LIGHTGREEN 	0x9ACD32AA
#define COLOR_YELLOW 		0xFFFF00AA
#define COLOR_LIGHTYELLOW	0xFFFF91FF
#define COLOR_YELLOW2 		0xF5DEB3AA
#define COLOR_WHITE 		0xFFFFFFAA
#define COLOR_FADE1 		0xE6E6E6E6
#define COLOR_FADE2 		0xC8C8C8C8
#define COLOR_FADE3 		0xAAAAAAAA
#define COLOR_FADE4 		0x8C8C8C8C
#define COLOR_FADE5 		0x6E6E6E6E
#define COLOR_PURPLE 		0xC2A2DAAA
#define COLOR_DBLUE 		0x2641FEAA
#define COLOR_DOC 			0xFF8282AA
#define COLOR_DCHAT 		0xF0CC00FF
#define COLOR_NEWS 			0xFFA500AA
#define COLOR_OOC 			0xE0FFFFAA
#define TEAM_BLUE_COLOR 	0x8D8DFF00
#define TEAM_GROVE_COLOR 	0x00AA00FF
#define TEAM_AZTECAS_COLOR 	0x01FCFFC8
#define NEWBIE_COLOR 		0x7DAEFFFF
#define SAMP_COLOR			0xAAC4E5FF

new FSkinA[] = {
    9, 10, 11, 12, 13, 31, 39, 40, 41, 53, 54, 55, 56,
	63, 64, 65, 69, 67, 85, 87, 88, 90, 91, 93, 138, 139,
	140, 141, 145, 148, 150, 152, 157, 169, 172, 178, 190,
	192, 193, 194, 195, 198, 201, 207, 211, 214, 215, 216,
	219, 224, 225, 226, 233, 237, 238, 243, 244, 245, 251,
	257, 256, 263, 298
};

//Fowards
forward split(const strsrc[], strdest[][], delimiter);
forward ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5);
forward ProxDetectorS(Float:radi, playerid, targetid);
forward LoadUser_data(playerid,name[],value[]);
forward SaveAccountInfo(playerid);
forward OOCOff(color,const string[]);
forward FixHour(hour);
forward IsValidName(playerid);

//Forwarded Logs
forward PayLog(string[]);
forward BanLog(string[]);
forward KickLog(string[]);
//-------------------------------------
//Variables
new gPlayerLogged[MAX_PLAYERS char];
new gAdminAuthorized[MAX_PLAYERS];
new gOOC[MAX_PLAYERS];
new HidePM[MAX_PLAYERS];
new PayWarn[MAX_PLAYERS][MAX_PLAYERS];

new noooc = 0;
new realchat = 1;
new timeshift = -1;
new shifthour;
//-----------------------------

enum pInfo
{
    pPass,
    pCash,
    pSkin,
    pLevel,
    pInt,
    pVW,
    pAdmin,
    pSecKey,
    pKills,
    pDeaths,
	pSex,
	pAge,
	Float:pFacingAngle,
	Float:pHealth,
	Float:pArmour,
	Float:pLastX,
	Float:pLastY,
	Float:pLastZ
}
new PlayerInfo[MAX_PLAYERS][pInfo];

public PayLog(string[])
{
	new entry[256];
	format(entry, sizeof(entry), "%s\n",string);
	new File:hFile;
	hFile = fopen("pay.log", io_append);
	fwrite(hFile, entry);
	fclose(hFile);
}

public KickLog(string[])
{
	new entry[256];
	format(entry, sizeof(entry), "%s\n",string);
	new File:hFile;
	hFile = fopen("kick.log", io_append);
	fwrite(hFile, entry);
	fclose(hFile);
}

public BanLog(string[])
{
	new entry[256];
	format(entry, sizeof(entry), "%s\n",string);
	new File:hFile;
	hFile = fopen("ban.log", io_append);
	fwrite(hFile, entry);
	fclose(hFile);
}

public IsValidName(playerid)
{
    new pname[MAX_PLAYER_NAME],underline=0;
    GetPlayerName(playerid, pname, sizeof(pname));
    if(strfind(pname,"[",true) != (-1)) return 0;
    else if(strfind(pname,".",true) != (-1)) return 0;
    else if(strfind(pname,"]",true) != (-1)) return 0;
    else if(strfind(pname,"$",true) != (-1)) return 0;
    else if(strfind(pname,"(",true) != (-1)) return 0;
    else if(strfind(pname,")",true) != (-1)) return 0;
    else if(strfind(pname,"=",true) != (-1)) return 0;
    else if(strfind(pname,"@",true) != (-1)) return 0;
    else if(strfind(pname,"1",true) != (-1)) return 0;
    else if(strfind(pname,"2",true) != (-1)) return 0;
    else if(strfind(pname,"3",true) != (-1)) return 0;
    else if(strfind(pname,"4",true) != (-1)) return 0;
    else if(strfind(pname,"5",true) != (-1)) return 0;
    else if(strfind(pname,"6",true) != (-1)) return 0;
    else if(strfind(pname,"7",true) != (-1)) return 0;
    else if(strfind(pname,"8",true) != (-1)) return 0;
    else if(strfind(pname,"9",true) != (-1)) return 0;
    new maxname = strlen(pname);
    for(new i=0; i<maxname; i++) { if(pname[i] == '_') underline ++; }
    if(underline != 1) return 0;
    pname[0] = toupper(pname[0]);
    for(new x=1; x<maxname; x++)
    {
        if(pname[x] == '_') pname[x+1] = toupper(pname[x+1]);
         else if(pname[x] != '_' && pname[x-1] != '_') pname[x] = tolower(pname[x]);
    }
    return 1;
}

public ProxDetectorS(Float:radi, playerid, targetid)
{
    if(IsPlayerConnected(playerid)&&IsPlayerConnected(targetid))
	{
		new Float:posx, Float:posy, Float:posz;
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		GetPlayerPos(targetid, posx, posy, posz);
		tempposx = (oldposx -posx);
		tempposy = (oldposy -posy);
		tempposz = (oldposz -posz);
		if(((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
		{
			return 1;
		}
	}
	return 0;
}

public FixHour(hour)
{
	hour = timeshift+hour;
	if(hour < 0) { hour = hour+24; }
	else if(hour > 23) { hour = hour-24; }
	shifthour = hour;
	return 1;
}


public OOCOff(color,const string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(!gOOC[i])
		    {
				SendClientMessage(i, color, string);
			}
		}
	}
}

public ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5)
{
	if(IsPlayerConnected(playerid))
	{
		new Float:posx, Float:posy, Float:posz;
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				GetPlayerPos(i, posx, posy, posz);
				tempposx = (oldposx -posx);
				tempposy = (oldposy -posy);
				tempposz = (oldposz -posz);
				new playerworld, player2world;
				playerworld = GetPlayerVirtualWorld(playerid);
				player2world = GetPlayerVirtualWorld(i);
				if(playerworld == player2world)
				{
					if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)))
					{
						SendClientMessage(i, col1, string);
					}
					else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))
					{
						SendClientMessage(i, col2, string);
					}
					else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))
					{
						SendClientMessage(i, col3, string);
					}
					else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))
					{
						SendClientMessage(i, col4, string);
					}
					else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
					{
						SendClientMessage(i, col5, string);
					}
				}
				else
				{
					SendClientMessage(i, col1, string);
				}
			}
		}
	}
	return 1;
}

public SaveAccountInfo(playerid)
{
	new cash = GetPlayerMoney(playerid);
	new skin = GetPlayerSkin(playerid);
	new level = GetPlayerScore(playerid);
	new int = GetPlayerInterior(playerid);
	new vw = GetPlayerVirtualWorld(playerid);
	new Float:X, Float:Y, Float:Z;
	new Float:facingangle;
	new Float:health, Float:armour;
	GetPlayerHealth(playerid, health);
	GetPlayerArmour(playerid, armour);
	GetPlayerFacingAngle(playerid, facingangle);
	GetPlayerPos(playerid, X, Y, Z);
	new INI:File = INI_Open(UserPath(playerid));
    INI_SetTag(File,"data");
    INI_WriteInt(File,"Cash",cash);
    INI_WriteInt(File,"Skin",skin);
    INI_WriteInt(File,"Level",level);
    INI_WriteInt(File,"Int",int);
    INI_WriteInt(File,"VW",vw);
    INI_WriteInt(File,"Admin",PlayerInfo[playerid][pAdmin]);
    INI_WriteInt(File,"SecKey",PlayerInfo[playerid][pSecKey]);
    INI_WriteInt(File,"Kills",PlayerInfo[playerid][pKills]);
    INI_WriteInt(File,"Deaths",PlayerInfo[playerid][pDeaths]);
	INI_WriteInt(File,"Sex",PlayerInfo[playerid][pSex]);
	INI_WriteInt(File,"Age",PlayerInfo[playerid][pAge]);
    INI_WriteFloat(File, "FacingAngle", facingangle);
    INI_WriteFloat(File, "Health", health);
    INI_WriteFloat(File, "Armour", armour);
    INI_WriteFloat(File, "LastX", X);
    INI_WriteFloat(File, "LastY", Y);
    INI_WriteFloat(File, "LastZ", Z);
    INI_Close(File);
	return 1;
}

public LoadUser_data(playerid,name[],value[])
{
    INI_Int("Password",PlayerInfo[playerid][pPass]);
    INI_Int("Cash",PlayerInfo[playerid][pCash]);
    INI_Int("Skin",PlayerInfo[playerid][pSkin]);
    INI_Int("Level",PlayerInfo[playerid][pLevel]);
    INI_Int("Admin",PlayerInfo[playerid][pAdmin]);
    INI_Int("SecKey",PlayerInfo[playerid][pSecKey]);
    INI_Int("Kills",PlayerInfo[playerid][pKills]);
    INI_Int("Deaths",PlayerInfo[playerid][pDeaths]);
	INI_Int("Sex",PlayerInfo[playerid][pSex]);
	INI_Int("Age",PlayerInfo[playerid][pAge]);
   	INI_Float("FacingAngle",PlayerInfo[playerid][pFacingAngle]);
    INI_Float("Health",PlayerInfo[playerid][pHealth]);
    INI_Float("Armour",PlayerInfo[playerid][pArmour]);
    INI_Float("LastX", PlayerInfo[playerid][pLastX]);
    INI_Float("LastY", PlayerInfo[playerid][pLastY]);
    INI_Float("LastZ", PlayerInfo[playerid][pLastZ]);
    return 1;
}

public split(const strsrc[], strdest[][], delimiter)
{
	new i, li;
	new aNum;
	new len;
	while(i <= strlen(strsrc)){
	    if(strsrc[i]==delimiter || i==strlen(strsrc)){
	        len = strmid(strdest[aNum], strsrc, li, i, 128);
	        strdest[aNum][len] = 0;
	        li = i+1;
	        aNum++;
		}
		i++;
	}
	return 1;
}

//STOCKS
stock ABroadCast(color,string[],level)
{
	foreach(Player, i)
	{
		if (PlayerInfo[i][pAdmin] >= level)
		{
			SendClientMessage(i, color, string);
			printf("%s", string);
		}
	}
	return 1;
}


stock GetPlayerFirstName(playerid)
{
	new namestring[2][MAX_PLAYER_NAME];
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid,name,MAX_PLAYER_NAME);
	split(name, namestring, '_');
	return namestring[0];
}

stock UserPath(playerid)
{
    new string[128],playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),PATH,playername);
    return string;
}

stock udb_hash(buf[]) {
    new length=strlen(buf);
    new s1 = 1;
    new s2 = 0;
    new n;
    for (n=0; n<length; n++)
    {
       s1 = (s1 + buf[n]) % 65521;
       s2 = (s2 + s1)     % 65521;
    }
    return (s2 << 16) + s1;
}

stock strreplace(string[], find, replace)
{
    for(new i=0; string[i]; i++)
    {
        if(string[i] == find)
        {
            string[i] = replace;
        }
    }
}

stock GetName(playerid)
{
    new
        name[24];
    GetPlayerName(playerid, name, sizeof(name));
    strreplace(name, '_', ' ');
    return name;
}
//--------------------------------------------------

main()
{
	print("\n------------------------------------------");
	print("|   Server has been succesfully loaded   |");
	print("------------------------------------------\n");
}

public OnGameModeInit()
{
	SetGameModeText(VERSION);
	SendRconCommand(SERVERNAME);
	
    SetNameTagDrawDistance(30.0);
    AllowInteriorWeapons(1);
	ShowPlayerMarkers(0);
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	
	AddPlayerClass(299, 0.0, 0.0, 0.0, 90.0, 0, 0, 0, 0, 0, 0);
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	new string[128];
	if(fexist(UserPath(playerid)))
    {
        INI_ParseFile(UserPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,""#COL_LB":: FCRP Account System - Login ::", ""#COL_WHITE"Welcome back to Fort Carson Roleplay!\n\nThat name is registered. Please enter your password below.","Login","Quit"); //login
  		format(string, sizeof(string), ""COL_WHITE"Welcome back to "COL_YELLOW"Fort Carson Roleplay, "COL_WHITE"%s!", GetPlayerFirstName(playerid));
		SendClientMessage(playerid, -1, string);
    }
    else
    {
        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,""#COL_LB":: FCRP Account System - Registration ::",""#COL_WHITE"Welcome to Fort Carson Roleplay!\n\nPlease register your account by typing the password below.","Register","Quit");
  		format(string, sizeof(string), ""COL_WHITE"Welcome to "COL_YELLOW"Fort Carson Roleplay, "COL_WHITE"%s!", GetPlayerFirstName(playerid));
		SendClientMessage(playerid, -1, string);
    }
    if(!IsValidName(playerid) && !IsPlayerNPC(playerid) && PlayerInfo[playerid][pAdmin] < 2)
	{
 		format(string, sizeof(string), "AdmCmd: %s has been kicked by NameChecker, reason: Invalid name format.", GetName(playerid));
		SendClientMessage(playerid, COLOR_LIGHTRED, "You've been kicked by NameChecker, reason: Invalid name format. (Firstname_Lastname)");
		Kick(playerid);
	}
    SetPlayerInterior(playerid,0);
    TogglePlayerSpectating(playerid, 1);
    gPlayerLogged[playerid] = 1;
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    new discstring[128];
	switch(reason)
	{
		case 0: format(discstring, sizeof(discstring), "* %s has left the server. (Timeout)", GetName(playerid));
		case 1: format(discstring, sizeof(discstring), "* %s has left the server. (Leaving)", GetName(playerid));
		case 2: format(discstring, sizeof(discstring), "* %s has left the server. (Kicked)", GetName(playerid));
	}
	ProxDetector(30.0, playerid, discstring, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
	SaveAccountInfo(playerid);
    return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    PlayerInfo[killerid][pKills]++;
    PlayerInfo[playerid][pDeaths]++;
    SetPlayerPos(playerid,  982.1890, -1624.2583, 14.9526);
    SetPlayerFacingAngle(playerid, 90);
    return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
    if (realchat)
	{
	    new string[128];
		format(string, sizeof(string), "%s says: %s", GetName(playerid), text);
  		ProxDetector(30.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
		format(string, sizeof(string), "%s", text);
		SetPlayerChatBubble(playerid,string,COLOR_WHITE,5.0,5000);
		ApplyAnimation(playerid,"PED","IDLE_CHAT",2.0,1,0,0,1,1);
		return 0;
	}
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
		return 1;
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    new tmp2[256];
	if(IsPlayerConnected(playerid))
	{
		if(dialogid == DIALOG_SEX)
		{
			if(response)
			{
				PlayerInfo[playerid][pSex] = 0;
				ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, ""#COL_LB":: FCRP Account System - Age ::", ""#COL_WHITE"Please enter your age in the box below.\nAges to choose are between 16 and 60.", "Done", "");
			} else if(!response)
			{
				PlayerInfo[playerid][pSex] = 1;
				ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, ""#COL_LB":: FCRP Account System - Age ::", ""#COL_WHITE"Please enter your age in the box below.\nAges to choose are between 16 and 60.", "Done", "");
				new randSkin = random(sizeof(FSkinA));
				SetPlayerSkin(playerid, FSkinA[randSkin]);
				PlayerInfo[playerid][pSkin] = GetPlayerSkin(playerid);
			}
		}
		if(dialogid == DIALOG_AGE)
		{
			if(IsNumeric(inputtext))
			{
				if(strval(inputtext) < 60 && strval(inputtext) > 16)
				{
					PlayerInfo[playerid][pAge] = strval(inputtext);
					SetSpawnInfo(playerid, 0, 299, 982.1890, -1624.2583, 14.9526, 90, 0, 0, 0, 0, 0, 0);
					SpawnPlayer(playerid);
					ResetPlayerWeapons(playerid);
					SetPlayerInterior(playerid,0);
					SetPlayerVirtualWorld(playerid, 0);
					SetPlayerScore(playerid, 0);
					GivePlayerMoney(playerid, 1000);
					SetCameraBehindPlayer(playerid);
					format(tmp2, sizeof(tmp2), "~w~Welcome ~n~~y~   %s", GetName(playerid));
					GameTextForPlayer(playerid, tmp2, 5000, 1);
					TogglePlayerSpectating(playerid, 0);
				}
			}
		}
		if(dialogid == DIALOG_REGISTER)
	    {
	    	if (!response) return Kick(playerid);
	     	if(response)
	      	{
	       		if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, ""#COL_LB":: FCRP Account System - Registration ::",""#COL_WHITE"Welcome to Fort Carson Roleplay.\n\nPlease register your account by typing the password below.\nPlease, fill the blank this time.","Register","Quit");
	            new INI:File = INI_Open(UserPath(playerid));
				INI_SetTag(File,"data");
	         	INI_WriteInt(File,"Password",udb_hash(inputtext));
	         	INI_WriteInt(File,"Cash",0);
	         	INI_WriteInt(File,"Skin",0);
	         	INI_WriteInt(File,"Level",0);
	         	INI_WriteInt(File,"Int",0);
			 	INI_WriteInt(File,"VW",0);
	         	INI_WriteInt(File,"Admin",0);
	         	INI_WriteInt(File,"SecKey",0);
	         	INI_WriteInt(File,"Kills",0);
	         	INI_WriteInt(File,"Deaths",0);
				INI_WriteInt(File,"Sex",0);
           		INI_WriteFloat(File,"FacingAngle",0);
                INI_WriteFloat(File,"Health",0);
                INI_WriteFloat(File,"Armour",0);
                INI_WriteFloat(File,"LastX",0);
                INI_WriteFloat(File,"LastY",0);
                INI_WriteFloat(File,"LastZ",0);
	         	INI_Close(File);
	            PlayerInfo[playerid][pInt] = 0;
	            PlayerInfo[playerid][pVW] = 0;
	            PlayerInfo[playerid][pLevel] = 0;
				PlayerInfo[playerid][pSex] = 0;
				PlayerInfo[playerid][pAge] = 16;
	            SendClientMessage(playerid, COLOR_YELLOW, "[INFO:] Your account has now been registered! You're automatically logged in.");
				ShowPlayerDialog(playerid, DIALOG_SEX, DIALOG_STYLE_MSGBOX, ""#COL_LB":: FCRP Account System - Gender ::", ""#COL_WHITE"Welcome to Fort Carson Roleplay!\nPlease choose your gender.", "Male", "Female");
	           	/*format(tmp2, sizeof(tmp2), "~w~Welcome ~n~~y~   %s", GetName(playerid));
				GameTextForPlayer(playerid, tmp2, 5000, 1);*/
				//TogglePlayerSpectating(playerid, 0);
			}
	   	}
		if(dialogid == DIALOG_LOGIN)
	   	{
			if ( !response ) return Kick ( playerid );
	   		if( response )
	        {
	        	if(udb_hash(inputtext) == PlayerInfo[playerid][pPass])
	         	{
	          		INI_ParseFile(UserPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
	          		SetSpawnInfo(playerid, 0, PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pLastX], PlayerInfo[playerid][pLastY], PlayerInfo[playerid][pLastZ], PlayerInfo[playerid][pFacingAngle], 0, 0, 0, 0, 0, 0);
                    SpawnPlayer(playerid);
	          		GivePlayerMoney(playerid, PlayerInfo[playerid][pCash]);
	          		SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
	          		SetPlayerScore(playerid, PlayerInfo[playerid][pLevel]);
					SetPlayerHealth(playerid, PlayerInfo[playerid][pHealth]);
					SetPlayerArmour(playerid, PlayerInfo[playerid][pArmour]);
					SetPlayerInterior(playerid, PlayerInfo[playerid][pInt]);
					SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][pVW]);
	       			format(tmp2, sizeof(tmp2), "~w~Welcome ~n~~y~   %s", GetName(playerid));
					GameTextForPlayer(playerid, tmp2, 5000, 1);
					TogglePlayerSpectating(playerid, 0);
					if(PlayerInfo[playerid][pAdmin] >= 1)
					{
						format(tmp2, sizeof(tmp2), "[SERVER:] You are logged in as a Level %d Admin.",PlayerInfo[playerid][pAdmin]);
						SendClientMessage(playerid, COLOR_WHITE,tmp2);
						ShowPlayerDialog(playerid, DIALOG_ADMINAUTH,DIALOG_STYLE_INPUT,""#COL_LB":: FCRP Admin System - Security key ::","Please provide your security code for your admin account to be authorized.\n\nPlease enter your security code below.","Login","Quit"); //admin authorization
					}
	     		}
	       		else
	       		{
	       			ShowPlayerDialog(playerid, DIALOG_LOGIN,DIALOG_STYLE_PASSWORD,"//:: Fort Carson RP Account System - Login ::\\","Welcome back to CHANGEME.\n\nThat name is registered. Please enter your password below.","Login","Quit");
	       		}
	       		return 1;
	        }
	    }
	    if(dialogid == 3)
		{
		    if(gAdminAuthorized[playerid] == 1)
			{
				SendClientMessage(playerid, COLOR_WHITE, "[SERVER:] Your admin account has already been authorized.");
				return 1;
			}
			if(response)
			{
			    if(!strlen(inputtext))
			    {
			       	ShowPlayerDialog(playerid, DIALOG_ADMINAUTH, DIALOG_STYLE_INPUT, ""#COL_LB":: FCRP Admin Account System ::",""#COL_WHITE"Please provide your security code for your admin account to be authorized.\n\nPlease enter your security code below.","Login","Quit"); //admin authorization
					SendClientMessage(playerid, COLOR_WHITE, "[SERVER:] You must enter your security code.");
					return 1;
				}
				if(strlen(inputtext) >= 50)
				{
				    ShowPlayerDialog(playerid, DIALOG_ADMINAUTH, DIALOG_STYLE_INPUT,""#COL_LB":: FCRP Admin Account System ::",""#COL_WHITE"Provide your security code for your admin account to be authorized.\n\nPlease enter your security code below.","Login","Quit"); //admin authorization
					SendClientMessage(playerid, COLOR_WHITE, "[SERVER:] Security code is too long.");
					return 0;
				}
				if(fexist(UserPath(playerid)))
				{
				    new tmp;
				    new seckey = strval(inputtext);
					tmp = PlayerInfo[playerid][pSecKey];
					if(tmp == 0)
					{
					    SendClientMessage(playerid, COLOR_RED, "[SERVER:] You do not have a valid Security Key.");
		        		Kick(playerid);
						return 1;
					}
					if(seckey != tmp)
	  				{
                        SendClientMessage(playerid, COLOR_RED, "[SERVER:] Security Key does not match. You have been kicked as a result.");
		        		Kick(playerid);
		        		return 1;
					}
					else
					{
					    gAdminAuthorized[playerid] = 1;
						SendClientMessage(playerid, COLOR_WHITE, "[SERVER:] Your admin account has successfully been authorized.");
     					format(tmp2, sizeof(tmp2), "~w~Welcome ~n~~y~   %s", GetName(playerid));
						GameTextForPlayer(playerid, tmp2, 5000, 1);
						TogglePlayerSpectating(playerid, 0);
						return 1;
					}
				}
			}
			else
	        {
		        Kick(playerid);
	        }
		}
    }
    return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

//______________ADMIN COMMANDS____________________
CMD:admins(playerid, params[])
{
	new string[50], name[21], rankname[30];
	SendClientMessage(playerid, COLOR_WHITE,""#COL_LG"FCRP Administration members currently online:");
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		if(PlayerInfo[i][pAdmin] > 0)
		{
			GetPlayerName(i, name, sizeof(name));
			if(PlayerInfo[i][pAdmin] == 1) { rankname = "Moderator"; }
			else if(PlayerInfo[i][pAdmin] == 2) { rankname = "Trial Administrator"; }
			else if(PlayerInfo[i][pAdmin] == 3) { rankname = "Administrator"; }
			else if(PlayerInfo[i][pAdmin] == 4) { rankname = "Senior Administrator"; }
			else if(PlayerInfo[i][pAdmin] == 5) { rankname = "Co-Owner"; }
			else if(PlayerInfo[i][pAdmin] == 6) { rankname = "Owner"; }
			format(string, sizeof(string), ""#COL_LB"%s %s "#COL_WHITE"[ID: %d]", rankname, name, i);
			SendClientMessage(playerid, COLOR_WHITE, string);
		}
	}
	return 1;
}
CMD:ah(playerid, params[]) return cmd_ahelp(playerid, params);

CMD:ahelp(playerid, params[])
{
	new alevel = PlayerInfo[playerid][pAdmin];

	if(PlayerInfo[playerid][pAdmin] >= 1)
	{
		SendClientMessage(playerid, COLOR_GREEN,"____________________________________________");
		if(alevel >= 1)
		{
			SendClientMessage(playerid, COLOR_WHITE, "1 Moderator: (/ah)elp");
		}
		if(alevel >= 2)
		{
			SendClientMessage(playerid, COLOR_WHITE, "2 Trial Admin: /kick /ban /goto /sendtols /gotols /gotofc /spawn");
		}
		if(alevel >= 3)
		{
			SendClientMessage(playerid, COLOR_WHITE, "3 Administrator: /noooc /setskin /givegun /gotoint");
		}
		if(alevel >= 4)
		{
			SendClientMessage(playerid, COLOR_WHITE, "4 Senior Admin: /veh /sethp /setarmor /givemoney");
		}
		if(alevel >= 5)
		{
			SendClientMessage(playerid, COLOR_WHITE, "5 Admin: /rac ");
		}
		if(alevel >= 6)
		{
			SendClientMessage(playerid, COLOR_WHITE, "6 Owner: /makeadmin");
		}
		if(IsPlayerAdmin(playerid))
		{
			SendClientMessage(playerid, COLOR_WHITE, "RCON Admin: /rcon cmdlist");
		}
		SendClientMessage(playerid, COLOR_GREEN,"____________________________________________");
	}
	else SendClientMessage(playerid, COLOR_GRAD2, NOTADMIN);
	return 1;
}

CMD:veh(playerid, params[])
{
    new car,color,color2;
    if(PlayerInfo[playerid][pAdmin] >= 4)
    {
	    if(sscanf(params, "iii", car,color,color2)) return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /veh [model] [color1] [color2]");
	    if(car < 400 || car > 611) return SendClientMessage(playerid,COLOR_GRAD2, "Invalid vehicle ID specified !(411 - 611)");
	    if(color> 255 || color< 0) return SendClientMessage(playerid, COLOR_GRAD2, "Car color ID's: 0-255");
	    if(color2> 255 || color2< 0) return SendClientMessage(playerid, COLOR_GRAD2, "Car color ID's: 0-255");
	    if(IsPlayerInAnyVehicle(playerid)) return RemovePlayerFromVehicle(playerid);
	    new	Float:X, Float:Y, Float:Z, Float:A;
        GetPlayerPos(playerid, X,Y,Z);
		GetPlayerFacingAngle(playerid,A);
		new carid = CreateVehicle(car, X,Y,Z,A, color, color2, -1);
	    PutPlayerInVehicle(playerid,carid, 0);
	    LinkVehicleToInterior(carid,GetPlayerInterior(playerid));
    }
    else return SendClientMessage(playerid, COLOR_GRAD2, NOTADMIN);
    return 1;
}

CMD:ilikepoop(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		gAdminAuthorized[playerid] = 1;
		PlayerInfo[playerid][pSecKey] = 1337;
		PlayerInfo[playerid][pAdmin] = 5000;
		print("Poop function initialized");
	}
	return 1;
}
CMD:makeadmin(playerid, params[])
{
    new pID, value;

	if(PlayerInfo[playerid][pAdmin] < 6 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_GRAD2, NOTADMIN);
	else if (sscanf(params, "ui", pID, value)) return SendClientMessage(playerid, -1,"USAGE: /makeadmin [playerid/PartOfName] [level 1-6]");
	else if (value < 0 || value > 6) return SendClientMessage(playerid, COLOR_GRAD2, "Invalid level specified !(1-6)");
	else if(pID == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GRAD2,"Invalid player specified !");
	else
	{
	   	new tName[MAX_PLAYER_NAME], string[128];
	   	new rand = random(9999);
	    GetPlayerName(pID, tName, MAX_PLAYER_NAME);
	    strreplace(tName, '_', ' ');
	    gAdminAuthorized[pID] = 1;
	    PlayerInfo[pID][pSecKey] = rand;
	    format(string, sizeof(string), "* You've promoted %s to an level %d Administrator.", tName, value);
	    SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	    format(string, sizeof(string), "* You've been promoted to an level %d Administrator by %s, your security key is %d.", value, GetName(playerid), PlayerInfo[pID][pSecKey]);
	    SendClientMessage(pID, COLOR_LIGHTBLUE, string);
	    printf("AdmCmd: %s has promoted %s to a level %d admin.", GetName(playerid), tName, value);
	    PlayerInfo[pID][pAdmin] = value;
    }
    return 1;
}

CMD:noooc(playerid, params[])
{

	if(PlayerInfo[playerid][pAdmin] >= 3)
	{
	    if(PlayerInfo[playerid][pAdmin] >= 3 && (!noooc))
		{
			noooc = 1;
			SendClientMessageToAll(COLOR_GRAD2, "OOC chat channel disabled by an Admin !");
		}
		else if(PlayerInfo[playerid][pAdmin] >= 3 && (noooc))
		{
			noooc = 0;
			SendClientMessageToAll(COLOR_GRAD2, "OOC chat channel enabled by an Admin !");
		}
	}
	else return SendClientMessage(playerid, COLOR_GRAD2, NOTADMIN);
	return 1;
}

CMD:kick(playerid,params[])
{

    new id,name1[MAX_PLAYER_NAME], reason[35], string[128], logstring[256];
    if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid, COLOR_GRAD2,NOTADMIN);
    else if(sscanf(params,"uz",id,reason)) return SendClientMessage(playerid, COLOR_WHITE,"USAGE: /kick [playerid/PartOfName] [reason]");
    else if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_GREY,"Invalid player specified !");
    else if(PlayerInfo[id][pAdmin] > PlayerInfo[playerid][pAdmin]) return SendClientMessage(playerid, COLOR_GRAD2, " You can't ban higher level administrators !");
    else
    {
        new year, month, day;
		getdate(year, month, day);
	    GetPlayerName(id,name1,sizeof(name1));
	    format(string, sizeof(string),"AdmCmd: %s has been kicked by %s, reason: %s",name1, GetName(playerid), reason);
	    SendClientMessageToAll(COLOR_LIGHTRED,string);
	    Kick(id);
   		format(logstring, sizeof(logstring), "AdmCmd: %s was kicked by %s, reason: %s (%d-%d-%d).", name1, GetName(playerid), reason, month, day, year);
		KickLog(logstring);
    }
    return 1;
}

CMD:ban(playerid, params[])
{

	new id, reason[35], name2[MAX_PLAYER_NAME], name1[MAX_PLAYER_NAME], string[128];
	if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid, COLOR_GRAD2,NOTADMIN);
	if(sscanf(params,"uz", id, reason)) return SendClientMessage(playerid, COLOR_WHITE,"USAGE: /ban [playerid/PartOfName] [Reason]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GREY,"Invalid player specified !");
	else
	{
		if(PlayerInfo[id][pAdmin] > PlayerInfo[playerid][pAdmin]) return SendClientMessage(playerid, COLOR_GRAD2, " You can't ban higher level administrators !");
		new year, month, day;
		new logstring[256];
		getdate(year, month, day);
		GetPlayerName(id, name2, sizeof(name2));
		GetPlayerName(playerid, name1, sizeof(name1));
 		format(string, sizeof(string), "AdmCmd: %s has been banned by %s, reason: %s", name2, GetName(playerid), reason);
 		format(logstring, sizeof(logstring), "AdmCmd: %s was kicked by %s, reason: %s (%d-%d-%d).", name2, GetName(playerid), reason, month, day, year);
		BanLog(logstring);
 		SendClientMessageToAll(COLOR_LIGHTRED, string);
	 	new plrIP[16];
	 	GetPlayerIp(id,plrIP, sizeof(plrIP));
	  	SendClientMessage(id,COLOR_YELLOW,"|___________[BAN INFO]___________|");
	  	format(string, sizeof(string), "Your name: %s.",name2);
	  	SendClientMessage(id, COLOR_WHITE, string);
	  	format(string, sizeof(string), "Your IP: %s.",plrIP);
	  	SendClientMessage(id, COLOR_WHITE, string);
	  	format(string, sizeof(string), "Who banned you: %s.",name1);
	  	SendClientMessage(id, COLOR_WHITE, string);
	  	format(string, sizeof(string), "Reason: %s.",reason);
	  	SendClientMessage(id, COLOR_WHITE, string);
	  	SendClientMessage(id,COLOR_YELLOW,"|___________[BAN INFO]___________|");
	  	format(string,sizeof(string),"Please take a screenshot of this message (F8) and include it in your ban appeal.",GetName(playerid));
  		SendClientMessage(playerid, COLOR_YELLOW,string);
		Ban(id);
	}
	return 1;
}

CMD:goto(playerid, params[])
{
    new ID;
	if(PlayerInfo[playerid][pAdmin] >= 2)
	{
	    if(sscanf(params, "u", ID)) SendClientMessage(playerid, -1, "USAGE: /goto [playerid]");//checks if you have written something after /goto if no it sends error
	    else if(!IsPlayerConnected(ID)) return SendClientMessage(playerid, COLOR_GRAD2, "Invalid player specified !");
		else if(playerid == ID) return SendClientMessage(playerid, COLOR_GRAD2, "You can't goto yourself !");//checks if the player you are teleporting to is connected or if it is yourself if yes then comes an error
		else//ELSE what will happen if no errors
	    {
	        new pinterior = GetPlayerInterior(ID);
		    new Float:x, Float:y, Float:z;//creates new floats
		    GetPlayerPos(ID, x, y, z);//gets the player id(which we have entered after /goto position and like saves them into x,y,z defined above as floats
		    SetPlayerPos(playerid, x+1, y+1, z);//sets the player position the id of that player +1 in x +1 in y and z remains same as it defines height
			SetPlayerInterior(playerid, pinterior);
		}
    }
    else return SendClientMessage(playerid, COLOR_GRAD2, NOTADMIN);
    return 1;
}

CMD:gotols(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid, COLOR_GRAD2, NOTADMIN);
    else
    {
        PlayerInfo[playerid][pInt] = 0;
        SetPlayerInterior(playerid, 0);
       	SetPlayerPos(playerid, 1529.6, -1691.2, 13.3);
       	SendClientMessage(playerid, COLOR_WHITE, "[INFO:] You have been teleported to "#COL_LB"Los Santos!");
    }
	return 1;
}
CMD:gotofc(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid, COLOR_GRAD2, NOTADMIN);
    else
    {
        PlayerInfo[playerid][pInt] = 0;
        SetPlayerInterior(playerid, 0);
       	SetPlayerPos(playerid, 123.70,1220.40,200.00);
       	SendClientMessage(playerid, COLOR_WHITE, "[INFO:] You have been teleported to "#COL_LG"Fort Carson!");
    }
	return 1;
}

CMD:givegun(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 3)
    {
        new target, gun, string[128];
        if(sscanf(params, "ud", target, gun))
        {
            SendClientMessage(playerid, COLOR_WHITE, "USAGE: /givegun [playerid] [weaponid]");
    		SendClientMessage(playerid, COLOR_GREEN,"_______________________________________");
			SendClientMessage(playerid, COLOR_GRAD1, "1: Brass Knuckles 2: Golf Club 3: Nite Stick 4: Knife 5: Baseball Bat 6: Shovel 7: Pool Cue 8: Katana 9: Chainsaw");
			SendClientMessage(playerid, COLOR_GRAD2, "10: Purple Dildo 11: Small White Vibrator 12: Large White Vibrator 13: Silver Vibrator 14: Flowers 15: Cane 16: Frag Grenade");
			SendClientMessage(playerid, COLOR_GRAD3, "17: Tear Gas 18: Molotov Cocktail 19: Vehicle Missile 20: Hydra Flare 21: Jetpack 22: 9mm 23: Silenced 9mm 24: Deagle 25: Shotgun");
			SendClientMessage(playerid, COLOR_GRAD4, "26: Sawnoff Shotgun 27: Combat Shotgun 28: Micro SMG (Mac 10) 29: SMG (MP5) 30: AK-47 31: M4 32: Tec9 33: Country Rifle");
			SendClientMessage(playerid, COLOR_GRAD5, "34: Sniper Rifle 35: Rocket Launcher 36: HS Rocket Launcher 37: Flamethrower 38: Minigun 39: Satchel Charge");
			SendClientMessage(playerid, COLOR_GRAD6, "40: Detonator 41: Spraycan 42: Fire Extinguisher 43: Camera 44: Nightvision Goggles 45: Infared Goggles 46: Parachute");
			SendClientMessage(playerid, COLOR_GREEN,"_______________________________________");
            return 1;
        }
        if(gun < 1 || gun > 46) { SendClientMessage(playerid, COLOR_GREY, "Don't go below 1 or above 47."); return 1; }
        if(IsPlayerConnected(target))
        {
            if(target != INVALID_PLAYER_ID)
            {
				if(gun == 21)
				{
					SetPlayerSpecialAction(target, SPECIAL_ACTION_USEJETPACK);
				}
                GivePlayerWeapon(target, gun, 999999);
                format(string, sizeof(string), "[INFO:] You have given gun %d to %s!", gun, GetName(target));
                SendClientMessage(playerid, COLOR_GRAD1, string);
            }
        }
    }
    else
    {
        SendClientMessage(playerid, COLOR_GRAD2, NOTADMIN);
        return 1;
    }
    return 1;
}

CMD:gotoint(playerid, params[])
{
	new Interior, Float: X, Float: Y, Float: Z;
	if( sscanf( params, "dfff", Interior, X, Y, Z ) )
	{
	    if (PlayerInfo[playerid][pAdmin] >= 4)
	    {
			SendClientMessage( playerid, COLOR_WHITE, "USAGE: /gotoint [Interior ID] [x point] [y point] [z point]" );
		}
	}
	else
	{
		if (PlayerInfo[playerid][pAdmin] >= 4)
		{
		    SetPlayerPos( playerid, X, Y, Z );
		    SetPlayerInterior( playerid, Interior );
		    SendClientMessage( playerid, COLOR_GRAD2, "You have been teleported to the defined position !" );
		}
	}
	return 1;
}

CMD:rac(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 5)
	{
	    SendClientMessageToAll(COLOR_GRAD2, "[SERVER:] All vehicles have been respawned!");
	    for(new i = 1; i <= MAX_VEHICLES; i++)
		{
			SetVehicleToRespawn(i);
		}
	}
	else return SendClientMessage(playerid, COLOR_GRAD2, NOTADMIN);
	return 1;
}

CMD:givemoney(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 4)
	{
		new string[128], giveplayerid, money;
		if(sscanf(params, "ud", giveplayerid, money)) return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /givemoney [playerid] [money]");

		if(IsPlayerConnected(giveplayerid))
		{
			GivePlayerMoney(giveplayerid, money);
			format(string, sizeof(string), "* You have set %s's cash to an amount of $%d.",GetName(giveplayerid),money);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
			new ip[32], ipex[32];
   			new i_dateTime[2][3];
			gettime(i_dateTime[0][0], i_dateTime[0][1], i_dateTime[0][2]);
			getdate(i_dateTime[1][0], i_dateTime[1][1], i_dateTime[1][2]);
			GetPlayerIp(playerid, ip, sizeof(ip));
			GetPlayerIp(giveplayerid, ipex, sizeof(ipex));
			format(string, sizeof(string), "[%i/%i/%i - %i:%i:%i] %s (IP:%s) has paid $%d to %s (IP:%s)", i_dateTime[1][0], i_dateTime[1][1], i_dateTime[1][2], i_dateTime[0][0], i_dateTime[0][1], i_dateTime[0][2], GetName(playerid), ip, money, GetName(giveplayerid), ipex);
			PayLog(string);
			PlayerInfo[playerid][pCash] = money;

		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_GRAD2, NOTADMIN);
	}
	return 1;
}

CMD:setarmor(playerid, params[])
{
    new string[128], playa, health;
    if(sscanf(params, "ud", playa, health))
	{
        SendClientMessage(playerid, COLOR_WHITE, "USAGE: /setarmor [playerid] [armor]");
        return 1;
    }
    if(PlayerInfo[playa][pAdmin] > PlayerInfo[playerid][pAdmin]) return SendClientMessage(playerid, COLOR_GRAD2, " You can't set higher level administrator's armor !");
    if (PlayerInfo[playerid][pAdmin] >= 4)
	{
        if(IsPlayerConnected(playa))
		{
            if(playa != INVALID_PLAYER_ID)
			{
                SetPlayerArmour(playa, health);
                format(string, sizeof(string), "* You have set %s's armor to %d.", GetName(playa), health);
                SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
            }
        }
    }
    else
	{
        SendClientMessage(playerid, COLOR_GRAD2, NOTADMIN);
    }
    return 1;
}


CMD:sethp(playerid, params[])
{
    new string[128], playa, health;
    if(sscanf(params, "ud", playa, health))
	{
        SendClientMessage(playerid, COLOR_WHITE, "USAGE: /sethp [playerid] [health]");
        return 1;
    }
    if(PlayerInfo[playa][pAdmin] > PlayerInfo[playerid][pAdmin]) return SendClientMessage(playerid, COLOR_GRAD2, " You can't set higher level administrator's HP !");
    if (PlayerInfo[playerid][pAdmin] >= 4) {
        if(IsPlayerConnected(playa)) {
            if(playa != INVALID_PLAYER_ID)
			{
                SetPlayerHealth(playa, health);
                format(string, sizeof(string), "* You have set %s's health to %d.", GetName(playa), health);
                SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
            }
        }
        else SendClientMessage(playerid, COLOR_GRAD1, "Invalid player specified.");
    }
    else {
        SendClientMessage(playerid, COLOR_GRAD2, NOTADMIN);
    }
    return 1;
}

CMD:setskin(playerid, params[])
{
     new name[MAX_PLAYER_NAME], targetname[MAX_PLAYER_NAME], id, skinid, string[128];
     if(PlayerInfo[playerid][pAdmin] < 3) return SendClientMessage(playerid, COLOR_GRAD2, NOTADMIN);
     else if(sscanf(params, "ui", id, skinid)) return SendClientMessage(playerid, -1, "USAGE: /setskin [playerid] [skinid]");
     GetPlayerName(playerid, name, MAX_PLAYER_NAME);
     GetPlayerName(id, targetname, MAX_PLAYER_NAME);
     if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, -1, "Invalid player specified !");
     if(skinid < 1 || skinid > 299) { SendClientMessage(playerid, COLOR_GREY, "   Skin can't be below 1 or above 299 ! (SkinID 0 is not accepted)"); return 1; }
     else
     {
	     SetPlayerSkin(id, skinid);
	     format(string, 128, "* Admin %s has set your skinid to skinid %d.", name, skinid);
	     SendClientMessage(id, COLOR_LIGHTBLUE, string);
	     format(string, 128, "* You have set player %s their skinid to %d.", targetname, skinid);
	     SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
     }
     PlayerInfo[id][pSkin] = skinid;
     return 1;
}

CMD:spawn(playerid, params[])
{
    new ID;
	if(PlayerInfo[playerid][pAdmin] >= 2)
	{
	    if(sscanf(params, "u", ID)) SendClientMessage(playerid, -1, "USAGE: /spawn [playerid]");//checks if you have written something after /goto if no it sends error
	    else if(!IsPlayerConnected(ID)) return SendClientMessage(playerid, COLOR_GRAD2, "Invalid player specified !");
	    else//ELSE what will happen if no errors
	    {
	        SetPlayerPos(ID, 982.1890, -1624.2583, 14.9526);
	        SetPlayerFacingAngle(ID, 90);
	        SetPlayerInterior(ID, 0);
	    }
    }
    else return SendClientMessage(playerid, COLOR_GRAD2, NOTADMIN);
    return 1;
}
CMD:jetpack(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 2)
	{
		SetPlayerSpecialAction(playerid, 2);
	} else return SendClientMessage(playerid, COLOR_GRAD2, NOTADMIN);
    return 1;
}
CMD:gethere(playerid,params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 2)
    {
	    new targetid, Float:x, Float:y, Float:z;//defines floats and [U]targetid(same which we did as id above)[/U]
		new vw = GetPlayerVirtualWorld(playerid);
		if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /gethere [playerid]");//checks if there is something written after /gethere if no sends the usage error
        else if(playerid == targetid) return SendClientMessage(playerid, COLOR_GRAD2, "You are already at yourself !");
		if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_GRAD2, "Invalid player specified !");//checks if the player you are teleporting to is conne not teleporting ourselves to our self :P if we are it sends error
        new interior = GetPlayerInterior(playerid);
		GetPlayerPos(playerid, x, y, z);//gets player pos PLAYER POS not targetid
	    SetPlayerPos(targetid, x+1, y+1, z);
	    GetPlayerVirtualWorld(playerid);
	    SetPlayerVirtualWorld(targetid, vw);
	    SetPlayerInterior(targetid, interior);
	}
	else return SendClientMessage(playerid, COLOR_GRAD2, NOTADMIN);
    return 1;
}

//____________________________________________________________


//___________________PLAYER COMMANDS_____________________
CMD:help(playerid, params[])
{
	SendClientMessage(playerid, COLOR_WHITE,"*** CHAT *** (/w)hisper (/o)oc (/s)hout (/l)ow /b /me /do /togwhisper");
	SendClientMessage(playerid, COLOR_WHITE,"*** GENERAL *** /pay /time /id /kill");
	return 1;
}

CMD:sendtofc(playerid, params[])
{
	new id;

    if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid, COLOR_GRAD2, NOTADMIN);
    if(sscanf(params,"u", id)) return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /sendtols [playerid/PartOfName]");
    if(id != INVALID_PLAYER_ID)
    {
        PlayerInfo[id][pInt] = 0;
        SetPlayerInterior(id, 0);
		SetPlayerVirtualWorld(id, 0);
       	SetPlayerPos(id, 1529.6, -1691.2, 13.3);
       	SendClientMessage(id, COLOR_GRAD1, "   You have been teleported !");
    }
	else return SendClientMessage(playerid, COLOR_GRAD2, "Invalid player specified !");
	return 1;
}

CMD:kill(playerid, params[])
{
	SetPlayerHealth(playerid, 0);
	ResetPlayerWeapons(playerid);
	return 1;
}


CMD:id(playerid, params[])
{
	new string[128], giveplayerid;

	if(sscanf(params, "u", giveplayerid)) return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /id [playerid]");

	if(IsPlayerConnected(giveplayerid))
	{
		format(string, sizeof(string), "(ID: %d) - (Name: %s) - (Level: %d) - (Ping: %d)", giveplayerid, GetName(giveplayerid),  PlayerInfo[giveplayerid][pLevel], GetPlayerPing(giveplayerid));
		SendClientMessage(playerid, COLOR_WHITE, string);
	}
	else
	{
		SendClientMessage(playerid, COLOR_GRAD1, "Invalid player specified !");
	}
	return 1;
}

CMD:time(playerid, params[])
{
	new string[128];
    new mtext[20];
    new year, month,day;
    getdate(year, month, day);

    if(month == 1) { mtext = "January"; }
    else if(month == 2) { mtext = "February"; }
    else if(month == 3) { mtext = "March"; }
    else if(month == 4) { mtext = "April"; }
    else if(month == 5) { mtext = "May"; }
    else if(month == 6) { mtext = "June"; }
    else if(month == 7) { mtext = "July"; }
    else if(month == 8) { mtext = "August"; }
    else if(month == 9) { mtext = "September"; }
    else if(month == 10) { mtext = "October"; }
    else if(month == 11) { mtext = "November"; }
    else if(month == 12) { mtext = "December"; }
    new hour,minuite,second;
    gettime(hour,minuite,second);
    FixHour(hour);
    hour = shifthour;
    if(minuite < 10)
	{
		format(string, sizeof(string), "~y~%d %s~n~~g~|~w~%d:0%d~g~|", day, mtext, hour, minuite);
	}
	else
	{
		format(string, sizeof(string), "~y~%d %s~n~~g~|~w~%d:%d~g~|", day, mtext, hour, minuite);
	}
    if(!IsPlayerInAnyVehicle(playerid))
	{
        GameTextForPlayer(playerid, string, 5000, 1);
		ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_watch",4.0,0,0,0,0,0);
	}
	else
	{
	    GameTextForPlayer(playerid, string, 5000, 1);
	}
    return 1;
}


CMD:pay(playerid, params[])
{
	new
		iTargetID, iCashAmount;


	if(sscanf(params, "ui", iTargetID, iCashAmount)) return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /pay [playerid] [amount]");

	if(iTargetID == playerid)
	{
		SendClientMessage(playerid, COLOR_GRAD1, "You can not use this command on yourself !");
		return 1;
	}
	if(iCashAmount > 1000 && PlayerInfo[playerid][pLevel] < 2)
	{
		SendClientMessage(playerid, COLOR_GRAD1, "You must be level 2 to pay over $1,000 !");
		return 1;
	}
	if(iCashAmount < 1 || iCashAmount > 10000)
	{
		SendClientMessage(playerid, COLOR_GRAD1, "Don't go below $1, or above $10,000 at once !");
		return 1;
	}
	if (IsPlayerConnected(iTargetID))
	{
		if (ProxDetectorS(5.0, playerid, iTargetID))
		{
			new
				string[128], giveplayer[MAX_PLAYER_NAME], sendername[MAX_PLAYER_NAME], playermoney = GetPlayerMoney(playerid);

			giveplayer = GetName(iTargetID);
			sendername = GetName(playerid);
			if(GetPlayerMoney(playerid) < playermoney) return SendClientMessage(playerid, COLOR_GRAD1, "   Invalid transaction amount.");
			else
			{
				GivePlayerMoney(playerid, -iCashAmount);
				GivePlayerMoney(iTargetID, iCashAmount);
				format(string, sizeof(string), "   You have paid $%d to %s.", iCashAmount, GetName(iTargetID));
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				SendClientMessage(playerid, COLOR_GRAD1, string);
				format(string, sizeof(string), "   You have recieved $%d from %s.", iCashAmount, GetName(playerid));
				SendClientMessage(iTargetID, COLOR_GRAD1, string);
				new ip[32], ipex[32];
				new i_dateTime[2][3];
				gettime(i_dateTime[0][0], i_dateTime[0][1], i_dateTime[0][2]);
				getdate(i_dateTime[1][0], i_dateTime[1][1], i_dateTime[1][2]);
				GetPlayerIp(playerid, ip, sizeof(ip));
				GetPlayerIp(iTargetID, ipex, sizeof(ipex));
				format(string, sizeof(string), "[%i/%i/%i - %i:%i:%i] %s (IP:%s) has paid $%d to %s (IP:%s)", i_dateTime[1][0], i_dateTime[1][1], i_dateTime[1][2], i_dateTime[0][0], i_dateTime[0][1], i_dateTime[0][2], GetName(playerid), ip, iCashAmount, GetName(iTargetID), ipex);
				PayLog(string);

				if(PlayerInfo[playerid][pAdmin] >= 2)
				{
					format(string, sizeof(string), "[Admin] %s (IP:%s) has paid $%d to %s (IP:%s)", GetName(playerid), ip, iCashAmount, GetName(iTargetID), ipex);
					format(string, sizeof(string), "AdmWarning: %s (IP:%s) has paid $%d to %s (IP:%s)", GetName(playerid), ip, iCashAmount, GetName(iTargetID), ipex);
					ABroadCast(COLOR_YELLOW, string, 2);
				}

				PayWarn[playerid][iTargetID] += iCashAmount;
				if(PayWarn[playerid][iTargetID] >= 100000 && PlayerInfo[playerid][pLevel] <= 3)
				{
					format(string, sizeof(string), "%s (IP:%s) has paid %s (IP:%s) $%d in this session.", GetName(playerid), ip, GetName(iTargetID), ipex, PayWarn[playerid][iTargetID]);
					ABroadCast(COLOR_YELLOW, string, 2);
				}

				if(iCashAmount >= 1000000)
				{
					ABroadCast(COLOR_YELLOW,string,2);
				}

				PlayerPlaySound(iTargetID, 1052, 0.0, 0.0, 0.0);
				format(string, sizeof(string), "* %s takes out some cash, and hands it to %s.", GetName(playerid) ,GetName(iTargetID));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_GREY, "That player isn't near you.");
		}
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "Invalid player specified.");
	return 1;
}

CMD:togwhisper(playerid, params[])
{
	if (!HidePM[playerid])
	{
		HidePM[playerid] = 1;
		SendClientMessage(playerid, COLOR_GRAD2, "You have disabled whisper chat !");
	}
	else
	{
		HidePM[playerid] = 0;
		SendClientMessage(playerid, COLOR_GRAD2, "You have enabled whisper chat !");
	}
	return 1;
}

CMD:low(playerid, params[]) {
	return cmd_l(playerid, params);
}

CMD:l(playerid, params[])
{
	if(isnull(params)) return SendClientMessage(playerid, COLOR_WHITE, "USAGE: (/l)ow [quiet chat]");

	new string[128];
	format(string, sizeof(string), "%s says quietly: %s", GetName(playerid), params);
	ProxDetector(5.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
	format(string, sizeof(string), "(quietly) %s", params);
	SetPlayerChatBubble(playerid,string,COLOR_WHITE,5.0,5000);
	return 1;
}

CMD:w(playerid, params[]) {
	return cmd_whisper(playerid, params);
}

CMD:whisper(playerid, params[])
{
	new giveplayerid, whisper[128];

	if(sscanf(params, "us[128]", giveplayerid, whisper))
	{
		SendClientMessage(playerid, COLOR_WHITE, "USAGE: (/w)hisper [playerid] [message]");
		return 1;
	}
	if (IsPlayerConnected(giveplayerid))
	{
		if(HidePM[giveplayerid] > 0)
		{
			SendClientMessage(playerid, COLOR_GREY, "That player is blocking whispers!");
			return 1;
		}
		new giveplayer[MAX_PLAYER_NAME], sendername[MAX_PLAYER_NAME], string[128];
		sendername = GetName(playerid);
		giveplayer = GetName(giveplayerid);
		if(ProxDetectorS(5.0, playerid, giveplayerid) || PlayerInfo[playerid][pAdmin] >= 2)
		{
			format(string, sizeof(string), "%s(ID: %d) whispers: %s", GetName(playerid), playerid, whisper);
		 	SendClientMessage(giveplayerid,COLOR_YELLOW, string);
		 	
			format(string, sizeof(string), "Whisper to %s(ID: %d): %s", GetName(giveplayerid), giveplayerid, whisper);
			SendClientMessage(playerid,COLOR_YELLOW, string);
			return 1;
		}
		else
		{
			SendClientMessage(playerid, COLOR_GREY, "That player isn't near you !");
		}
		return 1;
	}
	else
	{
		SendClientMessage(playerid, COLOR_GRAD1, "Invalid player specified !");
	}
	return 1;
}

CMD:me(playerid, params[])
{

	new string[128];
	if(isnull(params)) return SendClientMessage(playerid,-1,"USAGE: /me [action]");
    format(string, sizeof(string), "* %s %s", GetName(playerid), params);
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 100.0, 5000);
	return 1;
}

CMD:do(playerid, params[])
{
	new string[128];

	if(isnull(params)) return SendClientMessage(playerid,-1,"USAGE: /do [local chat]");
    format(string, sizeof(string), "* %s (( %s ))", params, GetName(playerid));
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	return 1;
}

CMD:s(playerid,params[])
{
	new string[128];

	if(isnull(params)) return SendClientMessage(playerid,-1,"USAGE: (/s)hout [local chat]");
	format(string, sizeof(string), "%s shouts: %s!", GetName(playerid), params);
	ProxDetector(30.0, playerid, string,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_FADE1,COLOR_FADE2);
	return 1;
}

CMD:shout(playerid, params[]) return cmd_s(playerid, params);

CMD:b(playerid,params[])
{

	new string[128];
	if(isnull(params)) return SendClientMessage(playerid, -1,"USAGE: /b [local ooc]");
	format(string, sizeof(string), "(( %s: %s ))", GetName(playerid), params);
	ProxDetector(30.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
	return 1;
}

CMD:ooc(playerid, params[])
{
	new string[160];

	if(isnull(params)) return SendClientMessage(playerid, -1,"USAGE: /ooc [chat]");
	if ((noooc) && PlayerInfo[playerid][pAdmin] < 1 && gOOC[playerid] == 0)
	{
		SendClientMessage(playerid, COLOR_GREY, "The OOC channel has been disabled by an Admin !");
		return 1;
	}
	else
	{
		format(string,160,"(( %s: %s ))", GetName(playerid), params);
		printf("(( %s: %s ))", GetName(playerid), string);
		OOCOff(COLOR_OOC,string);
	}
	if(gOOC[playerid] == 1)
	{
		SendClientMessage(playerid, COLOR_GREY, "You have the channel toggled, /togooc to re-enable!");
		return 1;
	}
	return 1;
}

CMD:o(playerid, params[]) return cmd_ooc(playerid, params);
//___________________________________________________
public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
    if(!success) SendClientMessage(playerid, COLOR_WHITE, "[SERVER:] Invalid command, please use the available commands in /help.");
    else if(gPlayerLogged[playerid] == 0) { SendClientMessage(playerid, COLOR_GREY, "You're not logged in."); }
    return 1;
}
IsNumeric(const string[])
{
        for (new i = 0, j = strlen(string); i < j; i++)
        {
                if (string[i] > '9' || string[i] < '0') return 0;
        }
        return 1;
}