-------------------------------------------------
---                                           ---
---              LilleWebMarket               ---
---                                           ---
-------------------------------------------------
--- Script de création de la base
---------------------------------
--- Auteur : Alexandre Demode
--- Date de création : 15 janvier 2014
-------------------------------------------------





-------------------------------------------------
--- Crée la table des utilisateurs
-------------------------------------------------
CREATE TABLE lwm_utilisateur (
	login		VARCHAR(30) PRIMARY KEY,
	mdp			VARCHAR(30) NOT NULL,
	nom			VARCHAR(75) NOT NULL,
	prenom		VARCHAR(75) NOT NULL,

	CONSTRAINT pk_lwm_utilisateur
		PRIMARY KEY login
);



-------------------------------------------------
--- Crée la table des informations sur les utilisateurs
-------------------------------------------------
CREATE TABLE lwm_utilisateur_infos (
	login		VARCHAR(30) PRIMARY KEY,
	role		VARCHAR(30) NOT NULL,
	cash		INTEGER 	NOT NULL	DEFAULT 10000,

	CONSTRAINT pk_lwm_utilisateur_infos
		PRIMARY KEY login,

	FOREIGN KEY login
		REFERENCES lwm_utilisateur(login)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);



-------------------------------------------------
--- Crée la table des achats en cours des utilisateurs
-------------------------------------------------
CREATE TABLE lwm_utilisateur_achat (
	login		INTEGER 	NOT NULL,
	id_marche	INTEGER 	NOT NULL,
	nb_titres	INTEGER 	NOT NULL 	CHECK (nb_titres > 0),
	prix		INTEGER 	NOT NULL,
	affirmation BOOLEAN		NOT NULL 	DEFAULT TRUE,

	PRIMARY KEY (login, id_marche, prix),

	FOREIGN KEY login
		REFERENCES lwm_utilisateur(login)
		ON DELETE CASCADE
		ON UPDATE CASCADE,

	FOREIGN KEY id_marche
		REFERENCES lwm_marche(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);



-------------------------------------------------
--- Crée la table des titres des utilisateurs
-------------------------------------------------
CREATE TABLE lwm_utilisateur_titre (
	login		INTEGER 	NOT NULL,
	id_marche	INTEGER 	NOT NULL,
	nb_titres	INTEGER 	NOT NULL CHECK (nb_titres > 0),
	prix		INTEGER 	NOT NULL,

	CONSTRAINT pk_lwm_utilisateur_titre
		PRIMARY KEY (login, id_marche, prix),

	CONSTRAINT fk_lwm_utilisateur
		FOREIGN KEY login
		REFERENCES lwm_utilisateur(login)
		ON DELETE CASCADE
		ON UPDATE CASCADE,

	CONSTRAINT fk_lwm_marche
		FOREIGN KEY id_marche
		REFERENCES lwm_marche(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);



-------------------------------------------------
--- Crée la table des marchés
-------------------------------------------------
CREATE TABLE lwm_marche (
	id			INTEGER		AUTO_INCREMENT,
	titre		VARCHAR(255)NOT NULL,
	titre_inv	VARCHAR(255)NOT NULL,
	echeance	TIMESPTAMP	NOT NULL,
	principal	BOOLEAN		NOT NULL 	DEFAULT TRUE,

	CONSTRAINT pk_lwm_marche
		PRIMARY KEY id,

	FOREIGN KEY id_inverse
		REFERENCES lwm_marche(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);



-------------------------------------------------
--- Crée la table des variations d'un marché
-------------------------------------------------
CREATE TABLE lwm_variations_marche (
	id_marche	INTEGER		NOT NULL,
	instant		TIMESPTAMP	NOT NULL,
	valeur		INTEGER		NOT NULL,

	PRIMARY KEY (id_marche, instant),

	FOREIGN KEY id_marche
		REFERENCES lwm_marche(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);