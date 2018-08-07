#include <iostream>

#include "io/interface/ecal_data_io.h"

int main(int argc, char **argv) {
    std::string file_name;
    if (argc>=2)
        file_name = {argv[1]};

    ecal_data_io io{file_name};
    auto entries = io.get_n_entries(10000);
    for (auto const& p : entries) {
        auto const& inputs = p.first;
        auto const& pulse_matrix = p.second;
        std::cout << inputs;
        std::cout << pulse_matrix;
    }

    return 0;
}
