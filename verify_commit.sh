#!/bin/bash
target_server="https://github.com/takuyakt/poc_script.git"
target_repository=.
target_branch=master
last_git_revision=3797cbb
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

commit_hashs=`git log ${target_branch} --pretty=format:"%h" ${last_git_revision}..${git_revision}` 


#ここからloop処理をする。
for hash in ${commit_hashs}
do
 # --no-mergesは外す。
 git_files=`git show ${target_branch} ${hash} --pretty="format:" --name-only` 
 for line in  ${git_files}
 do
  #file sizeを確認する。
   file_size=`ls -la ${line} | awk '{ print $5 }'`
  #MIME-typeを確認する。
   mime_type=`file -i ${line}`
   output="${output}\n${hash},${line},${file_size},${mime_type}"
  done
done
echo -e $output 
