/*
 * context.h
 * 
 * Created: 12/3/2019
 *  Author: n-is
 *   Email: 073bex422.nischal@pcampus.edu.np
 */

#ifndef _CONTEXT_H_
#define _CONTEXT_H_

#include "logger.h"

class Context
{
public:
        Context(Logger* lgr) {
                logger_ = lgr;
        }
        Context(Context &&) = default;
        Context(const Context &) = default;
        Context &operator=(Context &&) = default;
        Context &operator=(const Context &) = default;
        ~Context() { }

        Logger* getLogger() { return logger_; }

private:
        Logger* logger_;
};

#endif // !_CONTEXT_H_
