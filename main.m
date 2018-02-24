%==========  Error analysis using the given parameters ========== %

g1 = [1 1 0 1 1 1 0 0 1];
g2 = [1 1 1 0 1 1 0 0 1];
threshold = 5;
m = 11;
orig_in_len = 4;
max_errors = 6;

disp('Analyzing Errors ...');
[per_detected, per_corrected] = error_percentage(orig_in_len, g1, g2, threshold, m, max_errors)

percentage = transpose([per_detected;per_corrected]);

bar(1:max_errors, percentage)

legend('% of Detected Errors','% of Corrected Errors')
ylim([0 100])
title(['Error Analysis for ' num2str(orig_in_len) , ' bit Input'])
xlabel('No. of error bits')
ylabel('Percentage')
print('BarPlot','-dpng')
