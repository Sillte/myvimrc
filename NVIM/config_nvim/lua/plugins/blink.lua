-- lua/plugins/blink.lua
return {
    'saghen/blink.cmp',
    version = '*',
    -- 他のプラグインで blink の能力を使いたい場合に依存関係を記述
    dependencies = 'rafamadriz/friendly-snippets',

    opts = {
        keymap = {
            preset        = 'none', -- 完全に制御するために一度 none にするのがクリーンです
            ['<C-j>']     = {
                function(cmp)
                    if cmp.is_visible() then
                        return cmp.select_next()
                    else
                        return cmp.show()
                    end
                end,
                'fallback'
            },
            ['<C-space>'] = { 'show', 'show_documentation', 'hide' },
            ['<C-e>']     = { 'hide', 'fallback' },
            ['<CR>']      = { 'accept', 'fallback' },
            ['TAB']       = { 'show', 'show_documentation', 'hide' },


            -- C-n / C-p での選択（behavior = Insert に相当する動作がデフォルトです）
            ['<C-n>'] = { 'select_next', 'fallback' },
            ['<C-p>'] = { 'select_prev', 'fallback' },

            -- ドキュメント（詳細）のスクロール
            ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        },

        -- 補完メニューの見た目 (最新のUI設定)
        appearance = {
            use_nvim_cmp_as_default = true, -- nvim-cmpのハイライトを流用
            nerd_font_variant = 'mono'      -- アイコンの表示スタイル
        },

        -- 補完ソースの管理
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },

        -- 2026年版の注目機能: シグネチャヘルプ (関数の引数ガイド)
        signature = { enabled = true },

        -- 補完ウィンドウのカスタマイズ
        completion = {
            ghost_text = {
                enabled = true,
            },
            -- 補完が1つしかない時に自動で選択するか
            list = { selection = { preselect = true, auto_insert = true } },

            -- ドキュメント（右側に出る詳細説明）の表示
            documentation = { auto_show = true, auto_show_delay_ms = 200 },

            -- アイコンやラベルの表示順序を弄りたい場合
            menu = {
                draw = {
                    columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
                }
            }
        }
    },
}
