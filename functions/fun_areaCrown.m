% Default function for leaf area density distribution.
function RelativeBlockArea = fun_areaCrown(NBlock, ...
                                              BlocksParameters,...
                                              varargin)
    %-
    
    % Flag: true if block is the last in its branch, false otherwise.
    branch_Z = varargin{1}.cylinder_start_point(:,3);
    branch_crown = branch_Z>varargin{2};
    
    
    if any(branch_crown)
        % Distribute evenly to all branch tip blocks.
        RelativeBlockArea = zeros(NBlock,1);
        RelativeBlockArea(branch_crown) = 1/nnz(branch_crown);
    else
        % Fallback, if none of the blocks are marked to be last. Distribute
        % evenly to all blocks.
        RelativeBlockArea = ones(NBlock,1)/NBlock;
    end
    

end