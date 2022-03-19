#include <sourcemod>

#include <gokz/core>
#include <gokz/localdb>

#undef REQUIRE_EXTENSIONS
#undef REQUIRE_PLUGIN

#include <gokz/profile>

#pragma newdecls required
#pragma semicolon 1



public Plugin myinfo =
{
	name = "LOB Profile",
	author = "Szwagi",
	version = "v1.0.0",
};

bool gB_GOKZProfile;
Database gH_DB = null;

#include "lob-profile/sql.sp"
#include "lob-profile/helpers.sp"
#include "lob-profile/profile.sp"



// =====[ PLUGIN EVENTS ]=====

public void OnPluginStart()
{
	LoadTranslations("lob-profile.phrases");
	RegisterCommands();
}

public void OnAllPluginsLoaded()
{
	gB_GOKZProfile = LibraryExists("gokz-profile");

	gH_DB = GOKZ_DB_GetDatabase();
	if (gH_DB == null)
	{
		SetFailState("No database");
	}
}



// =====[ COMMANDS ]=====

void RegisterCommands()
{
	RegConsoleCmd("sm_profile", CommandProfile, "[LOB] Open the local profile menu.");
}

public Action CommandProfile(int client, int args)
{
	if (args < 1)
	{
		DB_OpenProfile(client, GetSteamAccountID(client));
	}
	else if (args >= 1)
	{
		char argPlayer[MAX_NAME_LENGTH];
		GetCmdArg(1, argPlayer, sizeof(argPlayer));
		DB_OpenProfile_FindPlayer(client, argPlayer);
	}
	return Plugin_Handled;
}
