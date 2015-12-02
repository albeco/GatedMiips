function updatePhase(miips)
% UPDATEPHASE sets the retrievedPhase to the total phase correction

% 2015, Alberto Comin - LMU Muenchen

if isempty(miips.iterations) || isempty(miips.retrievedGDD)
  miips.retrievedPhase = [];
  return;
end

miips.retrievedPhase = miips.doubleIntegrateGDD(...
  2*pi*miips.frequencyArray, ...
  2*pi*miips.centralFrequency, ...
  miips.retrievedGDD);
end

