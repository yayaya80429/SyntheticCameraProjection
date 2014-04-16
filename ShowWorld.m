function ShowWorld( R_L, t_L, R_R, t_R, pt3d, Npt )
%plot world with cameras
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

% axis([-2, 2, -2, 2, -2, 2]);
xlabel('X'), ylabel('Y'), zlabel('Z')
grid on
hold off

end

