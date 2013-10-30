function [f] = prcurve(P, R, name)

f = figure;
hold on;

plot(R, P);

title(name);
xlabel('Recall');
ylabel('Precision');
set(gca, 'YGrid', 'on', 'XGrid', 'on');

hold off;

end
