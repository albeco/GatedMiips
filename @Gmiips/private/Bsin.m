function y = Bsin( x )
%BSIN is a best-fit cubic approximation to a sinusoidal wave
%
% see also:
% see also: Psin, PsinSD, BsinSD, TriangleWave

% credits:
% a similar forumula, without composition with triangle wave, was published
% by Jasper Vijn on his website (http://www.coranac.com/2009/07/sines/).

% 2015 Alexander Hertlein

twave = TriangleWave(x);

y  = twave-(4*(1-2/pi)*twave.^3)/pi.^2;
end