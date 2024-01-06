{ ... }:

{
  # Bash
  programs.bash = {
    enable = true;
    historyControl = [ "ignoredups" "erasedups" ];
    historyIgnore = [ "exit" "clear" ];
    shellAliases = {
      ll = "ls -l";
      la = "ls -lA";
      gedit = "gnome-text-editor";
      console = "kgx";
      ls = "ls --color=auto";
      diff = "diff --color=auto";
      grep = "grep --color=auto";
      ip = "ip --color=auto";
    };
    bashrcExtra = "mkdircd () { mkdir -p $1 && cd $1; }";
  };

  # Readline config for bash history search
  programs.readline = {
    enable = true;
    includeSystemConfig = true;
    bindings = {
      "\\e[A" = "history-search-backward";
      "\\e[B" = "history-search-forward";
    };
  };

  # Oh my Posh prompt
  programs.oh-my-posh = {
    enable = true;
    enableBashIntegration = true;
    #useTheme = "powerlevel10k_lean";
    settings = import ./omp-theme.nix;
  };
}
