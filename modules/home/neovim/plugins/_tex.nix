{
  # LaTeX authoring: VimTeX conceal (`\omega` renders as `ω`), LuaSnip
  # autosnippets, and context-aware math snippets. Snippets that
  # start math (`mk`, `dm`) fire in text; the rest only fire inside a math
  # zone, detected via `vimtex#syntax#in_mathzone()`.
  programs.lazyvim.plugins.tex = ''
    return {
      {
        "lervag/vimtex",
        init = function()
          -- Conceal is drawn by VimTeX's Vim syntax engine, never by
          -- Tree-sitter (lervag/vimtex#2388, `:help vimtex-faq-treesitter`).
          -- LazyVim's tex extra already lists "latex" in the Tree-sitter
          -- highlight.disable set, so `syntax=tex` stays in charge here; if
          -- that ever changes, conceal silently stops working.
          -- 'conceallevel'/'concealcursor' are window-local, so re-apply them
          -- for every window showing a tex buffer, not just the first
          -- FileType event (splits, `:b`, reused windows).
          local function tex_conceal()
            local ft = vim.bo.filetype
            if ft ~= "tex" and ft ~= "plaintex" then
              return
            end
            vim.wo.conceallevel = 2
            -- Empty: the line under the cursor always shows raw source, so
            -- editing a concealed `\frac{}{}` isn't done blind.
            vim.wo.concealcursor = ""
          end

          vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
            callback = tex_conceal,
          })

          -- Math-aware snippets. Registered once, lazily requiring LuaSnip
          -- (which loads it with autosnippets enabled via the opts below).
          local ls = require("luasnip")
          local s = ls.snippet
          local t = ls.text_node
          local i = ls.insert_node

          local function in_math()
            return vim.fn["vimtex#syntax#in_mathzone"]() == 1
          end
          local function in_text()
            return not in_math()
          end

          -- text-mode: enter math
          local function tsnip(trig, nodes)
            return s(
              { trig = trig, snippetType = "autosnippet", condition = in_text },
              nodes
            )
          end
          -- math-mode: symbols / structures (non-word triggers)
          local function msnip(trig, nodes)
            return s(
              { trig = trig, wordTrig = false, snippetType = "autosnippet", condition = in_math },
              nodes
            )
          end
          local function msym(trig, replacement)
            return msnip(trig, { t(replacement) })
          end

          ls.add_snippets("tex", {
            -- enter math from text
            tsnip("mk", { t("\\( "), i(1), t(" \\)"), i(0) }),
            tsnip("dm", { t({ "\\[", "\t" }), i(1), t({ "", "\\]" }), i(0) }),

            -- align environments (text-mode: these are display math themselves)
            tsnip("ali", { t({ "\\begin{align*}", "\t" }), i(1), t({ "", "\\end{align*}" }), i(0) }),
            tsnip("aln", { t({ "\\begin{align}", "\t" }), i(1), t({ "", "\\end{align}" }), i(0) }),

            -- matrices (math-mode)
            msnip("pmat", { t({ "\\begin{pmatrix}", "\t" }), i(1), t({ "", "\\end{pmatrix}" }) }),
            msnip("bmat", { t({ "\\begin{bmatrix}", "\t" }), i(1), t({ "", "\\end{bmatrix}" }) }),
            msnip("vmat", { t({ "\\begin{vmatrix}", "\t" }), i(1), t({ "", "\\end{vmatrix}" }) }),
            msnip("mat", { t({ "\\begin{matrix}", "\t" }), i(1), t({ "", "\\end{matrix}" }) }),

            -- \left ... \right auto-resizing delimiters (math-mode)
            msnip("lr(", { t("\\left( "), i(1), t(" \\right)") }),
            msnip("lr[", { t("\\left[ "), i(1), t(" \\right]") }),
            msnip("lr{", { t("\\left\\{ "), i(1), t(" \\right\\}") }),
            msnip("lr|", { t("\\left| "), i(1), t(" \\right|") }),
            msnip("lr<", { t("\\left\\langle "), i(1), t(" \\right\\rangle") }),

            -- structures
            msnip("//", { t("\\frac{"), i(1), t("}{"), i(2), t("}") }),
            msnip("sq", { t("\\sqrt{"), i(1), t("}") }),
            msnip("ee", { t("e^{"), i(1), t("}") }),
            msnip("__", { t("_{"), i(1), t("}") }),
            msnip("td", { t("^{"), i(1), t("}") }),
            msnip("set", { t("\\{ "), i(1), t(" \\}") }),

            -- operators / relations
            msym("!=", "\\neq "),
            msym("<=", "\\leq "),
            msym(">=", "\\geq "),
            msym("->", "\\to "),
            msym("=>", "\\implies "),
            msym("xx", "\\times "),
            msym("**", "\\cdot "),
            msym("inn", "\\in "),
            msym("notin", "\\notin "),
            msym("sub", "\\subseteq "),
            msym("cup", "\\cup "),
            msym("cap", "\\cap "),
            msym("...", "\\dots "),
            msym("inf", "\\infty "),
            msym("sum", "\\sum "),
            msym("prod", "\\prod "),
            msym("int", "\\int "),

            -- greek (;<letter>)
            msym(";a", "\\alpha "),
            msym(";b", "\\beta "),
            msym(";g", "\\gamma "),
            msym(";d", "\\delta "),
            msym(";e", "\\epsilon "),
            msym(";t", "\\theta "),
            msym(";k", "\\kappa "),
            msym(";l", "\\lambda "),
            msym(";m", "\\mu "),
            msym(";p", "\\pi "),
            msym(";r", "\\rho "),
            msym(";s", "\\sigma "),
            msym(";f", "\\phi "),
            msym(";c", "\\chi "),
            msym(";w", "\\omega "),
            msym(";G", "\\Gamma "),
            msym(";D", "\\Delta "),
            msym(";T", "\\Theta "),
            msym(";L", "\\Lambda "),
            msym(";S", "\\Sigma "),
            msym(";F", "\\Phi "),
            msym(";W", "\\Omega "),
          })
        end,
      },
      {
        "L3MON4D3/LuaSnip",
        opts = { enable_autosnippets = true },
      },
    }
  '';
}
