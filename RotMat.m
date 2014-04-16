function Rot = RotMat( yaw, pitch, roll )
% return Rz(yaw)*Ry(pitch)*Rx(roll)

Rx = [ 
        1,      0,      0;
        0,  cos(roll), -sin(roll);
        0,  sin(roll),  cos(roll)];
    
Ry = [
    cos(pitch),	-sin(pitch),	0;
        0,          1,          0;
    -sin(pitch),	0,      cos(pitch)];

Rz = [
    cos(yaw),	-sin(yaw),      0;
    sin(yaw),	cos(yaw),       0;
        0,          0,          1];

   Rot = Rz * Ry * Rx;
end

