clc
clear
close all

load("quad_convergence_v3.mat")

max_slope_deg = rad2deg(max_slope);
max_slope_bounds = [0.99 1.01]*max_slope_deg(end);
rms_slope_deg = rad2deg(rms_slope);
rms_slope_bounds = [0.99 1.01]*rms_slope_deg(end);
Rout = 0.5;
D = Rout*2;
N = linspace(100,250000,100);
l_approx = sqrt(pi/sqrt(3)*D^2./N);

figure; hold on; axis padded; box on;
plot(element_count,max_slope_deg,"o-","LineWidth",2,"Color","k")
plot(element_count,ones(length(element_count))*max_slope_bounds(1),...
    "--","LineWidth",2,"Color","r")
plot(element_count,ones(length(element_count))*max_slope_bounds(2),...
    "--","LineWidth",2,"Color","r")
xlim([element_count(1),element_count(end)])
xlabel("Number of Elements")
ylabel("Max. Slope Error (deg)")
set(gcf,'Units','Inches','Position',[1,1,4.5*1.3,3*1.3]);
set(gca,'FontSize',14)
hold off;

figure; hold on; axis padded; box on;
plot(element_count,rms_slope_deg,"o-","LineWidth",2,"Color","k")
plot(element_count,ones(length(element_count))*rms_slope_bounds(1),...
    "--","LineWidth",2,"Color","b")
plot(element_count,ones(length(element_count))*rms_slope_bounds(2),...
    "--","LineWidth",2,"Color","b")
xlim([element_count(1),element_count(end)])
xlabel("Number of Elements")
ylabel("RMS Slope Error (deg)")
set(gcf,'Units','Inches','Position',[1,1,4.5*1.3,3*1.3]);
set(gca,'FontSize',14)
hold off;

% figure; hold on; axis padded; box on;
% plot(element_count,mesh_size*1e3,"o-","LineWidth",2,"Color","k")
% plot(N,l_approx*1e3,"--","LineWidth",2,"Color","r")
% xlim([element_count(1),element_count(end)])
% xlabel("Number of Elements")
% ylabel("Mesh Size (mm)")
% set(gcf,'Units','Inches','Position',[1,1,4.5*1.3,3*1.3]);
% set(gca,'FontSize',14)
% legend("Abaqus","Approximation")
% hold off;