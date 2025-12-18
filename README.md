# dumbbellPlot
Function to create a dumbell plot in MATLAB

## Documentation:
### Required Input Arguments:
**X:**
- Type: Table or numeric vector.
- Purpose: Data to plot. If numeric vector, it represents the first set of data. If table, it can contain at least 1 or 2 column (in the case of a single plot) or at least 4 variables (in the case of a double plot)

### Positional optional Arguments:
**X2:** 
- Type: numeric vector or single column table.
- Purpose: Second set of data for single plots. Required when X is a single column table or numeric vector.

**X3, X4:** 
- Type: numeric vectors
- Purpose: Required when plotType = "double" and X is a numeric input

**varname1, varname2:**
- Type: String or char.
- Purpose: Variable of n dimensional X table to use for plotting

**varname3, varname4:**
- Type: string or character.
- Purpose: Variables of the n dimensional X table to use for plotting in case of plotType "double"

### Optional "Name", Value Arguments

**"plotType", type**
- Type: string OR char
- Accepted values: "single" (default) OR "double"
- Purpose: Determines the type of plot that will be created; "single" creates a single plot, "double" creates a set of 2 plots, useful to compare different years
- Example: dumbbellPlot(X1, X2, X3, X4, "plotType", "double")

**"orientation", orientation**
- Type: string or Char
- Accepted Values: "horizontal" (default) or "vertical"
- Purpose: determines the orientation of the plot.
- Example: dumbbellPlot(X1, X2, X3, X4, "plotType", "double", "orientation", "vertical")

**"LabelX1"**
- Type: string OR char
- Summary: Custom legend label for the first set of data, Default: X1.

**"LabelX2"**
- Type: string or char
- Summary: Custom legend label for the second set of data, Default: X2.

**Title**
- Type: string or char or cell array
- Purpose: plot title(s). number of expected inputs depends on the number of plots. Default for doubles is ["Year1" "Year2"], for the default single is empty
- Example: dumbbellPlot(X1, X2, X3, X4, "plotType", "double", "Title", ["Q1 2025", "Q3 2025"])

**YLabels**
- Type: string or char oR cell array
- Purpose: Custom labels for tick labels, Must match length of input Data. If missing, default will be used ("Row 1", "Row 2", ...)

### Output
**ax:**
- Type: axes handles or array of axes handles
- Purpose: Returns the axes handles for the resulting plots, one handle for each created axis
