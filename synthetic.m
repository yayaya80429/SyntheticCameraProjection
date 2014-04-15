% close all
% 
% % [x,y,z] = sphere; pt3d = [x(:), y(:), z(:)]';
% pt3d = bunny;
% % pt3d = randn(3, Npt);
% 
% Npt = length(pt3d);
% 
% pt3d(4, :) = ones;
% % subplot(3, 1, 1);
% figure
% scatter3(pt3d(1, :), pt3d(2, :), pt3d(3, :), 10, 1:Npt)

width = 500;
height = 500;

fx = max(width, height); fy = max(width, height);
cx = width/2; cy = height/2;

baselineLen = 0.8;

K_L = [fx, 0, cx; 0, fy, cy; 0, 0, 1];
K_R = K_L;

theta_L = -pi/12; R_L = [cos(theta_L), -sin(theta_L), 0; 0, 1, 0; sin(theta_L), cos(theta_L), 0];
theta_R = pi/12; R_R = [cos(theta_R), -sin(theta_R), 0; 0, 1, 0; sin(theta_R), cos(theta_R), 0];
t_L = [0; 0; 2];
t_R = [t_L(1)+baselineLen; t_L(2); t_L(3)];


P_L = K_L * [R_L t_L];
P_R = K_R * [R_R t_R];

pt2dL = P_L * pt3d;
pt2dR = P_R * pt3d;

pt2dL = pt2dL ./ repmat(pt2dL(3, :), 3, 1);
pt2dR = pt2dR ./ repmat(pt2dR(3, :), 3, 1);

% subplot(3, 1, 2);
figure
scatter(pt2dL(1, :), pt2dL(2, :), 10, 1:Npt);
axis([0, width, 0, height])

% subplot(3, 1, 3);
figure
scatter(pt2dR(1, :), pt2dR(2, :), 10, 1:Npt);
axis([0, width, 0, height])

% 
% world = [0.1*eye(3), zeros(3, 1); zeros(1, 3), 1];
% camera_L = [R_L, t_L; zeros(1, 3), 1] *world;
% center_L = [R_L, t_L; zeros(1, 3), 1] * [0, 0, 0, 1]';
% camera_R = [R_R, t_R; zeros(1, 3), 1] *world;
% center_R = [R_R, t_R; zeros(1, 3), 1] * [0, 0, 0, 1]';

% camera_L = camera_L ./ camera_L(4, 4);
% camera_R = camera_R ./ camera_R(4, 4);

% figure
% view(3)
% hold on
% % plot3([0, 0.1], [0, 0], [0, 0], 'r');
% % plot3([0, 0], [0, 0.1], [0, 0], 'g');
% % plot3([0, 0], [0, 0], [0.1, 0], 'b');
% 
% plot3([center_L(1), camera_L(1, 1)], [center_L(2), camera_L(2, 1)], [center_L(3), camera_L(3, 1)], 'r');
% plot3([center_L(1), camera_L(1, 2)], [center_L(2), camera_L(2, 2)], [center_L(3), camera_L(3, 2)], 'g');
% plot3([center_L(1), camera_L(1, 3)], [center_L(2), camera_L(2, 3)], [center_L(3), camera_L(3, 3)], 'b');
% 
% % plot3([center_R(1), camera_R(1, 1)], [center_R(2), camera_R(2, 1)], [center_R(3), camera_R(3, 1)], 'r');
% % plot3([center_R(1), camera_R(1, 2)], [center_R(2), camera_R(2, 2)], [center_R(3), camera_R(3, 2)], 'g');
% % plot3([center_R(1), camera_R(1, 3)], [center_R(2), camera_R(2, 3)], [center_R(3), camera_R(3, 3)], 'b');
% axis([-3, 3, -3, 3, -3, 3]);
% hold off
