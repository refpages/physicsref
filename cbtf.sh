#!/bin/bash 

if [ -z "$1" ]; then
    echo -e "Specify location of GitHub repo. Example: . cbtf.sh \$HOME/Documents/GitHub"
    return 1
fi

# BUILD PAGES AND MODIFY LINKS
npm run astro build
python3 cbtf.py

# MOVE PAGES TO RESPECTIVE REPOS AND COMMIT
# THIS ARRAY CONTAINS REPO NAMES
declare -a courses=("pl-tam210" "pl-tam212" "pl-tam251")

for c in "${courses[@]}"
do
    echo "Course: $c"
    cd "$1/$c"
    git switch master
    git stash
    git pull --rebase
    scp -r "$1/physicsref/dist" "$1/$c/clientFilesCourse/"
    rm -rf "clientFilesCourse/physicsref"
    mv "clientFilesCourse/dist" "clientFilesCourse/physicsref" 
    git add -A
    git commit -m "Updated reference pages"
    git push
done

cd "$1/physicsref"