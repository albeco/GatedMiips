function [ cg ] = TriangleWave( x )
%TRIANGLEWAVE generates a triangle wave with period 2pi and amplitude pi/2
%useful to extend in a periodic way functions defined in -pi/2..pi/2
%
% see also:
% see also: Psin, PsinSD, Bsin, BsinSD

% 2015 Alberto Comin, LMU Muenchen

cg = -2 * pi * abs(-1 / 4 + x / pi / 2 -...
    floor(x / pi / 2 + 1 / 4)) + pi / 2;

end

