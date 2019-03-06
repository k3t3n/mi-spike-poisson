**Status:** In progress (More files to be added soon)


# Mutual Information for a Poisson Mixture Model of Spiking Neurons

This repository contains example code for modeling multi-unit neuronal responses as a Poisson mixture and calculating the mutual information as described in the following
paper:

**[Quantifying Neuronal Information Flow in Response to Frequency and Intensity Changes in the Auditory Cortex](https://centers.njit.edu/nesh/sites/nesh/files/MehtaKliewerIhlefeld_2018.pdf)**, by
Ketan Mehta, Joerg Kliewer, and Antje Ihlefeld.

## Contents

**`MI`**
This folder contains scripts to estimate the following information theoretic quantities for Poisson random variables:
- `mutual_info.m` - calculates the mutual information of a general Poisson mixture of two random variables with specified weights.
- `poisson_mixture.m` - calculates the entropy of a bi-variate Poisson mixture model.
- `entropy.m` - calculates the entropy of a single Poisson random variable given its rate parameter.

**`Spikes`**
This folder contains scripts to process neuronal spike trains, along with two example datasets.
'Spikes' contains code for spike detection, calculating inter-spike arrival time, and estimating the rate parameter from the spike sequence.
- `spike_main.m`
    - performs spike detection using voltage thresholding.
    - calculates inter-spike arrival time.
    - estimates the mean firing rate of the spike sequence by modeling it as a Poisson random variable. The rate parameter is calculated for each electrode, by concatenating data from multiple trials.

- `spike_view` - opens and reads trial information from a .hd5 session file, and bandpass filter the spike sequence.  
- `trial1K_1.mat` - an example dataset from an experimental session. This session file consists of ten trials (repetitions) of the same stimulus; an audio tone of 1 kHz being presented at a sound pressure level of 53 dB.
- `trialSilence_1.mat` - an example dataset for a session file with ten trials of no audio tone being presented.

## Citation

If you find this code useful please cite us in your work:

```
@inproceedings{Mehta2018Asilomar,
  title={Quantifying Neuronal Information Flow in Response to Frequency and Intensity Changes in the Auditory Cortex},
  author={Mehta, Ketan and Kliewer, J{\"o}rg and Ihlefeld, Antje},
  booktitle={Asilomar Conference on Signals, Systems and Computers},
  month={Oct},
  year={2018},
  address={Pacific Grove, California}
}
```
