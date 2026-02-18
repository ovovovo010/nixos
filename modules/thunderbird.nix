{ pkgs, ... }: {
  programs.thunderbird = {
    enable = true;
    profiles.eric = {
      isDefault = true;
    };
  };
}
