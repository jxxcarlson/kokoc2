

color=`tput setaf 48`
reset=`tput setaf 7`

echo
echo "${color}Copying source files to MeenyLatex package${reset}"

cp src/MeenyLatex/Accumulator.elm ../MeenyLatex/src/MeenyLatex/
cp src/MeenyLatex/Configuration.elm ../MeenyLatex/src/MeenyLatex/
cp src/MeenyLatex/Differ.elm ../MeenyLatex/src/MeenyLatex/
cp src/MeenyLatex/Driver.elm ../MeenyLatex/src/MeenyLatex/
cp src/MeenyLatex/HasMath.elm ../MeenyLatex/src/MeenyLatex/
cp src/MeenyLatex/KeyValueUtilities.elm ../MeenyLatex/src/MeenyLatex/
cp src/MeenyLatex/LatexDiffer.elm ../MeenyLatex/src/MeenyLatex/
cp src/MeenyLatex/LatexState.elm ../MeenyLatex/src/MeenyLatex/
cp src/MeenyLatex/Paragraph.elm ../MeenyLatex/src/MeenyLatex/
cp src/MeenyLatex/Parser.elm ../MeenyLatex/src/MeenyLatex/
cp src/MeenyLatex/ParserTools.elm ../MeenyLatex/src/MeenyLatex/
cp src/MeenyLatex/Render.elm ../MeenyLatex/src/MeenyLatex/
cp src/MeenyLatex/RenderToLaTex.elm ../MeenyLatex/src/MeenyLatex/
cp src/MeenyLatex/Image.elm ../MeenyLatex/src/MeenyLatex/
cp src/MeenyLatex/Html.elm ../MeenyLatex/src/MeenyLatex/
cp src/MeenyLatex/JoinStrings.elm ../MeenyLatex/src/MeenyLatex/
cp src/MeenyLatex/RenderLatexForExport.elm ../MeenyLatex/src/MeenyLatex/
cp src/MeenyLatex/FastExportToLatex.elm ../MeenyLatex/src/MeenyLatex/
cp src/MeenyLatex/Utility.elm ../MeenyLatex/src/MeenyLatex/
cp src/MeenyLatex/Source.elm ../MeenyLatex/src/MeenyLatex/
cp src/MeenyLatex/StateReducerHelpers.elm ../MeenyLatex/src/MeenyLatex/
cp src/MeenyLatex/ParserHelpers.elm ../MeenyLatex/src/MeenyLatex/
cp src/MeenyLatex/ErrorMessages.elm ../MeenyLatex/src/MeenyLatex/




cp src/MeenyLatex/Accumulator.elm ../MeenyLatexTester/src/MeenyLatex/
cp src/MeenyLatex/Configuration.elm ../MeenyLatexTester/src/MeenyLatex/
cp src/MeenyLatex/Differ.elm ../MeenyLatexTester/src/MeenyLatex/
cp src/MeenyLatex/Driver.elm ../MeenyLatexTester/src/MeenyLatex/
cp src/MeenyLatex/HasMath.elm ../MeenyLatexTester/src/MeenyLatex/
cp src/MeenyLatex/KeyValueUtilities.elm ../MeenyLatexTester/src/MeenyLatex/
cp src/MeenyLatex/LatexDiffer.elm ../MeenyLatexTester/src/MeenyLatex/
cp src/MeenyLatex/LatexState.elm ../MeenyLatexTester/src/MeenyLatex/
cp src/MeenyLatex/Paragraph.elm ../MeenyLatexTester/src/MeenyLatex/
cp src/MeenyLatex/Parser.elm ../MeenyLatexTester/src/MeenyLatex/
cp src/MeenyLatex/ParserTools.elm ../MeenyLatexTester/src/MeenyLatex/
cp src/MeenyLatex/Render.elm ../MeenyLatexTester/src/MeenyLatex/
cp src/MeenyLatex/RenderToLatex.elm ../MeenyLatexTester/src/MeenyLatex/
cp src/MeenyLatex/Image.elm ../MeenyLatexTester/src/MeenyLatex/
cp src/MeenyLatex/Html.elm ../MeenyLatexTester/src/MeenyLatex/
cp src/MeenyLatex/JoinStrings.elm ../MeenyLatexTester/src/MeenyLatex/
cp src/MeenyLatex/RenderLatexForExport.elm ../MeenyLatexTester/src/MeenyLatex/
cp src/MeenyLatex/FastExportToLatex.elm ../MeenyLatexTester/src/MeenyLatex/
cp src/MeenyLatex/Source.elm ../MeenyLatexTester/src/MeenyLatex/
cp src/MeenyLatex/Utility.elm ../MeenyLatexTester/src/MeenyLatex/
cp src/MeenyLatex/StateReducerHelpers.elm ../MeenyLatexTester/src/MeenyLatex/
cp src/MeenyLatex/ParserHelpers.elm ../MeenyLatexTester/src/MeenyLatex/
cp src/MeenyLatex/ErrorMessages.elm ../MeenyLatexTester/src/MeenyLatex/
 



echo
echo "${color}Copying README to MeenyLatex package${reset}"

cp src/MeenyLatex/README.MD ../MeenyLatex/
cp src/MeenyLatex/README.MD ../MeenyLatexTester/


echo
echo "${color}Copying tests files to MeenyLatex package${reset}"


cp tests/AccumulatorTest.elm ../MeenyLatex/tests/
cp tests/DifferTest.elm ../MeenyLatex/tests/
cp tests/ParserTest.elm ../MeenyLatex/tests/
cp tests/RenderTest.elm ../MeenyLatex/tests/
cp tests/DriverTest.elm ../MeenyLatex/tests/

cp tests/AccumulatorTest.elm ../MeenyLatexTester/tests/
cp tests/DifferTest.elm ../MeenyLatexTester/tests/
cp tests/ParserTest.elm ../MeenyLatexTester/tests/
cp tests/RenderTest.elm ../MeenyLatexTester/tests/
cp tests/DriverTest.elm ../MeenyLatexTester/tests/

echo
echo "${color}Done${reset}"
