set pages 10000 lines 10000 trims on
col project_id for a10
col project_name for a12
col end_user for a8
col start_date for a10
col release_date for a12
col project_status for a14
col member_name for a11
col member_age for a10
col entrydate for a10
col favorite_food for a20

SELECT
  pro.project_id,
  pro.project_name,
  eu.end_user_name AS end_user,
  TO_CHAR(pro.start_date, 'YYYY/MM/DD') AS start_date,
  TO_CHAR(pro.release_date, 'YYYY/MM/DD') AS release_date,
  CASE
    WHEN pro.project_status = 0 THEN '保守'
    ELSE '開発'
  END AS project_status,
  mem.member_name,
  TO_CHAR(
    EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM.BIRTHDAY) -
    EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM mem.birthday) -
      CASE
        WHEN TO_CHAR(SYSDATE, 'MMDD') < TO_CHAR(mem.birthday, 'MMDD') THEN 1
        ELSE 0 
      END
  ) AS member_age,
  TO_CHAR(mem.entrydate,'YYYY/MM/DD') AS entrydate,
  mem.favorite_food
FROM
  member mem
INNER JOIN j_project_member jpm ON mem.member_id = jpm.member_id
INNER JOIN project pro ON pro.project_id = jpm.project_id
INNER JOIN end_user eu ON eu.end_user_id = pro.end_user_id
;
