function update(miips)
% UPDATE recalculates Gmiips trace, GDD, phase and shaped laser pulse
% It must be called after either changing the input laser pulse or any of the
% Gmiips parameters (amplitude,frequency, modulation function, ...)

% Copyright (C) 2015 Alberto Comin, LMU Muenchen

% This file is part of Gmiips. See README.txt for copyright and licence
% notice.

% IMPLEMENTATION:
%  the updateTrace() method is the currently the most time-consuming
%  operation.  It could be possibly optimized by tuning the internal
%  parameters of the matlab fft routine.

% in onlyAnalysis mode the miips trace is provided by user
if ~miips.onlyAnalysis
  miips.updateTrace();
end

miips.updateGDD();

miips.updatePhase();

if ~miips.onlyAnalysis
  miips.updatePulse();
end

end