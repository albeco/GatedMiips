function trace = calculateGmiipsTrace(f,ef,modFun, f0,amp,tau,phi,gated, ...
  gateFun,gateWidth,maxCorr, noiselevel)
%CALCULATETRACE calculates the Gmiips trace
%  using a phase modulation given by amp*modFun(2*pi*tau*(f-f0)-phi)
%  and a amplitude modulation given by gateFun(2*pi*tau*(f-f0)-phi,gateWidth)
%
% USAGE:
% trace = calculateTrace(f,ef,modFun,f0,amp,tau,phi,gateFun,gateWidth,maxCorrection)
%
% INPUTS:
%  f: frequency (1/timeUnits)
%  ef: frequency domain electric field (normalized)
%  modFun: handle to function used for phase modulation (default: sin)
%  f0: central frequency (1/timeUnits)
%  amp: amplitude of phase modulation (rad)
%  tau: modulation frequency (timeUnits) 
%  phi: phase array
%  gateFun: handle to function used for the scanning gate
%  gateWidth: width of the scanning gate
%  maxCorr: an upper limit to the Gmiips correction


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


%% IMPLEMENTATION NOTE:
% The exponential prefactor improves the accuracy near the end of the
% range. It does not lead to divergence because the Gmiips streak is
% non-zero only within a narrow band around the zero GDD line. In real
% experiments, however, noise and residual background signal are present
% everywhere and are amplified by the exponential prefactor. This amplified
% noise does not affect the analysis, which only considers the inner
% region, where signal is present. For this reason we clip the empty part
% of the Gmiips trace using a rectangle window.
%   Setting maximum limit to the Gmiips prefactor could be usuful
% when working on experimental data with poor signal/noise ratio. The SHG
% level at the sides of the spectrum can be so low to fall below the noise
% level. Limiting the prefactor, in those cases, avoids boosting the noise
% in spectral regions where the signal could not be analysed anyways.


%% Main Calculation:

% precalculate the scanning phase term
phaseShift = bsxfun(@minus, 2*pi*tau*(f-f0), phi);
% calculate the modulation
modulation = exp(1i*amp*modFun(phaseShift));
if gated
  modulation = modulation .* gateFun(phaseShift,gateWidth);
end

ef = reshape(ef, size(ef,1), []);
noPulses = size(ef,2);
trace = zeros(size(modulation));
if (noPulses>1); hwb = waitbar(0, 'calculating Gmiips trace ...'); end
for n = 1:noPulses
  % apply phase and amplitude modulation
  modField = bsxfun(@times, ef(:,n), modulation);
  % calculated raw second harmonic trace
  trace = trace + abs(secondHarmonic(f,modField)).^2;
  if (noPulses>1); waitbar(n/noPulses, hwb); end
end
if (noPulses>1); delete(hwb); end

% add simulated noise
trace = trace + noiselevel * rand(size(trace)) * max(trace(:));

% calculate gated trace by muliplying SHG trace and exponential prefactor
% only needed for Gated-Miips
if gated
  pref = min(maxCorr, gateFun(phaseShift,gateWidth).^(-4));
  pref = pref.* heaviside(phaseShift+pi/2) .* heaviside(pi/2-phaseShift);
  trace = bsxfun(@times, trace, pref);
end

end



