%#ok<*NOPTS>

La = 0.02;
Ra = 3;
Ke =0.01;
Kt = 0.01;
I = 6*10^-4;
b = 10^-4;

A = [0 1 0; 0 (-b/I) (Kt/I); 0 (-Ke/La) (-Ra/La)];
B = [0; 0; (1/La)];
C = [0 1 0];
D = 0;

A1 = [0 1; 0 -(b + (Ke*Kt)/Ra)/I];
B1 = [0; (Kt/(Ra/I))];
C1 = [0 1];
D1 = 0;

motor = ss(A,B,C,D);
motor_simplified = ss(A1,B1,C1,D1);

G_motor = tf(motor);
G_motor_simplified = tf(motor_simplified);

zpk_motor = zpk(motor);

[zeros, poles, gain] = zpkdata(G_motor);
poles = cell2mat(poles);

[num, den] = tfdata(G_motor);
num = cell2mat(num);
den = cell2mat(den);

[num1, den1] = tfdata(G_motor_simplified);
num1 = cell2mat(num1);
den1 = cell2mat(den1);

%{
zpk_motor 
poles
num
den
num1
den1
%}

T = linspace(0,30,1000);

subplot(3,1,1);
Y1 = step(motor, T);
plot(T,Y1);

subplot(3,1,2);
Y2 = step(motor_simplified, T);
plot(T,Y2);

subplot(3,1,3);
plot(T,Y1-Y2);
