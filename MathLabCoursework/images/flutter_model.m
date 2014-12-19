function [dq_dt, A] = flutter_model(t, q, U, p)
% function [dq_dt, A] = flutter_model(t, q, U, p)
% 
% State-space model of a 2D airfoil section with plunge and pitch DOFs.
% Quasi-steady aerodynamic approximation.
%
% q = [h, alpha, dh/dt, dalpha/dt]

% Parameters
a       = p(1); % Position of elastic axis relative to semi chord
b       = p(2); % Semi chord
mW      = p(3); % Wing mass
mT      = p(4); % Total mass
xalpha  = p(5); % Distance between elastic axis and centre of mass of the entire model
Ialpha  = p(6); % Aerofoil mass moment of inertia about elastic axis
kw0     = p(7); % Plunge stiffness
kalpha0 = p(8); % Pitch stiffness
dw      = p(9); % Plunge damping ratio
dalpha  = p(10); % Pitch damping ratio
rho     = p(11); % Density
kalpha1 = p(12); % Nonlinear stiffness (quadratic)
kalpha2 = p(13); % Nonlinear stiffness (cubic)

Salpha = xalpha*mW*b;

% Mass matrix
M = zeros(2);
M(1, 1) = mT + pi*rho*b^2;
M(1, 2) = Salpha - a*pi*rho*b^3;
M(2, 1) = M(1, 2);
M(2, 2) = Ialpha + pi*(1/8+a^2)*rho*b^4;

% Damping matrix
C = zeros(2);
C(1, 1) = dw + 2*pi*rho*b*U;
C(1, 2) = 2*(1-a)*pi*rho*b^2*U;
C(2, 1) = -2*pi*(a+0.5)*rho*b^2*U;
C(2, 2) = dalpha + a*(2*a-1)*pi*rho*b^3*U;

% Stiffness matrix
K = zeros(2);
K(1, 1) = kw0;
K(1, 2) = 2*pi*rho*b*U^2;
K(2, 1) = 0;
K(2, 2) = kalpha0 - 2*pi*(0.5+a)*rho*b^2*U^2;

% Linear state-space matrix (for speed this should really be pre-computed since it does not change with q)
A = [zeros(2), eye(2); -M\K, -M\C];

% The nonlinearity
alpha = q(2);
N = [0; 0; -M\[0; kalpha1*alpha^2 + kalpha2*alpha^3]];

% The state-space equations
dq_dt = A*q(:) + N;

end
