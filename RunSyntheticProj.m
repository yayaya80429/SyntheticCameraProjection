% calculate K, R, t
K_L = [fx, 0, cx; 0, -fy, cy; 0, 0, 1];
K_R = K_L;

R_L = RotMat(yaw_L, pitch_L, roll_L)';
R_R = RotMat(yaw_R, pitch_R, roll_R)';
t_L = R_L * -cam_L;
t_R = R_R * -cam_R;

% Project it
P_L = K_L * [R_L t_L];
P_R = K_R * [R_R t_R];

pt2dL = P_L * pt3d;
pt2dR = P_R * pt3d;   

pt2dL = pt2dL ./ repmat(pt2dL(3, :), 3, 1);
pt2dR = pt2dR ./ repmat(pt2dR(3, :), 3, 1);