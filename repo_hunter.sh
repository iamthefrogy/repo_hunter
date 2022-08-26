#!/bin/bash

echo "What topic you are interested in?"
read input
input1=`echo $input | tr '[:upper:]' '[:lower:]'| tr " " "+"`
topic=`echo $input1 | tr " " "+"`
repos=$(curl -s "https://api.github.com/search/repositories?q=stars%3A%3E50+$topic+pushed%3A%3E2022-01-01+sort:stars+in%3Aname" | jq -r '.items[].full_name')
if [ -e repo_list.txt ] ; then
        rm repo_list.txt
else
        :
fi
for repo in $repos
do
echo "Checking $repo" | tee -a repo_list.txt
folder=`echo $repo | cut -d "/" -f2`
if [ -d "$folder" ]; then
  echo -e "\e[36mRepo exists, updating...\e[0m"
  cd $folder
  git pull -q
  cd ..
else
  echo -e "\e[92mRepo does not exist, clonning...\e[0m"
  git clone "https://github.com/$repo" -q
fi
done


if [ -e repo_list.txt ] ; then
        echo -e "\e[93mTotal repos found: \e[32m$(cat repo_list.txt | wc -l)\e[0m"
        echo -e "\e[93mList of Repos:\e[0m"
        cat repo_list.txt | cut -d " " -f2
else
        :
fi
