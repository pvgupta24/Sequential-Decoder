%========================================================================================================%
%==========  Error analysis - Sequential Decoding ( Fanos Algorithm for convolutional codes)  ========== %

%=========  Parameters  =========%
%=========  Generating Functions here  =========%
g1 = [1 1 0 1 1 1 0 0 1];
g2 = [1 1 1 0 1 1 0 0 1];

%=========  Given Threshhold value  =========%
threshold = 5;
%=========  No. of Memory Units (Registers)  =========%
memory_bits = 11;

%=========  No. of Input bits to be passed to encoder  =========%
input_bits = 4;
%=========  Maximum no of bits with errors in the encoded codeword for analysis  =========%
max_errors = 6;

disp('Input Bits to encoder :'num2str(input_bits));
disp('Maximum Bits with errors in encoded codeword :'num2str(max_errors));
disp('Analyzing Errors ...');

%=========  Calculating Percentage of Error deteced and corrected  =========%
[per_detected, per_corrected] = error_percentage(input_bits, g1, g2, threshold, memory_bits, max_errors)

%=========  Convert to matrix to plot as a double bar graph  =========%
percentage = transpose([per_detected;per_corrected]);
%=========  Bar Plot  =========%
bar(1:max_errors, percentage)
legend('% of Detected Errors','% of Corrected Errors')
ylim([0 100])
title(['Error Analysis for ' num2str(input_bits) , ' bit Input'])
xlabel('No. of error bits')
ylabel('Percentage')
%print('BarPlot','-dpng')
%=========  Save plot as image  =========%
print('error_analysis-'num2str(input_bits)'bit_input-'num2str(max_errors)'bit_errors','-dpng')
