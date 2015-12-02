function y = heaviside(x)
%HEAVISIDE is the unit step function.
%
% It is defined on the real range.
%
% heaviside(x0) = 1 for x>0
%               0.5 for x=0
%                -1 for x<0
%
% This function is meant to replace the matlab heaviside function,
% when the latter is not available.

% 2014 Alberto Comin, LMU Muenchen

% input argument check
assert(isreal(x),'heaviside(x) must be called with real argument')

y = 0.5 * (1+sign(x));

end
