function updateGDD(miips)
% UPDATEGDD sets the retrievedGDD to the total GDD correction

% 2015 Alberto Comin, LMU Muenchen

if isempty(miips.iterations)
  miips.retrievedGDD = [];
  return;
end

GDD = zeros(size(miips.inputPulse.frequencyArray));
for i = 1:numel(miips.iterations)
  GDD = GDD + miips.iterations{i}.retrievedGDD;
end
miips.retrievedGDD = GDD;

end

