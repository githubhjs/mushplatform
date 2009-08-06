CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL default '',
  `salt` varchar(255) NOT NULL ,
  `salted_password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL unique,
  `created_at` datetime default NULL,
  `update_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

