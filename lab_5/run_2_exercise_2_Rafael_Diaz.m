%2.b 
clc; clear; close all;

% =========================================================================
% EXERCISE 2.b - Automatic Taylor degree selection for f(x) = e^x
% Three cases (A, B, C), tol = 1e-6, maxDegree = 30
% =========================================================================

tol       = 1e-6;
maxDegree = 30;
Npts      = 10001;

% ---- Case definitions: [a, b, x0, M] ----
caseNames = {'A', 'B', 'C'};
a_vals  = [-1, 1, 1];
b_vals  = [ 1, 2, 2];
x0_vals = [ 0, 0, 1.5];
M_vals  = [exp(1), exp(2), exp(2)];

% Storage for the summary table
R_all       = zeros(1,3);
n_all       = zeros(1,3);
bound_all   = zeros(1,3);
maxErr_all  = zeros(1,3);

for i = 1:3
    a  = a_vals(i);
    b  = b_vals(i);
    x0 = x0_vals(i);
    M  = M_vals(i);

    % ---- Step 1: select the degree using Exercise 2a ----
    [n, R, degreeTable] = my_taylor_degree_Rafael_Diaz(a, b, x0, M, tol, maxDegree);

    fprintf('\n=== CASE %s: [a,b] = [%g, %g], x0 = %g, M = %g ===\n', ...
        caseNames{i}, a, b, x0, M);
    disp(degreeTable);
    fprintf('Selected degree n = %d, R = %g\n', n, R);

    % ---- Step 2: evaluate the selected Taylor approximation ----
    x = linspace(a, b, Npts);
    f = exp(x);

    % Derivatives of e^x at x0 are all equal to e^x0
    D = exp(x0) * ones(1, n+1);

    T = my_taylor_Rafael_Diaz(x0, D, n, x);

    err = abs(f - T);
    maxErr = max(err);

    % ---- Store results for summary table ----
    R_all(i)      = R;
    n_all(i)      = n;
    bound_all(i)  = degreeTable.ErrorBound(n+1);   % bound for selected n
    maxErr_all(i) = maxErr;
end

% ---- Summary table ----
disp(' ');
disp('=== SUMMARY TABLE - ALL CASES ===');
SummaryTable = table(caseNames', R_all', n_all', bound_all', maxErr_all', ...
    'VariableNames', {'Case', 'R', 'Degree', 'ErrorBound', 'MaxAbsError'});
disp(SummaryTable);

% ---- Numerical comparison: Case B vs Case C ----
disp(' ');
disp('=== COMPARISON: CASE B vs CASE C ===');
fprintf(['Case B (x0 = 0) needs degree n = %d to reach the tolerance, ' ...
    'while Case C (x0 = 1.5) only needs degree n = %d.\n'], ...
    n_all(2), n_all(3));
disp(['This happens because both cases cover the same interval [1,2] and ', ...
    'use the same M, but Case C centers the expansion inside the ', ...
    'interval (x0 = 1.5), which makes R roughly half of what it is in ', ...
    'Case B (x0 = 0, at the edge of the interval). Since the error ', ...
    'bound depends on R^(n+1), a smaller R lets the bound drop below ', ...
    'the tolerance at a much lower degree. This shows that choosing ', ...
    'the expansion center close to the region of interest can ', ...
    'drastically reduce the number of terms needed for the same accuracy.']);