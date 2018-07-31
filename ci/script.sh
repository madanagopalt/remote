#!/bin/sh

BUILDLOGS=$TRAVIS_BUILD_DIR/buildlogs
EXECLOGS=$TRAVIS_BUILD_DIR/execlogs

touch $BUILDLOGS
touch $EXECLOGS

checkError()
{
  if [ "$1" -ne 0 ]
  then
    printf "\n\n*********************************************************************";
    printf "\n********************* SCRIPT FAIL DETAILS *****************************";
    printf "\nCI failure reason: $2"
    printf "\nCause: $3"
    printf "\nReproduction/How to fix: $4"
    printf "\n*********************************************************************";
    printf "\n*********************************************************************\n\n";
    cat "$5"
    exit 1
  fi
}

./ci/build.sh 2&>$BUILDLOGS
checkError $? "Build failed" "Build problem" "Analyze corresponding log file" $BUILDLOGS

./ci/run.sh 2&>$EXECLOGS

cat $EXECLOGS
echo "printed exec logs"
checkError $? "Execution failed" "Execution problem" "Analyze corresponding log file" $EXECLOGS

exit 0;
