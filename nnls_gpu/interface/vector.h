
template <typename T> 
class vector {
    public:

        __host__ __device__
        explicit vector(unsigned long size=2){
            this->array = new T[size];
            this->_size = size;
        }
        
        __host__ __device__
        void push_back(T elem){
            this->last_elem++;
            if(this->last_elem >= this->_size) resize(this->_size/2);
            this->array[this->last_elem] = elem; 
        }

        __host__ __device__
        void erase(const unsigned long index){
            this->last_elem--;
            for(int i = index; i < this->last_elem; ++i){
                this->array[i] = this->array[i+1];
            }
            if(this->last_elem <= (this->_size/4)) resize(this->_size/2);
        }

        __host__ __device__
        T& operator[](unsigned long index){
            return this->array[index];
        }

        __host__ __device__
        unsigned long size() const {
            return this->_size;
        }
        
        __host__ __device__
        bool empty() const {
            return !this->last_elem;
        }


        typedef T* iterator;
        typedef const T* const_iterator;

        __host__ __device__
        inline iterator begin() { return &this->array[0]; }
        __host__ __device__
        inline const_iterator begin() const { return &this->array[0]; }
        __host__ __device__
        inline iterator end() { return &this->array[this->_size]; }
        __host__ __device__
        inline const_iterator end() const { return &this->array[this->_size]; }


    private:
        T* array;
        unsigned long _size;
        unsigned long last_elem=0;
        
        __host__ __device__
        inline void resize(unsigned long size){
            T* tmp = new T[size];
            memcpy(tmp,this->array, _size * sizeof(T));
            _size /= size;
            delete [] this->array;
            this->array = tmp;
        }

};
