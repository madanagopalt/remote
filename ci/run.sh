#!/bin/sh

EXECLOGS=$TRAVIS_BUILD_DIR/execlogs
cd $TRAVIS_BUILD_DIR
#run sample apps
count=0
retVal=1
export RT_LOG_LEVEL=info
export LD_LIBRARY_PATH=$TRAVIS_BUILD_DIR/pxCore/build/glut:$LD_LIBRARY_PATH
$TRAVIS_BUILD_DIR/rtSampleServer &
$TRAVIS_BUILD_DIR/rtSampleClient &

while [ "$count" -ne "10" ]; do
        count=$((count+10))
        sleep 10;
done

kill -15 `ps -ef | grep rtSampleServer|grep -v grep|awk '{print $2}'`
kill -15 `ps -ef | grep rtSampleClient|grep -v grep|awk '{print $2}'`
#need to change
grep "value:1234" $EXECLOGS
retVal=$?
#perform validation
if [ "$retVal" -eq 1 ]
then
  exit 1
fi
exit 0;
