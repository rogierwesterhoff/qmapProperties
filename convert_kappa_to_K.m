function [K_m_timeunit,sigma_K_m_timeunit]=convert_kappa_to_K(log_kappa_grid,log_sigma_grid,time_unit)
%% convert permeability to hydraulic conductivity
% input: 
%   - grid or vector of log kappa (log of permeability), unit [m2]
%   - log sigma(log of standard deviations), unit [m2]
%   - timeunit [s] (e.g. 86400 is one day)
% output: 
%   - hydraulic conductivity in m per time unit
%   - standard deviation of hydraulic conductivity per time unit

if nargin<3
    time_unit=1; %time unit in sec
end

K_m_timeunit=time_unit*10.^log_kappa_grid*1000*9.8/1.2155e-3;

Kmin_m_timeunit=time_unit*10.^(log_kappa_grid-log_sigma_grid)*1000*9.8/1.2155e-3;
Kmax_m_timeunit=time_unit*10.^(log_kappa_grid+log_sigma_grid)*1000*9.8/1.2155e-3;
sigma_K_m_timeunit=0.5*(Kmax_m_timeunit-Kmin_m_timeunit);