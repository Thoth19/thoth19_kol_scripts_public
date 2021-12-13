void main(string arg) {
	print("Trying to eat "+arg);
	item it = to_item(arg);
	if (item_amount(it) == 0) {
		abort("No instances of " +it);
	}

	item offhand = equipped_item($slot[offhand]);
	cli_execute("/e o familiar scrapbook");
	if (it.spleen > 0) {
		chew(it);
	} else if (it.fullness > 0) {
		eat(it);
	} else if (it.inebrity > 0) {
		drink(it);
	}
	print("Consumed item successfully");
	equip(offhand);
}