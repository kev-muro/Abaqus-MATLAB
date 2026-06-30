clc
clear
close all

load("quad_convergence_v4_pt1.mat")
load("quad_convergence_v4_pt2.mat")

element_count = [element_count_pt1;  element_count_pt2];
mesh_size = [mesh_size_pt1; mesh_size_pt2];
rms_slope = [rms_slope_pt1; rms_slope_pt2];
max_slope = [max_slope_pt1; max_slope_pt2];

max_slope_deg = rad2deg(max_slope);
max_slope_bounds = [0.99 1.01]*max_slope_deg(end);
rms_slope_deg = rad2deg(rms_slope);
rms_slope_bounds = [0.99 1.01]*rms_slope_deg(end);

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
