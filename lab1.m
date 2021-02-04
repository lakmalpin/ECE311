%#ok<*NOPTS>

%Armature constants
La = 0.02;
Ra = 3;
Ke =0.01;
Kt = 0.01;
I = 6*10^-4;
b = 10^-4;

%Motor State Space Matrices
A = [0 1 0; 0 (-b/I) (Kt/I); 0 (-Ke/La) (-Ra/La)];
B = [0; 0; (1/La)];
C = [0 1 0];
D = 0;

%Simplified Motor State Space Matrices
A1 = [0 1; 0 -(b + (Ke*Kt)/Ra)/I];
B1 = [0; (Kt/(Ra*I))];
C1 = [0 1];
D1 = 0;

%State Space model for Motor and Simplified Motor
motor = ss(A,B,C,D);
motor_simplified = ss(A1,B1,C1,D1);

%Transfer Function for Motor and Simplified Motor
G_motor = tf(motor);
G_motor_simplified = tf(motor_simplified);

%ZPK form of Real Motor
zpk_motor = zpk(motor);

%Extract the list of poles of the transfer function of Motor
[zeros, poles, gain] = zpkdata(G_motor);
poles = cell2mat(poles);

%extract numerator and denominator arrays from Motor transfer function
[num, den] = tfdata(G_motor);
num = cell2mat(num);
den = cell2mat(den);

%extract numerator and denominator arrays from Simplified Motor transfer function
[num1, den1] = tfdata(G_motor_simplified);
num1 = cell2mat(num1);
den1 = cell2mat(den1);

G_motor
G_motor_simplified
zpk_motor 
poles
num
den
num1
den1


%times
T = linspace(0,30,1000);

%First subplot
subplot(3,1,1);

%Plot step response of state space model of Motor
Y1 = step(motor, T);
plot(T,Y1)
title('Real Motor: Speed vs. Time with Step Response')
xlabel('Time (s)')
ylabel('Speed (m/s)')

%The approximate asymptotic value of motor speed in response to a unit step
approx = Y1(1000)

%Second subplot
subplot(3,1,2);

%Plot step response of state space model of Simplified Motor
Y2 = step(motor_simplified, T);
plot(T,Y2);
title('Simplified Armature: Speed vs. Time with Step Response')
xlabel('Time (s)')
ylabel('Speed (m/s)')

%Third subplot
subplot(3,1,3);

%Plot the difference between the first and second subplot
plot(T,Y1-Y2);
title({'Difference between Real and Simplified Armature:','Speed vs. Time with Step Response'})
xlabel('Time (s)')
ylabel('Speed (m/s)')

%Finds magnitude of error using third subplot
error = abs(min(Y1-Y2))

figure();

%Final Value Theorem of Motor Transfer Function to find Theoretical Asymptotic Value
syms s;
TAV = limit(833.3/(s^2+150.2*s+33.33));

TAV

%State Space Model of Motor with Output as Armature Current
C_current = [0 0 1];
motor_armature_current = ss(A,B,C_current,D);

%Plot step response of state space model of Motor with Current Output 
Y3 = step(motor_armature_current, T);
plot(T,Y3);
title('Real Armature: Current vs. Time with Step Response')
xlabel('Time (s)')
ylabel('Current (A)')

figure();

%Plots the time response of the State Space Model of Motor with a sinusodial input
X0 = [0;-1;.5];
lsim(motor,sin(T),T,X0);
title('Real Armature: Output Response with Input Sinusoidal Signal')
ylabel('Speed (m/s)')

%Calculate the average amplitude of previous plot
y = lsim(motor,sin(T),T,X0);
amp1 = rms(y)*(sqrt(2));
amp1

%Evaluate the frequency response of the motor transfer function at s = i
s = 1i;
motor_at_i = evalfr(G_motor,s);
motor_at_i

%Verify that previous amplitude is approximately |G(i)|
theoretical_Amp = abs(motor_at_i);
theoretical_Amp

%Max error, approximate asymptotic motor speed, theoretical " " ", fix
%variable names
