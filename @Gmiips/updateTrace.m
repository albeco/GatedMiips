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

efield = miips.inputPulse.spectralField;
if ~isvector(efield)
  % arrange all sub-pulses as column in a 2D matrix
  efield = reshape(efield, size(efield,1), []);
end

trace = zeros(numel(miips.frequencyArray), numel(miips.phaseArray));
noPulses = size(miips.inputPulse.spectralField,2);
if (noPulses>1); hwb = waitbar(0, 'calculating Gmiips trace ...'); end
for iPulse = 1 : noPulses
  trace = trace + calculateGmiipsTrace(...
    2*pi*miips.frequencyArray, ... 
    efield(:, iPulse),... % frequency domain electric field
    miips.modFunctionHandle_,... % phase modulation function handle
    2*pi*miips.centralFrequency,...
    miips.modulationAmplitude,...
    miips.modulationFrequency,...
    miips.phaseArray,... % the phase delays of the Gmiips trace
    miips.gated, ... % true for G-MIIPS and false for MIIPS
    miips.gateFunction,... % amplitude gate function handle
    miips.gateWidth,... 
    miips.maxCorrection, ... % max value of G-MIIPS prefactor
    miips.cameraNoiseLevel);
  if (noPulses>1); waitbar(iPulse/noPulses, hwb); end
end
if (noPulses>1); delete(hwb); end;
miips.trace = trace;

end



