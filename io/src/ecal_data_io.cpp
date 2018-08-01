#include <tuple>
#include <vector>

#include "io/interface/ecal_data_io.h"

ecal_data_io::ecal_data_io(std::string const& file_name) 
    : file_name{file_name}, tfile{new TFile(file_name.c_str())}, samples{new std::vector<double>{}}, ientry{0} {
    ttree = (TTree*) tfile->Get("Samples");

    ttree->SetBranchAddress("amplitudeTruth", &truth_ampl);
    ttree->SetBranchAddress("samples", &samples);
}

ecal_data_io::entry_type ecal_data_io::get_one_entry() {
    // get the data
    ttree->GetEntry(ientry % ttree->GetEntries());
    ientry++;

    // inputs
    input_vector_type inputs{input_vector_type::Zero()};
    for (int i=0; i<samples->size(); ++i)
        inputs(i) = samples->at(i);

    // feature matrix
    extended_input_vector_type pulse_extended = extended_input_vector_type::Zero();
    double pulseShapeTemplate[num_samples+2];
    for(int i=0; i<num_samples+2; i++) {
        double x = double( IDSTART + NFREQ * (i + 3) + NFREQ - 500 / 2);
        pulseShapeTemplate[i] = fpulse.fShape(x);
        pulse_extended(i+7) = pulseShapeTemplate[i];
    }
    int activeBXs[] = { -5, -4, -3, -2, -1,  0,  1,  2,  3,  4 };
    pulse_matrix_type pulse_matrix = pulse_matrix_type::Zero();
    for (unsigned int ip=0; ip<num_pulses; ++ip) {
        int bx = activeBXs[ip];
        int first_sample_t = std::max(0, bx+3);
        int offset = 7 - 3 - bx;

        unsigned int nsample_pulse = num_samples - first_sample_t;
        pulse_matrix.col(ip).segment(first_sample_t, nsample_pulse) = pulse_extended.segment(first_sample_t + offset,
            nsample_pulse);
    }

    return {inputs, pulse_matrix};
}

std::vector<ecal_data_io::entry_type> ecal_data_io::get_n_entries(int n) {
    std::vector<entry_type> result;
    for (int i=0; i<n; i++)
        result.push_back(get_one_entry());

    return result;
}
