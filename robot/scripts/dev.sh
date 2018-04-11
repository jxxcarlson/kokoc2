color=`tput setaf 48`
reset=`tput setaf 7`

echo
echo "${color}Use dev configuration.${reset}"
# cp ./robot/src/dev/Configuration.elm ./src/
# cp ./robot/src/dev/webpack.config.js ./src/

echo
echo "${color}Compiling${reset}"

start=`date +%s`
elm make src/Main.elm --debug --output ./dist/main.js
end=`date +%s`

runtime=$((end-start))

echo 'Runtime ' $runtime ' seconds'

echo "${color}Copying files${reset}"
cp index.html ./dist/index.html
