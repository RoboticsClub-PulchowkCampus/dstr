#*
#* test.sh
#*
#* Created: 12/3/2019
#*  Author: n-is
#*   Email: 073bex422.nischal@pcampus.edu.np
#*

#!/bin/sh

# Build Static Library in the root folder
cd ../
make
cd Tests/

# Build the test and run it
make tests
