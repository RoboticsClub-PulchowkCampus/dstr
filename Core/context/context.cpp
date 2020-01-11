/*
 * context.cpp
 * 
 * Created: 12/3/2019
 *  Author: n-is
 *   Email: 073bex422.nischal@pcampus.edu.np
 */

#include "logger.h"
#include "context.h"

Logger ConsoleLogger(&std::cout);
Context DefaultContext(&ConsoleLogger);
