La = 0.02;
Ra = 3;
Ke =0.01;
Kt = 0.01;
I = 6*10^-4;
b = 10^-4;

A = [0 1 0; 0 (-b/I) (Kt/I); 0 (-Ke/La) (-Ra/La)];
B = [0; 0; (1/La)];
C = [0; 1; 0];
D = zeros(3,1);

disp(A)

A1 = [0 1; 0 -(b + (Ke*Kt)/Ra)/I];
B1 = [0; Kt/(Ra/I)];
C1 = [0; 1];
D1 = zeros(2,1);

disp(A1)