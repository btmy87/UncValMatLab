# UncValMatLab
MatLab class for handling uncertain values.

Propagates uncertainty through basic matlab calculations, tracking sources
of uncertainty.  Most basic math operations are supported, along with some 
trigonometry and exponents.

Independent sources of error must be given unique id's by the user.
Dependencies between calculations are handled appropriately, but there is 
no mechanism for handling dependencies between user inputs.

Some array operations are supported, but be careful.  All array elements
with the same id are effectively dependent on one another.  This is not
expected to be true for a typical use pattern.

The plot and errorbar functions are overloaded so that objects can be 
passed directly to plot calls.  Errorbars are automatically configured.
