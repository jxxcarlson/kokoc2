# dev.sh: Compile for development

color=`tput setaf 48`
magenta=`tput setaf 5`
reset=`tput setaf 7`

echo
echo "${color}Use dev configuration ... copying${reset}"
cp ./robot/src/dev/Configuration.elm ./src/Configuration.elm

echo
echo "${color}Compiling${reset}"

start=`date +%s`
elm make src/Main.elm --debug --output ./dist-local/main.js
end=`date +%s`
runtime=$((end-start))

echo "${magenta}Compile time: " $runtime " seconds${reset}"

echo
echo "${color}Copying files${reset}"
cp index.html ./dist-local/index.html
