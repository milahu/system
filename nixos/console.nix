{ config, pkgs, ... }:
{
  environment.variables = {
    EDITOR = "${pkgs.neovim}/bin/nvim";
  };

  
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    shellAliases = {
      infssh = "ssh root@infinisil.io";
      vim = "nvim";
      vimrc = "nvim $HOME/.config/nvim/init.vim";
      nixrc = "nvim /global/system/nixos";
      rebuild = ''(
        cd /global/nixpkgs && 
        git checkout nixos-17.03 && 
        sudo nixos-rebuild switch -I nixpkgs=/global/nixpkgs
      )'';
    };
		promptInit = ''
			DEFAULT_USER=infinisil

			POWERLEVEL9K_MODE='nerdfont-fontconfig'
			POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(root_indicator context dir vcs)
			POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time time battery)

			POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
			POWERLEVEL9K_SHORTEN_DELIMITER=""
			POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
		'';
    ohMyZsh = let 
      packages = [
        {
          owner = "bhilburn";
          repo = "powerlevel9k";
          rev = "v0.6.3";
          sha256 = "1yg8nzbxpcaq5nbixqggq3b2ki59w096zmrk0grrhqgjgfiv58sh";
        }
      ];

      fetchToFolder = { repo, ...}@attrs:
        pkgs.fetchFromGitHub (attrs // {
          extraPostFetch = ''
            tmp=$(mktemp -d)
            mv $out/* $tmp
            mkdir $out/${repo}
            mv $tmp/* $out/${repo}
          '';
        });
      custom = pkgs.buildEnv {
        name = "zsh-custom";
        paths = builtins.map fetchToFolder packages;
      };
    in
    {
      enable = true;
      custom = custom.outPath;
      theme = "powerlevel9k/powerlevel9k";
      plugins = [ "git" "pass" "brew" "colored-man" "colorize" ];
    };
    shellInit = ''
      # Simple function to enumerate all snapshots of a directory
      # Example: To list all files of all snapshots of the `dir` directory of the current folder:
      # ls $(snaps dir)
      #
      # To view all versions of a file in vim:
      # vim $(snaps dir)
      function snaps() {
        local mount=$(stat -c '%m' .)
        echo "$mount/.zfs/snapshot/*/$(realpath . --relative-to=$mount)/$1"
      }
    '';
  };

  users.defaultUserShell = pkgs.zsh;
}