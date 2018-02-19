%==========  Given generating functions and threshhold ==========%
g1 = [1 1 0 1 1 1 0 0 1];
g2 = [1 1 1 0 1 1 0 0 1];
threshhold = 5;
%========== 10 Zeroes for starting state (in Trellis) ==========%
start_state = [0 0 0 0 0 0 0 0 0 0];
error_count =0;
m = 11;
%========== 8 Bit Input to Decode ==========%
input = [1 0 1 0 1 0 1 0];

decode(input, g1, g2, start_state, error_count, threshhold, m)
