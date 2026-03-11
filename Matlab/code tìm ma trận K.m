clc;clear all;

m=0.055;  %khoi luong banh xe
M=1.8915;  %khoi luong robot
R=0.0325;   %ban kinh banh xe
W=0.1938;     %chieu rong robot
D=0.17238;      %chieu sau robot
H=0.153;      %chieu cao robot
L=0.095;     %khoang cach tu trong tam den truc banh xe     
fw=0;    %he so ma sat giua banh xe voi mat phang
fm=0.0022;   %he so ma sat giua dong co va robot
Jm=0.000014762;    %moment quan tinh cua dong co
Jw=m*R^2/2;
J_psi = M*L^2/3;
J_phi = M*(W^2+D^2)/12; 
Rm=4;      %dien tro dong co DC
Kb=0.0115;   %he so emf cua dong co
Kt=0.0115;   %momemt xoan cua dong co DC
n=30;       %ti so giam toc
g=9.81;     %gia toc trong truong
a = (n*Kt)/Rm;
b = (n*Kt*Kb/Rm)+fm;
T=0.01;
x1_init = 0.01;
x2_init = 0.01;
x3_init = 0.01;
x4_init = 0.01;
x5_init = 0.01;
x6_init = 0.01;


 
A =[ 0,                                                                                                                                                                                                                                                       1,                                                                                                                                                                                                                                      0,                                                                                                                                                                                                                        0, 0,                                                                 0;
     0, -(2*J_psi*b + 2*J_psi*fw + 2*L^2*M*b + 2*L^2*M*fw + 4*Jm*fw*n^2 + 2*L*M*R*b)/(2*J_psi*Jw + 2*Jw*L^2*M + J_psi*M*R^2 + 2*J_psi*Jm*n^2 + 4*Jm*Jw*n^2 + 2*J_psi*R^2*m + 2*Jm*L^2*M*n^2 + 2*Jm*M*R^2*n^2 + 2*L^2*M*R^2*m + 4*Jm*R^2*m*n^2 + 4*Jm*L*M*R*n^2),                             -(R*g*L^2*M^2 - 2*Jm*g*L*M*n^2)/(2*J_psi*Jw + 2*Jw*L^2*M + J_psi*M*R^2 + 2*J_psi*Jm*n^2 + 4*Jm*Jw*n^2 + 2*J_psi*R^2*m + 2*Jm*L^2*M*n^2 + 2*Jm*M*R^2*n^2 + 2*L^2*M*R^2*m + 4*Jm*R^2*m*n^2 + 4*Jm*L*M*R*n^2),           (2*M*b*L^2 + 2*M*R*b*L + 2*J_psi*b)/(2*J_psi*Jw + 2*Jw*L^2*M + J_psi*M*R^2 + 2*J_psi*Jm*n^2 + 4*Jm*Jw*n^2 + 2*J_psi*R^2*m + 2*Jm*L^2*M*n^2 + 2*Jm*M*R^2*n^2 + 2*L^2*M*R^2*m + 4*Jm*R^2*m*n^2 + 4*Jm*L*M*R*n^2), 0,                                                                 0;
     0,                                                                                                                                                                                                                                                       0,                                                                                                                                                                                                                                      0,                                                                                                                                                                                                                        1, 0,                                                                 0;
     0,      (4*Jw*b + 2*M*R^2*b - 4*Jm*fw*n^2 + 4*R^2*b*m + 2*L*M*R*b + 2*L*M*R*fw)/(2*J_psi*Jw + 2*Jw*L^2*M + J_psi*M*R^2 + 2*J_psi*Jm*n^2 + 4*Jm*Jw*n^2 + 2*J_psi*R^2*m + 2*Jm*L^2*M*n^2 + 2*Jm*M*R^2*n^2 + 2*L^2*M*R^2*m + 4*Jm*R^2*m*n^2 + 4*Jm*L*M*R*n^2), (L*g*M^2*R^2 + 2*L*g*m*M*R^2 + 2*Jm*L*g*M*n^2 + 2*Jw*L*g*M)/(2*J_psi*Jw + 2*Jw*L^2*M + J_psi*M*R^2 + 2*J_psi*Jm*n^2 + 4*Jm*Jw*n^2 + 2*J_psi*R^2*m + 2*Jm*L^2*M*n^2 + 2*Jm*M*R^2*n^2 + 2*L^2*M*R^2*m + 4*Jm*R^2*m*n^2 + 4*Jm*L*M*R*n^2), -(4*Jw*b + 2*M*R^2*b + 4*R^2*b*m + 2*L*M*R*b)/(2*J_psi*Jw + 2*Jw*L^2*M + J_psi*M*R^2 + 2*J_psi*Jm*n^2 + 4*Jm*Jw*n^2 + 2*J_psi*R^2*m + 2*Jm*L^2*M*n^2 + 2*Jm*M*R^2*n^2 + 2*L^2*M*R^2*m + 4*Jm*R^2*m*n^2 + 4*Jm*L*M*R*n^2), 0,                                                                 0;
     0,                                                                                                                                                                                                                                                       0,                                                                                                                                                                                                                                      0,                                                                                                                                                                                                                        0, 0,                                                                 1;
     0,                                                                                                                                                                                                                                                       0,                                                                                                                                                                                                                                      0,                                                                                                                                                                                                                        0, 0, -(W^2*b + W^2*fw)/(m*R^2*W^2 + 2*J_phi*R^2 + Jm*W^2*n^2 + Jw*W^2)]
 
 

 B =[                                                                                                                                                                                                                    0,                                                                                                                                                                                                                    0;
                 (M*a*L^2 + M*R*a*L + J_psi*a)/(2*J_psi*Jw + 2*Jw*L^2*M + J_psi*M*R^2 + 2*J_psi*Jm*n^2 + 4*Jm*Jw*n^2 + 2*J_psi*R^2*m + 2*Jm*L^2*M*n^2 + 2*Jm*M*R^2*n^2 + 2*L^2*M*R^2*m + 4*Jm*R^2*m*n^2 + 4*Jm*L*M*R*n^2),             (M*a*L^2 + M*R*a*L + J_psi*a)/(2*J_psi*Jw + 2*Jw*L^2*M + J_psi*M*R^2 + 2*J_psi*Jm*n^2 + 4*Jm*Jw*n^2 + 2*J_psi*R^2*m + 2*Jm*L^2*M*n^2 + 2*Jm*M*R^2*n^2 + 2*L^2*M*R^2*m + 4*Jm*R^2*m*n^2 + 4*Jm*L*M*R*n^2);
                                                                                                                                                                                                                        0,                                                                                                                                                                                                                    0;
     -(2*Jw*a + M*R^2*a + 2*R^2*a*m + L*M*R*a)/(2*J_psi*Jw + 2*Jw*L^2*M + J_psi*M*R^2 + 2*J_psi*Jm*n^2 + 4*Jm*Jw*n^2 + 2*J_psi*R^2*m + 2*Jm*L^2*M*n^2 + 2*Jm*M*R^2*n^2 + 2*L^2*M*R^2*m + 4*Jm*R^2*m*n^2 + 4*Jm*L*M*R*n^2), -(2*Jw*a + M*R^2*a + 2*R^2*a*m + L*M*R*a)/(2*J_psi*Jw + 2*Jw*L^2*M + J_psi*M*R^2 + 2*J_psi*Jm*n^2 + 4*Jm*Jw*n^2 + 2*J_psi*R^2*m + 2*Jm*L^2*M*n^2 + 2*Jm*M*R^2*n^2 + 2*L^2*M*R^2*m + 4*Jm*R^2*m*n^2 + 4*Jm*L*M*R*n^2);
                                                                                                                                                                                                                        0,                                                                                                                                                                                                                    0;
                                                                                                                                                                 -(R*W*a)/(m*R^2*W^2 + 2*J_phi*R^2 + Jm*W^2*n^2 + Jw*W^2),                                                                                                                                                              (R*W*a)/(m*R^2*W^2 + 2*J_phi*R^2 + Jm*W^2*n^2 + Jw*W^2)]
 
C=[1 0 0 0 0 0;
   0 0 1 0 0 0; 
   0 0 0 0 1 0];
%% Observer
Observer = [C;C*A;C*A^2;C*A^3;C*A^4;C*A^5];
%detObserver = det(Observer) 
rank_O=rank(Observer)
%rank(obsv(A,C))
%% FIND LQR
R_ = [0.1     0;
      0     0.1];
Q = [500      0        0       0       0        0;
     0      1        0       0       0        0;
     0      0        100       0       0        0;
     0      0        0       1       0        0;
     0      0        0       0       1000        0;
     0      0        0       0       0        1];
K=lqr(A,B,Q,R_)
%% Kalman Filter
G = diag([1,1,1,1,1,1]);  
QN=0.001*diag([1,1,1,1,1,1]);
RN=[0.1     0     0;
    0     0.001    0;
    0     0     0.01];
L=lqe(A,G,C,QN,RN)
