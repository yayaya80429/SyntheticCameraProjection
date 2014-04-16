close all
% 
[x,y,z] = peaks(100); range=1:51; x = x(range, :); y = y(range, :); z=z(range, :); pt3d = [x(:) y(:), z(:)]';
% load('bunny.mat'); pt3d = bunny;
% pt3d = randn(3, Npt);

Npt = length(pt3d);

pt3d(4, :) = ones;
% subplot(3, 1, 1);
figure
scatter3(pt3d(1, :), pt3d(2, :), pt3d(3, :), 10, 1:Npt)

width = 500;
height = 500;

fx = max(width, height); fy = max(width, height);
cx = width/2; cy = height/2;

baselineLen = 0.6;
% 
K_L = [fx, 0, cx; 0, -fy, cy; 0, 0, 1];
K_R = K_L;

theta_L = -pi/12; R_L = [cos(theta_L), -sin(theta_L), 0; 0, 1, 0; -sin(theta_L), 0, cos(theta_L)];
theta_R = pi/12; R_R = [cos(theta_R), -sin(theta_R), 0; 0, 1, 0; -sin(theta_R), 0, cos(theta_R)];
t_L = [0.2; 0; 2];
t_R = [t_L(1)-baselineLen; t_L(2); t_L(3)];


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
set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');

% subplot(3, 1, 3);
figure
scatter(pt2dR(1, :), pt2dR(2, :), 10, 1:Npt);
axis([0, width, 0, height])
set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');


coord = [0.5*eye(3), zeros(3, 1); ones(1, 4)];
% world(3, 3) = -world(3, 3);
camera_L = [R_L, t_L; zeros(1, 3), 1]\ coord; 
camera_R = [R_R, t_R; zeros(1, 3), 1]\ coord;


figure
view(3)
hold on
plot3(coord(1, [4, 1]), coord(2, [4, 1]), coord(3, [4, 1]), 'r');
plot3(coord(1, [4, 2]), coord(2, [4, 2]), coord(3, [4, 2]), 'g');
plot3(coord(1, [4, 3]), coord(2, [4, 3]), coord(3, [4, 3]), 'b');

plot3(camera_L(1, [4, 1]), camera_L(2, [4, 1]), camera_L(3, [4, 1]), 'r');
plot3(camera_L(1, [4, 2]), camera_L(2, [4, 2]), camera_L(3, [4, 2]), 'g');
plot3(camera_L(1, [4, 3]), camera_L(2, [4, 3]), camera_L(3, [4, 3]), 'b');

plot3(camera_R(1, [4, 1]), camera_R(2, [4, 1]), camera_R(3, [4, 1]), 'r');
plot3(camera_R(1, [4, 2]), camera_R(2, [4, 2]), camera_R(3, [4, 2]), 'g');
plot3(camera_R(1, [4, 3]), camera_R(2, [4, 3]), camera_R(3, [4, 3]), 'b');
scatter3(pt3d(1, :), pt3d(2, :), pt3d(3, :), 10, 1:Npt)

axis([-2, 2, -2, 2, -2, 2]);
xlabel('X'), ylabel('Y'), zlabel('Z')
grid on
hold off


%% sample pt2d on image
inRangeIdx = pt2dL(1, :) > 0 & pt2dL(1, :) < width & pt2dL(2, :) > 0 & pt2dL(2, :) < height...
    &  pt2dR(1, :) > 0 & pt2dR(1, :) < width & pt2dR(2, :) > 0 & pt2dR(2, :) < height;

sampPt_L = pt2dL(:, inRangeIdx);
sampPt_R = pt2dR(:, inRangeIdx);

%% 8-pt
A = [sampPt_R(1, :)'.*sampPt_L(1, :)' sampPt_R(1, :)'.*sampPt_L(2, :)' sampPt_R(1, :)'.*sampPt_L(3, :)' ...
sampPt_R(2, :)'.*sampPt_L(1, :)' sampPt_R(2, :)'.*sampPt_L(2, :)' sampPt_R(2, :)'.*sampPt_L(3, :)' ...
sampPt_R(3, :)'.*sampPt_L(1, :)' sampPt_R(3, :)'.*sampPt_L(2, :)' sampPt_R(3, :)'.*sampPt_L(3, :)'];

F1 = null(A);
F1 = reshape(F1, 3, 3)';

[U, D, V] = svd(A, 0);

F2 = reshape(V(:,9),3,3)';
[U,D,V] = svd(F2,0);
F3 = U*diag([D(1,1) D(2,2) 0])*V';

[sampPt_L, T1] = normalise2dpts(sampPt_L);
[sampPt_R, T2] = normalise2dpts(sampPt_R);
 % Denormalise
F4 = T2'*F3*T1;

exp1 = A*reshape(F1', 9,1);
exp2 = A*reshape(F2', 9,1);
exp3 = A*reshape(F3', 9,1);
exp4 = A*reshape(F4', 9,1);