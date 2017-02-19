db = db.getSiblingDB('towergirl');

db["user_account"].drop();

db["user_game_info"].drop();

db["user_account"].insert({user_id: "1", account: "aaa@gmail.com", device: "iphone6", facebook_account: "aaa", google_play_account: "aaa", identifier: "00000001"});

db["user_account"].insert({user_id: "2", account: "bbb@gmail.com", device: "winphone", facebook_account: "bbb", google_play_account: "bbb", identifier: "00000002"});

db["user_account"].insert({user_id: "3", account: "ccc@gmail.com", device: "nexus", facebook_account: "ccc", google_play_account: "ccc", identifier: "00000003"});

db["user_game_info"].insert({user_id: "1", level: 7, exp: 30, game_version: "1.0", last_login_time: "2016-12-10"});


db["user_game_info"].insert({user_id: "2", level: 6, exp: 100, game_version: "1.0", last_login_time: "2016-12-05"});


db["user_game_info"].insert({user_id: "3", level: 9, exp: 90, game_version: "1.0", last_login_time: "2016-12-19"});
