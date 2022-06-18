var=${1:-modify}

git add .
git commit -m $var
git push -u origin master
