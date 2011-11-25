FILES="binding.html FAQ.html install.html wxlua.html"
DIR=../docs

for f in $FILES; do echo $DIR/$f; tidy -q -e $DIR/$f; done

echo
read -p "Run tidy on all the files? (y/n)?"

if [ "$REPLY" == "y" ]; then

    for f in $FILES; do echo $DIR/$f; tidy -q -i -u -w 80 -m $DIR/$f; done

fi
