#!/bin/sh

# プロパティファイルから、ユーザID、パスワード、接続先DB名を読み込み
source ../access_info.properties

# 表示用の枠となる文字列
readonly FRAME="+----------------+--------+"

# SQL ファイル格納ディレクトリの相対パス
readonly SQL_DIR="./Sqls/"

# データベース接続コマンド
CONNECT_DB="connect testUser/password@ORCLPDB"

while :
do
  (
  # echo で出力することで、 コンソール上で順番にコマンドを叩いてる風にする。
  echo $CONNECT_DB

  # 上記のエコーによって、コンソール上はSQL*Plus が立ち上がった状態
  # "SQL> " って幹事の待ち状態
  # これ以降、echo で出力すれば待ち状態のところにSQLコマンドを送っていくかたちになる

  # 出力カラムの設定
  echo "col アクティビティ名 for a16"

  # ShellScript のWhile を使用してSQLを繰り返し実行する
  echo "@${SQL_DIR}showAct.sql"
  )| sqlplus -s /nolog |
  #echo "`awk '{print NR ":" $0 ":";}'`"
   echo -e "`awk '
    {
      if(NR==2){
        print "'$FRAME'"
        contPrint += 1
        printf("|%-8s|%4s|\n",$1,$2)
        contPrint += 1
        print "'$FRAME'"
        contPrint += 1
        sum += $2
      }
      if(NR==1 || NR==3){
        # NOP
        # SQL実行結果に含まれる不横行(空白行、区切り行) のため何もしない。
      }
      if(3<NR && $2!=""){
        printf("|%-16s|%9s|\n",$1,$2)
        contPrint += 1
        sum+= $2
      }
    }
    END{
      print "'$FRAME'"
      contPrint += 1
      printf("|%-16s|\\\\e[31m%8s\\\\e[m|\n","TOTAL",sum)
      contPrint += 1
      print "'$FRAME'"
      contPrint += 1
    }
    '`"
  # カーソル位置を戻す
  # TODO 戻す数は固定値じゃなくてawkのなかで出力した回数分戻したいんだけど...
  tput cuu 10
  sleep 5s
done
exit 0
