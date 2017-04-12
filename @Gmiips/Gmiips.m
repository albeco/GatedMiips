classdef Gmiips < matlab.mixin.Copyable
  %GMIIPS is a class for simulating MIIPS and Gated-MIIPS. 
  %
  %Multiphoton Intrapulse Interference Phase Scan (MIIPS) is a technique
  %for measuring and compensating the Group Delay Dispersion (GDD) of a
  %laser pulse [1]. The spectral phase is retrieved by double numerical
  %integration.
  %
  %Gated-MIIPS, also known as G-MIIPS, is a variation of MIIPS which uses
  %an amplitude gate to improve its accuracy.
  % 
  %USAGE:
  %  m = Gmiips(inputPulse, amp, tau, phi)
  %   simulates a G-MIIPS iteration
  %  mg = Gmiips(inputPulse, amp, tau, phi, [name], [value], ...)
  %   simulates MIIPS or G-MIIPS with specified parameters.
  %
  %INPUT ARGUMENTS:
  %  inputPulse: laser pulse to be compressed (of type: LaserPulse)
  %  amp: amplitude of phase modulation
  %  tau: frequency of phase modulation
  %  phi: array with the phase steps
  %
  %NAME-VALUE ARGUMENTS: 
  % 'modulationFunction': name of a phase modulation function
  %   'sin' (default) | 'psin'
  % 'gateWidth': width of the scanning gate, for MIIPS use [] or Inf
  %   (double scalar)
  % 'fitrange': range for GDD and phase correction, in frequency units
  % 'fitrangeStd': range for GDD and phase correction, in units of standard deviations
  %   (double scalar)
  % 'streakNo': number of MIIPS streak to analyze (default 0)
  % 'analysisMethod': 'peak-finding' (default), 'centerOfMass' or 'weighted' average
  % 'trace': experimental MIIPS or G-MIIPS trace to be analyzed
  % 'noiselevel': simulated camera noise level
  % 'maxCorrection': limit value for the exponential prefactor in
  %   the formula for the Gmiips signal
  %
  %CALCULATED PROPERTIES:
  %  m.retrievedGDD: GDD retrieved by G-MIIPS
  %  m.retrievedPhase: phase retrieved by G-MIIPS
  %  m.retrievedPulse: laserPulse retrieved by G-MIIPS
  %  m.shapedPulse: laserPulse after pulse-shaping using G-MIIPS
  %
  %FORMULAS AND DEFINITIONS:
  %
  % The phase modulation is defined as:
  %
  %  amp * modulationFunction(2*pi * tau * (f-f0) - phi)
  %
  % where f is the frequency, f0 is the central frequency and phi is an
  % array with phase steps.
  %
  % The amplitude gate is genearally defined as:
  %
  %  gateFun(2*pi * tau * (f-f0) - phi, gateWidth)
  %
  % where gateFun is the gate function, by default a Gaussian defined as:
  %
  %  exp(-(2*pi * tau * (f-f0) - phi).^2 / gateWidth^2)
  %
  %NOTES ON DATA ANALYSIS:
  %
  % streakNo: MIIPS data are bidimensional maps which contain
  %   multiple streaks. Each streak carries the same information, so it is
  %   possible to choose which one to analyze. The streaks are numbered as
  %   follows: the n-th streak is is the one which, for a transform limited
  %   pulse, passes through the point (phi = n*pi/2, f = f0). For G-MIIPS
  %   there is only one streak: the central one, obtained for n=0.
  %
  % modulationFunction: the choice of the modulation function has a
  %   significant impact for the accuracy of the phase retrieval. Currently
  %   the best results are obtained using polynomial pseudo-sinusoidal
  %   functions.
  %
  % fitrange, fitRangeStd: These parameters limit the frequency range which
  %   is used for retrieving the GDD. By default the full frequency array
  %   is used. Limiting the range can be useful when analysing experimental
  %   data or simualated data with artificial noise.
  %
  % analysisMethod: The standard way to analyse the MIIPS trace is
  %  using a 'peak-finding' algorithm [1]. Two alternatives are: detecting
  %  the 'centerOfMass' or calculating a 'weighted' average of the GDD
  %  using the whole Miips map. The latter two methods give a biased
  %  estimate of the position of the maxima of the MIIPS trace, but
  %  not necesserly a worse estimate of the GDD. See the example
  %  files for more information.
  %
  % gateWidth: The width of the gaussian gate influences the accuracy of
  %   the phase retrieval. A narrower gate gives higher accuracy. However,
  %   narrowing the gate makes the streaks thicker, so it can be useful to
  %   increase the GDD range by increasing the amplitude of the phase
  %   modulation function.
  %
  % maxCorrection: Sets a maximum value for the exponential prefactor
  %   in the formula for the Gmiips signal [2]. The exponential
  %   prefactor improves the accuracy near the end of the GDD
  %   range. Setting a maximum limit for the Gmiips prefactor could be
  %   usuful when working on experimental data with poor signal/noise
  %   ratio. Limiting the prefactor, in those cases, avoids boosting
  %   the noise in spectral regions where the signal is anyways not
  %   detectable.
  %
  %REQUIREMENTS:
  % - the LaserPulse class must be present in the matlab search path.
  %   If needed, it can be downloaded for free at:
  %   https://github.com/albeco/LaserPulseClass.git
  %
  %CREDITS:
  % MIIPS:
  %  'Multiphoton Intrapulse Interference Phase Scan' is a technique
  %  invented by M.Dantus [1].
  %  
  % G-MIIPS: Gated-MIIPS is an improved version of MIIPS, developed at
  %  LMU Munich [2].
 %
 % REFERENCES:
 %
 % [1] Dantus, M.; Lozovoy, V. V.; Pastirk, I. Laser Focus World 2007, 43
 %     (5), 101?104.
 %
 % [2] Comin, A.; Ciesielski, R.; Piredda, G.; Donkers, K.; Hartschuh, A.
 %     J. Opt. Soc. Am. B 2014, 31 (5), 1118-1125.
   
  %% Copyright (C) 2015 Alberto Comin, LMU Muenchen
  %
  %  This file is part of Gmiips.
  % 
  %  Gmiips is free software: you can redistribute it and/or modify
  %  it under the terms of the GNU General Public License as published by
  %  the Free Software Foundation, either version 3 of the License, or
  %  (at your option) any later version.
  % 
  %  Gmiips is distributed in the hope that it will be useful,
  %  but WITHOUT ANY WARRANTY; without even the implied warranty of
  %  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  %  GNU General Public License for more details.
  % 
  %  You should have received a copy of the GNU General Public License
  %  along with Gmiips.  If not, see <http://www.gnu.org/licenses/>.

  %% IMPLEMENTATION NOTES:
  %  In a experiemental setup, the miips central frequency could differ
  %  from the laser central frequency, due to alignement or calibration
  %  issues. Here they are assumed to be the same.

  
  %% laser properties
  properties
    inputPulse = []; % the input laser pulse
    retrievedPulse = []; % the retreieved laser pulse
    shapedPulse = []; % the laser pulse shaped by GMiips
    notes = ''; % reserved for user annotations
  end
  
  %% Gmiips setup properties
  properties (Access = private, Constant)
    % hash map of phase modulation functions
    modFunctionsMap_ = containers.Map({'sin','psin','bsin','atan'}, ...
      {@sin, @Psin, @Bsin, @atan});
    % hash map of second derivatives of phase modulation functions
    gddFunctionsMap_ = containers.Map({'sin','psin','bsin','atan'}, ...
      {@(x) sin(-x), @PsinSD, @BsinSD, @(x) -2*x./(x.^2+1).^2})
  end
  properties (Dependent, Access = private)
    % define handles to functions currently used for phase modulation and
    % for retrieving its second derivative
    modFunctionHandle_;
    gddFunctionHandle_; 
  end

  properties
    onlyAnalysis = false; %  selects between full simulation and only data analysis
    analysisMethod = 'peak-finding'; % selects between 'peak-finding' (default), 'centerOfMass' or 'weighted' average
    streakNo = 0; % number of streak to analyze within the MIIPS trace (always 0 for Gmiips)
    gated = true; % selects between gated or non-gated Miips (true/false)
    gateFunction = @gaussian; % handle to function used as amplitud gate
    modulationFunction = 'sin'; % name of function used for phase modulation
    modulationAmplitude = []; % amplitude of phase modulation (rad)
    modulationFrequency = []; % "frequency" of phase modulation
    phaseArray = []; % array with phase steps used for the GMiips trace (rad)
    gateWidth = 1; % gate width for GMIIPS (a Inf value indicates non-gated MIIPS)
    fitRange = Inf; % spectral range for Gmiips (in frequency units)
    maxCorrection = 1/eps; % upper limited for the prefactor in the GMiips formula
  end
  
  properties (Dependent)
    streakRange; % spectral range occupied by the transform limited Gmiips streak
    fitRangeStd; % spectral range for Gmiips (in units of standard deviations)
    frequencyArray; % frequency of input pulse
    centralFrequency; % central frequency for the phase modulation
    fitRangeMask; % spectral range for Gmiips (boolean mask)
  end
  
  %% Gmiips simulation properties
  properties
    trace = []; % the GMiips trace
    ridgePhase = []; % values of scanning phase which maximize the SHG
    retrievedPhase = []; % spectral phase measured by Gmiips
    retrievedGDD = []; % group delay dispersion (GDD) measured by Gmiips
  end
  
  %% experimental setup propertes
  properties
    cameraNoiseLevel = 0; % additive random noise (e.g. from CCD camera)
  end

  %% constructor method
  methods
    function miips = Gmiips(inputPulse, amp, tau, phi, varargin)
      
      % assign MIIPS parameters
      miips.inputPulse = copy(inputPulse); % create a new pulse with same property
      miips.modulationAmplitude = amp;
      miips.modulationFrequency = tau;
      miips.phaseArray = phi;
      % restrict frequency range to region occupied by Gmiips streak
      miips.fitRange = miips.streakRange;
      
      % emtpy class constructor
      if nargin==0
        return;
      end
      
      % making sure we get a laser field as input
      assert(isa(inputPulse,'LaserPulse'), ['inputPulse must belong to the',...
        'class LaserPulse, please check if you have it in the',...
        'matlab path.']);

      n = 1;
      while n <= length(varargin)
        switch lower(varargin{n})
          case 'trace'
            miips.trace = varargin{n+1};
            miips.onlyAnalysis = true;
            n = n+1;
          case {'modulationfunction','modfun'}
              miips.modulationFunction = varargin{n+1};
            n = n+1;
          case {'gatewidth', 'gate'}
            if ~isempty(varargin{n+1}) && isfinite(varargin{n+1})
              miips.gated = true;
            else
              miips.gated = false;
            end
            miips.gateWidth = varargin{n+1};
            n = n+1;
          case 'fitrangestd'
            miips.fitRangeStd = varargin{n+1};
            n = n+1;
          case 'fitrange'
            miips.fitRange = varargin{n+1};
            n = n+1;
          case 'noiselevel'
            miips.cameraNoiseLevel = varargin{n+1};
            n = n+1;
          case {'maxcorrection', 'maxcorr'}
            miips.maxCorrection = varargin{n+1};
            n=n+1;
          case {'analysismethod', 'method'}
            miips.analysisMethod = varargin{n+1};
            n = n+1;
          case 'streakno'
            miips.streakNo = varargin{n+1};
            n = n+1;
          otherwise
            error('MiipsIteration:ArgChk', ...
              ['unsupported argument: ', varargin{n}])
        end
        n = n+1;
      end
      
      % update MIIPS trace and retrieve GDD and phase
      miips.update();
    end
  end
  %% getter methods
  methods
    function f = get.modFunctionHandle_(miips)
      f = miips.modFunctionsMap_(miips.modulationFunction);
    end
    function f = get.gddFunctionHandle_(miips)
      f = miips.gddFunctionsMap_(miips.modulationFunction);
    end
    function f = get.frequencyArray(miips)
      f = miips.inputPulse.frequencyArray;
    end
    function w0 = get.centralFrequency(miips)
      w0 = miips.inputPulse.centralFrequency;
    end
    function df = get.fitRangeStd(miips)
      df = miips.fitRange ./ std(miips.inputPulse, 'frequency');
    end
    function fitmask = get.fitRangeMask(miips)    
      fitmask = abs(miips.frequencyArray - miips.centralFrequency) <= miips.fitRange/2;
    end
    function df = get.streakRange(miips)
      df = abs(miips.phaseArray(end)-miips.phaseArray(1)) / miips.modulationFrequency/2/pi;
    end
  end
  
  %% setter methods
  methods
    function set.fitRangeStd(miips, df)
      miips.fitRange = df * std(miips.inputPulse, 'frequency');
    end
    function set.modulationFunction(miips, functionName)
      if isKey(miips.modFunctionsMap_, functionName)
        miips.modulationFunction = functionName;
      else
        warning(['not supported modulation function, the supported one are: ' ,...
          strjoin(miips.modFunctionsMap_.keys,',')]);
      end
    end
  end
  
  %% static methods
  methods(Static)
    phase = doubleIntegrateGDD(w,w0,GDD); % calculates spectral phase from GDD values
  end
  
  %% utility methods
  methods (Access = private)
    updateTrace(miips) % updates miips.trace by recalculating it
    updateGDD(miips) % updates miips.retrievedGDD  by recalculating it
    updatePhase(miips) % updates miips.retrievedPhase by recalculating it
    updatePulse(miips) % updates miips.retrievedPulse and miips.shapedPulse
  end
  methods
    miipsCopy = deepCopy(miips) % create a copy of miips object and of its LaserPulse properties
    update(miips) % updates trace, GDD and phase
    disp(miips) % display Gmiips object
    varargout = pcolor(miips, varargin) % display Gmiips trace
  end
end

