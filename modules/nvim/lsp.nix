{ config, pkgs, mkMerge, ... }:

{
  config = {
    programs.neovim = {
      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
      ];

      extraPackages = [
        # pkgs.ansible-language-server removed
        pkgs.pyright
        pkgs.terraform-ls
        pkgs.haskell-language-server
        # pkgs.yamllint
      ];

      extraPython3Packages = ps: [
      ];

      extraLuaConfig = ''
        -- Ansible
        -- require'lspconfig'.ansiblels.setup{}

        -- Python
        vim.lsp.enable('pyright')

        -- Terraform
        vim.lsp.enable('terraformls')

        -- Haskell
        vim.lsp.enable('hls')

        vim.api.nvim_create_autocmd({"BufWritePre"}, {
          pattern = {"*.tf", "*.tfvars"},
          callback = function()
            vim.lsp.buf.format()
          end,
        })

        -- General keymaps
        do
          vim.keymap.set('n', 'grn', function()
            vim.lsp.buf.rename()
          end, { desc = 'vim.lsp.buf.rename()' })

          vim.keymap.set({ 'n', 'x' }, 'gra', function()
            vim.lsp.buf.code_action()
          end, { desc = 'vim.lsp.buf.code_action()' })

          vim.keymap.set('n', 'grr', function()
            vim.lsp.buf.references()
          end, { desc = 'vim.lsp.buf.references()' })

          vim.keymap.set('i', '<C-S>', function()
            vim.lsp.buf.signature_help()
          end, { desc = 'vim.lsp.buf.signature_help()' })
        end
      '';
    };
  };
}
