NAME = "CLIENT";

init() {
	game[NAME]["_required_permission_level"] = level.ebinmenu.constants.permissions["Standard"];

	game[NAME]["fullbright"] = ::fullbright;
	game[NAME]["thirdperson"] = ::thirdPerson;
	game[NAME]["laser"] = ::laser;
	game[NAME]["hud"] = ::noop; //cg_draw2D handled client-side
	game[NAME]["gun"] = ::noop; //cg_drawGun handled client-side

	level thread onPlayerConnected();

	return NAME;
}

onPlayerConnected() {
	level endon("game_ended");

	while(true) {
		self waittill("connected", player);

		player setClientDvars(
			"secret_guid", player getGuid(),
			"cg_draw2D", 1,
			"cg_drawGun", 1
		);

		player thread onGameEnded();
	}
}

onGameEnded() {
	self endon("disconnect");

	level waittill("game_ended");
	self setClientDvars(
		"cg_draw2D", 1,
		"cg_drawGun", 1
	);
}

fullbright(state) {
	if(getDvarInt("sv_cheats") == 0) { //wasn't set by menu
		self setClientDvar("r_fullbright", state);
	}
}

thirdPerson(state) {
	if(getDvarInt("sv_cheats") == 0) {
		self setClientDvar("cg_thirdPerson", state); //resets on death, so may need loop?
	}
}

laser(state) {
	if(getDvarInt("sv_cheats") == 0) {
		self setClientDvar("laserForceOn", state);
	}
}

noop(state) {
	//noop
}
