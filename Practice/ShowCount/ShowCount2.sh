#!/bin/sh

# -n オプションなしの場合の対象ファイルを引数から取得
TARGET="$1"

# オプションのチェック
while getopts n: OPT
do
  case $OPT in
    "n" ) OPT_FLG="TRUE" ; OPT_VAL="$OPTARG" TARGET=$3 ;;
    * ) echo "Usage ShowCount [-n name] filename" 1>&2
        exit 1;;
  esac
done

# awk で集計
# オプション-n が指定されている場合
if [ "$OPT_FLG" == "TRUE" ] ; then
  awk -f ./Awks/task02_on_option.awk -v 'OPT_VAL='$OPT_VAL "$TARGET"
else
  awk -f ./Awks/task02_no_option.awk "$TARGET"
fi


