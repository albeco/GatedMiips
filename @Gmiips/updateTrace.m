function updateTrace(miips)
% UPDATETRACE recalculates the Gmiips trace and stores it.
%
% If the inputPulse consists of many sub-pulses, the miips trace is the sum
% of the traces obtained from each single pulse of the train. This
% simulates an experimental setup in which the detector is slow compared
% with the repetition rate of the laser.

% Copyright (C) 2015 Alberto Comin, LMU Muenchen

% This file is part of Gmiips. See README.txt for copyright and licence
% notice.


miips.trace = calculateGmiipsTrace(...
  miips.frequencyArray, ...
  miips.inputPulse.spectralField,... % frequency domain electric field
  miips.modFunctionHandle_,... % phase modulation function handle
  miips.centralFrequency,...
  miips.modulationAmplitude,...
  miips.modulationFrequency,...
  miips.phaseArray,... % the phase delays of the Gmiips trace
  miips.gated, ... % true for G-MIIPS and false for MIIPS
  miips.gateFunction,... % amplitude gate function handle
  miips.gateWidth,...
  miips.maxCorrection, ... % max value of G-MIIPS prefactor
  miips.cameraNoiseLevel);

end
