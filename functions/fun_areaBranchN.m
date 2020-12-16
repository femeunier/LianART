% Default function for leaf area density distribution.
function RelativeBlockArea = fun_areaBranchN(NBlock, ...
                                              BlocksParameters,...
                                              varargin)
    %-
    
    % Flag: true if block is the last in its branch, false otherwise.
    branch_order = BlocksParameters.branch_order;
    branch_orderN = branch_order>varargin{1};
    
    
    if any(branch_orderN)
        % Distribute evenly to all branch tip blocks.
        RelativeBlockArea = zeros(NBlock,1);
        RelativeBlockArea(branch_orderN) = 1/nnz(branch_orderN);
    else
        % Fallback, if none of the blocks are marked to be last. Distribute
        % evenly to all blocks.
        RelativeBlockArea = ones(NBlock,1)/NBlock;
    end
    

end