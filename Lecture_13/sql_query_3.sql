SELECT
    Institutions.institution_name,
    Institutions.address,
    COUNT(Children.child_id) AS number_of_children
FROM
    Institutions
LEFT JOIN
    Children ON Institutions.institution_id = Children.institution_id
GROUP BY
    Institutions.institution_name, Institutions.address;
