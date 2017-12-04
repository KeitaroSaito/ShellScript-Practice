set pages 10000 lines 10000 trims on
col project_name for a20
col member_name for a20

SELECT
  pro.project_name, mem.member_name
FROM
  member mem
INNER JOIN j_project_member jpm ON mem.member_id = jpm.member_id
INNER JOIN project pro ON pro.project_id = jpm.project_id
WHERE
  pro.project_name = '&1'
;
