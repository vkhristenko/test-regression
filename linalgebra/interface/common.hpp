#ifndef common_hpp
#define common_hpp

#define M_LINEAR_ACCESS(M, row, col, dim) M[(row) * (dim) + (col)]
#define SIMPLE_SQRT(x) std::sqrt(x)

//
// primitive versions of swaps
// assume j>i
//
template<typename T>
void swap_row_column(T *pM, int i, int j, int full_size, int view_size) {
    using data_type = T;
    data_type tmptmp = M_LINEAR_ACCESS(pM, i, i, full_size);
    M_LINEAR_ACCESS(pM, i, i, full_size) = M_LINEAR_ACCESS(pM, j, j, full_size);
    M_LINEAR_ACCESS(pM, j, j, full_size) = tmptmp;

    for (int elem=0; elem<i; ++elem) {
        data_type tmp = M_LINEAR_ACCESS(pM, i, elem, full_size);

        M_LINEAR_ACCESS(pM, i, elem, full_size) = 
            M_LINEAR_ACCESS(pM, j, elem, full_size);
        M_LINEAR_ACCESS(pM, j, elem, full_size) = tmp;

        // for the column
        M_LINEAR_ACCESS(pM, elem, i, full_size) = 
            M_LINEAR_ACCESS(pM, elem, j, full_size);
        M_LINEAR_ACCESS(pM, elem, j, full_size) = tmp;
    }
    for (int elem=i+1; elem<view_size; ++elem) {
        data_type tmp = M_LINEAR_ACCESS(pM, i, elem, full_size);

        M_LINEAR_ACCESS(pM, i, elem, full_size) = 
            M_LINEAR_ACCESS(pM, j, elem, full_size);
        M_LINEAR_ACCESS(pM, j, elem, full_size) = tmp;

        // for the column
        M_LINEAR_ACCESS(pM, elem, i, full_size) = 
            M_LINEAR_ACCESS(pM, elem, j, full_size);
        M_LINEAR_ACCESS(pM, elem, j, full_size) = tmp;
    }
}

#endif
