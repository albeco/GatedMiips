function wavelength_nm  = freq2wave( freq, freqUnits )
%FREQ2WAVE converts frequency to wavelength in nanometer

SPEEDOFLIGHT = 2.99792458e8; % m/s
NANO = 1e-9;

convFact = containers.Map({...
  'yHz','zHz','aHz','fHz','pHz','nHz','uHz','mHz','Hz',...
  'kHz','MHz','GHz','THz','PHz','EHz','ZHz','YHz'}, ...
  {-24, -21, -18, -15, -12, -9, -6, -3, 0, 3, 6, 9, 12, 15, 18, 21, 24});

wavelength_nm = SPEEDOFLIGHT ./ (freq * 10^convFact(freqUnits)) /NANO;

end

