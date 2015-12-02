function hsurf = pcolor( m, varargin)
% PCOLOR display the Gmiips trace
%
% inputs:
%   m: Gmiips trace
% optional name-value arguments:
%   'fig': figureHandle
%   'normalized': true/false
%
% Creates a new figure is created unless an handle to an existing figure is
% provided. The 'normalized' option displays the trace normalized to the
% peak values at each frequency.


% This file is part of Gmiips software.
% Copyright 2015, Alberto Comin, LMU Munich

%% process input arguments
figRef = [];
normalizeTrace = false;
for n = 1:2:numel(varargin)
  switch varargin{n}
    case 'fig'
      figRef = varargin{n+1};
    case 'normalized'
      normalizeTrace = varargin{n+1};
  end
end

%% set up figure and axes
if isempty(figRef)
  figure();
else
  figure(figRef);
  clf(figRef);
end
h1 = axes;
set(h1,'Box','off');

%% normalize data if required
if normalizeTrace
  trace = bsxfun(@rdivide,m.trace,max(m.trace,[],2));
else
  trace = m.trace;
end

%% plot the Miips trace
hs =  pcolor(h1, m.phaseArray, m.frequencyArray, trace);
% if normalizeTrace, caxis(h1,[0.9, 1]); end
shading flat
xlabel(h1, 'phase (rad)');
ylabel(h1, ['frequency (', m.inputPulse.frequencyUnits, ')']);

% restrict the frequency range except for experimental traces
if ~m.onlyAnalysis
  ylim(h1, [-2, 2] * m.inputPulse.std('frequency') + m.centralFrequency);
end

% add wavelenght axes except if laser central frequency is zero
if abs(m.centralFrequency) > eps
  % create secondary axes
  h2 = axes('color','none', 'YAxisLocation','right', 'XAxisLocation','top',...
    'YLim', freq2wave(fliplr(h1.YLim),m.inputPulse.frequencyUnits), ...
    'YDir','reverse', 'XTick',[]);
  ylabel('wavelength (nm)')
  % link the two axes pairs
  addlistener(h1, 'YLim', 'PostSet', @(source,event) resetWaveAxes())
  % set main axes as current
  axes(h1)
end

ridgeColor = 'k';
maxGDDColor  = [1.0 0.7 0.7];
zeroGDDColor = [0.7 1.0 0.7];
minGDDColor  = [0.7 0.7 1.0];

% draw the ridge line through the points used to determine the GDD
line(m.ridgePhase, m.frequencyArray, ...
  'LineStyle','--','Color', ridgeColor, 'LineWidth', 1, 'Parent', h1);

% calculate reference lines for maxGDD, minGDD, and zero GDD
GDDline = @(phi, n) (phi/2/pi + n/4)/m.modulationFrequency + m.centralFrequency;

% draw the zero-GDD, -maxGDD, and +maxGDD lines
line(m.phaseArray, GDDline(m.phaseArray, 0), 'LineStyle','--', ...
  'Color', zeroGDDColor, 'LineWidth',1, 'Parent',h1);
line(m.phaseArray, GDDline(m.phaseArray, -1), 'LineStyle','--', ...
  'Color', minGDDColor, 'LineWidth',1, 'Parent',h1);
line(m.phaseArray, GDDline(m.phaseArray, 1), 'LineStyle','--', ...
  'Color',maxGDDColor, 'LineWidth', 1, 'Parent', h1);

% return the handle of the Miips trace plot 
if nargout == 1; hsurf = hs; end

  function resetWaveAxes()
    % updates the wavelength axis to match changes in the frequency axis
    h2.YLim = freq2wave(fliplr(h1.YLim),m.inputPulse.frequencyUnits);
  end

end
