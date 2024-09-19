{ pkgs, ... }:

{
  programs = {
    autojump.enable = true;
    broot.enable = true;
    fzf.enable = true;
    pls.enable = true;

    bash = {
      enable = true;
      historyControl = [ "ignoredups" "erasedups" ];
      historyIgnore = [ "exit" "clear" ];
      shellAliases = {
        ll = "ls -l";
        la = "ls -lA";
        gedit = "gnome-text-editor";
        ls = "ls --color=auto";
        diff = "diff --color=auto";
        grep = "grep --color=auto";
        ip = "ip --color=auto";
      };
      bashrcExtra = ''
        mkdircd () { mkdir -p $1 && cd $1; }
        rebuild () { git -C /etc/nixos fetch && git -C /etc/nixos pull && sudo nixos-rebuild switch; }
      '';
    };

    # Readline config for bash history search
    readline = {
      enable = true;
      includeSystemConfig = true;
      bindings = {
        "\\e[A" = "history-search-backward";
        "\\e[B" = "history-search-forward";
      };
    };

    oh-my-posh = {
      enable = true;
      package = pkgs.unstable.oh-my-posh;
      #useTheme = "powerlevel10k_lean";
      settings = import ./omp-theme.nix;
    };
  };
}
