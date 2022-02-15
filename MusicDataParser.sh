#!/bin/bash

#Note: for .flac file command metaflac

#TODO check if user is sudo if not exit

#remove whitespaces in files in the folder
rm data.txt
rm musicList.sql
find . -name "* *" -type f | rename 's/ /_/g'


declare -i ID=0

for i in *.mp3 
 do
ID=$((ID+1))


echo Parsing $i datas

ffmpeg -i $i -f ffmetadata data.txt 2> /dev/null
TITLE=$(cat data.txt | grep 'title=' | cut -d= -f2 | cut -d'(' -f1| tr -d \" )

ARTIST=$(cat data.txt | grep ^artist | cut -d= -f2 | tr -d \"  )

ALBUM=$(cat data.txt | grep 'album=' | cut -d= -f2 | tr -d \" )

 
DATE=$(cat data.txt | grep 'date=' |cut -d= -f2 | tr -d \"  )



GENRE=$(cat data.txt | grep 'genre=' | cut -d= -f2 | tr -d \" ) 

LOCATION=$(readlink -f $i | tr -d \"  )



IMAGE=$(readlink -f $i | tr -d \"  )


#echo $ID,$TITLE,$ARTIST,$ALBUM,$DATE,$GENRE,$LOCATION,$IMAGE

echo INSERT INTO \`musics\` \(id, title, artist, album, date, genre, location, image\) VALUES \($ID, \"$TITLE\",\"$ARTIST\",\"$ALBUM\",$DATE,\"$GENRE\",\"$LOCATION\",\"$IMAGE\"\)\; >> musicList.sql
rm data.txt


done
