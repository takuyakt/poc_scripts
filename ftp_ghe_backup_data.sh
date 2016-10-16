#!/bin/bash


#todo 変数の共通化
 
id=root
password=centos
port=22
host=192.168.10.11
remote_base_dir=GHE
remote_dir=ghe_backup_data
previous_remote_dir=old_ghe_backup_data
local_dir=current
retry_count=3
log=tmp.log


ftp_to_evacuation_site(){
ftp -n << EOM
open ${host}
user ${id} ${password}
prompt
$1
EOM
}

ncftp_to_evacuation_site(){
ncftp << EOM
open -u ${id} -p ${password} ${host}
$1
EOM
}

# rename previous ghe backup data
ftp_to_evacuation_site "rename ${remote_base_dir}/${remote_dir} ${remote_base_dir}/${previous_remote_dir}"

# ftp new ghe back up data
ncftpput -u ${id} -p ${password} -v  -m -R -r ${retry_count} -d ${log} \
-Y "rm -r ${previous_remote_dir}" \
${host} ${remote_base_dir}/${remote_dir} ${local_dir} 

if [ ${?} = 0 ]; then
 echo ncftpput sccess 
else 
 echo ncftput failure
 exit 1
fi

# delete previous ghe backup data 
#ftp_to_evacuation_site "rmd ${remote_base_dir}/${previous_remote_dir}"
ncftp_to_evacuation_site "ls -la ${remote_base_dir};rm -r ${remote_base_dir}/${previous_remote_dir};echo ------;ls -la ${remote_base_dir}"

