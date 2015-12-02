function m = Miips(varargin)
% MIIPS initializes a Gmiips object standard MIIPS setting.
% Standard MIIPS means sinusoidal phase modulation and no amplitude gate.
%
% Requires: Gmiips matlab class.
%
% See also: Gmiips

% 2015 Alberto Comin, LMU Muenchen

m = Gmiips(varargin{:}, 'modulationFunction', 'sin', 'gateWidth', []);

end