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

#Personas con edad entre 20 y 30 años
SELECT p.first_name, p.last_name, p.age
FROM people p
WHERE p.age BETWEEN 20 AND 30;

#DISTINCT
#Grupos
SELECT DISTINCT g.group_name
FROM `groups` g;

#Tipos asignaturas
SELECT DISTINCT sub.subject_type
FROM subjects sub;

#Año de grupo creado, del mas reciente al mas antiguo
SELECT DISTINCT g.academic_year
FROM `groups` g
ORDER BY g.academic_year DESC;

#SUBCONSULTAS
SELECT MAX(g.grade_value) AS max_grades
FROM grades g
WHERE g.student_id= 6;

#que alumnos estan en el grupo 2024
#primero pregunta pequeña, grupo 2024

#SELECT g.group_id
#FROM `groups` g
#WHERE g.academic_year = 2024;

SELECT DISTINCT  sg.student_id
FROM students_groups sg
WHERE sg.group_id IN(
	SELECT g.group_id
	FROM `groups` g
	WHERE g.academic_year = 2024)
ORDER BY sg.student_id ASC;

#asignaturas que tienen mas créditos que la media

SELECT sub.subject_name, sub.credits
FROM subjects sub
WHERE sub.credits > (
	SELECT AVG(sub.credits) FROM subjects sub);
	
#LIKE
SELECT p.first_name, p.last_name, p.dni
FROM people p
WHERE p.dni LIKE '%A';

SELECT sub.subject_name
FROM subjects sub
WHERE sub.subject_name LIKE 'Fundamentos%';

SELECT p.first_name, p.last_name
FROM people p
WHERE p.first_name LIKE '_____';

#FILTRAR AÑO

SELECT g.group_name, g.activity, g.academic_year
FROM `groups` g
WHERE g.academic_year = 2024;

SELECT g.group_name, g.activity, g.academic_year
FROM `groups` g
WHERE g.academic_year BETWEEN 2020 AND 2023
ORDER BY g.academic_year;

#VISTAS COMPLEJAS: JOIN DE VARIAS TABLAS
#v_grades_with_honor
CREATE OR REPLACE VIEW v_grades_with_honors AS
SELECT g.grade_id, g.student_id, g.group_id,g.grade_value,g.exam_call
FROM grades g
WHERE g.with_honors = 1;

CREATE OR REPLACE VIEW v_student_grades AS
SELECT 
	p.person_id,p.dni,p.first_name,p.last_name,
	g.grade_value,g.exam_call,g.with_honors,
	gr.group_name,gr.activity,gr.academic_year,
	sub.subject_name,sub.acronym,sub.credits
FROM people p
JOIN  students st ON p.person_id = st.student_id
JOIN grades g ON st.student_id = g.student_id
JOIN `groups` gr ON g.group_id = gr.group_id
JOIN subjects sub ON gr.subject_id = sub.subject_id;

CREATE OR REPLACE VIEW v_professor_loads AS
SELECT	
	p.person_id,p.first_name,p.last_name,
	pr.category,
	tl.credits AS teaching_credits,
	gr.group_name,gr.activity,gr.academic_year,
	sub.subject_name,sub.acronym
FROM people p
JOIN professors pr ON p.person_id = pr.professor_id
JOIN teaching_loads tl ON pr.professor_id = tl.professor_id
JOIN `groups` gr ON tl.group_id = gr.group_id
JOIN subjects sub ON gr.subject_id = sub.subject_id;

CREATE OR REPLACE VIEW v_degree_students AS
SELECT DISTINCT
	d.degree_id,d.degree_name,
	p.person_id,p.first_name,p.last_name,
	st.access_method,
	gr.academic_year
FROM `degrees` d
JOIN subjects sub ON d.degree_id = sub.degree_id
JOIN `groups` gr ON sub.subject_id = gr.subject_id
JOIN students_groups stgr ON gr.group_id = stgr.group_id
JOIN students st ON stgr.student_id = st.student_id
JOIN people p ON st.student_id = p.person_id;

SELECT COUNT(*) AS total_honors
FROM  v_grades_with_honors;

