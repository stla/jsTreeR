library(shiny)
library(jsTreeR)
library(shinyAce)

# binary files extensions (we don't want to open these files)
binaryExtensions <- c(
  "3dm", "3ds", "3g2", "3gp", "7z", "a", "aac", "adp",
  "ai", "aif", "aiff", "alz", "ape", "apk", "appimage", "ar",
  "arj", "asf", "au", "avi", "bak", "baml", "bh", "bin",
  "bk", "bmp", "btif", "bz2", "bzip2", "cab", "caf", "cgm",
  "class", "cmx", "cpio", "cr2", "cur", "dat", "dcm", "deb",
  "dex", "djvu", "dll", "dmg", "dng", "doc", "docm", "docx",
  "dot", "dotm", "dra", "DS_Store", "dsk", "dts", "dtshd", "dvb",
  "dwg", "dxf", "ecelp4800", "ecelp7470", "ecelp9600", "egg", "eol", "eot",
  "epub", "exe", "f4v", "fbs", "fh", "fla", "flac", "flatpak",
  "fli", "flv", "fpx", "fst", "fvt", "g3", "gh", "gif",
  "graffle", "gz", "gzip", "h261", "h263", "h264", "icns", "ico",
  "ief", "img", "ipa", "iso", "jar", "jpeg", "jpg", "jpgv",
  "jpm", "jxr", "key", "ktx", "lha", "lib", "lvp", "lz",
  "lzh", "lzma", "lzo", "m3u", "m4a", "m4v", "mar", "mdi",
  "mht", "mid", "midi", "mj2", "mka", "mkv", "mmr", "mng",
  "mobi", "mov", "movie", "mp3", "mp4", "mp4a", "mpeg", "mpg",
  "mpga", "mxu", "nef", "npx", "numbers", "nupkg", "o", "oga",
  "ogg", "ogv", "otf", "pages", "pbm", "pcx", "pdb", "pdf",
  "pea", "pgm", "pic", "png", "pnm", "pot", "potm", "potx",
  "ppa", "ppam", "ppm", "pps", "ppsm", "ppsx", "ppt", "pptm",
  "pptx", "psd", "pya", "pyc", "pyo", "pyv", "qt", "rar",
  "ras", "raw", "resources", "rgb", "rip", "rlc", "rmf", "rmvb",
  "rpm", "rtf", "rz", "s3m", "s7z", "scpt", "sgi", "shar",
  "snap", "sil", "sketch", "slk", "smv", "snk", "so", "stl",
  "suo", "sub", "swf", "tar", "tbz", "tbz2", "tga", "tgz",
  "thmx", "tif", "tiff", "tlz", "ttc", "ttf", "txz", "udf",
  "uvh", "uvi", "uvm", "uvp", "uvs", "uvu", "viv", "vob",
  "war", "wav", "wax", "wbmp", "wdp", "weba", "webm", "webp",
  "whl", "wim", "wm", "wma", "wmv", "wmx", "woff", "woff2",
  "wrm", "wvx", "xbm", "xif", "xla", "xlam", "xls", "xlsb",
  "xlsm", "xlsx", "xlt", "xltm", "xltx", "xm", "xmind", "xpi",
  "xpm", "xwd", "xz", "z", "zip", "zipx"
)

# ace editor mode
aceMode <- function(filepath){
  ext <- tolower(tools::file_ext(filepath))
  if(ext %in% binaryExtensions){
    return(NULL)
  }
  switch(ext,
         c = "c_cpp",
         cpp = "c_cpp",
         "c++" = "c_cpp",
         dockerfile = "dockerfile",
         frag = "glsl",
         h = "c_cpp",
         hpp = "c_cpp",
         css = "css",
         f = "fortran",
         f90 = "fortran",
         gitignore = "gitignore",
         hs = "haskell",
         html = "html",
         java = "java",
         js = "javascript",
         jsx = "jsx",
         json = "json",
         jl = "julia",
         tex = "latex",
         md = "markdown",
         map = "json",
         markdown = "markdown",
         rmd = "markdown",
         mysql = "mysql",
         ml = "ocaml",
         perl = "perl",
         pl = "perl",
         php = "php",
         py = "python",
         r = "r",
         rd = "rdoc",
         rhtml = "rhtml",
         rnw = "latex",
         ru = "ruby",
         rs = "rust",
         scala = "scala",
         scss = "scss",
         sh = "sh",
         sql = "sql",
         svg = "svg",
         txt = "text",
         ts = "typescript",
         vb = "vbscript",
         xml = "xml",
         yaml = "yaml",
         yml = "yaml",
         "plain_text"
  )
}

# custom context menu
menuItems <- JS("function customMenu(node) {
  $treeNavigator = $('div[id^=\"explorer-\"]');
  var tree = $treeNavigator.jstree(true);
  var items = {
    'view' : {
      'label': 'View (files only)',
      'action': function (obj) {
        if(tree.is_leaf(node)) {
          var path = tree.get_path(node, '/');
          Shiny.setInputValue('path', path, {priority: 'event'});
        }
      },
      'icon': 'fas fa-eye'
    }
  };
  return items;
}")

ui <- fluidPage(
  h1("Right-click on a file to view it."),
  fluidRow(
    column(
      width = 12, treeNavigatorUI("explorer")
    )
  )
)

server <- function(input, output, session){

  Paths <- treeNavigatorServer(
    "explorer", rootFolder = getwd(),
    search = list( # (search in the visited folders only)
      show_only_matches  = TRUE,
      case_sensitive     = TRUE,
      search_leaves_only = TRUE
    ),
    contextMenu = list(items = menuItems, select_node = FALSE)
  )

  observeEvent(input[["path"]], {
    mode <- aceMode(input[["path"]])
    if(is.null(mode)){
      showModal(modalDialog(
        "Cannot open this file!",
        title = "Binary file",
        footer = NULL,
        easyClose = TRUE
      ))
    }else{
      contents <- paste0(suppressWarnings(
        readLines(input[["path"]])
      ), collapse = "\n")
      showModal(modalDialog(
        aceEditor(
          "aceEditor",
          value = contents,
          mode = mode,
          theme = "cobalt",
          tabSize = 2,
          height = "60vh"
        ),
        size = "l"
      ))
    }
  })

}

shinyApp(ui, server)
