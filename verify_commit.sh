#!/bin/bash
target_server="https://github.com/github/backup-utils.git"
target_repository=backup-utils
target_branch=master
last_git_revision=8987607
git_revision=HEAD
IFS=$'\n';

if [ ! -e ${target_repository} ]; then
 #git clone
 git clone ${target_server}
fi

cd ${target_repository}
git pull

#ターゲットブランチを見つける。
git checkout -fb ${target_branch}

#ここからloop処理をする。
while [ "${last_git_revision}" != ${git_revision} ]
do
 declare -i cnt=0
 # --no-mergesは外す。
 git_files_log=`git log ${target_branch} --name-only --oneline ${git_revision}^..${git_revision}` 
 for line in  ${git_files_log}
 do
   if [ ${cnt} -eq 0 ]; then
    # hash値とbranch名が表示される。
    hash_and_branch=${line}
    cnt=`expr ${cnt} + 1`
   else
  #file sizeを確認する。
   file_size=`ls -la ${line} | awk '{ print $5 }'`
  #MIME-typeを確認する。
   mime_type=`file -i ${line}`
   output="${output}¥n${hash_and_branch},${file_size},${mime_type}"
  fi
  done
 #git revisionを更新
 git_revision=`echo ${hash_and_branch} | awk '{print $1}'`
done
echo -e ${output}