SELECT v.first_name, v.last_name, AVG(v.grade_value) AS avarage_grade
FROM v_student_grades v
GROUP BY v.person_id, v.first_name,v.last_name;

#ORDENAR
SELECT g.grade_id, g.student_id,g.grade_value,g.exam_call
FROM grades g
ORDER BY g.grade_value ASC;	

SELECT g.grade_id, g.student_id,g.grade_value,g.exam_call
FROM grades g
ORDER BY g.grade_value DESC;

SELECT g.grade_id, g.student_id,g.grade_value,g.exam_call
FROM grades g
ORDER BY g.grade_value DESC
LIMIT 5;

SELECT st.first_name, st.last_name, g.grade_value, g.exam_call
FROM grades g
JOIN v_students st ON g.student_id = st.student_id
WHERE g.grade_value >= 5
ORDER BY st.last_name ASC , st.first_name ASC;

SELECT g.grade_id, g.student_id, g.grade_value
FROM grades g
ORDER BY g.grade_value DESC
LIMIT 5 OFFSET _;

SELECT g.grade_id, g.student_id, g.grade_value
FROM grades g
ORDER BY g.grade_value DESC
LIMIT 5 OFFSET 5;

SELECT g.group_name, g.activity, g.academic_year
FROM `groups` g
ORDER BY g.academic_year DESC, g.group_name ASC;
#JOIN CON VARIAS TABLAS
SELECT st.first_name, st.last_name, gr.group_name, gr.activity, gr.academic_year
FROM v_students st
JOIN students_groups sg ON st.student_id = sg.student_id
JOIN `groups` gr ON sg.group_id = gr.group_id;

SELECT d.degree_name, s.subject_name, s.acronym, s.credits, s.course, s.subject_type
FROM degrees d
JOIN subjects s ON d.degree_id = s.degree_id
ORDER BY d.degree_name, s.course;

SELECT st.first_name, st.last_name, s.subject_name, s.acronym, g.grade_value, g.exam_call, gr.academic_year
FROM grades g
JOIN v_students st ON g.student_id = st.student_id
JOIN `groups` gr ON g.group_id = gr.group_id
JOIN subjects s ON gr.subject_id = s.subject_id;

SELECT pr.first_name, pr.last_name, pr.category, s.subject_name, gr.group_name, gr.activity, tl.credits AS teaching_credits
FROM v_professors pr
JOIN teaching_loads tl ON pr.professor_id = tl.professor_id
JOIN `groups` gr ON tl.group_id = gr.group_id
JOIN subjects s ON gr.subject_id = s.subject_id;

#DISTINCT CON JOIN
SELECT DISTINCT st.first_name, st.last_name, s.subject_name, s.acronym, gr.academic_year
FROM v_students st
JOIN students_groups sg ON st.student_id = sg.student_id
JOIN `groups` gr ON sg.group_id = gr.group_id
JOIN subjects s ON gr.subject_id = s.subject_id
ORDER BY st.last_name, s.subject_name;

#LEFT JOIN
SELECT st.first_name, st.last_name, g.grade_value, g.exam_call
FROM v_students st
LEFT JOIN grades g ON st.student_id = g.student_id;

#GROUP BY
SELECT st.first_name, st.last_name, AVG(g.grade_value) AS average_grade, COUNT(*) AS total_grades
FROM v_students st
JOIN grades g ON st.student_id = g.student_id
GROUP BY st.student_id, st.first_name, st.last_name;

SELECT st.access_method, COUNT(*) AS total_students
FROM students st
GROUP BY st.access_method;

SELECT d.degree_name, COUNT(*) AS total_subjects
FROM degrees d
JOIN subjects s ON d.degree_id = s.degree_id
GROUP BY d.degree_id, d.degree_name;

SELECT s.subject_name, s.acronym, COUNT(*) AS total_groups
FROM subjects s
JOIN `groups` gr ON s.subject_id = gr.subject_id
GROUP BY s.subject_id, s.subject_name, s.acronym;

SELECT g.exam_call, AVG(g.grade_value) AS average_grade, COUNT(*) AS total_grades
FROM grades g
GROUP BY g.exam_call;

