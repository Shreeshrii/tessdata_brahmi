#!/bin/bash

rm -rf tmp*

shuf  ./brah.tamiltrain.training_text > tmp33.txt

# get freq of chars, max 2
cat ./brah.chars.txt | while IFS="
" read target; do grep -F -m 2 -c "$target"  tmp33.txt; done > tmp0.txt
# combine char with frequency
paste ./brah.chars.txt tmp0.txt > tmp1.txt
# grep chars not there twice, remove tab and frequency number to get missing chars
grep -v 2 tmp1.txt > brah.missing.txt
sed -i -e 's/[0-9]//g' brah.missing.txt
sed -i $'s/\t//g' brah.missing.txt

#create eval text with two sample lines for each of chars 
cat ./brah.chars.txt | while IFS="
" read target; do grep -F -m 2 "$target"  tmp33.txt  ; done > tmp3.txt
sort -u tmp3.txt   > tmp40.txt
shuf tmp40.txt >  ./brah.evalnew.training_text

#remove lines already selected for eval
awk '{if (f==1) { r[$0] } else if (! ($0 in r)) { print $0 } } ' f=1 tmp3.txt f=2 tmp33.txt > tmp00.txt

shuf  tmp00.txt > ./brah.trainnew.training_text

#create training text with max 100 samples of each char from remaining text
###cat ./brah.chars.txt | while IFS="
###" read target; do grep -F -m 100 "$target"  tmp00.txt  ; done > tmp7.txt
###sort -u tmp7.txt   > tmp50.txt
###shuf tmp50.txt > ./brah.training_text
###
###


rm -rf tmp*

