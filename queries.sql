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
SELECT p.first_name,p.last_name,st.access_method
FROM students st
JOIN people p ON st.student_id = p.person_id
WHERE st.access_method = 'Selectividad';

SELECT p.first_name,p.last_name,pr.category
FROM professors pr
JOIN people p ON pr.professor_id = p.person_id
WHERE pr.category = 'Catedrático';