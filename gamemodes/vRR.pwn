/////////////        ///////////////////////////////////////////////////////////////////////////////////////
////////////  /////  //////////      ////////////        ////////////  /////////  //////////////////////////
///////////  //////  ////////  ////////////////  ///////////////////  //////////  //////////////////////////
//////////  ///////  ///////  ////////////////  ////////////////////  //////////  //////////////////////////
/////////             //////  ///////////////  /////////////////////  //////////  //////////////////////////
////////  /////////  ///////  //////////////  //////////////////////  //////////  //////////////////////////
///////  //////////  ///////  ///////////////  /////////////////////  //////////  //////////////////////////
//////  ///////////  ///////  ////////////////  ////////////////////  //////////  //////////////////////////
/////  ////////////  ///////  /////////////////  ///////////////////              //////////////////////////
////  /////////////  ///////  //////////////////  //////////////////  //////////  //////////////////////////
///  //////////////  ///////  ///////////////////       ////////////  //////////  //////////////////////////
//  ///////////////  ///////  //////////////////////////////////////  //////////  //////////////////////////
//  ////////////////  ///////  //////////////////////////////////////  //////////  //////////////////////////
//Credits to ArchAngel(PjFord)

//includes
#include <a_samp>
#include <core>
#include <float>
#include <zcmd>
#include <YSI\y_ini>
#include <sscanf2>
#pragma tabsize 0

//color defines
#define grey 0xCECECEFF
#define green 0x33AA33AA
#define red 0xFF0000FF
#define yellow 0xFFFF00AA
#define white 0xFFFFFFAA
#define blue 0x0000BBAA
#define orange 0xFF9900AA
#define COLOR_YELLOW 0xD8D8D8FF
#define COLOR_FADE1 0xE6E6E6E6
#define COLOR_FADE2 0xC8C8C8C8
#define COLOR_FADE3 0xAAAAAAAA
#define COLOR_FADE4 0x8C8C8C8C
#define COLOR_FADE5 0x6E6E6E6E
#define COL_WHITE "{FFFFFF}"
#define COL_RED "{F81414}"
#define COL_GREEN "{00FF22}"
#define COL_LIGHTBLUE "{00CED1}"

//other
#define SCM SendClientMessage

//Login/Register System Defines
#define DIALOG_REGISTER 1
#define DIALOG_LOGIN 2
#define DIALOG_SUCCESS_1 3
#define DIALOG_SUCCESS_2 4

//Defining where to save the Accounts
#define PATH "/FCRP/Users/%s.ini"

//Telling the server what to save in the Account files
enum pInfo
{
    pPass,
    pCash,
    pAdmin,
	pSkin,
	pSex,
	Float: PosX[ MAX_PLAYERS ],
    Float: PosY[ MAX_PLAYERS ],
    Float: PosZ[ MAX_PLAYERS ],
    Float: Angle[ MAX_PLAYERS ],
    Interior[ MAX_PLAYERS ],
    VirtualWorld[ MAX_PLAYERS ]
}
new PlayerInfo[MAX_PLAYERS][pInfo];

//Loading the Accounts
forward LoadUser_data(playerid,name[],value[]);
public LoadUser_data(playerid,name[],value[])
{
    INI_Int("Password",PlayerInfo[playerid][pPass]);
    INI_Int("Cash",PlayerInfo[playerid][pCash]);
    INI_Int("Admin",PlayerInfo[playerid][pAdmin]);
	INI_Int("Skin",PlayerInfo[playerid][pSkin]);
	INI_Int("Sex", PlayerInfo[playerid][pSex]);
	INI_Float("PositionX", PlayerInfo[playerid][PosX]);
    INI_Float("PositionY", PlayerInfo[playerid][PosY]);
    INI_Float("PositionZ", PlayerInfo[playerid][PosZ]);
    INI_Float("Angle", PlayerInfo[playerid][Angle]);
    INI_Int("Interior", PlayerInfo[playerid][Interior]);
    INI_Int("VirtualWorld", PlayerInfo[playerid][VirtualWorld]);
    return 1;
}
main()
{
    print("\n--------------------------------------------------/n");
    print(" ----Virtual Reality Roleplay by ChangeMe Loaded----\n");
    print("----------------------------------------------------\n");
}

