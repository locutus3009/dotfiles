# zips all the files in the current directory into a .plasmoid file
packageExt="plasmoid"

### Colors
# https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
# https://stackoverflow.com/questions/911168/how-can-i-detect-if-my-shell-script-is-running-through-a-pipe
TC_Red='\033[31m'; TC_Orange='\033[33m';
TC_LightGray='\033[90m'; TC_LightRed='\033[91m'; TC_LightGreen='\033[92m'; TC_Yellow='\033[93m'; TC_LightBlue='\033[94m';
TC_Reset='\033[0m'; TC_Bold='\033[1m';
if [ ! -t 1 ]; then
	TC_Red=''; TC_Orange='';
	TC_LightGray=''; TC_LightRed=''; TC_LightGreen=''; TC_Yellow=''; TC_LightBlue='';
	TC_Bold=''; TC_Reset='';
fi
function echoTC() {
	text="$1"
	textColor="$2"
	echo -e "${textColor}${text}${TC_Reset}"
}
function echoGray { echoTC "$1" "$TC_LightGray"; }
function echoRed { echoTC "$1" "$TC_Red"; }
function echoGreen { echoTC "$1" "$TC_LightGreen"; }

# read field of json file
if ! type "jq" > /dev/null; then
  echoRed "[error] 'jq' command not found."
  exit 1
fi

plasmoidName=$(jq -r '.KPlugin.Name' package/metadata.json)
plasmoidVersion=$(jq -r '.KPlugin.Version' package/metadata.json)

# change spaces by underscores in the name
plasmoidName=$(echo $plasmoidName | sed 's/ /_/g')

if ! type "zip" > /dev/null; then
	echoRed "[error] 'zip' command not found."
	if type "zypper" > /dev/null; then
		echoRed "[error] Opensuse detected, please run: ${TC_Bold}sudo zypper install zip"
	fi
	exit 1
fi

rm -f $plasmoidName-v*.plasmoid # Cleanup
filename="$plasmoidName-v$plasmoidVersion.$packageExt"
cd package
zip -qr $filename *
mv $filename ..
echoGreen "Plasmoid file created: $filename"
