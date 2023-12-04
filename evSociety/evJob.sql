INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_blanchisseur', 'blanchisseur', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_blanchisseur', 'blanchisseur', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_blanchisseur', 'blanchisseur', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('blanchisseur', 'blanchisseur')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('blanchisseur',0,'recrue','Recrue',12,'{}','{}'),
	('blanchisseur',1,'medium',"Medium",24,'{}','{}'),
	('blanchisseur',2,'co','chef Operation',36,'{}','{}'),
	('blanchisseur',3,'boss',"Patron",48,'{}','{}')
;



