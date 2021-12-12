boolean  in_clan_stash(item it) {
	int [item] stashed_items;
	stashed_items = get_stash();
	foreach stashed_item in stashed_items {
		if (stashed_item == it) {
			return true;
		}
	}
	return false;
}

void who_took(item it) {
	string log = visit_url("clan_log.php");
	// 11/30/21, 07:01PM: CheeseyPickle (#3048851) took 1 picky tweezers.
	matcher item_matcher = create_matcher(">([^>]+ .#\\d+.)</a> (took 1 "+it.name+")", log);
	if (item_matcher.find()) {
		print("Player " + item_matcher.group(1) + " has the item: " + it.name);
	} else {
		print("failed");
		//abort("dumb matcher");
	}
}

boolean check_stash_item(item it) {
	if (!(in_clan_stash(it))){
		who_took(it);
		return false;
	} else {
		print("found " + it.name +" successfully");
	}
	return true;
}

boolean check_all_stash() {
	boolean all = true;
	foreach it in $items[platinum yendorian express card, moveable feast, pantsgiving, operation patriot shield, Buddy Bjorn] {
		if (!check_stash_item(it)) {
			all = false;
		}
	}
	print("Finished");
	return all;
}

void take_all_stash() {
	foreach it in $items[platinum yendorian express card, moveable feast, pantsgiving, operation patriot shield, Buddy Bjorn] {
		cli_execute("stash take "+it.name);
	}
	foreach it in $items[platinum yendorian express card, moveable feast, pantsgiving, operation patriot shield, Buddy Bjorn] {
		cli_execute("inv "+it.name);
	}
	print("Finished");	
}
void put_all_stash() {
	foreach it in $items[platinum yendorian express card, moveable feast, pantsgiving, operation patriot shield, Buddy Bjorn] {
		cli_execute("stash put "+it.name);
	}
	foreach it in $items[platinum yendorian express card, moveable feast, pantsgiving, operation patriot shield, Buddy Bjorn] {
		cli_execute("inv "+it.name);
	}
	print("Finished");	
}

void main(string arg) {
	switch (arg) {
		case "":
		case " ":
		case "check":
			check_all_stash();			
			break;
		case "take":
			if (check_all_stash()) {
				take_all_stash();
			}
			break;
		case "put":
			put_all_stash();
			break;
	}
}

// cli_execute("CONSUME SIM");