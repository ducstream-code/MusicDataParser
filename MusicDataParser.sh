#!/bin/bash

#Note: for .flac file command metaflac

#TODO check if user is sudo if not exit

#remove whitespaces in files in the folder
find . -name "* *" -type f | rename 's/ /_/g'


declare -i ID=0

for i in *.mp3 
 do
ID=$((ID+1))


echo Parsing $i datas
ffmpeg -i $i -f ffmetadata data.txt 2> /dev/null
TITLENotSain=$(cat data.txt | grep 'title=' | cut -d= -f2 | cut -d'(' -f1 >title1.ns )

#removing ' from string with \'
sed s/\'/"\\\'"/ title1.ns > title2.ns
TITLE=$(cat title2.ns)

ARTISTns=$(cat data.txt | grep ^artist | cut -d= -f2 >artist1.ns )
sed s/\'/"\\\'"/ artist1.ns > artist2.ns

ARTIST=$(cat artist2.ns)

ALBUMns=$(cat data.txt | grep 'album=' | cut -d= -f2 >album1.ns )
sed s/\'/"\\\'"/ album1.ns > album2.ns

ALBUM=$(cat album2.ns)
 
DATEns=$(cat data.txt | grep 'date=' |cut -d= -f2 >date1.ns )
sed s/\'/"\\\'"/ date1.ns > date2.ns

DATE=$(cat date2.ns)


GENREns=$(cat data.txt | grep 'genre=' | cut -d= -f2 >genre1.ns) 
sed s/\'/"\\\'"/ genre1.ns > genre2.ns

GENRE=$(cat genre2.ns)

LOCATIONns=$(readlink -f $i > location1.ns )
sed s/\'/"\\\'"/ location1.ns > location2.ns
LOCATION=$(cat location2.ns)


IMAGEns=$(readlink -f $i > image1.ns )
sed s/\'/"\\\'"/ image1.ns > image2.ns
IMAGE=$(cat image2.ns)

#echo $ID,$TITLE,$ARTIST,$ALBUM,$DATE,$GENRE,$LOCATION,$IMAGE

echo INSERT INTO \`musics\` \(\`id\`, \`title\`, \`artist\`, \`album\`, \`date\`, \`genre\`, \`location\`, \`image\`\) VALUES \($ID, \'$TITLE\',\'$ARTIST\',\'$ALBUM\',$DATE,\'$GENRE\',\'$LOCATION\',\'$IMAGE\'\)\; >> musicList.sql
rm data.txt
rm *.ns
done
