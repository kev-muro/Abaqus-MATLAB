clc
clear
close all

load("variational_study_data_v2.mat")

x = diameter;
y = thickness;
z = max_slope;

np1 = 10;
[xq1, yq1] = meshgrid(linspace(min(x), max(x), np1), ...
                    linspace(min(y), max(y), np1));

F = scatteredInterpolant(x, y, z, 'natural'); 
zq1 = F(xq1, yq1);

np2 = 200;
[xq2, yq2] = meshgrid(linspace(min(x), max(x), np2), ...
                    linspace(min(y), max(y), np2));
zq2 = griddata(x, y, z, xq2, yq2, 'cubic');

figure; hold on;
surf(yq1*1e3, xq1, rad2deg(zq1));
scatter3(y*1e3, x, rad2deg(z),40, 'filled','MarkerEdgeColor','k',...
    'MarkerFaceColor','k'); 
ylabel('Diameter (m)'); 
xlabel('Thickness (mm)'); 
zlabel('Max. Slope Error (deg)');
set(gcf,'Units','Inches','Position',[1,1,4.5*1.3,3.2*1.3]);
set(gca,'FontSize',14)
view(-50,30)
hold off;

figure; hold on; axis square;
contourf(yq2*1e3, xq2, rad2deg(zq2));
contour(yq2*1e3, xq2, rad2deg(zq2), [0.1 0.1], 'r', 'LineWidth', 3);
cb = colorbar();
cb.Label.String = "Max. Slope Error (deg)";
cb.Label.FontSize = 14;
ylabel('Diameter (m)'); 
xlabel('Thickness (mm)'); 
set(gcf,'Units','Inches','Position',[1,1,4.5*1.3,3.2*1.3]);
set(gca,'FontSize',14)
%ylim([1,10])
hold off;
