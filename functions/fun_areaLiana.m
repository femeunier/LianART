% Default function for leaf area density distribution.
function RelativeBlockArea = fun_areaLiana(NBlock, ...
                                              BlocksParameters,...
                                              varargin)
    %-
    
    % Flag: true if block is the last in its branch, false otherwise.
    is_liana = varargin{1};
    branch_Z = varargin{2}.cylinder_start_point(:,3);
    branch_crown = branch_Z>varargin{3};
    
    if any(is_liana & branch_crown)
        % Distribute evenly to all branch tip blocks.
        RelativeBlockArea = zeros(NBlock,1);
        RelativeBlockArea(is_liana & branch_crown) = 1/nnz(is_liana & branch_crown);
    else
        % Fallback, if none of the blocks are marked to be last. Distribute
        % evenly to all blocks.
        RelativeBlockArea = ones(NBlock,1)/NBlock;
    end
    

end