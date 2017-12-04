SELECT
  act_name AS アクティビティ名,
  COUNT(act_name) AS 実行回数
FROM
  activity
GROUP BY
  act_name
;
