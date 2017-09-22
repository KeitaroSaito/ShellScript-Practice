#!/bin/sh
echo "`df $1`" | awk '
BEGIN {
  LOG_PATH = "/var/log/system.log"
}
{
  if(NR == 2){
    
    # ディスク使用率の欄から"%" を除外
    gsub("%", "", $5);
    
    if($5 >= '$2'){
      print strftime("%Y/%m/%d %H:%M:%S", systime()) >> LOG_PATH
      print "ディスクの使用量が" "'$2'" "% を超えました。" >> LOG_PATH
      print "ファイルシステム: " $1 ", 使用率(%):" $5 "\n" >> LOG_PATH
    }
  }
}'
