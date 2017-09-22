{
  # 対象ファイルの一行目には必ず日付が "/" 区切りで、
  # 年月日の順で記載されている前提
  if(NR == 1){
    split($0, ymd, "/")
    printf "%d/%02d/%02d\n", ymd[1], ymd[2], ymd[3]
  }

  # オプションとして指定された文字列だけ集計
  if($1 == OPT_VAL){
    sum_of[OPT_VAL] += $2
  }
}

END {
  print(OPT_VAL ":" sum_of[OPT_VAL])
}
