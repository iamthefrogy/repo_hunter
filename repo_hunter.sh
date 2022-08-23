#!/bin/bash

echo "What topic you are interested in?"
read input
input1=`echo $input | tr '[:upper:]' '[:lower:]'| tr " " "+"`
topic=`echo $input1 | tr " " "+"`
repos=$(curl -s "https://api.github.com/search/repositories?q=$topic&sort=stars&order=desc" | jq -r '.items[].full_name')
for repo in $repos
do
echo "Checking $repo"
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
