
function! s:lsp_diagnostic_toggle() abort
    let g:lsp_diagnostics_enabled = !get(g:, 'lsp_diagnostics_enabled', 1)
    let l:state = g:lsp_diagnostics_enabled
    echo l:state
    if l:state == 0
        call lsp#disable_diagnostics_for_buffer()
        " HACK: (2026/01/17) -> Currently, `let g:lsp_document_code_action_signs_enabled` is off.
        "execute 'sign unplace * group=vim_lsp_document_code_action_signs buffer=' . bufnr('%')
    else
        call lsp#enable_diagnostics_for_buffer()
    endif
endfunction

function! s:on_lsp_buffer_enabled() abort
    " At first, no `diagnosis`.  
    call lsp#disable_diagnostics_for_buffer()
    
    setlocal omnifunc=lsp#complete
    set shortmess+=c

    " gd で定義ジャンプ (coc の jumpDefinition 相当)
    nmap <silent> gd <plug>(lsp-definition)
    nmap <silent> gD <plug>(lsp-declaration)
    nmap <silent> gi <plug>(lsp-implementation)
    nmap <silent> gy <plug>(lsp-type-definition)
    nmap <silent> gr <plug>(lsp-references)

    " --- 診断 (エラー) 移動 ---
    nmap <silent> ]g <plug>(lsp-next-diagnostic)
    nmap <silent> [g <plug>(lsp-previous-diagnostic)

    " --- その他 (リネーム・クイックフィックス) ---
    nmap <leader>rn <plug>(lsp-rename)
    nmap <leader>qf <plug>(lsp-code-action)
    nmap <leader>ac <plug>(lsp-code-action)

    " --- シグネチャヘルプ ---
    nnoremap <C-k> :LspSignatureHelp<CR>
    inoremap <silent><C-k> <C-o>:LspSignatureHelp<CR>

    nnoremap <silent> <F11> :call <SID>lsp_diagnostic_toggle()<CR>

    inoremap <expr> <Tab> pumvisible() ? "\<C-y>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-y>" : "\<S-Tab>"
    inoremap <expr> <cr> pumvisible() ? asyncomplete#close_popup() : "\<cr>"
    inoremap <silent> <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-x>\<C-o>"
    endfunction

function! s:format_current_buffer() abort
    if &filetype == 'markdown'
        if executable('prettier')
            let l:view = winsaveview()
            silent! execute "%!prettier --stdin-filepath %"
            call winrestview(l:view)
        endif
    else
        if exists(':LspDocumentFormat')
            LspDocumentFormat
        endif
    endif
endfunction

let g:lsp_semantic_enabled = 1
let g:lsp_diagnostics_virtual_text_align = "right"

nnoremap <silent> <A-f> :call <SID>format_current_buffer()<CR>
inoremap <silent> <A-f> <C-o>:call <SID>format_current_buffer()<CR>


" HACK: (2026/01/17) -> Currently, some hack is required to toggle `A>` sign.
let g:lsp_document_code_action_signs_enabled = 0

" HACK: It is required to override the standard setting of vim after. 
augroup PythonKey
    autocmd!
    autocmd FileType python nnoremap <buffer><silent> K :LspHover<CR>
    nnoremap <buffer><silent> <C-f> :call lsp#scroll(+4)<CR>
    nnoremap <buffer><silent> <C-b> :call lsp#scroll(-4)<CR>
augroup END


augroup MyLspConfig
    autocmd!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END


