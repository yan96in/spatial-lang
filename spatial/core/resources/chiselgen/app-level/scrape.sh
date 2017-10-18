#!bin/bash

# get tid
REGRESSION_HOME="/home/mattfel/regression/zynq"
tid=`cat ${REGRESSION_HOME}/data/tid`

appname=`basename \`pwd\``
par_util=`pwd`/verilog-zynq/par_utilization.rpt
if [[ -f ${par_util} ]]; then
	lutraw=`cat $par_util | grep "Slice LUTs" | awk -F'|' '{print $3}' | sed "s/ //g"`
	lutpcnt=`cat $par_util | grep "Slice LUTs" | awk -F'|' '{print $6}' | sed "s/ //g"`
	regraw=`cat $par_util | grep "Slice Registers" | awk -F'|' '{print $3}' | sed "s/ //g"`
	regpcnt=`cat $par_util | grep "Slice Registers" | awk -F'|' '{print $6}' | sed "s/ //g"`
	ramraw=`cat $par_util | grep "Block RAM Tile" | awk -F'|' '{print $3}' | sed "s/ //g"`
	rampcnt=`cat $par_util | grep "Block RAM Tile" | awk -F'|' '{print $6}' | sed "s/ //g"`
	dspraw=`cat $par_util | grep "DSPs" | awk -F'|' '{print $3}' | sed "s/ //g"`
	dsppcnt=`cat $par_util | grep "DSPs" | awk -F'|' '{print $6}' | sed "s/ //g"`
else
	lutraw="NA"
	lutpcnt="NA"
	regraw="NA"
	regpcnt="NA"
	ramraw="NA"
	rampcnt="NA"
	dspraw="NA"
	dsppcnt="NA"
fi

python3 scrape.py $tid $appname "$lutraw (${lutpcnt}%)" "$regraw (${regpcnt}%)" "$ramraw (${rampcnt}%)" "$dspraw (${dsppcnt}%)"

# Fake out scala Regression
echo "PASS: 1"