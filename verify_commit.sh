#!/bin/bash
target_server="https://github.com/takuyakt/poc_script.git"
target_repository=.
target_branch=master
last_git_revision=c1c323c
git_revision=HEAD
#IFS=$'\n';

if [ ! -e ${target_repository} ]; then
 #git clone
 git clone ${target_server}
fi

cd ${target_repository}
git pull

#ターゲットブランチを見つける。
git checkout -fb ${target_branch}

#commit hash値一覧を取得する。

commit_hashs=`git log ${target_branch} --pretty=format:"%H" ${last_git_revision}..${git_revision}` 


#ここからloop処理をする。
for hash in ${commit_hashs}
do
 declare -i cnt=0
 # --no-mergesは外す。
 git_files=`git show ${target_branch} ${hash} --pretty="format:" --name-only` 
 for line in  ${git_files}
 do
  # if [ ${cnt} -eq 0 ]; then
    # hash値とbranch名が表示される。
  #  hash_and_branch=${line}
  #  cnt=`expr ${cnt} + 1`
  # else
  #file sizeを確認する。
   file_size=`ls -la ${line} | awk '{ print $5 }'`
  #MIME-typeを確認する。
   mime_type=`file -i ${line}`
   output="${output}¥n${hash},${file_size},${mime_type}"
 # fi
  done
done
echo -e ${output}

