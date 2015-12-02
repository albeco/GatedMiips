function updatePulse(miips)
% UPDATEPULSE calculates shaped pulse using Gmiips retrieved phase

%% Copyright (C) 2015 Alberto Comin, LMU Muenchen
%
%  This file is part of Gmiips. Gmiips is free software: you can
%  redistribute it and/or modify it under the terms of the GNU General
%  Public License as published by the Free Software Foundation, either
%  version 3 of the License, or (at your option) any later version.
%  Gmiips is distributed in the hope that it will be useful, but WITHOUT
%  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
%  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
%  for more details. You should have received a copy of the GNU General
%  Public License along with Gmiips.  If not, see
%  <http://www.gnu.org/licenses/>.

%% update retrievedPulse
if isempty(miips.retrievedPulse)
  miips.retrievedPulse = LaserPulse( ...
    miips.inputPulse.frequencyArray, ...
    miips.inputPulse.frequencyUnits, ...
    miips.inputPulse.spectralAmplitude, ...
    miips.retrievedPhase);
else
  miips.retrievedPulse.spectralPhase = miips.retrievedPhase;
end

%% update shapedPylse
if miips.onlyAnalysis
% in onlyAnalysis mode, an experimental miips trace is provided by user,
% since inputPulse is not provided, it cannot be shaped
    miips.shapedPulse = [];
  return;
end

% check if inputPulse contains one or many sub-pulses
oldPhase = miips.inputPulse.spectralPhase;
if isvector(oldPhase)
  correctedPhase = oldPhase - miips.retrievedPhase;
else
  % pulse train: the input pulse contains many sub-pulses, but only the
  % averaged signal is measured.
  correctedPhase = bsxfun(@minus, oldPhase, miips.retrievedPhase);
end

% initialize or update the corrected input pulse (shapedPulse)
if isempty(miips.shapedPulse)
  miips.shapedPulse = LaserPulse( ...
    miips.inputPulse.frequencyArray, ...
    miips.inputPulse.frequencyUnits, ...
    miips.inputPulse.spectralAmplitude, ...
    correctedPhase);
else
  miips.shapedPulse.spectralPhase = correctedPhase;
end

end

