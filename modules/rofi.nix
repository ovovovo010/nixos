{ config, pkgs, lib, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    
    terminal = "${pkgs.kitty}/bin/kitty";
    
    extraConfig = {
      modi = "drun,run,window,ssh";
      show-icons = true;
      icon-theme = "Papirus-Dark";
      display-drun = "Applications";
      display-run = "Run";
      display-window = "Windows";
      display-ssh = "SSH";
      drun-display-format = "{name}";
      window-format = "{w} · {c} · {t}";
      disable-history = false;
      hide-scrollbar = true;
      sidebar-mode = true;
    };

    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        bg0 = mkLiteral "#1a1625";
        bg1 = mkLiteral "#2d1b4e";
        bg2 = mkLiteral "#3b2667";
        bg3 = mkLiteral "#4c2f7a";
        fg0 = mkLiteral "#e9d5ff";
        fg1 = mkLiteral "#c4b5fd";
        fg2 = mkLiteral "#a78bfa";
        accent = mkLiteral "#7c3aed";
        accent-alt = mkLiteral "#b794f6";
        urgent = mkLiteral "#f87171";
        active = mkLiteral "#34d399";
        
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg0";
        font = "JetBrains Mono 12";
      };

      "window" = {
        transparency = "real";
        location = mkLiteral "center";
        anchor = mkLiteral "center";
        fullscreen = false;
        width = mkLiteral "800px";
        border-radius = mkLiteral "16px";
        background-color = mkLiteral "@bg0";
        border = mkLiteral "3px solid";
        border-color = mkLiteral "@accent-alt";
      };

      "mainbox" = {
        background-color = mkLiteral "transparent";
        children = map mkLiteral [ "inputbar" "message" "mode-switcher" "listview" ];
        spacing = mkLiteral "12px";
        padding = mkLiteral "20px";
      };

      "inputbar" = {
        background-color = mkLiteral "@bg1";
        text-color = mkLiteral "@fg0";
        border-radius = mkLiteral "12px";
        padding = mkLiteral "16px 20px";
        spacing = mkLiteral "12px";
        children = map mkLiteral [ "prompt" "entry" ];
        border = mkLiteral "2px solid";
        border-color = mkLiteral "@accent";
      };

      "prompt" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@accent-alt";
        padding = mkLiteral "0px";
      };

      "entry" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg0";
        placeholder-color = mkLiteral "@fg2";
        placeholder = "Search...";
        padding = mkLiteral "0px";
      };

      "message" = {
        background-color = mkLiteral "@bg1";
        border-radius = mkLiteral "10px";
        padding = mkLiteral "12px";
        text-color = mkLiteral "@fg1";
      };

      "textbox" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
      };

      "listview" = {
        background-color = mkLiteral "transparent";
        columns = 1;
        lines = 8;
        spacing = mkLiteral "6px";
        cycle = true;
        dynamic = true;
        scrollbar = false;
      };

      "element" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg0";
        orientation = mkLiteral "horizontal";
        border-radius = mkLiteral "10px";
        padding = mkLiteral "12px 16px";
      };

      "element-icon" = {
        background-color = mkLiteral "transparent";
        size = mkLiteral "32px";
        border = mkLiteral "0px";
        padding = mkLiteral "0px 12px 0px 0px";
      };

      "element-text" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
      };

      "element normal.normal" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg0";
      };

      "element normal.urgent" = {
        background-color = mkLiteral "@urgent";
        text-color = mkLiteral "@bg0";
      };

      "element normal.active" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@active";
      };

      "element selected.normal" = {
        background-color = mkLiteral "@accent";
        text-color = mkLiteral "@fg0";
        border = mkLiteral "0px 0px 0px 4px solid";
        border-color = mkLiteral "@accent-alt";
      };

      "element selected.urgent" = {
        background-color = mkLiteral "@urgent";
        text-color = mkLiteral "@fg0";
      };

      "element selected.active" = {
        background-color = mkLiteral "@active";
        text-color = mkLiteral "@fg0";
      };

      "element alternate.normal" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg0";
      };

      "element alternate.urgent" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@urgent";
      };

      "element alternate.active" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@active";
      };

      "mode-switcher" = {
        background-color = mkLiteral "@bg1";
        border-radius = mkLiteral "12px";
        padding = mkLiteral "8px";
        spacing = mkLiteral "8px";
      };

      "button" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg1";
        padding = mkLiteral "10px 16px";
        border-radius = mkLiteral "8px";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.5";
      };

      "button selected" = {
        background-color = mkLiteral "@accent";
        text-color = mkLiteral "@fg0";
      };

      "error-message" = {
        background-color = mkLiteral "@bg0";
        border-radius = mkLiteral "12px";
        padding = mkLiteral "20px";
        border = mkLiteral "2px solid";
        border-color = mkLiteral "@urgent";
      };
    };
  };
}
