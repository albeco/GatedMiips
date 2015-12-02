function updateGDD(miips)
% UPDATEGDD calculates and corrects the spectral phase

% Copyright (C) 2015 Alberto Comin, LMU Muenchen

% This file is part of Gmiips. See README.txt for copyright and licence
% notice.

% choose which streak to analyze (0 for Gmiips)
if miips.gated
  streakNo =0;
else
  streakNo = miips.streakNo;
end

% retrieve the GDD from the trace
[GDD, ridgePhase] = estimateGDD(...
  2*pi*miips.frequencyArray, ...
  2*pi*miips.centralFrequency, ...
  miips.modulationAmplitude, ...
  miips.modulationFrequency, ...
  miips.phaseArray, ...
  miips.trace, ...
  streakNo, ... 
  miips.gddFunctionHandle_, ...
  miips.analysisMethod); 

% keep only the part of the signal where signal-noise ratio is good enough
miips.retrievedGDD = GDD .* miips.fitRangeMask;
miips.ridgePhase = ridgePhase .* miips.fitRangeMask;

end