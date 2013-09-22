// .:--------------------------------------------------------------:.
// .:==============================================================:.
//       ShuffRoam Indev. Unreleased.
//
//		 Mainly scripted by Shuffz/Ken. Anyone else shouldnt be here.
//       2012, 29 October. Signed. LULZ LET IT BEGIN
//
//       Started development: 29 October 2012
//       Started again: 21 January 2012
//
// .:==============================================================:.
// .:--------------------------------------------------------------:.

//================================================================

new version[10] = "0.001";

//================================================================
#include <a_samp>
#include <YSI\y_ini>
#include <zcmd>
#include <sscanf2>
#include <streamer>
#include <foreach>
//-----[INI includes]-----
#define DIALOG_REGISTER 1
#define DIALOG_LOGIN 2
#define DIALOG_TUNE 3
#define DIAV 4
#define DIALOG_AOB 19
#define PATH "/ShuffRoam/Users/%s.ini"
#define AOPATH "/ShuffRoam/Users/AttachedObjects/%s.ini"

#define KEY_AIM (128)
#define KEY_HORN (2)
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

//-----[Color defines]-----
#define COLOR_WHITE             0xFFFFFFFF
#define COLOR_GREEN             0x33AA33AA
#define COLOR_RED               0xA10000AA
#define COLOR_YELLOW            0xFFFF00AA
#define COLOR_GREY				0xAFAFAFAA
#define LIME 					0x88AA62FF
#define WHITE 					0xFFFFFFAA
#define RULE 					0xFBDF89AA
#define ORANGE 					0xDB881AAA

#define GREY 					0xAFAFAFAA
#define GREEN 					0x9FFF00FF
#define RED 					0xA10000AA
#define YELLOW 					0xFFFF00AA
#define WHITE 					0xFFFFFFAA

//-----[0.3c Color defines]-----
#define COL_EASY           "{FFF1AF}"
#define COL_DGREEN		   "{0E8C00}"
#define COL_LOGIN		   "{98E090}"
#define COL_WHITE          "{FFFFFF}"
#define COL_BLACK          "{0E0101}"
#define COL_GREY           "{C3C3C3}"
#define COL_GREEN          "{6EF83C}"
#define COL_RED            "{F81414}"
#define COL_YELLOW         "{F3FF02}"
#define COL_ORANGE         "{F9B857}"
#define COL_LIME           "{B7FF00}"
#define COL_CYAN           "{00FFEE}"
#define COL_BLUE           "{0049FF}"
#define COL_MAGENTA        "{F300FF}"
#define COL_VIOLET         "{B700FF}"
#define COL_PINK           "{FF00EA}"
#define COL_MARONE         "{A90202}"
#define COL_CMD            "{B8FF02}"
#define COL_PARAM          "{3FCD02}"
#define COL_SERVER         "{AFE7FF}"
#define COL_VALUE          "{A3E4FF}"
#define COL_RULE           "{F9E8B7}"
#define COL_RULE2          "{FBDF89}"
#define COL_RWHITE         "{FFFFFF}"
#define COL_LGREEN         "{9FE4AA}"
#define COL_LRED           "{DA7272}"
#define COL_LRED2          "{C77D87}"
#define COL_DYELLOW		   "{FAFA52}"
#define COL_BROWN		   "{8C703F}"
#define COL_SBLACK         "{474747}"
#define COL_SGREY          "{ADADAD}"
#define COL_DGREY          "{616161}"
#define COL_SBLUE		   "{3660D1}"
#define COL_LBLUE 		   "{00CED1}"

new Text3D:Admin[ MAX_PLAYERS ], AdminDuty[ MAX_PLAYERS ],
	checkinv = 0;


new mycar[MAX_PLAYERS];

forward carfix();
forward randommsg();

new Text:undertext;

new item1, item2, item3, item4, item5;

new
	Float:g_EventPosition[4],
	g_EventWeapon = -1,
	g_EventReward = 0,
	g_EventPlayers = 0,
	pInEvent[MAX_PLAYERS] = 0,
	g_EventOpen = 0;
//-----[Enum Playerinfo]-----
enum pInfo
{
    Password,
    Cash,
    Kills,
    Deaths,
	Skin,
	Cookies,
	Float:Speedboost,
    Adminlevel
}
new PlayerInfo[MAX_PLAYERS][pInfo];

enum aInfo
{
	// first
	Model,
	ID,
	Float:oX,
	Float:rX,
	Float:oY,
	Float:rY,
	Float:oZ,
	Float:rZ,
	// second
	Model2,
	ID2,
	Float:oX2,
	Float:rX2,
	Float:oY2,
	Float:rY2,
	Float:oZ2,
	Float:rZ2,
	// third
	Model3,
	ID3,
	Float:oX3,
	Float:rX3,
	Float:oY3,
	Float:rY3,
	Float:oZ3,
	Float:rZ3,
	// fourth
	Model4,
	ID4,
	Float:oX4,
	Float:rX4,
	Float:oY4,
	Float:rY4,
	Float:oZ4,
	Float:rZ4,
	// fifth
	Model5,
	ID5,
	Float:oX5,
	Float:rX5,
	Float:oY5,
	Float:rY5,
	Float:oZ5,
	Float:rZ5
}

new AOInfo[MAX_PLAYERS][aInfo];

main()
{
	print("-----------------------------------");
	print("|        ShuffRoam Indev          |");
	printf("|         Version v%s          |", version);
	print("|      Loaded successfully        |");
	print("-----------------------------------");
}
new randomMsg[][] =
{
    ""#COL_LBLUE"~ "#COL_WHITE"Go to mount chilliad with "#COL_LBLUE"/chilliad ~",
    ""#COL_LBLUE"~ "#COL_WHITE"You can spawn your own vehicle with "#COL_LBLUE"/veh"#COL_LBLUE" ~",
    ""#COL_LBLUE"~ "#COL_WHITE"Dont ask to be an admin."#COL_LBLUE" ~",
	""#COL_LBLUE"~ "#COL_WHITE"Use "#COL_LBLUE"/pm"#COL_WHITE" to send another player a message."#COL_LBLUE" ~",
	""#COL_LBLUE"~ "#COL_WHITE"Use "#COL_LBLUE"/teles"#COL_WHITE" to see our teleports.."#COL_LBLUE" ~"
};

new Float:RandomSpawn[][3] =
{
    {403.6374,2447.7241,16.5000}, // aa
    {2119.0869, -2616.2554, 13.5469}, // lsair
    {-2620.0549,1414.5328,7.0938} // jiggy
};

