let s:plugin_directory = expand('<sfile>:p:h:h:h')

function! elmper#utils#find_root(file)
  let l:path = expand('%:p:h')
  let l:last_path = ''
  while l:last_path != l:path
    if filereadable(l:path . '/' . a:file)
      return l:path
    endif
    let l:last_path = l:path
    let l:path = substitute(l:path, '/[^/]*$', '', '')
  endwhile
endfunction

function! elmper#utils#select_element(text, candidates)
  redraw
  if len(a:candidates) == 0
    return ''
  elseif len(a:candidates) == 1
    return a:candidates[0]
  endif

  let l:no = 1
  let l:candidates_display = [a:text]

  for l:candidate in a:candidates
    call add(l:candidates_display, l:no . ') ' . l:candidate)
    let l:no = l:no + 1
  endfor
  let l:selection = input(join(l:candidates_display, "\n") . "\nSelect: ", '')
  echo ''
  if l:selection >= 1 && l:selection <= len(a:candidates)
    return get(a:candidates, l:selection - 1, '')
  endif
endfunction

function! elmper#utils#intersects(list1, list2)
  for l:elem1 in a:list1
    for l:elem2 in a:list2
      if l:elem1 == l:elem2
        return v:true
      endif
    endfor
  endfor

  return v:false
endfunction

function! elmper#utils#is_in_list(list, elem)
  for l:name in a:list
    if l:name == a:elem
      return v:true
    endif
  endfor
  return v:false
endfunction

function! elmper#utils#plugin_dir()
  return s:plugin_directory
endfunction
