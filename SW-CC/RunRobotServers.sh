#!
export PATH=/mnt/Projects/Robot/tools/bin:${PATH}
export LD_LIBRARY_PATH=/mnt/Projects/Robot/SW/lib:$LD_LIBRARY_PATH
cd ./SW-Modules/SerialComm; ./SerialComm.x &
cd ../..
sleep 1
cd ./SW-Modules/MotionControl; ./MotionControl.x &
cd ../..
sleep 1
cd ./SW-Modules/CameraMotionControl; ./CameraMotionControl.x &
cd ../..
sleep 1
echo "Everything READY..."
