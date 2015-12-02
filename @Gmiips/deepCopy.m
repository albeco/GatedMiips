function [ miipsCopy ] = deepCopy( miips )
%DEEPCOPY create a copy of a Gmiips object

% 2015 Alberto Comin, LMU Muenchen

% call superclass: the properties are copied by reference
miipsCopy = miips.copy();
% create a copy of the handle properties to make the two object independent
miipsCopy.inputPulse = miips.inputPulse.copy();
miipsCopy.retrievedPulse = miips.retrievedPulse.copy();
miipsCopy.shapedPulse = miips.shapedPulse.copy();
end

