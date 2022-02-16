#!/bin/bash

#Note: for .flac file command metaflac

#TODO check if user is sudo if not exit

#remove whitespaces in files in the folder
FILE="data.txt"
FILE2="musicList.sql"
if test -f "$FILE"; then
    rm $FILE
fi

if test -f "$FILE2"; then
    rm $FILE2
fi


#database creation query if not exists
echo "CREATE TABLE IF NOT EXISTS \`musics\` (
  \`id\` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  \`title\` varchar(255) NOT NULL,
  \`artist\` varchar(255) NOT NULL,
  \`album\` varchar(255) NOT NULL,
  \`date\` int(11) NOT NULL,
  \`genre\` varchar(255) NOT NULL,
  \`location\` varchar(255) NOT NULL,
  \`image\` varchar(255) NOT NULL,
  \`duration\` int(10) DEFAULT 0

) ENGINE=InnoDB DEFAULT CHARSET=utf8;" >> musicList.sql\

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

DURATION=$(mp3info -p "%S\n" $i | awk 'BEGIN { s = 0 }; { s = s + $1 }; END { print s }' )

#echo $ID,$TITLE,$ARTIST,$ALBUM,$DATE,$GENRE,$LOCATION,$IMAGE,$DURATION

echo INSERT INTO \`musics\` \(title, artist, album, date, genre, location, image, duration\) VALUES \(\"$TITLE\",\"$ARTIST\",\"$ALBUM\",$DATE,\"$GENRE\",\"$LOCATION\",\"$IMAGE\",$DURATION\)\; >> musicList.sql
rm data.txt


done
