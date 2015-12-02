function phase = doubleIntegrateGDD(w,w0,GDD)
% calculates spectral phase from GDD values
% 
% INPUTS:
% w: array with angular frequencies
% w0: central angular frequency
% GDD: group delay dispersion
%
% OUTPUT:
% phase: the spectral phase

% Copyright (C) 2015 Alberto Comin, LMU Muenchen

% This file is part of Gmiips. See README.txt in the Gmiips folder for
% copyright and licence notice.



% finding the array index of the central frequency
[~,iw0]=min(abs(w-w0));
dw = w(2)-w(1);
% calculating first Derivative
% the cumtrapz output start from zero, differently from cumsum
FirstDerRight=cumtrapz(GDD(iw0:end)) * dw;
FirstDerLeft=cumtrapz(GDD(iw0:-1:1)) * dw;
% avoid duplicating the central point
FirstDer= [FirstDerLeft(end:-1:1); FirstDerRight(2:end)];
% calculating phase 
% the cumtrapz output start from zero, differently from cumsum
CalculatedPhaseRight=cumtrapz(FirstDer(iw0:end)) * dw;
CalculatedPhaseLeft=cumtrapz(FirstDer(iw0:-1:1)) * dw;
% avoid duplicating the central point
phase = [CalculatedPhaseLeft(end:-1:1); CalculatedPhaseRight(2:end)];

end

