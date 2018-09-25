//---- plot output of multifit

void plotPulseOutput (std::string nameInputFile = "output.root", int nEvent = 1){
  
  
  Color_t* color = new Color_t [200];
  color[0] = kAzure; //kRed ;
  color[1] = kAzure + 10 ;
  color[2] = kYellow + 2 ;
  color[3] = kGreen ;
  color[4] = kGreen + 4 ;
  color[5] = kBlue ;
  color[6] = kCyan ;
  color[7] = kPink + 1 ;
  color[8] = kBlack ;
  color[9] = kYellow + 4 ;
  for (int i=0; i<30; i++) {
    color[i+10] = kBlue + i;
  }
  
  
  
  
  TFile *file = new TFile(nameInputFile.c_str());
  
  TTree* tree = (TTree*) file->Get("RecoAndSim");
  
  int    nWF;
  std::vector<double>* pulse_signal = new std::vector<double>;
  std::vector<double>* samples = new std::vector<double>;
  std::vector<double>* samplesReco = new std::vector<double>;
  std::vector<double>* pulseShapeTemplate     = new std::vector<double>;
  std::vector<int>*    activeBXs   = new std::vector<int>;
  float NFREQ;
  double amplitudeTruth;
  double signalTruth;
  
  tree->SetBranchAddress("nWF",      &nWF);
  tree->SetBranchAddress("pulse_signal", &pulse_signal);
  tree->SetBranchAddress("samples", &samples);
  tree->SetBranchAddress("samplesReco", &samplesReco);
  tree->SetBranchAddress("pulseShapeTemplate",   &pulseShapeTemplate);
  tree->SetBranchAddress("activeBXs", &activeBXs);
  tree->SetBranchAddress("nFreq",   &NFREQ);
  tree->SetBranchAddress("amplitudeTruth",   &amplitudeTruth);
  tree->SetBranchAddress("signalTruth",   &signalTruth);
  
  tree->GetEntry(nEvent);
  
  //   std::cout << " nWF = " << nWF << std::endl;
  
  TCanvas* ccpulse_signal = new TCanvas ("ccpulse_signal","Signal",800,600);
  TGraph *gr = new TGraph();
  for(int i=0; i<nWF; i++){
    gr->SetPoint(i, i/4., pulse_signal->at(i));
    //     std::cout << " i = " << pulse_signal->at(i) << std::endl;
  }
  gr->Draw("AL");
  gr->SetLineColor(kMagenta);
  gr->SetLineWidth(2);
  gr->GetXaxis()->SetTitle("time [ns]");
  
  
  TCanvas* ccPulse = new TCanvas ("ccPulse","Pulse",800,600);
  TGraph *grPulse = new TGraph();
  for(int i=0; i<samples->size(); i++){
    grPulse->SetPoint(i, i * NFREQ, samples->at(i));
  }
  grPulse->SetMarkerSize(2);
  grPulse->SetMarkerStyle(21);
  grPulse->SetMarkerColor(kRed);
  grPulse->Draw("ALP");
  grPulse->GetXaxis()->SetTitle("BX");
  
  
  
  
  
//   std::vector<double>* samples_noise = new std::vector<double>;
//   float best_pedestal = 0;
//   
//   
//   tree->SetBranchAddress("nWF",      &nWF);
//   tree->SetBranchAddress("pulse_signal", &pulse_signal);
//   tree->SetBranchAddress("samplesReco", &samplesReco);
//   tree->SetBranchAddress("samples",   &samples);
//   tree->SetBranchAddress("samples_noise",   &samples_noise);
//   tree->SetBranchAddress("pulseShapeTemplate",   &pulseShapeTemplate);
  
  
  
  
  
  TCanvas* ccReco = new TCanvas ("ccReco","Reco",800,600);
  ccReco->SetRightMargin(0.3);
  TGraph *grReco = new TGraph();
  for(int i=0; i<samplesReco->size(); i++){
    std::cout << " i, activeBXs->at(i), samplesReco->at(i) = " << i << "::" << samplesReco->size() << " -> " << activeBXs->at(i) << " , " << samplesReco->at(i) << std::endl;
    grReco->SetPoint(i, activeBXs->at(i), samplesReco->at(i));
  }
  grReco->SetMarkerSize(2);
  grReco->SetMarkerStyle(22);
  grReco->SetMarkerColor(kBlue);
  grReco->Draw("ALP");
  grReco->GetXaxis()->SetTitle("BX");
  
  
  TCanvas* ccPulseAndReco = new TCanvas ("ccPulseAndReco","Pulse and Reco",800,600);
  TGraph *grPulseRecoAll = new TGraph();
  TGraph *grPulseReco[samplesReco->size()];
  
  TLegend* leg = new TLegend(0.91,0.10,0.99,0.90);
  
  std::vector<float> totalRecoSpectrum;
  for(int i=0; i<samples->size(); i++){
    totalRecoSpectrum.push_back(0);
  }
  
  for(int iBx=0; iBx<samplesReco->size(); iBx++){
    grPulseReco[iBx] = new TGraph();
    for(int i=0; i<samples->size(); i++){
      grPulseReco[iBx]->SetPoint(i, i * NFREQ + activeBXs->at(iBx)*NFREQ + 2 * 25, pulseShapeTemplate->at(i) * samplesReco->at(iBx));
      
      int iReco = (i * NFREQ + activeBXs->at(iBx)*NFREQ + 2 * 25) / NFREQ;
      if ( iReco >= 0 && iReco <samples->size() ) {
        totalRecoSpectrum.at(iReco) += pulseShapeTemplate->at(i) * samplesReco->at(iBx);
      } 
     
//      std::cout << " pulseShapeTemplate->at(" << i << ") = " << pulseShapeTemplate->at(i) << std::endl;
     
    }
    grPulseReco[iBx]->SetMarkerColor(color[iBx]);
    grPulseReco[iBx]->SetLineColor(color[iBx]);
    grPulseReco[iBx]->SetMarkerSize(1);
    grPulseReco[iBx]->SetMarkerStyle(21+iBx);
    TString nameHistoTitle = Form ("BX %d", activeBXs->at(iBx));
    leg->AddEntry(grPulseReco[iBx],nameHistoTitle.Data(),"p");
  }

  
  
  
  TGraph *grPulseTruthInTime = new TGraph();
  for(int i=0; i<samples->size(); i++){
    grPulseTruthInTime->SetPoint(i, i * NFREQ + 2 * 25, pulseShapeTemplate->at(i) * amplitudeTruth );
    std::cout << " pulseShapeTemplate->at(" << i << ") * amplitudeTruth = " << pulseShapeTemplate->at(i) * amplitudeTruth << std::endl;
  }
  grPulseTruthInTime->SetMarkerSize(2);
  grPulseTruthInTime->SetMarkerStyle(30);
  grPulseTruthInTime->SetMarkerColor(kRed);
  grPulseTruthInTime->SetLineStyle(3);
  grPulseTruthInTime->SetLineColor(kRed);
  leg->AddEntry(grPulseTruthInTime,"True intime","p");
  
  
  grPulse->Draw("ALP");
  
  grPulseTruthInTime->Draw("LP");
  
  //  for(int iBx=0; iBx<3; iBx++){
  for(int iBx=0; iBx<samplesReco->size(); iBx++){
    grPulseReco[iBx]->Draw("PL");
  }
  
  for(int i=0; i<samples->size(); i++){
    grPulseRecoAll->SetPoint(i, i * NFREQ, totalRecoSpectrum.at(i));
    std::cout << " totalRecoSpectrum.at(" << i << ") = " << totalRecoSpectrum.at(i) << std::endl;
    
  }
  
  grPulseRecoAll->SetMarkerColor(kMagenta);
  grPulseRecoAll->SetLineColor(kMagenta);
  grPulseRecoAll->SetLineStyle(1);
  grPulseRecoAll->SetMarkerSize(2);
  grPulseRecoAll->SetMarkerStyle(24);
  grPulseRecoAll->Draw("PL");
  grPulse->GetXaxis()->SetTitle("time [ns]");
  
  leg->Draw();
  
  
  std::cout << " signalTruth = " << signalTruth << std::endl;
  std::cout << " amplitudeTruth = " << amplitudeTruth << std::endl;
  
  
}

