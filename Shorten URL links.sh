#Created by Leo Taffazoli
#This code asks the user to enter the filepath to a csv file willed with URLs
#which it will then generate a new file that replaces the URLs with much shorter ones from Tinyurl API

#Created: 03/07/2020
#Updated: 02/10/2022

#Enter the file path of the csv file
#For example: H:\person1\Urval(4).csv
clear;
echo -n "Enter your filepath and press [ENTER]: "
read -r orig
echo "Loading...";

#It adds slahes and get the file destination so it could enter
reworked=${orig//[\]/\\}
destination=$(echo "$reworked" | sed 's|\(.*\)\\.*|\1|')
cd $destination


#Checks if a completed file already exists. If it exists, it gets deleted.
FILE=log.csv
if [[ -f "$FILE" ]]; then
    rm log.csv;
fi

#Getting the file name and copies its header to the new file.
omShantiOm=$(echo "$reworked" | sed 's/.*\\//')
benshap=$(cat $omShantiOm);
headingThisWay=$(head -n 1 $omShantiOm);

echo "$headingThisWay" >> log.csv

echo "Starting converting links...";

#This will go through every row in the file.
nimps=0;
for comment in $benshap; do
	if [[ $comment == *"http"* ]]; 
	then
		#If a URL value exists in the file, seperate it,
		char=";";
		cutNumb=$(awk -F"${char}" '{print NF-1}' <<< "${comment}");
		for ((cN=1;cN<=$cutNumb + 1;cN++)); do
		selectedURL="$(cut -d';' -f$cN <<<"$comment")";
			if [[ $selectedURL == *"http"* ]]; 
			then
				#combine the link with the tinyurl code,
				defaultURL="https://tinyurl.com/api-create.php?url";
				ourURL="$defaultURL=$selectedURL";
				
				#use curl to see the web value and get the new URL
				content=$(curl -L $ourURL);
				
				#and then replace the old URL with the new in a file called log.csv
				echo "${comment/$selectedURL/$content}" >> log.csv;
				nimps=$((nimps+1))
				if [[ "$nimps" =~ '0'$ ]]; 
				then
					echo "";
					echo "      $nimps completed";
					#In every 1000 url, the process sleeps in 10 seconds to prevent overflowing the API with requests.
					if [[ "$nimps" =~ '000'$ ]]; 
					then
						echo "      Let us wait for 10 seconds";
						sleep 10s
						echo "      There, now we continue! :)";
					fi
					echo "";
				fi
			fi
		done
	fi
done;


#When its done, it will keep telling the user to exist manually.
echo "Complete!";
echo "Press any key to continue"
while [ true ] ; do
read -t 3 -n 1
if [ $? = 0 ] ; then
exit ;
else
echo "waiting for the keypress"
fi
done


#Dummy code for the future
# echo "$content; `date`; checkout,$Time_checkout; ${#len}" >> log.csv
# echo "$content; `date`; add, $Time_add; ${#len}" >> log.csv
# echo "$content; `date`; cimmit, $Time_commits; ${#len}" >> log.csv

# long="USCAGol.blah.blah.blah";
# short="${long:1:3}" ;
# echo "${short}"
