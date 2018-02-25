function code = decode(conv_code, g1, g2, cur_state, err_count, threshhold, m)
    % Function to recursively decode the received codeword using sequential decoding technique
    
    
    %=========  Return if exceeds threshhold =========%  
    if(err_count >= threshhold)
        code = [];
        return
    end    
    
    
    %=========  Return if last stage is reached  =========%
    if(length(conv_code) <= 0)
        code = [];
        return
    end

    %=========  Analyse the first 2 bits of codeword and the current state  =========%    
    conv_2bit = conv_code(1:2);    

    %=========  Get next possible states for 2 possibilities : 0 and 1  =========%
    [next_state_0, output_0] = getNextState(0, cur_state, g1, g2, m);
    [next_state_1, output_1] = getNextState(1, cur_state, g1, g2, m);
  

    %=========  Exact match('0' decoded) => Error count remains same  =========%
    if(isequal(output_0, conv_2bit))
        code = [0 decode(conv_code(3:end), g1, g2, next_state_0, err_count, threshhold, m)];
        
        % Return if reaches last stage i.e decodes successfully, else backtrack and continue
        if(length(code) == (length(conv_code)/2))
            return
        end
    end
    
    %=========  Exact match('1' decoded) => Error count remains same  =========%    
    if(isequal(output_1, conv_2bit))
        code = [1 decode(conv_code(3:end), g1, g2, next_state_1, err_count, threshhold, m)];
        if(length(code) == (length(conv_code)/2))
            return
        end
    end
    
    %=========  1-Bit Error('0' guessed) => Error count +=1  =========%    
    if(xor((output_0(1) == conv_2bit(1)),(output_0(2) == conv_2bit(2))))
        code = [0 decode(conv_code(3:end), g1, g2, next_state_0, err_count+1, threshhold, m)];
        if(length(code) == (length(conv_code)/2))
            return
        end
        %code = code(2:end);
    end  
    
    %=========  1-Bit Error('1' guessed) => Error count +=1  =========%    
    if(xor((output_1(1) == conv_2bit(1)), (output_1(2) == conv_2bit(2))))
        code = [1 decode(conv_code(3:end), g1, g2, next_state_1, err_count+1, threshhold, m)];
        if(length(code) == (length(conv_code)/2))
            return
        end
    end
    

    %=========  No match('0' guessed) => Error count +=2  =========%    
    if((output_0(1) ~= conv_2bit(1)) && (output_0(2) ~= conv_2bit(2)))
        code = [0 decode(conv_code(3:end), g1, g2, next_state_0, err_count+2, threshhold, m)];
        if(length(code) == (length(conv_code)/2))
            return
        end
    end 
    
    %=========  No match('1' guessed) => Error count +=2  =========%    
    if((output_1(1) ~= conv_2bit(1)) && (output_1(2) ~= conv_2bit(2)))
        code = [1 decode(conv_code(3:end), g1, g2, next_state_0, err_count+2, threshhold, m)];
        if(length(code) == (length(conv_code)/2))
            return
        end
    end

    %=========  Could not Decode => Error detected not corrected  =========%    
    code = [];
    return;
end