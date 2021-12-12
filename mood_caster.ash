skill get_skill(int i) {
	string s1 = mood_list()[i];
	// lose_effect | Smooth Movements | cast 1 Smooth Movement
	matcher m = create_matcher("[^\\|]+ \\| [^\\|]+ \\| cast 1 (.*)", s1);
	if (m.find()) {
		s1 = m.group(1);
	} else {
		print("failed");
	}
	return to_skill(s1);
}

skill find_min_skill() {
	int min_turns = 9999;
	skill min_skill;

	foreach m in mood_list() {
		skill s = get_skill(m);
		int e = have_effect(to_effect(s));
		if (e < min_turns) {
			min_turns = e;
			min_skill = s;
		}
	}
	return min_skill;
}

boolean check_safe_to_cast(skill s) {
	if ((my_mp() - mp_cost(s)) < 50) {
		return false;
	} else {
		return true;
	}
}

skill s;
while (true) {
	s = find_min_skill();
	# print(s);
	if (check_safe_to_cast(s)) {
		use_skill(s);
	} else {
		print("done");
		break;
	}
}