public OnGameModeInit()
{
	undertext = TextDrawCreate(20.000000, 431.000000, "ShuffRoam Indev [] /lsair [] Peter [] Make [] Maps []");
	TextDrawBackgroundColor(undertext, 255);
	TextDrawFont(undertext, 1);
	TextDrawLetterSize(undertext, 0.500000, 1.000000);
	TextDrawColor(undertext, -1);
	TextDrawSetOutline(undertext, 0);
	TextDrawSetProportional(undertext, 1);
	TextDrawSetShadow(undertext, 1);
	// Vehicles
	AddStaticVehicle(451,-2411.5598,-585.6307,132.3086,215.6878,11,1); // drift1
	AddStaticVehicle(451,-2414.1277,-587.6025,132.3079,216.2504,116,1); // drift1
	AddStaticVehicle(562,-2416.4407,-589.3303,132.3071,215.8436,113,1); // drift1
	AddStaticVehicle(562,-2408.9907,-583.7567,132.3065,216.1684,101,1); // drift1
	AddStaticVehicle(541,-318.0000,1515.9618,74.9823,359.7057,68,8); // drift2
	AddStaticVehicle(541,-324.0556,1515.7854,74.9845,0.5455,2,1); // drift2
	AddStaticVehicle(562,-321.0821,1515.7133,75.0186,0.4362,92,1); // drift2
	AddStaticVehicle(562,-314.7585,1515.8209,75.0156,1.2582,36,1); //  drift2
	AddStaticVehicle(451,2312.4407,1387.3271,42.4799,359.1716,35,1); //  drift3
	AddStaticVehicle(562,2309.1775,1387.3855,42.4786,359.5522,17,1); //  drift3
	AddStaticVehicle(451,2305.5750,1387.3441,42.4799,359.3799,11,1); //  drift3
	AddStaticVehicle(562,2302.3088,1387.4829,42.4798,358.7405,113,1); //  drift3
	// AA
	AddStaticVehicle(566, 422.1494, 2456.2971, 16.6550, 99.9000, 252, 1);
	AddStaticVehicle(541, 422.5320, 2452.4800, 16.6485, 102.9600, 252, 1);
	AddStaticVehicle(541, 422.8239, 2447.8926, 16.6061, 107.4600, 5, 1);
	AddStaticVehicle(411, 422.9463, 2442.6206, 16.3757, 66.0600, 138, 1);
	AddStaticVehicle(411, 416.9286, 2437.8254, 16.6641, 0.0000, 312, 1);
	AddStaticVehicle(522, 399.6383, 2437.0479, 16.1925, 0.0000, 132, 1);
	AddStaticVehicle(522, 414.7514, 2436.6504, 16.1925, 0.0000, 142, 1);
	AddStaticVehicle(522, 413.3470, 2436.9670, 16.1925, 0.0000, 132, 1);
	AddStaticVehicle(522, 412.1402, 2437.1863, 16.1925, 0.0000, 124, 1);
	AddStaticVehicle(522, 410.8504, 2437.4438, 16.1925, 0.0000, 255, 1);
	AddStaticVehicle(522, 409.6347, 2437.6597, 16.1925, 0.0000, 123, 1);
	AddStaticVehicle(522, 408.3750, 2437.9043, 16.1925, 0.0000, 123, 1);
	AddStaticVehicle(522, 407.4449, 2437.7917, 16.1925, 0.0000, 234, 1);
	AddStaticVehicle(522, 406.3276, 2437.6565, 16.1925, 0.0000, 276, 1);
	AddStaticVehicle(522, 405.1793, 2437.5176, 16.1925, 0.0000, 298, 1);
	AddStaticVehicle(522, 403.9483, 2437.3687, 16.1925, 0.0000, 198, 1);
	AddStaticVehicle(522, 402.8076, 2437.2837, 16.1925, 0.0000, 167, 1);
	AddStaticVehicle(522, 401.6833, 2437.2002, 16.1925, 0.0000, 187, 1);
	AddStaticVehicle(522, 400.6816, 2437.1255, 16.1925, 0.0000, 132, 1);
	AddStaticVehicle(411, 396.5830, 2439.2434, 16.7292, -18.4200, 176, 1);
	AddStaticVehicle(411, 393.3968, 2440.0627, 16.7790, -20.3400, 153, 1);
	AddStaticVehicle(451, 389.7756, 2441.1018, 16.5029, -18.4200, 143, 1);
	AddStaticVehicle(451, 386.8734, 2448.5510, 16.6804, -59.0400, 187, 1);
	// something
	AddStaticVehicleEx(411,1380.13598633,-2427.86596680,525.43133545,271.99951172,-1,-1,15); //Infernus
    AddStaticVehicleEx(556,1385.83801270,-2446.53002930,525.76275635,2.00000000,-1,-1,15); //Monster A
    AddStaticVehicleEx(556,1390.08813477,-2446.54736328,525.89727783,1.99951172,-1,-1,15); //Monster A
    AddStaticVehicleEx(556,1394.35778809,-2446.52661133,525.66802979,1.99951172,-1,-1,15); //Monster A
    AddStaticVehicleEx(411,1380.06774902,-2434.24023438,525.43133545,271.99951172,-1,-1,15); //Infernus
    AddStaticVehicleEx(411,1379.59570312,-2441.22338867,525.43133545,271.99951172,-1,-1,15); //Infernus
    AddStaticVehicleEx(522,1380.17028809,-2431.11547852,525.29174805,270.00000000,-1,-1,15); //NRG-500
    AddStaticVehicleEx(522,1380.51647949,-2437.39746094,525.29174805,270.00000000,-1,-1,15); //NRG-500
    AddStaticVehicleEx(522,1379.65490723,-2424.14770508,525.29174805,270.00000000,-1,-1,15); //NRG-500
    AddStaticVehicleEx(451,1380.25830078,-2419.88012695,525.39569092,268.00000000,-1,-1,15); //Turismo
    AddStaticVehicleEx(451,1380.15979004,-2416.35034180,525.39569092,267.99499512,-1,-1,15); //Turismo
    AddStaticVehicleEx(431,1404.79833984,-2443.35864258,525.92706299,4.00000000,-1,-1,15); //Bus
    AddStaticVehicleEx(431,1400.19372559,-2443.80566406,525.98114014,3.99902344,-1,-1,15); //Bus
    AddStaticVehicleEx(406,1393.10400391,-2411.15478516,527.32476807,182.00000000,-1,-1,15); //Dumper
    AddStaticVehicleEx(406,1399.11865234,-2411.06884766,527.26928711,181.99951172,-1,-1,15); //Dumper

	CreateDynamicObject(18450, 1342.40, -2484.92, 24.76,   0.00, 348.00, 180.00);
	CreateDynamicObject(18450, 758.72, -2482.10, 172.87,   0.00, 336.00, 180.00);
	CreateDynamicObject(18450, 1328.89, -2484.90, 27.68,   0.03, -12.34, 179.87);
	CreateDynamicObject(18450, 1311.02, -2484.84, 31.63,   0.04, -12.54, 179.81);
	CreateDynamicObject(18450, 1289.26, -2484.76, 36.50,   0.05, -12.69, 179.77);
	CreateDynamicObject(18450, 1264.07, -2484.65, 42.20,   0.06, -12.81, 179.75);
	CreateDynamicObject(18450, 1235.91, -2484.51, 48.63,   0.07, -12.93, 179.73);
	CreateDynamicObject(18450, 1205.24, -2484.36, 55.71,   0.07, -13.05, 179.72);
	CreateDynamicObject(18450, 1172.53, -2484.18, 63.32,   0.07, -13.17, 179.71);
	CreateDynamicObject(18450, 1138.24, -2484.00, 71.38,   0.08, -13.29, 179.71);
	CreateDynamicObject(18450, 1102.83, -2483.81, 79.79,   0.08, -13.43, 179.70);
	CreateDynamicObject(18450, 1066.76, -2483.61, 88.46,   0.08, -13.58, 179.70);
	CreateDynamicObject(18450, 1030.49, -2483.41, 97.28,   0.08, -13.76, 179.70);
	CreateDynamicObject(18450, 994.49, -2483.21, 106.16,   0.08, -13.96, 179.70);
	CreateDynamicObject(18450, 959.22, -2483.01, 115.00,   0.08, -14.20, 179.71);
	CreateDynamicObject(18450, 925.14, -2482.83, 123.71,   0.08, -14.49, 179.71);
	CreateDynamicObject(18450, 892.71, -2482.66, 132.19,   0.08, -14.84, 179.72);
	CreateDynamicObject(18450, 862.39, -2482.50, 140.35,   0.08, -15.30, 179.73);
	CreateDynamicObject(18450, 834.65, -2482.37, 148.08,   0.07, -15.90, 179.75);
	CreateDynamicObject(18450, 809.96, -2482.25, 155.30,   0.07, -16.74, 179.78);
	CreateDynamicObject(18450, 788.76, -2482.17, 161.90,   0.06, -17.98, 179.81);
	CreateDynamicObject(18450, 771.53, -2482.12, 167.79,   0.04, -20.03, 179.88);
	CreateDynamicObject(8040, 682.21, -2481.71, 190.27,   0.00, 0.00, 0.00);
	CreateDynamicObject(8397, 720.39, -2467.82, 149.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(8397, 720.38, -2472.10, 149.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(8397, 720.81, -2496.41, 149.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(8397, 720.75, -2492.06, 149.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(8397, 720.38, -2464.02, 149.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(8397, 720.69, -2500.83, 149.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(8493, 1247.50, -2396.64, 27.56,   0.00, 0.00, 214.00);
	CreateDynamicObject(8881, 1252.23, -2535.79, 23.99,   0.00, 0.00, 28.00);
	CreateDynamicObject(8881, 1268.06, -2622.25, 28.24,   0.00, 0.00, 40.00);
	CreateDynamicObject(8881, 1306.42, -2688.98, 23.99,   0.00, 0.00, 68.00);
	CreateDynamicObject(8881, 1369.06, -2727.72, 23.99,   0.00, 0.00, 95.99);
	CreateDynamicObject(8881, 1444.00, -2744.63, 23.99,   0.00, 0.00, 101.99);
	CreateDynamicObject(8881, 1519.24, -2746.45, 23.99,   0.00, 0.00, 121.99);
	CreateDynamicObject(8881, 1594.05, -2737.97, 17.38,   0.00, 0.00, 121.99);
	CreateDynamicObject(8882, 1422.85, -2787.99, 33.41,   0.00, 0.00, 284.00);
	CreateDynamicObject(8882, 1503.60, -2800.40, 33.41,   0.00, 0.00, 308.00);
	CreateDynamicObject(8882, 1592.34, -2785.89, 33.41,   0.00, 0.00, 308.00);
	CreateDynamicObject(8882, 1343.35, -2778.43, 33.41,   0.00, 0.00, 272.00);
	CreateDynamicObject(8882, 1284.47, -2732.11, 33.41,   0.00, 0.00, 247.99);
	CreateDynamicObject(8882, 1236.35, -2673.28, 33.41,   0.00, 0.00, 235.99);
	CreateDynamicObject(8882, 1202.15, -2606.04, 33.41,   0.00, 0.00, 221.99);
	CreateDynamicObject(8882, 1195.07, -2532.98, 33.41,   0.00, 0.00, 199.98);
	CreateDynamicObject(9052, 1408.27, -2641.07, 19.32,   0.00, 0.00, 24.00);
	CreateDynamicObject(9052, 1420.53, -2646.56, 19.32,   0.00, 0.00, 24.00);
	CreateDynamicObject(7586, 1605.95, -2414.03, 28.15,   0.00, 0.00, 2.00);
	CreateDynamicObject(7586, 1873.31, -2243.41, 28.15,   0.00, 0.00, 2.00);
	CreateDynamicObject(7586, 1524.64, -2413.57, 28.15,   0.00, 0.00, 2.00);
	CreateDynamicObject(7586, 1685.33, -2413.54, 28.15,   0.00, 0.00, 26.00);
	CreateDynamicObject(7586, 1767.40, -2413.74, 28.00,   0.00, 0.00, 2.00);
	CreateDynamicObject(7586, 1873.31, -2328.47, 28.15,   0.00, 0.00, 2.00);
	CreateDynamicObject(8397, 1488.35, -2656.23, -26.42,   0.00, 0.00, 0.00);
	CreateDynamicObject(8397, 1560.65, -2656.76, -26.42,   0.00, 0.00, 0.00);
	CreateDynamicObject(8397, 1535.82, -2656.77, -26.42,   0.00, 0.00, 0.00);
	CreateDynamicObject(8397, 1512.37, -2656.34, -26.42,   0.00, 0.00, 0.00);
	CreateDynamicObject(8397, 1462.57, -2656.25, -26.78,   0.00, 0.00, 0.00);
	CreateDynamicObject(8397, 1969.08, -2178.78, -29.39,   0.00, 0.00, 0.00);
	CreateDynamicObject(8397, 1969.15, -2183.01, -29.39,   0.00, 0.00, 0.00);
	CreateDynamicObject(8397, 1969.17, -2187.27, -29.39,   0.00, 0.00, 0.00);
	CreateDynamicObject(8397, 1954.45, -2187.33, -29.39,   0.00, 0.00, 0.00);
	CreateDynamicObject(8397, 1954.38, -2182.97, -29.39,   0.00, 0.00, 0.00);
	CreateDynamicObject(8397, 1954.32, -2178.60, -29.39,   0.00, 0.00, 0.00);
	CreateDynamicObject(3472, 1968.99, -2196.12, 11.80,   0.00, 0.00, 60.00);
	CreateDynamicObject(3472, 1953.54, -2196.24, 11.55,   0.00, 0.00, 230.00);
	CreateDynamicObject(3472, 1985.01, -2218.45, 11.80,   0.00, 0.00, 60.00);
	CreateDynamicObject(3472, 1992.63, -2186.68, 11.80,   0.00, 0.00, 60.00);
	CreateDynamicObject(3472, 2003.15, -2218.95, 11.80,   0.00, 0.00, 60.00);
	CreateDynamicObject(3472, 2024.26, -2185.75, 11.80,   0.00, 0.00, 60.00);
	CreateDynamicObject(3472, 2042.95, -2220.35, 11.80,   0.00, 0.00, 60.00);
	CreateDynamicObject(3472, 2058.10, -2187.92, 11.80,   0.00, 0.00, 60.00);
	CreateDynamicObject(3472, 2091.34, -2203.91, 11.80,   0.00, 0.00, 60.00);
	CreateDynamicObject(3472, 2116.38, -2220.80, 11.80,   0.00, 0.00, 60.00);
	CreateDynamicObject(3472, 2100.77, -2237.24, 11.80,   0.00, 0.00, 60.00);
	CreateDynamicObject(3472, 2062.79, -2241.51, 11.80,   0.00, 0.00, 60.00);
	CreateDynamicObject(3472, 2079.95, -2284.49, 11.80,   0.00, 0.00, 60.00);
	CreateDynamicObject(3472, 2048.90, -2277.89, 11.80,   0.00, 0.00, 60.00);
	CreateDynamicObject(3472, 2084.01, -2326.00, 11.80,   0.00, 0.00, 60.00);
	CreateDynamicObject(3472, 2059.53, -2334.01, 11.80,   0.00, 0.00, 122.00);
	CreateDynamicObject(3472, 2083.57, -2355.68, 11.80,   0.00, 0.00, 121.99);
	CreateDynamicObject(3472, 2031.91, -2393.82, 11.80,   0.00, 0.00, 121.99);
	CreateDynamicObject(3472, 2083.58, -2403.96, 11.80,   0.00, 0.00, 121.99);
	CreateDynamicObject(3472, 1999.82, -2335.91, 11.80,   0.00, 0.00, 121.99);
	CreateDynamicObject(3472, 1998.47, -2293.05, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1994.49, -2240.97, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1936.42, -2239.58, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1897.56, -2259.49, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1893.67, -2311.57, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1889.06, -2355.53, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1856.56, -2372.13, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1804.76, -2400.75, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1787.62, -2432.88, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1749.37, -2432.34, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1711.14, -2421.85, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1701.86, -2435.45, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1666.68, -2433.07, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1628.36, -2421.94, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1624.51, -2431.83, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1586.75, -2428.08, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1546.82, -2420.69, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1542.47, -2432.87, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1504.16, -2431.47, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1463.02, -2442.16, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1427.68, -2444.72, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1378.28, -2445.63, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1371.97, -2470.87, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1372.97, -2499.76, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1376.67, -2564.75, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1389.16, -2618.39, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1449.71, -2644.80, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1500.70, -2652.90, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1475.07, -2653.65, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1525.23, -2653.15, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1547.67, -2652.60, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1575.59, -2652.86, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1634.31, -2635.63, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1695.67, -2633.70, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1771.67, -2635.90, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1839.47, -2635.65, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1905.62, -2635.02, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1941.39, -2652.26, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1991.18, -2650.93, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 2043.08, -2652.61, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 2088.11, -2650.48, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 2116.34, -2632.58, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 2135.52, -2608.16, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 2145.82, -2579.24, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 2145.55, -2541.91, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 2145.84, -2500.68, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 2144.43, -2466.30, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 2138.68, -2420.37, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 2000.54, -2409.97, 11.80,   0.00, 0.00, 175.99);
	CreateDynamicObject(3472, 1456.21, -2360.39, 12.55,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1431.16, -2331.94, 12.55,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1375.20, -2349.26, 12.55,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1312.81, -2338.24, 12.55,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1288.43, -2347.83, 12.09,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1291.57, -2322.97, 12.51,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1300.19, -2291.79, 12.49,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1315.89, -2281.81, 12.55,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1265.93, -2272.99, 12.49,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1290.23, -2226.12, 16.64,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1304.40, -2222.29, 12.53,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1296.07, -2248.41, 12.48,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1240.50, -2297.49, 12.15,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1234.26, -2318.37, 25.82,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1301.56, -2398.19, 12.52,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1293.77, -2420.89, 10.04,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1278.04, -2420.16, 10.09,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1296.38, -2482.38, 10.28,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1265.92, -2481.33, 9.28,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1233.63, -2476.04, 9.78,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1205.17, -2467.42, 10.49,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1171.36, -2445.96, 13.42,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1161.00, -2422.59, 22.16,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1171.00, -2379.65, 18.82,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1182.90, -2396.02, 10.06,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1209.81, -2413.30, 9.58,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1231.89, -2421.95, 9.29,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1257.64, -2426.79, 9.04,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1309.31, -2523.31, 12.49,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1307.94, -2563.87, 12.54,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1323.44, -2603.02, 12.54,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1333.34, -2643.50, 12.54,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1365.72, -2673.48, 12.54,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1396.93, -2691.77, 12.54,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1435.63, -2699.08, 12.54,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1717.80, -2680.66, 12.55,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1787.47, -2685.67, 12.55,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1855.87, -2684.27, 12.55,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1919.95, -2683.74, 12.55,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1648.88, -2682.50, 12.55,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1586.02, -2682.06, 12.55,   0.00, 0.00, 177.99);
	CreateDynamicObject(3472, 1838.20, -2390.75, 12.55,   0.00, 0.00, 177.99);
	CreateDynamicObject(3054, 1429.42, -2445.07, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1436.07, -2639.33, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1433.03, -2639.43, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1428.95, -2639.34, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1428.80, -2643.90, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1431.71, -2643.72, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1436.60, -2644.88, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1434.84, -2643.95, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1440.10, -2644.77, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1438.77, -2641.41, 12.57,   0.00, 0.00, 40.00);
	CreateDynamicObject(2898, 1441.71, -2648.47, 12.57,   0.00, 0.00, 58.00);
	CreateDynamicObject(2898, 1445.78, -2650.59, 12.57,   0.00, 0.00, 58.00);
	CreateDynamicObject(2898, 1443.65, -2654.41, 12.57,   0.00, 0.00, 58.00);
	CreateDynamicObject(2898, 1444.62, -2653.38, 12.57,   0.00, 0.00, 58.00);
	CreateDynamicObject(2898, 1441.59, -2652.47, 12.57,   0.00, 0.00, 58.00);
	CreateDynamicObject(2898, 1429.68, -2647.59, 12.57,   0.00, 0.00, 58.00);
	CreateDynamicObject(2898, 1438.11, -2640.24, 12.57,   0.00, 0.00, 40.00);
	CreateDynamicObject(2898, 1426.02, -2639.14, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1423.31, -2638.71, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1420.84, -2638.31, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1417.38, -2637.75, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1416.87, -2640.96, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1413.66, -2640.44, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1409.95, -2639.84, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1413.35, -2637.60, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1410.39, -2637.13, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1407.43, -2636.65, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1402.99, -2635.93, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1404.47, -2636.17, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1400.91, -2633.06, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1403.63, -2633.50, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1396.97, -2633.95, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1394.26, -2633.51, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1396.75, -2630.62, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1398.97, -2630.98, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1401.68, -2631.41, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1404.65, -2631.89, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1407.11, -2632.29, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1410.57, -2632.85, 12.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2898, 1413.53, -2633.32, 12.57,   0.00, 0.00, 358.00);
	CreateDynamicObject(2898, 1416.74, -2633.84, 12.57,   0.00, 0.00, 355.99);
	CreateDynamicObject(2898, 1419.70, -2634.32, 12.57,   0.00, 0.00, 353.99);
	CreateDynamicObject(2898, 1422.66, -2634.79, 12.57,   0.00, 0.00, 351.98);
	CreateDynamicObject(2898, 1425.87, -2635.31, 12.57,   0.00, 0.00, 349.98);
	CreateDynamicObject(2898, 1428.83, -2635.79, 12.57,   0.00, 0.00, 345.97);
	CreateDynamicObject(2898, 1392.65, -2629.96, 12.57,   0.00, 0.00, 345.97);
	CreateDynamicObject(2898, 1388.70, -2629.32, 12.57,   0.00, 0.00, 345.97);
	CreateDynamicObject(2898, 1385.49, -2628.80, 12.57,   0.00, 0.00, 345.97);
	CreateDynamicObject(2898, 1382.28, -2628.29, 12.57,   0.00, 0.00, 345.97);
	CreateDynamicObject(2898, 1383.80, -2630.09, 12.57,   0.00, 0.00, 345.97);
	CreateDynamicObject(2898, 1432.37, -2636.38, 12.57,   0.00, 0.00, 345.97);
	CreateDynamicObject(2898, 1435.70, -2637.45, 12.57,   0.00, 0.00, 345.97);
	CreateDynamicObject(2898, 1438.32, -2638.30, 12.57,   0.00, 0.00, 345.97);
	CreateDynamicObject(2898, 1441.41, -2639.30, 12.57,   0.00, 0.00, 343.97);
	CreateDynamicObject(2898, 1444.74, -2640.37, 12.57,   0.00, 0.00, 343.97);
	CreateDynamicObject(2898, 1443.28, -2644.89, 12.57,   0.00, 0.00, 343.97);
	CreateDynamicObject(2898, 1446.07, -2646.84, 12.57,   0.00, 0.00, 343.97);
	CreateDynamicObject(2898, 1449.40, -2647.92, 12.57,   0.00, 0.00, 343.97);
	CreateDynamicObject(2898, 1450.22, -2651.86, 12.57,   0.00, 0.00, 343.97);
	CreateDynamicObject(2898, 1448.99, -2655.67, 12.57,   0.00, 0.00, 343.97);
	CreateDynamicObject(2898, 1446.55, -2656.72, 12.57,   0.00, 0.00, 343.97);
	CreateDynamicObject(2898, 1448.21, -2657.25, 12.57,   0.00, 0.00, 343.97);
	CreateDynamicObject(2898, 1447.86, -2653.46, 12.57,   0.00, 0.00, 343.97);
	CreateDynamicObject(2898, 1452.01, -2648.76, 12.57,   0.00, 0.00, 343.97);
	CreateDynamicObject(2898, 1453.24, -2644.96, 12.57,   0.00, 0.00, 343.97);
	CreateDynamicObject(2898, 1453.70, -2643.53, 12.57,   0.00, 0.00, 343.97);
	CreateDynamicObject(2898, 1449.89, -2642.30, 12.57,   0.00, 0.00, 343.97);
	CreateDynamicObject(2898, 1447.28, -2641.45, 12.57,   0.00, 0.00, 343.97);
	CreateDynamicObject(2898, 1450.57, -2652.94, 12.57,   0.00, 0.00, 343.97);
	CreateDynamicObject(18449, 1960.84, -2158.80, 49.52,   0.00, 2.00, 90.00);
	CreateDynamicObject(18449, 1938.71, -1790.48, 187.40,   358.51, 317.98, 90.66);
	CreateDynamicObject(18449, 1960.70, -2146.40, 49.72,   -0.24, -3.36, 91.10);
	CreateDynamicObject(18449, 1960.32, -2132.18, 51.06,   -0.46, -7.14, 91.83);
	CreateDynamicObject(18449, 1959.72, -2116.34, 53.47,   -0.67, -9.96, 92.33);
	CreateDynamicObject(18449, 1958.92, -2099.10, 56.86,   -0.86, -12.15, 92.68);
	CreateDynamicObject(18449, 1957.94, -2080.65, 61.15,   -1.03, -13.94, 92.93);
	CreateDynamicObject(18449, 1956.81, -2061.21, 66.27,   -1.19, -15.45, 93.11);
	CreateDynamicObject(18449, 1955.56, -2040.98, 72.13,   -1.34, -16.77, 93.23);
	CreateDynamicObject(18449, 1954.21, -2020.17, 78.65,   -1.48, -17.95, 93.31);
	CreateDynamicObject(18449, 1952.78, -1998.98, 85.76,   -1.61, -19.05, 93.36);
	CreateDynamicObject(18449, 1951.30, -1977.62, 93.37,   -1.73, -20.09, 93.37);
	CreateDynamicObject(18449, 1949.80, -1956.30, 101.40,   -1.84, -21.12, 93.36);
	CreateDynamicObject(18449, 1948.29, -1935.22, 109.78,   -1.94, -22.15, 93.32);
	CreateDynamicObject(18449, 1946.81, -1914.58, 118.42,   -2.03, -23.23, 93.25);
	CreateDynamicObject(18449, 1945.37, -1894.61, 127.24,   -2.10, -24.38, 93.15);
	CreateDynamicObject(18449, 1944.01, -1875.50, 136.17,   -2.16, -25.64, 93.02);
	CreateDynamicObject(18449, 1942.74, -1857.45, 145.12,   -2.20, -27.09, 92.85);
	CreateDynamicObject(18449, 1941.59, -1840.68, 154.01,   -2.20, -28.78, 92.63);
	CreateDynamicObject(18449, 1940.59, -1825.39, 162.76,   -2.17, -30.85, 92.34);
	CreateDynamicObject(18449, 1939.76, -1811.79, 171.30,   -2.07, -33.49, 91.95);
	CreateDynamicObject(18449, 1939.13, -1800.08, 179.54,   -1.87, -37.02, 91.42);
	CreateDynamicObject(18779, 1313.61, -2473.36, 42.94,   0.00, 0.00, 180.14);
	CreateDynamicObject(18779, 1313.61, -2473.36, 36.39,   0.00, 0.00, 180.14);
	CreateDynamicObject(18783, 2122.88, -2419.09, 15.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(18783, 2102.92, -2419.10, 15.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2102.89, -2438.59, 14.33,   18.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2122.92, -2438.62, 14.33,   18.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2112.61, -2417.92, 20.00,   33.00, 0.00, 0.00);
	CreateDynamicObject(18837, 2196.92, -2775.13, 210.00,   90.00, 0.00, 136.23);
	CreateDynamicObject(18983, 2136.06, -2779.92, 210.03,   0.00, 0.00, 269.94);
	CreateDynamicObject(18983, 2036.52, -2779.83, 210.03,   0.00, 0.00, 269.94);
	CreateDynamicObject(18983, 1936.67, -2779.70, 210.03,   0.00, 0.00, 269.94);
	CreateDynamicObject(18983, 1836.83, -2779.59, 210.03,   0.00, 0.00, 269.94);
	CreateDynamicObject(18983, 1737.09, -2779.49, 210.03,   0.00, 0.00, 269.94);
	CreateDynamicObject(18983, 1637.64, -2779.39, 210.03,   0.00, 0.00, 269.94);
	CreateDynamicObject(18983, 1537.83, -2779.29, 210.03,   0.00, 0.00, 269.94);
	CreateDynamicObject(18983, 2201.21, -2714.04, 210.02,   0.00, 0.00, 180.06);
	CreateDynamicObject(18983, 2200.74, -2564.60, 210.12,   0.00, 0.00, 180.06);
	CreateDynamicObject(18820, 2151.22, -2639.52, 210.48,   90.00, 0.00, 0.00);
	CreateDynamicObject(18818, 2193.04, -2639.25, 210.19,   91.00, 0.00, 90.75);
	CreateDynamicObject(18983, 2151.15, -2564.99, 210.52,   0.00, 0.00, 180.06);
	CreateDynamicObject(18837, 2186.00, -2693.45, 210.51,   90.00, 0.00, 223.54);
	CreateDynamicObject(18820, 2151.20, -2688.68, 210.48,   90.00, 0.00, 0.00);
	CreateDynamicObject(18837, 2185.11, -2764.07, 210.52,   90.00, 0.00, 136.23);
	CreateDynamicObject(18837, 2169.96, -2749.49, 210.51,   90.00, 0.00, 136.23);
	CreateDynamicObject(18837, 2155.71, -2724.32, 210.50,   90.00, 0.00, 44.52);
	CreateDynamicObject(19129, 2174.79, -2733.92, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2194.58, -2751.31, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2194.46, -2711.50, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2194.60, -2731.43, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(18983, 2124.32, -2768.91, 210.53,   0.00, 0.00, 269.94);
	CreateDynamicObject(18983, 2109.01, -2754.45, 210.53,   0.00, 0.00, 269.94);
	CreateDynamicObject(18983, 2024.91, -2768.78, 210.53,   0.00, 0.00, 269.94);
	CreateDynamicObject(18983, 1925.46, -2768.66, 210.53,   0.00, 0.00, 269.94);
	CreateDynamicObject(18837, 2048.00, -2749.67, 210.50,   90.00, 0.00, 44.52);
	CreateDynamicObject(18837, 2115.72, -2693.85, 210.50,   90.00, 0.00, 317.19);
	CreateDynamicObject(18837, 2107.09, -2716.38, 210.51,   90.00, 0.00, 136.23);
	CreateDynamicObject(18837, 2084.93, -2716.46, 210.50,   90.00, 0.00, 44.52);
	CreateDynamicObject(18983, 2080.35, -2655.43, 210.53,   0.00, 0.00, 180.06);
	CreateDynamicObject(18837, 2115.27, -2634.72, 210.50,   90.00, 0.00, 44.52);
	CreateDynamicObject(18829, 2110.76, -2598.88, 210.36,   90.00, 0.00, 0.00);
	CreateDynamicObject(18829, 2070.06, -2508.87, 210.75,   90.00, 0.00, 0.00);
	CreateDynamicObject(18818, 2102.66, -2549.49, 210.50,   91.00, 0.00, 90.75);
	CreateDynamicObject(18837, 2074.67, -2544.99, 210.81,   90.00, 0.00, 44.52);
	CreateDynamicObject(18829, 2110.19, -2500.55, 210.35,   90.00, 0.00, 0.00);
	CreateDynamicObject(18837, 2076.00, -2594.35, 210.51,   90.00, 0.00, 223.54);
	CreateDynamicObject(18983, 2014.98, -2589.42, 210.53,   0.00, 0.00, 269.94);
	CreateDynamicObject(18837, 2065.71, -2473.28, 210.71,   90.00, 0.00, 223.54);
	CreateDynamicObject(18837, 2177.77, -2504.37, 210.51,   90.00, 0.00, 223.54);
	CreateDynamicObject(18837, 2155.64, -2504.18, 210.51,   90.00, 0.00, 315.51);
	CreateDynamicObject(18837, 2181.47, -2526.29, 205.12,   17.00, 40.00, 94.78);
	CreateDynamicObject(18812, 2175.49, -2527.91, 163.36,   0.00, 0.00, 359.90);
	CreateDynamicObject(18823, 2165.29, -2529.41, 118.91,   4.00, -40.00, 180.34);
	CreateDynamicObject(18983, 2097.96, -2529.05, 105.39,   0.00, 0.00, 88.40);
	CreateDynamicObject(18983, 1998.56, -2526.27, 105.39,   0.00, 0.00, 88.40);
	CreateDynamicObject(18983, 1898.83, -2523.50, 105.39,   0.00, 0.00, 88.40);
	CreateDynamicObject(18837, 2114.85, -2464.59, 210.51,   90.00, 0.00, 315.51);
	CreateDynamicObject(18829, 2150.75, -2459.17, 210.04,   90.00, 0.00, 271.56);
	CreateDynamicObject(18837, 2196.20, -2463.04, 210.20,   90.00, 0.00, 223.54);
	CreateDynamicObject(18829, 2200.67, -2498.77, 210.15,   90.00, 0.00, 0.00);
	CreateDynamicObject(18829, 2160.22, -2458.92, 210.14,   90.00, 0.00, 271.56);
	CreateDynamicObject(19129, 2042.98, -2729.97, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2042.95, -2710.00, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2042.91, -2690.14, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2042.93, -2670.21, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2042.91, -2650.23, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2023.09, -2650.27, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2003.33, -2650.28, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 1983.47, -2650.31, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 1963.62, -2650.29, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 1956.03, -2588.76, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 1936.03, -2588.75, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(18783, 2066.56, -2549.39, 14.78,   0.00, 0.00, 0.00);
	CreateDynamicObject(18786, 2066.51, -2569.37, 14.78,   0.00, 0.00, 269.84);
	CreateDynamicObject(18786, 2066.59, -2549.78, 19.53,   0.00, 0.00, 269.74);
	CreateDynamicObject(18783, 2066.71, -2529.45, 14.78,   0.00, 0.00, 0.00);
	CreateDynamicObject(18783, 2066.77, -2529.95, 19.52,   0.00, 0.00, 0.00);
	CreateDynamicObject(18786, 2066.61, -2530.40, 24.42,   0.00, 0.00, 269.74);
	CreateDynamicObject(19129, 2066.67, -2510.65, 26.84,   0.00, 0.00, 0.00);
	CreateDynamicObject(18783, 2066.63, -2510.68, 14.87,   0.00, 0.00, 0.00);
	CreateDynamicObject(18783, 2066.72, -2510.76, 19.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(18783, 2066.74, -2510.76, 24.38,   0.00, 0.00, 0.00);
	CreateDynamicObject(18777, 2042.24, -2502.47, 29.42,   0.00, 0.00, 0.00);
	CreateDynamicObject(18777, 2042.34, -2502.73, 55.37,   0.00, 0.00, 0.00);
	CreateDynamicObject(18783, 2081.79, -2382.20, 19.25,   0.00, 0.00, 359.90);
	CreateDynamicObject(18783, 2062.89, -2382.21, 19.32,   0.00, 0.00, 0.00);
	CreateDynamicObject(18772, 2072.69, -2377.52, 29.47,   0.00, 0.00, 359.90);
	CreateDynamicObject(19129, 2064.56, -2382.24, 22.27,   18.00, 0.00, 91.52);
	CreateDynamicObject(18777, 2053.01, -2252.65, 29.43,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2069.10, -2246.02, 52.62,   0.00, 0.00, 354.88);
	CreateDynamicObject(18772, 1946.52, -2292.83, 55.42,   0.00, 0.00, 111.96);
	CreateDynamicObject(18777, 1902.36, -2219.91, 27.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(18781, 1960.71, -2202.28, 61.52,   0.00, 0.00, 180.71);
	CreateDynamicObject(19129, 1922.61, -2214.54, 51.25,   0.00, 0.00, 358.08);
	CreateDynamicObject(19129, 1923.28, -2197.04, 55.93,   25.00, 0.00, 358.00);
	CreateDynamicObject(19129, 1923.96, -2178.11, 59.94,   0.00, 0.00, 359.05);
	CreateDynamicObject(19129, 1942.71, -2178.64, 55.63,   25.00, 0.00, 89.38);
	CreateDynamicObject(19129, 1944.33, -2178.91, 54.97,   18.00, 0.00, 89.07);
	CreateDynamicObject(18783, 1921.15, -2259.35, 15.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 1921.21, -2278.84, 14.33,   18.00, 0.00, 0.00);
	CreateDynamicObject(18783, 1921.42, -2239.41, 19.89,   0.00, 0.00, 358.92);
	CreateDynamicObject(19129, 1921.18, -2258.75, 19.27,   18.00, 0.00, 359.28);
	CreateDynamicObject(19129, 1921.59, -2240.80, 22.43,   18.00, 0.00, 359.28);
	CreateDynamicObject(18781, 1975.24, -2406.06, 22.60,   0.00, 0.00, 180.71);
	CreateDynamicObject(18830, 1864.56, -2432.61, 14.51,   180.00, 0.00, 186.19);
	CreateDynamicObject(18830, 1832.69, -2436.30, 14.51,   180.00, 0.00, 186.19);
	CreateDynamicObject(18778, 1892.17, -2429.03, 12.20,   0.00, 0.00, 96.25);
	CreateDynamicObject(18778, 1884.31, -2429.89, 15.32,   0.00, 0.00, 96.13);
	CreateDynamicObject(18780, 2033.09, -2421.69, 2.74,   0.00, 0.00, 0.00);
	CreateDynamicObject(18780, 2033.10, -2431.52, 2.74,   0.00, 0.00, 0.00);
	CreateDynamicObject(18780, 2072.85, -2321.29, 43.86,   0.00, 0.00, 89.92);
	CreateDynamicObject(19129, 2086.57, -2484.40, 32.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2106.37, -2484.38, 32.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2126.03, -2484.38, 32.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2145.97, -2484.35, 32.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2146.13, -2464.39, 32.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2146.01, -2444.58, 32.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2145.99, -2425.17, 32.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2145.92, -2405.38, 32.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2145.91, -2385.58, 32.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2127.76, -2385.47, 26.70,   33.00, 0.00, 269.93);
	CreateDynamicObject(19129, 2066.67, -2484.27, 32.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(18781, 2026.39, -2543.80, 23.43,   0.00, 0.00, 272.32);
	CreateDynamicObject(19129, 2146.05, -2504.21, 32.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2146.10, -2524.16, 32.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2145.94, -2543.93, 32.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2126.26, -2543.81, 32.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2106.73, -2543.94, 32.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2086.72, -2543.96, 32.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(8397, 1964.79, -2395.09, -35.65,   0.00, 0.00, 0.00);
	CreateDynamicObject(8397, 1985.77, -2395.02, -35.65,   0.00, 0.00, 0.00);
	CreateDynamicObject(8397, 2006.59, -2533.41, -35.65,   0.00, 0.00, 0.00);
	CreateDynamicObject(8397, 2007.79, -2555.29, -35.65,   0.00, 0.00, 5.74);
	CreateDynamicObject(18779, 1828.61, -2623.29, 15.35,   0.00, 0.00, 90.48);
	CreateDynamicObject(18779, 1895.46, -2621.79, 15.35,   0.00, 0.00, 90.48);
	CreateDynamicObject(18779, 1760.10, -2622.71, 15.35,   0.00, 0.00, 90.48);
	CreateDynamicObject(18779, 1688.70, -2621.66, 15.35,   0.00, 0.00, 90.48);
	CreateDynamicObject(18779, 1623.16, -2621.71, 15.35,   0.00, 0.00, 90.48);
	CreateDynamicObject(19070, 1632.64, -2544.69, 12.00,   0.00, 0.00, 270.66);
	CreateDynamicObject(19070, 1691.55, -2543.82, 11.98,   0.00, 0.00, 91.05);
	CreateDynamicObject(8397, 1702.17, -2514.75, -35.65,   0.00, 0.00, 359.89);
	CreateDynamicObject(8397, 1623.00, -2514.63, -35.65,   0.00, 0.00, 359.89);
	CreateDynamicObject(8397, 1623.30, -2572.87, -35.65,   0.00, 0.00, 359.89);
	CreateDynamicObject(8397, 1702.44, -2573.11, -35.65,   0.00, 0.00, 359.89);
	CreateDynamicObject(19073, 1719.88, -2666.39, 24.50,   0.00, 0.00, 271.20);
	CreateDynamicObject(19073, 1788.48, -2664.79, 24.50,   0.00, 0.00, 271.20);
	CreateDynamicObject(19073, 1857.54, -2663.84, 24.50,   0.00, 0.00, 271.20);
	CreateDynamicObject(19073, 1930.30, -2664.25, 26.07,   4.00, 0.00, 271.00);
	CreateDynamicObject(19073, 1988.79, -2663.19, 28.12,   0.00, 0.00, 271.20);
	CreateDynamicObject(19073, 2048.39, -2661.93, 28.12,   0.00, 0.00, 271.20);
	CreateDynamicObject(18824, 2113.40, -2607.22, 19.68,   105.00, 0.00, 136.00);
	CreateDynamicObject(19129, 2206.69, -2668.39, 27.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(19073, 2107.44, -2660.61, 28.12,   0.00, 0.00, 271.20);
	CreateDynamicObject(19073, 2166.71, -2659.51, 28.12,   0.00, 0.00, 271.20);
	CreateDynamicObject(19129, 2226.58, -2668.40, 27.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2206.70, -2648.54, 27.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2226.67, -2648.41, 27.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(19073, 2215.39, -2609.58, 28.12,   0.00, 0.00, 0.09);
	CreateDynamicObject(19073, 2215.31, -2550.10, 28.12,   0.00, 0.00, 0.09);
	CreateDynamicObject(19129, 2225.48, -2510.79, 27.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2205.64, -2510.70, 27.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2225.60, -2491.35, 27.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2205.74, -2491.36, 27.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(19073, 2170.37, -2500.88, 39.28,   -25.00, 0.00, 271.00);
	CreateDynamicObject(19073, 2123.33, -2452.45, 51.75,   0.00, 0.00, 0.95);
	CreateDynamicObject(19129, 2133.80, -2511.52, 51.83,   0.00, 0.00, 0.93);
	CreateDynamicObject(19129, 2133.47, -2491.62, 51.83,   0.00, 0.00, 0.93);
	CreateDynamicObject(19129, 2114.11, -2511.78, 51.83,   0.00, 0.00, 0.93);
	CreateDynamicObject(19129, 2113.70, -2491.89, 51.83,   0.00, 0.00, 0.93);
	CreateDynamicObject(19129, 2132.19, -2412.76, 51.83,   0.00, 0.00, 0.93);
	CreateDynamicObject(19129, 2112.25, -2413.03, 51.83,   0.00, 0.00, 0.93);
	CreateDynamicObject(19129, 2131.84, -2392.96, 51.83,   0.00, 0.00, 0.93);
	CreateDynamicObject(19129, 2111.96, -2393.05, 51.83,   0.00, 0.00, 0.93);
	CreateDynamicObject(19073, 2072.00, -2404.32, 51.85,   0.00, 0.00, 270.97);
	CreateDynamicObject(19073, 2013.06, -2405.23, 51.85,   0.00, 0.00, 270.97);
	CreateDynamicObject(19073, 1953.96, -2406.37, 51.85,   0.00, 0.00, 270.97);
	CreateDynamicObject(19073, 1894.36, -2407.33, 51.85,   0.00, 0.00, 270.97);
	CreateDynamicObject(19073, 1835.51, -2408.30, 51.85,   0.00, 0.00, 270.97);
	CreateDynamicObject(19073, 1775.71, -2409.44, 51.85,   0.00, 0.00, 270.97);
	CreateDynamicObject(19073, 1716.64, -2410.48, 51.85,   0.00, 0.00, 270.97);
	CreateDynamicObject(19073, 1658.03, -2411.48, 51.85,   0.00, 0.00, 270.97);
	CreateDynamicObject(19073, 1598.84, -2412.38, 51.85,   0.00, 0.00, 270.97);
	CreateDynamicObject(19073, 1539.26, -2413.41, 51.85,   0.00, 0.00, 270.97);
	CreateDynamicObject(19073, 1479.63, -2414.36, 51.85,   0.00, 0.00, 270.97);
	CreateDynamicObject(19073, 1420.04, -2415.36, 51.85,   0.00, 0.00, 270.97);
	CreateDynamicObject(19070, 1360.97, -2415.58, 46.50,   0.00, 0.00, 269.35);
	CreateDynamicObject(19070, 1305.55, -2414.74, 36.58,   0.00, 0.00, 268.98);
	CreateDynamicObject(19073, 1282.21, -2415.29, 39.99,   0.00, 0.00, 270.97);
	CreateDynamicObject(19073, 1223.39, -2416.28, 39.99,   0.00, 0.00, 270.97);
	CreateDynamicObject(19073, 1164.02, -2417.29, 39.99,   0.00, 0.00, 270.97);
	CreateDynamicObject(19070, 1105.20, -2418.13, 34.71,   0.00, 0.00, 270.69);
	CreateDynamicObject(19070, 1062.97, -2418.57, 25.04,   0.00, 0.00, 270.69);
	CreateDynamicObject(19070, 1005.63, -2419.28, 14.60,   0.00, 0.00, 270.69);
	CreateDynamicObject(19070, 951.29, -2419.88, 4.84,   0.00, 0.00, 270.69);
	CreateDynamicObject(19073, 894.20, -2422.16, 0.10,   0.00, 0.00, 273.77);
	CreateDynamicObject(19073, 837.11, -2425.94, 0.10,   0.00, 0.00, 273.77);
	CreateDynamicObject(1225, 809.54, -2410.77, 0.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1225, 809.86, -2412.87, 0.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1225, 810.29, -2415.10, 0.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1225, 811.18, -2419.97, 0.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1225, 811.49, -2421.84, 0.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1225, 811.49, -2423.86, 0.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1225, 811.83, -2425.11, 0.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1225, 812.55, -2430.19, 0.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1225, 812.87, -2432.28, 0.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1225, 812.80, -2434.42, 0.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1225, 812.67, -2435.76, 0.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1225, 813.26, -2433.23, 0.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1225, 812.73, -2439.56, 0.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1225, 812.78, -2442.15, 0.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1225, 812.82, -2444.56, 0.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1225, 812.96, -2443.43, 0.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1225, 813.08, -2445.88, 0.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1225, 812.77, -2441.01, 0.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1225, 812.85, -2430.92, 0.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1225, 811.81, -2422.78, 0.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1225, 811.50, -2420.91, 0.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1225, 812.26, -2425.37, 0.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1225, 810.96, -2416.08, 0.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1225, 810.11, -2413.95, 0.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1225, 810.02, -2411.72, 0.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1225, 809.97, -2410.03, 0.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(18859, 1727.54, -2385.76, 23.49,   0.00, 0.00, 0.00);
	CreateDynamicObject(18859, 1646.57, -2384.34, 23.49,   0.00, 0.00, 0.00);
	CreateDynamicObject(18859, 1565.60, -2384.74, 23.49,   0.00, 0.00, 0.00);
	CreateDynamicObject(18859, 1490.66, -2384.06, 23.49,   0.00, 0.00, 0.00);
	CreateDynamicObject(18859, 1437.61, -2399.95, 23.49,   0.00, 0.00, 0.00);
	CreateDynamicObject(18859, 1389.16, -2399.89, 23.49,   0.00, 0.00, 0.00);
	CreateDynamicObject(18779, 1388.32, -2466.60, 22.38,   0.00, 0.00, 359.16);
	CreateDynamicObject(18800, 1426.08, -2543.71, 22.63,   0.00, 0.00, 179.87);
	CreateDynamicObject(18800, 1467.01, -2543.71, 46.13,   0.00, 0.00, 359.46);
	CreateDynamicObject(18800, 1423.89, -2588.83, 45.74,   0.00, 0.00, 179.87);
	CreateDynamicObject(18800, 1477.88, -2634.27, 45.63,   0.00, 0.00, 359.46);
	CreateDynamicObject(18800, 1421.23, -2679.86, 45.74,   0.00, 0.00, 179.87);
	CreateDynamicObject(18830, 1776.74, -2555.41, 21.85,   180.00, 47.00, 1.13);
	CreateDynamicObject(18830, 1776.47, -2534.42, 21.85,   180.00, 47.00, 1.13);
	CreateDynamicObject(18804, 1519.83, -2700.48, 34.44,   0.00, 0.00, 1.50);
	CreateDynamicObject(18801, 1595.39, -2708.07, 57.46,   0.00, 0.00, 188.57);
	CreateDynamicObject(18804, 1665.50, -2715.90, 34.44,   0.00, 0.00, 1.50);
	CreateDynamicObject(18804, 1814.59, -2711.99, 34.44,   0.00, 0.00, 1.50);
	CreateDynamicObject(18824, 2074.66, -2609.64, 31.15,   105.00, 0.00, 51.62);
	CreateDynamicObject(18824, 2070.91, -2572.81, 42.60,   105.00, 0.00, 319.94);
	CreateDynamicObject(18824, 2108.99, -2569.81, 53.87,   105.00, 0.00, 229.17);
	CreateDynamicObject(18824, 2110.61, -2606.59, 65.32,   105.00, 0.00, 136.00);
	CreateDynamicObject(3131, 1744.85, -2465.05, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1785.55, -2479.96, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1783.93, -2459.55, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1715.97, -2481.39, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1753.31, -2484.51, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1693.97, -2461.23, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1681.36, -2512.10, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1702.88, -2506.30, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1774.97, -2503.65, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1738.64, -2498.37, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1765.63, -2532.69, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1808.95, -2529.40, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1810.60, -2559.01, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1816.51, -2495.39, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1718.45, -2509.31, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1702.85, -2554.96, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1708.49, -2539.84, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1743.76, -2535.83, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1760.35, -2565.51, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1795.19, -2553.89, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1735.65, -2576.66, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1713.61, -2579.82, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1740.98, -2599.56, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1796.11, -2592.89, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1829.47, -2608.14, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1766.01, -2609.74, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1736.59, -2614.06, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1755.14, -2588.27, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1827.36, -2593.76, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1838.28, -2571.54, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1893.84, -2523.79, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1880.72, -2550.17, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1884.80, -2574.11, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1907.49, -2612.29, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1876.77, -2607.93, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1870.74, -2580.75, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1867.70, -2599.46, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1882.73, -2562.27, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1807.22, -2549.11, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1751.44, -2542.86, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1781.18, -2538.12, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1846.45, -2532.75, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1875.46, -2540.78, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1860.92, -2550.49, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1866.02, -2512.44, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1871.89, -2514.18, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1828.89, -2516.25, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1791.29, -2510.81, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1773.95, -2515.91, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1810.59, -2519.00, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1872.96, -2487.58, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1838.46, -2495.60, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1829.27, -2495.68, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1846.37, -2467.85, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1891.23, -2463.33, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1923.16, -2467.23, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1838.13, -2474.43, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1809.75, -2472.93, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1828.12, -2480.54, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1872.20, -2477.65, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1930.86, -2496.55, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1899.35, -2507.27, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1935.94, -2464.25, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1914.00, -2431.75, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1856.27, -2454.48, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1915.21, -2482.99, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1939.93, -2575.39, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1913.63, -2550.76, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1836.12, -2517.75, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1846.78, -2513.18, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1874.95, -2534.82, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1910.91, -2562.32, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(3131, 1955.42, -2477.02, 35.34,   0.00, 0.00, 272.09);
	CreateDynamicObject(18809, 2066.90, -2618.59, 71.06,   90.00, 0.00, 270.28);
	CreateDynamicObject(18809, 2017.53, -2618.82, 71.06,   90.00, 0.00, 270.28);
	CreateDynamicObject(18809, 1967.75, -2619.17, 71.06,   90.00, 0.00, 270.28);
	CreateDynamicObject(18809, 1918.26, -2619.41, 71.06,   90.00, 0.00, 270.28);
	CreateDynamicObject(18809, 1868.38, -2619.72, 71.06,   90.00, 0.00, 270.28);
	CreateDynamicObject(18809, 1818.37, -2620.01, 71.06,   90.00, 0.00, 270.28);
	CreateDynamicObject(18809, 1768.23, -2619.98, 71.06,   90.00, 0.00, 270.28);
	CreateDynamicObject(18809, 1718.88, -2620.23, 71.06,   90.00, 0.00, 270.28);
	CreateDynamicObject(18809, 1669.57, -2620.51, 71.06,   90.00, 0.00, 270.28);
	CreateDynamicObject(18809, 1365.33, -3139.21, 71.06,   90.00, 0.00, 270.28);
	CreateDynamicObject(18830, 1583.52, -2621.40, 75.86,   180.00, 47.00, 179.06);
	CreateDynamicObject(18801, 1889.01, -2719.67, 57.46,   0.00, 0.00, 188.57);
	CreateDynamicObject(18801, 1893.39, -2738.91, 57.46,   0.00, 0.00, 188.57);
	CreateDynamicObject(18801, 1897.06, -2758.16, 57.46,   0.00, 0.00, 188.57);
	CreateDynamicObject(18804, 1971.12, -2765.90, 34.44,   0.00, 0.00, 1.50);
	CreateDynamicObject(19129, 2055.12, -2764.03, 34.62,   0.00, 0.00, 0.93);
	CreateDynamicObject(19129, 2074.79, -2763.66, 34.62,   0.00, 0.00, 0.93);
	CreateDynamicObject(19129, 2054.73, -2744.22, 34.62,   0.00, 0.00, 0.93);
	CreateDynamicObject(19129, 2074.52, -2743.68, 34.62,   0.00, 0.00, 0.93);
	CreateDynamicObject(19129, 2063.50, -2724.45, 34.62,   0.00, 0.00, 0.93);
	CreateDynamicObject(19129, 2063.09, -2704.70, 34.62,   0.00, 0.00, 0.93);
	CreateDynamicObject(19129, 2062.78, -2687.91, 34.62,   0.00, 0.00, 0.93);
	CreateDynamicObject(18830, 1837.76, -2521.44, 110.22,   180.00, 47.00, 177.67);
	CreateDynamicObject(18809, 1943.33, -2578.04, 208.24,   90.00, 0.00, 270.28);
	CreateDynamicObject(18830, 1865.04, -2768.05, 215.15,   180.00, 47.00, 182.69);
	CreateDynamicObject(18809, 1942.33, -2599.03, 208.24,   90.00, 0.00, 270.28);
	CreateDynamicObject(19129, 1916.84, -2592.35, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 1897.00, -2592.26, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 1876.88, -2593.00, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 1856.92, -2588.57, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 1837.31, -2588.60, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 1817.41, -2588.55, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(18809, 1922.21, -2620.56, 208.24,   90.00, 0.00, 180.30);
	CreateDynamicObject(18809, 1844.50, -2600.35, 208.24,   90.00, 0.00, 270.28);
	CreateDynamicObject(18809, 1894.08, -2578.29, 208.24,   90.00, 0.00, 270.28);
	CreateDynamicObject(18809, 1844.36, -2578.57, 208.24,   90.00, 0.00, 270.28);
	CreateDynamicObject(18809, 2012.52, -2661.26, 208.24,   90.00, 0.00, 270.28);
	CreateDynamicObject(18809, 1982.60, -2640.32, 208.24,   90.00, 0.00, 270.28);
	CreateDynamicObject(18809, 2026.49, -2639.88, 208.24,   90.00, 0.00, 270.28);
	CreateDynamicObject(18809, 1980.85, -2661.54, 208.24,   90.00, 0.00, 270.28);
	CreateDynamicObject(18809, 2053.25, -2664.01, 208.24,   90.00, 0.00, 180.18);
	CreateDynamicObject(18809, 2053.38, -2713.48, 208.24,   90.00, 0.00, 180.18);
	CreateDynamicObject(18809, 2032.91, -2680.83, 208.24,   90.00, 0.00, 180.18);
	CreateDynamicObject(18809, 2033.18, -2727.11, 208.24,   90.00, 0.00, 180.18);
	CreateDynamicObject(19129, 1943.91, -2650.31, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 1924.16, -2650.43, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(18809, 1943.56, -2640.29, 208.24,   90.00, 0.00, 270.28);
	CreateDynamicObject(18809, 1931.03, -2661.59, 208.24,   90.00, 0.00, 270.28);
	CreateDynamicObject(18809, 1881.79, -2662.10, 208.24,   90.00, 0.00, 270.28);
	CreateDynamicObject(18809, 1864.84, -2619.75, 208.24,   90.00, 0.00, 180.30);
	CreateDynamicObject(19129, 1904.14, -2650.34, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 1884.71, -2650.36, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 1864.91, -2650.02, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 1908.06, -2630.44, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 1888.12, -2631.09, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 1868.76, -2631.34, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 1870.95, -2611.42, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 1890.82, -2611.27, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 1910.86, -2611.46, 205.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(18809, 1893.67, -2620.58, 208.24,   90.00, 0.00, 180.30);
	CreateDynamicObject(18830, 1813.27, -2589.66, 215.11,   180.00, 47.00, 180.68);
	CreateDynamicObject(18842, 2064.26, -2482.60, 77.86,   90.00, 0.00, 23.43);
	CreateDynamicObject(18842, 2042.52, -2483.72, 77.86,   90.00, 0.00, 23.43);
	CreateDynamicObject(18842, 2060.01, -2481.43, 73.74,   90.00, 0.00, 23.43);
	CreateDynamicObject(18842, 2050.71, -2485.56, 73.12,   90.00, 0.00, 23.43);
	CreateDynamicObject(18842, 2023.22, -2439.44, 77.86,   90.00, 0.00, 23.43);
	CreateDynamicObject(18842, 2044.87, -2437.88, 77.86,   90.00, 0.00, 23.43);
	CreateDynamicObject(18842, 2025.24, -2392.68, 77.86,   90.00, 0.00, 23.43);
	CreateDynamicObject(18842, 2003.64, -2394.24, 77.86,   90.00, 0.00, 23.43);
	CreateDynamicObject(18842, 2040.58, -2436.49, 73.74,   90.00, 0.00, 23.43);
	CreateDynamicObject(18842, 2031.44, -2440.92, 73.12,   90.00, 0.00, 23.43);
	CreateDynamicObject(18842, 2011.58, -2395.20, 73.12,   90.00, 0.00, 23.43);
	CreateDynamicObject(18842, 2021.14, -2391.48, 73.74,   90.00, 0.00, 23.43);
	CreateDynamicObject(18781, 2009.15, -2379.38, 85.44,   0.00, 0.00, 28.12);
	CreateDynamicObject(18846, 2007.64, -2476.43, 17.38,   0.00, 0.00, 270.60);
	CreateDynamicObject(19159, 1960.45, -2266.31, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1935.91, -2284.02, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1961.40, -2282.51, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1982.94, -2310.94, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1961.97, -2313.30, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1955.05, -2346.47, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1906.88, -2284.73, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1900.76, -2323.51, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1890.02, -2351.74, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1982.61, -2335.97, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1982.99, -2375.49, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1935.07, -2349.89, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1960.21, -2374.81, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1946.20, -2308.99, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1873.84, -2380.77, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1832.50, -2395.28, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1793.92, -2417.05, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1890.91, -2418.87, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1892.64, -2438.88, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1946.06, -2473.15, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1899.20, -2473.21, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1921.65, -2494.02, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1950.80, -2493.79, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1982.55, -2493.86, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1887.04, -2493.76, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1838.70, -2493.94, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1795.26, -2493.92, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1817.62, -2478.59, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1816.41, -2509.36, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(19159, 1790.08, -2430.97, 12.67,   180.00, 0.00, 358.00);
	CreateDynamicObject(18779, 1556.03, -2658.54, 16.30,   0.00, 0.00, 177.04);
	CreateDynamicObject(18779, 1306.14, -2460.30, 16.69,   0.00, 0.00, 177.99);
	CreateDynamicObject(18783, 1545.78, -2493.86, 14.82,   0.00, 0.00, 0.00);
	CreateDynamicObject(18783, 1565.70, -2493.88, 14.82,   0.00, 0.00, 0.00);
	CreateDynamicObject(18786, 1585.39, -2493.80, 14.77,   0.00, 0.00, 0.00);
	CreateDynamicObject(18809, 1615.43, -2488.54, 16.64,   90.00, 0.00, 270.28);
	CreateDynamicObject(18809, 1620.39, -2620.68, 71.06,   90.00, 0.00, 270.28);
	CreateDynamicObject(18809, 1615.59, -2499.36, 16.64,   90.00, 0.00, 270.28);
	CreateDynamicObject(18809, 1479.37, -2501.05, 16.14,   90.00, 0.00, 270.28);
	CreateDynamicObject(18786, 1566.07, -2474.00, 14.76,   0.00, 0.00, 89.30);
	CreateDynamicObject(18786, 1549.22, -2513.45, 14.77,   0.00, 0.00, 269.83);
	CreateDynamicObject(18786, 1546.25, -2474.29, 19.70,   0.00, 0.00, 269.83);
	CreateDynamicObject(18786, 1546.30, -2455.17, 24.51,   0.00, 0.00, 269.69);
	CreateDynamicObject(18783, 1569.08, -2513.82, 14.82,   0.00, 0.00, 0.00);
	CreateDynamicObject(18783, 1569.00, -2533.84, 14.82,   0.00, 0.00, 0.00);
	CreateDynamicObject(18783, 1588.71, -2515.38, 14.82,   0.00, 0.00, 0.00);
	CreateDynamicObject(18783, 1546.42, -2435.65, 24.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(18786, 1546.51, -2416.91, 29.40,   0.00, 0.00, 269.69);
	CreateDynamicObject(18786, 1526.89, -2435.99, 29.30,   0.00, 0.00, 0.32);
	CreateDynamicObject(18786, 1566.25, -2435.74, 24.39,   0.00, 0.00, 0.32);
	CreateDynamicObject(18786, 1585.77, -2435.40, 24.31,   0.00, 0.00, 181.04);
	CreateDynamicObject(18786, 1568.98, -2553.68, 14.77,   0.00, 0.00, 269.83);
	CreateDynamicObject(18786, 1588.78, -2535.39, 14.77,   0.00, 0.00, 269.83);
	CreateDynamicObject(18786, 1607.90, -2515.66, 14.77,   0.00, 0.00, 0.00);
	CreateDynamicObject(18830, 1544.30, -2532.12, 21.85,   180.00, 47.00, 1.13);
	CreateDynamicObject(18830, 1522.50, -2501.11, 21.85,   180.00, 47.00, 1.13);
	CreateDynamicObject(18830, 1515.91, -2457.24, 21.19,   180.00, 47.00, 358.79);
	CreateDynamicObject(4866, 1517.16, -2449.65, 12.55,   0.00, 0.00, 0.00);
	CreateDynamicObject(18830, 1720.92, -2601.99, 21.85,   180.00, 47.00, 1.13);
	CreateDynamicObject(18830, 1720.60, -2590.16, 21.85,   180.00, 47.00, 1.13);
	CreateDynamicObject(19129, 1740.11, -2595.80, 35.16,   0.00, 0.00, 1.57);
	CreateDynamicObject(19129, 1760.02, -2595.21, 35.16,   0.00, 0.00, 1.57);
	CreateDynamicObject(19129, 1779.70, -2594.69, 35.16,   0.00, 0.00, 1.57);
	CreateDynamicObject(19129, 1799.53, -2594.17, 35.16,   0.00, 0.00, 1.57);
	CreateDynamicObject(18830, 1819.50, -2589.10, 44.94,   180.00, 47.00, 1.13);
	CreateDynamicObject(18830, 1819.61, -2600.62, 44.94,   180.00, 47.00, 1.13);
	CreateDynamicObject(19129, 1839.24, -2594.63, 57.72,   0.00, 0.00, 0.85);
	CreateDynamicObject(19129, 1859.02, -2594.32, 57.72,   0.00, 0.00, 0.85);
	CreateDynamicObject(19129, 1878.94, -2594.03, 57.72,   0.00, 0.00, 0.85);
	CreateDynamicObject(19129, 1898.74, -2593.75, 57.72,   0.00, 0.00, 0.85);
	CreateDynamicObject(18830, 1916.94, -2599.19, 55.67,   180.00, 149.00, 1.00);
	CreateDynamicObject(18830, 1916.45, -2587.28, 55.76,   180.00, 149.00, 1.00);
	CreateDynamicObject(18830, 1934.47, -2587.15, 34.15,   180.00, -33.00, 1.00);
	CreateDynamicObject(18830, 1934.76, -2598.87, 34.15,   180.00, -33.00, 1.00);
	CreateDynamicObject(18830, 1964.86, -2598.67, 30.03,   180.00, 18.00, 359.78);
	CreateDynamicObject(18830, 1965.07, -2586.91, 30.03,   180.00, 18.00, 359.78);
	CreateDynamicObject(19129, 1726.99, -2595.75, 14.40,   91.00, 0.00, 92.34);
	CreateDynamicObject(18779, 1751.08, -2586.20, 22.39,   0.00, 0.00, 343.27);
	CreateDynamicObject(18779, 1553.67, -2624.00, 22.20,   0.00, 0.00, 359.92);
	CreateDynamicObject(18830, 1820.30, -2503.38, 21.85,   180.00, 47.00, 1.13);
	CreateDynamicObject(18809, 2030.15, -2467.18, 210.63,   90.00, 0.00, 267.46);
	CreateDynamicObject(18845, -4623.24, 121.99, -7873.37,   0.00, 0.00, 0.00);
	CreateDynamicObject(18845, 1849.16, -2651.48, 266.27,   0.00, 0.00, 2.78);
	CreateDynamicObject(18830, 1858.17, -2651.00, 215.11,   180.00, 47.00, 180.68);
	CreateDynamicObject(18844, 1481.53, -2779.09, 156.49,   0.00, 0.00, 178.00);
	CreateDynamicObject(18844, 1481.53, -2779.09, 100.91,   0.00, 0.00, 178.00);
	CreateDynamicObject(18778, 1812.76, -2439.12, 15.44,   0.00, 0.00, 276.75);
	CreateDynamicObject(18778, 1804.70, -2440.14, 12.29,   0.00, 0.00, 276.75);
	CreateDynamicObject(18841, 1995.26, -2451.34, 204.39,   67.00, 0.00, 358.88);
	CreateDynamicObject(18841, 2015.61, -2452.15, 191.99,   67.00, 0.00, 176.77);
	CreateDynamicObject(18841, 1995.26, -2451.34, 179.61,   67.00, 0.00, 358.88);
	CreateDynamicObject(18841, 2015.61, -2452.15, 167.05,   67.00, 0.00, 176.77);
	CreateDynamicObject(18841, 1995.26, -2451.34, 154.64,   67.00, 0.00, 358.88);
	CreateDynamicObject(18841, 2015.61, -2452.15, 142.24,   67.00, 0.00, 176.77);
	CreateDynamicObject(18841, 1995.26, -2451.34, 129.90,   67.00, 0.00, 358.88);
	CreateDynamicObject(18841, 2015.61, -2452.15, 117.51,   67.00, 0.00, 176.77);
	CreateDynamicObject(18841, 1995.26, -2451.34, 105.12,   67.00, 0.00, 358.88);
	CreateDynamicObject(18841, 2015.03, -2452.13, 92.69,   67.00, 0.00, 176.77);
	CreateDynamicObject(18841, 1996.72, -2451.49, 80.42,   67.00, 0.00, 358.88);
	CreateDynamicObject(18841, 2017.76, -2451.41, 67.97,   67.00, 0.00, 181.83);
	CreateDynamicObject(18841, 1997.13, -2451.87, 55.49,   67.00, 0.00, 0.71);
	CreateDynamicObject(18841, 2017.76, -2451.41, 43.08,   67.00, 0.00, 181.83);
	CreateDynamicObject(18841, 1997.70, -2451.81, 30.62,   67.00, 0.00, 0.71);
	CreateDynamicObject(18841, 2017.93, -2452.08, 19.48,   72.00, 0.00, 180.47);
	CreateDynamicObject(18846, 2005.25, -2457.90, 17.38,   0.00, 0.00, 270.60);
	CreateDynamicObject(19130, 2008.04, -2467.32, 16.75,   0.00, 0.00, 359.70);
	CreateDynamicObject(18649, 1636.59, -2487.79, 13.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(18649, 1617.96, -2487.35, 13.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(18649, 1619.10, -2499.17, 13.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(18649, 1638.46, -2498.61, 13.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(18649, 1634.83, -2493.28, 13.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(18649, 1615.00, -2493.68, 13.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3054, 1402.98, -2507.66, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(3054, 1393.59, -2476.82, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(18779, 2038.31, -2487.36, 10.86,   0.00, 0.00, 337.04);
	CreateDynamicObject(3054, 1746.66, -2444.23, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(3054, 1920.58, -2446.82, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(3046, 1787.06, -2437.56, 13.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3046, 1784.04, -2434.93, 13.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3046, 1787.43, -2435.81, 13.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 1795.28, 7387.86, -5957.29,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 1937.43, -1751.10, 214.37,   0.00, 0.00, 0.95);
	CreateDynamicObject(19129, 1956.68, -1750.85, 214.37,   0.00, 0.00, 0.95);
	CreateDynamicObject(19129, 1918.73, -1751.46, 214.37,   0.00, 0.00, 0.95);
	CreateDynamicObject(19129, 1927.81, -1731.38, 214.37,   0.00, 0.00, 0.95);
	CreateDynamicObject(19129, 1947.75, -1731.49, 214.37,   0.00, 0.00, 0.95);
	CreateDynamicObject(19137, 1925.71, -2451.73, 13.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 2032.35, -2640.21, 12.68,   0.00, 0.00, 0.93);
	CreateDynamicObject(18842, 2017.58, -2654.00, 10.65,   90.00, 0.00, 90.13);
	CreateDynamicObject(19129, 2012.45, -2640.59, 12.68,   0.00, 0.00, 0.93);
	CreateDynamicObject(19129, 1992.84, -2640.96, 12.68,   0.00, 0.00, 0.93);
	CreateDynamicObject(19129, 1972.91, -2641.24, 12.68,   0.00, 0.00, 0.93);
	CreateDynamicObject(18842, 1968.33, -2654.09, 10.65,   90.00, 0.00, 90.13);
	CreateDynamicObject(19129, 1953.00, -2641.55, 12.68,   0.00, 0.00, 0.93);
	CreateDynamicObject(18750, 1269.23, -2576.32, 66.61,   91.00, 0.00, 110.13);

	//VEICULOS
	AddStaticVehicle(407, 1963.5295, -2638.0613, 13.8412, 0.0000, 1, 1);
	AddStaticVehicle(411, 1959.3696, -2638.3008, 13.5040, 0.0000, 1, 1);
	AddStaticVehicle(411, 1955.9056, -2638.1345, 13.5040, 0.0000, 1, 1);
	AddStaticVehicle(411, 1952.6620, -2638.1929, 13.5040, 0.0000, 1, 1);
	AddStaticVehicle(424, 1948.7966, -2637.9092, 13.4183, 0.0000, 1, 1);
	AddStaticVehicle(424, 1945.4180, -2637.9673, 13.4183, 0.0000, 1, 1);
	AddStaticVehicle(434, 1967.4640, -2638.0278, 13.8060, 0.0000, 1, 1);
	AddStaticVehicle(434, 1970.4543, -2637.9512, 13.8060, 0.0000, 1, 1);
	AddStaticVehicle(444, 1974.2195, -2638.3315, 13.8172, 0.0000, 1, 1);
	AddStaticVehicle(444, 1979.2319, -2638.2756, 13.8192, 0.0000, 1, 1);
	AddStaticVehicle(451, 1984.0171, -2638.5103, 13.4049, 0.0000, 1, 1);
	AddStaticVehicle(451, 1987.1814, -2638.4453, 13.4049, 0.0000, 1, 1);
	AddStaticVehicle(522, 1991.3119, -2637.7825, 13.3061, 31.5121, 1, 1);
	AddStaticVehicle(522, 1993.1531, -2637.3821, 13.3061, 31.5121, 1, 1);
	AddStaticVehicle(522, 1995.0907, -2636.9983, 13.3061, 31.5121, 1, 1);
	AddStaticVehicle(522, 1996.3804, -2641.0259, 13.3061, 31.5121, 1, 1);
	AddStaticVehicle(522, 1994.3866, -2642.0442, 13.3061, 31.5121, 1, 1);
	AddStaticVehicle(522, 1994.3866, -2642.0442, 13.3061, 31.5121, 1, 1);
	AddStaticVehicle(531, 2001.4351, -2638.1545, 13.8193, 0.0000, 1, 1);
	AddStaticVehicle(583, 2004.7701, -2636.7256, 13.2021, 0.0000, 1, 1);
	AddStaticVehicle(583, 2007.5615, -2636.6787, 13.2021, 0.0000, 1, 1);
	AddStaticVehicle(604, 2011.3866, -2636.5420, 13.7091, 0.0000, 1, 1);
	AddStaticVehicle(604, 2014.9478, -2636.6099, 13.7091, 0.0000, 1, 1);
	AddStaticVehicle(588, 2020.6582, -2637.3503, 13.7377, 0.0000, 1, 1);
	AddStaticVehicle(594, 2017.6993, -2631.5642, 13.0000, 0.0000, 1, 1);
	AddStaticVehicle(594, 2012.9685, -2630.6045, 13.0000, 0.0000, 1, 1);
	AddStaticVehicle(594, 2009.2153, -2630.9109, 13.0000, 0.0000, 1, 1);
	AddStaticVehicle(594, 2005.8628, -2630.7849, 13.0000, 0.0000, 1, 1);
	AddStaticVehicle(594, 2002.9049, -2630.8979, 13.0000, 0.0000, 1, 1);
	AddStaticVehicle(584, 2046.3097, -2642.5679, 15.0000, 0.0000, 1, 1);
	AddStaticVehicle(584, 2052.3472, -2643.0154, 15.0000, 0.0000, 1, 1);
	AddStaticVehicle(515, 2052.4187, -2629.8345, 15.0000, 0.0000, 1, 1);
	AddStaticVehicle(515, 2046.4120, -2629.5938, 15.0000, 0.0000, 1, 1);
	AddStaticVehicle(606, 2025.2012, -2644.7998, 13.8192, 0.0000, 1, 1);
	AddStaticVehicle(606, 2025.1842, -2640.7134, 13.8192, 0.0000, 1, 1);
	AddStaticVehicle(606, 2025.1633, -2636.6204, 13.8192, 0.0000, 1, 1);
	AddStaticVehicle(606, 2025.1404, -2632.5334, 13.8192, 0.0000, 1, 1);
	AddStaticVehicle(607, 2028.9485, -2645.5205, 13.8162, 0.0000, 1, 1);
	AddStaticVehicle(607, 2028.9230, -2641.4080, 13.8162, 0.0000, 1, 1);
	AddStaticVehicle(607, 2028.9222, -2637.3259, 13.8162, 0.0000, 1, 1);
	AddStaticVehicle(607, 2028.9032, -2633.2192, 13.8162, 0.0000, 1, 1);
	AddStaticVehicle(607, 2031.2473, -2633.1689, 13.8162, 0.0000, 1, 1);
	AddStaticVehicle(607, 2031.2719, -2637.2063, 13.8162, 0.0000, 1, 1);
	AddStaticVehicle(607, 2031.2642, -2641.2788, 13.8162, 0.0000, 1, 1);
	AddStaticVehicle(607, 2031.3059, -2645.4182, 13.8162, 0.0000, 1, 1);
	AddStaticVehicle(579, 2034.6704, -2635.7642, 13.9233, 0.0000, 1, 1);
	AddStaticVehicle(578, 2039.1312, -2637.0068, 14.3090, 0.0000, 1, 1);
	CreateDynamicObject(16133,-2367.73339800,-1603.61438000,475.60055500,0.00000000,-24.92366409,-199.92216345); //delux object
	CreateDynamicObject(16133,-2372.99511700,-1609.01977500,478.69290200,0.00000000,-7.73493023,-187.03061306); //delux object(1)
	CreateDynamicObject(4867,-2401.98779300,-1539.04418900,477.35107400,0.00000000,0.00000000,-83.82945501); //delux object(2)
	CreateDynamicObject(16141,-2445.33691400,-1581.44152800,467.57003800,0.00000000,0.00000000,-67.50015784); //delux object(3)
	CreateDynamicObject(5005,-2318.81909200,-1456.99646000,480.55267300,0.00000000,0.00000000,-83.90393952); //delux object(4)
	CreateDynamicObject(4867,-2406.93457000,-1493.29480000,477.34802200,0.00000000,0.00000000,-83.82945501); //delux object(5)
	CreateDynamicObject(5005,-2405.90820300,-1386.41870100,480.57461500,0.00000000,0.00000000,-173.90414998); //delux object(6)
	CreateDynamicObject(5005,-2426.62207000,-1388.61120600,480.57897900,0.00000000,0.00000000,-173.90414998); //delux object(7)
	CreateDynamicObject(5005,-2500.00732400,-1479.63781700,480.60266100,0.00000000,0.00000000,-263.90436044); //delux object(8)
	CreateDynamicObject(5005,-2489.83740200,-1575.88964800,480.60266100,0.00000000,0.00000000,-263.90436044); //delux object(9)
	CreateDynamicObject(1655,-2359.70776400,-1412.58789100,478.39819300,0.00000000,0.00000000,-354.84422168); //delux object(10)
	CreateDynamicObject(1655,-2360.35620100,-1405.52551300,482.63403300,-343.67154468,0.00000000,-354.84422168); //delux object(11)
	CreateDynamicObject(1655,-2360.83691400,-1400.02832000,488.72464000,-326.48281082,0.00000000,-354.84422168); //delux object(12)
	CreateDynamicObject(1655,-2361.08642600,-1396.88122600,496.23053000,-305.85633020,0.00000000,-354.84422168); //delux object(13)
	CreateDynamicObject(1655,-2361.12793000,-1396.47692900,504.54086300,-286.08928626,0.00000000,-354.84422168); //delux object(14)
	CreateDynamicObject(13592,-2402.92895500,-1408.99108900,487.74356100,0.00000000,-14.61042378,-258.74774028); //delux object(15)
	CreateDynamicObject(13592,-2411.46704100,-1405.44213900,488.45111100,0.00000000,-14.61042378,-258.74774028); //delux object(16)
	CreateDynamicObject(13592,-2420.02490200,-1401.76220700,489.42272900,0.00000000,-14.61042378,-258.74774028); //delux object(17)
	CreateDynamicObject(1632,-2424.10009800,-1402.57128900,480.35263100,-20.62648062,0.00000000,-353.98478499); //delux object(18)
	CreateDynamicObject(1632,-2424.63354500,-1397.52795400,481.54306000,-1.71887339,0.00000000,-353.98478499); //delux object(19)
	CreateDynamicObject(1632,-2425.09985400,-1393.02221700,484.44729600,-341.09323460,0.00000000,-353.98478499); //delux object(20)
	CreateDynamicObject(13831,-2433.23193400,-1586.09094200,499.38769500,0.00000000,0.00000000,-148.82578729); //delux object(21)
	CreateDynamicObject(13722,-2433.10913100,-1585.54235800,499.36746200,0.00000000,0.00000000,-148.82578729); //delux object(22)
	CreateDynamicObject(1655,-2459.95654300,-1442.69921900,478.37625100,0.00000000,0.00000000,-294.68365319); //delux object(23)
	CreateDynamicObject(1655,-2464.28247100,-1440.72216800,481.33200100,-340.23379790,0.00000000,-294.68365319); //delux object(24)
	CreateDynamicObject(1655,-2468.94677700,-1531.21789600,478.37625100,0.00000000,0.00000000,-215.93060425); //delux object(25)
	CreateDynamicObject(1655,-2472.12548800,-1535.63024900,481.63229400,-342.81210798,0.00000000,-215.93060425); //delux object(26)
	CreateDynamicObject(16133,-2482.74487300,-1487.61462400,477.35290500,0.00000000,-12.89155039,-199.92216345); //delux object(27)
	CreateDynamicObject(16133,-2324.28710900,-1489.34082000,475.90289300,0.00000000,-12.89155039,-347.74527460); //delux object(28)
	CreateDynamicObject(16133,-2386.09375000,-1573.15295400,482.04553200,0.00000000,-32.65859432,-91.73627258); //delux object(29)
	CreateDynamicObject(16133,-2452.60400400,-1400.91101100,477.39984100,0.00000000,-24.92366409,-247.29431396); //delux object(30)
	CreateDynamicObject(16037,-2233.22583000,-1588.54809600,482.91549700,0.00000000,-354.84422168,-338.36022591); //delux object(31)
	CreateDynamicObject(16037,-2123.11328100,-1544.88195800,461.06970200,0.00000000,-344.53098137,-338.36022591); //delux object(32)
	CreateDynamicObject(16037,-2016.90673800,-1502.71472200,429.39611800,0.00000000,-344.53098137,-338.36022591); //delux object(33)
	CreateDynamicObject(3502,-2282.90112300,-1660.62341300,483.17660500,0.00000000,0.00000000,-96.87570400); //delux object(34)
	CreateDynamicObject(3502,-2273.98999000,-1661.89086900,483.21597300,0.00000000,0.00000000,-96.87570400); //delux object(35)
	CreateDynamicObject(3502,-2265.24853500,-1663.13354500,482.86764500,-5.15662016,-18.04817055,-99.45401408); //delux object(36)
	CreateDynamicObject(3502,-2259.70117200,-1664.18518100,481.81460600,-13.75098708,-2.57831008,-100.31345077); //delux object(37)
	CreateDynamicObject(3502,-2251.64599600,-1665.36035200,479.92565900,-11.17267701,0.00000000,-97.73514069); //delux object(38)
	CreateDynamicObject(3502,-2244.31225600,-1666.31152300,480.13970900,-347.96872814,-2.57831008,-96.01626731); //delux object(39)
	CreateDynamicObject(3502,-2225.49633800,-1668.42797900,484.03262300,-353.12534830,0.00000000,-96.87570400); //delux object(40)
	CreateDynamicObject(3502,-2217.83178700,-1669.22338900,484.96652200,-353.12534830,0.00000000,-96.87570400); //delux object(41)
	CreateDynamicObject(3502,-2210.45996100,-1670.09362800,485.82321200,-353.12534830,0.00000000,-96.87570400); //delux object(42)
	CreateDynamicObject(3502,-2203.32812500,-1671.06359900,486.72229000,-353.12534830,0.00000000,-96.87570400); //delux object(43)
	CreateDynamicObject(3502,-2197.36059600,-1671.77441400,487.54376200,-353.12534830,0.00000000,-96.87570400); //delux object(44)
	CreateDynamicObject(3554,-2283.53295900,-1660.56872600,491.42706300,0.00000000,0.00000000,-277.25427706); //delux object(45)
	CreateDynamicObject(726,-2317.47558600,-1523.26355000,476.74862700,0.00000000,0.00000000,0.00000000); //delux object(46)
	CreateDynamicObject(726,-2262.24633800,-1687.04333500,478.71728500,0.00000000,0.00000000,0.00000000); //delux object(47)
	CreateDynamicObject(13831,-2371.49951200,-1609.12622100,510.35189800,0.00000000,-359.14140514,-281.17330838); //delux object(48)
	CreateDynamicObject(16133,-2271.32910200,-1725.69751000,467.92666600,0.00000000,-12.89155039,-154.99654274); //delux object(49)
	CreateDynamicObject(726,-2244.67773400,-1751.02038600,479.25305200,0.00000000,0.00000000,0.00000000); //delux object(50)
	CreateDynamicObject(726,-2332.69995100,-1395.80004900,476.59555100,0.00000000,0.00000000,0.00000000); //delux object(51)
	CreateDynamicObject(726,-2456.03759800,-1415.98779300,478.83923300,0.00000000,0.00000000,0.00000000); //delux object(52)
	CreateDynamicObject(726,-2475.01928700,-1500.01538100,483.23504600,0.00000000,0.00000000,0.00000000); //delux object(53)
	CreateDynamicObject(726,-2401.30053700,-1556.42248500,476.97836300,0.00000000,0.00000000,0.00000000); //delux object(54)
	CreateDynamicObject(726,-2474.94604500,-1602.27978500,476.54879800,0.00000000,0.00000000,-11.17267701); //delux object(55)
	CreateDynamicObject(13641,-2296.28613300,-1598.39794900,481.65768400,-0.85943669,-342.81210798,-330.47059708); //delux object(56)
	CreateDynamicObject(1655,-2237.60717800,-1732.99121100,480.59750400,-358.28196845,-359.14140514,-149.76543807); //delux object(57)
	CreateDynamicObject(4853,-2273.50268600,-1563.09521500,479.01318400,0.00000000,-1.71887339,-315.00073661); //delux object(58)
	CreateDynamicObject(733,-2328.62890600,-1685.13793900,481.26333600,0.00000000,0.00000000,0.00000000); //delux object(59)
	CreateDynamicObject(735,-2359.96215800,-1646.89648400,480.82318100,0.00000000,0.00000000,0.00000000); //delux object(60)
	CreateDynamicObject(16127,-2346.48437500,-1683.91796900,486.53527800,-13.75098708,-359.14140514,-67.50015784); //delux object(61)
	CreateDynamicObject(16127,-2316.88525400,-1707.42895500,485.29409800,-10.31324031,0.00000000,-38.27931029); //delux object(62)
	CreateDynamicObject(1655,-2287.53686500,-1640.01342800,483.29040500,-0.85943669,-359.14140514,-88.12663847); //delux object(63)
	CreateDynamicObject(1655,-2287.70434600,-1631.85266100,483.34332300,-0.85943669,0.00000000,-89.84551185); //delux object(64)
	CreateDynamicObject(9685,-2282.94506800,-1531.11254900,536.95642100,0.00000000,0.00000000,-39.76327098); //delux object(65)
	CreateDynamicObject(9685,-2196.87622100,-1427.74841300,545.70929000,0.00000000,0.00000000,-39.76327098); //delux object(66)
	CreateDynamicObject(9685,-2110.68212900,-1324.25854500,554.47406000,0.00000000,0.00000000,-39.76327098); //delux object(67)
	CreateDynamicObject(1655,-1897.73938000,-1056.23449700,523.44641100,0.00000000,0.00000000,-38.90383429); //delux object(68)
	CreateDynamicObject(7916,-2362.49560500,-1613.52172900,497.17547600,-331.63943098,0.00000000,-282.96666628); //delux object(69)
	CreateDynamicObject(7916,-2355.78027300,-1657.32080100,495.55090300,-330.77999428,-0.85943669,-250.93832553); //delux object(70)
	CreateDynamicObject(16127,-2363.80419900,-1645.95227100,482.38360600,-13.75098708,-359.14140514,-67.50015784); //delux object(71)
	CreateDynamicObject(16133,-2384.80053700,-1575.73510700,485.20529200,-9.45380362,-27.50197417,-105.48725966); //delux object(72)
	CreateDynamicObject(11435,-2310.02441400,-1584.27673300,485.40649400,0.00000000,0.00000000,0.00000000); //delux object(73)
	CreateDynamicObject(7392,-2287.59643600,-1672.06616200,491.21005200,0.00000000,0.00000000,-6.87549354); //delux object(74)
	CreateDynamicObject(8483,-2354.76001000,-1579.37890600,490.02667200,-1.71887339,-2.57831008,-28.36141086); //delux object(75)
	CreateDynamicObject(13562,-2288.04223600,-1654.21960400,483.42868000,0.00000000,0.00000000,0.00000000); //delux object(76)
	CreateDynamicObject(16776,-2309.83178700,-1695.02258300,481.26385500,0.00000000,0.00000000,-224.20984439); //delux object(77)
	CreateDynamicObject(1655,-2293.26391600,-1607.78308100,483.33184800,-1.71887339,-0.85943669,-69.21903123); //delux object(78)
	CreateDynamicObject(1655,-2290.20874000,-1615.83081100,483.37838700,-1.71887339,0.00000000,-69.21903123); //delux object(79)
	CreateDynamicObject(1655,-1746.05761700,-1395.10510300,356.68914800,-15.46986047,0.00000000,-67.50015784); //delux object(80)
	CreateDynamicObject(1655,-1738.83349600,-1392.10241700,358.86459400,-359.14140514,0.00000000,-67.50015784); //delux object(81)
	CreateDynamicObject(1655,-1732.12805200,-1389.34411600,363.11526500,-345.39041806,0.00000000,-67.50015784); //delux object(82)
	CreateDynamicObject(1655,-2344.17773400,-1555.53625500,479.02584800,-351.40647491,0.00000000,-170.54661730); //delux object(83)
	CreateDynamicObject(1655,-2340.23632800,-1571.68981900,483.50128200,-347.10929145,0.00000000,-347.10929145); //delux object(84)
	CreateDynamicObject(10838,-2321.31933600,-1576.83862300,497.20776400,-0.85943669,-1.71887339,-311.87238705); //delux object(85)
	CreateDynamicObject(3502,-2236.01660200,-1667.08581500,481.97851600,-347.96872814,-2.57831008,-96.01626731); //delux object(86)
	CreateDynamicObject(3502,-2231.74292000,-1667.53930700,483.07952900,-347.96872814,-2.57831008,-96.01626731); //delux object(87)
	CreateDynamicObject(3502,-2189.54809600,-1672.90918000,488.47512800,-353.12534830,0.00000000,-100.31345077); //delux object(88)
	CreateDynamicObject(3502,-2182.24780300,-1674.79174800,489.42492700,-353.12534830,0.00000000,-110.62669108); //delux object(89)
	CreateDynamicObject(3502,-2175.39697300,-1678.20214800,490.33047500,-353.12534830,0.00000000,-124.37767817); //delux object(90)
	CreateDynamicObject(3502,-2169.11547900,-1682.43920900,490.70208700,-0.85943669,-358.28196845,-124.37767817); //delux object(91)
	CreateDynamicObject(3502,-2162.80957000,-1687.26135300,490.58270300,-0.85943669,-358.28196845,-132.97204509); //delux object(92)
	CreateDynamicObject(3502,-2157.65771500,-1693.17504900,490.43576000,-0.85943669,-358.28196845,-147.58246887); //delux object(93)
	CreateDynamicObject(3502,-2153.70507800,-1699.34362800,490.11257900,-5.15662016,0.00000000,-147.58246887); //delux object(94)
	CreateDynamicObject(3502,-2150.36181600,-1705.59436000,489.45642100,-5.15662016,0.00000000,-159.61458257); //delux object(95)
	CreateDynamicObject(3502,-2148.39233400,-1712.52026400,488.78668200,-5.15662016,0.00000000,-171.64669627); //delux object(96)
	CreateDynamicObject(3502,-2147.96044900,-1719.52050800,488.13839700,-5.15662016,0.00000000,-183.67880996); //delux object(97)
	CreateDynamicObject(3502,-2148.93481400,-1726.64257800,487.48654200,-5.15662016,0.00000000,-194.85148697); //delux object(98)
	CreateDynamicObject(3502,-2150.71704100,-1733.48364300,486.59045400,-10.31324031,0.00000000,-194.85148697); //delux object(99)
	CreateDynamicObject(3502,-2153.01586900,-1739.36718800,485.40170300,-10.31324031,0.00000000,-206.02416397); //delux object(100)
	CreateDynamicObject(3502,-2156.83715800,-1745.68225100,484.07098400,-10.31324031,0.00000000,-218.05627767); //delux object(101)
	CreateDynamicObject(3502,-2161.27392600,-1750.57287600,482.88763400,-10.31324031,0.00000000,-230.08839137); //delux object(102)
	CreateDynamicObject(3502,-2167.02392600,-1754.29797400,481.63760400,-10.31324031,0.00000000,-244.69881514); //delux object(103)
	CreateDynamicObject(3502,-2173.99829100,-1756.77710000,480.30600000,-10.31324031,0.00000000,-257.59036553); //delux object(104)
	CreateDynamicObject(3502,-2181.32812500,-1757.56945800,478.92004400,-10.31324031,0.00000000,-272.20078931); //delux object(105)
	CreateDynamicObject(3502,-2188.53710900,-1756.43286100,477.59371900,-10.31324031,0.00000000,-285.95177639); //delux object(106)
	CreateDynamicObject(3502,-2195.46069300,-1753.23205600,476.21871900,-10.31324031,0.00000000,-303.99994694); //delux object(107)
	CreateDynamicObject(3502,-2201.58154300,-1748.01196300,474.66912800,-10.31324031,0.00000000,-317.75093402); //delux object(108)
	CreateDynamicObject(3502,-2205.86084000,-1742.10656700,473.35968000,-10.31324031,0.00000000,-332.36135780); //delux object(109)
	CreateDynamicObject(3502,-2208.18652300,-1735.10754400,471.99813800,-10.31324031,0.00000000,-351.26896504); //delux object(110)
	CreateDynamicObject(3502,-2208.33300800,-1727.43518100,470.60827600,-10.31324031,0.00000000,-7.59742036); //delux object(111)
	CreateDynamicObject(3502,-2206.18432600,-1719.65429700,469.12423700,-10.31324031,0.00000000,-22.20784414); //delux object(112)
	CreateDynamicObject(3502,-2202.08935500,-1713.13183600,467.79620400,-10.31324031,0.00000000,-41.97488807); //delux object(113)
	CreateDynamicObject(3502,-2196.13818400,-1708.34826700,466.40631100,-10.31324031,0.00000000,-60.02305862); //delux object(114)
	CreateDynamicObject(3502,-2189.04370100,-1705.48706100,465.06039400,-10.31324031,0.00000000,-76.35235578); //delux object(115)
	CreateDynamicObject(3502,-2181.02905300,-1704.21948200,463.62796000,-10.31324031,0.00000000,-86.66559609); //delux object(116)
	CreateDynamicObject(3502,-2173.13891600,-1703.71691900,462.15863000,-10.31324031,0.00000000,-86.66559609); //delux object(117)
	CreateDynamicObject(3502,-2166.24169900,-1703.24694800,460.85147100,-10.31324031,0.00000000,-86.66559609); //delux object(118)
	CreateDynamicObject(3502,-2158.81933600,-1702.77380400,459.46057100,-10.31324031,0.00000000,-86.66559609); //delux object(119)
	CreateDynamicObject(3502,-2151.51806600,-1702.33508300,458.11300700,-10.31324031,0.00000000,-86.66559609); //delux object(120)
	CreateDynamicObject(3502,-2144.23388700,-1701.88623000,456.76208500,-10.31324031,0.00000000,-86.66559609); //delux object(121)
	CreateDynamicObject(13641,-2148.50415000,-1700.99939000,446.60180700,0.00000000,0.00000000,0.00000000); //delux object(122)
	CreateDynamicObject(13641,-2142.58593800,-1700.97485400,446.36911000,0.00000000,0.00000000,0.00000000); //delux object(123)
	CreateDynamicObject(1655,-1810.57824700,-1636.15234400,443.57193000,-8.59436693,0.00000000,-90.00021046); //delux object(124)
	CreateDynamicObject(1655,-1802.60864300,-1636.15820300,446.36175500,-357.42253176,0.00000000,-90.00021046); //delux object(125)
	CreateDynamicObject(1655,-1796.57519500,-1636.11462400,450.26486200,-342.81210798,0.00000000,-90.00021046); //delux object(126)
	CreateDynamicObject(1655,-1790.48852500,-1636.09533700,456.11071800,-334.21774106,0.00000000,-90.00021046); //delux object(127)
	CreateDynamicObject(6986,-2349.08227500,-1572.66455100,499.17211900,0.00000000,0.00000000,-56.72282172); //delux object(128)
	CreateDynamicObject(2918,-1893.17346200,-1063.10266100,524.18872100,0.00000000,0.00000000,0.00000000); //delux object(129)
	CreateDynamicObject(2918,-2403.69262700,-1416.83154300,481.09008800,0.00000000,0.00000000,0.00000000); //delux object(130)
	CreateDynamicObject(2918,-2402.50781300,-1416.59265100,481.02084400,0.00000000,0.00000000,0.00000000); //delux object(131)
	CreateDynamicObject(2918,-2404.88842800,-1416.94970700,481.04327400,0.00000000,0.00000000,0.00000000); //delux object(132)
	CreateDynamicObject(16133,-2382.16137700,-1605.63000500,488.94613600,0.00000000,-25.78310078,-223.12695416); //delux object(133)
	CreateDynamicObject(16127,-2363.82128900,-1674.43359400,499.31698600,-13.75098708,-359.14140514,-67.50015784); //delux object(134)
	CreateDynamicObject(8618,-2355.65966800,-1591.17443800,499.22119100,0.00000000,0.00000000,-335.07717775); //delux object(135)
	CreateDynamicObject(3715,-2287.51562500,-1636.57995600,491.15588400,0.00000000,0.00000000,-89.38141604); //delux object(136)
	CreateDynamicObject(1655,-2245.18212900,-1737.32568400,480.61645500,-358.28196845,-0.85943669,-150.62487476); //delux object(137)
	CreateDynamicObject(13641,-2235.34130900,-1746.54797400,489.82138100,-359.14140514,-18.04817055,-60.16056849); //delux object(138)
	CreateDynamicObject(13722,-2371.52270500,-1609.12573200,510.78802500,0.00000000,0.00000000,-281.17903796); //delux object(139)
	CreateDynamicObject(16133,-2391.17993200,-1617.60156300,504.42272900,0.00000000,-7.73493023,-187.89004976); //delux object(140)
	CreateDynamicObject(10281,-2360.66674800,-1667.89660600,507.08081100,0.00000000,-1.71887339,-243.97688832); //delux object(141)
	CreateDynamicObject(16480,-2272.72558600,-1686.89209000,482.32971200,0.00000000,0.00000000,-97.11634627); //delux object(142)
	CreateDynamicObject(3528,-2287.64209000,-1635.91467300,496.56921400,-358.28196845,0.00000000,-179.62226877); //delux object(143)
	CreateDynamicObject(13667,-2224.70410200,-1497.71936000,503.36624100,-359.14140514,0.00000000,-116.02395351); //delux object(144)
	CreateDynamicObject(9685,-2024.51379400,-1220.60412600,563.33282500,0.00000000,0.00000000,-39.76327098); //delux object(145)
	CreateDynamicObject(9685,-1937.97802700,-1116.64074700,572.14013700,0.00000000,0.00000000,-39.76327098); //delux object(146)
	CreateDynamicObject(1655,-1885.76342800,-1065.62939500,523.49609400,0.00000000,0.00000000,-39.76327098); //delux object(147)
	CreateDynamicObject(1655,-1893.63867200,-1051.21411100,527.07312000,-347.96872814,0.00000000,-38.90383429); //delux object(148)
	CreateDynamicObject(1655,-1891.21899400,-1048.13659700,530.24810800,-338.51492452,0.00000000,-38.90383429); //delux object(149)
	CreateDynamicObject(1655,-1882.04699700,-1061.12402300,526.65741000,-347.96872814,0.00000000,-39.76327098); //delux object(150)
	CreateDynamicObject(1655,-1878.97631800,-1057.24011200,530.95202600,-336.79605113,0.00000000,-39.76327098); //delux object(151)
	CreateDynamicObject(2918,-1814.75610400,-1630.92358400,444.39895600,0.00000000,0.00000000,0.00000000); //delux object(152)
	CreateDynamicObject(2918,-1814.23303200,-1642.56665000,444.21426400,0.00000000,0.00000000,0.00000000); //delux object(153)
	CreateDynamicObject(2918,-1814.36010700,-1641.33471700,444.01147500,0.00000000,0.00000000,0.00000000); //delux object(154)
	CreateDynamicObject(2918,-1814.28552200,-1629.35400400,444.27661100,0.00000000,0.00000000,0.00000000); //delux object(155)
	CreateDynamicObject(2918,-1751.89111300,-1390.11853000,357.95867900,0.00000000,0.00000000,0.00000000); //delux object(156)
	CreateDynamicObject(2918,-1751.58068800,-1391.69079600,357.63897700,0.00000000,0.00000000,0.00000000); //delux object(157)
	CreateDynamicObject(2918,-1748.32226600,-1401.55578600,358.25439500,0.00000000,0.00000000,0.00000000); //delux object(158)
	CreateDynamicObject(2918,-1746.57299800,-1402.64331100,358.20712300,0.00000000,0.00000000,0.00000000); //delux object(159)
	CreateDynamicObject(2918,-2307.16552700,-1589.94287100,485.26867700,0.00000000,0.00000000,0.00000000); //delux object(160)
	CreateDynamicObject(4853,-2210.49243200,-1500.05444300,481.67050200,0.00000000,-1.71887339,-315.00073661); //delux object(161)
	CreateDynamicObject(4853,-2150.03833000,-1439.54370100,483.53909300,0.00000000,-0.85943669,-315.00073661); //delux object(162)
	CreateDynamicObject(4853,-2087.69043000,-1377.16088900,484.82846100,0.00000000,-0.85943669,-315.00073661); //delux object(163)
	CreateDynamicObject(4853,-2025.60461400,-1315.12756300,484.12933300,0.00000000,-358.28196845,-315.00073661); //delux object(164)
	CreateDynamicObject(4853,-1962.24853500,-1251.77746600,481.44866900,0.00000000,-358.28196845,-315.00073661); //delux object(165)
	CreateDynamicObject(4853,-1904.20153800,-1193.69958500,479.61804200,-359.14140514,-359.14140514,-315.00073661); //delux object(166)
	CreateDynamicObject(1655,-1871.27710000,-1160.85412600,483.56735200,-355.70365837,0.00000000,-46.01424053); //delux object(167)
	CreateDynamicObject(2918,-2285.19140600,-1664.53320300,483.92590300,0.00000000,0.00000000,0.00000000); //delux object(168)
	CreateDynamicObject(18449,-2245.02954100,-1636.05664100,484.84658800,0.00000000,0.00000000,0.00000000); //delux object(169)
	CreateDynamicObject(18449,-2165.40722700,-1636.06140100,484.83361800,0.00000000,0.00000000,0.00000000); //delux object(170)
	CreateDynamicObject(18449,-2086.04614300,-1636.09631300,484.84552000,0.00000000,0.00000000,0.00000000); //delux object(171)
	CreateDynamicObject(18449,-2007.12939500,-1636.09533700,477.75775100,0.00000000,-349.68760152,0.00000000); //delux object(172)
	CreateDynamicObject(18449,-1929.06311000,-1636.09265100,463.59442100,0.00000000,-349.68760152,0.00000000); //delux object(173)
	CreateDynamicObject(18449,-1852.87683100,-1636.08068800,449.73495500,0.00000000,-349.68760152,0.00000000); //delux object(174)
	CreateDynamicObject(18449,-1928.73535200,-1467.16076700,400.45431500,0.00000000,-347.10929145,-338.51492452); //delux object(175)
	CreateDynamicObject(18449,-1856.40197800,-1438.66333000,382.68826300,0.00000000,-347.10929145,-338.51492452); //delux object(176)
	CreateDynamicObject(18449,-1784.23852500,-1410.25036600,364.94928000,0.00000000,-347.10929145,-338.51492452); //delux object(177)
	CreateDynamicObject(1655,-2234.17309600,-1738.96838400,484.51684600,-348.82816483,-358.28196845,-149.76543807); //delux object(178)
	CreateDynamicObject(1655,-2241.74682600,-1743.29223600,484.24514800,-348.82816483,-358.28196845,-149.76543807); //delux object(179)

	// Normal shit
	UsePlayerPedAnims();
	SetTimer("carfix", 1500, true);
	SetTimer("randommsg", 60000, true);
	EnableStuntBonusForAll(1);
	SetGameModeText("ShuffRoam R1");
	AddPlayerClass(256, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	return 1;
}

public OnGameModeExit()
{
	print("Server restart initiated.");
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SpawnPlayer(playerid);
	SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
	if(GetPlayerSkin(playerid) == 0)
	{
		SetPlayerSkin(playerid, 246);
		PlayerInfo[playerid][Skin] = GetPlayerSkin(playerid);
		SendClientMessage(playerid, COLOR_WHITE, "[INFO:] Your skin ID was invalid. It was changed to a different one.");
		SendClientMessage(playerid, COLOR_WHITE, "[INFO:] To change your skin, use "#COL_LBLUE"/skin [value]");
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
    new pname[MAX_PLAYER_NAME], string[22 + MAX_PLAYER_NAME];
    GetPlayerName(playerid, pname, sizeof(pname));
    format(string, sizeof(string), ""#COL_EASY"[JOIN] %s has joined the server", pname);
    SendClientMessageToAll(COLOR_WHITE, string);
	printf("[JOIN] %s has joined the server!", pname);
	TextDrawShowForAll(Text:undertext);
	for(new chat = 0; chat <= 100; chat++)
	{
		SendClientMessage(playerid,COLOR_WHITE," ");
	}

  	SendClientMessage(playerid,COLOR_WHITE,""#COL_LOGIN"==========================================================================================================");
	SendClientMessage(playerid,COLOR_WHITE,""#COL_LOGIN"  ShuffRoam, under development and shitty work. INDEV");
	SendClientMessage(playerid,COLOR_WHITE,""#COL_LOGIN"             - Since 2012");
	SendClientMessage(playerid, COLOR_WHITE, "  ");
	SendClientMessage(playerid,COLOR_WHITE,""#COL_LOGIN"» Latest update: Many new things added, not updating this for a while");
	SendClientMessage(playerid,COLOR_WHITE,""#COL_LOGIN"» I dont know why I am adding these, I am going to fail anyways.");
	SendClientMessage(playerid,COLOR_WHITE,""#COL_LOGIN" ");
	SendClientMessage(playerid,COLOR_WHITE,""#COL_LOGIN"==========================================================================================================");

    if(fexist(UserPath(playerid)))
    {
        INI_ParseFile(UserPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
		INI_ParseFile(UserAOPath(playerid), "LoadAO_%s", .bExtra = true, .extra = playerid);
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,""#COL_ORANGE":: "#COL_WHITE"Login", "\t\t"#COL_LBLUE"ShuffRoam Indev \n\n"#COL_WHITE"Welcome back to the server!\nEnter your password below to start playing.", "Login", "Quit");
    }
    else
    {
        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,""#COL_ORANGE":: "#COL_WHITE"Register" , "\t\t"#COL_LBLUE"ShuffRoam Indev \n\n"#COL_WHITE"You are not registered, \nPlease enter a password below to register your account!", "Register", "Exit");
    }
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{

    new pname[MAX_PLAYER_NAME], string[39 + MAX_PLAYER_NAME];
    GetPlayerName(playerid, pname, sizeof(pname));
    switch(reason)
    {
        case 0: format(string, sizeof(string), ""#COL_EASY"[LEFT] %s has left the server. (Timeout)", pname);
        case 1: format(string, sizeof(string), ""#COL_EASY"[LEFT] %s has left the server. (Leaving)", pname);
        case 2: format(string, sizeof(string), ""#COL_EASY"[LEFT] %s has left the server. (Kicked/Banned)", pname);
    }
    SendClientMessageToAll(COLOR_WHITE, string);

	DestroyVehicle(mycar[playerid]);

    new INI:File = INI_Open(UserPath(playerid));
    INI_SetTag(File,"data");
    INI_WriteInt(File,"Cash",GetPlayerMoney(playerid));
    INI_WriteInt(File,"Kills",PlayerInfo[playerid][Kills]);
    INI_WriteInt(File,"Deaths",PlayerInfo[playerid][Deaths]);
	INI_WriteInt(File,"Skin",PlayerInfo[playerid][Skin]);
	INI_WriteInt(File,"Cookies",PlayerInfo[playerid][Cookies]);
	INI_WriteFloat(File,"Speedboost",PlayerInfo[playerid][Speedboost]);
    INI_WriteInt(File,"Adminlevel",PlayerInfo[playerid][Adminlevel]);
    INI_Close(File);
	
	new INI:File2 = INI_Open(UserAOPath(playerid));
	INI_SetTag(File,"1 AttachedObject");
    INI_WriteInt(File2,"Model", AOInfo[playerid][Model]);
    INI_WriteInt(File2, "ID", AOInfo[playerid][ID]);
	INI_WriteFloat(File2, "X", AOInfo[playerid][oX]);
	INI_WriteFloat(File2, "rX", AOInfo[playerid][rX]);
	INI_WriteFloat(File2, "Y", AOInfo[playerid][oY]);
	INI_WriteFloat(File2, "rY", AOInfo[playerid][rY]);
	INI_WriteFloat(File2, "Z", AOInfo[playerid][oZ]);
	INI_WriteFloat(File2, "rZ", AOInfo[playerid][rZ]);
	/*INI_SetTag(File,"2 AttachedObject");
	INI_WriteInt(File2,"Model", AOInfo[playerid][Model2]);
    INI_WriteInt(File2, "ID", AOInfo[playerid][ID2]);
	INI_WriteFloat(File2, "X", AOInfo[playerid][oX2]);
	INI_WriteFloat(File2, "rX", AOInfo[playerid][rX2]);
	INI_WriteFloat(File2, "Y", AOInfo[playerid][oY2]);
	INI_WriteFloat(File2, "rY", AOInfo[playerid][rY2]);
	INI_WriteFloat(File2, "Z", AOInfo[playerid][oZ2]);
	INI_WriteFloat(File2, "rZ", AOInfo[playerid][rZ2]);
	INI_SetTag(File,"3 AttachedObject");
	INI_WriteInt(File2,"Model", AOInfo[playerid][Model3]);
    INI_WriteInt(File2, "ID", AOInfo[playerid][ID3]);
	INI_WriteFloat(File2, "X", AOInfo[playerid][oX3]);
	INI_WriteFloat(File2, "rX", AOInfo[playerid][rX3]);
	INI_WriteFloat(File2, "Y", AOInfo[playerid][oY3]);
	INI_WriteFloat(File2, "rY", AOInfo[playerid][rY3]);
	INI_WriteFloat(File2, "Z", AOInfo[playerid][oZ3]);
	INI_WriteFloat(File2, "rZ", AOInfo[playerid][rZ3]);
	INI_SetTag(File,"4 AttachedObject");
	INI_WriteInt(File2,"Model", AOInfo[playerid][Model4]);
    INI_WriteInt(File2, "ID", AOInfo[playerid][ID4]);
	INI_WriteFloat(File2, "X", AOInfo[playerid][oX4]);
	INI_WriteFloat(File2, "rX", AOInfo[playerid][rX4]);
	INI_WriteFloat(File2, "Y", AOInfo[playerid][oY4]);
	INI_WriteFloat(File2, "rY", AOInfo[playerid][rY4]);
	INI_WriteFloat(File2, "Z", AOInfo[playerid][oZ4]);
	INI_WriteFloat(File2, "rZ", AOInfo[playerid][rZ4]);
	INI_SetTag(File,"5 AttachedObject");
	INI_WriteInt(File2,"Model", AOInfo[playerid][Model5]);
    INI_WriteInt(File2, "ID", AOInfo[playerid][ID5]);
	INI_WriteFloat(File2, "X", AOInfo[playerid][oX5]);
	INI_WriteFloat(File2, "rX", AOInfo[playerid][rX5]);
	INI_WriteFloat(File2, "Y", AOInfo[playerid][oY5]);
	INI_WriteFloat(File2, "rY", AOInfo[playerid][rY5]);
	INI_WriteFloat(File2, "Z", AOInfo[playerid][oZ5]);
	INI_WriteFloat(File2, "rZ", AOInfo[playerid][rZ5]);*/
    INI_Close(File2);
    return 1;
}

public OnPlayerSpawn(playerid)
{
	new rand = random(sizeof(RandomSpawn));

	//SetPlayerPos(playerid, 403.6374,2447.7241,16.5000);
	if(RandomSpawn[rand][0] == 403.6374) { SendClientMessage(playerid, COLOR_WHITE, ""#COL_LOGIN"[INFO:] You have spawned at the abandoned airport!"); }
	else if(RandomSpawn[rand][0] == 2119.0869) { SendClientMessage(playerid, COLOR_WHITE, ""#COL_LOGIN"[INFO:] You have spawned at the LS Airport!"); }
	else if(RandomSpawn[rand][0] == -2620.0549) { SendClientMessage(playerid, COLOR_WHITE, ""#COL_LOGIN"[INFO:] You have spawned at Jizzys club!!"); }
	SetPlayerPos(playerid, RandomSpawn[rand][0], RandomSpawn[rand][1],RandomSpawn[rand][2]);
	SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
	TextDrawShowForPlayer(playerid, undertext);
	new thebone;
	if(AOInfo[playerid][Model] == 19101) { thebone = 2; }
	else if(AOInfo[playerid][Model] == 19086) { thebone = 5; }
	if(AOInfo[playerid][Model] != 0)
	{
		item1 = SetPlayerAttachedObject(playerid, AOInfo[playerid][ID], AOInfo[playerid][Model], thebone, AOInfo[playerid][oX], AOInfo[playerid][oY], AOInfo[playerid][oZ], AOInfo[playerid][rX], AOInfo[playerid][rY], AOInfo[playerid][rZ]);	
	}
	if(AOInfo[playerid][Model2] != 0)
	{
		item2 = SetPlayerAttachedObject(playerid, AOInfo[playerid][ID2], AOInfo[playerid][Model2], thebone, AOInfo[playerid][oX2], AOInfo[playerid][oY2], AOInfo[playerid][oZ2], AOInfo[playerid][rX2], AOInfo[playerid][rY2], AOInfo[playerid][rZ2]);	
	}
	if(AOInfo[playerid][Model3] != 0)
	{
		item3 = SetPlayerAttachedObject(playerid, AOInfo[playerid][ID], AOInfo[playerid][Model3], thebone, AOInfo[playerid][oX3], AOInfo[playerid][oY3], AOInfo[playerid][oZ3], AOInfo[playerid][rX3], AOInfo[playerid][rY3], AOInfo[playerid][rZ3]);	
	}
	if(AOInfo[playerid][Model4] != 0)
	{
		item4 = SetPlayerAttachedObject(playerid, AOInfo[playerid][ID4], AOInfo[playerid][Model4], thebone, AOInfo[playerid][oX4], AOInfo[playerid][oY4], AOInfo[playerid][oZ4], AOInfo[playerid][rX4], AOInfo[playerid][rY4], AOInfo[playerid][rZ4]);	
	}
	if(AOInfo[playerid][Model5] != 0)
	{
		item5 = SetPlayerAttachedObject(playerid, AOInfo[playerid][ID5], AOInfo[playerid][Model5], thebone, AOInfo[playerid][oX5], AOInfo[playerid][oY5], AOInfo[playerid][oZ5], AOInfo[playerid][rX5], AOInfo[playerid][rY5], AOInfo[playerid][rZ5]);	
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	new killerName[MAX_PLAYER_NAME], playerName[MAX_PLAYER_NAME], death[256];
	GetPlayerName(killerid, killerName, sizeof(killerName));
	GetPlayerName(playerid, playerName, sizeof(playerName));

    PlayerInfo[killerid][Kills]++;
    PlayerInfo[playerid][Deaths]++;
	format(death, sizeof(death), "~g~you got pwned by \n~w~%s", killerName);
	GameTextForPlayer(playerid, death, 5000, 3);

	if(pInEvent[playerid] == 1)
	{
		g_EventPlayers--;
		pInEvent[playerid] = 0;
		if(g_EventPlayers == 1)
		{
			foreach(Player, i)
			{
		        if(pInEvent[i] == 1)
				{
					new string[128], player_Name[MAX_PLAYER_NAME];
					GetPlayerRame(i, player_Name, sizeof(player_Name));
					format(string, sizeof(string), ""#COL_BROWN"[EVENT]"#COL_LBLUE" %s has won the LMS event and has collected $%d!", player_Name, g_EventReward);
					SendClientMessageToAll(-1, string);
					GivePlayerMoney(i, g_EventReward);
					pInEvent[i] = 0;
					g_EventOpen = 0, g_EventPlayers = 0, g_EventReward = 0, g_EventWeapon = 0;
					SpawnPlayer(i);
				}
			}
		}
	}
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
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
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
	if(PRESSED(KEY_FIRE))
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
		}
	}
	if(PRESSED(KEY_HORN))
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			new Float:vx,Float:vy,Float:vz;
			new vehicle = GetPlayerVehicleID(playerid);
			GetVehicleVelocity(vehicle, vx, vy, vz);
  			SetVehicleVelocity(vehicle, vx, vy, vz + 0.5);
		}
	}
	if(PRESSED(KEY_ACTION))
    {
		if(IsPlayerInAnyVehicle(playerid))
		{
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			{
				new Float:v;
				v = PlayerInfo[playerid][Speedboost];
				if(v == 0.000000) { v = 1.3; }
				new Float:vx,Float:vy,Float:vz;
				GetVehicleVelocity(GetPlayerVehicleID(playerid),vx,vy,vz);
				SetVehicleVelocity(GetPlayerVehicleID(playerid), vx * v, vy * v, vz * v);
			}
		}

	}
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
	if(dialogid == DIALOG_AOB)
	{
		switch(listitem)
		{
			if(response)
			{
				case 0:
				{
					if(AOInfo[playerid][Model] != 0)
					{
						ShowPlayerDialog(playerid, DIALOG_AOB+1, DIALOG_STYLE_MSGBOX, ""#COL_LBLUE"Attached Object Editor", ""#COL_WHITE"Do you want to edit the positon of your current object?", "YES", "EXIT");
						
					} else
					{
						ShowPlayerDialog(playerid, DIALOG_AOB+1, DIALOG_STYLE_LIST, ""#COL_LBLUE"Attached Object Editor", "Add Army Helmet\nAdd Chainsaw Dildo", "OK", "EXIT");
					}
				}
				case 1: // chainsaw dildo
				{
				
				}
			}
		}
	}
	if(dialogid == DIALOG_AOB+1)
	{
		EditAttachedObject(playerid, item1);
		SendClientMessage(playerid, COLOR_WHITE, "[INFO:] Use the buttons to move the object.");
		SendClientMessage(playerid, COLOR_WHITE, "[INFO:] When you are done editing the object, click the save button");
		return 1;
	}
	if(dialogid == DIAV)
    {
        switch(listitem)
        {
			case 0:
			{
				ShowPlayerDialog(playerid, DIAV+1, DIALOG_STYLE_LIST, ""#COL_WHITE"Vehicles - Sports !", "{0094FF}Alpha\n{0094FF}Banshee\n{0094FF}Buffalo\n{0094FF}Bullet\n{0094FF}Cheetah\n{0094FF}Phoenix\n{0094FF}Super GT\n{0094FF}Infernus {FF0000}[Recommended {0094FF}and {FFD800}Rapid]\n{0094FF}Turismo\n{0094FF}ZR-350", "Accept", "Cancel");
			}
			case 1:
			{
				ShowPlayerDialog(playerid, DIAV+2, DIALOG_STYLE_LIST, ""#COL_WHITE"Vehicles - Tuneables and elegants !", "{0094FF}Elegy{FF0000} [Drifting]\n{0094FF}Sultan\n{0094FF}Blade\n{0094FF}Savanna\n{0094FF}Slamvan\n{0094FF}Remington\n{0094FF}Jester\n{0094FF}Uranus\n{0094FF}Sabre\n{0094FF}Flash", "Accept", "Cancel");
			}
			case 2:
			{
				ShowPlayerDialog(playerid, DIAV+3, DIALOG_STYLE_LIST, ""#COL_WHITE" Motorcycles and bicycles !", "{0094FF}Bike\n{0094FF}BMX\n{0094FF}Mountain Bike\n{0094FF}Faggio\n{0094FF}Pizzaboy\n{0094FF}BF-400\n{0094FF}NRG-500{FF0000} [Recommended]\n{0094FF}PCJ-600\n{0094FF}FCR-900\n{0094FF}Freeway\n{0094FF}Wayfarer\n{0094FF}Sanchez\n{0094FF}Quad", "Accept", "Cancel");
			}
			case 3:
			{
				ShowPlayerDialog(playerid, DIAV+4, DIALOG_STYLE_LIST, ""#COL_WHITE" SUV !", "{0094FF}Bandito\n{0094FF}BF Injection\n{0094FF}Dune\n{0094FF}Huntley\n{0094FF}Landstalker\n{0094FF}Mesa\n{0094FF}Monster\n{0094FF}Moster A\n{0094FF}Monster B\n{0094FF}Patriot\n{0094FF}Rancher\n{0094FF}Sandking", "Accept", "Cancel");
			}
			case 4:
			{
				ShowPlayerDialog(playerid, DIAV+5, DIALOG_STYLE_LIST, ""#COL_WHITE" Planes !", "{0094FF}Andromada\n{0094FF}AT-400\n{0094FF}Beagle\n{0094FF}Cropduster\n{0094FF}Dodo\n{0094FF}Hydra {FF0000}[Admin]\n{0094FF}Nevada\n{0094FF}Rustler {FF0000}[Admin]\n{0094FF}Shamal\n{0094FF}Skimmer\n{0094FF}Stunt Plane", "Accept", "Cancel");
			}
			case 5:
			{
				ShowPlayerDialog(playerid, DIAV+6, DIALOG_STYLE_LIST, ""#COL_WHITE" Helicopters !", "{0094FF}Cargobob\n{0094FF}Hunter {FF0000}[Admin]\n{0094FF}Leviathan\n{0094FF}Maverick\n{0094FF}Heli News\n{0094FF}Heli Police\n{0094FF}Raindance\n{0094FF}Seasparrow\n{0094FF}Sparrow", "Accept", "Cancel");
			}
			case 6:
			{
				ShowPlayerDialog(playerid, DIAV+7, DIALOG_STYLE_LIST, ""#COL_WHITE" Aquatic/Ships/Boats !", "{0094FF}Coastguard\n{0094FF}Dinghy\n{0094FF}Jetmax\n{0094FF}Launch\n{0094FF}Marquis\n{0094FF}Predator\n{0094FF}Reefer\n{0094FF}Speeder\n{0094FF}Squallo\n{0094FF}Tropip", "Accept", "Cancel");
			}
			case 7:
			{
				ShowPlayerDialog(playerid, DIAV+8, DIALOG_STYLE_LIST, ""#COL_WHITE"Public service !", "{0094FF}Ambulance\n{0094FF}Barracks\n{0094FF}Bus\n{0094FF}Cabbie\n{0094FF}Coach\n{0094FF}Police Motorcycle\n{0094FF}Enforcer\n{0094FF}FBI Rancher\n{0094FF}Van FBI\n{0094FF}Fire Truck\n{0094FF}Fire Truck Stair\n{0094FF}LSPD\n{0094FF}SFPD\n{0094FF}LVPD\n{0094FF}Ranger\n{0094FF}Rinho {FF0000}[Admin]\n{0094FF}SWAT\n{0094FF}Taxi", "Accept", "Cancel");
			}
			case 8:
			{
				ShowPlayerDialog(playerid, DIAV+9, DIALOG_STYLE_LIST, ""#COL_WHITE"Industrials !", "{0094FF}Benson\n{0094FF}Bobcat\n{0094FF}Burrito\n{0094FF}Boxville\n{0094FF}Boxburg\n{0094FF}Mule\n{0094FF}News\n{0094FF}Picador\n{0094FF}Pony\n{0094FF}Rumpo\n{0094FF}Sadler\n{0094FF}Topfun\n{0094FF}Tractor\n{0094FF}Utility\n{0094FF}Yankee\n{0094FF}Yosemite", "Accept", "Cancel");
			}
			case 9:
			{
				ShowPlayerDialog(playerid, DIAV+10, DIALOG_STYLE_LIST, ""#COL_WHITE"Saloon", "{0094FF}Admiral\n{0094FF}Bloodring Banger\n{0094FF}Bravura\n{0094FF}Buccaner\n{0094FF}Cadrona\n{0094FF}Clover\n{0094FF}Elegant\n{0094FF}Emperor\n{0094FF}Glendale\n{0094FF}Hermes\n{0094FF}Intruder\n{0094FF}Majestic\n{0094FF}Manana\n{0094FF}Merit\n{0094FF}Nebula\n{0094FF}Premier\n{0094FF}Oceanic\n{0094FF}Primo\n{0094FF}Previon\n{0094FF}Stafford\n{0094FF}Vicent\n{0094FF}Virgo\n{0094FF}Washington", "Accept", "Cancel");
			}
			case 10:
			{
				ShowPlayerDialog(playerid, DIAV+11, DIALOG_STYLE_LIST, ""#COL_WHITE" Trucks !", "{0094FF}Cement Truck\n{0094FF}DFT-30\n{0094FF}Flatbed\n{0094FF}Linerunner\n{0094FF}Packer\n{0094FF}Petrol Tank\n{0094FF}Roadtrain", "Aceptar", "Cancelar");
			}
			case 11:
			{
				ShowPlayerDialog(playerid, DIAV+12, DIALOG_STYLE_LIST, ""#COL_WHITE" Loads !", "{0094FF}Loads of Articles 1\n{0094FF}Load of Arena\n{0094FF}Loads of Articles 2\n{0094FF}Load of Gasoline\n{0094FF}Load of Train 1\n{0094FF}Train\n{0094FF}Load of Train 2\n{0094FF}Baggage A\n{0094FF}Baggage B\n{0094FF}Scairs\n{0094FF}Farm\n{0094FF}Load Utility", "Accept", "Cancel");
			}
			case 12:
			{
				ShowPlayerDialog(playerid, DIAV+13, DIALOG_STYLE_LIST, ""#COL_WHITE" Unique vehicles !", "{0094FF}Baggage\n{0094FF}Train\n{0094FF}Caddy\n{0094FF}Camper 1\n{0094FF}Camper 2\n{0094FF}Combine Harvester\n{0094FF}Dozer\n{0094FF}Dumper\n{0094FF}Forklift\n{0094FF}Train 2\n{0094FF}Hotknife\n{0094FF}Hustler\n{0094FF}Hotdog\n{0094FF}Kart\n{0094FF}Mower\n{0094FF}IceCream Truck\n{0094FF}Romero\n{0094FF}Securicar\n{0094FF}Stretch\n{0094FF}Sweeper\n{0094FF}Tram\n{0094FF}Tug\n{0094FF}Vortex", "Accept", "Cancel");
			}
			case 13:
			{
				ShowPlayerDialog(playerid, DIAV+14, DIALOG_STYLE_LIST, ""#COL_WHITE" RC Vehicles !", "{0094FF}RC Bandit\n{0094FF}RC Baron\n{0094FF}RC Raider\n{0094FF}RC Goblin\n{0094FF}RC Tiger\n{0094FF}RC Cam", "Accept", "Cancel");
			}
        }
		return 1;
	}
    if(dialogid == DIAV+1)
    {
        switch(listitem)
        {
	        case 0: { CreateVehicleExEx(playerid, 602); }
			case 1: { CreateVehicleExEx(playerid, 429); }
	        case 2: { CreateVehicleExEx(playerid, 402); }
			case 3: { CreateVehicleExEx(playerid, 541); }
			case 4: { CreateVehicleExEx(playerid, 415); }
			case 5: { CreateVehicleExEx(playerid, 603); }
			case 6: { CreateVehicleExEx(playerid, 506); }
			case 7: { CreateVehicleExEx(playerid, 411); }
			case 8: { CreateVehicleExEx(playerid, 451); }
			case 9: { CreateVehicleExEx(playerid, 477); }
        }
        return 1;
	}
    if(dialogid == DIAV+2)
    {
        switch(listitem)
        {
	        case 0: { CreateVehicleExEx(playerid, 562); }
			case 1: { CreateVehicleExEx(playerid, 560); }
			case 2: { CreateVehicleExEx(playerid, 536); }
			case 3: { CreateVehicleExEx(playerid, 567); }
			case 4: { CreateVehicleExEx(playerid, 535); }
			case 5: { CreateVehicleExEx(playerid, 534); }
			case 6: { CreateVehicleExEx(playerid, 559); }
			case 7: { CreateVehicleExEx(playerid, 558); }
			case 8: { CreateVehicleExEx(playerid, 475); }
			case 9: { CreateVehicleExEx(playerid, 565); }
		}
		return 1;
	}
    if(dialogid == DIAV+3)
    {
        switch(listitem)
        {
	        case 0: { CreateVehicleExEx(playerid, 509); }
			case 1: { CreateVehicleExEx(playerid, 481); }
			case 2: { CreateVehicleExEx(playerid, 510); }
			case 3: { CreateVehicleExEx(playerid, 462); }
			case 4: { CreateVehicleExEx(playerid, 448); }
			case 5: { CreateVehicleExEx(playerid, 581); }
			case 6: { CreateVehicleExEx(playerid, 522); }
			case 7: { CreateVehicleExEx(playerid, 461); }
			case 8: { CreateVehicleExEx(playerid, 521); }
			case 9: { CreateVehicleExEx(playerid, 463); }
			case 10: { CreateVehicleExEx(playerid, 586); }
			case 11: { CreateVehicleExEx(playerid, 468); }
			case 12: { CreateVehicleExEx(playerid, 471); }
		}	
		return 1;
	}
    if(dialogid == DIAV+4)
    {
        switch(listitem)
        {
	        case 0: { CreateVehicleExEx(playerid, 568); }
			case 1: { CreateVehicleExEx(playerid, 424); }
			case 2: { CreateVehicleExEx(playerid, 573); }
			case 3: { CreateVehicleExEx(playerid, 579); }
			case 4: { CreateVehicleExEx(playerid, 400); }
			case 5: { CreateVehicleExEx(playerid, 500); }
			case 6: { CreateVehicleExEx(playerid, 444); }
			case 7: { CreateVehicleExEx(playerid, 556); }
			case 8: { CreateVehicleExEx(playerid, 557); }
			case 9: { CreateVehicleExEx(playerid, 470); }
			case 10: { CreateVehicleExEx(playerid, 489); }
			case 11: { CreateVehicleExEx(playerid, 495); }
		}
		return 1;
	}
    if(dialogid == DIAV+5)
    {
        switch(listitem)
        {
	        case 0: { CreateVehicleExEx(playerid, 592); }
			case 1: { CreateVehicleExEx(playerid, 577); }
			case 2: { CreateVehicleExEx(playerid, 511); }
			case 3: { CreateVehicleExEx(playerid, 512); }
			case 4: { CreateVehicleExEx(playerid, 593); }
			case 5:
			{
			    if(PlayerInfo[playerid][Adminlevel] <= 1) return SendClientMessage(playerid, COLOR_WHITE, "** This vehicle is only for administrators");
		    	CreateVehicleExEx(playerid, 520);
			}
			case 6: { CreateVehicleExEx(playerid, 553); }
			case 7:
			{
   				if(PlayerInfo[playerid][Adminlevel] <= 1) return SendClientMessage(playerid, COLOR_WHITE, "** This vehicle is only for administrators");
		    	CreateVehicleExEx(playerid, 476);
			}
			case 8: { CreateVehicleExEx(playerid, 519); }
			case 9: { CreateVehicleExEx(playerid, 460); }
			case 10: { CreateVehicleExEx(playerid, 513); }
		}
		return 1;
	}
    if(dialogid == DIAV+6)
    {
        switch(listitem)
        {
	        case 0: { CreateVehicleExEx(playerid, 548); }
			case 1:
			{
			    if(PlayerInfo[playerid][Adminlevel] <= 1) return SendClientMessage(playerid, COLOR_WHITE, "** This vehicle is only for administrators !");
	    		CreateVehicleExEx(playerid, 425);
			}
			case 2: { CreateVehicleExEx(playerid, 417); }
			case 3: { CreateVehicleExEx(playerid, 487); }
			case 4: { CreateVehicleExEx(playerid, 488); }
			case 5: { CreateVehicleExEx(playerid, 497); }
			case 6: { CreateVehicleExEx(playerid, 563); }
			case 7: { CreateVehicleExEx(playerid, 447); }
			case 8: { CreateVehicleExEx(playerid, 469); }
		}
		return 1;
	}
    if(dialogid == DIAV+7)
    {
        switch(listitem)
        {
	        case 0: { CreateVehicleExEx(playerid, 472); }
			case 1: { CreateVehicleExEx(playerid, 473); }
			case 2: { CreateVehicleExEx(playerid, 493); }
			case 3: { CreateVehicleExEx(playerid, 595); }
			case 4: { CreateVehicleExEx(playerid, 484); }
			case 5: { CreateVehicleExEx(playerid, 430); }
			case 6: { CreateVehicleExEx(playerid, 453); }
			case 7: { CreateVehicleExEx(playerid, 452); }
			case 8: { CreateVehicleExEx(playerid, 446); }
			case 9: { CreateVehicleExEx(playerid, 454); }
		}
		return 1;
	}
    if(dialogid == DIAV+8)
    {
        switch(listitem)
        {
	        case 0: { CreateVehicleExEx(playerid, 416); }
			case 1: { CreateVehicleExEx(playerid, 433); }
			case 2: { CreateVehicleExEx(playerid, 431); }
			case 3: { CreateVehicleExEx(playerid, 438); }
			case 4: { CreateVehicleExEx(playerid, 437); }
			case 5: { CreateVehicleExEx(playerid, 523); }
			case 6: { CreateVehicleExEx(playerid, 427); }
			case 7: { CreateVehicleExEx(playerid, 490); }
			case 8: { CreateVehicleExEx(playerid, 528); }
			case 9: { CreateVehicleExEx(playerid, 407); }
 			case 10: { CreateVehicleExEx(playerid, 544); }
			case 11: { CreateVehicleExEx(playerid, 596); }
			case 12: { CreateVehicleExEx(playerid, 597); }
			case 13: { CreateVehicleExEx(playerid, 598); }
			case 14: { CreateVehicleExEx(playerid, 599); }
			case 15:
			{
			    if(PlayerInfo[playerid][Adminlevel] <= 1) return SendClientMessage(playerid, COLOR_WHITE, "** This vehicle is only for administrators !");
		    	CreateVehicleExEx(playerid, 432);
			}
			case 16: { CreateVehicleExEx(playerid, 601); }
			case 17: { CreateVehicleExEx(playerid, 420); }
		}
        return 1;
	}

    if(dialogid == DIAV+9)
    {
        switch(listitem)
        {
	        case 0: { CreateVehicleExEx(playerid, 499); }
			case 1: { CreateVehicleExEx(playerid, 422); }
			case 2: { CreateVehicleExEx(playerid, 482); }
			case 3: { CreateVehicleExEx(playerid, 498); }
			case 4: { CreateVehicleExEx(playerid, 609); }
			case 5: { CreateVehicleExEx(playerid, 414); }
			case 6: { CreateVehicleExEx(playerid, 582); }
			case 7: { CreateVehicleExEx(playerid, 600); }
			case 8: { CreateVehicleExEx(playerid, 413); }
			case 9: { CreateVehicleExEx(playerid, 440); }
 			case 10: { CreateVehicleExEx(playerid, 543); }
			case 11: { CreateVehicleExEx(playerid, 605); }
			case 12: { CreateVehicleExEx(playerid, 531); }
			case 13: { CreateVehicleExEx(playerid, 552); }
			case 14: { CreateVehicleExEx(playerid, 456); }
			case 15: { CreateVehicleExEx(playerid, 554); }
		}
        return 1;
	}
    if(dialogid == DIAV+10)
    {
        switch(listitem)
        {
	        case 0: { CreateVehicleExEx(playerid, 445); }
	        case 1: { CreateVehicleExEx(playerid, 504); }
	        case 2: { CreateVehicleExEx(playerid, 401); }
	        case 3: { CreateVehicleExEx(playerid, 518); }
	        case 4: { CreateVehicleExEx(playerid, 527); }
	        case 5: { CreateVehicleExEx(playerid, 542); }
	        case 6: { CreateVehicleExEx(playerid, 507); }
	        case 7: { CreateVehicleExEx(playerid, 585); }
	        case 8: { CreateVehicleExEx(playerid, 466); }
	        case 9: { CreateVehicleExEx(playerid, 474); }
 	        case 10: { CreateVehicleExEx(playerid, 546); }
	        case 11: { CreateVehicleExEx(playerid, 517); }
	        case 12: { CreateVehicleExEx(playerid, 410); }
	        case 13: { CreateVehicleExEx(playerid, 551); }
	        case 14: { CreateVehicleExEx(playerid, 516); }
	        case 15: { CreateVehicleExEx(playerid, 426); }
	        case 16: { CreateVehicleExEx(playerid, 467); }
	        case 17: { CreateVehicleExEx(playerid, 547); }
	        case 18: { CreateVehicleExEx(playerid, 436); }
	        case 19: { CreateVehicleExEx(playerid, 580); }
	        case 20: { CreateVehicleExEx(playerid, 540); }
	        case 21: { CreateVehicleExEx(playerid, 491); }
	        case 22: { CreateVehicleExEx(playerid, 421); }
		}
        return 1;
	}
    if(dialogid == DIAV+11)
    {
        switch(listitem)
        {
	        case 0: { CreateVehicleExEx(playerid, 524); }
	        case 1: { CreateVehicleExEx(playerid, 578); }
	        case 2: { CreateVehicleExEx(playerid, 455); }
	        case 3: { CreateVehicleExEx(playerid, 403); }
	        case 4: { CreateVehicleExEx(playerid, 443); }
	        case 5: { CreateVehicleExEx(playerid, 514); }
	        case 6: { CreateVehicleExEx(playerid, 515); }
		}
        return 1;
	}
    if(dialogid == DIAV+12)
    {
        switch(listitem)
        {
	        case 0: { CreateVehicleExEx(playerid, 435); }
	        case 1: { CreateVehicleExEx(playerid, 450); }
	        case 2: { CreateVehicleExEx(playerid, 591); }
	        case 3: { CreateVehicleExEx(playerid, 584); }
	        case 4: { CreateVehicleExEx(playerid, 569); }
	        case 5: { CreateVehicleExEx(playerid, 570); }
	        case 6: { CreateVehicleExEx(playerid, 590); }
	        case 7: { CreateVehicleExEx(playerid, 606); }
	        case 8: { CreateVehicleExEx(playerid, 607); }
	        case 9: { CreateVehicleExEx(playerid, 608); }
	        case 10: { CreateVehicleExEx(playerid, 610); }
	        case 11: { CreateVehicleExEx(playerid, 611); }
		}
        return 1;
	}
    if(dialogid == DIAV+13)
    {
        switch(listitem)
        {
	        case 0: { CreateVehicleExEx(playerid, 485); }
	        case 1: { CreateVehicleExEx(playerid, 538); }
	        case 2: { CreateVehicleExEx(playerid, 457); }
	        case 3: { CreateVehicleExEx(playerid, 483); }
	        case 4: { CreateVehicleExEx(playerid, 508); }
	        case 5: { CreateVehicleExEx(playerid, 532); }
	        case 6: { CreateVehicleExEx(playerid, 486); }
	        case 7: { CreateVehicleExEx(playerid, 406); }
	        case 8: { CreateVehicleExEx(playerid, 530); }
	        case 9: { CreateVehicleExEx(playerid, 537); }
	        case 10: { CreateVehicleExEx(playerid, 434); }
	        case 11: { CreateVehicleExEx(playerid, 545); }
	        case 12: { CreateVehicleExEx(playerid, 588); }
	        case 13: { CreateVehicleExEx(playerid, 571); }
	        case 14: { CreateVehicleExEx(playerid, 572); }
	        case 15: { CreateVehicleExEx(playerid, 423); }
	        case 16: { CreateVehicleExEx(playerid, 442); }
	        case 17: { CreateVehicleExEx(playerid, 428); }
	        case 18: { CreateVehicleExEx(playerid, 409); }
	        case 19: { CreateVehicleExEx(playerid, 574); }
	        case 20: { CreateVehicleExEx(playerid, 449); }
	        case 21: { CreateVehicleExEx(playerid, 583); }
	        case 22: { CreateVehicleExEx(playerid, 539); }
		}
        return 1;
	}
    if(dialogid == DIAV+14)
    {
         switch(listitem)
         {
	        case 0: { CreateVehicleExEx(playerid, 441); }
	        case 1: { CreateVehicleExEx(playerid, 464); }
	        case 2: { CreateVehicleExEx(playerid, 465); }
	        case 3: { CreateVehicleExEx(playerid, 501); }
	        case 4: { CreateVehicleExEx(playerid, 564); }
	        case 5: { CreateVehicleExEx(playerid, 594); }
		}
	}
    switch( dialogid )
    {
		case DIALOG_TUNE:
		{
			if(response)
			{
				if(IsPlayerInAnyVehicle(playerid))
				{
					if(listitem == 0)
					{
						SetPlayerPosWithVehicle(playerid, 2644.3606, -2004.1403, 13.3828, 88.0709);
						return 1;
					}
					if(listitem == 1)
					{
						SetPlayerPosWithVehicle(playerid, 2408.4683, 1036.2778, 10.8203, 88.0709);
						return 1;
					}
					if(listitem == 2)
					{
						SetPlayerPosWithVehicle(playerid, -2713.6375, 224.2012, 4.3281, 270.1193);
						return 1;
					}

				} else
				{
					if(listitem == 0)
					{
						SetPlayerPos(playerid, 2644.3606, -2004.1403, 13.3828);
						return 1;
					}
					if(listitem == 1)
					{
						SetPlayerPos(playerid, 2408.4683, 1036.2778, 10.8203);
						return 1;
					}
					if(listitem == 2)
					{
						SetPlayerPos(playerid, -2713.6375, 224.2012, 4.3281);
						return 1;
					}
				}
			}
		}
        case DIALOG_REGISTER:
        {
            if (!response) return Kick(playerid);
            if(response)
            {
                if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, ""#COL_ORANGE":: "#COL_WHITE"Register" , "\t\t"#COL_LBLUE"ShuffRoam Indev \n\n"#COL_RED"You have entered a invalid password\n"#COL_WHITE"You are not registered, \nPlease enter a password below to register your account!", "Register", "Exit");
                new INI:File = INI_Open(UserPath(playerid));
                INI_SetTag(File,"data");
                INI_WriteInt(File,"Password",udb_hash(inputtext));
                INI_WriteInt(File,"Cash",0);
                INI_WriteInt(File,"Kills",0);
                INI_WriteInt(File,"Deaths",0);
				INI_WriteInt(File,"Skin",256);
				INI_WriteInt(File,"Cookies",0);
				INI_WriteFloat(File,"Speedboost", 1.3);
            	INI_WriteInt(File,"Adminlevel",0);
                INI_Close(File);
				/*INI_Int("Model",AOInfo[playerid][Model]);
	INI_Int("ID", AOInfo[playerid][Model]);
    INI_Float("X",AOInfo[playerid][oX]);
    INI_Float("rX",AOInfo[playerid][rX]);
    INI_Float("Y",AOInfo[playerid][oY]);
	INI_Float("rY",AOInfo[playerid][rY]);
	INI_Float("Z",AOInfo[playerid][oZ]);
	INI_Float("rZ",AOInfo[playerid][rZ]); */
				new INI:File2 = INI_Open(UserAOPath(playerid));
				INI_SetTag(File,"1 AttachedObject");
                INI_WriteInt(File2,"Model", 0);
                INI_WriteInt(File2, "ID", 0);
				INI_WriteFloat(File2, "X", 0);
				INI_WriteFloat(File2, "rX", 0);
				INI_WriteFloat(File2, "Y", 0);
				INI_WriteFloat(File2, "rY", 0);
				INI_WriteFloat(File2, "Z", 0);
				INI_WriteFloat(File2, "rZ", 0);
				INI_SetTag(File,"2 AttachedObject");
				INI_WriteInt(File2,"Model2", 0);
                INI_WriteInt(File2, "ID2", 0);
				INI_WriteFloat(File2, "X2", 0);
				INI_WriteFloat(File2, "rX2", 0);
				INI_WriteFloat(File2, "Y2", 0);
				INI_WriteFloat(File2, "rY2", 0);
				INI_WriteFloat(File2, "Z2", 0);
				INI_WriteFloat(File2, "rZ2", 0);
				INI_SetTag(File,"3 AttachedObject");
				INI_WriteInt(File2,"Model3", 0);
                INI_WriteInt(File2, "ID3", 0);
				INI_WriteFloat(File2, "X3", 0);
				INI_WriteFloat(File2, "rX3", 0);
				INI_WriteFloat(File2, "Y3", 0);
				INI_WriteFloat(File2, "rY3", 0);
				INI_WriteFloat(File2, "Z3", 0);
				INI_WriteFloat(File2, "rZ3", 0);
				INI_SetTag(File,"4 AttachedObject");
				INI_WriteInt(File2,"Model4", 0);
                INI_WriteInt(File2, "ID4", 0);
				INI_WriteFloat(File2, "X4", 0);
				INI_WriteFloat(File2, "rX4", 0);
				INI_WriteFloat(File2, "Y4", 0);
				INI_WriteFloat(File2, "rY4", 0);
				INI_WriteFloat(File2, "Z4", 0);
				INI_WriteFloat(File2, "rZ4", 0);
				INI_SetTag(File,"5 AttachedObject");
				INI_WriteInt(File2,"Model5", 0);
                INI_WriteInt(File2, "ID5", 0);
				INI_WriteFloat(File2, "X5", 0);
				INI_WriteFloat(File2, "rX5", 0);
				INI_WriteFloat(File2, "Y5", 0);
				INI_WriteFloat(File2, "rY5", 0);
				INI_WriteFloat(File2, "Z5", 0);
				INI_WriteFloat(File2, "rZ5", 0);
                INI_Close(File2);

                SetSpawnInfo(playerid, 256, 0, 1958.33, 1343.12, 15.36, 269.15, 0, 0, 0, 0, 0, 0);
                SpawnPlayer(playerid);
            }
        }
        case DIALOG_LOGIN:
        {
            if ( !response ) return Kick ( playerid );
            if( response )
            {
                if(udb_hash(inputtext) == PlayerInfo[playerid][Password])
                {
                    INI_ParseFile(UserPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
					INI_ParseFile(UserAOPath(playerid), "LoadAO_%s", .bExtra = true, .extra = playerid);
                    GivePlayerMoney(playerid, PlayerInfo[playerid][Cash]);
					SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
					/*INI_Int("Model",AOInfo[playerid][Model]);
	INI_Int("ID", AOInfo[playerid][Model]);
    INI_Float("X",AOInfo[playerid][oX]);
    INI_Float("rX",AOInfo[playerid][rX]);
    INI_Float("Y",AOInfo[playerid][oY]);
	INI_Float("rY",AOInfo[playerid][rY]);
	INI_Float("Z",AOInfo[playerid][oZ]);
	INI_Float("rZ",AOInfo[playerid][rZ]); */
					new thebone;
					if(AOInfo[playerid][Model] == 19101) { thebone = 2; }
					else if(AOInfo[playerid][Model] == 19086) { thebone = 5; }
					if(AOInfo[playerid][Model] != 0)
					{
						item1 = SetPlayerAttachedObject(playerid, AOInfo[playerid][ID], AOInfo[playerid][Model], thebone, AOInfo[playerid][oX], AOInfo[playerid][oY], AOInfo[playerid][oZ], AOInfo[playerid][rX], AOInfo[playerid][rY], AOInfo[playerid][rZ]);	
					}
					SendClientMessage(playerid, COLOR_WHITE, "You have successfully logged in!");
					SendClientMessage(playerid, COLOR_WHITE, "Click "#COL_LBLUE"SPAWN"#COL_WHITE" to spawn!");
                }
                else
                {
                    ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,""#COL_ORANGE":: "#COL_WHITE"Login", "\t\t"#COL_LBLUE"ShuffRoam Indev \n\n"#COL_RED"You have entered a invalid password\n"#COL_WHITE"Welcome back, \nPlease enter your password below to start the game!", "Login", "Exit");
                }
                return 1;
            }
        }
    }
    return 1;
}
public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
    if(response)
    {
        SendClientMessage(playerid, COLOR_GREEN, "[INFO:] Attached object position saved!");
 
        AOInfo[playerid][oX] = fOffsetX;
        AOInfo[playerid][oY] = fOffsetY;
        AOInfo[playerid][oZ] = fOffsetZ;
        AOInfo[playerid][rX] = fRotX;
        AOInfo[playerid][rY] = fRotY;
        AOInfo[playerid][rZ] = fRotZ;
    }
    else
    {
        SendClientMessage(playerid, COLOR_RED, "Attached object edition not saved.");
        SetPlayerAttachedObject(playerid, item1, AOInfo[playerid][Model], 2, AOInfo[playerid][oX], AOInfo[playerid][oY], AOInfo[playerid][oZ], AOInfo[playerid][rX], AOInfo[playerid][rY], AOInfo[playerid][rZ]);
    }
    return 1;
}
public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

//-----[LoadUser Data]-----
forward LoadUser_data(playerid,name[],value[]);
public LoadUser_data(playerid,name[],value[])
{
    INI_Int("Password",PlayerInfo[playerid][Password]);
    INI_Int("Cash",PlayerInfo[playerid][Cash]);
    INI_Int("Kills",PlayerInfo[playerid][Kills]);
    INI_Int("Deaths",PlayerInfo[playerid][Deaths]);
	INI_Int("Skin",PlayerInfo[playerid][Skin]);
	INI_Int("Cookies",PlayerInfo[playerid][Cookies]);
	INI_Float("Speedboost",PlayerInfo[playerid][Speedboost]);
    INI_Int("Adminlevel",PlayerInfo[playerid][Adminlevel]);
    return 1;
}

//-----[AO Data]-----
forward LoadAO_data(playerid,name[],value[]);
public LoadAO_data(playerid,name[],value[])
{
    INI_Int("Model",AOInfo[playerid][Model]);
	INI_Int("ID", AOInfo[playerid][ID]);
    INI_Float("X",AOInfo[playerid][oX]);
    INI_Float("rX",AOInfo[playerid][rX]);
    INI_Float("Y",AOInfo[playerid][oY]);
	INI_Float("rY",AOInfo[playerid][rY]);
	INI_Float("Z",AOInfo[playerid][oZ]);
	INI_Float("rZ",AOInfo[playerid][rZ]);
	// second
	INI_Int("Model2",AOInfo[playerid][Model2]);
	INI_Int("ID2", AOInfo[playerid][ID2]);
    INI_Float("X2",AOInfo[playerid][oX2]);
    INI_Float("rX2",AOInfo[playerid][rX2]);
    INI_Float("Y2",AOInfo[playerid][oY2]);
	INI_Float("rY2",AOInfo[playerid][rY2]);
	INI_Float("Z2",AOInfo[playerid][oZ2]);
	INI_Float("rZ2",AOInfo[playerid][rZ2]);
	// third
	INI_Int("Model3",AOInfo[playerid][Model3]);
	INI_Int("ID3", AOInfo[playerid][ID3]);
    INI_Float("X3",AOInfo[playerid][oX3]);
    INI_Float("rX3",AOInfo[playerid][rX3]);
    INI_Float("Y3",AOInfo[playerid][oY3]);
	INI_Float("rY3",AOInfo[playerid][rY3]);
	INI_Float("Z3",AOInfo[playerid][oZ3]);
	INI_Float("rZ3",AOInfo[playerid][rZ3]);
	// fourth
	INI_Int("Model4",AOInfo[playerid][Model4]);
	INI_Int("ID4", AOInfo[playerid][ID4]);
    INI_Float("X4",AOInfo[playerid][oX4]);
    INI_Float("rX4",AOInfo[playerid][rX4]);
    INI_Float("Y4",AOInfo[playerid][oY4]);
	INI_Float("rY4",AOInfo[playerid][rY4]);
	INI_Float("Z4",AOInfo[playerid][oZ4]);
	INI_Float("rZ4",AOInfo[playerid][rZ4]);
	// fifth
	INI_Int("Model5",AOInfo[playerid][Model5]);
	INI_Int("ID5", AOInfo[playerid][ID5]);
    INI_Float("X5",AOInfo[playerid][oX5]);
    INI_Float("rX5",AOInfo[playerid][rX5]);
    INI_Float("Y5",AOInfo[playerid][oY5]);
	INI_Float("rY5",AOInfo[playerid][rY5]);
	INI_Float("Z5",AOInfo[playerid][oZ5]);
	INI_Float("rZ5",AOInfo[playerid][rZ5]);
    return 1;
}
stock UserPath(playerid)
{
    new string[128],playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),PATH,playername);
    return string;
}
stock UserAOPath(playerid)
{
    new string[128],playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),AOPATH,playername);
    return string;
}


stock udb_hash(buf[]) {
    new length=strlen(buf);
    new s1 = 1;
    new s2 = 0;
    new n;
    for (n=0; n<length; n++) // dracoblue ftw!
    {
       s1 = (s1 + buf[n]) % 65521;
       s2 = (s2 + s1)     % 65521;
    }
    return (s2 << 16) + s1;
}

//-----[INV Explosion]-----
forward Explosion(playerid, adminid);
public Explosion(playerid, adminid) {
    if(checkinv == 1)
    {
        new Float:health;
        GetPlayerHealth(playerid,health);
        if(health == 100)
        {
            SendClientMessage(adminid,COLOR_YELLOW,"Invulnerability check result : [POSITIVE]");
            checkinv = 0;
        }
        else if(health != 100)
        {
            SendClientMessage(adminid,COLOR_YELLOW,"Invulnerability check result : [NEGATIVE]");
            checkinv = 0;
        }
    }
    return 1;
}

//-----[Removing underscore]-----
stock GetPlayerRame( giveplayer, name[ ], len )
{
    GetPlayerRame( giveplayer, name, len );
    for(new i = 0; i < len; i++ )
    {
        if ( name[ i ] == '_' )
        name[ i ] = ' ';
    }
}

//-----[Unfreeze LMS]-----
//-----[Unfreezeplayer]-----
forward UnfreezeLMS(playerid);
public UnfreezeLMS(playerid)
{
	foreach(Player, i)
	{
		if(pInEvent[i] == 1)
		{
			if(g_EventOpen == 1)
			{
				TogglePlayerControllable(i, 1);
				GameTextForPlayer(i, "~r~Be the Last Man Standing!", 2000, 3);
			}
		}
	}
	return 1;
}

// attached objects
CMD:aob(playerid, params[])
{
	new string[256];
	format(string, sizeof(string), ""#COL_WHITE"Slot: 1 || Item name: %s\nSlot: 2 || Item name: ", GetAOName1(playerid));
	ShowPlayerDialog(playerid, DIALOG_AOB, DIALOG_STYLE_LIST, ""#COL_LBLUE"Attached Object Editor", string, "EDIT", "EXIT");
	return 1;
}


//=================================
//           Teleports
//=================================
CMD:teles(playerid, params[])
{
	SendClientMessage(playerid, COLOR_WHITE, ""#COL_LBLUE"|| /chilliad || /drift1-4 || /basejump || /chilliad || /aa || /jiggy || /lsair ||");
	return 1;
}
CMD:lsair(playerid, params[])
{
	SetPlayerInterior(playerid, 0);
	if(IsPlayerInAnyVehicle(playerid))
	{
		SetVehiclePos(GetPlayerVehicleID(playerid),2119.0869, -2616.2554, 13.5469);
		SetVehicleZAngle(GetPlayerVehicleID(playerid),353.8925);
	} else
	{
		SetPlayerPos(playerid,2119.0869, -2616.2554, 13.5469);
		SetPlayerFacingAngle(playerid,353.8925);
	}
	return 1;
}
CMD:jiggy(playerid, params[])
{
	SetPlayerInterior(playerid, 0);
	if(IsPlayerInAnyVehicle(playerid))
	{
		SetVehiclePos(GetPlayerVehicleID(playerid),-2620.0549,1414.5328,7.0938);
		SetVehicleZAngle(GetPlayerVehicleID(playerid),0.0);
	} else
	{
		SetPlayerPos(playerid,-2620.0549,1414.5328,7.0938);
		SetPlayerFacingAngle(playerid,0.0);
	}
	return 1;
}
CMD:aa(playerid, params[])
{
	SetPlayerInterior(playerid, 0);
	if(IsPlayerInAnyVehicle(playerid))
	{
		SetVehiclePos(GetPlayerVehicleID(playerid),403.6374,2447.7241,16.5000);
		SetVehicleZAngle(GetPlayerVehicleID(playerid),0.0);
	} else
	{
		SetPlayerPos(playerid,403.6374,2447.7241,16.5000);
		SetPlayerFacingAngle(playerid,0.0);
	}
	return 1;
}
CMD:basejump(playerid, params[])
{
	SetPlayerInterior(playerid, 0);
	GivePlayerWeapon(playerid, 46, 1);
	SetPlayerPos(playerid, -2662.5652,1933.9298,225.7578);
	SendClientMessage(playerid, COLOR_WHITE,"[INFO:] Teleported to the "#COL_LBLUE"basejump area");
	SetPlayerInterior(playerid,0);
	return 1;
}
CMD:chilliad(playerid, params[])
{
	SetPlayerInterior(playerid, 0);
	if(IsPlayerInAnyVehicle(playerid))
	{
		SetVehiclePos(GetPlayerVehicleID(playerid),-2327.3235,-1639.4313,483.7031);
		SetVehicleZAngle(GetPlayerVehicleID(playerid),0.0);
	} else
	{
		SetPlayerPos(playerid,-2327.3235,-1639.4313,483.7031);
		SetPlayerFacingAngle(playerid,0.0);
	}
	return 1;
}
CMD:drift(playerid, params[])
{
	SetPlayerInterior(playerid, 0);
	if(IsPlayerInAnyVehicle(playerid))
	{
		SetVehiclePos(GetPlayerVehicleID(playerid),-295.5432,1543.2266,75.5625);
		SetVehicleZAngle(GetPlayerVehicleID(playerid),0.0);
	} else
	{
		SetPlayerPos(playerid,-295.5432,1543.2266,75.5625);
		SetPlayerFacingAngle(playerid,0.0);
	}
	return 1;
}
CMD:drift2(playerid, params[])
{
	SetPlayerInterior(playerid, 0);
	if(IsPlayerInAnyVehicle(playerid))
	{
		SetVehiclePos(GetPlayerVehicleID(playerid),-2539.2822,-596.3240,132.7109);
		SetVehicleZAngle(GetPlayerVehicleID(playerid),0.0);
	} else
	{
		SetPlayerPos(playerid,-2539.2822,-596.3240,132.7109);
		SetPlayerFacingAngle(playerid,0.0);
	}
	return 1;
}
CMD:drift3(playerid, params[])
{
	SetPlayerInterior(playerid, 0);
	if(IsPlayerInAnyVehicle(playerid))
	{
		SetVehiclePos(GetPlayerVehicleID(playerid),2222.9109,1965.0009,31.7797);
		SetVehicleZAngle(GetPlayerVehicleID(playerid),0.0);
	} else
	{
		SetPlayerPos(playerid,2222.9109,1965.0009,31.7797);
		SetPlayerFacingAngle(playerid,0.0);
	}
	return 1;
}
CMD:drift4(playerid, params[])
{
	SetPlayerInterior(playerid, 0);
	if(IsPlayerInAnyVehicle(playerid))
	{
		SetVehiclePos(GetPlayerVehicleID(playerid),2325.2664,1392.3447,42.8203);
		SetVehicleZAngle(GetPlayerVehicleID(playerid),0.0);
	} else
	{
		SetPlayerPos(playerid,2325.2664,1392.3447,42.8203);
		SetPlayerFacingAngle(playerid,0.0);
	}
	return 1;
}

//=================================
//        Normal commands
//=================================

CMD:stats(playerid, params[])
{
	new string[256], string2[100], name[16];
	GetPlayerName(playerid, name, sizeof(name));
	format(string, sizeof(string), "---------| "#COL_LBLUE"%s ID[%d]"#COL_WHITE" |----------", name, playerid);
    SendClientMessage(playerid, COLOR_WHITE, string);
	SendClientMessage(playerid, COLOR_WHITE, " ");
	format(string2, sizeof(string2), "Money: [$%d] | Cookies: [%d]", GetPlayerMoney(playerid), PlayerInfo[playerid][Cookies]);
    SendClientMessage(playerid, COLOR_WHITE, string2);
	return 1;
}

CMD:tune(playerid, params[])
{
	ShowPlayerDialog(playerid, DIALOG_TUNE, DIALOG_STYLE_LIST, ""#COL_LBLUE"Tuning Locations", ""#COL_WHITE"Loco Low Co\nTransfender\nWheel Arch Angel", "Choose", "Close");
	return 1;
}

CMD:commands(playerid, params[])
{
	SendClientMessage(playerid,COLOR_WHITE, ".:: Commands ::.");
	SendClientMessage(playerid,COLOR_WHITE, "/pm - /rules - /kill");
	return 1;
}
CMD:kill(playerid, params[])
{
	SetPlayerHealth(playerid, 0.0);
	SendClientMessage(playerid, COLOR_RED, ""#COL_LGREEN"[INFO]"#COL_SBLUE" You committed a suicide!");
	return 1;
}
COMMAND:pm(playerid, params[])
{
    new str[128],id,pname[MAX_PLAYER_NAME], Message[128];
    if(sscanf(params, "ds[128]", id, Message))SendClientMessage(playerid, COLOR_WHITE, "[SYNTAX:] / [PlayerID/PartOfName] [Message]");
    else if(id == INVALID_PLAYER_ID) SendClientMessage(playerid, COLOR_WHITE, ""#COL_ORANGE"[ERROR]"#COL_LRED" Player not connected!");
    else
    {
        GetPlayerName(id, str, 24);
        format(str, sizeof(str), "PM To %s(%d): %s", str, id, Message);
        GetPlayerName(id, str, 24);
        format(str, sizeof(str), "PM To %s(%d): %s", str, id, Message);
        SendClientMessage(playerid, COLOR_RED, str);
        GetPlayerName(playerid, pname, sizeof(pname));
        format(str, sizeof(str), "PM From %s(%d): %s", pname, playerid, Message);
        SendClientMessage(id, COLOR_RED, str);
    }
    return 1;
}
CMD:veh(playerid, params[])
{
	/*if(mycar[playerid] >= 0) DestroyVehicle(mycar[playerid]);
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	mycar[playerid] = CreateVehicle(411, x, y, z, 0, 1, 1, 60);
	PutPlayerInVehicle(playerid, mycar[playerid], 0);
    SendClientMessage(playerid, COLOR_WHITE, "Spawned an Infernus and put your ass in it. "#COL_LBLUE"Have fun!");*/
	ShowPlayerDialog(playerid, DIAV, DIALOG_STYLE_LIST, "{0094FF}Vehicles",""#COL_WHITE"Sports\n"#COL_WHITE"Tuneables and elegants\n"#COL_WHITE"Motorcycles and bicycles\n"#COL_WHITE"SUV\n"#COL_WHITE"Planes\n"#COL_WHITE"Helicopters\n"#COL_WHITE"Aquatic\n"#COL_WHITE"Public Service\n"#COL_WHITE"Industrials\n"#COL_WHITE"Saloon\n"#COL_WHITE"Trucks\n"#COL_WHITE"Loads\n"#COL_WHITE"Unique Vehicles\n"#COL_WHITE"RC Vehicles",">>","X");
    return 1;
}

CMD:admins(playerid, params[])
{
	new string[126], name[16], rankname[16];
	SendClientMessage(playerid, COLOR_WHITE, "----| Currently online administrators |----");
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		if(PlayerInfo[i][Adminlevel] > 0)
		{
			GetPlayerName(i, name, sizeof(name));
			if(PlayerInfo[i][Adminlevel] == 1) { rankname = "Moderator"; }
			else if(PlayerInfo[i][Adminlevel] == 2) { rankname = "Lead Moderator"; }
			else if(PlayerInfo[i][Adminlevel] == 3) { rankname = "Administrator"; }
			else if(PlayerInfo[i][Adminlevel] == 4) { rankname = "Co-Owner"; }
			else if(PlayerInfo[i][Adminlevel] == 5) { rankname = "Owner"; }
			format(string, sizeof(string), ""#COL_LBLUE"%s "#COL_WHITE"|| "#COL_LBLUE"%s [ID: %d]", rankname, name, i);
			SendClientMessage(playerid, COLOR_WHITE, string);
		}
	}
	return 1;
}
CMD:ah(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] == 0) return SendClientMessage(playerid,COLOR_WHITE,".:: You are not authorized to use this command ::.");

	SendClientMessage(playerid,COLOR_WHITE, ""#COL_DGREEN"===============[ "#COL_WHITE"Administrator Commands"#COL_DGREEN" ]===============");

	if(PlayerInfo[playerid][Adminlevel] < 0)
	{
		SendClientMessage(playerid,COLOR_WHITE, ""#COL_ORANGE"> "#COL_DGREEN"Administrator (1):"#COL_WHITE" /kick - /ban - /slap - /explode - /apm - /inv - /gmx - /freeze - /freezeall");
		SendClientMessage(playerid,COLOR_WHITE, ""#COL_ORANGE"> "#COL_DGREEN"Administrator (1):"#COL_WHITE" /adminduty - /jetpack - /goto - /gethere - /respawn");
	}
	else if(PlayerInfo[playerid][Adminlevel] < 1)
	{
		SendClientMessage(playerid, COLOR_WHITE, "Yes, level 2");
	}
	return 1;
}

CMD:para(playerid, params[])
{
	GivePlayerWeapon(playerid,46,1);
	SendClientMessage(playerid, COLOR_WHITE, "[INFO:] You got a parachute!");
	return 1;
}
CMD:slap(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 1) return SendClientMessage(playerid,COLOR_WHITE,".:: You are not authorized to use this command ::.");
	new targetid;
	if(sscanf(params, "d", targetid)) return SendClientMessage(playerid, COLOR_WHITE, "[SYNTAX:] / [PlayerID/PartOfName]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, ""#COL_ORANGE"[ERROR]"#COL_LRED" Player not connected!");
	else
	{
		new Float:SLX, Float:SLY, Float:SLZ;
		GetPlayerPos(targetid, SLX, SLY, SLZ);
		SetPlayerPos(targetid, SLX, SLY, SLZ+5);
		new string[128];
		new pName[24], pTame[24];
		GetPlayerName(playerid,pName,24);
		GetPlayerName(targetid,pTame,24);
		format(string,sizeof string,""#COL_ORANGE"[SERVER]"#COL_LRED" %s has been slapped by the awesome %s.",pTame,pName);
		SendClientMessageToAll(COLOR_RED, string);
  	}
	return 1;
}
CMD:givecookie(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 2) return SendClientMessage(playerid,COLOR_WHITE,".:: You are not authorized to use this command ::.");
	new targetid, reason;
	if(sscanf(params, "di", targetid, reason)) return SendClientMessage(playerid, COLOR_WHITE, "[SYNTAX:] /givecookie [PlayerID/PartOfName] [Amount]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, ""#COL_ORANGE"[ERROR]"#COL_LRED" Player not connected!");
	{
		new pTargetName[24], pName[24], string[256], oldcookies, newcookies;
		GetPlayerName(playerid,pName,24);
		GetPlayerName(targetid,pTargetName,24);
		if(reason == 0) return SendClientMessage(playerid, COLOR_WHITE, "[INFO:] You cannot give 0 cookies! Idiot.");
		if(reason == 1)
		{
			format(string, sizeof(string), ""#COL_LBLUE"[SERVER:]"#COL_WHITE" Admin %s has given %s 1 cookie!", pName, pTargetName, reason);
		} else { format(string, sizeof(string), ""#COL_LBLUE"[SERVER:]"#COL_WHITE" Admin %s has given %s %d cookies!", pName, pTargetName, reason); }
		oldcookies = PlayerInfo[targetid][Cookies];
		newcookies = oldcookies + reason;
		PlayerInfo[targetid][Cookies] = newcookies;
		SendClientMessageToAll(COLOR_WHITE, string);
	}
	return 1;
}
CMD:resetcookies(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 2) return SendClientMessage(playerid,COLOR_WHITE,".:: You are not authorized to use this command ::.");
	new targetid;
	if(sscanf(params, "d", targetid)) return SendClientMessage(playerid, COLOR_WHITE, "[SYNTAX:] /resetcookies [PlayerID/PartOfName]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, ""#COL_ORANGE"[ERROR]"#COL_LRED" Player not connected!");
	{
		new pTargetName[24], pName[24], string[256], string2[256];
		GetPlayerName(playerid,pName,24);
		GetPlayerName(targetid,pTargetName,24);
		format(string, sizeof(string), ""#COL_LBLUE"[SERVER:]"#COL_WHITE" You have reset the cookies of %s!", pTargetName);
		format(string2, sizeof(string2), ""#COL_LBLUE"[SERVER:]"#COL_WHITE" %s has reset your cookies!", pName);
		PlayerInfo[targetid][Cookies] = 0;
		SendClientMessage(playerid, COLOR_WHITE, string);
		SendClientMessage(targetid, COLOR_WHITE, string2);
	}
	return 1;
}
CMD:mycookies(playerid, params[])
{
	new string[256];
	format(string, sizeof(string), ""#COL_LBLUE"[INFO:]"#COL_WHITE" You have %d cookies", PlayerInfo[playerid][Cookies]);
	SendClientMessage(playerid, COLOR_WHITE, string);
	return 1;
}
CMD:kick(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 1) return SendClientMessage(playerid,COLOR_WHITE,".:: You are not authorized to use this command ::.");
	new targetid, reason[64], string[128];
	if(sscanf(params, "dz", targetid, reason)) return SendClientMessage(playerid, COLOR_WHITE, "[SYNTAX:] / [PlayerID/PartOfName] [Reason]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, ""#COL_ORANGE"[ERROR]"#COL_LRED" Player not connected!");
	{
	new pTargetName[24], pName[24];
	GetPlayerName(playerid,pName,24);
	GetPlayerName(targetid,pTargetName,24);
	format(string, sizeof(string), ""#COL_ORANGE"[SERVER]"#COL_LRED" Admin %s has kicked %s: %s", pName, pTargetName, reason);
	SendClientMessageToAll(COLOR_RED,string);
	Kick(targetid);
	}
	return 1;
}
CMD:gmx(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 1) return SendClientMessage(playerid,COLOR_WHITE,".:: You are not authorized to use this command ::.");
	{
	new string[256];
	new pName[24];
	GetPlayerName(playerid,pName,24);
	format(string,sizeof string,""#COL_ORANGE"[SERVER]"#COL_LRED" Administrator %s has created a server restart.",pName);

 	new INI:File = INI_Open(UserPath(playerid));
    INI_SetTag(File,"data");
    INI_WriteInt(File,"Cash",GetPlayerMoney(playerid));
    INI_WriteInt(File,"Kills",PlayerInfo[playerid][Kills]);
    INI_WriteInt(File,"Deaths",PlayerInfo[playerid][Deaths]);
    INI_WriteInt(File,"Adminlevel",PlayerInfo[playerid][Adminlevel]);
    INI_Close(File);

	SendClientMessageToAll(COLOR_RED, string);
	GameTextForAll("Server Restarting",3000,0);
	SetTimer("Gmx",3000,false);
	SendRconCommand("gmx");
	}
	return 1;
}
CMD:ban(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 1) return SendClientMessage(playerid,COLOR_WHITE,".:: You are not authorized to use this command ::.");
	new targetid, reason[64], string[128];
	if(sscanf(params, "dz", targetid, reason)) return SendClientMessage(playerid, COLOR_WHITE, "[SYNTAX:] / [PlayerID/PartOfName] [Reason]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, ""#COL_ORANGE"[ERROR]"#COL_LRED" Player not connected!");
	{
		new pTargetName[24], pName[24];
		GetPlayerName(playerid,pName,24);
		GetPlayerName(targetid,pTargetName,24);
		format(string, sizeof(string), ""#COL_ORANGE"[SERVER]"#COL_LRED" Admin %s has IP banned %s: %s", pName,  pTargetName, reason);
		SendClientMessageToAll(COLOR_RED,string);
		Ban(targetid);
	}
	return 1;
}
CMD:explode(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 1) return SendClientMessage(playerid,COLOR_WHITE,".:: You are not authorized to use this command ::.");
	new targetid;
	if(sscanf(params, "d", targetid)) return SendClientMessage(playerid, COLOR_WHITE, "[SYNTAX:] /explode [PlayerID/PartOfName]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, ""#COL_ORANGE"[ERROR]"#COL_LRED" Player not connected!");
	else
	{
	new Float:SLX, Float:SLY, Float:SLZ;
	GetPlayerPos(targetid, SLX, SLY,SLZ);
	CreateExplosion(SLX, SLY, SLZ, 11, 0.25);
	new string[128];
	new pName[24], pTame[24];
	GetPlayerName(playerid,pName,24);
	GetPlayerName(targetid,pTame,24);
	format(string,sizeof string,""#COL_ORANGE"[SERVER]"#COL_LRED" %s has been exploded by Administrator %s.",pTame,pName);
	SendClientMessageToAll(COLOR_RED, string);
	}
	return 1;
}

//-----[INV]-----
CMD:inv(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 1) return SendClientMessage(playerid,COLOR_WHITE,".:: You are not authorized to use this command ::.");
	new targetid;
	if(sscanf(params, "dz", targetid)) return SendClientMessage(playerid, COLOR_WHITE, "[SYNTAX:] /inv [PlayerID/PartOfName]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, ""#COL_ORANGE"[ERROR]"#COL_LRED" Player not connected!");
	else
	{
		if(IsPlayerInAnyVehicle(targetid) == 1)
		{
			RemovePlayerFromVehicle(targetid);
		}
		TogglePlayerControllable(targetid, 1);
		SetPlayerArmour(targetid,0);
		SetPlayerHealth(targetid,100);
		checkinv = 1;
		new Float:x,Float:y,Float:z;
		GetPlayerPos(targetid,x,y,z);
		CreateExplosion(x, y, z, 12, 2.0);
		SetTimerEx("Explosion",500,0,"ii", targetid, playerid);
		SetPlayerArmour(targetid,99);
		SetPlayerHealth(targetid,99);
	}
	return 1;
}

//-----[Admin PM]-----
COMMAND:apm(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 1) return SendClientMessage(playerid,COLOR_WHITE,".:: You are not authorized to use this command ::.");
    new str[128],id,pname[MAX_PLAYER_NAME], Message[128];
    if(sscanf(params, "ds[128]", id, Message))SendClientMessage(playerid, COLOR_WHITE, "[SYNTAX:] /apm [PlayerID/PartOfName] [Message]");
    else if(id == INVALID_PLAYER_ID) SendClientMessage(playerid, COLOR_WHITE, ""#COL_ORANGE"[ERROR]"#COL_LRED" Player not connected!");
    else
    {
        GetPlayerName(id, str, 24);
        format(str, sizeof(str), "[ADMIN] %s(%d): %s", str, id, Message);
        GetPlayerName(id, str, 24);
        format(str, sizeof(str), "[ADMIN] %s(%d): %s", str, id, Message);
        SendClientMessage(playerid, COLOR_YELLOW, str);
        GetPlayerName(playerid, pname, sizeof(pname));
        format(str, sizeof(str), "[ADMIN] %s(%d): %s", pname, playerid, Message);
        SendClientMessage(id, COLOR_YELLOW, str);
    }
    return 1;
}
CMD:giveallmoney(playerid, params[])
{
	new name[21], value, string[100];
	GetPlayerName(playerid, name, sizeof(name));
	if(PlayerInfo[playerid][Adminlevel] < 3) return SendClientMessage(playerid, 0xFF0000AA, ".:: You are not authorized to use this command ::.");
    else if (sscanf(params, "d", value)) return SendClientMessage(playerid, COLOR_WHITE, "[SYNTAX:] /giveallmoney [amount]");
	else if(value >= 400000) return SendClientMessage(playerid, COLOR_WHITE, "Not that much!");
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		format( string, sizeof(string), "~g~%s has given everyone $%d Yay!", name, value);
		GameTextForAll( string, 5000, 5 );
		GivePlayerMoney(i, value);
	}
	return 1;
}
CMD:makeadmin(playerid, params[])
{
    new pID, value;
    if(!IsPlayerAdmin(playerid) || PlayerInfo[playerid][Adminlevel] != 5) return SendClientMessage(playerid, 0xFF0000AA, ".:: You are not authorized to use this command ::.");
    else if (sscanf(params, "di", pID, value)) return SendClientMessage(playerid, 0xFF0000AA, "[SYNTAX:] /makeadmin [playerid/partofname] [level 1-1338]");
    else if (value < 1 || value > 5) return SendClientMessage(playerid, 0xFF0000AA, "[INFO:] Wrong level! Legit numbers are only from 1 to 5.");
    if(IsPlayerConnected(pID)) {
    if(pID == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GREY,"Invalid player id");
    {
        new pName[MAX_PLAYER_NAME], tName[MAX_PLAYER_NAME], string[128];
        GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
        GetPlayerName(pID, tName, MAX_PLAYER_NAME);
        format(string, sizeof(string), "You have promoted %s to Admin level %i", tName, value);
        SendClientMessage(playerid, COLOR_WHITE, string);
        format(string, sizeof(string), "You have been promoted to Admin level %i by %s", value, pName);
        SendClientMessage(pID, COLOR_WHITE, string);
        PlayerInfo[pID][Adminlevel] = value;
    } }
    return 1;
}
CMD:skin(playerid, params[])
{
    new skinid, string[256];
    if(sscanf(params, "i", skinid)) return SendClientMessage(playerid, COLOR_WHITE, ""#COL_DGREY"[CMD] /skin "#COL_SGREY"[ID]");
    else if(skinid <= 0 || skinid >= 257) return SendClientMessage(playerid, COLOR_WHITE, "Invalid ID");
    else
	{
		PlayerInfo[playerid][Skin] = skinid;
		SetPlayerSkin(playerid, skinid);
		format(string, sizeof(string), "[INFO:] You have set your skin to "#COL_LBLUE"%d", PlayerInfo[playerid][Skin]);
		SendClientMessage(playerid, COLOR_WHITE, string);
    }
    return 1;
}
CMD:freeze(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 1) return SendClientMessage(playerid,COLOR_WHITE,".:: You are not authorized to use this command ::.");
	new targetid, string[128];
	if(sscanf(params, "d", targetid)) return SendClientMessage(playerid, COLOR_WHITE, "[SYNTAX:] /freeze [PlayerID/PartOfName]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, ""#COL_ORANGE"[ERROR]"#COL_LRED" Player not connected!");
	new pTargetName[24], pName[24];
	GetPlayerName(playerid,pName,24);
	GetPlayerName(targetid,pTargetName,24);
	format(string, sizeof(string), ""#COL_ORANGE"[SERVER]"#COL_LRED" %s has been frozen by Administrator %s.",pTargetName, pName);
	SendClientMessageToAll(COLOR_RED,string);
	TogglePlayerControllable(targetid, 0);
	return 1;
}
CMD:unfreeze(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 1) return SendClientMessage(playerid,COLOR_WHITE,".:: You are not authorized to use this command ::.");
	new targetid, string[128];
	if(sscanf(params, "d", targetid)) return SendClientMessage(playerid, COLOR_WHITE, "[SYNTAX:] /unfreeze [PlayerID/PartOfName]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, ""#COL_ORANGE"[ERROR]"#COL_LRED" Player not connected!");
	new pTargetName[24], pName[24];
	GetPlayerName(playerid,pName,24);
	GetPlayerName(targetid,pTargetName,24);
	format(string, sizeof(string), ""#COL_ORANGE"[SERVER]"#COL_LRED" %s has been unfrozen by Administrator %s.",pTargetName, pName);
	SendClientMessageToAll(COLOR_RED,string);
	TogglePlayerControllable(targetid, 1);
	return 1;
}
CMD:adminduty(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 1) return SendClientMessage(playerid,COLOR_WHITE,".:: You are not authorized to use this command ::.");
    if( AdminDuty[ playerid ] == 0 )
    {
        AdminDuty[ playerid ] = 1;
        Admin[ playerid ] = Create3DTextLabel("ADMIN DUTY",0x5CD6CAFF,30.0,40.0,50.0,10.0,0);
        Attach3DTextLabelToPlayer( Admin[ playerid ], playerid, 0.0, 0.0, 0.3);
		new string[128];
  		new pName[24], pTame[24];
  		GetPlayerName(playerid,pName,24);
  		format(string,sizeof string,""#COL_ORANGE"[SERVER]"#COL_LRED" Administrator %s is on Admin Duty.",pName,pTame);
		SendClientMessageToAll(COLOR_WHITE, string);
    }
    else
    {
        AdminDuty[ playerid ] = 0;
        Delete3DTextLabel( Admin[ playerid ] );
		new string[128];
  		new pName[24], pTame[24];
  		GetPlayerName(playerid,pName,24);
  		format(string,sizeof string,""#COL_ORANGE"[SERVER]"#COL_LRED" Administrator %s is off Admin Duty.",pName,pTame);
		SendClientMessageToAll(COLOR_WHITE, string);
    }
    return 1;
}

//-----[Freeze All]-----
CMD:freezeall(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 3) return SendClientMessage(playerid,COLOR_WHITE,".:: You are not authorized to use this command ::.");
	new string[128];
	new pName[24], pTame[24];
	GetPlayerName(playerid,pName,24);
	format(string,sizeof string,""#COL_ORANGE"[SERVER]"#COL_LRED" Administrator %s has frozen everyone.",pName,pTame);
	SendClientMessageToAll(COLOR_RED, string);
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		TogglePlayerControllable(i,0);
  		}
  	}
  	return 1;
}

//-----[Unfreeze All]-----
CMD:unfreezeall(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 3) return SendClientMessage(playerid,COLOR_WHITE,".:: You are not authorized to use this command ::.");
	new string[128];
	new pName[24], pTame[24];
	GetPlayerName(playerid,pName,24);
	format(string,sizeof string,""#COL_ORANGE"[SERVER]"#COL_LRED" Administrator %s has unfrozen everyone.",pName,pTame);
	SendClientMessageToAll(COLOR_RED, string);
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
  			TogglePlayerControllable(i,1);
    	}
 	}
 	return 1;
}

//-----[Jetpack]-----
CMD:jetpack(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
		if(!IsPlayerInAnyVehicle(playerid))
		{
		    SetPlayerSpecialAction(playerid, 2);
		    SendClientMessage(playerid, COLOR_WHITE, "Jetpack spawned. Dont forget to remove it with "#COL_LBLUE"/removejet");
		}
	}
	return 1;
}
//-----[Remove Jetpack]-----
CMD:removejet(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
		if(!IsPlayerInAnyVehicle(playerid))
		{
		    SetPlayerSpecialAction(playerid, 0);
            SendClientMessage(playerid, COLOR_WHITE, ""#COL_ORANGE"[INFO:] Your jetpack has been removed.");
		}
	}
	return 1;
}

//-----[Goto]-----
CMD:goto(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 1) return SendClientMessage(playerid,COLOR_WHITE,".:: You are not authorized to use this command ::.");
	new targetid, string[128];
	if(sscanf(params, "d", targetid)) return SendClientMessage(playerid, COLOR_WHITE, "[SYNTAX:] /goto [PlayerID/PartOfName]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, ""#COL_ORANGE"[ERROR]"#COL_LRED" Player not connected!");
	else
	{
		new pName[24];
		GetPlayerName(targetid,pName,128);
		format(string, sizeof(string), ""#COL_ORANGE"[ADMIN]"#COL_LRED" You succesfully teleported to [%d] %s.",targetid, pName);
		SendClientMessage(playerid,COLOR_RED,string);
		SetPlayerInterior(playerid,GetPlayerInterior(targetid));
		new Float:TPX, Float:TPY, Float:TPZ;
		GetPlayerPos(targetid, TPX, TPY, TPZ);
		SetPlayerPos(playerid, TPX, TPY, TPZ+1);
	}
	return 1;
}

//-----[Respawn]-----
CMD:respawn(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 1) return SendClientMessage(playerid,COLOR_WHITE,".:: You are not authorized to use this command ::.");
	new targetid;
	if(sscanf(params, "d", targetid)) return SendClientMessage(playerid, COLOR_WHITE, "[SYNTAX:] / [PlayerID/PartOfName]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, ""#COL_ORANGE"[ERROR]"#COL_LRED" Player not connected!");
	else
	{
		new string[128];
		new pName[24], pTame[24];
		GetPlayerName(playerid,pName,24);
		GetPlayerName(targetid,pTame,24);
		format(string,sizeof string,""#COL_ORANGE"[SERVER]"#COL_LRED" %s has been respawned by Administrator %s.",pTame,pName);
		SendClientMessageToAll(COLOR_RED, string);
		SpawnPlayer(targetid);
	}
	return 1;
}
stock GetAOName1(playerid)
{
	new itemname[50];
	if(AOInfo[playerid][Model] == 0) { itemname = "None"; }
	else if(AOInfo[playerid][Model] == 19101) { itemname = "Army Helmet"; }
	else if(AOInfo[playerid][Model] == 19805) { itemname = "Chainsaw Dildo"; }
	return itemname;
}
public randommsg()
{
	new rand = random(sizeof(randomMsg));
	SendClientMessageToAll(COLOR_WHITE, randomMsg[rand]);
}
public carfix()
{
	for ( new playerid = 0; playerid != MAX_PLAYERS; ++ playerid )
    {
		if(IsPlayerInAnyVehicle(playerid))
		{
			new Float:vehicleHP, vehicleid;
			vehicleid = GetPlayerVehicleID(playerid);
			vehicleHP = GetVehicleHealth(vehicleid, Float:vehicleHP);
			if(vehicleHP < 501)
			{
				SetVehicleHealth(vehicleid, 1000);
			}
		}
	}
}

//-----[Gethere]-----
CMD:ssb(playerid, params[])
{
	/*new Float:vx,Float:vy,Float:vz;
	GetVehicleVelocity(GetPlayerVehicleID(playerid),vx,vy,vz);*/
	new Float:ssb;
	new string[256];
	if(sscanf(params, "f", ssb))
	{
		SendClientMessage(playerid, COLOR_WHITE, "___| Speed Boost |___");
		format(string, sizeof(string), "Your current speedboost value is "#COL_LBLUE"%f", PlayerInfo[playerid][Speedboost]);
		SendClientMessage(playerid, COLOR_WHITE, string);
		SendClientMessage(playerid, COLOR_WHITE, "[INFO:] Use /ssb [value] to change the value.");
	}
	else
	{
		if(ssb > 4) return SendClientMessage(playerid, COLOR_WHITE, "[ERROR:] You don't want to give yourself a "#COL_LBLUE"seizure"#COL_WHITE" now, do you?");
		PlayerInfo[playerid][Speedboost] = ssb;
		format(string, sizeof(string), "You have changed your speedboost value, which is now "#COL_LBLUE"%f", PlayerInfo[playerid][Speedboost]);
		SendClientMessage(playerid, COLOR_WHITE, string);
	}
	return 1;
}
CMD:gethere(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 1) return SendClientMessage(playerid,COLOR_WHITE,".:: You are not authorized to use this command ::.");
	new targetid, string[128];
	if(sscanf(params, "dz", targetid)) return SendClientMessage(playerid, COLOR_WHITE, "[SYNTAX:] / [PlayerID/PartOfName]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, ""#COL_ORANGE"[ERROR]"#COL_LRED" Player not connected!");
	else
	{
		new pName[24];
		GetPlayerName(playerid,pName,128);
		format(string, sizeof(string), ""#COL_ORANGE"[ADMIN]"#COL_LRED" You have been teleported to Administrator %s.",pName);
		SendClientMessage(targetid,COLOR_RED,string);
		SetPlayerInterior(targetid,GetPlayerInterior(playerid));
		new Float:TPX, Float:TPY, Float:TPZ;
		GetPlayerPos(playerid, TPX, TPY, TPZ);
		SetPlayerPos(targetid, TPX, TPY, TPZ+1);
	}
	return 1;
}

//-----[Create LMS]-----
	CMD:createlms(playerid, params[]) {
	    new
	        WeaponID,
	        RewardAmount,
			string[128],
			player_Name[MAX_PLAYER_NAME];

	    if(PlayerInfo[playerid][Adminlevel] > 2) {

 		if(sscanf(params, "ii", WeaponID, RewardAmount))
   			return SendClientMessage(playerid, -1, "[SYNTAX:] / [WeaponID] [Reward]");

		GetPlayerPos(playerid, g_EventPosition[0], g_EventPosition[1], g_EventPosition[2]);
  		GetPlayerFacingAngle(playerid, g_EventPosition[3]);
  		GetPlayerRame(playerid, player_Name, sizeof(player_Name));

    	g_EventWeapon = WeaponID;
	    g_EventReward = RewardAmount;
	    format(string, sizeof(string), ""COL_BROWN"[EVENT]"#COL_LBLUE" Administrator %s has created an LMS event! "#COL_BROWN"/join "#COL_LBLUE"to join the event!", player_Name);
		SendClientMessageToAll(-1, string);

		SetTimerEx("UnfreezeLMS", 20000, false, "i", playerid);

		g_EventOpen = 1;
		g_EventPlayers = 0;

		}
		else return SendClientMessage(playerid, COLOR_RED, ".:: You are not authorized to use this command ::.");
	    return true;

	}

//-----[Join LMS]-----
	CMD:join(playerid, params[]) {
	    #pragma unused params
	    if(pInEvent[playerid] == 0) {
	        if(g_EventOpen == 1) {

	            SetPlayerPos(playerid, g_EventPosition[0], g_EventPosition[1], g_EventPosition[2]);
	            SetPlayerFacingAngle(playerid, g_EventPosition[3]);

	            ResetPlayerWeapons(playerid);
	            GivePlayerWeapon(playerid, g_EventWeapon, 100000);

	            GameTextForPlayer(playerid, "~g~Joined event~n~~w~Please wait..", 3000, 3);

	            TogglePlayerControllable(playerid, 0);

	            g_EventPlayers++;
	            pInEvent[playerid] = 1; //Now in the event!

	        }
	        else return SendClientMessage(playerid, COLOR_RED, ".:: No event is going on ::.");

	    }
	    else return SendClientMessage(playerid,  COLOR_RED, ".:: You're already in the event ::.");

	    return true;

	}

CreateVehicleExEx(playerid, modelid)
{
        new Auto, Float:x,Float:y,Float:z,Float:angulo;
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			Auto = GetPlayerVehicleID(playerid);
			GetVehiclePos(Auto, x, y, z);
			GetVehicleZAngle(Auto, angulo);
	    }
	    else
	    {
			GetPlayerPos(playerid, x, y, z);
			GetPlayerFacingAngle(playerid, angulo);
	    }
        if(mycar[playerid] != 0)DestroyVehicle(mycar[playerid]);
        mycar[playerid] = CreateVehicle(modelid,x,y,z,angulo,-1,-1,60);
		SetVehicleNumberPlate(Auto, "ShuffRoam");
        SetVehicleToRespawn(Auto);
        PutPlayerInVehicle(playerid,mycar[playerid],0);
		LinkVehicleToInterior(Auto, GetPlayerInterior(playerid));
		SetVehicleVirtualWorld(Auto, GetPlayerVirtualWorld(playerid));
        PutPlayerInVehicle(playerid,mycar[playerid],0);
        return 1;
}
SetPlayerPosWithVehicle(playerid, Float:X, Float:Y, Float:Z, Float:Ang)
{
	new cartype = GetPlayerVehicleID(playerid);
	SetVehiclePos(cartype,X,Y,Z);
	SetVehicleZAngle(cartype, Ang);
  	PutPlayerInVehicle(playerid,cartype,0);
}