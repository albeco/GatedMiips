classdef IterativeGmiips < Gmiips
%IterativeGmiips class for pulse-compression using Gated-Miips
  
  % 2015 Alberto Comin, LMU Muenchen
  
  
  %% Gmiips properties
  properties (SetAccess = private)
    iterations; % array with Gmiips iterations
  end
  
  %% utility methods
  methods (Access = private)
    updateTrace(miips) % get trace from last iteration
    updateGDD(miips) % get total GDD correction
    updatePhase(miips) % get totatal phase correction
    updatePulse(miips) % get shaped pulse after last iterations
  end
  
  methods
    update(miips) % updates trace, GDD and phase
    newIteration(miips, varargin) % updates trace, GDD and phase
  end
  
  %% constructor method
  methods
    function miips = IterativeGmiips(inputPulse, modulationAmplitude, ...
        modulationFrequency, phaseArray,varargin)
      
      miips@Gmiips(inputPulse, modulationAmplitude, ...
        modulationFrequency, phaseArray,varargin{:})
      
      % compute first Gmiips iteration
      miips.newIteration();
      
    end
  end

  
end

