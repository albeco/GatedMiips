function update(miips)
% UPDATE updates the G-MIIPS trace, retrieved GDD and retrieved phase

miips.updateTrace();
miips.updateGDD();
miips.updatePhase();
miips.updatePulse();

end