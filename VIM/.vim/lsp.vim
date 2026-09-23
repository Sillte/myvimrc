"================
" Utility functions
"================

function! s:lsp_diagnostic_toggle() abort
    let g:lsp_diagnostics_enabled = !get(g:, 'lsp_diagnostics_enabled', 1)
    if g:lsp_diagnostics_enabled == 0
        call lsp#disable_diagnostics_for_buffer()
    else
        call lsp#enable_diagnostics_for_buffer()
    endif
endfunction

command! -bar LspDiagnosticToggle call <SID>lsp_diagnostic_toggle()


function! s:format_current_buffer() abort
    if &filetype == 'markdown'
        if executable('prettier')
            let l:view = winsaveview()
            silent! execute "%!prettier --stdin-filepath %"
            call winrestview(l:view)
        endif
    elseif exists(':LspDocumentFormat')
        LspDocumentFormat
    endif
endfunction

"================
" Initialization (Buffer/Global)
"================

let g:lsp_settings_filetype_python = ['pyright-langserver']
let g:lsp_settings_filetype_markdown = ['marksman']

function! s:InitializeLspBuffer() abort
    " Diagnostics start hidden and are toggled for the current buffer with <F11>.
    call lsp#disable_diagnostics_for_buffer()
    
    setlocal omnifunc=lsp#complete

    " Navigation
    nmap <buffer><silent> gd <plug>(lsp-definition)
    nmap <buffer><silent> gD <plug>(lsp-declaration)
    nmap <buffer><silent> gy <plug>(lsp-type-definition)
    nmap <buffer><silent> gr <plug>(lsp-references)
    nnoremap <buffer><silent> <C-f> :call lsp#scroll(+4)<CR>
    nnoremap <buffer><silent> <C-b> :call lsp#scroll(-4)<CR>

    " Diagnostics
    nmap <buffer><silent> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer><silent> [g <plug>(lsp-previous-diagnostic)
    nnoremap <buffer><silent> ]e :LspNextError<CR>
    nnoremap <buffer><silent> [e :LspPreviousError<CR>
    nnoremap <buffer><silent> <leader>dd :LspDocumentDiagnostics<CR>
    nnoremap <buffer><silent> <F11> :LspDiagnosticToggle<CR>


    " Code Actions
    nmap <buffer><silent> <leader>rn <plug>(lsp-rename)
    nmap <buffer><silent> <leader>ac <plug>(lsp-code-action)

    " Hover
    nnoremap <buffer><silent> K :LspHover<CR>
    nnoremap <buffer><silent> <leader>ds :LspDocumentSymbol<CR>
    nnoremap <buffer><silent> <leader>ws :LspWorkspaceSymbol<CR>
    nnoremap <buffer><silent> <leader>st :LspStatus<CR>


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
    let g:lsp_diagnostics_enabled = 1

    " Keep diagnostics available to the per-buffer <F11> toggle.
    let g:lsp_document_code_action_signs_enabled = 0
    set shortmess+=c

    augroup LspBufferConfig
        autocmd!
        autocmd User lsp_buffer_enabled call s:InitializeLspBuffer()
    augroup END
endfunction

call s:InitializeGlobal()


