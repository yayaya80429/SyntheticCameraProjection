close all

% given 3d points
% [x,y,z] = sphere(100); range=1:51; x = x(range, :); y = y(range, :); z=z(range, :); pt3d = [x(:) y(:), z(:)]';
load('bunny.mat'); pt3d = bunny;
% pt3d = randn(3, Npt);
% [x, y, z] = meshgrid(-1:0.1:1, -1:0.1:1, 1); pt3d = [x(:) y(:), z(:)]';

Npt = length(pt3d);
pt3d(4, :) = ones;

% figure, scatter3(pt3d(1, :), pt3d(2, :), pt3d(3, :), 10, 1:Npt)

% intrinsic parameters
width = 500;
height = 500;

fx = max(width, height); fy = max(width, height);
cx = width/2; cy = height/2;

baselineLen = 0.6;

% extrinsic parameters(defined at world coordinate)
yaw_L = 0; pitch_L = 0; roll_L = 0; % z, y, x
yaw_R = 0; pitch_R = -pi/12; roll_R = 0; % z, y, x
cam_L = [-0.2; 0.2; -1.75];
cam_R = [0.2; 0.2; -1.75];
%% synth proj
RunSyntheticProj

% distort it
pt2dL(1:2, :) = pt2dL(1:2, :) - repmat([cx; cy], 1, Npt);
pt2dL(1:2, :) = pt2dL(1:2, :) .* repmat( 1-8e-6*sum(pt2dL(1:2, :).^2), 2, 1);
pt2dL(1:2, :) = pt2dL(1:2, :) + repmat([cx; cy], 1, Npt);
% % show views
% ShowView(pt2dL, Npt, width, height);
% ShowView(pt2dR, Npt, width, height);

% % show world
% ShowWorld( R_L, t_L, R_R, t_R, pt3d, Npt )

%% sample pt2d on image
inRangeIdx = pt2dL(1, :) > 0 & pt2dL(1, :) < width & pt2dL(2, :) > 0 & pt2dL(2, :) < height...
    &  pt2dR(1, :) > 0 & pt2dR(1, :) < width & pt2dR(2, :) > 0 & pt2dR(2, :) < height;

sampPt_L = pt2dL(:, inRangeIdx);
sampPt_R = pt2dR(:, inRangeIdx);

%% 8-pt

F = FMat8pt(sampPt_L, sampPt_R);

A = [sampPt_R(1, :)'.*sampPt_L(1, :)' sampPt_R(1, :)'.*sampPt_L(2, :)' sampPt_R(1, :)'.*sampPt_L(3, :)' ...
sampPt_R(2, :)'.*sampPt_L(1, :)' sampPt_R(2, :)'.*sampPt_L(2, :)' sampPt_R(2, :)'.*sampPt_L(3, :)' ...
sampPt_R(3, :)'.*sampPt_L(1, :)' sampPt_R(3, :)'.*sampPt_L(2, :)' sampPt_R(3, :)'.*sampPt_L(3, :)'];

errs = A*reshape(F', 9,1);

% draw epipolar lines
nLines = 50;
randIdx = randi(nnz(inRangeIdx), nLines, 1);

ShowView(pt2dL, Npt, width, height);
hold on
plot(sampPt_L(1, randIdx), sampPt_L(2, randIdx), 'kx');
hold off
ShowView(pt2dR, Npt, width, height);
hold on
% plot(sampPt_R(1, randIdx), sampPt_R(2, randIdx), 'wx');
xx = [0; width];
lines = F2 * sampPt_L(:, randIdx);
yy1 = cross(lines, repmat([1; 0; -xx(1)], 1, nLines)); 
yy1 = yy1 ./ repmat(yy1(3, :), 3, 1);
yy2 = cross(lines, repmat([1; 0; -xx(2)], 1, nLines)); 
yy2 = yy2 ./ repmat(yy2(3, :), 3, 1);
plot(xx, [yy1(2, :); yy2(2, :)], 'k');
hold off
