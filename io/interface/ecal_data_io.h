#include "TFile.h"
#include "TTree.h"

#include <array>
#include <vector>

#include "io/interface/Pulse.h"

#include <Eigen/Dense>

constexpr int num_samples = 10;
constexpr int num_pulses = num_samples;
constexpr int num_samples_extended = 19;

class ecal_data_io {
private:
    std::string file_name;
    TFile* tfile;
    TTree* ttree;

    double truth_ampl;
    std::vector<double> *samples;
    int ientry;

    Pulse fpulse;

public:
    using pulse_matrix_type = Eigen::Matrix<double, num_samples, num_pulses>;
    using input_vector_type = Eigen::Matrix<double, num_samples, 1>;
    using extended_input_vector_type = Eigen::Matrix<double, num_samples_extended, 1>;
    using extended_pulse_matrix_type = Eigen::Matrix<double, num_samples_extended, num_samples_extended>;
    using entry_type = std::pair<input_vector_type, pulse_matrix_type>;

    ecal_data_io(std::string const& file_name);

    entry_type get_one_entry();
    std::vector<entry_type> get_n_entries(int);
};
