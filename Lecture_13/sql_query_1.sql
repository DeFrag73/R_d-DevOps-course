SELECT
    Children.first_name AS child_first_name,
    Children.last_name AS child_last_name,
    Institutions.institution_name,
    Institutions.institution_type,
    Classes.class_name,
    Classes.direction
FROM
    Children
JOIN
    Institutions ON Children.institution_id = Institutions.institution_id
JOIN
    Classes ON Children.class_id = Classes.class_id;
