#!/usr/bin/env python3
"""Step 4 spike: npm @yowasp/clang as classic scripts, for a page opened from
file://, where Chrome refuses ES modules and fetch (README, step 4).

    python3 -I repack-classic.py <@yowasp/clang gen/> <out dir>

writes
  clang.js       the package's bundle.js as a classic script: its fetch reads
                 window.YOWASP_DATA, and it sets window.YoWASPClang when ready
  clang-data.js  the WebAssembly and the resource archive, base64 (~100 MB)

A page loads `<script>window.YOWASP_DATA={}</script>`, clang-data.js, then
clang.js. The resource archive (30 MB in the package: a WASI C/C++ library
Simile never uses) is cut to the 17 clang headers Simile's models include;
compiled output is byte-identical with either.
"""
import base64, io, re, sys, tarfile

# clang's own headers that emcc reads for predator-prey and Trees (em++ -M).
USED = '''__stdarg___gnuc_va_list.h stdarg.h __stdarg_header_macro.h __stdarg_va_arg.h
__stdarg___va_copy.h __stdarg_va_copy.h __stdarg_va_list.h stddef.h __stddef_header_macro.h
__stddef_max_align_t.h __stddef_null.h __stddef_nullptr_t.h __stddef_offsetof.h
__stddef_ptrdiff_t.h __stddef_size_t.h __stddef_wchar_t.h stdint.h'''.split()


def small_tar(full):
    out = io.BytesIO()
    with tarfile.open(full) as src, tarfile.open(fileobj=out, mode='w', format=tarfile.USTAR_FORMAT) as dst:
        dst.addfile(src.getmember('include'))
        for name in USED:
            m = src.getmember('include/' + name)
            dst.addfile(m, src.extractfile(m))
    b = bytearray(out.getvalue())
    # The package's unpacker wants a folder named "include", not "include/"
    # as tarfile writes it: drop the slash and redo the header's checksum.
    assert b[0:8] == b'include/'
    b[7] = 0
    b[148:156] = b' ' * 8
    b[148:156] = ('%06o' % sum(b[:512])).encode() + b'\0 '
    return bytes(b)


def main(gen, out):
    src = open(gen + '/bundle.js').read()
    src = src.replace('fetch2 = globalThis.fetch;', '''fetch2 = async function(url) {
    const name = String(url).split("/").pop();
    const bytes = window.YOWASP_BYTES(name);
    return new Response(bytes, { headers: { "content-type": name.endsWith(".wasm") ? "application/wasm" : "application/octet-stream", "content-length": String(bytes.length) } });
  };''', 1)
    src = src.replace('import.meta.url', '"file:///yowasp/"')
    src, n = re.subn(r'export \{\s*Exit,\s*commands,\s*runClang,\s*runLLVM,\s*version\s*\};',
                     'window.YoWASPClang = { Exit, commands, runClang, runLLVM, version };', src)
    assert n == 1 and 'export {' not in src, 'bundle.js is not shaped as expected'
    with open(out + '/clang.js', 'w') as f:
        f.write('''// npm @yowasp/clang as a classic script (tools/engine/clang/repack-classic.py)
window.YOWASP_BYTES = function (name) {
  const s = window.YOWASP_DATA[name];
  if (typeof s !== "string") return s;
  const b = Uint8Array.fromBase64 ? Uint8Array.fromBase64(s) : Uint8Array.from(atob(s), (c) => c.charCodeAt(0));
  window.YOWASP_DATA[name] = b;
  return b;
};
(async function () {
''' + src + '\n})();\n')
    with open(out + '/clang-data.js', 'w') as f:
        for name in ('llvm.core.wasm', 'llvm.core2.wasm', 'llvm.core3.wasm', 'llvm.core4.wasm', 'llvm-resources.tar'):
            data = small_tar(gen + '/' + name) if name.endswith('.tar') else open(gen + '/' + name, 'rb').read()
            f.write('YOWASP_DATA[%r]="%s";\n' % (name, base64.b64encode(data).decode()))


if __name__ == '__main__':
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    main(*sys.argv[1:])
