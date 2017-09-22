#!/bin/sh

CMDNAME=`basename $0`
TARGET="$1"

# オプションのチェック
# getopts によってコマンドで指定されたオプションの一覧が取得される。
while getopts n: OPT
do
  case $OPT in
    "n" ) OPT_FLG="TRUE" ; OPT_VALUE="$OPTARG" TARGET=$3 ;;
      * ) echo "Usage ShowCount [-n name] filename" 1>&2
          exit 1;;
  esac
done

awk '
{
  # 1行目には必ず日付が "/" 区切りで 年月日の準で記載されている前提
  if(NR == 1){
    split($0, ymd, "/")
    printf "%d/%02d/%02d\n", ymd[1], ymd[2], ymd[3]
  }
}
{
  # コマンドオプション -n が指定されている場合の処理
  if("'$OPT_FLG'" == "TRUE"){
    if($1 == "'$OPT_VALUE'"){
      sum_of["'$OPT_VALUE'"] += $2
    }
  }else if(substr($1, 0, 2) == "OP"){
    # 集計対象データの1列目はOP始まりである前提
#    if(sum_of[$1] >= 0){
      sum_of[$1] += $2
#    } else {
#      sum_of[$1] = $2
#    }
  }
}
END {
  if("'$OPT_FLG'" == "TRUE"){
    # オプションで集計対象が指定されているならば指定されている集計のみ表示
    print("'$OPT_VALUE':" sum_of["'$OPT_VALUE'"])
  } else {
#    for(sum_value in sum_of){
#      total += sum_of[sum_value]
#      print sum_value ":" sum_of[sum_value]
#    }
    # ソートされたインデクスを取得
    # index文字列だけの配列を作成
    i=1
    for(sum_value in sum_of){
      indexes[i] = sum_value
      i++
    }
    # 上記で作成した配列をソート
    for(i=1; i<=length(indexes)-1; i++){
      for(j=i+1; j <=length(indexes); j++){
        if(indexes[i] > indexes[j]){
          tmp = indexes[i]
          indexes[i] = indexes[j]
          indexes[j] = tmp
        }
      }
    }
    # 取得したインデクス準に出力
    for(i=1; i<=length(indexes); i++){
      total += sum_of[indexes[i]]
      print indexes[i] ":" sum_of[indexes[i]]
    }
    print "TOTAL:" total
  }
}
' $TARGET