SELECT s.subject_name, g.exam_call, AVG(g.grade_value) AS average_grade, COUNT(*) AS total_grades
FROM grades g
JOIN `groups` gr ON g.group_id = gr.group_id
JOIN subjects s ON gr.subject_id = s.subject_id
GROUP BY s.subject_id, s.subject_name, g.exam_call
ORDER BY s.subject_name, g.exam_call;

SELECT gr.academic_year, COUNT(DISTINCT sg.student_id) AS total_students
FROM `groups` gr
JOIN students_groups sg ON gr.group_id = sg.group_id
GROUP BY gr.academic_year
ORDER BY gr.academic_year DESC;

SELECT pr.first_name, pr.last_name, pr.category, SUM(tl.credits) AS total_credits
FROM v_professors pr
JOIN teaching_loads tl ON pr.professor_id = tl.professor_id
GROUP BY pr.professor_id, pr.first_name, pr.last_name, pr.category;

#HAVING
SELECT st.first_name, st.last_name, AVG(g.grade_value) AS average_grade
FROM v_students st
JOIN grades g ON st.student_id = g.student_id
GROUP BY st.student_id, st.first_name, st.last_name
HAVING AVG(g.grade_value) > 7;

SELECT s.subject_name, COUNT(*) AS total_groups
FROM subjects s
JOIN `groups` gr ON s.subject_id = gr.subject_id
GROUP BY s.subject_id, s.subject_name
HAVING COUNT(*) > 3;

SELECT gr.group_name, gr.activity, COUNT(*) AS total_students
FROM `groups` gr
JOIN students_groups sg ON gr.group_id = sg.group_id
GROUP BY gr.group_id, gr.group_name, gr.activity
HAVING COUNT(*) > 15;

SELECT s.subject_name, AVG(g.grade_value) AS average_grade, COUNT(*) AS total_grades
FROM subjects s
JOIN `groups` gr ON s.subject_id = gr.subject_id
JOIN grades g ON gr.group_id = g.group_id
GROUP BY s.subject_id, s.subject_name
HAVING AVG(g.grade_value) > 5.5;

#CONSULTAS COMBINADAS
SELECT s.subject_name, COUNT(DISTINCT sg.student_id) AS total_students
FROM subjects s
JOIN `groups` gr ON s.subject_id = gr.subject_id
JOIN students_groups sg ON gr.group_id = sg.group_id
WHERE gr.academic_year = 2024
GROUP BY s.subject_id, s.subject_name
ORDER BY total_students DESC, s.subject_name ASC
LIMIT 3;

SELECT st.first_name, st.last_name, COUNT(*) AS total_honors
FROM v_students st
JOIN grades g ON st.student_id = g.student_id
WHERE g.with_honors = 1
GROUP BY st.student_id, st.first_name, st.last_name
HAVING COUNT(*) > 1;

SELECT d.degree_name, COUNT(DISTINCT sg.student_id) AS total_students
FROM degrees d
JOIN subjects s ON d.degree_id = s.degree_id
JOIN `groups` gr ON s.subject_id = gr.subject_id
JOIN students_groups sg ON gr.group_id = sg.group_id
WHERE gr.academic_year = 2024
GROUP BY d.degree_id, d.degree_name
ORDER BY COUNT(DISTINCT sg.student_id) DESC;

SELECT st.first_name, st.last_name, MAX(g.grade_value) AS max_grade
FROM v_students st
JOIN grades g ON st.student_id = g.student_id
GROUP BY st.student_id, st.first_name, st.last_name
ORDER BY MAX(g.grade_value) DESC;

SELECT pr.first_name, pr.last_name, COUNT(DISTINCT tl.group_id) AS total_groups
FROM v_professors pr
JOIN teaching_loads tl ON pr.professor_id = tl.professor_id
GROUP BY pr.professor_id, pr.first_name, pr.last_name
HAVING COUNT(DISTINCT tl.group_id) > 1;

SELECT DISTINCT s.subject_name, d.degree_name
FROM subjects s
JOIN degrees d ON s.degree_id = d.degree_id
WHERE d.degree_id IN (
    SELECT degree_id
    FROM subjects
    GROUP BY degree_id
    HAVING COUNT(*) > 15
);


