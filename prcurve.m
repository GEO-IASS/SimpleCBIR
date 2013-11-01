function [f] = prcurve(P, R, name, legends={})
% PRCURVE - Plots the precision-recall curve.
%   f = prcurve(P, R, name)
%
% Arguments:
%   P       - Vector of precision values.
%   R       - Vector of recall values.
%   name    - Title of the figure.
%   legends - Legends of the figure.
%
% Returns:
%   f - The handle to the figure object.

colors = 'brgkmcyw';
nColors = length(colors);
nLines = length(P);

f = figure;
hold on;

arrayfun(@(idx) plot(R{idx}, P{idx}, colors(mod(idx, nColors))), 1:nLines);

title(name);
legend(legends{:});
xlabel('Recall');
ylabel('Precision');
set(gca, 'YGrid', 'on', 'XGrid', 'on');

hold off;

end
