function ps = Psin( x )
%PSIN approximates sin(x) by a C2 continuous piece-wise cubic function
%useful to avoid higher order in the Tailor expansion (for ex. in MIIPS)
%
% see also: PsinSD, Bsin, BsinSD, TriangleWave

% credits:
% a similar forumula, without composition with triangle wave, was published
% by Jasper Vijn on his website (http://www.coranac.com/2009/07/sines/).

% 2015 Alberto Comin, LMU Muenchen

twave = TriangleWave(x);

ps = 3/pi*twave - 4/pi^3*twave.^3;

end

