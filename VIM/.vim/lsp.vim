"================
" Utility functions
"================

function! s:lsp_diagnostic_toggle() abort
    let g:lsp_diagnostics_enabled = !get(g:, 'lsp_diagnostics_enabled', 1)
    if g:lsp_diagnostics_enabled == 0
        call lsp#disable_diagnostics_for_buffer()
        " NOTE: (2026/01/17) -> Currently, `let g:lsp_document_code_action_signs_enabled` is off.
        "execute 'sign unplace * group=vim_lsp_document_code_action_signs buffer=' . bufnr('%')
    else
        call lsp#enable_diagnostics_for_buffer()
    endif
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

"================
" Initialization (Buffer/Global)
"================

function! s:InitializeLspBuffer() abort
    call lsp#disable_diagnostics_for_buffer()
    
    setlocal omnifunc=lsp#complete

    " Navigation
    nmap <buffer><silent> gd <plug>(lsp-definition)
    nmap <buffer><silent> gD <plug>(lsp-declaration)
    nmap <buffer><silent> gi <plug>(lsp-implementation)
    nmap <buffer><silent> gy <plug>(lsp-type-definition)
    nmap <buffer><silent> gr <plug>(lsp-references)
    nnoremap <buffer><silent> <C-f> :call lsp#scroll(+4)<CR>
    nnoremap <buffer><silent> <C-b> :call lsp#scroll(-4)<CR>

    " Diagnostics
    nmap <buffer><silent> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer><silent> [g <plug>(lsp-previous-diagnostic)
    nnoremap <buffer><silent> <F11> :call <SID>lsp_diagnostic_toggle()<CR>


    " Code Actions
    nmap <buffer><silent> <leader>rn <plug>(lsp-rename)
    nmap <buffer><silent> <leader>qf <plug>(lsp-code-action)
    nmap <buffer><silent> <leader>ac <plug>(lsp-code-action)

    " Hover
    nnoremap <buffer><silent> K :LspHover<CR>


    " Completion
    inoremap <buffer><expr> <Tab> pumvisible() ? "\<C-y>" : "\<Tab>"
    inoremap <buffer><expr> <S-Tab> pumvisible() ? "\<C-y>" : "\<S-Tab>"
    inoremap <buffer><expr> <cr> pumvisible() ? asyncomplete#close_popup() : "\<cr>"
    inoremap <buffer><expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-x>\<C-o>"

    " Format
    nnoremap <buffer><silent> <A-f> :call <SID>format_current_buffer()<CR>
    inoremap <buffer><silent> <A-f> <C-o>:call <SID>format_current_buffer()<CR>


endfunction

function! s:InitializeGlobal() abort
    let g:lsp_semantic_enabled = 1
    let g:lsp_diagnostics_virtual_text_align = "right"

    " NOTE: (2026/01/17) -> Currently, some hack is required to toggle `A>` sign.
    let g:lsp_document_code_action_signs_enabled = 0
    set shortmess+=c

    augroup LspBufferConfig
        autocmd!
        autocmd User lsp_buffer_enabled call s:InitializeLspBuffer()
    augroup END
endfunction

call s:InitializeGlobal()


