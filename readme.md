Gmiips
========================================

![example_gmiips_trace](https://github.com/albeco/GatedMiips/blob/master/pictures/Gmiips.jpg)

Gmiips is a Matlab class for simulating femtosecond laser pulse
compression using
Gated-Multiphoton Intrapulse Interference Phase Scan
([G-MIIPS](http://dx.doi.org/10.1364/JOSAB.31.001118)) [1].
[MIIPS](https://en.wikipedia.org/wiki/Multiphoton_intrapulse_interference_phase_scan) is a pulse compression and characterization technique invented
by the group of
[Dantus](http://spie.org/x17798.xml) [2], and
commercialized by
[Biophotonic Solutions](http://www.biophotonicsolutions.com/about.php). [G-MIIPS](https://www.osapublishing.org/josab/fulltext.cfm?uri=josab-31-5-1118&id=283564)
is a techique based on MIIPS developed at the LMU University of Munich.
It is generally more accurate and particularly suited for broadband and highly distorted pulses.  

Note that the Gmiips software is not related to the original MIIPS
software and it is only meant to be a tool for research. People
interested in purchasing the original MIIPS software or a complete MIIPS
solution for femtosecond pulse compression can find more details in
the webpage of
[Biophotonic Solutions](http://www.biophotonicsolutions.com/about.php).

####Bibliography:

1) A. Comin et al. ["Compression of ultrashort laser pulses via gated multiphoton intrapulse interference phase scans"](http://dx.doi.org/10.1364/JOSAB.31.001118) JOSA B 31, 1118-1125 (2014)
2) M. Dantus et al. ["Measurement and Repair: The Femtosecond Wheatstone Bridge"](http://spie.org/x17798.xml) OE Magazine 9 (2003)

Introduction to MIIPS
----------------------------------------

[MIIPS](https://en.wikipedia.org/wiki/Multiphoton_intrapulse_interference_phase_scan)
is a pulse characterization technique based on
[Second Harmonic Generation](https://en.wikipedia.org/wiki/Second-harmonic_generation)
(SHG) and femtosecond pulse-shaping. It is based on the idea is that
the SHG intensity at a certain frequency is maximum if, at that
frequency, the second derivative of the spectral phase is null.
The second derivative of the spectral phase with respect to the
angular frequency is also called
[group delay dispersion](http://www.rp-photonics.com/group_delay_dispersion.html)
or simply GDD.

A MIIPS measurements consists of modulating the spectral phase of
the laser pulse while simultaneously recording SHG spectra. The
modulation function is typically a sinusoid which is scanned across
the laser spectrum. By stacking together all the measured spectra
one obtains a map with on one axes the frequency and on the other
axes a scanning parameter. These kind of data are known as "MIIPS
traces" because they contain well defined traces where the SHG is
maximum. The analysis of the position of the MIIPS traces gives an
estimate of the GDD for each spectral component of the laser pulse.

The modulation function can be written as:

$\varphi_{\mathrm{mod}}(\omega) = \Phi_0 \sin\left(\tau (\omega-\omega_0)
- \psi\right)$

where $\Phi_0$ is the modulation amplitude, $\tau$ is the
modulation frequency (expressed in units of time) and $\psi$ is a
scanning parameter.


Introduction to G-MIIPS
----------------------------------------

G-MIIPS is based on the observation that MIIPS is
not very accurate when measuring structured broad-band pulses. The
accuracy can improved by reducing the bandwidth of the laser using an
amplitude 'gate', which is scanned across the laser specrum, alongside
the phase modulation.

The most common choice for the scanning gate is the Gaussian function:

$\exp\left[-\left(\tau (\omega-\omega_0) - \psi\right)^2 /
\sigma^2\right]$


Software Requirements:
----------------------------------------

The [LaserPulse](https://github.com/albeco/LaserPulseClass) class must
be present in the matlab search path. The Laser class is open source
and can be downloaded on
[GitHub](https://github.com/albeco/LaserPulseClass).

Installation:
----------------------------------------

 * **Automatic Installation:**
    From matlab: go to the folder where the Gmiips class is located
    (for example: 'cd GmiipsClass') and run the installer script 'install_Gmiips.m'.
 * **Manual Installation:** For installing the **Gmiips** class, just
     include its parent folder in the matlab search path or,
     alternatively, copy the '@Gmiips' folder into a folder which is
     in the matlab search path.  If the manual for the Gmiips class is
     missing, you can generate it using the matlab 'publish'
     function. See 'install_Gmiips.m' for an example.
