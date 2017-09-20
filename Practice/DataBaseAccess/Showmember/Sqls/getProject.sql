set pages 10000 lines 10000 trims on
col PROJECT_NAME for a20
col MEMBER_NAME for a20

SELECT
  PRO.PROJECT_NAME, MEM.MEMBER_NAME
FROM
  MEMBER MEM
INNER JOIN
  J_PROJECT_MEMBER JPM
ON
  MEM.MEMBER_ID = JPM.MEMBER_ID
INNER JOIN
  PROJECT PRO
ON
  PRO.PROJECT_ID = JPM.PROJECT_ID
WHERE
  PRO.PROJECT_NAME = '&1'
;
