clear; clc
%% parameter definition
N = 2^16; % sampling points
df = 1e-5; % frequency step
f0 = 0.5; % central frequency

% laser pulse
bw = 0.1; % bandwidth (FWHM of spectral amplitude)
f = f0 + df*(-N/2 : N/2-1).';
Af = exp(-4*log(2)*(f-f0).^2/bw^2);
Af = Af/sum(Af(:).^2); % normalize to unit intensity
phi = zeros(size(Af));

% SLM
phaseRange = 2*pi;
nPhaseSteps = 2^12;
phaseResolution = phaseRange/nPhaseSteps;

slmRange = 5*bw;
nPixels = 640;
pixelSize = slmRange/nPixels;
gapSize = 1e-3 * pixelSize;
pixelBorder = 1e-1*pixelSize;
slmRegion = abs(f-f0) < nPixels/2*pixelSize;
laserSpotSize = 5*pixelSize;
% desired modulation phase
modFun = @(x, x0) 10*sin(2*pi*(x-x0) * 10);

pixelized = true;
separatedPixels = false;
smoothPixels = true;

%% pixelization
round2step = @(x, x0, step) round((x-x0)/step)*step + x0;
% discretize the frequency over the SLM pixels
if pixelized
  fd = round2step(f, f0, pixelSize);
else
  fd = f;
end

%% phase modulation: ideal case (for comparison)
phiMod_id = phi + modFun(f, f0); % ideal case 
% phase wrapping
phiMod_id = mod(phiMod_id,phaseRange);

%% phase modulation: more realistic case
phiMod = round2step(phi + modFun(fd, f0), 0, phaseResolution);
% phase wrapping
phiMod = mod(phiMod,phaseRange);

%% smoothing SLM pixels (takes into account soft pixel boundary)
if pixelized && smoothPixels
  % do a simple convolution with Gaussian kernel
  kern = exp(-4*log(2)*(f-f0).^2/pixelBorder^2); kern = kern / sum(kern(:));
  phiMod = fftshift(ifft(fft(ifftshift(phiMod)) .* fft(ifftshift(kern))));
end
%% removing modulation from gap regions, where SLM is transparent
if separatedPixels
  gapLocalizer = @(x,x0,step,gapsize) abs(mod(x-x0,step)-step/2)<gapsize/2;
  gapRegion = gapLocalizer(f, f0, pixelSize, gapSize);
  phiMod(gapRegion) = phi(gapRegion); % restore original phase
end
%% calculating transmitted field
Ef_id = Af .*exp(1i*phiMod_id); % ideal modulator
Ef2 = Af .*exp(1i*phiMod);

%% considering finite laser spot size
if laserSpotSize > eps % finite spot size
  focus = exp(-4*log(2)*(f-f0).^2/laserSpotSize^2);
  focus = focus / sum(focus(:));
%   Ef2 = fftshift(ifft(fft(ifftshift(Ef2)) .* fft(ifftshift(focus))));
  Ef2 = Af .* fftshift(ifft(fft(ifftshift(exp(1i*phiMod))) .* fft(ifftshift(focus))));
end

%% clipping range outside the SLM
phiMod_id(~slmRegion)=0;
phiMod(~slmRegion)=0;
Ef2(~slmRegion)=0;

% calculating time domain
t = (-N/2:N/2-1).' /df/N;
Et1 = fftshift(fft(ifftshift(Ef_id)));
Et2 = fftshift(fft(ifftshift(Ef2)));

%% plotting
figure(1)
plot(f,phiMod_id+2*pi,'b.',f,phiMod+2*pi,'r.',f,abs(Ef2)/max(abs(Ef2))*5,'k');
xlim([-slmRange/2 slmRange/2]+f0)
ylim([0 14])
xlabel('Frequency (1/fs)')
ylabel('A(f), phi(f)')
title('Spectral Field and Phase')
figure(2)
plot(t,abs(Et1),'b-',t,abs(Et2),'r--')
xlim([-3000, 3000])
title('Temporal Field Amplitude');
xlabel('Time (fs)')
ylabel('A(t)')