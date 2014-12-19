% Get the default parameters
par = flutter_parameters();
U = 1; % Flow speed 1 m/s

% Run ODE45 with U = 1
sol = ode45(@(t, q)flutter_model(t, q, U, par), [0, 10], [0.1, 0, 0, 0]);

% Plot the results on a linear mesh
t = linspace(sol.x(1), sol.x(end), 2001);
q = deval(sol, t);
disp (q);
plot(t, q(1, :), 'b-', t, q(2, :), 'r-');
legend({'h(t)', 'alpha(t)'});
xlabel('Time [s]');
ylabel('Displacement [m] / angle [rad]');
