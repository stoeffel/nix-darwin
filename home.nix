{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "stoeffel";
  home.homeDirectory = "/Users/stoeffel";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  nixpkgs.config.allowUnfree = true;
  home.packages = [
    pkgs.eza
    (pkgs.writeShellScriptBin "e" ''
      ${pkgs.eza}/bin/eza --long --git --icons --sort=Name --header $@
    '')
    pkgs.autojump
    pkgs.elmPackages.elm
    pkgs.elmPackages.elm-format
    pkgs.elmPackages.elm-json
    pkgs.elmPackages.elm-language-server
    pkgs.elmPackages.elm-test
    pkgs.imagemagick
    pkgs.gh
    pkgs.git
    pkgs.git-crypt
    pkgs.git-extras
    pkgs.gnupg
    pkgs.gopass
    pkgs.jq
    pkgs.killall
    pkgs.nerdfonts
    pkgs.nixfmt
    pkgs.nodePackages.prettier
    pkgs.nodePackages.vega-cli
    pkgs.nodejs
    pkgs.python3
    pkgs.ripgrep
    pkgs.tree-sitter
    pkgs.tree-sitter-grammars.tree-sitter-elm
    pkgs.wget
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/stoeffel/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
    TERM = "kitty";
    SHELL = "${pkgs.zsh}/bin/zsh";
    NNN_PLUG = "o:xdg-open;d:diffs;p:preview-tui";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh.enable = true;
  programs.zsh.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
    EDITOR = "${pkgs.neovim}/bin/nvim";
  };
  programs.zsh.shellAliases = {
    g = "lazygit";
    v = "nvim";
    t = "tmuxinator";
  };

  programs.zsh.oh-my-zsh.enable = true;
  programs.zsh.oh-my-zsh.plugins =
    [ "git" "pip" "autojump" "command-not-found" "fasd" "history" "fzf" ];

  programs.tmux.enable = true;
  programs.tmux.tmuxinator.enable = true;
  programs.tmux.keyMode = "vi";
  programs.tmux.sensibleOnTop = true;
  programs.tmux.prefix = "C-b";
  programs.tmux.shell = "${pkgs.zsh}/bin/zsh";
  programs.tmux.mouse = true;
  programs.kitty = {
    enable = true;
    theme = "kanagawabones";
    font = {
      name = "FiraCode Nerd Font Mono";
      size = 12;
    };
    settings = {
      shell = "zsh";
      hide_window_decorations = "no";
      macos_option_as_alt = "yes";
    };
  };
  programs.fzf.enable = true;
  programs.starship.enable = true;
  programs.git.enable = true;
  programs.git.userName = "Stoeffel";
  programs.git.userEmail = "schtoeffel@gmail.com";
  programs.lazygit.enable = true;
  programs.helix.enable = true;
  programs.helix.settings.theme = "kanagawa";
  programs.helix.settings.editor.shell = ["${pkgs.zsh}/bin/zsh" "-c"];
  programs.helix.settings.editor.color-modes = true;
  programs.helix.settings.keys.insert = { C-c = "normal_mode"; };
  programs.helix.settings.editor.statusline = {
    left = [ "mode" "spinner" ];
    center = [ "file-name" ];
    right = [
      "diagnostics"
      "selections"
      "position"
      "file-encoding"
      "file-line-ending"
      "file-type"
    ];
    separator = "│";
    mode.normal = "NORMAL";
    mode.insert = "INSERT";
    mode.select = "SELECT";
  };
  programs.helix.languages = {
    language = [
      {
        name = "elm";
        scope = "source.elm";
        injection-regex = "^elm$";
        file-types = [ "elm" ];
        roots = [ "elm.json" ];
        comment-token = "--";
        language-server = {
          command =
            "${pkgs.elmPackages.elm-language-server}/bin/elm-language-server";
          args = [ "--stdio" ];
        };
        formatter = {
          command = "elm-format";
          args = [ "--stdin" ];
        };
      }

      {
        name = "nix";
        scope = "source.nix";
        injection-regex = "^nix$";
        file-types = [ "nix" ];
        comment-token = "--";
        formatter = {
          command = "nixfmt";
          args = [ ];
        };
      }
    ];
  };
  programs.neovim.enable = true;
  programs.neovim.viAlias = true;
  programs.neovim.vimAlias = true;
  programs.neovim.plugins = with pkgs.vimPlugins; [
    ale
    bufferline-nvim
    mini-nvim
    copilot-lua
    dashboard-nvim
    dhall-vim
    editorconfig-vim
    fzf-vim
    git-blame-nvim
    gitsigns-nvim
    haskell-vim
    hop-nvim
    lazygit-nvim
    vim-bookmarks
    telescope-vim-bookmarks-nvim
    lightspeed-nvim
    lualine-nvim
    neoformat
    neoyank-vim
    nightfox-nvim
    tokyonight-nvim
    nvim-tree-lua
    nvim-web-devicons
    plenary-nvim
    quickfix-reflector-vim
    tabular
    telescope-nvim
    telescope-fzf-native-nvim
    toggleterm-nvim
    unicode-vim
    vim-abolish
    vim-devicons
    vim-eunuch
    vim-exchange
    vim-fugitive
    vim-highlightedyank
    vim-localvimrc
    vim-markdown
    vim-nix
    vim-repeat
    vim-rhubarb
    vim-scala
    vim-scriptease
    vim-sensible
    vim-speeddating
    vim-surround
    vim-textobj-user
    vim-unimpaired
    vim-vinegar
    vim-visual-star-search
    which-key-nvim
    nvim-lspconfig
    nvim-treesitter
    nvim-treesitter-parsers.elm
  ];
  programs.neovim.extraLuaConfig = builtins.readFile ./neovim.lua;
  home.activation.createGitignore = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    cp -f ${./gitignore} $HOME/.config/git/ignore
  '';
}
