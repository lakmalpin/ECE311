M = 1000;
B = 1;
g = 9.81;
a = B/M;
vdes = 14;
theta = -pi/6;
dbar = g*sin(theta);

num = [1];
den = [1 a];
G = tf(num, den);

p1 = 1.07;
p2 =1.07;
k = p1+p2-a;
Ti = (p1+p2-a)/(p1*p2);

num1 = [k*Ti k];
dem1 = [Ti 0];

C = tf(num1,dem1);

T = C*G/(1+C*G);

T = minreal(T);
[zeros, poles, gain] = zpkdata(T);
poles = cell2mat(poles);

z = stepinfo(T);


% Extract the numerator/denominator
[num3,den3] = tfdata(T);
% Build symbolic expression using the numerator/denominator
syms s
arrayNum = cell2mat(num3);
arrayDen = cell2mat(den3);
X2_symbolic = poly2sym(arrayNum,s)/poly2sym(arrayDen,s);
% Valid usage of ilaplace on a symbolic
x = ilaplace(X2_symbolic);

z
poles