
CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

if  [[ -f student-submission/ListExamples.java ]]
then 
    echo ""
else
     echo -e "File not found.\nFinal score: 0%"
    exit
fi

cp student-submission/* grading-area/
cp TestListExamples.java grading-area/


# javac -cp $CPATH *.java
error_output=$(javac -cp $CPATH grading-area/*.java 2>&1)
if [[ $? -ne 0 ]]
then 
    echo -e "There was an error:\n$error_output\nFinal score: 0%"
else
    cd grading-area
    java -cp ../lib/hamcrest-core-1.3.jar:../lib/junit-4.13.2.jar:. org.junit.runner.JUnitCore TestListExamples | grep -m 1 -A1 "JUnit" > results.txt

    second_line=$(sed -n '2p' results.txt)

    # Count the number of dots in the second line
    total=$(grep -o '\.' <<< "$second_line" | wc -l)

    # Count the number of 'E's in the second line
    e_count=$(grep -o 'E' <<< "$second_line" | wc -l)

    # Output the counts
    # echo "Number of dots: $dot_count"
    # echo "Number of E's: $e_count"

    success=$(( total - e_count  ))
    percentage=$((success * 100 / total))
    echo "Final score: $percentage%"
fi








# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests
