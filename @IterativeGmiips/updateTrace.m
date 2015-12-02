function updateTrace(miips)
% UPDATETRACE retrieves trace of last Gmiips iteration

% 2015, Alberto Comin - LMU Muenchen

if isempty(miips.iterations)
  miips.trace = [];
else
  miips.trace = miips.iterations{end}.trace;
end

end