

color=`tput setaf 48`
red=`tput setaf 1`
reset=`tput setaf 7`

echo
echo "${color}Use deploy-local configuration.${reset}"
cp ./robot/src/deploy-local/Configuration.elm ./src/Configuration.elm

echo
echo "${color}Compiling${reset}"

start=`date +%s`
elm make src/Main.elm --debug --output ./dist/main.js
end=`date +%s`
runtime=$((end-start))
echo "YADA!"
echo "runtime: ${runtime}"

echo "./dist/main.js:"
ls -lh ./dist/main.js

# echo
# echo "${color}Uglifying${reset}"
# uglifyjs ./dist/main.js -mc 'unsafe_comps=true,unsafe=true,pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9"' > ./dist/main.min.js
# echo "Uglified main.js:"
# mv ./dist/main.min.js ./dist/main.js
# ls -lh ./dist/main.js
# echo


# echo "${color}Compressing${reset}"
# gzip -f ./dist/main.js
# echo "Compressed & uglified main.js:"
# ls -lh ./dist/main.js.gzip

echo
tput setaf 2; echo "${color}Run server${reset}"

http-server ./dist
#
# echo
# echo "${color}... Now use dev configuration.${reset}"
# cp ./robot/src/dev/Configuration.elm ./src/
# cp ./robot/src/dev/webpack.config.js ./src/
#
# echo
# echo "${color}Start webpack${reset}"
# yarn start
