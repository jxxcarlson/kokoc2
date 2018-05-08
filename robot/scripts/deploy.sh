

color=`tput setaf 48`
magenta=`tput setaf 5`
red=`tput setaf 1`
reset=`tput setaf 7`


if [ "$1" = "-c" ]
then
echo
echo "${color}Use DEPLOYMENT configuration ... copying${reset}"
cp ./robot/src/deploy/Configuration.elm ./src/Configuration.elm
cp ./robot/src/deploy/Main.elm ./src/Main.elm
fi


echo
echo "${color}Compiling${reset}"
start=`date +%s`
elm make src/Main.elm  --debug --output ./dist/main.js
end=`date +%s`
runtime=$((end-start))
echo
echo "${magenta}Compile time: " $runtime " seconds${reset}"


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
echo "${color}upload to cloud ...${reset}"
scp -r ./dist/main.js root@138.197.81.6:/var/www/html/

echo
tput setaf 2; echo "${color}Done${reset}"
#
# echo
# echo "${color}... Now use dev configuration.${reset}"
# cp ./robot/src/dev/Configuration.elm ./src/
# cp ./robot/src/dev/webpack.config.js ./src/
#
# echo
# echo "${color}Start webpack${reset}"
# yarn start
