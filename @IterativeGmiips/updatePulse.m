function updatePulse(miips)
% UPDATEPULSE retrieves shaped pulse of last Gmiips iteration

% 2015, Alberto Comin - LMU Muenchen

if isempty(miips.iterations)
  miips.retrievedPulse = [];
  miips.shapedPulse = miips.inputPulse;
else
  miips.retrievedPulse = miips.iterations{end}.retrievedPulse;
  miips.shapedPulse = miips.iterations{end}.shapedPulse;
end

end

