#!/bin/ash
#天翼极速提速脚本
#by weicn.org
#time:2017-1-29 01:52:35

user=
passwd=
#远程提速,socks5代理提远端
#socks="--socks5 10.1.1.5:10801"
cookies="/jffs/telspeed/cookies.txt"

rm -rf $cookies

userlogin=`curl -ks "http://ispeed.ebit.cn/face/user/login.jhtml?phone=$user&passwd=$passwd" -c $cookies $socks`

usertel=`echo $userlogin|grep -oE '[0-9]{11}'`
userid_temp=`echo $userlogin|grep -oE '[0-9]{4}}'`
userid=`echo $userid_temp|grep -oE '[0-9]{4}'`
phonedes=`echo $userlogin|grep -oE '[0-9_a-z]{32}'`



echo "登录用户:$usertel 用户ID:$userid"

isCanSpeedup=`curl -ks "http://ispeed.ebit.cn/speedup2/isCanSpeedup.jhtml" -b $cookies -c $cookies $socks`

speed_ip=`echo $isCanSpeedup|grep -oE '([0-9]{1,3}[\.]){3}[0-9]{1,3}'`

dialacct_temp=`echo ${isCanSpeedup%\",\"basicRateDown*}`
dialacct=`echo ${dialacct_temp##*dialAcct\":\"}`
#echo "$dialacct"

#当前上行速度
basicRateUp_temp=`echo ${isCanSpeedup##*basicRateUp\":\"}`
basicRateUp_temp2=`echo ${basicRateUp_temp%\",\"ip\"*}`
basicRateUp=`echo $(( $basicRateUp_temp2/1024 ))`

#能够提速的最高上行速度
maxLinerateUp0_temp=`echo ${isCanSpeedup##*maxLinerateUp\":\"}`
maxLinerateUp0_temp2=`echo ${maxLinerateUp0_temp%\",\"state\"*}`
maxLinerateUp0=`echo $(( $maxLinerateUp0_temp2/1024 ))`

#当前下行速度
basicRateDown_temp=`echo ${isCanSpeedup##*basicRateDown\":\"}`
basicRateDown_temp2=`echo ${basicRateDown_temp%\",\"maxLinerateUp\"*}`
basicRateDown=`echo $(( $basicRateDown_temp2/1024 ))`

#能够提速的最高下行速度
maxLinerateDown0_temp=`echo ${isCanSpeedup##*maxLinerateDown\":\"}`
maxLinerateDown0_temp2=`echo ${maxLinerateDown0_temp%\",\"dialAcct\"*}`
maxLinerateDown0=`echo $(( $maxLinerateDown0_temp2/1024 ))`

#echo $basicRateUp $maxLinerateUp0 $basicRateDown $maxLinerateDown0

speedup=`curl -ks "http://ispeed.ebit.cn/speedup2/speedup.jhtml?dial_acct=$dialacct&basic_rate_down=$basicRateDown&basic_rate_up=$basicRateUp&max_linerate_down=$maxLinerateDown0&max_linerate_up=$maxLinerateUp0" -b $cookies -c $cookies $socks`

echo $speedup


#{"ip":"","state":-3,"message":"此用户没有登录，并且没有免费的提速时长"}
#{"ip":"","state":-2,"message":"此用户已经没有提速券可以进行使用"}
#{"speedupTime":{"sptimeresult":0,"tsTime":1485623770000,"hours":0.0,"seconds":59,"minutes":59,"tsTime2":"2017-01-29 01:16","endtime":"2017-01-29 02:16","sphour":1},"ip":"","state":0,"message":"提速成功"}
#{"speedupTime":{"sptimeresult":0,"tsTime":1485622744000,"hours":4.0,"seconds":41,"minutes":55,"tsTime2":"2017-01-29 00:59","endtime":"2017-01-29 05:59","sphour":5},"ip":"","state":0,"message":"正在提速"}
