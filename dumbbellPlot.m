function ax = dumbbellPlot(X, varargin)
%% dumbbellPlot creates a dumbbell chart comparing two sets of values
%
%% Start of code

plotType= "single"; %default
plotTypeidx= find(strcmp(varargin, "plotType"));
if ~isempty(plotTypeidx)
    if plotTypeidx + 1 <= length(varargin)
        plotType = varargin{plotTypeidx + 1};
    else
        error("dumbbellPlot:MissingPlotTypeValue", "plotType 'name',value argument requires a value")
    end
end
%% Required input validation
if nargin < 1
    error("dumbbellPlot:MissingRequiredInput", "Missing required input argument X")
end

% check X, it can be vector, or tabel
if istable(X)
    switch width(X)
        case 1
            if length(varargin) < 1
                error("dumbbellPlot:MissingRequiredInput", "When X is a single-column table, a second set of values must be provided")
            end

            X1= X{:,1};
            labelX1= X.Properties.VariableNames{1};

            if istable(varargin{1})
                if width(varargin{1}) ~= 1
                    error("dumbbellPlot:InvalidTableWidth", ...
                        "Second table argument must have exactly one column")
                end
                X2 = varargin{1}{:,1};
                labelX2= varargin{1}.Properties.VariableNames{1};
                vararginStart = 2;

            elseif isnumeric(varargin{1}) && isvector(varargin{1})
                if length(varargin{1}) ~= length(X1)
                    error("dumbbellPlot:DimensionMismatch", "X2 length must match X1 length")
                end
                X2 = varargin{1};
                labelX2= "X2";
                vararginStart = 2;
            else
                error("dumbbellPlot:WrongInput", ...
                    "X2 must be a single-column table or numeric vector with compatible size")
            end

        case 2
            if plotType ~= "single"
                error("dumbbellPlot:WrongInput", "Tables with 2 variables are only accepted if plotType is 'single'")
            end

            X1 = X{:,1};
            X2 = X{:,2};
            labelX1= X.Properties.VariableNames{1};
            labelX2= X.Properties.VariableNames{2};
            vararginStart= 1;

        otherwise %3 or more columns
            if plotType == "double"
                if width(X) == 4
                    X1 = X{:,1};
                    X2 = X{:,2};
                    X3 = X{:,3};
                    X4 = X{:,4};

                    % not sure if to leave default, TO BE DECIDED
                    labelX1 = X.Properties.VariableNames{1};
                    labelX2 = X.Properties.VariableNames{2};
                    vararginStart = 1;
                else
                    if length(varargin) < 4
                        error("dumbbellPlot:MissingTableVariables", ...
                            "When X is a multi-column table, you must specify 4 variable names for Value1, 2, 3 and 4 in a double plotType")
                    end



                    varNames = {varargin{1}, varargin{2}, varargin{3}, varargin{4}};
                    for i = 1:4
                        if ~(ischar(varNames{i}) || isstring(varNames{i}))
                            error("dumbbellPlot:InvalidVariableName", ...
                                "Variable name %d must be a string or character array", i);
                        end
                        if ~ismember(varNames{i}, X.Properties.VariableNames)
                            error("dumbbellPlot:VariableNotFound", ...
                                "Variable '%s' not found in table", varNames{i});
                        end
                    end

                    vararginStart= 5;

                    % assign data set values
                    X1= X.(varNames{1});
                    X2= X.(varNames{2});
                    X3= X.(varNames{3});
                    X4= X.(varNames{4});

                    % not sure if leaving default is better DECIDE LATER
                    labelX1 = varNames{1};
                    labelX2 = varNames{2};

                end

            elseif plotType == "single"
                if length(varargin) < 2
                    error("dumbbellPlot:MissingTableVariables", ...
                        "When X is a multi-column table, you must specify two variable names for Value1 and Value2")
                end

                varName1 = varargin{1};
                varName2 = varargin{2};
                vararginStart= 3;

                if ~(ischar(varName1) || isstring(varName1))
                    error("dumbbellPlot:InvalidVariableName", "Variable name 1 must be a string or character array")
                end
                if ~(ischar(varName2) || isstring(varName2))
                    error("dumbbellPlot:InvalidVariableName", "Variable name 2 must be a string or character array")
                end

                if ~ismember(varName1, X.Properties.VariableNames)
                    error("dumbbellPlot:VariableNotFound", "Variable '%s' not found in table", varName1)
                end
                if ~ismember(varName2, X.Properties.VariableNames)
                    error("dumbbellPlot:VariableNotFound", "Variable '%s' not found in table", varName2)
                end

                X1= X.(varName1);
                X2= X.(varName2);
                labelX1 = varName1;
                labelX2 = varName2;

            end
    end

    % add Yticklabels from table or set default ones
    if ~isempty(X.Properties.RowNames)
        YLabels = X.Properties.RowNames;
    else
        YLabels = cellstr("Row " + string(1:length(X1)));
    end

