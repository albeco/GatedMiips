function [GDD, ridgePhase] = estimateGDD(w, w0, amp, tau, phi, trace, streakNo, ...
  secondDerivFun, algorithm)
%ESTIMATEGDD calculates the best estimate of the spectral phase
%
% INPUTS:
% w: angular frequency array;
% w0 = central angular frequency;
% amp = modulation amplitude;
% tau = modulation frequency;
% phi =  phase array;
% trace = miips trace;
% streakNo: which streak to analyze, usually the central one
% secondDerivFun: second derivative of miips modulation function (handle)
% algorithm = 'peak-finding' or 'weighted'
%
% OUTPUT:
% GDD: the retrieved GDD
%
% The 'peak-finding' algorithm uses the matlab 'max' function, the
% 'weighted' calculates the weighted average.

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

% TODO: replace the peak-finding routine with a more robust one (for ex. the
% one from matlab signal processing toolbox)

% create a mask and cut out the extra traces (affects only not-gated miips)
[DD,FF] = meshgrid(phi, w);
traceMask = ((tau*(FF - w0) >= DD - (streakNo-1/2)*pi) | ...
  (tau*(FF - w0) <= DD - (streakNo+1/2)*pi));
trace(traceMask)=0;

switch lower(algorithm)
  case 'peak-finding'
    % find the ridge of miips trace via peak-finding
    [~,ridgeIndex] = max(trace,[],2);
    ridgePhase = phi(ridgeIndex)';
    shiftedPhase = tau*(w-w0)-ridgePhase;  
    % calculate the GDD using the second derivative of the formula used for
    % generating the trace, but with reversed sign
    GDD = -amp * tau^2 *secondDerivFun(shiftedPhase);
    GDD(ridgeIndex==1) = 0; % quick fix because max find ridgeIndex==1 for low signal
   
  case 'weighted'
    % first calculate the GDD values for each point of the trace,
    % then calculate their weighted average
    GDDmat = -amp * tau^2 *secondDerivFun(tau*(FF-w0)-DD);
    GDD = sum(GDDmat .* trace, 2) ./ (sum(trace, 2)+eps);
    ridgePhase = nan(size(trace, 1), 1); % for output uniformity
  case 'centerofmass'
    % calculate the center of mass of the trace
    ridgePhase = sum(bsxfun(@times, phi, trace), 2) ./ (sum(trace, 2)+eps);
    shiftedPhase = tau*(w-w0)-ridgePhase;  
    GDD = -amp * tau^2 *secondDerivFun(shiftedPhase);
end
end
