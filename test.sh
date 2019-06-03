#! /bin/bash
#set -ue
input=$1
base=${input%.*}

mix jack_compiler $@
echo Compile complete.
if [[ ${input} == ${base} ]]; then
    base=${base}/$(basename ${base})
fi
~/git/nand2tetris/tools/TextComparer.bat ${base}.xml ${base}_out.xml

# test=${base}.tst
# ~/git/nand2tetris/tools/CPUEmulator.sh ${test}
# echo cmp
# cat ${base}.cmp
# echo out
# cat ${base}.out
