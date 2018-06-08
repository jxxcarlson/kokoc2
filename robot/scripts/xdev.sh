# dev.sh: Compile for development

color=`tput setaf 48`
magenta=`tput setaf 5`
reset=`tput setaf 7`

if [ "$1" = "-c" ]
then
echo
echo "${color}Use dev configuration ... copying${reset}"
cp ./robot/src/dev/Configuration.elm ./src/Configuration.elm
cp ./robot/src/dev/Main.elm ./src/Main.elm
fi


echo
echo "${color}Compiling${reset}"
start=`date +%s`
/Users/carlson/Downloads/elm make src/Main.elm  --output ./dist-local/main.js
end=`date +%s`
runtime=$((end-start))
echo
echo "${magenta}Compile time: " $runtime " seconds${reset}"
