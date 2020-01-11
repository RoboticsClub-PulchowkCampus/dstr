/*
 * logger.h
 * 
 * Created: 12/3/2019
 *  Author: n-is
 *   Email: 073bex422.nischal@pcampus.edu.np
 */

#ifndef _LOGGER_H_
#define _LOGGER_H_

#include <iostream>

class Logger
{
public:
        Logger(std::ostream* os) {
                os_ = os;
        }
        Logger(Logger &&) = default;
        Logger(const Logger &) = default;
        Logger &operator=(Logger &&) = default;
        Logger &operator=(const Logger &) = default;
        ~Logger() { }

        // Logs to the selected ostream
        void log(const char * file, int line, const char *str) {
                *os_ << "File: " << file << " Line: " << line << "\t" << str << "\n";
        }

private:
        std::ostream* os_;
};

#endif // !_LOGGER_H_
