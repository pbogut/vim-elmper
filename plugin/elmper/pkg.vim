function! elmper#pkg#install(packages)
  if confirm("I'm going to install those packages:\n  " . join(a:packages, "\n  ") . "\nDo you want me to proceed?", "&Yes\n&No") == 1
    let l:root = elmper#utils#find_root('elm-package.json')
    for l:package in a:packages
      exec('!cd "' . l:root . '"; elm-package install "' . l:package . '" --yes')
    endfor
  endif
endfunction

function! elmper#pkg#install_missing()
  let l:root = elmper#utils#find_root('elm-package.json')
  if empty(l:root)
    echo "[elmper] Can't find Elm root folder, does elm-package.json exists?"
    return
  endif
  let l:candidates = s:get_potential_packages(s:get_missing_modules())
  let l:to_install = []
  for l:module in sort(keys(l:candidates), function('s:sort_candidates', [l:candidates]))
    let l:text = "Which package you want to use to provide '"
          \ . l:module . "' module"
    if elmper#utils#intersects(l:candidates[l:module], l:to_install)
      continue
    endif
    let l:costam = elmper#utils#select_element(l:text, l:candidates[l:module])
    if !empty(l:costam)
      call add(l:to_install, l:costam)
    endif
  endfor
  redraw
  if !empty(l:to_install)
    call elmper#pkg#install(l:to_install)
  else
    echo "[elmper] Nothing to install."
  endif
endfunction

function! s:get_potential_packages(modules)
  let candidates = {}
  for package in elmper#repo#all_packages()
    for missing_module in a:modules
      for module in package['modules']
        if missing_module == module
          let candidates[missing_module] = get(candidates, missing_module, [])
          call add(candidates[missing_module], package['name'])
        endif
      endfor
    endfor
  endfor
  return candidates
endfunction

function! s:get_potential_packages(modules)
  let candidates = {}
  for package in elmper#repo#all_packages()
    for missing_module in a:modules
      for module in package['modules']
        if missing_module == module
          let candidates[missing_module] = get(candidates, missing_module, [])
          call add(candidates[missing_module], package['name'])
        endif
      endfor
    endfor
  endfor
  return candidates
endfunction

function! s:get_missing_modules()
  let l:installed_modules = s:get_installed_modules()

  let l:missing_modules = []
  for line in getline('^', '$')
    if line =~ '^import [A-Z].*'
      let module = substitute(line, '^import \([A-Z][A-Za-z\.]*\).*$', '\1', '')
      if !elmper#utils#is_in_list(l:installed_modules, l:module)
        call add(l:missing_modules, l:module)
      endif
    endif
  endfor

  return l:missing_modules
endfunction

function! s:get_missing_modules()
  let l:installed_modules = s:get_installed_modules()

  let l:missing_modules = []
  for line in getline('^', '$')
    if line =~ '^import [A-Z].*'
      let module = substitute(line, '^import \([A-Z][A-Za-z\.]*\).*$', '\1', '')
      if !elmper#utils#is_in_list(l:installed_modules, l:module)
        call add(l:missing_modules, l:module)
      endif
    endif
  endfor

  return l:missing_modules
endfunction

function! s:get_installed_modules()
  let l:elmpackage = json_decode(readfile('elm-package.json'))

  let l:installed_packages = []
  for l:package in keys(l:elmpackage['dependencies'])
    for l:module in s:get_modules(l:package)
      call add(l:installed_packages , l:module)
    endfor
  endfor

  return l:installed_packages
endfunction

function! s:get_modules(name)
  for package in elmper#repo#all_packages()
    if package['name'] == a:name
      return package['modules']
    endif
  endfor
  return []
endfunction

function! s:sort_candidates(dict, elem1, elem2)
  let l:val1 = len(a:dict[a:elem1])
  let l:val2 = len(a:dict[a:elem2])
  return l:val1 == l:val2 ? 0 : l:val1 > l:val2 ? 1 : -1
endfunction

