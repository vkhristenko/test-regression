
#ifndef MY_CUDA_VECTORS_H
#define MY_CUDA_VECTORS_H

const unsigned long base_vector_size = 16;

template <typename T>
class vector {
 public:
  __host__ __device__ explicit vector(unsigned long elements = 0) {
    _size = elements;
    if (elements == 0)
      last_elem = base_vector_size;
    else
      last_elem = elements;
    array = new T[last_elem];
  }

  __host__ __device__ void push_back(T elem) {
    if (_size >= last_elem)
      extend();
    array[_size] = elem;

    _size++;
  
  }

  __host__ __device__ void erase(const unsigned long index) {
    _size--;
    for (auto i = index; i < _size; ++i) {
      array[i] = array[i + 1];
    }
    if (last_elem > 16 && _size < last_elem * 4)
      reduce();
  }

  __host__ __device__ T& operator[](unsigned long index) {
    return array[index];
  }

  __host__ __device__ unsigned long size() const { return _size; }

  __host__ __device__ bool empty() const { return !_size; }

  __host__ __device__ void resize(unsigned long size) {
    T* tmp = new T[size];
    memcpy(tmp, array, _size * sizeof(T));
    _size = size;
    delete[] array;
    array = tmp;
  }

  __host__ __device__ void clear() { _size = 0; }

  typedef T* iterator;
  typedef const T* const_iterator;

  __host__ __device__ inline iterator begin() { return &array[0]; }
  __host__ __device__ inline const_iterator begin() const { return &array[0]; }
  __host__ __device__ inline iterator end() { return &array[_size]; }
  __host__ __device__ inline const_iterator end() const {
    return &array[_size];
  }

 private:
  T* array;
  unsigned long last_elem;
  unsigned long _size;

  __host__ __device__ void extend() {
    last_elem *= 2;
    T* tmp = new T[last_elem];
    memcpy(tmp, array, _size * sizeof(T));
    delete[] array;
    array = tmp;
  }
  __host__ __device__ void reduce() {
    last_elem /= 2;
    T* tmp = new T[last_elem];
    memcpy(tmp, array, _size * sizeof(T));
    delete[] array;
    array = tmp;
  }
};

#endif