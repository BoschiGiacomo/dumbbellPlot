# Dumbbell Charts for MATLAB
A MATLAB function for creating customizable dumbbell plots to compare two values across categories.

I decided to start developing this project both as a personal learning experience and as an attempt to create a useful tool for the community.<br/>
The idea came from my professor [@MarcoRianiUNIPR](https://github.com/MarcoRianiUNIPR), whom I thank for the inspiration.

![Banner](images/banner_image.png)

A dumbbell is a chart that compares two values for each category, using points
connected by a line, creating a figure that resembles a dumbbell. It is ideal 
for showing difference between to sets of data (e.g. before/after, Q1/Q2, A/B), 
highlighting both the direction and the magnitude of the difference in a clean, simple way.

# Quickstart
At the moment the function is not available as a package on MATLAB's file exange, it will be added soon.

To use the function you will have to clone the GitHub repository into a folder of your choosing.

After cloning make sure to run the `dumbbellplot_setup.m` helper function in your MATLAB command window to
quickly add all the function files to the MATLAB search path. Or, if you prefer, do it manually.

Run this after installation to see a sample plot:
```
morning = [120, 135, 128, 142, 112];
evening = [128, 145, 135, 150, 119];

Patients = {'Carol', 'Pierre', 'Jack', 'April', 'Terry'};

dumbbellPlot(morning, evening, "plotType", "single", "TextInside", true, ...
    "orientation", "horizontal", "labelX1", "Morning", "labelX2", "Evening", ...
    "YLabels", Patients, "Background", "bands", "Title", "Measured Systolic BP", "AxesFontSize", 17)
```
# Main features
- Double plots to highlight difference between two sets of data over a two time periods
- Custom code autocompletion and suggestions
- Numerous options to customize your plots, including but not limited to:
    - Ability to plot both vertically and horizontally oriented dumbbell plots
    - Colouring of the bars of the dummbells based on the difference between the two points
        featuring simple as well as robust methods for determining the colouring of the bars
    - Option to colour the background of the plot with vertical or horizontal bands (more will be added in the future)
    - Option to decide wheter to insert descriptive text inside the dots, or outside
    - Built-in color palettes, with the option to insert your own custom palette

## Roadmap:
Recently added features:
- [x] support for custom colors, markersize, axesfontsize, linewidth, Textsize
- [x] addition of functionSignatures.json for customized code suggestions
- [x] Option to insert the values of the points inside of the points of the plot
- [x] Option to change the color of the line depending on the distance between the points
- [x] Option to change the background of the plot to be clearer or more visually appealing

The next additions to the function will be:
- [ ] Improvement of documentation
- [ ] restructuring of the repository and README
- [ ] Addition of a graph that creates plots for every pair of variables in a table
- [ ] Add more background options, and custom background colors
- [ ] Option to add the differences between the points at the side of the plot
- [ ] Option to add and control weights assigned to dot sizes
- [ ] Options to display additional information about the data, like 
    having boxplots on the side to show distribution of the points

Suggestions, feedback, and contributions are welcome and encouraged.

# Documentation
Extensive documentation for the function can be found in the [UserGuide](/docs/UserGuide.md)
located inside the [docs](/docs) folder of the repository.

The documentation can also be consulted in the preamble of the function. It was written by
professor [Marco Riani](https://github.com/MarcoRianiUNIPR), whom i thank for his contributions
to the project.

# Examples:
I have created some examples to showcase this function most prominent features,
more will be added, when new features are released. I suggest looking at them if
you want to get an idea of the results you can expect by using this function.

All the examples can be found in the [Examples Gallery](/docs/ExamplesGallery.md),
or in `.mlx` format in the [examples](/examples) folder of the repository.

# Contributing
Contributions are always welcome!

- Issues: if you find a bug or have an idea for a new feature, please open
    an issue describing the problem or suggestion, including an example if possible
- Pull Requests: To submit code changes, please work on a for of the repository, and when 
    you are done open a pull request with a clear description of what you 
    changed and why
- Whenever possible, try to follow the existing coding style, when proposing
    changes trough pull requests
- Try to write meaningful commits, prefer committing a lot of small changes than
    one large commit that mixes unrelated changes.
- If possible, try to write clear and understandable code. Prefer longer more readable code
    than shorter, more difficult to read code. If your code looks strange for specific reasons
    (e.g. performance, compatibility,etc...) please specify it with a comment


# Acknowledgements
My gratitude goes to Dr. [Domenico Perrotta](https://github.com/DomenicoPerrottaJRC) 
and professor [Marco Riani](https://github.com/MarcoRianiUNIPR) not only for giving 
me the idea to write this function, but also for their suggestions, help and support.