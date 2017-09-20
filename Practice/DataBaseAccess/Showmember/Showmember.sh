#!/bin/sh

# SQL ファイル格納ディレクトリの相対パス
readonly SQL_DIR="./Sqls/"

# オプション判定
# オプションは [--project projectName], [--entry_after YYYY/MM/DD], [--all] に決め打ち。
case $1 in
  "--project")
    EXEC_SQL="${SQL_DIR}getProject.sql $2"
    ;;
  "--entry_after")
    EXEC_SQL="${SQL_DIR}getEntryAfterMember.sql `echo $2 | tr "/" "-"`"
    ;;
  "--all")
    EXEC_SQL="${SQL_DIR}getAll.sql"
    ;;
  *)
    echo "Usage $0 [--project projectName], [--entry_after YYYY/MM/DD], [--all]" 1>&2
    exit 1
    ;;
esac

# データベース接続コマンド
CONNECT_DB="connect testUser/password@ORCLPDB"

# SQL 実行
sqlplus -s /nolog << EOF
  -- DB へ接続
  $CONNECT_DB

  -- 外出SQL ファイルを呼び出す時、変数置換の新旧が出力されるのをやめるため、
  -- VERIFY 変数をOFF に変更
  SET VERIFY OFF

  -- Sql ファイルを実行
  @$EXEC_SQL

  exit

EOF
