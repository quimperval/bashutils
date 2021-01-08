#!/bin/bash
#Author: Joaquin Perez Valera
#Script to copy mp3 files, listed in a xsdf file, to a destination folder. 

echo "Parsing list of music"

charArray=( "%20-\ " "%28-(" "%29-)" "%C3%B1-ñ" "%C3%9A-Ú" "%C3%B3-ó" "%C3%89-É" "%C3%A1-á" "%C3%BA-ú" "%26-\&" "%3B-;" "%C3%A9-é" "%C3%AD-í" "%25-\%" "%5B-\[" "%5D-\]" "%27-\'" "%2C-\," "%21-!" "%C3%91-Ñ" "%C3%81-Á") 


#Getting the locations from the list, parsing the xml with grep command
readFileContent () {
	grep -oP "<location>(.*)</location>" $1 
}


#Removing location tags from the list.
removeLocationTags () {
	
	trimmed=$( sed 's/<location>//g' <<< $1)
	trimmedTwo=$( sed 's/<\/location>//g' <<< $trimmed)

	trimmedThree=$( sed 's/file:\/\///g' <<< $trimmedTwo ) 
	echo $trimmedThree
}


#Removing utf8 codes of special chars and replacing by special characters, these codes are used by VLC to represent special characters.
removeHexaChars() {
	#echo "special Chars to remove: "${charArray[*]}
	response=$1
	#echo "Removing special chars"	 
	for line in ${charArray[*]}
	do
		IFS="-" read key value <<< $line
		#echo "key: "$key
		if [ $key == "%20" ]; then
			value="\ "
		fi
		
		if [ $key == "%26" ]; then
			value="\&"
		fi

		#echo "value: "$value
		dummy=$( sed -e "s/${key}/${value}/g" <<< $response)
		response=$( echo $dummy)
	done
	
	echo $response
}

destination=$2

initialList=$( readFileContent $1)

counter=0
for line in ${initialList[*]}
do
	#echo "line as is: "$line
	noTags=$( removeLocationTags $line )
	file=$( removeHexaChars $noTags	)
	#echo $file
	counter=$(( counter += 1 ))
	
	#Copying the file to the destination you want
	cp "$file" $destination
done

echo "lines in the var: "$counter

echo "Destino: "$destination

#listFromGrep=$( readFileContent $1)
#removeChars $listFromGrep
 
