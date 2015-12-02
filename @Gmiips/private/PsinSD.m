function [ y ] = PsinSD( x )
%PSINSD give the second derivative of the Psin function
%which is a cubic piece-wise approximation of the sin(x) function
%
% see also: Psin, Bsin, BsinSD, TriangleWave

% credits:
% a similar forumula, without composition with triangle wave, was published
% by Jasper Vijn on his website (http://www.coranac.com/2009/07/sines/).

% 2015 Alberto Comin, LMU Muenchen

y = -24/pi^3 * TriangleWave(x);

end

