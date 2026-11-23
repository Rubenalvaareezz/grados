USE grados;
DELIMITER //
#Borrar todas las notas de un alumno por su dni
CREATE OR REPLACE PROCEDURE p_delete_student_grades(
	IN p_student_dni CHAR(9)
	)
BEGIN
	DECLARE v_student_id INT;
	SELECT s.student_id INTO v_student_id
	FROM people p
	JOIN students s ON s.student_id = p.person_id
	WHERE p.dni = p_student_dni;
	DELETE FROM grades WHERE student_id = v_student_id;
END //
#Borra todo los datos PRIMERO tablas hijas, SEGUNDO tablas padre
CREATE OR REPLACE PROCEDURE p_delete_all_data()
BEGIN
	DELETE FROM grades;
	DELETE FROM teaching_loads;
	DELETE FROM students_groups;
	DELETE FROM students_subjects;
	DELETE FROM `groups`;
	DELETE FROM subjects;
	DELETE FROM students;
	DELETE FROM professors;
	DELETE FROM degrees;
	DELETE FROM people;
END //

#HOLA

DELIMITER ;
