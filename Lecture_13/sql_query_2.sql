SELECT
    Parents.first_name AS parent_first_name,
    Parents.last_name AS parent_last_name,
    Children.first_name AS child_first_name,
    Children.last_name AS child_last_name,
    Parents.tuition_fee
FROM
    Parents
JOIN
    Children ON Parents.child_id = Children.child_id;