CMD:cmds(playerid,params[])
{
	SendClientMessage(playerid, green,"_____| Server Commands |_____");
	SendClientMessage(playerid, white, "");
	SendClientMessage(playerid, white, "As of now, I havent added any to add here!");
	SendClientMessage(playerid, white, "Whoopsies");
	return 1;
}
CMD:t(playerid,params[])
{
    new Float:X, Float:Y, Float:Z;
    new Nam[MAX_PLAYERS],message[128],str[128];
    if(sscanf(params,"s",message)) return SendClientMessage(playerid,grey,"[USAGE:] /t [text]");
    GetPlayerPos(playerid,X,Y,Z);
    GetPlayerName(playerid,Nam,sizeof(Nam));
    format(str,sizeof(str),"%s says: %s",Nam, message);
    for(new i=0; i<MAX_PLAYERS; i++)
    {
        if(IsPlayerInRangeOfPoint(i,10, X,Y,Z))
        {
            SendClientMessage(i,0x00E6E6FF,str);
        }
    }
    return 1;
}
CMD:s(playerid,params[])
{
        new Float:X, Float:Y, Float:Z;
        new Nam[MAX_PLAYERS],message[128],str[128];
        if(sscanf(params,"s",message)) return SendClientMessage(playerid,grey,"[USAGE:] /s [text]");
        GetPlayerName(playerid,Nam,sizeof(Nam));
        GetPlayerPos(playerid,X,Y,Z);
        format(str,sizeof(str),"%s shouts: %s",Nam, message);
        for(new i=0; i<MAX_PLAYERS; i++)
        {
                if(IsPlayerInRangeOfPoint(i,20, X,Y,Z))
                {
                    SendClientMessage(i,red,str);
                }
        }
        return 1;
}
CMD:w(playerid,params[])
{
        new Float:X, Float:Y, Float:Z;
        new Nam[MAX_PLAYERS],message[128],str[128];
        if(sscanf(params,"s",message)) return SendClientMessage(playerid,grey,"[USAGE:] /w [text]");
        GetPlayerName(playerid,Nam,sizeof(Nam));
        GetPlayerPos(playerid,X,Y,Z);
        format(str,sizeof(str),"%s Whispers: %s",Nam, message);
        for(new i=0; i<MAX_PLAYERS; i++)
        {
                if(IsPlayerInRangeOfPoint(i, 5.0, X,Y,Z))
                {
                    SendClientMessage(i,0xFF925EFF,str);
                }
        }
        return 1;
}
CMD:me(playerid,params[])
{
    new Nam[MAX_PLAYERS],message[128],str[128];
    if(sscanf(params,"s",message)) return SCM(playerid,grey,"[USAGE:] /me [Text]");
    GetPlayerName(playerid,Nam,sizeof(Nam));
    format(str,sizeof(str),"* %s %s",Nam,message);
    SendClientMessageToAll(orange,str);
    return 1;
}
CMD:setskin(playerid, params[])
{
    new id, skin, name[ MAX_PLAYER_NAME ], name2[ MAX_PLAYER_NAME ], str[ 128 ];
    if(PlayerInfo[playerid][pAdmin] == 0) return SendClientMessage(playerid, red,"[ERROR:] You are not an admin!");
    if( sscanf ( params, "ui", id, skin ) ) return SendClientMessage( playerid, orange, "/setskin [PlayerName/ID] [SkinModel]");
    if( id == INVALID_PLAYER_ID ) return SendClientMessage( playerid, red, "[ERROR:] Invalid player ID!");
    if(skin > 299 || skin < 1) return SendClientMessage(playerid, -1, "Wrong Skin ID! Available ID's: 1-299");
    GetPlayerName( playerid, name, MAX_PLAYER_NAME ); GetPlayerName( id, name2, MAX_PLAYER_NAME );
    format( str, sizeof ( str ),"[INFO:] You have set %s skin to model %d", name2, skin);
    SendClientMessage( playerid, orange -1, str );
    format( str, sizeof ( str ),"[INFO:] Your skin has been set to model %d by %s", skin, name);
    SendClientMessage( id, orange -1, str );
    SetPlayerSkin( id, skin );
 	return 1;
}
CMD:makeadmin(playerid, params[])
{
    new id, skin, name[ MAX_PLAYER_NAME ], name2[ MAX_PLAYER_NAME ], str[ 128 ];
    //if(PlayerInfo[playerid][pAdmin] != 5) return SendClientMessage(playerid, red,"[ERROR:] You are not an admin!");
    if( sscanf ( params, "ui", id, skin ) ) return SendClientMessage( playerid, orange, "[SYNTAX:] /makeadmin [PlayerName/ID] [level]");
    if( id == INVALID_PLAYER_ID ) return SendClientMessage( playerid, red, "[ERROR:] Invalid player ID!");
    if(skin > 299 || skin < 1) return SendClientMessage(playerid, -1, "Wrong Skin ID! Available ID's: 1-299");
    GetPlayerName( playerid, name, MAX_PLAYER_NAME ); GetPlayerName( id, name2, MAX_PLAYER_NAME );
    format( str, sizeof ( str ),"[INFO:] You have made %s a level %d admin.", name2, skin);
    SendClientMessage( playerid, orange -1, str );
    format( str, sizeof ( str ),"[INFO:] Your admin level has been set to %d by %s", skin, name);
    SendClientMessage( id, orange -1, str );
    PlayerInfo[id][pAdmin] == skin;
 	return 1;
}

