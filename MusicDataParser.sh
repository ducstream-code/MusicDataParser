#!/bin/bash

declare -i ID=0

for i in titre.mp3 
 do
ID=$((ID+1))


echo Parsing $i datas
ffmpeg -i $i -f ffmetadata data.txt 2> /dev/null
TITLE=$(cat data.txt | grep 'title=' | cut -d= -f2 | cut -d' ' -f1 )
ARTIST=$(cat data.txt | grep ^artist | cut -d= -f2 )
ALBUM=$(cat data.txt | grep 'album=' | cut -d= -f2 ) 
DATE=$(cat data.txt | grep 'date=' |cut -d= -f2 )
GENRE=$(cat data.txt | grep 'genre=' | cut -d= -f2 ) 
LOCATION=$(readlink -f $i )
IMAGE=$(readlink -f $i )

#echo $ID,$TITLE,$ARTIST,$ALBUM,$DATE,$GENRE,$LOCATION,$IMAGE

echo INSERT INTO \`musics\` \(\`id\`, \`title\`, \`artist\`, \`album\`, \`date\`, \`genre\`, \`location\`, \`image\`\) VALUES \($ID, \'$TITLE\',\'$ARTIST\',\'$ALBUM\',$DATE,\'$GENRE\',\'$LOCATION\',\'$IMAGE\'\) >> musicList.sql
rm data.txt
done
