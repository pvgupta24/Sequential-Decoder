%==========  Given generating functions and threshhold ==========%
g{1} = [1 1 0 1 1 1 0 0 1];
g{2} = [1 1 1 0 1 1 0 0 1];
threshhold = 5;
%========== 10 Zeroes for starting state (in Trellis) ==========%
start_state = [0 0 0 0 0 0 0 0 0 0]

%========== 8 Bit Input to Decode ==========%
input = [1 0 1 0 1 0 1 0];

decode(input, g, start_state)
