CREATE TABLE `user_login` (
  `user_id` varchar(255) NOT NULL DEFAULT '',
  `user_account` varchar(255) DEFAULT NULL,
  `device_identifier` varchar(255) DEFAULT NULL,
  `client_version` varchar(255) DEFAULT NULL,
  `client_app_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `user_energy` (
  `user_id` varchar(255) NOT NULL DEFAULT '',
  `energy` int(11) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;