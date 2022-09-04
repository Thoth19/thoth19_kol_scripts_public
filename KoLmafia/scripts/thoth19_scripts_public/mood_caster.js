const {abort, haveEffect, toEffect, myMp, mpCost, skill, toSkill, useSkill, moodList, matcher, create_matcher, print} = require("kolmafia");
// kolmafia.print("Hello, " + kolmafia.myName());
//
function get_skill(i) {
  var s1 = moodList()[i];
  // lose_effect | Smooth Movements | cast 1 Smooth Movement
  const regex = /.*[\|] cast 1 (.*)/;
  matches = s1.match(regex);
  if (matches.length != 0) {
    s1 = matches[1]
  } else {
    abort("Failed to find skill in mood.")
  }
  return toSkill(s1);
}

function find_min_skill() {
  min_turns = 9999;
  min_skill: skill;

  for (i = 0; i < moodList().length; i++) {
    s = get_skill(i);
    print(s)
    e = haveEffect(toEffect(s));
    if (e < min_turns) {
      min_turns = e;
      min_skill = s;
    }
  }
  return min_skill;
}

function check_safe_to_cast(s, reserved_mp) {
  if (myMp() - mpCost(s) < reserved_mp) {
    return false;
  } 
  return true;
}

module.exports.main = (reserved_mp) => {
  if (!reserved_mp) {
    reserved_mp = 50;
  }
  while (true) {
    s = find_min_skill();
    if (check_safe_to_cast(s, reserved_mp)) {
      // Optimization for low cost skills
      if (mpCost(s) < 11 && myMp() - mpCost(s) * 10 > 50) {
        result = useSkill(9, s);
        if (!result) {
          abort("Failed to use skill: "+s)
        }
      }
      useSkill(s);
    } else {
      print("done");
      break;
    }
  }
}

