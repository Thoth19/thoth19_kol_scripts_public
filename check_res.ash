string sheet = visit_url("charsheet.php");

int get_hot_res() {
	string hot_res_s;
	//Hot Protection:</td><td><b>Very High (6)</b></td></tr><tr><td align=right>
	matcher hot_matcher = create_matcher("Hot Protection:</td><td><b>.* .(\\d+).</b></td></tr><tr><td align=right>Cold Protection", sheet);
	if (hot_matcher.find()) {
		hot_res_s = hot_matcher.group(1);
	} else {
		print("failed");
	}
	int hot_res = to_int(hot_res_s);
	return hot_res;
}
int get_spooky_res() {
	string spooky_res_s;

	matcher spooky_matcher = create_matcher("Spooky Protection:</td><td><b>.* .(\\d+).</b></td></tr><tr><td align=right>Stench Protection", sheet);
	if (spooky_matcher.find()) {
		spooky_res_s = spooky_matcher.group(1);
	} else {
		print("failed");
	}
	int spooky_res = to_int(spooky_res_s);
	return spooky_res;
}

float resist_percent(int res, float myst_bonus) {
	float projected_res;
	float res2 = res;
	if (res < 4) {
		projected_res = res2/10 + myst_bonus;
	} else {
		projected_res = (90-50*(0.833333333333333)**(res-4))/100 + myst_bonus;
	}
	# print("res" + res + " projec %" + projected_res);
	return projected_res;
}

boolean check_food(int res, int level, boolean myst, int hp, int max_hp, string type) {
	float myst_bonus = 0;
	if (myst) {
		myst_bonus = 0.05;
	}

	int res_needed = 0;
	float projected_res;
	int projected_damage;
	int actual_damage;
	projected_damage = max_hp * max(20 - level, 1);
	while (res_needed < 30) {
		projected_res = 1-resist_percent(res_needed, myst_bonus);
		actual_damage = projected_res*projected_damage; 
		if (actual_damage < max_hp) {
			break;
		}
		# print("res: " + res_needed + "projected_damage_h: " + projected_damage + " actual_damage_h" + actual_damage);
		res_needed += 1;
	} 
	if (res_needed == 30) {
		print("Cant handle Dread Food at this level");
	}

	print("Can handle Dread Food at res: " + res_needed);
	print("Damage Dealt: " + actual_damage);
	if (res >= res_needed) {
		print("You have sufficient "+type+" res: "+res);
	} else {
		print("You need: " + (res_needed-res) + " more "+type+" res");
	}
	if (hp < actual_damage) {
		if (hp < max_hp) {
			print("Consider healing?");
		}
	} else {
		return true;
	}
	return false;
}
void main() {
	int hot_res = get_hot_res();
	int spooky_res = get_spooky_res();
	int level = my_level();
	boolean myst = false;
	if (my_class() == $class[pastamancer] || my_class() == $class[sauceror]) {
			myst = true;
	}
	int hp = my_hp();
	int max_hp = my_maxhp();


	check_food(hot_res, level, myst, hp, max_hp, "hot");
	check_food(spooky_res, level, myst, hp, max_hp, "spooky");
}

/*
Dump something like this into small_modifiers


	result.append('<tr>');
	result.append('<td class="label">Hot Consumable Safe?</td>');
	int hot_res = get_hot_res();
	int spooky_res = get_spooky_res();
	int level = my_level();
	boolean myst = false;
	if (my_class() == $class[pastamancer] || my_class() == $class[sauceror]) {
			myst = true;
	}
	int hp = my_hp();
	int max_hp = my_maxhp();
	if (check_food(hot_res, level, myst, hp, max_hp, "hot")) {
		result.append('<td class="info"><span style="color:blue" title=""> GYD Safe</span></td>');
	} else {
		result.append('<td class="info"><span style="color:red" title="">GYD UNSAFE</span></td>');

	}
	result.append('</tr>');
	result.append('</tbody>');
*/