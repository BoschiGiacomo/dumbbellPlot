# Documentation:
A dumbbell plot is a data visualization used to compare two values per
category. Each category is represented by two points connected by a line,
resembling a dumbbell. The two points usually indicate before–after, A vs
B, or two time periods. The distance between the points highlights the
magnitude of change or difference. Colors or shapes can distinguish the
two values clearly. It is especially effective when comparing many
categories without clutter. Dumbbell plots emphasize direction of change
better than bar charts. They work well with ordered categories to show
trends. They require a common numeric scale for meaningful comparison.
Overall, dumbbell plots provide a clean and intuitive comparison tool.

## Required Input Arguments:
**X:**
- Type: Table or numeric vector.
- Purpose: Data to plot. If numeric vector, it represents the first set of 
    data. If table, it can contain at least 1 or 2 column (in the case of a single plot) 
    or at least 4 variables (in the case of a double plot)

## Positional optional Arguments:
**X2:** 
- Type: numeric vector or single column table.
- Purpose: Second set of data for single plots. Required when X is a single 
    column table or numeric vector.

**X3, X4:** 
- Type: numeric vectors
- Purpose: Required when plotType = "double" and X is a numeric input

**varname1, varname2:**
- Type: String or char.
- Purpose: Variable of n dimensional X table to use for plotting

**varname3, varname4:**
- Type: string or character.
- Purpose: Variables of the n dimensional X table to use for plotting in 
    case of plotType "double"

## Optional "Name", Value Arguments

**"plotType", type**
- Type: string OR char
- Accepted values: "single" (default) OR "double"
- Purpose: Determines the type of plot that will be created; "single" creates
     a single plot, "double" creates a set of 2 plots, useful to compare different years
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
- Purpose: plot title(s). number of expected inputs depends on the number of plots. 
    Default for doubles is ["Year1" "Year2"], for the default single is empty
- Example: dumbbellPlot(X1, X2, X3, X4, "plotType", "double", "Title", ["Q1 2025", "Q3 2025"])

**YLabels**
- Type: string or char oR cell array
- Purpose: Custom labels for tick labels, Must match length of input Data. If missing, 
    default will be used ("Row 1", "Row 2", ...)

**Color**
- Type: string, or char or rgb triplet
- Accepted built-in palettes: "default", "colorblind", "ruby_jade", "cherry_sky", "red_blue"
- Purpose: Color of the dots of the plot

**MarkerSize**
- Type numeric scalar or numeric vector
- Purpose: Set size of dots

**LineWidth**
- Type: numeric scalar
- Purpose: width of the lines connecting the dots

**TextSize**
- Type: numeric scalar
- Purpose: Font size of descriptive text next to datapoints

**TextInside**
- Type: logical
- Purpose: Text inside or outside (default) of the data points

**AxesFontSize**
- Type: numeric scalar
- Purpose: set font size for axes

**ColorDist**
- Type: char or string
- accepted values: "false" (default), "directional", "magnitude", "robust"
- Purpose: Determine whether to color the bars of the dumbbels based on the specified distance

When using the ColorDist parameter, the connecting lines are colored based 
on the difference between values, helping visualize the magnitude and/or direction of change

When choosing "directional", the color is based on the difference between 
X2 and X1, normalized in the range [0 1] with the Min Max normalization, calculated as follows:

$$x_{norm}= \frac{\text{diff}-min(x)}{max(x)-min(x)}\quad \text{where diff}=X_2-X_1$$

This calculation is performed automatically by the native MATLAB function `rescale()`

When choosing "magnitude" the absolute value of the difference is taken into account,
this means it doesn't take into account direction of the variation, but only magnitude
the data is then scaled in range [0 1] using the Min Max normalization descripted above

When choosing the "robust" method, the color of the bars is determined through robust scaling,
using the following formula: 

$$x_{robust}=\frac{\text{diff}-\text{median(x)}}{\text{IQR}}\quad \text{where diff}=X_2-X_1$$

The data is then clipped in the range [-2 2] to prevent extreme outliers 
from dominating the color scale. After clipping, the values are used as indexes for the colormap

**Choosing a Method:**
- "Directional" is best for showing both magnitude and direction of the change
- "magnitude" is best when direction doesn't matter and you just want to show how 
    big is the difference
- "robus" is best for handling data which contains outliers that would otherwise 
    shift the scale of the colormap

**Background**
- Type: "char" or string
- Accepted inputs: "none", "bands"
- Purpose: Type of background to display in the plot

## Output
**ax:**
- Type: axes handles or array of axes handles
- Purpose: Returns the axes handles for the resulting plots, one handle for each created axis
