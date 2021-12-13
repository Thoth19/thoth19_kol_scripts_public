string pill_check() {
	string page = visit_url("campground.php?action=workshed");
	// print(page);
	// Dr. Jeeves, Internetst says, "I'm prescribing you a Fleshazole™."
	matcher item_matcher = create_matcher("prescribing you <b>an? (.+)</b>", page);
	if (item_matcher.find()) {
		return item_matcher.group(1);
	}
	//<p>You can visit the doctors again in 20 turns.<br>You     have 4 consultations left     today.
	matcher avail_matcher = create_matcher("You can visit the doctors again in (\\d+) turns.<br>You have (\\d) consultations left today.", page);
	if (avail_matcher.find()) {
		return "Wait turns: "+avail_matcher.group(1) + " Consults left: "+avail_matcher.group(2);
	}
	return "error";	
}

print("Your pill is: "+pill_check());