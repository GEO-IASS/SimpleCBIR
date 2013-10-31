function [f] = prcurve(P, R, name)
% PRCURVE - Plots the precision-recall curve.
%   f = prcurve(P, R, name)
%
% Arguments:
%   P    - Vector of precision values.
%   R    - Vector of recall values.
%   name - Title of the figure.
%
% Returns:
%   f - The handle to the figure object.

f = figure;
hold on;

plot(R, P);

title(name);
xlabel('Recall');
ylabel('Precision');
set(gca, 'YGrid', 'on', 'XGrid', 'on');

hold off;

end
