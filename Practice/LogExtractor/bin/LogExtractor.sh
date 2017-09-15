#!/bin/sh

# 抽出結果出力先
OUTPUT_DEST="../data/extracted.log"
# 前回の処理を記録したファイル
PROCESS_LOG="LogExtractor_ProsessLog.log"
# プロパティファイルから、対象ファイル, 対象文字列を読み込み
source ../conf/extract.properties
# 前回処理フラグ
CONTINUATION_FLG="false"

# 前回処理の情報を取得(LD:以前最後に処理した行番号 WD:以前処理した最終行の内容)
read LN WD < $PROCESS_LOG
EXIST=$?

# 抽出結果出力先を空にする
echo -n > $OUTPUT_DEST

# 既に処理した記録があるかどうかチェック
if [ $EXIST = 0 ] ; then 
  for file in `find ${TARGET_PATH} -type f | sort -r`
  do
    # デリミタは一行取れるようなものならなんでもいい
    if [ "$CONTINUATION_FLG" = "false" ] ; then
      CONTINUATION_FLG=`awk -F'@@' '
      {
        if(NR=='$LN' && $0=="'"$WD"'"){
          print outputFlg="true"
        }
      }
      ' $file`

      if [ "$CONTINUATION_FLG" = "true" ] ; then
        FILE_NAME="$file"
        break
      fi
    fi
  done
fi

TARGET_FLG="false"
# 対象ログの抽出処理
for file in `find ${TARGET_PATH} -type f | sort -r`
do
  # 前回処理がなかった場合
  if [ "$CONTINUATION_FLG" = "false" ] ; then
    awk -F'|' '
    {
      if($4 == "'$TARGET_WORD'"){
        print $0 >> "'$OUTPUT_DEST'"
      }
    }
    ' "$file"
  else
    # 途中のファイルから処理をする場合
    if [ "$file" = "$FILE_NAME" ] ; then
      TARGET_FLG="true"
      awk -F'|' '
      {
        if($4=="'$TARGET_WORD'" && NR > '$LN'){
          print $0  >> "'$OUTPUT_DEST'"
        }
      }
      ' "$file"
    elif [ "$TARGET_FLG" = "true" ] ; then
      awk -F'|' '
      {
        if($4=="'$TARGET_WORD'"){
          print $0 >> "'$OUTPUT_DEST'"
        }
      }
      ' "$file"
    fi
  fi

  # 最後に処理したfile を記憶しておく
  LAST_FILE="$file"

done
  
# ファイルの最終行を記憶しておく
awk '
END{
  print NR " " $0 > "'$PROCESS_LOG'"
}
' $LAST_FILE

# mv -f $PROCESS_LOG.tmp $PROCESS_LOG
