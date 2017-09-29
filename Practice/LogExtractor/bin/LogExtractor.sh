#!/bin/sh

# 抽出結果出力先
readonly OUTPUT_DESTINATION="../data/extracted.log"
# 前回の処理を記録したファイル
readonly PROCESS_LOG="LogExtractor_ProsessLog.log"
# プロパティファイルから、対象ファイル, 対象文字列を読み込み
source ../conf/extract.properties
# 前回処理フラグ
continuation_flg="false"

# 前回処理の情報を取得(LINE_NUMBER:以前最後に処理した行番号 LINE_CONTENT:以前処理した最終行の内容)
read readonly LINE_NUMBER readonly LINE_CONTENT < $PROCESS_LOG
EXIST_PROCESS_LOG=$?

# 抽出結果出力先を空にする
echo -n > $OUTPUT_DESTINATION

# 既に処理した記録があるかどうかチェック
if [ $EXIST_PROCESS_LOG = 0 ] ; then
  FILE_NAME=find ${TARGET_PATH} -type f | xargs grep "$LINE_CONTENT" | head -n 1
  continuation_flg="true"
fi

target_flg="false"
# 対象ログの抽出処理
for file in `find ${TARGET_PATH} -type f | sort -r`
do
  # 前回処理がなかった場合
  if [ "$continuation_flg" = "false" ] ; then
    awk -F'|' '
    {
      if($4 == "'$TARGET_WORD'"){
        print $0 >> "'$OUTPUT_DESTINATION'"
      }
    }
    ' "$file"
  else
    # 途中のファイルから処理をする場合

    if [ "$file" = "$FILE_NAME" ] ; then
      # 途中まで処理したファイルの場合
      target_flg="true"
      sed -n '$LINE_NUMBER,$p' | awk -F'|' '
      {
        if($4=="'$TARGET_WORD'"){
          print $0  >> "'$OUTPUT_DESTINATION'"
        }
      }
      ' "$file"
    elif [ "$target_flg" = "true" ] ; then
      # 新しく処理をするファイルの場合
      awk -F'|' '
      {
        if($4=="'$TARGET_WORD'"){
          print $0 >> "'$OUTPUT_DESTINATION'"
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