public OnPlayerSpawn(playerid)
{
    SetPlayerInterior(playerid,0);
    TogglePlayerClock(playerid,0);
    SetPlayerPos(playerid,PlayerInfo[playerid][PosX],PlayerInfo[playerid][PosY],PlayerInfo[playerid][PosZ]);
    SetPlayerColor(playerid,0xFFFFFFFF);
    return 1;
}
public OnPlayerDeath(playerid, killerid, reason)
{
    return 1;
}

SetupPlayerForClassSelection(playerid)
{
    SetPlayerPos(playerid,2537.1050,-1677.2736,19.9302);
    SetPlayerFacingAngle(playerid,85.8876);
    SetPlayerCameraPos(playerid,2526.7771,-1675.5574,19.9302);
    SetPlayerCameraLookAt(playerid,2526.7771,-1675.5574,19.9302);
}

public OnPlayerRequestClass(playerid, classid)
{
    SetupPlayerForClassSelection(playerid);
    return 1;
}
public OnPlayerConnect(playerid)
{
    if(fexist(UserPath(playerid)))
    {
        INI_ParseFile(UserPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT,""COL_WHITE"Login",""COL_WHITE"Type your password below to login.","Login","Quit");
    }
    else
    {
        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT,""COL_WHITE"Registering...",""COL_WHITE"Type your password below to register a new account.","Register","Quit");
    }
    return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch( dialogid )
    {
        case DIALOG_REGISTER:
        {
            if (!response) return Kick(playerid);
            if(response)
            {
                if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, ""COL_WHITE"Registering...",""COL_RED"You have entered an invalid password.\n"COL_WHITE"Type your password below to register a new account.","Register","Quit");
                new INI:File = INI_Open(UserPath(playerid));
                INI_SetTag(File,"data");
                INI_WriteInt(File,"Password",udb_hash(inputtext));
                INI_WriteInt(File,"Cash",0);
                INI_WriteInt(File,"Admin",0);
				INI_WriteInt(File,"Skin",1);
				INI_WriteInt(File,"Sex", 0);
				INI_WriteFloat( File, "PositionX", PlayerInfo[playerid][PosX]);
				INI_WriteFloat( File, "PositionY", PlayerInfo[playerid][PosY]);
				INI_WriteFloat( File, "PositionZ", PlayerInfo[playerid][PosZ]);
				INI_WriteFloat( File, "Angle", PlayerInfo[playerid][Angle] );
				INI_WriteInt( File, "Interior", GetPlayerInterior( playerid ) );
				INI_WriteInt( File, "VirtualWorld", GetPlayerVirtualWorld( playerid ) );
                INI_Close(File);

                SetSpawnInfo(playerid, 0, 0, PlayerInfo[playerid][PosX], PlayerInfo[playerid][PosY], PlayerInfo[playerid][PosZ], 269.15, 0, 0, 0, 0, 0, 0);
                SpawnPlayer(playerid);
                ShowPlayerDialog(playerid, DIALOG_SUCCESS_1, DIALOG_STYLE_MSGBOX,""COL_WHITE"Success!",""COL_GREEN"Great! Your Y_INI system works perfectly. Relog to save your stats!","Ok","");
            }
        }

        case DIALOG_LOGIN:
        {
            if ( !response ) return Kick ( playerid );
            if( response )
            {
                if(udb_hash(inputtext) == PlayerInfo[playerid][pPass])
                {
                    INI_ParseFile(UserPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
                    GivePlayerMoney(playerid, PlayerInfo[playerid][pCash]);
                    ShowPlayerDialog(playerid, DIALOG_SUCCESS_2, DIALOG_STYLE_MSGBOX,""COL_WHITE"Success!",""COL_GREEN"You have successfully logged in!","Ok","");
                }
                else
                {
                    ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT,""COL_WHITE"Login",""COL_RED"You have entered an incorrect password.\n"COL_WHITE"Type your password below to login.","Login","Quit");
                }
                return 1;
            }
        }
    }
    return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	PlayerInfo[playerid][PosX] = x;
	PlayerInfo[playerid][PosY] = y;
	PlayerInfo[playerid][PosZ] = z;
    new INI:File = INI_Open(UserPath(playerid));
    INI_SetTag(File,"data");
    INI_WriteInt(File,"Cash",GetPlayerMoney(playerid));
    INI_WriteInt(File,"Admin",PlayerInfo[playerid][pAdmin]);
	INI_WriteInt(File,"Skin",GetPlayerSkin(playerid));
	INI_WriteInt(File,"Sex",PlayerInfo[playerid][pSex]);
	INI_WriteFloat( File, "PositionX", PlayerInfo[playerid][PosX] );
	INI_WriteFloat( File, "PositionY", PlayerInfo[playerid][PosY] );
	INI_WriteFloat( File, "PositionZ", PlayerInfo[playerid][PosZ] );
	INI_WriteFloat( File, "Angle", PlayerInfo[playerid][Angle] );
	INI_WriteInt( File, "Interior", GetPlayerInterior( playerid ) );
	INI_WriteInt( File, "VirtualWorld", GetPlayerVirtualWorld( playerid ) );
    INI_Close(File);
    return 1;
}
public OnGameModeInit()
{

//Telling the Server the Game Mode
    SetGameModeText("FCRP v1");
//If you want the player blips shown on the mini map, change this to 1.
    ShowPlayerMarkers(0);
//If you don't want player name tags to be shown to other players, change this to 0.
    ShowNameTags(1);

//Telling the Server to use the CJ Run/Walk Style
	UsePlayerPedAnims();

//Skins for Skin Selection
    AddPlayerClass(110,2796.6479,-2543.6895,14.1724,269.0830,0,0,0,0,-1,-1);
    AddPlayerClass(109,2796.6479,-2543.6895,14.1724,269.0830,0,0,0,0,-1,-1);
    AddPlayerClass(108,2796.6479,-2543.6895,14.1724,269.0830,0,0,0,0,-1,-1);
    AddPlayerClass(292,2796.6479,-2543.6895,14.1724,269.0830,0,0,0,0,-1,-1);
    AddPlayerClass(92,2796.6479,-2543.6895,14.1724,269.0830,0,0,0,0,-1,-1);
    
//Vehicles
    AddStaticVehicle(481,1710.2172,1466.9941,10.3314,181.1224,3,3); // BMX
    AddStaticVehicle(510,1703.1008,1429.5359,10.2545,340.5261,46,46); // Mountainbike
    AddStaticVehicle(402,2440.7981,1121.8737,10.8352,273.2132,0,0); // Buffalo
    AddStaticVehicle(429,2172.2168,1019.2421,10.5000,90.2754,14,14); // banshee
    AddStaticVehicle(439,2141.8962,1009.6799,10.6640,92.7715,43,21); // pontiac
    AddStaticVehicle(461,2176.5083,986.4388,10.4063,0.0000,43,1); // motorbike
    AddStaticVehicle(475,2129.0181,987.9767,10.9716,180.6869,17,1); // Sabre
    AddStaticVehicle(451,2040.0520,1319.2799,10.3779,183.2439,16,16);
    AddStaticVehicle(429,2040.5247,1359.2783,10.3516,177.1306,13,13);
    AddStaticVehicle(421,2110.4102,1398.3672,10.7552,359.5964,13,13);
    AddStaticVehicle(411,2074.9624,1479.2120,10.3990,359.6861,64,64);
    AddStaticVehicle(477,2075.6038,1666.9750,10.4252,359.7507,94,94);
    AddStaticVehicle(541,2119.5845,1938.5969,10.2967,181.9064,22,22);
    AddStaticVehicle(541,1843.7881,1216.0122,10.4556,270.8793,60,1);
    AddStaticVehicle(402,1944.1003,1344.7717,8.9411,0.8168,30,30);
    AddStaticVehicle(402,1679.2278,1316.6287,10.6520,180.4150,90,90);
    AddStaticVehicle(415,1685.4872,1751.9667,10.5990,268.1183,25,1);
    AddStaticVehicle(411,2034.5016,1912.5874,11.9048,0.2909,123,1);
    AddStaticVehicle(411,2172.1682,1988.8643,10.5474,89.9151,116,1);
    AddStaticVehicle(429,2245.5759,2042.4166,10.5000,270.7350,14,14);
    AddStaticVehicle(477,2361.1538,1993.9761,10.4260,178.3929,101,1);
    AddStaticVehicle(550,2221.9946,1998.7787,9.6815,92.6188,53,53);
    AddStaticVehicle(558,2243.3833,1952.4221,14.9761,359.4796,116,1);
    AddStaticVehicle(587,2276.7085,1938.7263,31.5046,359.2321,40,1);
    AddStaticVehicle(587,2602.7769,1853.0667,10.5468,91.4813,43,1);
    AddStaticVehicle(603,2610.7600,1694.2588,10.6585,89.3303,69,1);
    AddStaticVehicle(587,2635.2419,1075.7726,10.5472,89.9571,53,1);
    AddStaticVehicle(437,2577.2354,1038.8063,10.4777,181.7069,35,1);
    AddStaticVehicle(535,2039.1257,1545.0879,10.3481,359.6690,123,1);
    AddStaticVehicle(535,2009.8782,2411.7524,10.5828,178.9618,66,1);
    AddStaticVehicle(429,2010.0841,2489.5510,10.5003,268.7720,1,2);
    AddStaticVehicle(415,2076.4033,2468.7947,10.5923,359.9186,36,1);
    AddStaticVehicle(487,2093.2754,2414.9421,74.7556,89.0247,26,57);
    AddStaticVehicle(506,2352.9026,2577.9768,10.5201,0.4091,7,7);
    AddStaticVehicle(506,2166.6963,2741.0413,10.5245,89.7816,52,52);
    AddStaticVehicle(411,1960.9989,2754.9072,10.5473,200.4316,112,1);
    AddStaticVehicle(429,1919.5863,2760.7595,10.5079,100.0753,2,1);
    AddStaticVehicle(415,1673.8038,2693.8044,10.5912,359.7903,40,1);
    AddStaticVehicle(402,1591.0482,2746.3982,10.6519,172.5125,30,30);
    AddStaticVehicle(603,1580.4537,2838.2886,10.6614,181.4573,75,77);
    AddStaticVehicle(550,1555.2734,2750.5261,10.6388,91.7773,62,62);
    AddStaticVehicle(535,1455.9305,2878.5288,10.5837,181.0987,118,1);
    AddStaticVehicle(477,1537.8425,2578.0525,10.5662,0.0650,121,1);
    AddStaticVehicle(451,1433.1594,2607.3762,10.3781,88.0013,16,16);
    AddStaticVehicle(603,2223.5898,1288.1464,10.5104,182.0297,18,1);
    AddStaticVehicle(558,2451.6707,1207.1179,10.4510,179.8960,24,1);
    AddStaticVehicle(550,2461.7253,1357.9705,10.6389,180.2927,62,62);
    AddStaticVehicle(558,2461.8162,1629.2268,10.4496,181.4625,117,1);
    AddStaticVehicle(477,2395.7554,1658.9591,10.5740,359.7374,0,1);
    AddStaticVehicle(404,1553.3696,1020.2884,10.5532,270.6825,119,50);
    AddStaticVehicle(400,1380.8304,1159.1782,10.9128,355.7117,123,1);
    AddStaticVehicle(418,1383.4630,1035.0420,10.9131,91.2515,117,227);
    AddStaticVehicle(404,1445.4526,974.2831,10.5534,1.6213,109,100);
    AddStaticVehicle(400,1704.2365,940.1490,10.9127,91.9048,113,1);
    AddStaticVehicle(404,1658.5463,1028.5432,10.5533,359.8419,101,101);
    AddStaticVehicle(581,1677.6628,1040.1930,10.4136,178.7038,58,1);
    AddStaticVehicle(581,1383.6959,1042.2114,10.4121,85.7269,66,1);
    AddStaticVehicle(581,1064.2332,1215.4158,10.4157,177.2942,72,1);
    AddStaticVehicle(581,1111.4536,1788.3893,10.4158,92.4627,72,1);
    AddStaticVehicle(522,953.2818,1806.1392,8.2188,235.0706,3,8);
    AddStaticVehicle(522,995.5328,1886.6055,10.5359,90.1048,3,8);
    AddStaticVehicle(521,993.7083,2267.4133,11.0315,1.5610,75,13);
    AddStaticVehicle(535,1439.5662,1999.9822,10.5843,0.4194,66,1);
    AddStaticVehicle(522,1430.2354,1999.0144,10.3896,352.0951,6,25);
    AddStaticVehicle(522,2156.3540,2188.6572,10.2414,22.6504,6,25);
    AddStaticVehicle(598,2277.6846,2477.1096,10.5652,180.1090,0,1);
    AddStaticVehicle(598,2268.9888,2443.1697,10.5662,181.8062,0,1);
    AddStaticVehicle(598,2256.2891,2458.5110,10.5680,358.7335,0,1);
    AddStaticVehicle(598,2251.6921,2477.0205,10.5671,179.5244,0,1);
    AddStaticVehicle(523,2294.7305,2441.2651,10.3860,9.3764,0,0);
    AddStaticVehicle(523,2290.7268,2441.3323,10.3944,16.4594,0,0);
    AddStaticVehicle(523,2295.5503,2455.9656,2.8444,272.6913,0,0);
    AddStaticVehicle(522,2476.7900,2532.2222,21.4416,0.5081,8,82);
    AddStaticVehicle(522,2580.5320,2267.9595,10.3917,271.2372,8,82);
    AddStaticVehicle(522,2814.4331,2364.6641,10.3907,89.6752,36,105);
    AddStaticVehicle(535,2827.4143,2345.6953,10.5768,270.0668,97,1);
    AddStaticVehicle(521,1670.1089,1297.8322,10.3864,359.4936,87,118);
    AddStaticVehicle(487,1614.7153,1548.7513,11.2749,347.1516,58,8);
    AddStaticVehicle(487,1647.7902,1538.9934,11.2433,51.8071,0,8);
    AddStaticVehicle(487,1608.3851,1630.7268,11.2840,174.5517,58,8);
    AddStaticVehicle(476,1283.0006,1324.8849,9.5332,275.0468,7,6); //11.5332
    AddStaticVehicle(476,1283.5107,1361.3171,9.5382,271.1684,1,6); //11.5382
    AddStaticVehicle(476,1283.6847,1386.5137,11.5300,272.1003,89,91);
    AddStaticVehicle(476,1288.0499,1403.6605,11.5295,243.5028,119,117);
    AddStaticVehicle(415,1319.1038,1279.1791,10.5931,0.9661,62,1);
    AddStaticVehicle(521,1710.5763,1805.9275,10.3911,176.5028,92,3);
    AddStaticVehicle(521,2805.1650,2027.0028,10.3920,357.5978,92,3);
    AddStaticVehicle(535,2822.3628,2240.3594,10.5812,89.7540,123,1);
    AddStaticVehicle(521,2876.8013,2326.8418,10.3914,267.8946,115,118);
    AddStaticVehicle(429,2842.0554,2637.0105,10.5000,182.2949,1,3);
    AddStaticVehicle(549,2494.4214,2813.9348,10.5172,316.9462,72,39);
    AddStaticVehicle(549,2327.6484,2787.7327,10.5174,179.5639,75,39);
    AddStaticVehicle(549,2142.6970,2806.6758,10.5176,89.8970,79,39);
    AddStaticVehicle(521,2139.7012,2799.2114,10.3917,229.6327,25,118);
    AddStaticVehicle(521,2104.9446,2658.1331,10.3834,82.2700,36,0);
    AddStaticVehicle(521,1914.2322,2148.2590,10.3906,267.7297,36,0);
    AddStaticVehicle(549,1904.7527,2157.4312,10.5175,183.7728,83,36);
    AddStaticVehicle(549,1532.6139,2258.0173,10.5176,359.1516,84,36);
    AddStaticVehicle(521,1534.3204,2202.8970,10.3644,4.9108,118,118);
    AddStaticVehicle(549,1613.1553,2200.2664,10.5176,89.6204,89,35);
    AddStaticVehicle(400,1552.1292,2341.7854,10.9126,274.0815,101,1);
    AddStaticVehicle(404,1637.6285,2329.8774,10.5538,89.6408,101,101);
    AddStaticVehicle(400,1357.4165,2259.7158,10.9126,269.5567,62,1);
    AddStaticVehicle(411,1281.7458,2571.6719,10.5472,270.6128,106,1);
    AddStaticVehicle(522,1305.5295,2528.3076,10.3955,88.7249,3,8);
    AddStaticVehicle(521,993.9020,2159.4194,10.3905,88.8805,74,74);
    AddStaticVehicle(415,1512.7134,787.6931,10.5921,359.5796,75,1);
    AddStaticVehicle(522,2299.5872,1469.7910,10.3815,258.4984,3,8);
    AddStaticVehicle(522,2133.6428,1012.8537,10.3789,87.1290,3,8);
    AddStaticVehicle(415,2266.7336,648.4756,11.0053,177.8517,0,1); //
    AddStaticVehicle(461,2404.6636,647.9255,10.7919,183.7688,53,1); //
    AddStaticVehicle(506,2628.1047,746.8704,10.5246,352.7574,3,3); //
    AddStaticVehicle(549,2817.6445,928.3469,10.4470,359.5235,72,39); //
    AddStaticVehicle(562,1919.8829,947.1886,10.4715,359.4453,11,1); //
    AddStaticVehicle(562,1881.6346,1006.7653,10.4783,86.9967,11,1); //
    AddStaticVehicle(562,2038.1044,1006.4022,10.4040,179.2641,11,1); //
    AddStaticVehicle(562,2038.1614,1014.8566,10.4057,179.8665,11,1); //
    AddStaticVehicle(562,2038.0966,1026.7987,10.4040,180.6107,11,1); //
    AddStaticVehicle(422,9.1065,1165.5066,19.5855,2.1281,101,25); //
    AddStaticVehicle(463,19.8059,1163.7103,19.1504,346.3326,11,11); //
    AddStaticVehicle(463,12.5740,1232.2848,18.8822,121.8670,22,22); //
    AddStaticVehicle(434,-110.8473,1133.7113,19.7091,359.7000,2,2); //hotknife
    AddStaticVehicle(586,69.4633,1217.0189,18.3304,158.9345,10,1); //
    AddStaticVehicle(586,-199.4185,1223.0405,19.2624,176.7001,25,1); //
    AddStaticVehicle(605,-340.2598,1177.4846,19.5565,182.6176,43,8); // SMASHED UP CAR
    AddStaticVehicle(476,325.4121,2538.5999,17.5184,181.2964,71,77); //
    AddStaticVehicle(476,291.0975,2540.0410,17.5276,182.7206,7,6); //
    AddStaticVehicle(576,384.2365,2602.1763,16.0926,192.4858,72,1); //
    AddStaticVehicle(586,423.8012,2541.6870,15.9708,338.2426,10,1); //
    AddStaticVehicle(586,-244.0047,2724.5439,62.2077,51.5825,10,1); //
    AddStaticVehicle(586,-311.1414,2659.4329,62.4513,310.9601,27,1); //
    AddStaticVehicle(406,547.4633,843.0204,-39.8406,285.2948,1,1); // DUMPER
    AddStaticVehicle(406,625.1979,828.9873,-41.4497,71.3360,1,1); // DUMPER
    AddStaticVehicle(486,680.7997,919.0510,-40.4735,105.9145,1,1); // DOZER
    AddStaticVehicle(486,674.3994,927.7518,-40.6087,128.6116,1,1); // DOZER
    AddStaticVehicle(543,596.8064,866.2578,-43.2617,186.8359,67,8); //
    AddStaticVehicle(543,835.0838,836.8370,11.8739,14.8920,8,90); //
    AddStaticVehicle(549,843.1893,838.8093,12.5177,18.2348,79,39); //
    AddStaticVehicle(605,319.3803,740.2404,6.7814,271.2593,8,90); // SMASHED UP CAR
    AddStaticVehicle(400,-235.9767,1045.8623,19.8158,180.0806,75,1); //
    AddStaticVehicle(599,-211.5940,998.9857,19.8437,265.4935,0,1); //
    AddStaticVehicle(422,-304.0620,1024.1111,19.5714,94.1812,96,25); //
    AddStaticVehicle(588,-290.2229,1317.0276,54.1871,81.7529,1,1); //
    AddStaticVehicle(424,-330.2399,1514.3022,75.1388,179.1514,2,2); //BF INJECT
    AddStaticVehicle(451,-290.3145,1567.1534,75.0654,133.1694,61,61); //
    AddStaticVehicle(470,280.4914,1945.6143,17.6317,310.3278,43,0); //
    AddStaticVehicle(470,272.2862,1949.4713,17.6367,285.9714,43,0); //
    AddStaticVehicle(470,271.6122,1961.2386,17.6373,251.9081,43,0); //
    AddStaticVehicle(470,279.8705,1966.2362,17.6436,228.4709,43,0); //
    AddStaticVehicle(433,277.6437,1985.7559,18.0772,270.4079,43,0); //
    AddStaticVehicle(433,277.4477,1994.8329,18.0773,267.7378,43,0); //
    AddStaticVehicle(568,-441.3438,2215.7026,42.2489,191.7953,41,29); //
    AddStaticVehicle(568,-422.2956,2225.2612,42.2465,0.0616,41,29); //
    AddStaticVehicle(568,-371.7973,2234.5527,42.3497,285.9481,41,29); //
    AddStaticVehicle(568,-360.1159,2203.4272,42.3039,113.6446,41,29); //
    AddStaticVehicle(468,-660.7385,2315.2642,138.3866,358.7643,6,6); //
    AddStaticVehicle(460,-1029.2648,2237.2217,42.2679,260.5732,1,3); //
    AddStaticVehicle(411,113.8611,1068.6182,13.3395,177.1330,116,1); //
    AddStaticVehicle(429,159.5199,1185.1160,14.7324,85.5769,1,2); //
    AddStaticVehicle(411,612.4678,1694.4126,6.7192,302.5539,75,1); //
    AddStaticVehicle(522,661.7609,1720.9894,6.5641,19.1231,6,25); //
    AddStaticVehicle(522,660.0554,1719.1187,6.5642,12.7699,8,82); //
    AddStaticVehicle(567,711.4207,1947.5208,5.4056,179.3810,90,96); //
    AddStaticVehicle(567,1031.8435,1920.3726,11.3369,89.4978,97,96); //
    AddStaticVehicle(567,1112.3754,1747.8737,10.6923,270.9278,102,114); //
    AddStaticVehicle(567,1641.6802,1299.2113,10.6869,271.4891,97,96); //
    AddStaticVehicle(567,2135.8757,1408.4512,10.6867,180.4562,90,96); //
    AddStaticVehicle(567,2262.2639,1469.2202,14.9177,91.1919,99,81); //
    AddStaticVehicle(567,2461.7380,1345.5385,10.6975,0.9317,114,1); //
    AddStaticVehicle(567,2804.4365,1332.5348,10.6283,271.7682,88,64); //
    AddStaticVehicle(560,2805.1685,1361.4004,10.4548,270.2340,17,1); //
    AddStaticVehicle(506,2853.5378,1361.4677,10.5149,269.6648,7,7); //
    AddStaticVehicle(567,2633.9832,2205.7061,10.6868,180.0076,93,64); //
    AddStaticVehicle(567,2119.9751,2049.3127,10.5423,180.1963,93,64); //
    AddStaticVehicle(567,2785.0261,-1835.0374,9.6874,226.9852,93,64); //
    AddStaticVehicle(567,2787.8975,-1876.2583,9.6966,0.5804,99,81); //
    AddStaticVehicle(411,2771.2993,-1841.5620,9.4870,20.7678,116,1); //
    AddStaticVehicle(420,1713.9319,1467.8354,10.5219,342.8006,6,1); // taxi

    return 1;
}

//stocking the user path
stock UserPath(playerid)
{
    new string[128],playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),PATH,playername);
    return string;
}

//Hashing Player's Account Passwords. Credits to DracoBlue
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
