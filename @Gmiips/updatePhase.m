function updatePhase(miips)
% UPDATEPHASE calculates spectral phase from GDD values
% miips: m

% Copyright (C) 2015 Alberto Comin, LMU Muenchen 

% This file is part of Gmiips. See README.txt for copyright and licence
% notice.

miips.retrievedPhase = miips.doubleIntegrateGDD(...
  2*pi*miips.frequencyArray, ...
  2*pi*miips.centralFrequency, ...
  miips.retrievedGDD);

end

