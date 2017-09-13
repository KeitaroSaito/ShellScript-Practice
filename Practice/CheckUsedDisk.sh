#!/bin/sh
echo "`df $1`" | awk '
BEGIN {
  LOG_PATH = """/var/log/system.log""" 
}
{
  if(NR == 2){
    if(substr($5, 0, length($5)-1) >= '$2'){
      print strftime("%Y/%m/%d %H:%M:%S", systime()) >> "/var/log/system.log"
      print "ディスクの使用量が" "'$2'" "% を超えました。" >> "/var/log/system.log"
      print "ファイルシステム: " $1 ", 使用率(%):" $5 "\n" >> "/var/log/system.log"
    }
  }
}'
