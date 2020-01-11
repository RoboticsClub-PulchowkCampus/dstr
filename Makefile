#*
#* Makefile
#*
#* Created: 12/3/2019
#*  Author: n-is
#*   Email: 073bex422.nischal@pcampus.edu.np
#*

######################################
# target
######################################
TARGET = dstr

######################################
# building variables
######################################
# debug build?
DEBUG = 1
# optimization
OPT = -Og


#######################################
# paths
#######################################
# Build path
BUILD_DIR = Build

######################################
# source
######################################
# C sources
C_SOURCES =  \


# ASM sources
ASM_SOURCES =  \


##
# C++ sources
CXX_SOURCES = \
Core/context/context.cpp

##
#######################################
# binaries
#######################################
# The gcc compiler bin path can be either defined in make command via GCC_PATH variable (> make GCC_PATH=xxx)
# either it can be added to the PATH environment variable.
ifdef PREFIX

ifdef GCC_PATH
CC_ = $(GCC_PATH)/$(PREFIX)gcc
AS_ = $(GCC_PATH)/$(PREFIX)gcc -x assembler-with-cpp
CP_ = $(GCC_PATH)/$(PREFIX)objcopy
SZ_ = $(GCC_PATH)/$(PREFIX)size
AR_ = $(GCC_PATH)/$(PREFIX)ar
##
CXX_ = $(GCC_PATH)/$(PREFIX)g++
##
else
CC_ = $(PREFIX)gcc
AS_ = $(PREFIX)gcc -x assembler-with-cpp
CP_ = $(PREFIX)objcopy
SZ_ = $(PREFIX)size
AR_ = $(PREFIX)ar
##
CXX_ = $(PREFIX)g++
##
endif

else
CC_ = gcc
AS_ = gcc -x assembler-with-cpp
CP_ = objcopy
SZ_ = size
AR_ = ar
CXX_ = g++
endif

ifdef WINDOWS
CC = $(CC_).exe
AS = $(CC_) -x assembler-with-cpp
CP = $(CP_).exe
SZ = $(SZ_).exe
AR = $(AR_).exe
CXX = $(CXX_).exe
else
CC = $(CC_)
AS = $(CC_)
CP = $(CP_)
SZ = $(SZ_)
AR = $(AR_)
CXX = $(CXX_)
endif

HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S
 
#######################################
# CFLAGS
#######################################
# cpu
ifdef PREFIX
CPU = -mcpu=cortex-m4

# fpu
FPU = -mfpu=fpv4-sp-d16

# float-abi
FLOAT-ABI = -mfloat-abi=hard

# mcu
MCU = $(CPU) -mthumb $(FPU) $(FLOAT-ABI)

endif
# macros for gcc
# AS defines
AS_DEFS = 

# C defines
C_DEFS =  \



# AS includes
AS_INCLUDES =  \


# C includes
C_INCLUDES =  \
-ICore/context \
-ICore/slice \
-I.



# compile gcc flags
ASFLAGS = $(MCU) $(AS_DEFS) $(AS_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

CFLAGS = $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif


# Generate dependency information
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"

##
CXXFLAGS = $(CFLAGS) -fno-exceptions
##

#######################################
# LDFLAGS
#######################################

# libraries
ifdef PREFIX
LIBS = -lc -lm -lnosys 
LIBDIR = 
LDFLAGS = $(MCU) -specs=nano.specs -specs=nosys.specs $(LIBDIR) $(LIBS) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections
else
LIBS = -lc -lm
LIBDIR = 
LDFLAGS = $(LIBDIR) $(LIBS) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections
endif

# default action: create test executable
LIB_TARGET = lib$(TARGET).a
all: $(LIB_TARGET)


#######################################
# build the application
#######################################
# list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))
# list of ASM program objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

##
# list of C++ objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(CXX_SOURCES:.cpp=.o)))
vpath %.cpp $(sort $(dir $(CXX_SOURCES)))
##

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR) 
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.s Makefile | $(BUILD_DIR)
	$(AS) -c $(CFLAGS) $< -o $@

##
$(BUILD_DIR)/%.o: %.cpp Makefile | $(BUILD_DIR)
	$(CXX) -c $(CXXFLAGS) $< -o $@

##

$(LIB_TARGET): $(OBJECTS) Makefile
	$(AR) rcs $@ $(OBJECTS)
	@echo Library Created Successfully
	
	
$(BUILD_DIR):
	mkdir $@
#######################################
# clean up
#######################################
clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(LIB_TARGET)
	@echo Everything Cleaned up

rebuild: clean all
	@echo Rebuild Succeeded
#######################################
# dependencies
#######################################
-include $(wildcard $(BUILD_DIR)/*.d)

# *** EOF ***
