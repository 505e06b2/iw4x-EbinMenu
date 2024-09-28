#include common_scripts\utility;
#include maps\mp\_utility;
#include ebinmenu\array_utils;

VERSION = "master";

init() {
	level.ebinmenu = spawnStruct();

	level.ebinmenu.players = spawnStruct();

	level.ebinmenu.events = spawnStruct();
	level.ebinmenu.events.sync_menu_dvars = [];

	level.ebinmenu.constants = spawnStruct();
	level.ebinmenu.constants.icon = "cardicon_iwlogo";
	level.ebinmenu.constants.bot_rank_titles = array_create(
		"cardtitle_ssdd",
		"cardtitle_20",
		"cardtitle_30",
		"cardtitle_40",
		"cardtitle_50",
		"cardtitle_60",
		"cardtitle_70"
	);

	ebinmenu\permissions::init();

	preCacheShader(level.ebinmenu.constants.icon);

	game["menu_ebinmenu"] = "ebinmenu";

	game["menu_ebinmenu_items"] = array_create(
		ebinmenu\menu_items\client::init(),
		ebinmenu\menu_items\vip::init(),
		ebinmenu\menu_items\admin::init(),
		ebinmenu\menu_items\match_settings::init(),
		ebinmenu\menu_items\host::init()
	);

	preCacheMenu(game["menu_ebinmenu"]);

	OnPlayerSay(::_onPlayerSay); //exclusive to iw4x
	level thread onPlayerConnected();
	//level thread checkHumanPlayers();
}

_executeMenuFunction(name, function_name, params) {
	//self iprintln(name + " # " + function_name + " ? paramcount " + params.size);

	menu = game[name];
	if(isDefined(menu) == false) {
		self iPrintLn("^1Invalid Menu: " + name);
		return;
	}

	required_permission_level = menu["_required_permission_level"];
	if(isDefined(required_permission_level)) {
		if(self ebinmenu\permissions::setDvarIfAccessDenied(required_permission_level)) {
			self iPrintLn("^1Access Denied: " + name);
			return;
		}
	}

	function = menu[function_name];
	if(isDefined(function) == false) {
		self iPrintLn("^1Invalid Menu Command: " + function_name);
		return;
	}

	switch(params.size) {
		case 0: return self [[function]]();
		case 1: return self [[function]](params[0]);
		case 2: return self [[function]](params[0], params[1]);
		case 3:	return self [[function]](params[0], params[1], params[2]);

		default:
			self iPrintLn("^1FAILED TO EXECUTE AS TOO MANY PARAMS");
	}
}

_onPlayerSay(message, mode) {
	if(message[0] == "/") {
		return false;
	}

	return true;
}

onPlayerConnected() {
	level endon("game_ended");

	while(true) {
		level waittill("connected", player);

		if(isDefined(player.pers["isBotWarfare"]) && player.pers["isBotWarfare"]) {
			player thread onBotConnected();
		} else {
			player setClientDvar("ui_ebinmenu_version", VERSION);
			player notifyOnPlayerCommand("ebinmenu/menu_open", "+actionslot 1");
			player notifyOnPlayerCommand("restart", "+actionslot 2");

			player thread onPlayerMenuOpen();
			player thread onPlayerSpawned();
			player thread onPlayerChangedKit();
			player thread onPlayerRestart();
		}
	}
}

onBotConnected() {
	self endon("disconnect");
	level endon("game_ended");

	self setClientDvar("customTitle", "Bot Warfare");

	wait 2;

	if(isDefined(self)) {
		self SetClanTag(":iw:"); //exclusive to iw4x
		rank_index = (self.pers["bots"]["skill"]["base"]) + (7 - getDvarInt("bots_skill_max"));
		self setRank(rank_index * 10 - 1, 0);
		self setCardIcon(level.ebinmenu.constants.icon);
		self setCardTitle(level.ebinmenu.constants.bot_rank_titles[rank_index - 1]);
	}
}

onPlayerSpawned() {
	self endon("disconnect");
	level endon("game_ended");

	while(true) {
		self waittill("spawned_player");

		self freezecontrols(false);
	}
}

onPlayerChangedKit() {
	self endon("disconnect");
	level endon("game_ended");

	while(true) {
		self waittill("changed_kit");
		self setActionSlot(1, "");
		self setWeaponHudIconOverride("actionslot1", level.ebinmenu.constants.icon);
	}
}

onPlayerMenuOpen() {
	self endon("disconnect");
	level endon("game_ended");

	while(true) {
		self waittill("ebinmenu/menu_open");

		foreach(item in level.ebinmenu.events.sync_menu_dvars) {
			self [[ item ]]();
		}

		self openPopupMenu(game["menu_ebinmenu"]);

		while(true) {
			self waittill("menuresponse", menu, menu_response);

			if(menu_response == "back") {
				break;
			}

			if(menu == game["menu_ebinmenu"]) {
				message_parts = strTok(menu_response, "|");
				if(message_parts.size >= 3) { //menu_name, menu_function, params...
					menu_name = message_parts[0];
					menu_function = message_parts[1];
					params = [];

					i = 0;
					for(x = 2; x < message_parts.size; x++) {
						params[i] = message_parts[x];
						i++;
					}

					self thread _executeMenuFunction(menu_name, menu_function, params);
				}
			}
		}

		self notify("ebinmenu/menu_close");
	}
}

onPlayerRestart() {
	self endon("disconnect");
	level endon("game_ended");

	while(true) {
		self waittill("restart");
		map(getDvar("mapname"));
	}
}
