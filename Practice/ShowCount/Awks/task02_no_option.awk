{
  # 対象ファイルの一行目には必ず日付が"/" 区切りで、
  # 年月日の順で記載されている前提
  if(NR == 1){
    split($0, ymd, "/")
    printf "%d/%02d/%02d\n", ymd[1], ymd[2], ymd[3]
  }

  # 対象データを集計
  if(substr($1, 0, 2) == "OP"){
    # 集計対象データの1列目はOP始まりである前提
    sum_of[$1] += $2
  }
}

END {

  # 集計結果を出力 & TOTAL の計算
  for(i in sum_of){
    print i ":" sum_of[i]
    total += sum_of[i]
  }

  print "TOTAL:" total
}
