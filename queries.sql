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