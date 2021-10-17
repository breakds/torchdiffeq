{ pytorchWithCuda11
, torchvisionWithCuda11
}:

final: prev: rec {
  python3 = prev.python3.override {
    packageOverrides = pyFinal: pyPrev: rec {
      pudb = pyFinal.callPackage ./pkgs/pudb {};
      inherit pytorchWithCuda11 torchvisionWithCuda11;
    };
  };

  python3Packages = python3.pkgs;
}
