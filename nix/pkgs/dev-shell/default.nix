# This is a development environment for agent learning framework.

{ mkShell
, python3
, python-language-server }:

let pythonForDiffEq = python3.withPackages (pyPkgs: with pyPkgs; [
      # For both Dev and Deploy
      pytorchWithCuda11
      torchvisionWithCuda11
      numpy
      scipy
      matplotlib
      tqdm      
      
      # Dev only packages
      jupyterlab ipywidgets ipydatawidgets
    ]);

    pythonIcon = "f3e2";

in mkShell rec {
  name = "DiffEq";

  packages = [
    pythonForDiffEq
    python-language-server  # From Microsoft, not Palantir
  ];

  # This is to have a leading python icon to remind the user we are in
  # the Alf python dev environment.
  shellHook = ''
    export PS1="$(echo -e '\u${pythonIcon}') {\[$(tput sgr0)\]\[\033[38;5;228m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]} (${name}) \\$ \[$(tput sgr0)\]"
  '';
}
