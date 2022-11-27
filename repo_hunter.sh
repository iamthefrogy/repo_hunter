#!/bin/bash

echo -e "\e[93mWhat topic you are interested in?\e[0m"
read input
input1=`echo $input | tr '[:upper:]' '[:lower:]'| tr " " "+"`
topic=`echo $input1 | tr " " "+"`

tpc=$(curl -s "https://api.github.com/search/repositories?q=stars%3A%3E50+$topic+sort:stars+in%3Aname&per_page=5" | jq -r '.total_count')

if [ -z "$tpc" ]
then
        echo "Sorry, no results found"
        exit 1
else
        pg=$(($tpc/5))
fi

for i in $(seq 1 $pg);
do
repos=$(curl -s "https://api.github.com/search/repositories?q=stars%3A%3E50+$topic+sort:stars+in%3Aname&per_page=5&page=$i" | jq -r '.items[].html_url')
echo "$repos" | tee -a $topic-repos.txt
done

if [ -e $topic-repos.txt ] ; then
        echo -e "\e[93mTotal repos found: \e[32m$(cat $topic-repos.txt | wc -l)\e[0m"
else
        :
fi
