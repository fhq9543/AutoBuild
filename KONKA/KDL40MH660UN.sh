#!/bin/bash

#######################
# Description : AUTOBUILD tool 
# Manual : autobuild_usage.doc
# Author : huaqing.fang
# Email : huaqing.fang@mastarsemi.com
# Date : 2016-09-09 12:11:45
#######################

work_path=`pwd`
#following variables need to change according to the fact
svn_path=http://172.30.2.147/svn/MST538/trunk/Beta_release
svn_username=fae
svn_password=12345678
code_path=$work_path/Beta_release
image_path=$work_path/Beta_release/images/marshmallow/konka
build_flow()
{
    cp -f KDL40MH660UN.config Beta_release/vendor/mstar/supernova/projects/configuration/.config && \
    cd Beta_release && \
    rm -rf ./out && \
    echo EY > FILE && \
    source build/kk_envsetup.sh < FILE && \
    supernova_release && \
    android_release
}

#there variables don't need to change
project_name=${0:2:-3}
current_reversion_log=$work_path/.${project_name}_reversion
build_log=$work_path/${project_name}_build.log
out_path=$work_path/$project_name

#check code path
if [[ ! -d $code_path ]]; then
    echo -e "\033[31m there is no $code_path!!! \033[0m"
    echo -e "\033[31m please make sure code_path!!! \033[0m"
    exit 1
fi

#begin to build code
echo -e "### `date +%Y%m%d\ %H:%M:%S` begin to build $code_path"
echo -e "building ..."

#check whether the code is newest
echo check whether the code is newest ...
cmd="svn ${svn_username:+--username} $svn_username ${svn_password:+--password} $svn_password log -l 1 $svn_path"
echo $cmd
newest_reversion=`$cmd | awk '/r[0-9]+/{print $1}'`
echo the newest reversion is : $newest_reversion
if [[ -e $current_reversion_log && $newest_reversion == `cat $current_reversion_log` ]]; then
    echo -e "\033[32m the code is newest!\033[0m"
    echo -e "\033[32m don't need to update and build!\033[0m"
    exit 0
else
    cd $code_path && svn update 
    cd $work_path
    echo $newest_reversion > $current_reversion_log
fi

#build flow
build_flow > $build_log 2>&1 || { 
echo -e "\033[32m build fail!!!!!!!! \033[0m"
#set the flag
build_success=false 
}

#move the build.log and image to out_path
cd $work_path
if [[ $build_success == false ]]; then
    image_out_path=$out_path/`date +%Y%m%d_%H%M`_${newest_reversion}_false
    mkdir -p $image_out_path
    mv $build_log  $image_path/* $image_out_path
else
    image_out_path=$out_path/`date +%Y%m%d_%H%M`_$newest_reversion
    mkdir -p $image_out_path
    mv $build_log  $image_path/* $image_out_path
fi

#end to build code
echo -e "### `date +%Y%m%d\ %H:%M:%S` end to build $code_path"
