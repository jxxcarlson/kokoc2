color=`tput setaf 48`
magenta=`tput setaf 5`
reset=`tput setaf 7`

echo
echo "${color}Use dev configuration.${reset}"

echo
echo "${magenta}Compiling .."


time elm make src/Main.elm --debug --output ./dist/main.js


echo "${reset}"
