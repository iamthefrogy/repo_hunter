#!/bin/bash

# Set up color variables
YELLOW='\033[1;93m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${YELLOW}What topic are you interested in?${NC}"
read input
topic=$(echo $input | tr '[:upper:]' '[:lower:]' | tr " " "+")

# Fetch the total count of repositories
response=$(curl -s "https://api.github.com/search/repositories?q=stars%3A%3E50+$topic+sort:stars+in%3Aname&per_page=5")
tpc=$(echo "$response" | jq -r '.total_count')

# Check if total_count is null or empty
if [[ -z "$tpc" || "$tpc" == "null" ]]; then
    echo -e "${YELLOW}Sorry, no results found${NC}"
    exit 1
fi

# Calculate the number of pages needed, rounding up
pg=$(( (tpc + 4) / 5 ))

for i in $(seq 1 $pg);
do
    # Fetch repositories for each page
    repos=$(curl -s "https://api.github.com/search/repositories?q=stars%3A%3E50+$topic+sort:stars+in%3Aname&per_page=5&page=$i" | jq -r '.items[]?.html_url')
    if [[ -z "$repos" || "$repos" == "null" ]]; then
        break  # Stop the loop if no repositories are returned
    fi
    echo "$repos" | tee -a $topic-repos.txt
done

if [ -e $topic-repos.txt ] ; then
    echo -e "${YELLOW}Total repos found: ${GREEN}$(cat $topic-repos.txt | wc -l)${NC}"
fi
