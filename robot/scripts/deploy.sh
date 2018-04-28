

color=`tput setaf 48`
red=`tput setaf 1`
reset=`tput setaf 7`


echo
echo "${color}Compiling${reset}"

start=`date +%s`
elm make src/Main.elm --debug --output ./dist/main.js
end=`date +%s`
runtime=$((end-start))

echo "size of main.js:"
ls -lh ./dist/main.js

echo
echo "${color}Uglifying${reset}"
uglifyjs ./dist/main.js -mc 'unsafe_comps=true,unsafe=true,pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9"' > ./dist/main.min.js
echo "size of main.js after uglification"
ls -lh ./dist/main.min.js
mv ./dist/main.min.js ./dist/main.js
echo
echo "${color}Compressing${reset}"
gzip ./dist/main.js
ls -lh ./dist/main.js.gzip

echo
echo "${color}upload to cloud ...${reset}"
scp -r ./dist/* root@138.197.81.6:/var/www/html/

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
