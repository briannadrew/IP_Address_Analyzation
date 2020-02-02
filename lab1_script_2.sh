#!/bin/bash

############################################################################
#                                                                          #
#  IP Address Log Analyzation                                              #
#                                                                          #
#  Name: lab1_scipt_2.sh                                                   #
#                                                                          #
#  Written By: Brianna Drew                                                #
#                                                                          #
#  Date Created: January 15th, 2020                                        #
#                                                                          #
#  Last Modified: January 29th, 2020                                       #
#                                                                          #
#  Usage: ./lab1_scipt_2.sh $directory containing IP log files             #
#         (e.g. ./lab1_script_2.sh /home/COIS/3380/secure*)                #
#                                                                          #
#  Purpose: First, find all IP addresses within log files passed through   #
#           the command line that generate authentication failures. Then,  #
#           determine the top 10 most frequent IP addresses out of those   #
#           and redirect them to a temporary text file. Finally, determine #
#           the geolocation of the top 2 most frequent IP addresses.       #
#                                                                          #
#  Description of Parameters:                                              #
#     - $@ ~ wildcard for multiple IP log files                            #
#                                                                          #
############################################################################

#Note: Use temp.txt file as temp file

#remove old top_ten_ip.txt file
FILE=top_ten_ip.txt
if [ -f "$FILE" ]; then
    rm top_ten_ip.txt
fi

#remove old i.p. files
logfiles=(*.*.*.*)
if [[ -f ${logfiles[0]} ]]
then
  rm *.*.*.*
fi

#Get wildcard log files and one by one filter by authentication failure
#and then remove by filtering everything but i.p. address in each line.
#Append all output to temp.txt which now contains only i.p. addreesses of lines
#that have authentication failure.

for file in "$@"; do
	cat $file | grep 'authentication failure' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' >> temp.txt
done

#From temp.txt file, count multiple occurrances of each I.P. Address using uniq and then
#sort to send outout I.P. address with a number indicating number of occurences ordered by most
#to Head (with default of 10 lines for Head)
#and thus sorting out top 10 and placing in the top_ten_ip.txt file.

printf "\n"
echo "Top Ten"
echo "-------"
sort temp.txt | uniq -c | sort -nr | head > top_ten_ip.txt
rm temp.txt
cat top_ten_ip.txt

#Find info for top 2 urls
var1=$(head -n 1 top_ten_ip.txt | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
#echo $var1
var2=$(head -n 2 top_ten_ip.txt | tail -n 1 | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
#echo $var2
printf "\n\n"
#get info on first I.P. address from  ipinfo.io and place in a file with same name as first I.P. Address
curl -O http://ipinfo.io/$var1
#Display contents of file named as per above I.P. Address
printf "\n"
cat $var1
printf "\n\n\n\n"
#get info on second I.P. address from  ipinfo.io and place in a file with same name as second I.P. Address
curl -O http://ipinfo.io/$var2
#Display contents of file named as per above I.P. Address
printf "\n"
cat $var2
printf "\n\n"

#List top 2 files in the directory
pwd
ls -al *.*.*.*
