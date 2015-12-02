function SHG  = secondHarmonic(w,ef)
% SECONDHARMONIC gives the SHG of a frequency domain electric field
% It is a very basic implementation, so it is meant to give a theoretical
% limit for the SHG, rather than a realistic simulation.

% 2015 Alberto Comin, LMU Muenchen

% IMPLEMENTATION NOTE:
% the autoconvolution via fft is faster than the "conv" function
inputSize = size(ef);
SHG = ifft(fft(ef, 2*inputSize(1)-1, 1).^2, [], 1) .* (w(2)-w(1));
SHG = reshape(SHG(1:2:end, :), inputSize);
end