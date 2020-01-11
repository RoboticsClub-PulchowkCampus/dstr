/*
 * slice.h
 * 
 * Created: 12/3/2019
 *  Author: n-is
 *   Email: 073bex422.nischal@pcampus.edu.np
 */

#ifndef _SLICE_H_
#define _SLICE_H_

#include "context.h"
#include <cstddef>

// DEFAULT_SLICE_SIZE is the default size used for the buffer of a slice.
#define DEFAULT_SLICE_SIZE (4)

// Need to undef this at the end of file.
#define log(x) log(__FILE__, __LINE__, x)

extern Context DefaultContext;

/**
 * Slice is a template class that wraps a basic array, and provides some
 * useful functionality to make it easier to use.
 * 
 * @param T The type stored by the Slice
 * @param N The maximum number of elements the slice can hold
 * 
 * @brief A slice cannot be accessed to the full limit of the buffer if it is
 *      not initialized accordingly. The maximum element that a slice can hold
 *      can be given at the creation to the constructor. This range can be
 *      grown to a maximum of the size of the underlying buffer using 'push'
 *      function.
 * 
 * @note Any value that is accessed from a slice is guaranteed to have some
 *      value of the respective type. Context can be provided to the slice so
 *      that the errors produced by it is appropriately logged. A default
 *      context named 'DefaultContext' is used by default if none are available.
 */
template <class T, size_t N = DEFAULT_SLICE_SIZE>
class Slice
{
public:
        // Slice creation with 0 elements.
        Slice(Context *ctx = &DefaultContext)
        {
                len_ = 0;
                cap_ = N;
                ctx_ = ctx;
        }

        // Slice creation using initializer list
        Slice(std::initializer_list<T> lst, Context *ctx = &DefaultContext) : Slice(ctx)
        {
                for (auto &x : lst)
                {
                        push(x);
                }
        }

        // Slice creation of certain default size and value
        Slice(size_t len, T defVal)
        {
                if (len > N)
                {
                        ctx_->getLogger()->log("Maximum buffer size exceeded");
                        return;
                }

                len_ = len;
                for (size_t i = 0; i < len; ++i)
                {
                        slice_[i] = defVal;
                }
        }

        Slice(Slice &&) = default;
        Slice(const Slice &) = default;
        Slice &operator=(Slice &&) = default;
        Slice &operator=(const Slice &) = default;
        ~Slice() {}

        // len returns the current length of the slice.
        size_t len() const { return len_; }
        // cap returns the maximum size the slice can grow to.
        size_t cap() const { return cap_; }

        // Overload array subscript operator
        T &operator[](size_t i)
        {
                // Log error if it occurs
                if (i > len_)
                {
                        ctx_->getLogger()->log("Index out of bounds");

                        // Return first element
                        return slice_[0];
                }

                return slice_[i];
        }

        // push pushes the 'elem' to the end of the slice.
        void push(T elem)
        {
                if (len() >= cap())
                {
                        ctx_->getLogger()->log("Buffer Full");
                        return;
                }

                // Insert the element at the end of the slice
                slice_[len_++] = elem;
        }

private:
        T slice_[N]; //< Underlying buffer that stores all the data
        size_t len_, cap_;

        Context *ctx_; //< The context under which the slice works
};

#undef log

#endif // !_SLICE_H_
