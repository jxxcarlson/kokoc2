# dev.sh: Compile for development

color=`tput setaf 48`
magenta=`tput setaf 5`
reset=`tput setaf 7`

echo
echo "${color}Use dev configuration.${reset}"

echo
echo "${color}Compiling${reset}"

start=`date +%s`
elm make src/Main.elm --debug --output ./dist/main.js
end=`date +%s`
runtime=$((end-start))

echo "${magenta}Compile time: " $runtime " seconds${reset}"

echo
echo "${color}Copying files${reset}"
cp index.html ./dist/index.html
