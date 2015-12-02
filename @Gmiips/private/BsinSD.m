function y = BsinSD(x)
%PSINSD give the second derivative of the Bsin function
%
% see also:
% see also: Psin, PsinSD, Bsin, TriangleWave

% credits:
% a similar forumula, without composition with triangle wave, was published
% by Jasper Vijn on his website (http://www.coranac.com/2009/07/sines/).

% 2015 Alexander Hertlein

twave = TriangleWave(x);

y  = -((24*(1-2/pi)*twave)/pi.^2);
end