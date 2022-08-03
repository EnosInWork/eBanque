INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_banquier', 'Banquier', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_banquier', 'Banquier', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_banquier', 'Banquier', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('banquier', 'Banquier')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('banquier',0,'recrue','Recrue',12,'{}','{}'),
	('banquier',1,'novice','Novice',25,'{}','{}'),
	('banquier',2,'experimente','Experimente',36,'{}','{}'),
	('banquier',3,'assistant','Assistant',48,'{}','{}'),
  ('banquier',4,'boss','Patron',0,'{}','{}')
;

CREATE TABLE banking_historique (
  id int(11) NOT NULL,
  identifier varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  Montant varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '2',
  type varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '',
  time varchar(50) DEFAULT '0',
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE banking_historique
  ADD PRIMARY KEY (id);

ALTER TABLE banking_historique
  MODIFY id int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=263;


INSERT INTO `items` (name, label) VALUES ('cartebanque', 'Carte Bancaire');

CREATE TABLE `bank_lent_money` (
  `id` int(11) PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `firstname` varchar(255) DEFAULT NULL,
  `lastname` varchar(255) NOT NULL,
  `clientID` varchar(255) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `rate` double NOT NULL,
  `remainDeadlines` double DEFAULT NULL,
  `deadlines` double NOT NULL,
  `amountNextDeadline` double DEFAULT NULL,
  `alreadyPaid` double DEFAULT NULL,
  `timeLeft` double NOT NULL,
  `timeBeforeDeadline` double NOT NULL,
  `advisorFirstname` varchar(255) DEFAULT NULL,
  `advisorLastname` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'Ouvert'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `bank_savings` (
  `id` int(11) PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `firstname` varchar(255) DEFAULT NULL,
  `lastname` varchar(255) NOT NULL,
  `tot` double DEFAULT NULL,
  `rate` double NOT NULL,
  `advisorFirstname` varchar(255) DEFAULT NULL,
  `advisorLastname` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'Ouvert'
);