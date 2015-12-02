%% Simulation of Gmiips with 4th order spectral phase

%% Set up chirped Gaussian pulse
p = gaussianPulse('f0',300/800, 'fwhm', 5, 'units', 'fs', 'dt', 0.5);

FOD = 500; % fs^2
p.polynomialPhase([FOD 0 0 0 0])

%% Simulate Gmiips
maxGDD = 200; % fs^2
tau = p.calculateShortestDuration();
amp = maxGDD/tau^2;
phasesteps = linspace(-2*pi, 2*pi, 500);
% simulate standard miips
m = Gmiips(p, amp, tau, phasesteps, 'gateWidth', []);
% simulate Gmiips
mg = Gmiips(p, amp, tau, phasesteps, 'gateWidth', 1, 'modulationFunction', 'psin');

%% Plot results
figure(1)
subplot(3,1,1)
pcolor(m.phaseArray, m.frequencyArray, m.trace);
shading flat
ylim([-2,2]*p.bandwidth+p.centralFrequency)
xlabel('phase shift (rad)')
ylabel(['frequency (', p.frequencyUnits, ')'])
title('MIIPS trace')

subplot(3,1,2)
pcolor(mg.phaseArray, mg.frequencyArray, mg.trace);
shading flat
ylim([-2,2]*p.bandwidth+p.centralFrequency)
xlabel('phase shift (rad)')
ylabel(['frequency (', p.frequencyUnits, ')'])
title('G-MIIPS trace')


subplot(3,1,3)
plot(p.frequencyArray, m.retrievedPhase, 'b', ...
  p.frequencyArray, mg.retrievedPhase, 'r', ...
  p.frequencyArray, p.spectralPhase, 'k--');
legend('miips', 'G-miips', 'true')
xlim([-2,2]*p.bandwidth+p.centralFrequency)
xlabel(['frequency (', p.frequencyUnits, ')'])
ylabel('spectral phase (rad)')
title('Phase Retrieval')