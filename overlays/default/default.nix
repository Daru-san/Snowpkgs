{self}: {
  default = final: prev: import self.packages {pkgs = final;};
}
