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

exit 0
