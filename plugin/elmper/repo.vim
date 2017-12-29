function! elmper#repo#all_packages()
  if empty(get(s:, 'remote_packages'))
    let s:remote_packages = s:load_from_file(s:remote_packages_file())
  endif

  return s:remote_packages
endfunction

function! s:remote_packages_file()
  let l:dir = elmper#utils#plugin_dir()
  return l:dir . '/elm-remote-packages.json'
endfunction

function! s:load_from_file(file_name)
  return json_decode(readfile(a:file_name))
endfunction
