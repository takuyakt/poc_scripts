#!/bin/bash
target_server="https://github.com/takuyakt/poc_scripts.git"
target_repository=poc_scripts
target_branch=master
last_git_revision=3797cbb
git_revision=HEAD
file_size_threshold=1000
output=first_line

cd ${target_repository} 
if [ ! -e ${target_repository} ]; then
 #git clone
 git clone ${target_server}
fi

git pull

#ターゲットブランチをcheckout
git checkout -B ${target_branch}

#commit hash値一覧を取得する。
commit_hashs=`git log ${target_branch} --pretty=format:"%h" ${last_git_revision}..${git_revision}` 

#ここからloop処理をする。
for hash in ${commit_hashs}
do
# 対象ファイルをgit resetでローカルに出力する。
 git reset --hard ${hash}
 
 # --no-mergesは外す。
 git show ${hash} --pretty="format:" --name-status > tmp.txt 
 while read line
 do
  var=($line)
  file_size_flag=N
  if [ ${var[0]} = "D" ]; then
   file_size=0
   mime_type="deleted file" 
  else
   #file sizeを確認する。
   file_size=`ls -la ${var[1]} | awk '{ print $5 }'`
   if [ ${file_size} -gt ${file_size_threshold} ]; then
    file_size_flag=Y
   fi
   #MIME-typeを確認する。
   mime_type=`file -b ${var[1]}`
  fi
   output="${output}\n${hash},${var[0]},${var[1]},${file_size},${file_size_flag},${mime_type}"
 done <tmp.txt
done
echo -e $output 