elseif isvector(X) && isnumeric(X)
    if length(varargin) < 1
        error("dumbbellPlot:MissingRequiredInput", "If X1 is a vector, a second vector is required")
    end
    if ~(isvector(varargin{1}) && isnumeric(varargin{1}))
        error("dumbbellPlot:MissingRequiredInput", "Second input argument is not a numeric vector")
    end

    X1= X;
    X2= varargin{1};
    vararginStart= 2;
    if length(X1) ~= length(X2)
        error("dumbbellPlot:DimensionMismatch", ...
            "All data vectors must have the same length");
    end

    labelX1 = "X1";
    labelX2 = "X2";
    YLabels = cellstr("Row" + string(1:length(X1)));
    if plotType == "double"
        if length(varargin) < 3
            error("dumbbellPlot:MissingRequiredInput", "If plotType is 'double', 4 sets of data must be inserted")
        end
        if ~(isvector(varargin{2}) && isnumeric(varargin{2}))
            error("dumbbellPlot:MissingRequiredInput", "Third input argument is not a numeric vector")
        end
        if ~(isvector(varargin{3}) && isnumeric(varargin{3}))
            error("dumbbellPlot:MissingRequiredInput", "Fourth input argument is not a numeric vector")
        end

        X3= varargin{2};
        X4= varargin{3};
        vararginStart= 4;

        if length(X3) ~= length(X1) || length(X4) ~= length(X1)
            error("dumbbellPlot:DimensionMismatch", ...
                "All data vectors must have the same length");
        end
    end
else
    error("dumbbellPlot:InvalidInputType", "X must be a table or a numeric vector")
end

%% optional inputs
% store the additional inputs
options = struct();
if length(varargin) >= vararginStart
    for i = vararginStart:2:length(varargin)
        if i+1 <= length(varargin)
            options.(varargin{i}) = varargin{i+1};
        end
    end
end

if isfield(options, "labelX1")
    validateattributes(options.labelX1, {'string', 'char'}, {}, 'dumbellPlot', 'labelX1')
    labelX1 = string(options.labelX1);
end

if isfield(options, "labelX2")
    validateattributes(options.labelX2, {'string', 'char'}, {}, 'dumbellPlot', 'labelX2')
    labelX2 = string(options.labelX2);
end


if plotType == "single"
    Title = "";
elseif plotType == "double"
    Title = ["Year 1"; "Year 2"];
end

if isfield(options, "Title")
    validateattributes(options.Title, {'string', 'char', 'cell'}, {}, 'dumbellPlot', 'Title')

    if iscell(options.Title)
        tempTitle = options.Title;
    else
        tempTitle = cellstr(options.Title);
    end

    if plotType == "single"
        if numel(tempTitle) ~= 1
            warning("dumbbellPlot:TitleMismatch", "Single plot requires 1 title, default will be used")
        else
            Title=string(tempTitle{1});
        end
    elseif plotType == "double"
        if numel(tempTitle) ~= 2
            warning("dumbbellPlot:TitleMismatch", "Double plot requires 2 titles, default will be used")
        else
            Title=tempTitle;
        end
    end
end

if isfield(options, "YLabels")
    validateattributes(options.YLabels, {'string', 'char', 'cell'}, {}, 'dumbbellPlot', 'YLabels')

    if iscell(options.YLabels)
        tempYLabels = options.YLabels;
    else
        tempYLabels = cellstr(options.YLabels);
    end

    if length(tempYLabels) ~= length(X1)
        warning("dumbbellPlot:YLabelsMismatch", "Ylabels and X lenght does not match, default YLabels will be used")
    else
        YLabels= tempYLabels;
    end
end

if isfield(options, "orientation")
    validateattributes(options.orientation, {'string', 'char'}, {}, 'dumbbellPlot', 'orientation')
    orientation= options.orientation;
else
    orientation= "horizontal";
end

if isfield(options, "Color")
    if (ischar(options.Color) && isrow(options.Color)) || (isstring(options.Color) && isscalar(options.Color))
        colors = getColorPalette(options.Color);
    else
        try
            colors = validatecolor(options.Color, "multiple");
            if size(colors, 1) ~= 2
                warning("dumbbellPlot:InvalidColor", "Color must provide exactly 2 valid colors, default palette will be used")
                colors = getColorPalette("default");
            end
        catch ME
            warning("dumbbellPlot:InvalidColor", "Invalid Color, default palette will be used")
            colors = getColorPalette("default");
        end
    end
