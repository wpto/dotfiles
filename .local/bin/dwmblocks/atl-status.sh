log=$XDG_DATA_HOME/atl/log

n=$(cat $log | tail -n 1)
n_status=$(echo $n | awk -F, '{print $1}')
n_time=$(echo $n | awk -F, '{print $2}')
n_act=$(echo $n | awk -F, '{print $3}')

diff=$(($(date "+%s") - n_time))
icon= [ $n_status = 'start' ] && icon="💚" || icon="💤"

seconds=$((diff % 60))
minutes=$((diff / 60 % 60))
hours=$((diff / 3600))

total=0
is_start=0
last_act=""

if [ $icon="💚" ] ; then
  if [ $n_act != 'anki' ] ; then
    mins=$(date "+%M")
    if [ $mins -le 1 ] && [ $mins -gt 0 ]; then
      now=$(date "+%s")
      echo "end,$((now - 1)),$n_act" >> $log
      echo "start,$now,anki" >> $log
      pkill -RTMIN+15 dwmblocks
      exit 0
    fi
  else
    dd=$(($(date "+%s") - n_time))

    if [ $dd -gt 100 ]; then
      now=$(date "+%s")
      n2=$(cat $log | tail -n 2 | head -n 1)
      n2_status=$(echo $n2 | awk -F, '{print $1}')
      n2_act=$(echo $n2 | awk -F, '{print $3}')
      echo "end,$((now - 1)),anki" >> $log
      echo "start,$now,$n2_act" >> $log # hopes that anki dont run twice which couldn't...
      pkill -RTMIN+15 dwmblocks
      exit 0
    fi
  fi
fi


if [ $minutes = '0' ]; then
  time="${seconds}s"
elif [ $hours = '0' ]; then
  time="${minutes}m ${seconds}s"
else
  time="${hours}h ${minutes}m"
fi

echo "${icon} ${time} ${n_act}"
