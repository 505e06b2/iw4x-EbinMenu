init() {
	setDvarIfUninitialized("bots_skill_min", 2); //1 is min
	setDvarIfUninitialized("bots_skill_max", 5); //7 is max
	//setDvarIfUninitialized("bots_manage_fill_mode", 4); //used for balancing - can't be solo so turn off when bots are disabled (handled in menu)
	setDvarIfUninitialized("bots_manage_fill_kick", 1); //kick for players
	setDvarIfUninitialized("bots_manage_fill_spec", 0); //fill in for spectators
	setDvarIfUninitialized("bots_team_force", 1); //unbalanced teams will be balanced
	setDvarIfUninitialized("bots_loadout_reasonable", 1); //reasonable
	setDvarIfUninitialized("bots_loadout_allow_op", 0); //nothing annoying
	setDvarIfUninitialized("bots_loadout_rank", 70);
	setDvarIfUninitialized("bots_loadout_prestige", 0);

	bot_warfare\scripts\mp\bots::init();
	bot_warfare\scripts\mp\bots_adapter_iw4x::init();
}
