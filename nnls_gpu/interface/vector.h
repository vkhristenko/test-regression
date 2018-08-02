
#ifndef MY_CUDA_VECTORS_H
#define MY_CUDA_VECTORS_H

template <typename T>
class vector {
 public:
  __host__ __device__ explicit vector(unsigned long size = 0) {
    this->_size = size;
    if (size == 0)
      this->last_elem = 16;
    else
      this->last_elem = size;
    this->array = new T[this->last_elem];
  }

  __host__ __device__ void push_back(T elem) {
    this->_size++;
    if (this->_size >= this->last_elem)
      extend();
    this->array[this->_size - 1] = elem;
  }

  __host__ __device__ void erase(const unsigned long index) {
    printf("inside erase\n");
    printf("size %u, last_elem %u, index %u\n", this->_size, this->last_elem,
           index);
    this->_size--;
    for (auto i = index; i < this->_size; ++i) {
      this->array[i] = this->array[i + 1];
    }

    printf("size %u, last_elem %u, index %u\n", this->_size, this->last_elem,
           index);
    if (this->_size > 16 && this->_size < this->last_elem * 4)
      reduce();
  }

  __host__ __device__ T& operator[](unsigned long index) {
    return this->array[index];
  }

  __host__ __device__ unsigned long size() const { return this->_size; }

  __host__ __device__ bool empty() const { return !this->_size; }

  __host__ __device__ void resize(unsigned long size) {
    T* tmp = new T[size];
    memcpy(tmp, this->array, this->_size * sizeof(T));
    this->_size = size;
    delete[] this->array;
    this->array = tmp;
  }

  typedef T* iterator;
  typedef const T* const_iterator;

  __host__ __device__ inline iterator begin() { return &this->array[0]; }
  __host__ __device__ inline const_iterator begin() const {
    return &this->array[0];
  }
  __host__ __device__ inline iterator end() {
    return &this->array[this->_size];
  }
  __host__ __device__ inline const_iterator end() const {
    return &this->array[this->_size];
  }

 private:
  T* array;
  unsigned long _size;
  unsigned long last_elem;

  __host__ __device__ void extend() {
    this->last_elem *= 2;
    T* tmp = new T[this->last_elem];
    memcpy(tmp, this->array, this->_size * sizeof(T));
    delete[] this->array;
    this->array = tmp;
  }
  __host__ __device__ void reduce() {
    this->last_elem /= 2;
    T* tmp = new T[this->last_elem];
    memcpy(tmp, this->array, this->_size * sizeof(T));
    delete[] this->array;
    this->array = tmp;
  }
};

#endif