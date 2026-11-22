USE grados;

#Todas las columnas de subject
SELECT *
FROM subjects;

#Buscar asignatura concreta
SELECT *
FROM subjects s
WHERE s.acronym = 'IISSI-1';

#Obtener los nombres y acronimos de las asignaturas
SELECT s.subject_name,s.acronym
FROM subjects s;

#Filtrar por tipo Formación Básica
SELECT s.subject_name,s.acronym,s.subject_type
FROM subjects s
WHERE s.subject_type = 'Formación Básica';

#JOIN
#Nombre, apellido y categoria de quien haya entrado por selectividad
SELECT p.first_name,p.last_name,st.access_method
FROM students st
JOIN people p ON st.student_id = p.person_id
WHERE st.access_method = 'Selectividad';

#Nombre, apellido y categoria de quien sea catedrático
SELECT p.first_name,p.last_name,pr.category
FROM professors pr
JOIN people p ON pr.professor_id = p.person_id
WHERE pr.category = 'Catedrático';

#VISTAS
#Profesores con información completa
CREATE OR REPLACE VIEW v_professors AS
SELECT
	pr.professor_id,
	pr.category,
	p.person_id,
	p.dni,
	p.first_name,
	p.last_name,
	p.age,
	p.email
FROM professors pr
JOIN people p ON pr.professor_id = p.person_id;

SELECT * FROM v_professors;

SELECT *
FROM v_professors
WHERE category = 'Catedrático';
#Ahora con los estudiantes
CREATE OR REPLACE VIEW v_students AS
SELECT
	st.student_id,
	st.access_method,
	p.person_id,
	p.dni,
	p.first_name,
	p.last_name,
	p.age,
	p.email
FROM students st
JOIN people p ON st.student_id = p.person_id;

SELECT * FROM v_students;

#FUNCIONES AGREGADAS
#MEDIA DE LAS NOTAS GRUPO 1 (AVG)
SELECT AVG(g.grade_value) AS avarage_grade
FROM grades g
WHERE g.group_id = 1;

#SUMA CREDITOS GRADO 3
SELECT SUM(sub.credits) AS total_credits
FROM subjects sub
WHERE sub.degree_id = 3;

#COUNT
SELECT COUNT(*) AS total_students
FROM students;

#MAX
SELECT MAX(g.grade_value) AS max_grade
FROM grades g;

#MIN
SELECT MIN(g.grade_value) AS min_grade
FROM grades g;

#CONDICIONES MÚLTIPLES
#notas con valor menor que 5 o mayor que 9
SELECT g.grade_id, g.grade_value, g.exam_call
FROM grades g
WHERE g.grade_value < 5 OR g.grade_value > 9;

#notas entre 5 y 7
SELECT g.grade_id,g.grade_value,g.exam_call
FROM grades g
WHERE g.grade_value BETWEEN 5 AND 7;

#Asignaturas con 6 o 12 creditos
SELECT sub.subject_name,sub.credits
FROM subjects sub
WHERE sub.credits IN(6,12);