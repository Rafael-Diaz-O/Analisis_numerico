%2.a
function [n, R, degreeTable] = my_taylor_degree_Rafael_Diaz(a, b, x0, M, tol, maxDegree)
% MY_TAYLOR_DEGREE_FIRSTNAME_LASTNAME  Selects the smallest Taylor degree
% whose Lagrange error bound is below a given tolerance.
%
%   [n, R, degreeTable] = my_taylor_degree_firstname_lastname(a, b, x0, M, tol, maxDegree)
%
%   Inputs:
%       a, b      - interval endpoints, [a, b]
%       x0        - center of the Taylor expansion
%       M         - bound on |f^(n+1)(xi)| valid for all degrees considered
%       tol       - desired tolerance for the error bound
%       maxDegree - maximum degree to try
%
%   Outputs:
%       n           - smallest degree n <= maxDegree such that B_n < tol
%                     (if no such degree exists, n = maxDegree and a
%                     warning is issued)
%       R           - maximum distance from x0 to the interval [a, b]
%       degreeTable - table with columns Degree and ErrorBound for
%                     degrees 0, 1, ..., maxDegree
%
%   Error bound formula (Lagrange remainder):
%       B_n = M * R^(n+1) / (n+1)!

% ---- Compute R: maximum distance from x0 to the interval ----
R = max(abs(a - x0), abs(b - x0));

% ---- Compute the error bound for every degree from 0 to maxDegree ----
degrees     = (0:maxDegree)';
errorBounds = zeros(size(degrees));

for k = 0:maxDegree
    errorBounds(k+1) = M * R^(k+1) / factorial(k+1);
end

degreeTable = table(degrees, errorBounds, ...
    'VariableNames', {'Degree', 'ErrorBound'});

% ---- Find the smallest degree meeting the tolerance ----
idx = find(errorBounds < tol, 1, 'first');

if isempty(idx)
    % Tolerance cannot be met within maxDegree
    warning(['Tolerance tol = %g could not be met for any degree up to ' ...
        'maxDegree = %d. Returning n = maxDegree with its error ' ...
        'bound = %g. Consider increasing maxDegree or relaxing tol.'], ...
        tol, maxDegree, errorBounds(end));
    n = maxDegree;
else
    n = degrees(idx);
end

end