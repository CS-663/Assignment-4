tic;
% Test Input Matrix => A
A = randi(21, 5, 7);
[U0, S0, V0] = svd(A);
[U1, S1, V1] = mySVD(A);
A1 = U1*S1*V1';
A0 = U0*S0*V0';
A0
A1

toc;