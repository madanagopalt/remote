#!/bin/sh
cd $TRAVIS_BUILD_DIR
rm -rf .git
git clone https://github.com/pxscene/pxCore.git

#build rtCore
cd pxCore
mkdir temp
cd temp
cmake -DBUILD_RTCORE_LIBS=ON -DBUILD_PXCORE_LIBS=OFF -DBUILD_PXSCENE=OFF ..
cmake --build .
retVal=$?
if [ "$retVal" -ne 0 ]
then
	exit 1;
fi

#build rtRemote
cd $TRAVIS_BUILD_DIR
pwd
mkdir temp
cd temp
cmake -DCMAKE_CXX_FLAGS=" -I$TRAVIS_BUILD_DIR/pxCore/src/ -L$TRAVIS_BUILD_DIR/pxCore/build/glut/ " -DBUILD_RTREMOTE_SAMPLE_APP_SIMPLE=ON ..
cmake --build . --config Release
retVal=$?
if [ "$retVal" -ne 0 ] 
then
	exit 1;
fi

EXECLOGS=$TRAVIS_BUILD_DIR/execlogs
touch $EXECLOGS
cd $TRAVIS_BUILD_DIR
#run sample apps
count=0
retVal=1
export RT_LOG_LEVEL=info
export LD_LIBRARY_PATH=$TRAVIS_BUILD_DIR/pxCore/build/glut:$LD_LIBRARY_PATH
$TRAVIS_BUILD_DIR/rtSampleServer &
cd $TRAVIS_BUILD_DIR
./rtSampleClient > $EXECLOGS 2>&1 &

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