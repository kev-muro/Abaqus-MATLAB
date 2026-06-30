clc
clear
close all

% Constant Parameters
E = 120e9; % elastic modulus [Pa]
nu = 0.28; % Poisson's ratio
g = 1.625; % lunar gravity [m/s^2]
rho = 1400; % desnity of CF composite [kg/m^3]

% Case Parmeters
% a: outer radius [m]
% b: inner radius [m]
% t: thickness [m]
% radius: radial distance from center [m]
% u2: lateral deflection [m]
load("flat_plate_case4.mat");
q = rho*t*g; % self weight [N/m^2]

e = deflection_plot(a,b,t,E,nu,q,radius,u2);

function e = deflection_plot(a,b,t,E,nu,q,radius,u2_fea)
    r = linspace(b,a,100); 
    w = radial_deflection(r,a,b,q,E,nu,t); 
    u2_roark = radial_deflection(radius,a,b,q,E,nu,t);
    e = rmse(u2_roark,u2_fea);
    e_mm = e*1e3;
    
    figure; hold on; axis padded; box on;
    plot(r,zeros(size(r)),"Color","k","LineWidth",2,"LineStyle","--")
    plot(r,w*1e3,"Color","r","LineWidth",2)
    scatter(radius,u2_fea*1e3,40,"blue")
    lgd = legend("Reference","Deformed - Roark",...
        "Deformed - FEA","Location","southwest");
    xlabel("Radial Distance (m)")
    ylabel("Deflection (mm)")
    set(gcf,'Units','Inches','Position',[1,1,4.5*1.3,3*1.3]);
    set(gca,'FontSize',14)
    drawnow
    lgd_pos = lgd.Position;
    annotation(gcf,"textbox",[lgd_pos(1),lgd_pos(2)+lgd_pos(4)+0.05,lgd_pos(3),0.06],...
        "String",sprintf("RMSE = %.2f mm",e_mm),"FontSize",14,...
        "BackgroundColor","w","Margin",4,"FitBoxToText","on")
    hold off;

    if max(abs(w)) > t
        disp("Small-deflection assumption does not hold.")
    end

    fprintf("\n RMSE: %.2f mm \n\n",e_mm)
end


function w = radial_deflection(r,a,b,q,E,nu,t)
%ANNULAR_PLATE_FIXED_FREE_DEFLECTION
% Deflection of a flat annular plate with:
%   - inner edge fixed at r = b
%   - outer edge free at r = a
%   - uniform pressure q over the full annulus
%
% Inputs:
%   r  : radial locations where deflection is evaluated 
%   a  : outer radius
%   b  : inner radius
%   q  : uniform pressure, positive downward
%   E  : Young's modulus
%   nu : Poisson's ratio
%   t  : plate thickness
%
% Output:
%   w  : transverse deflection at r

    % Ensure column vector
    r = r(:);

    % Plate flexural rigidity
    D = E*t^3/(12*(1 - nu^2));

    % bark constants/functions for moment expression
    C8 = 0.5*(1 + nu + (1 - nu)*(b/a)^2);

    C9 = (b/a)*(((1 + nu)/2)*log(a/b) + ((1 - nu)/4)*(1 - (b/a)^2));

    L17 = 0.25*(1 - ((1 - nu)/4)*(1 - (b/a)^4) ...
        - (b/a)^2*(1 + (1 + nu)*log(a/b)));

    % Fixed-inner-edge reactions
    Mrb = -(q*a^2/C8)*(C9*(a^2 - b^2)/(2*a*b) - L17);
    Qb = q*(a^2 - b^2)/(2*b);

    % Plate functions for deflection expression
    F2 = 0.25*(1 - (b./r).^2 .* (1 + 2*log(r./b)));

    F3 = (b./(4*r)).*(((b./r).^2 + 1).*log(r./b) + (b./r).^2 - 1);

    G11 = (1/64)*(1 + 4*(b./r).^2 - 5*(b./r).^4 - 4*(b./r).^2 .* ...
            (2 + (b./r).^2) .* log(r./b));

    % Deflection
    % Note: q is positive downward, so w is positive downward.
    w = (Mrb*r.^2/D).*F2 + (Qb*r.^3/D).*F3 - (q*r.^4/D).*G11;
end
