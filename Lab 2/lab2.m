%Output 2 Code follows
%#ok<*NOPTS>

%Magnetic Levitation Constants
M = 0.1;
La = 0.05;
Ra = 3;
g = 9.81;
km = 0.1;

%Equilibrium Value
ybar = 0.1;

%Xbar and Ubar equilibrium values.
xbar = [ybar;0;(ybar)*sqrt(g*M/km)];
ubar = ybar*Ra*sqrt(g*M/km);

%Numerical linearization matrices from Simulink
[A,B,C,D] = linmod('lab2_1', xbar,ubar);

%Theoretical numerical linearization matrices
A1 = [0 1 0; 2*km/M*((ybar*sqrt(g*M/km))^2)/(ybar^3) 0 -2*km/M*(ybar*sqrt(g*M/km))/ybar^2; 0 0 -Ra/La];
B1 = [0; 0; 1/La];
C1 = [1 0 0];
D1 = 0;

A
B
A1
B1

%Error between theoretical and Simulink matrices
errorA = norm(A-A1);
errorB = norm(B-B1);

errorA
errorB

%State space model and transfer function of Magnetic Levitation system.
ssmagBall = ss(A1,B1,C1,D1);
G_magBall = tf(ssmagBall);

%ZPK form of Real Motor
zpk_magBall = zpk(ssmagBall);

%Extract the list of poles of the transfer function
[zeros, poles, gain] = zpkdata(G_magBall);
poles = cell2mat(poles);

poles

%Eigenvalues for A matrix of linearized Magnetic Levitation system.
eigA1 = eig(A1);

eigA1


%Output 3 Code follows

% Define tuning parameters
z = 10;
p = 100;
K = 100;

% Create an LTI system object representing lead controller transfer function
num = [K (K*z)];
den = [1 p];
CONTROLLER = tf(num, den);

%Extract the list of zeros of 1 - C(s)G(s)
[zeros, poles, gain] = zpkdata(1 - (CONTROLLER * G_magBall));

