classdef PulseShaper < handle
  % PULSESHAPER models a pixelated spatial light modulator setup.
  %
  % The simulated device consists of a spatial light modulator (SLM), 2
  % identical dispersive elements (gratings or prisms) and 2 identical
  % focusing elements disposed in 4-f configuration.
  %
  % Description of main properties:
  % - nPixels: this is the number of the pixels of the SLM. Together with
  %   the frequency step, it defines the spectral range which can be shaped
  %   by the SLM.
  % - gapSize: the gap is a not-modulated zone between neighbouring pixels.
  %   The gap size here is measured as a fraction of the pixel size or
  %   equivalent of the frequencyStep (in the assumption of linear frequency
  %   dispersion)
  % - smoothing: the pixels of spatial light modulator have not sharp
  %   boundary. This feature can be simulated by taking the convolution of an
  %   idal pulse shaper with a Gaussian kernel. The 'smoothing' property
  %   is the FWHM of that Gaussian.
  % - frequencyStep: this is the frequency increment from one pixel to the
  %   next one. It depends on the physical pixel size, on the type of
  %   dispersion element used and on the distance between the dispersive
  %   element and the SLM, which in 4f setup is also equal to the focal
  %   length of the focusing element.
  % - spectralRange: product of nPixels and frequencyStep (dependent
  %   property). Setting a new value to spectralRange automatically
  %   changes frequencyStep.
  % - spectralResolution: this is the laser spot size (FWHM) at the SLM, in
  %   normalized units
  % - inputPulse: the laser pulse to be shaped (instance of LaserPulse
  %   class)
  % - shapedField: the shaped laser field (1D array)
  % - shapedPulse: the shaped laser pulse (instance of LaserPulse class)
  %
  %
  % Requires:
  % - LaserPulse matlab class (https://github.com/albeco/LaserPulseClass)
  %
  % see also: LaserPulse, GMiips
  
  %% Copyright (C) 2015 Alberto Comin, LMU Muenchen
  %
  %  This file is part of LaserPulse.
  % 
  %  LaserPulse is free software: you can redistribute it and/or modify it
  %  under the terms of the GNU General Public License as published by the
  %  Free Software Foundation, either version 3 of the License, or (at your
  %  option) any later version. LaserPulse is distributed in the hope that
  %  it will be useful, but WITHOUT ANY WARRANTY; without even the implied
  %  warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
  %  the GNU General Public License for more details. You should have
  %  received a copy of the GNU General Public License along with
  %  LaserPulse.  If not, see <http://www.gnu.org/licenses/>.
  
  %%
  properties
    % SLM physical properties
    nPixels = 128; % number of pixels of the modulator
    gapSize = 0; % size of the gap between pixels (normalized)
    smoothing = 0; % FWHM of the gaussian used to smooth the pixel rensponse
    % optical propertes
    frequencyStep = 1e-2; % frequency increment between pixels
    spectralResolution = 1e-3; % laser spot size (FWHM) on the SLM (normalized)
    inputPulse; % input laser pulse (instance of LaserPulse class)
  end
  
  properties (Dependent)
    spectralRange; % spectral range which can be modulated by the SLM
    shapedField; % electric field shaped by SLM
    shapedPulse; % shaped pulse (instance of LaserPulse class)
  end
  
  %% Constructor
  methods
    function SLM  = PulseShaper(varargin)
      % constructs a SLM object
      initializeSLM(SLM, varargin{:});
    end
  end
  
  %% Getter Methods
  methods
    function freqRange = get.spectralRange(SLM)
      freqRange = SLM.nPixels * SLM.frequencyStep;
    end
    function ef = get.shapedField(SLM)
      ef = calculateShapedField(SLM);
    end
    function p = get.shapedPulse(SLM)
      p = SLM.inputPulse.copy();
      p.spectralField = SLM.shapedField;
    end
  end
  
  %% Setter Methods
  methods
    function set.spectralRange(SLM, freqRange)
      SLM.frequencyStep = freqRange / SLM.nPixels;
    end
  end

%% Utility functions
methods (Access = private)
function initializeSLM(SLM, varargin)
% INITIALIZESLM assigns iniital values to properties of SLM object
n = 1;
while n < numel(varargin)
  if isprop(SLM, varargin{n})
    SLM.(varargin{n}) = varargin{n+1};
    n = n+2;
  else
    fprintf('%s is not supported argument.\n', varargin{n});
    n = n+1;
  end
end
end

function ef = calculateShapedField(SLM)
  return; % to be filled in
end
end
end