#ifndef _UTILS_H_
#define _UTILS_H_


template<typename T, size_t N>
constexpr size_t len(T (&arr)[N]) {
        return N;
}

#endif // !_UTILS_H_
