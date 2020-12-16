% Default function for leaf area density distribution.
function RelativeBlockArea = fun_areaBranch3(NBlock, ...
                                              BlocksParameters,...
                                              varargin)
    %-
    
    % Flag: true if block is the last in its branch, false otherwise.
    branch_order = BlocksParameters.branch_order;
    branch_order3 = branch_order>3;
    
    
    if any(branch_order3)
        % Distribute evenly to all branch tip blocks.
        RelativeBlockArea = zeros(NBlock,1);
        RelativeBlockArea(branch_order3) = 1/nnz(branch_order3);
    else
        % Fallback, if none of the blocks are marked to be last. Distribute
        % evenly to all blocks.
        RelativeBlockArea = ones(NBlock,1)/NBlock;
    end
    

end