else
    colors = getColorPalette("default");
end

if isfield(options, "MarkerSize")
    if isnumeric(options.MarkerSize) && isscalar(options.MarkerSize)
        sz= options.MarkerSize;
    elseif isnumeric(options.MarkerSize) && length(options.MarkerSize) == length(X1)
        sz= options.MarkerSize;
    else
        warning("dumbbellPlot:InvalidMarkerSize", "Invalid Marker size provided, using default")
        sz= 70;
    end
else
    sz= 70; % set default
end

if isfield(options, "LineWidth")
    if isnumeric(options.LineWidth) && isscalar(options.LineWidth)
        LineWidth= options.LineWidth;
    else
        warning("dumbbellPlot:InvalidLineWidth", "Invalid Line Width provided, using default")
        LineWidth= 1.2;
    end
else
    LineWidth= 1.2; % setdefault
end

if isfield(options, "Fontsize")
    if isnumeric(options.Fontsize) && isscalar(options.Fontsize)
        Fontsize= options.Fontsize;
    else
        warning("dumbbellPlot:InvalidFontSize", "Invalid Font size provided, using default")
        Fontsize= 12;
    end
else
    Fontsize= 12; %default
end
%% main body
switch strcat(plotType,"_",orientation)
    case "single_horizontal"
        
        ax = gca;
        chart = DumbbellChart(X1,X2,YLabels,colors,sz,LineWidth,Fontsize);
        [h1, h2] = chart.build(ax);
        legend([h1 h2], {labelX1, labelX2}, "Location","bestoutside")

        % title
        if Title ~= ""
            title(ax, Title);
        end

    case "single_vertical"
        ax = gca;
        chart = DumbbellChart(X1,X2,YLabels,colors,sz,LineWidth,Fontsize);
        [h1, h2] = chart.buildVertical(ax);
        legend([h1 h2], {labelX1, labelX2}, "Location","bestoutside")

        % title
        if Title ~= ""
            title(ax, Title);
        end

    case "double_horizontal"
        t = tiledlayout(2, 1, 'TileSpacing', 'compact', 'Padding', 'compact');

        ax1 = nexttile;
        chart = DumbbellChart(X1,X2,YLabels,colors,sz,LineWidth,Fontsize);
        [h1, h2] = chart.build(ax1);
        legend(ax1, [h1 h2], {labelX1, labelX2}, "Location","best")
        
        ax2= nexttile;
        chart2 = DumbbellChart(X3,X4, YLabels,colors,sz,LineWidth,Fontsize);
        [~, ~] = chart2.build(ax2);

        title(ax1, Title{1});
        title(ax2, Title{2});

        % return value
        ax = [ax1; ax2];

    case "double_vertical"
        t = tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

        ax1 = nexttile;
        chart = DumbbellChart(X1,X2,YLabels,colors,sz,LineWidth,Fontsize);
        [h1, h2] = chart.buildVertical(ax1);
        
        ax2 = nexttile;
        chart2 = DumbbellChart(X3,X4, YLabels,colors,sz,LineWidth,Fontsize);
        [~, ~] = chart2.buildVertical(ax2);
        legend(ax2, [h1 h2], {labelX1, labelX2}, "Location","best")
        ax2.YAxisLocation= "right";
        ax2.YLabel.String= "";
        

        title(ax1, Title{1});
        title(ax2, Title{2});

        % return value
        ax = [ax1; ax2];
end
    
%% helper function to support pre-made color palettes
    function colors = getColorPalette(paletteName)
        switch paletteName
            case "default"
                colors = [0.92, 0.78, 0.38; % Sand yellow
                    0.17, 0.44, 0.26]; %Forest green
            case "colorblind"
                colors = [0.90, 0.62, 0.00; % Amber orange
                    0.00, 0.45, 0.70]; % Ocean blue
            case "ruby_jade"
                colors = [0.78, 0.15, 0.28; % Ruby red
                    0.25, 0.60, 0.50]; % Jade green
            case "cherry_sky"
                colors = [0.85, 0.25, 0.38; % Cherry red
                    0.52, 0.75, 0.92]; % Sky blue
            case "red_blue"
                colors = [0.88, 0.30, 0.30; % Coral Red
                    0.20, 0.42, 0.85]; % Royal blue
            otherwise
                warning("dumbbellPlot:UnknownPalette", ...
                    "Unknown palette '%s', using default", paletteName);
                colors = [0.92, 0.78, 0.38; 0.17, 0.44, 0.26];
        end
    end
end