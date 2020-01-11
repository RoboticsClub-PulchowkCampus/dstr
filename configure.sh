#*
#* configure.sh
#*
#* Created: 12/3/2019
#*  Author: n-is
#*   Email: 073bex422.nischal@pcampus.edu.np
#*

#!/bin/bash


if [ "$#" -eq 0 ]
then
        make
else
        for arg in "$@"
        do
                echo
                echo "Executing $arg"

                if [ "$arg" == "-t=arm,win" ]
                then
                        # Check to see if arm-none-eabi toolchain is installed
                        hash arm-none-eabi-gcc 2>/dev/null || {
                                have_arm=true
                                hash arm-none-eabi-gcc.exe 2>/dev/null || {
                                        echo >&2 "I require arm-none-eabi toolchain to build for arm target, but it's not installed.  Aborting."
                                        echo
                                        have_arm=false
                                }

                                if [ "$have_arm" = false ]
                                then
                                        continue
                                fi
                        }
                        make WINDOWS=10 PREFIX=arm-none-eabi-

                elif [ "$arg" == "--clean" ]
                then
                        make clean

                elif [ "$arg" == "--test" ]
                then
                        echo "Running tests in linux target, running test in arm not supported."
                        make rebuild
                        cd Tests
                        make tests
                        cd ..
                else
                        echo "Unsupported Command $arg"
                fi
        done
fi
