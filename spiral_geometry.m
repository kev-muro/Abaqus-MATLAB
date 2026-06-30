%% Generate deployed mountain/valley fold spirals on a paraboloid
clear; clc; close all;

%% Parameters
N = 10;                 % number of fold pairs
beta = 2*pi/N;          % sector angle [rad]

Rout = 10;              % outer radius [m]
Rin = Rout*0.1;         % inner hub radius [m]
f = 1000; 
c = 1/(4*f);            % paraboloid coefficient z = c r^2

nPts = 300;
r = linspace(Rin, Rout, nPts);

%% Fold parameters
curvatureSweep = deg2rad(20);   % shared curvature of both folds
gapOuter = 0.5*beta;           % M/V separation at outer radius

%% Storage
mountainLines = cell(N,1);
valleyLines   = cell(N,1);

figure; hold on; grid on; axis equal;
title('Deployed Fold Lines in Aperture Plane');
xlabel('x [m]');
ylabel('y [m]');

for i = 0:N-1

    theta0 = i*beta;

    %% Normalized radial coordinate
    s = (r - Rin)/(Rout - Rin);

    %% -------------------------------
    % Simple same-curvature parametrization
    %% -------------------------------
    theta_mountain = theta0 - 0.5*gapOuter*s + curvatureSweep*s;
    theta_valley   = theta0 + 0.5*gapOuter*s + curvatureSweep*s;

    %% Mountain fold
    x_mountain = r .* cos(theta_mountain);
    y_mountain = r .* sin(theta_mountain);

    X_mountain = -x_mountain;
    Y_mountain = c*(x_mountain.^2 + y_mountain.^2);
    Z_mountain = y_mountain;

    mountainLines{i+1} = [X_mountain(:), Y_mountain(:), Z_mountain(:)];

    %% Valley fold
    x_valley = r .* cos(theta_valley);
    y_valley = r .* sin(theta_valley);

    X_valley = -x_valley;
    Y_valley = c*(x_valley.^2 + y_valley.^2);
    Z_valley = y_valley;

    valleyLines{i+1} = [X_valley(:), Y_valley(:), Z_valley(:)];

    %% Plot aperture-plane view
    plot(x_mountain, y_mountain, 'r-', 'LineWidth', 2);
    plot(x_valley, y_valley, 'b--', 'LineWidth', 2);
end

% Plot inner hub and outer boundary
th = linspace(0, 2*pi, 500);
plot(Rin*cos(th), Rin*sin(th), 'k-', 'LineWidth', 1.5);
plot(Rout*cos(th), Rout*sin(th), 'k-', 'LineWidth', 1.5);

legend('Mountain folds', 'Valley folds', ...
    'Inner hub', 'Outer boundary');

%% Plot 3D deployed fold lines on paraboloid
figure; hold on; grid on; axis equal;
title('Deployed Fold Lines on Paraboloid');
xlabel('X [m]');
ylabel('Y = c r^2 [m]');
zlabel('Z [m]');

for i = 1:N
    mountain = mountainLines{i};
    valley   = valleyLines{i};

    plot3(mountain(:,1), mountain(:,2), mountain(:,3), ...
        'r-', 'LineWidth', 2);

    plot3(valley(:,1), valley(:,2), valley(:,3), ...
        'b--', 'LineWidth', 2);
end

view(35, 25);
legend('Mountain folds', 'Valley folds');