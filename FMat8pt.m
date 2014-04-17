function F = FMat8pt(sampPt_L, sampPt_R)
%find fundamental matrix by 8-point algorithm

[normPt_L, T1] = normalise2dpts(sampPt_L);
[normPt_R, T2] = normalise2dpts(sampPt_R);

normA = [normPt_R(1, :)'.*normPt_L(1, :)' normPt_R(1, :)'.*normPt_L(2, :)' normPt_R(1, :)'.*normPt_L(3, :)' ...
normPt_R(2, :)'.*normPt_L(1, :)' normPt_R(2, :)'.*normPt_L(2, :)' normPt_R(2, :)'.*normPt_L(3, :)' ...
normPt_R(3, :)'.*normPt_L(1, :)' normPt_R(3, :)'.*normPt_L(2, :)' normPt_R(3, :)'.*normPt_L(3, :)'];

[~, ~, V] = svd(normA, 0);
F = reshape(V(:,9),3,3)';
[U,D,V] = svd(F,0);
F = U*diag([D(1,1) D(2,2) 0])*V';

 % Denormalise
F = T2'*F*T1;

end

