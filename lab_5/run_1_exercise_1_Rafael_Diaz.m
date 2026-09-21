%1.b
clc; clear; close all;

% =========================================================================
% EXERCISE 1.b - Taylor approximation of f(x) = e^x on [-1, 1]
% Degrees: 2, 4, 6 ; centered at x0 = 0
% =========================================================================

% ---- Setup ----
x0 = 0;                        % center of expansion
a  = -1; b = 1;                % interval
Npts = 10001;                  % number of evaluation points
x = linspace(a, b, Npts);      % evaluation points

f = exp(x);                    % true function values

degrees = [2, 4, 6];           % degrees to test
maxErr  = zeros(size(degrees));% to store max absolute error per degree

% Colors for plotting
colors = {'r', 'g', 'm'};

% ---- Figure 1: function vs approximations ----
figure(1);
plot(x, f, 'b-', 'LineWidth', 2, 'DisplayName', 'e^x (exact)');
hold on;

% ---- Figure 2: absolute errors ----
figure(2);
hold on;

for i = 1:length(degrees)
    n = degrees(i);

    % Derivatives of e^x at x0 = 0 are all equal to e^0 = 1
    D = ones(1, n+1);   % D = [f(x0), f'(x0), ..., f^(n)(x0)]

    % Evaluate Taylor polynomial using the function from Exercise 1a
    T = my_taylor_Rafael_Diaz(x0, D, n, x);

    % Absolute error
    err = abs(f - T);
    maxErr(i) = max(err);

    % Add to function plot
    figure(1);
    plot(x, T, colors{i}, 'LineWidth', 1.5, ...
        'DisplayName', sprintf('Taylor n = %d', n));

    % Add to error plot
    figure(2);
    plot(x, err, colors{i}, 'LineWidth', 1.5, ...
        'DisplayName', sprintf('Error n = %d', n));
end

% ---- Finish Figure 1 ----
figure(1);
xlabel('x');
ylabel('f(x)');
title('e^x and its Taylor approximations on [-1, 1]');
legend('Location', 'northwest');
grid on;

% ---- Finish Figure 2 ----
figure(2);
xlabel('x');
ylabel('Absolute error');
title('Absolute error of Taylor approximations');
legend('Location', 'northwest');
grid on;
% Log scale often makes error comparison easier to read
set(gca, 'YScale', 'log');

% ---- Error table ----
disp('=== EXERCISE 1.b - MAXIMUM ABSOLUTE ERROR ===');
T_table = table(degrees', maxErr', ...
    'VariableNames', {'Degree', 'MaxAbsError'});
disp(T_table);

% ---- Numerical comparison ----
disp(' ');
disp('=== NUMERICAL COMPARISON ===');
fprintf('For degree 2, the maximum absolute error is %.6e.\n', maxErr(1));
fprintf('For degree 4, the maximum absolute error is %.6e.\n', maxErr(2));
fprintf('For degree 6, the maximum absolute error is %.6e.\n', maxErr(3));
disp(['As the degree increases, the Taylor polynomial matches e^x over ', ...
    'a wider portion of the interval, and the maximum absolute error ', ...
    'decreases substantially (by roughly one to two orders of ', ...
    'magnitude per added even degree). This is expected since the ', ...
    'remainder term of the Taylor series depends on (x-x0)^(n+1), ', ...
    'which shrinks quickly on [-1,1] as n grows, and on 1/(n+1)!, ', ...
    'which shrinks even faster.']);