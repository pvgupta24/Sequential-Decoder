function conv_code = encode(in_code, g1, g2, m)
    % function to find the convolutional code for given input code (input code must be padded with zeros)

    cur_state = zeros(1, m-1);            % intial state is [0 0 0 ...]
    conv_code = [];         
    len_in_code = length(in_code);        % length of input code padded with zeros
    for i=1:len_in_code 
        in_bit = in_code(i);              % 1 bit input 
        [cur_state, output] = getNextState(in_bit, cur_state, g1, g2, m);    % transition to next state and corresponding 2 bit convolution output
        conv_code = [conv_code output];   % append the 2 bit output to convolutional code
    end    
    
end