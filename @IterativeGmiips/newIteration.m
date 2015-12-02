function newIteration(miips, varargin)
%NEWITERATION adds another GMiips iteration
% USAGE:
% miips.newIteration()
%   adds GMiips iteration using  default parameters
% miips.newIteration('amp', newModulationAmplitude);  
%   adds iteration with new value for modulation amplitude
% miips.newIteration('tau', newModulationFrequency);  
%   adds iteration with a  value for modulation frequency
% miips.newIteration('amp', newAmp, 'tau', newTau);
%   adds iteration with new modulation amplitude and frequency
% miips.newIteration('maxGDD', newMaxGDD); 
%   adds iteration with same tau, and amp = newMaxGDD/tau^2

% TODO: argument processing does not handle all possible input
% combinations, just those listed in the help above are so far supported

n = 1;
while n <= length(varargin)
  switch varargin{n}
    case 'amp'
      miips.modulationAmplitude = varargin{n+1};
      n = n+1;
    case 'tau'
      miips.modulationFrequency{n+1};
      n = n+1;
    case 'maxGDD'
       miips.modulationAmplitude = varargin{n+1}/miips.modulationFrequency^2;
      n = n+1;
  end
  n = n+1;
end

miips.iterations{end+1} = Gmiips(...
  miips.shapedPulse, ...
  miips.modulationAmplitude, ...
  miips.modulationFrequency, ...
  miips.phaseArray, ...
  'modulationFunction', miips.modulationFunction, ...
  'gateWidth', miips.gateWidth, ...
  'fitrange', miips.fitRangeStd, ...
  'noiselevel', miips.cameraNoiseLevel);

% updates miips trace and retrieve GDD and phase
miips.update();

end

